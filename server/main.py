from flask import Flask, render_template, request, jsonify, json
from werkzeug.utils import secure_filename
from flask_ngrok import run_with_ngrok
import os

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/image-upload")
def imageUpload():
    return render_template('image_upload.html')

@app.route("/upload", methods=['POST'])
def upload():
    if request.method == 'POST':
        if 'image' not in request.files:
            return jsonify({'error': 'No file part'})

        file = request.files['image']

        if file.filename == '':
            return jsonify({'error': 'No selected file'})

        filename = secure_filename(file.filename)

        # Ensure 'uploads' directory exists
        os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return jsonify({'filename': filename})

if __name__ == '__main__':
    app.run(debug=True)
