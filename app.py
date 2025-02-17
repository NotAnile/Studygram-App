from flask import Flask, request, jsonify
from typing import List
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Column, Integer, select, insert, delete, engine
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt
import os
from datetime import timedelta

app = Flask(__name__)

bcrypt = Bcrypt(app)
file = open('.env', 'r')
app.config['JWT_SECRET_KEY'] = file.read()

#Making the token valid for 5 minutes before it expires
ACCESS_EXPIRES = timedelta(minutes = 5)
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = ACCESS_EXPIRES
jwt = JWTManager(app)

if 'AZURE_POSTGRESQL_CONNECTIONSTRING' in os.environ:
    conn = os.environ["AZURE_POSTGRESQL_CONNECTIONSTRING"]
    values = dict (x.split('=') for x in conn.split(' '))
    user = values['user']
    host = values['host']
    database = values['dbname']
    password = values['password']
    db_uri = f'postgres+psycopg2://{user}:{password}@{host}/{database}'
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    
else:
    db_path = os.path.join(os.path.dirname(__file__), 'app.db')
    db_uri = f'sqlite:///{db_path}'
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    debug_flag = True

db = SQLAlchemy()
db.init_app(app)

liked_by = db.Table(
    "LikedBy",
    db.Column('post_id', Integer, ForeignKey('post.id'), primary_key=True),
    db.Column('user_id', Integer, ForeignKey('user.id'), primary_key=True)
)

class User(db.Model):
    id: Mapped[str] = mapped_column(primary_key = True)
    password: Mapped[str] = mapped_column(nullable=False)
    # Secondary is the association table
    liked_posts: Mapped[List['Post']] = relationship(secondary=liked_by, back_populates = 'likes')
    posts: Mapped[List['Post']] = relationship(back_populates = 'owner')

    def __init__(self, id, password):
        self.id = id
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')

class Post(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    owner_id = Mapped[int] = mapped_column(db.ForeignKey("user.id"))
    owner: Mapped['User'] = relationship(back_populates = 'posts')
    body: Mapped[str]
    comments: Mapped[List['Comment']] = relationship(back_populates = 'post')
    likes: Mapped[List['User']] = relationship(secondary=liked_by, back_populates = 'liked_posts')

class Comment(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    post_id: Mapped[int] = mapped_column(db.ForeignKey("post.id"))
    post: Mapped['Post'] = relationship(back_populates='comments')
    owner: Mapped['User'] = mapped_column(nullable=False)
    message: Mapped[str]

class BlockedToken(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    jti: Mapped[str] = mapped_column(nullable=False)

    def __init__(self, jti):
        self.jti = jti



@app.route('/user', methods=['POST'])
def create_user():
    """Creates a user with the given UserId if the given id is unique"""
    # Checks if the user exists in the User column with filter  
    json_data = request.json

    if ('username' in json_data) and ('password' in json_data):
        username = json_data['username']
        password = json_data['password']

        user = db.session.execute(db.select(User).filter_by(id=username)).scalar_one_or_none()
        if user is None:
            # Creates a new user
            user = User(id=username, password=password)
            db.session.add(user)
            db.session.commit()
            return jsonify({'message': 'Welcome'}), 200
        
        return jsonify({'message': "UserId already taken"})

    else:
        return jsonify({'message':'No username or password received!'}), 400




@app.route('/user/login', methods=['POST'])
def do_login():
    json_data = request.json
    if ('username' in json_data) and ('password' in json_data):
        username = json_data['username']
        password = json_data['password']


        user = db.session.execute(db.select(User).filter_by(id = username)).scalar_one_or_none()
        if user is None:
            return jsonify({'message':'No such user or wrong password'}), 400

        #bcrypt.check_password_hash kommer att hasha det inskickade lösenordet och sedan jämföra det
        if bcrypt.check_password_hash(user.password, password):
            token = create_access_token(identity = user.id)
            return jsonify({'token':token}), 200
        
    return jsonify({'message':'No such user or wrong password'}), 400


@app.route('/messages', methods=['POST'])
@jwt_required()
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
@jwt_required()
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
@jwt_required()
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
@jwt_required()
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


@app.route('/user/logout', methods = ['POST'])
@jwt_required()
def logout():
    jti = get_jwt()['jti']
    db.session.add(BlockedToken(jti=jti))
    db.session.commit()
    return jsonify({'message':'You are now logged out'}), 200
    

@jwt.token_in_blocklist_loader
def is_token_in_blocklist(jwt_header, jwt_payload: dict) -> bool:
    '''Filtering out the jti in the BlockedToken column to see if the jti is in there.
    If it exists, return True. Otherwise return False.'''
    jti = jwt_payload['jti']
    token = db.session.execute(db.select(BlockedToken.jti).filter_by(jti=jti)).scalar()
    return token is not None


if __name__ == "__main__":
    app.debug = True
    app.run(port=5003)
