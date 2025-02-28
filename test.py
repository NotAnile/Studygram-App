import pytest
import app

@pytest.fixture()
def application():
    application = app.app
    application.config.update({
        "TESTING": True,
    })
    
    # Setting up the database
    db = app.db
    with application.app_context():
        # Create all tables
        db.create_all()
        yield application
        # Remove all tables and closes the session
        db.drop_all()
        db.session.close()


@pytest.fixture()
def client(application):
    return application.test_client()


@pytest.fixture()
def runner(application):
    return application.test_cli_runner()


def create_user_get_token(client, username, password):
    client.post('/user', json={'username': username, 'password': password})
    token = client.post('/user/login', json={'username': username, 'password': password}).json['token']
    return token

def test_create_user(client):
    response1 = client.post('/user', json={'username': 'Elina', 'password': '1234'})
    assert b"Welcome" in response1.data

    # Trying to create a user that already exists
    response2 = client.post('/user', json={'username': 'Elina', 'password': '1234'})
    assert b"UserId already taken" in response2.data

    # Trying to create a user without sending the right data
    response3 = client.post('/user', json={'userid': 'Elina', 'pass': '1234'})
    assert b'No username or password received!' in response3.data


def test_login(client):
    client.post('/user', json={'username': 'Elina', 'password': '1234'})
    response1 = client.post('/user/login', json={'username': 'Elina', 'password': '1234'})
    assert b"token" in response1.data
    
    # Trying to log in with wrong username
    response2 = client.post('/user/login', json={'username': 'Mahmoodi', 'password': '1234'})
    assert b'No such user or wrong password' in response2.data

    # Trying to log in with wrong password
    response3 = client.post('/user/login', json={'username': 'Elina', 'password': '4321'})
    assert b'No such user or wrong password' in response3.data

    # Trying to log in without sending the right data
    response4 = client.post('/user/login', json={'userid': 'Elina', 'password': '1234'})
    assert b'No such user or wrong password' in response4.data


def test_logout(client):
    token = create_user_get_token(client, "Elina", "1234")

    response1 = client.post('/user/logout', headers={'Authorization':'Bearer ' + token})
    assert b'You are now logged out' in response1.data

    # Trying to log out without being logged in
    response2 = client.post('/user/logout', headers={'Authorization':'Bearer ' + token})
    assert b'Token has been revoked' in response2.data
    assert response2.status_code == 401


def test_save_post(client):
    token = create_user_get_token(client, "Elina", "1234")

    post_list = ["Hej", "Hejsan", "Hi", "Hello"]
    for i in range(len(post_list)):
        response = client.post('/posts', json={"body": post_list[i]}, headers={'Authorization':'Bearer ' + token})
        assert str(i+1).encode() in response.data
        assert response.status_code == 200

    # Testing to create a post without a body
    response3 = client.post('/posts', json={}, headers={'Authorization':'Bearer ' + token})
    assert b"Post missing a message" in response3.data
    assert response3.status_code == 400


def test_get_post(client):
    # Creating a post
    token = create_user_get_token(client, "Elina", "1234")
    token2 = create_user_get_token(client, "Sarah", "4567")
    client.post('/posts', json={"body": "Hej"}, headers={'Authorization':'Bearer ' + token})

    response1 = client.get('/posts/1')
    assert b"1" in response1.data
    assert b"Hej" in response1.data
    assert b"[]" in response1.data

    # Testing with a post id that doesn't exist
    response2 = client.get('/posts/15')
    assert b"Invalid post ID" in response2.data
    assert response2.status_code == 400

    # Testing the liked_by list
    client.post('/posts/like/1', headers={'Authorization':'Bearer ' + token})
    response3 = client.get('/posts/1')
    assert "Elina" in response3.json["likedBy"]

    client.post('/posts/like/1', headers={'Authorization':'Bearer ' + token2})
    response4 = client.get('/posts/1')
    assert ["Elina", "Sarah"] == response4.json["likedBy"]


def test_delete_message(client):
    token = create_user_get_token(client, "Elina", "1234")
    token2 = create_user_get_token(client, "Sarah", "4567")

    client.post('/posts', json={"body": "Hej"}, headers={'Authorization':'Bearer ' + token})

    # Testing to delete a post with a user that does not own it
    response1 = client.delete('/posts/delete/1', headers={'Authorization':'Bearer ' + token2})
    assert b'Permission denied: User does not own the post' in response1.data
    assert response1.status_code == 400

    # Testing to delete a post
    response2 = client.delete('/posts/delete/1', headers={'Authorization':'Bearer ' + token})
    assert b"Post deleted" in response2.data
    assert response2.status_code == 200

    # Testing to delete a post with a post id that doesn't exist
    response3 = client.delete('/posts/delete/40', headers={'Authorization':'Bearer ' + token})
    assert b"Invalid post ID" in response3.data
    assert response3.status_code == 400


def test_like_post(client):
    # Creating a user and getting the token
    token = create_user_get_token(client, "Elina", "1234")
    # Creating a post
    client.post('/posts', json={"body": "Hej"}, headers={'Authorization':'Bearer ' + token})
    
    # Liking a post
    response1 = client.post('/posts/like/1', headers={'Authorization':'Bearer ' + token})
    assert b"Post liked" in response1.data
    assert response1.status_code == 200

    # Testing to like the same post again
    response2 = client.post('/posts/like/1', headers={'Authorization':'Bearer ' + token})
    assert b"Post already liked" in response2.data
    assert response2.status_code == 200

    # Testing to like a post that doesn't exist
    response3 = client.post('/posts/like/100', headers={'Authorization':'Bearer ' + token})
    assert b"Invalid post ID" in response3.data
    assert response3.status_code == 404


def test_get_all_posts(client):
    # Creating a user and getting the token
    token = create_user_get_token(client, "Elina", "1234")
    token2 = create_user_get_token(client, "Sarah", "4567")

    # Testing to get all posts when none are saved
    response1 = client.get('/posts')
    assert b"[]" in response1.data

    # Creating multiple posts
    message_list = ["Hej", "Hejsan", "Hello"]
    for i in range(len(message_list)):
        client.post('/posts', json={"body": message_list[i]}, headers={'Authorization':'Bearer ' + token})


    # Making one post have a single like
    client.post('/posts/like/1', headers={'Authorization':'Bearer ' + token})
    # Making a post that has two likes
    client.post('/posts/like/2', headers={'Authorization':'Bearer ' + token})
    client.post('/posts/like/2', headers={'Authorization':'Bearer ' + token2})

    # Testing get_all_messages
    response2 = client.get('/posts')
    for i in range(len(response2.json)):
        json_dict = response2.json[i]
        assert json_dict["id"] == i + 1
        assert json_dict["body"] == message_list[i]

def test_startsession(client):
    token = create_user_get_token(client, "Elina", "1234")

    response1 = client.post('/session/start', headers={'Authorization':'Bearer ' + token})
    json_data = response1.json
    assert json_data['message'] == 'Timer has been started' 

    
def test_endsession(client):
    # Starting a session
    token = create_user_get_token(client, "Elina", "1234")
    response = client.post('/session/start', headers={'Authorization':'Bearer ' + token})
    sessionid = response.json['id']

    # Testing to end a session
    response1 = client.post('/session/end', json = {'id': sessionid}, headers={'Authorization':'Bearer ' + token})
    assert response1.json['message'] == 'Session has ended'
    
    # Testing to end a session with an invalid session id
    response2 = client.post('/session/end', json = {'id':5}, headers={'Authorization':'Bearer ' + token})
    assert b'Session does not exist' in response2.data
    assert response2.status_code == 404

    # Testing to end a session without sending in the session id
    response3 = client.post('/session/end', json = {'dfghn':234}, headers={'Authorization':'Bearer ' + token})
    assert b'Session id missing' in response3.data
    assert response3.status_code == 404
