from flask import Flask, render_template_string, request, redirect
from pymongo import MongoClient
import os

app = Flask(__name__)

# Fallback to local devcontainer service name if MONGO_URI environment variable isn't set
mongo_uri = os.environ.get("MONGO_URI", "mongodb://mongo-db:27017/")
client = MongoClient(mongo_uri)
db = client.blog_db
comments_collection = db.comments

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Simple Blog Comments</title>
    <style>body { font-family: sans-serif; max-width: 500px; margin: 40px auto; padding: 0 20px; }</style>
</head>
<body>
    <h2>Leave a Comment (Python + AKS Demo)</h2>
    <form method="POST" action="add">
        <input type="text" name="username" placeholder="Your Name" required style="width:100%; margin-bottom:10px; padding:8px;"><br>
        <textarea name="text" placeholder="Write a comment..." required style="width:100%; height:80px; margin-bottom:10px; padding:8px;"></textarea><br>
        <button type="submit" style="padding:10px 20px; cursor:pointer;">Submit Comment V2</button>
    </form>
    <h2>Comments</h2>
    {% for c in comments %}
        <div style="border-bottom: 1px solid #eee; padding: 10px 0;">
            <strong>{{ c.username }}</strong>: {{ c.text }}
        </div>
    {% else %}
        <p>No comments yet!</p>
    {% endfor %}
</body>
</html>
"""

@app.route('/')
def index():
    comments = list(comments_collection.find().sort("_id", -1))
    return render_template_string(HTML_TEMPLATE, comments=comments)

@app.route('/add', methods=['POST'])
def add_comment():
    username = request.form.get('username')
    text = request.form.get('text')
    if username and text:
        comments_collection.insert_one({"username": username, "text": text})
    return redirect('./')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
