from flask import Flask,request,jsonify
app = Flask(__name__)

books_list = []
@app.route("/books", methods=['GET','POST'])
def books():
    if request.method == 'GET':
        if len(books_list) > 0:
            return jsonify(books_list)
        else:
            'Noting Found',404
        
        if request.method == 'POST':
            new_author = request.form['author']
            new_lang = request.form['lang']
            new_title = request.form['title']
            iD = books_list[-1]['id'] + 1
            
            new_obj = {
                id:iD,
                'author':new_author,
                'lang':new_lang,
                'title':new_title
            }
            books_list.append(new_obj)
            return jsonify(books_list),201

@app.route("/books/<int:id>", methods=['GET','PUT','DELETE'])
def single_book(id):
    if request.method == 'GET':
        for book in books_list:
            if book['id'] == id:
                return jsonify(book)
            pass
    if request.method == 'put':
        for book in books_list:
            if book['id'] == id:
                book['author'] = request.form['author']
                book['lang'] = request.form['lang']
                book['title'] = request.form['title']
                updated_book = {
                    'id':book['id'],
                    'author':book['author'],
                    'language':book['language'],
                    'title':book['title']
                }
                return jsonify(updated_book)
    if request.method == 'delete':
        for index,book in enumerate(books_list):
            if book['id'] == id:
                books_list.pop(book)
                return jsonify(books_list)

if __name__ == '__main__':
    app.run()
    