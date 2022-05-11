from flask import Flask, render_template
app = Flask(__name__)

posts = [
    {
        'author': 'Reza Bojnordi',
        'title': 'Blog Post 1',
        'content': 'First post content',
        'data': 'April 20, 2018'
    },
    {
        'author': 'aria Bojnordi',
        'title': 'Blog Post 2',
        'content': 'Second post content',
        'data': 'April 21, 2018'
    }
    
]
@app.route("/")
@app.route("/home")

def home():
    return render_template("home.html", posts=posts)
    #return "<h1>Home Page</h1>"


@app.route("/about")
def about():
    return render_template("about.html", title="About")


if __name__ == "__main__":
    app.run(debug=True)