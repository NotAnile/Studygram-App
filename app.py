from flask import Flask, request, jsonify
from typing import List
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Column, Integer, select, insert, delete, engine
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt, get_jwt_identity
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
    posts: Mapped[List['Post']] = relationship(back_populates = 'user')
    comments: Mapped[List['Comment']] = relationship(back_populates = 'user')

    def __init__(self, id, password):
        self.id = id
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')


class Post(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(db.ForeignKey("user.id"))
    user: Mapped['User'] = relationship(back_populates = 'posts')
    body: Mapped[str]
    comments: Mapped[List['Comment']] = relationship(back_populates = 'post')
    likes: Mapped[List['User']] = relationship(secondary=liked_by, back_populates = 'liked_posts')


class Comment(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    post_id: Mapped[int] = mapped_column(db.ForeignKey("post.id"))
    post: Mapped['Post'] = relationship(back_populates='comments')
    user_id: Mapped[int] = mapped_column(db.ForeignKey("user.id"))
    user: Mapped['User'] = relationship(back_populates = 'comments')
    message: Mapped[str]


class BlockedToken(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    jti: Mapped[str] = mapped_column(nullable=False)

    def __init__(self, jti):
        self.jti = jti


def user_exists(user_id) -> bool:
    """Checks if the given user id exists in the database"""
    user = db.session.execute(db.select(User).filter_by(id=user_id)).scalar_one_or_none()
    return user is not None

def post_exists(post_id) -> bool:
    """Checks if the given post id exists in the database"""
    post = db.session.execute(db.select(Post).filter_by(id=post_id)).scalar_one_or_none()
    return post is not None


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

        #bcrypt.check_password_hash hashes the given password and compares it
        if bcrypt.check_password_hash(user.password, password):
            token = create_access_token(identity = user.id)
            return jsonify({'token':token}), 200
        
    return jsonify({'message':'No such user or wrong password'}), 400


@app.route('/posts', methods=['POST'])
@jwt_required()
def save_post():
    """Saves the given json string message and returns a
    unique message id."""
    user_id = get_jwt_identity()
    json_data = request.json

    # Gets all the data for storing the message
    if 'body' in json_data:
        message = json_data['body']

        # Ensures that the length of the message is not over 500 characters
        if len(message) > 500:
            return 'Message length is over 500 characters', 400

        # Checks if the given userid already exists or not
        if not user_exists(user_id):
            return f'The user {user_id} does not exist', 404
        
        user = db.session.execute(db.select(User).filter_by(id = user_id)).scalar_one_or_none()
        # Saves the post and its owner's id in the database
        new_post = Post(user_id=user_id, body=message, comments=[], likes=[])
        user.posts.append(new_post)
        db.session.add(new_post)
        db.session.commit()

        return jsonify({'id': new_post.id}), 200
    else:
        return 'Post missing a message', 400


@app.route('/posts/comment/<PostID>', methods=['POST'])
@jwt_required()
def save_comment(PostID):
    """Saves the given json string message and returns a
    unique comment id."""

    # Checks if the given userid already exists or not
    user_id = get_jwt_identity()
    if not user_exists(user_id):
        return f'The user {user_id} does not exist', 404
    
    # Checks if the given post exists or not
    if not post_exists(PostID):
        return 'Post does not exist', 404
    
    json_data = request.json
    post = db.session.execute(db.select(Post).filter_by(id=PostID)).scalar_one_or_none()

    # Gets all the data for storing the message
    if 'message' in json_data:
        message = json_data['message']

        # Ensures that the length of the message is not over 300 characters
        if len(message) > 300:
            return 'Message length is over 300 characters', 400

        # Saves the post and its owner's id in the database
        comment = Comment(user_id=user_id, post=post, message=message)
        db.session.add(comment)
        db.session.commit()

        return jsonify({'id': comment.id}), 200
    else:
        return 'Comment missing a message', 400


@app.route('/posts/<PostID>', methods=['GET'])
def get_post(PostID):
    """Returns a json with the given postID, body, and a list of
    users that has liked the message and the amount of likes."""

    if post_exists(PostID):
        message = db.session.execute(db.select(Post).filter_by(id=PostID)).scalar_one_or_none().body
        users = db.session.execute(select(liked_by.c.user_id).where(liked_by.c.post_id == PostID)).scalars()
        
        # Gets the amount of likes  on a post
        liked_by_list = [username for username in users]
        likes = len(liked_by_list)
        return jsonify({'id': PostID, 'body': message, 'likedBy': liked_by_list, 'likes': likes}), 200
    else:
        return 'Invalid post ID', 400


@app.route('/posts/delete/<PostID>', methods=['DELETE'])
@jwt_required()
def delete_post(PostID):
    """Deletes the post if the id exists."""
    # Checks that the user exists
    if not user_exists(get_jwt_identity()):
        return "User does not exist", 404
    
    post = db.session.execute(db.select(Post).filter_by(id=PostID)).scalar_one_or_none()
    user = db.session.execute(db.select(User).filter_by(id=get_jwt_identity())).scalar_one_or_none()

    if post is not None and post.user_id == user.id:
        # Removes the comments
        comments_generator = db.session.execute(db.select(Comment).filter_by(post=post)).scalars()
        comments = [comment for comment in comments_generator]
        for comment in comments:
            db.session.delete(comment)
            
        # Removes the post from the users posts
        user.posts.remove(post)
        # Removes the post
        db.session.delete(post)
        # Deletes the likes given to the deleted post
        db.session.execute(delete(liked_by).where(liked_by.c.post_id == PostID))
        db.session.commit()
        return 'Post deleted', 200
    
    elif post is None:
        return 'Invalid post ID', 400 
    
    else:
        return 'Permission denied: User does not own the post', 400
        

@app.route('/posts/delete/<CommentID>', methods=['DELETE'])
@jwt_required()
def delete_comment(CommentID):
    """Deletes the comment if the id exists."""
    # Checks that the user exists
    if not user_exists(get_jwt_identity()):
        return "User does not exist", 404
    
    comment = db.session.execute(db.select(Comment).filter_by(id=CommentID)).scalar_one_or_none()
    if comment is not None and comment.user_id == user.id:
        # Removes the comment
        db.session.delete(comment)
        db.session.commit()
        return 'Comment deleted', 200
    else:
        return 'Invalid comment', 400 


@app.route('/posts/like/<PostID>', methods=['POST'])
@jwt_required()
def like_post(PostID):
    """Likes the post if the given post ID exists and if the logged in user is valid.
    If the user has already liked it, the database won't be changed and 200 will be returned."""

    if post_exists(PostID):
        # Check if the user exists or not and if they've already liked the post 
        user_id = get_jwt_identity()
        like = db.session.execute(
            liked_by.select().where(db.and_(liked_by.columns.user_id == user_id, liked_by.columns.post_id == PostID))
        ).scalar_one_or_none()
        
        if (user_exists(user_id)) and (like is None):
            # Adds the user and post to the liked_by table
            db.session.execute(db.insert(liked_by).values(user_id=user_id, post_id=PostID))
            db.session.commit()
            return "Post liked", 200

        elif not user_exists(user_id):
            return "No user found", 404 
            
        return "Post already liked", 200

    else:
        return 'Invalid post ID', 404


@app.route('/posts', methods=['GET'])
def get_all_posts():
    """Returns a jsonified list of all the posts."""
    result = []

    post_generator = db.session.execute(db.select(Post)).scalars()
    for post in post_generator:
        # Creating a list of all posts
        result.append({'id': post.id, 'body': post.body})
    
    return jsonify(result)


@app.route('/posts/<PostID>/comments', methods=['GET'])
def get_all_comments(PostID):
    """Returns a jsonified list of all the comments in a post."""
    result = []

    post = db.session.execute(db.select(Post).filter_by(id=PostID)).scalar_one_or_none()

    if post is not None:
        comment_generator = db.session.execute(db.select(Comment).filter_by(post=post)).scalars()
        for comment in comment_generator:
            # Creating a list of all the comments in the post
            result.append({'id': comment.id, 'message': comment.message})
    
        return jsonify(result)

    else:
        return "Post does not exist", 404


@app.route('/posts/<UserID>', methods=['GET'])
def get_user_posts(UserID):
    """Returns a jsonified list of all the posts created by the given user."""
    result = []

    # Checks if the user exists
    if user_exists(UserID):

        post_generator = db.session.execute(db.select(Post).filter_by(user_id=UserID)).scalars()
        for post in post_generator:
            # Creating a list of all the posts the user has created
            result.append({'id': post.id, 'body': post.body})
        
        return jsonify(result)

    else:
        return "User does not exist", 404


# @app.route('/messages/unread/<UserId>', methods=['GET'])
# @jwt_required()
# def get_unread_messages(UserId):
#     """Returns a jsonified list of all the messages that a given user has NOT read
#     with the messageID, message and a list of users that HAS read that message."""
#     result = []

#     # Checks if the given userid already exists or not
#     user = db.session.execute(db.select(User).filter_by(id=UserId)).scalar_one_or_none()
#     if user is not None:
#         # Gets a set with all the message_id's that the user has not read
#         # Using a set because the select query can select duplicates of message_id's since the filter
#         # is set to != UserId. 
#         unread_messages = set(db.session.execute(select(read_by.c.message_id).where(read_by.c.user_id != UserId)).scalars())

#     else:
#         return 'User does not exist', 404

#     for msg_id in unread_messages:
#         message = db.session.execute(db.select(Message.message).filter_by(id=msg_id)).scalar_one_or_none()
#         # Creating a list containing all the user ids that have read that message
#         users = db.session.execute(select(read_by.c.user_id).where(read_by.c.message_id == msg_id)).scalars()
#         read_by_list = list(users)

#         result.append({'id': msg_id, 'message': message, 'readBy': read_by_list})

#     return jsonify(result)


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
