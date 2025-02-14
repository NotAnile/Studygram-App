from flask import Flask, request, jsonify
from typing import List
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Column, Integer, select, insert, delete, engine
import os

app = Flask(__name__)
if 'AZURE_POSTGRESQL_CONNECTIONSTRING' in os.environ:
    conn = os.environ["AZURE_POSTGRESQL_CONNECTION"]
    values = dict (x.split('=') for x in conn.split(' '))
    user = values['user']
    host = values['host']
    database = values['dbname']
    password = values['password']
    db_uri = f'postgres+psycog2://{user}:{password}@{host}/{database}'
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    
else:
    db_path = os.path.join(os.path.dirname(__file__), 'app.db')
    db_uri = f'sqlite:///{db_path}'
    debug_flag = True

db = SQLAlchemy()
db.init_app(app)

read_by = db.Table(
    "ReadBy",
    db.Column('user_id', Integer, ForeignKey('user.id'), primary_key=True),
    db.Column('message_id', Integer, ForeignKey('message.id'), primary_key=True)
)

class User(db.Model):
    id: Mapped[str] = mapped_column(primary_key = True)
    # Secondary is the association table
    read_messages: Mapped[List['Message']] = relationship(secondary=read_by, back_populates = 'read_by')


class Message(db.Model):
    id: Mapped[int] = mapped_column(primary_key = True, autoincrement=True)
    message: Mapped[str]
    read_by: Mapped[List['User']] = relationship(secondary=read_by, back_populates = 'read_messages')


@app.route('/api/user/create/<UserId>', methods=['POST'])
def create_user(UserId):
    """Creates a user with the given UserId if the given id is unique"""
    # Checks if the user exists in the User column with filter  
    user = db.session.execute(db.select(User).filter_by(id=UserId)).scalar_one_or_none()
    if user is None:
        # Creates a new user
        user = User(id=UserId)
        db.session.add(user)
        db.session.commit()
        return jsonify({'message': 'Welcome, you have id %s' %(user.id)})
    return jsonify({'message': "UserId already taken"})


@app.route('/messages', methods=['POST'])
def save_message():
    """Saves the given json string message and returns a
    unique message id."""
    json_data = request.json

    # Gets all the data for storing the message
    if 'message' in json_data:
        message = json_data['message']

        # Ensures that the length of the message is not over 140 characters
        if len(message) > 140:
            return 'Message length is over 140 characters', 400
        # Saves the message and its id in the database
        msg = Message(message=message)
        db.session.add(msg)
        db.session.commit()

        return jsonify({'id': msg.id}), 200
    else:
        return 'Missing a message', 400


@app.route('/messages/<MessageID>', methods=['GET'])
def get_message(MessageID):
    """Returns a json with the given messageID, message and a list of users that has read the message"""
    msg = db.session.execute(db.select(Message).filter_by(id=MessageID)).scalar_one_or_none()
    if msg is not None:
        message = db.session.execute(db.select(Message).filter_by(id=MessageID)).scalar_one_or_none().message
        users = db.session.execute(select(read_by.c.message_id).where(read_by.c.message_id == MessageID)).scalars()
        read_by_list = [user.user_id for user in users]
        return jsonify({'id': MessageID, 'message': message, 'readBy': read_by_list}), 200
    else:
        return 'Invalid message ID', 400


@app.route('/messages/<MessageID>', methods=['DELETE'])
def delete_message(MessageID):
    """Deletes the MessageID from the read_by table if the id exists."""
    msg = db.session.execute(db.select(Message).filter_by(id=MessageID)).scalar_one_or_none()
    if msg is not None:
        db.session.delete(msg)
        # Deletes the given message id from the read by table
        db.session.execute(delete(read_by).where(read_by.c.message_id == MessageID))
        db.session.commit()
        return 'Message deleted', 200
    else:
        return 'Invalid message ID', 400 
        

@app.route('/messages/<MessageID>/read/<UserId>', methods=['POST'])
def read_message(MessageID, UserId):
    """Adds the MessageID and UserId to the read_by table if
    the MessageID is valid and the user hasn't already read it."""
    msg = db.session.execute(db.select(Message).filter_by(id=MessageID)).scalar_one_or_none()
    if msg is not None:
        # Check if the user exists or not and if they've read it 
        user = db.session.execute(db.select(User).filter_by(id=UserId)).scalar_one_or_none()
        read = db.session.execute(
            read_by.select().where(db.and_(read_by.columns.user_id == UserId, read_by.columns.message_id == MessageID))
        ).scalar_one_or_none()
        
        if (user is not None) and (read is None):
            # Adds the message to the users read messages
            db.session.execute(db.insert(read_by).values(user_id=UserId, message_id=MessageID))
            db.session.commit()

        elif user is None:
            return "No user found", 404
            
        return "", 200

    else:
        return 'Invalid message ID', 400 


@app.route('/messages', methods=['GET'])
def get_all_messages():
    """Returns a jsonified list of all the messages that a given user has read
    with the messageID, message and a list of all users that has read that message."""
    result = []

    message_generator = db.session.execute(db.select(Message)).scalars()
    for msg in message_generator:
        # Creating a list of all users that has read the message
        users = db.session.execute(select(read_by.c.user_id).where(read_by.c.message_id == msg.id)).scalars()
        read_by_list = list(users)
        # Adding a json of the message id, message and read by list to the result
        result.append({'id': msg.id, 'message': msg.message, 'readBy': read_by_list})
    
    return jsonify(result)


@app.route('/messages/unread/<UserId>', methods=['GET'])
def get_unread_messages(UserId):
    """Returns a jsonified list of all the messages that a given user has NOT read
    with the messageID, message and a list of users that HAS read that message."""
    result = []

    # Checks if the given userid already exists or not
    user = db.session.execute(db.select(User).filter_by(id=UserId)).scalar_one_or_none()
    if user is not None:
        # Gets a set with all the message_id's that the user has not read
        # Using a set because the select query can select duplicates of message_id's since the filter
        # is set to != UserId. 
        unread_messages = set(db.session.execute(select(read_by.c.message_id).where(read_by.c.user_id != UserId)).scalars())

    else:
        return 'User does not exist', 404

    for msg_id in unread_messages:
        message = db.session.execute(db.select(Message.message).filter_by(id=msg_id)).scalar_one_or_none()
        # Creating a list containing all the user ids that have read that message
        users = db.session.execute(select(read_by.c.user_id).where(read_by.c.message_id == msg_id)).scalars()
        read_by_list = list(users)

        result.append({'id': msg_id, 'message': message, 'readBy': read_by_list})

    return jsonify(result)


if __name__ == "__main__":
    app.debug = True
    app.run()
