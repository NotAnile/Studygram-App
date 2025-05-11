from flask import Flask, request, jsonify
from typing import List
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey, Integer, String, delete, select
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt, get_jwt_identity, create_refresh_token
import os
from datetime import timedelta, datetime, date
from dotenv import dotenv_values

app = Flask(__name__)

bcrypt = Bcrypt(app)
# Configuring the jwt secret key by getting the secret key from the .env file
app.config['JWT_SECRET_KEY'] = dotenv_values(".env")["SECRET_KEY"]

#Making the token valid for 15 minutes before it expires
ACCESS_EXPIRES = timedelta(minutes = 15)
REFRESH_EXPIRES = timedelta(days=7)
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = ACCESS_EXPIRES
app.config['JWT_REFRESH_TOKEN_EXPIRES'] = REFRESH_EXPIRES
jwt = JWTManager(app)

# Configuring the database uri depending on 
if 'AZURE_POSTGRESQL_CONNECTIONSTRING' in os.environ:
    conn = os.environ["AZURE_POSTGRESQL_CONNECTIONSTRING"]
    values = dict (x.split('=') for x in conn.split(' '))
    user = values['user']
    host = values['host']
    database = values['dbname']
    password = values['password']
    db_uri = f'postgresql+psycopg2://{user}:{password}@{host}/{database}'
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    
else:
    db_path = os.path.join(os.path.dirname(__file__), 'app.db')
    db_uri = f'sqlite:///{db_path}'
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    debug_flag = True

db = SQLAlchemy()
db.init_app(app)

# Association table for friends
friends = db.Table("Friends", 
    db.Column('user_id', String, ForeignKey('user.id'), primary_key=True), 
    db.Column('friend_id', String, ForeignKey('user.id'), primary_key=True))

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
    sessions: Mapped[List['Session']] = relationship(back_populates = 'user')
    following: Mapped[List['User']] = relationship(
        secondary=friends, 
        primaryjoin=id==friends.c.user_id, 
        secondaryjoin=id==friends.c.friend_id, 
        backref='followers'  # Followers are all the users who have you in their following list
    )

    def __init__(self, id, password):
        self.id = id
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')
    
    def setPassword(self, password):
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')

    
    def mutual_friends(self):
        """Returns a list of all usernames of the user's mutual friends"""
        return [user.id for user in self.following if user in self.followers]


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


class Session(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement = True)
    starttime: Mapped[datetime]
    endtime: Mapped[datetime]
    duration: Mapped[timedelta]
    startdate: Mapped[date]
    user_id: Mapped[int] = mapped_column(db.ForeignKey("user.id"))
    user: Mapped['User'] = relationship(back_populates = 'sessions')
    subject: Mapped[str]
    description: Mapped[str]

    def __init__(self, starttime, user_id, subject, description):
        self.user_id = user_id
        self.starttime = starttime
        self.startdate = starttime.date()
        self.subject = subject
        self.description = description
        self.endtime = starttime
        self.duration = starttime - starttime
    
    def setendtime(self, endtime):
        self.endtime = endtime
        self.duration = endtime - self.starttime

class BlockedToken(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    jti: Mapped[str] = mapped_column(nullable=False)

    def __init__(self, jti):
        self.jti = jti

with app.app_context():
    db.create_all()


def user_exists(user_id) -> bool:
    """Checks if the given user id exists in the database"""
    user = db.session.execute(db.select(User).filter_by(id=user_id)).scalar_one_or_none()
    return user is not None


def post_exists(post_id) -> bool:
    """Checks if the given post id exists in the database"""
    post = db.session.execute(db.select(Post).filter_by(id=post_id)).scalar_one_or_none()
    return post is not None


def data_exist(datalist:List[str], jsondict: dict) -> bool:
    """Returns true iff all data in the given datalist exists in the given jsondict."""
    for data in datalist:
        if not data in jsondict:
            return False
    return True


def get_data(key: str, dict: dict) -> str:
    """Returns the value if the given key exists in the given dict, else it will return an empty string"""
    if key in dict:
        return dict[key]
    return ''


@app.route('/user', methods=['POST'])
def create_user():
    """Creates a user with the given UserId if the given id is unique"""
    # Checks if the user exists in the User column with filter  
    json_data = request.json

    if data_exist(['username', 'password'], json_data):
        username = json_data['username']
        password = json_data['password']

        # Checks if there already exists a user with that username
        existing_user = db.session.get(User, username)
        if existing_user is None:
            # Creates a new user
            user = User(id=username, password=password)
            db.session.add(user)
            db.session.commit()
            return jsonify({'message': 'Welcome'}), 200
        
        return jsonify({'message': "Username already taken"}), 403

    else:
        return jsonify({'message':'No username or password received!'}), 400


@app.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    username = get_jwt_identity()
    new_access_token = create_access_token(identity=username)
    return jsonify(access_token=new_access_token)


@app.route('/user/login', methods=['POST'])
def do_login():
    json_data = request.json
    if data_exist(['username', 'password'], json_data):
        username = json_data['username']
        password = json_data['password']

        user = db.session.get(User, username)
        if user is None:
            return jsonify({'message':'No such user or wrong password'}), 400

        #bcrypt.check_password_hash hashes the given password and compares it
        if bcrypt.check_password_hash(user.password, password):
            access_token = create_access_token(identity=user.id)
            refresh_token = create_refresh_token(identity=user.id)
            return jsonify(access_token=access_token, refresh_token=refresh_token), 200
        
    return jsonify({'message':'No such user or wrong password'}), 400


@app.route('/user/change/password', methods=['POST'])
@jwt_required()
def change_password():
    username = get_jwt_identity()
    json_data = request.json
    if data_exist(['password'], json_data):
        password = json_data['password']

        user = db.session.get(User, username)
        if user is None:
            return jsonify({'message':'No such user'}), 400

        # Setting the new password
        user.setPassword(password)
        return jsonify({'message': 'Password has been updated'}), 200
        
    return jsonify({'message':'No password given'}), 400


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
        
        user = db.session.get(User, user_id)
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
    post = db.session.get(Post, PostID)

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


@app.route('/post/<PostID>', methods=['GET'])
def get_post(PostID):
    """Returns a json with the given postID, body, and a list of
    users that has liked the message and the amount of likes."""

    if post_exists(PostID):
        post = db.session.get(Post, PostID)
        # Gets the body and users that have liked the post
        message = post.body
        users = post.likes 
        # Gets the amount of likes  on a post
        liked_by_list = [user.id for user in users]
        
        likes = len(liked_by_list)
        return jsonify({'id': PostID, 'body': message, 'likedBy': liked_by_list, 'likes': likes}), 200
    else:
        return 'Invalid post ID', 400


@app.route('/posts/delete/<PostID>', methods=['DELETE'])
@jwt_required()
def delete_post(PostID):
    """Deletes the post if the id exists."""
    # Checks that the user exists
    user_id = get_jwt_identity()
    if not user_exists(user_id):
        return "User does not exist", 404

    post = db.session.get(Post, PostID)
    user = db.session.get(User, user_id)

    if post is not None and post.user_id == user.id:
        # Removes the comments
        comments = post.comments
        for comment in comments:
            db.session.delete(comment)
            
        # Removes the post from the users posts
        user.posts.remove(post)
        # Removes the post
        db.session.delete(post)
        # Deletes the likes given to the deleted post
        db.session.execute(delete(liked_by).where(liked_by.c.post_id == PostID))    # Fråga: Behövs detta eller tas likes-raderna bort automatiskt när man tar bort Post?
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
    user_id = get_jwt_identity()
    if not user_exists(user_id):
        return "User does not exist", 404

    comment = db.session.get(Comment, CommentID)

    if comment is not None and comment.user_id == user_id:
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
        post = db.session.get(Post, PostID)
        # Gets the user object for the given user id
        user_id = get_jwt_identity()
        if user_exists(user_id):
            user = db.session.get(User, user_id)
        else:
            "No user found", 404 
        
        # Checks if the user has already liked it
        if user in post.likes:
            return "Post already liked", 200

        # Adds the user and post to the likes list 
        post.likes.append(user)
        db.session.commit()
        return "Post liked", 200
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

    post = db.session.get(Post, PostID)

    if post is not None:
        for comment in post.comments:
            # Creating a list of all the comments in the post
            result.append({'id': comment.id, 'message': comment.message, 'username': comment.user_id})
    
        return jsonify(result)

    else:
        return "Post does not exist", 404





@app.route('/profile/<UserID>', methods=['GET'])
def get_user_profile(UserID):
    """Returns a jsonified dict of the user's posts (id, body, username and comment), amount of posts, 
    amount of friends, and friends (usernames of all mutual friends)."""

    def get_user_posts():
        """Returns a list of all the posts created by the given user."""
        result = []

        post_generator = db.session.execute(db.select(Post).filter_by(user_id=UserID)).scalars().all()
        for post in post_generator:
            # Creating a list with comments of the post in the form of a dictionary
            comments = []
            for comment in post.comments:
                comments.append({'id': comment.id, 'message': comment.message, 'username': comment.user_id})
            
            # Creating a list of all the posts the user has created
            result.append({'id': post.id, 'body': post.body, 'username': UserID, 'comments': comments})
        
        return result
    
    # Checks if the user exists
    if user_exists(UserID):
        posts = get_user_posts()
        user = db.session.get(User, UserID)
        mutual_friends = user.mutual_friends()

        friend_requests = db.session.execute(
            select(User)
            .join(friends, User.id == friends.c.user_id) # Joins each row in User with rows in the friends table 
                                                         # where that user was the one who sent the request.
            .where(friends.c.friend_id == UserID)  # They follow UserID
            .where(~User.id.in_(mutual_friends))  # But not mutual
        ).scalars().all()

        return jsonify({'username': UserID, 'posts': posts, 'post_count': len(posts), 'friends': mutual_friends, 'friend_count': len(mutual_friends), 'friend_requests': friend_requests})
    else:
        return "User does not exist", 404
    

@app.route('/session/start', methods = ['POST'])
@jwt_required()
def startsession():
    """Creates a session object by getting the current time and date."""
    user_id = get_jwt_identity()

    if user_exists(user_id):
        # Getting the subject and description if the user sent one
        json_data = request.json
        subject = get_data('subject', json_data)
        description = get_data('description', json_data)

        session = Session(starttime=datetime.now(), user_id=user_id, subject=subject, description=description)
        db.session.add(session)
        db.session.commit()
        return jsonify({'message':'Timer has been started', 'id': session.id, 'subject': session.subject})

    else:
        return 'User does not exist', 404


@app.route('/session/add', methods = ['POST'])
@jwt_required()
def addsession():
    """Adds a session manually by setting the start and end time """
    user_id = get_jwt_identity()
    if not user_exists(user_id):
        return "User does not exist", 404
    
    json_data = request.json
    if data_exist(['startdate', 'starttime', 'enddate', 'endtime'], json_data):
        startdate = json_data['startdate']
        starttime = json_data['starttime']
        enddate = json_data['enddate']
        endtime = json_data['endtime']
        # Getting the start and endtime as datetime objects
        starttime = datetime.strptime(startdate + " " + starttime + ":00", '%d/%m/%y %H:%M:%S')
        endtime = datetime.strptime(enddate + " " + endtime + ":00", '%d/%m/%y %H:%M:%S')
        # Getting the subject and description if the user sent one
        subject = get_data('subject', json_data)
        description = get_data('description', json_data)

        session = Session(starttime=starttime, subject=subject, user_id=user_id, description=description)
        session.setendtime(endtime=endtime)
        db.session.add(session)
        db.session.commit()

        return jsonify({'message':'Session has been added', 'id':session.id})
    
    else:
        return 'Missing startdate, starttime, enddate, or endtime', 400



@app.route('/session/end', methods = ['POST'])
@jwt_required()
def endsession():
    """Takes in the id of the session they want to end as a json and ends that session"""

    user_id = get_jwt_identity()
    if not user_exists(user_id):
        return 'User does not exist', 404
    
    json_data = request.json
    if 'id' in json_data:
        # Getting the session that we want to end
        sessionid = json_data['id']
        session = db.session.get(Session, sessionid)
        
        if session is not None:
            # Checks that the owner of the session is the logged in user
            if session.user.id != user_id:
                return 'Permission denied: User does not own session', 400
            
            # Updates the endtime and duration of the session
            session.setendtime(endtime=datetime.now())
            db.session.commit()

            return jsonify({'message':'Session has ended', 'duration': str(session.duration)})
        else:
            return 'Session does not exist', 404

    else:
        return 'Session id missing', 404


@app.route('/user/logout', methods = ['POST'])
@jwt_required()
def logout():
    jti = get_jwt()['jti']
    db.session.add(BlockedToken(jti=jti))
    db.session.commit()
    return jsonify({'message':'You are now logged out'}), 200
    

@app.route('/expiredtoken', methods = ['POST'])
@jwt.token_in_blocklist_loader
def is_token_in_blocklist(jwt_header, jwt_payload: dict) -> bool:
    '''Filtering out the jti in the BlockedToken column to see if the jti is in there.
    If it exists, return True. Otherwise return False.'''
    jti = jwt_payload['jti']
    token = db.session.execute(db.select(BlockedToken.jti).filter_by(jti=jti)).scalar()
    return token is not None


if __name__ == "__main__":
    app.debug = True
    app.run(port=5000)
