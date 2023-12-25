from flask import Flask, render_template, request, jsonify, json
from werkzeug.utils import secure_filename
from flask_ngrok import run_with_ngrok
import os

import cv2
import numpy as np
from imutils import contours
from tensorflow.keras.models import load_model
import pytesseract

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

# Load the OCR model
model = load_model('server/model/network_1.h5')

digits = '0123456789'
letters = 'ABCDEFGHIJKLMNOPQRSTUVWZYZ'
char_list = digits + letters
char_list = [ch for ch in char_list]

def filter_image(img):
    gray = cv2.cvtColor(img,cv2.COLOR_RGB2GRAY)
    clahe = cv2.createCLAHE(clipLimit=0.5, tileGridSize=(12, 12))
    clahed = clahe.apply(gray)
    gaussian = cv2.GaussianBlur(clahed,(3,3),0)
    thresholded = cv2.threshold(gaussian,165,255,cv2.THRESH_TRUNC + cv2.THRESH_OTSU)[1]
    binary = cv2.threshold(thresholded,127,255,cv2.THRESH_BINARY_INV)[1]
    
    return binary
    pass

def get_text_roi(image):
    text_roi=[]
    cnts = cv2.findContours(image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cnts = imutils.grab_contours(cnts)
    cnts = contours.sort_contours(cnts, method="left-to-right")[0]

    for cnt in cnts:
            x, y, w, h = cv2.boundingRect(cnt)
            if(w > 4 and h > 20):
                padded = cv2.copyMakeBorder(image[y:y+h, x:x+w],20,20,20,20, cv2.BORDER_CONSTANT)


            padded = cv2.resize(padded,(28,28))
            # padded = 255 - padded
            pad = np.array(padded)
            pad = pad / 255.0
            pad_vector = pad.reshape((-1, 1))
            padded = pad_vector.reshape(-1, 28, 28, 1)

            pred = model.predict(padded)
            pred_conf = np.amax(pred)
            pred_index = np.argmax(pred)
            print(f'model pred idx: {pred_index}')
            print(f'model pred conf: {pred_conf}')
            print(f'model pred label: {char_list[pred_index]}')
            text_roi.append(f'{char_list[pred_index]}')
    return text_roi
    pass

def grab_text(ktp_roi, index):
    rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (40,40))
    dlt = cv2.dilate(ktp_roi, rect_kernel, iterations = 1)

    cnts = cv2.findContours(dlt, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    cnts = imutils.grab_contours(cnts)
    cnts = contours.sort_contours(cnts, method="left-to-right")[0]
    x, y, w, h = cv2.boundingRect(cnts[index])

    return ktp_roi[y:y+h, x:x+w]
    pass

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    if 'file' not in request.files:
        return redirect(request.url)
    
    file = request.files['file']

    if file.filename == '':
        return redirect(request.url)

    if file:
        # Read the uploaded image
        image = cv2.imdecode(np.fromstring(file.read(), np.uint8), cv2.IMREAD_COLOR)
        
        # Perform image processing
        filtered_img = filter_image(image.copy())

        cnts = cv2.findContours(filtered_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        cnts = imutils.grab_contours(cnts)
        cnts = contours.sort_contours(cnts, method="left-to-right")[0]


        largest_areas = sorted(cnts, key=cv2.contourArea)
        x, y, w, h = cv2.boundingRect(largest_areas[-1])
        cv2.rectangle(filtered_img, (x, y), (x + w, y + h+30), (0, 0, 0), -1)
        resized = imutils.resize(image,width=2560)
        foto_ktp = resized[y:y+h, x:x+w]

        # remove big chunk
        for cnt in cnts:
            x, y, w, h = cv2.boundingRect(cnt)
            if(w > 100 and  h > 100):
                cv2.rectangle(filtered_img, (x, y), (x + w, y + h), (0, 0, 0), -1)

        rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (480,1))
        dilation = cv2.dilate(filtered_img, rect_kernel, iterations = 1)
        
        cnts = cv2.findContours(dilation, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        cnts = imutils.grab_contours(cnts)
        cnts = contours.sort_contours(cnts, method="top-to-bottom")[0]
        im2 = image.copy()
        ktp_roi=[]

        for cnt in cnts:
                x, y, w, h = cv2.boundingRect(cnt)
                if(50 < w and 50 < h < 100):
                    cv2.rectangle(im2, (x, y), (x + w, y + h), (0, 255, 0), 4)
                    ktp_roi.append(filtered_img[y:y+h, x:x+w])
        
        # Extract text using OCR
        for roi in ktp_roi:
            text_roi = grab_text(roi.copy(), -1)
            pred = get_text_roi(text_roi)
            extracted_information = pytesseract.image_to_string(text_roi)
            
            # Output the results
            print(f"tesseract: {extracted_information}")
            print(f"custom result: {''.join(pred)}")

        return render_template('result.html', result="Processing complete")

if __name__ == '__main__':
    app.run(debug=True)
