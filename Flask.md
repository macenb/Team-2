Example code:
```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
	return "<p>Hello, World!</p>"

if __name__ == "__main__":
	app.run(debug=True, host='0.0.0.0', port=1337, threaded=True)
```
`pip install flask`
debug on is BAD in production

You can use any valid HTTP endpoint, and you can even have variable paths:
```python
@app.route('api/botnet-orders/<int:order_id>', methods=['GET'])
@token_required # runs token required before the function runs
def get_botnet_order(session_data, order_id):
	# code stuff
```

You can also have functions run before and after every request:
```python
from flask import Flask

app = Flask(__name__)
@app.before_request
def before_request_func():
	print("before_request executing")

@app.after_request
def after_request_func(response):
	print("after_request executing")
	return response

@app.route("/")
def index():
	print("Index running!")

if __name__ == "__main__":
	app.run()
```

Also blueprints for scaling
```Python
## main server.py file
from flask import Flask
from example_blueprint import example_blueprint

app = Flask(__name__)
app.register_blueprint(example_blueprint) #


### example_blueprint.py in the same 
from flask import Blueprint

example_blueprint = Blueprint('example_blueprint', __name__)

@example_blueprint.route('/')
def index():
	return "This is an example app"
```

Requests and responses
```python
@app.route('/getpost', methods=['GET'])
def getpost():
	postid = request.args["id"]

@app.route('/flag', methods=['POST'])
def main():
	resp = make_response("Nope")
	resp.status_code = 401
```

### Flask + SQL
Flask usually uses SQLite, which is literally just a file with the whole database inside of it
You make the connection using a local file path, then pull off a cursor and use that cursor to run commands. Once you've run the commands, you can then commit with the connection object itself
```python
conn = sqlite3.connect('local.db')
cur = conn.cursor()
cur.execute('CREATE TABLE ...')
conn.commit()
cur.execute('SELECT * FROM table;')
rows = cur.fetchall()
```

Prevent sql injection using a two-parameter statement with a tuple with arguments
```python
### VULNERABLE
db.exec('SELECT * FROM users WHERE userId='+input_id+';')
db.exec('SELECT * FROM users WHERE userId={input_id};')
db.exec('SELECT * FROM users WHERE userId=%s;' % input_id)

# SAFE
db.exec('SELECT * FROM users WHERE userId=%s;', (input_id,))
```

Templating with Jinja2 is default safe from XSS *unless* it injects user given information like 
```python
{{ var_name | safe}}
```
which marks the input as 
Vulnerabilities here include `render_template_string(user_input)` and any render using a file they have write access to

Check POST parameters with Python's `isinstance(var, str)` to check data type before it's used or weird things can happen (specific to JSON). `request.form` is always a string though
Flask has cookies by default and with the import of `session`. They use JSON usually (starts with `eyJ`, which is b64 for JSON data), which is b64 encoded json data plus two period-separated signatures. JWT is similar but uses 2 b64 json fields and 1 signature. If the application uses the line
```python
app.secret_key = "somekey"
```
if the key is guessable, hardcoded, or known, you want to change it

HackTricks JWT article

`os.path.join` is vulnerable lol
Deserialization is great, but when you deserialize a Python `pickle` object, it can just straight up run code. If user data is being passed into `pickle.loads()` then you need to drop it.

SSRF will always be using the `import requests` library