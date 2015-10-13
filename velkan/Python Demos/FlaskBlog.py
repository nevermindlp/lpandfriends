import json
from functools import wraps
from flask import Flask, Response, request, current_app

app = Flask(__name__)

comments = [{"author": "Chris Wang", "text": "This is one comment"},
                {"author": "Velkan Xu", "text": "This is *another* comment"}]

@app.route('/')
def index():
    if 'name' in request.args:
        return 'Hello ' + request.args['name'] + '~'
    else:
        return 'Hello John Doe!'

@app.route('/hello')
def hello_world():
    return 'Hello World!'

def jsonp_support(func):
    @wraps(func)
    def decorated_function(*args, **kwargs):
        callback = request.args.get('callback', False)
        if callback:
            data = str(func(*args, **kwargs))
            content = str(callback) + '(' + data + ')'
            return current_app.response_class(content, mimetype='application/json')
        else:
            return func(*args, **kwargs)
    return decorated_function

@app.route('/comments.json', methods=['GET', 'POST'])
def get_comments():

    if request.method == 'POST':
        comments.append(request.form.to_dict())

    resp = Response(json.dumps(comments), mimetype='application/json')
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp


if __name__ == '__main__':
    app.run()
