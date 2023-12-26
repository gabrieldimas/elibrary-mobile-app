# import cv2
# import numpy as np
# from imutils import contours
# from tensorflow.keras.models import load_model

# digits = '0123456789'
# letters = 'ABCDEFGHIJKLMNOPQRSTUVWZYZ'
# char_list = digits + letters
# char_list = [ch for ch in char_list]

# def filter_image(img):
#     gray = cv2.cvtColor(img,cv2.COLOR_RGB2GRAY)
#     clahe = cv2.createCLAHE(clipLimit=0.5, tileGridSize=(12, 12))
#     clahed = clahe.apply(gray)
#     gaussian = cv2.GaussianBlur(clahed,(3,3),0)
#     thresholded = cv2.threshold(gaussian,165,255,cv2.THRESH_TRUNC + cv2.THRESH_OTSU)[1]
#     binary = cv2.threshold(thresholded,127,255,cv2.THRESH_BINARY_INV)[1]
    
#     return binary
#     pass

# def get_text_roi(image):
#     text_roi=[]
#     cnts = cv2.findContours(image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
#     cnts = imutils.grab_contours(cnts)
#     cnts = contours.sort_contours(cnts, method="left-to-right")[0]

#     for cnt in cnts:
#             x, y, w, h = cv2.boundingRect(cnt)
#             if(w > 4 and h > 20):
#                 padded = cv2.copyMakeBorder(image[y:y+h, x:x+w],20,20,20,20, cv2.BORDER_CONSTANT)


#             padded = cv2.resize(padded,(28,28))
#             # padded = 255 - padded
#             pad = np.array(padded)
#             pad = pad / 255.0
#             pad_vector = pad.reshape((-1, 1))
#             padded = pad_vector.reshape(-1, 28, 28, 1)

#             pred = model.predict(padded)
#             pred_conf = np.amax(pred)
#             pred_index = np.argmax(pred)
#             print(f'model pred idx: {pred_index}')
#             print(f'model pred conf: {pred_conf}')
#             print(f'model pred label: {char_list[pred_index]}')
#             text_roi.append(f'{char_list[pred_index]}')
#     return text_roi
#     pass

# def grab_text(ktp_roi, index):
#     rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (40,40))
#     dlt = cv2.dilate(ktp_roi, rect_kernel, iterations = 1)

#     cnts = cv2.findContours(dlt, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
#     cnts = imutils.grab_contours(cnts)
#     cnts = contours.sort_contours(cnts, method="left-to-right")[0]
#     x, y, w, h = cv2.boundingRect(cnts[index])

#     return ktp_roi[y:y+h, x:x+w]
#     pass

import cv2
import numpy as np
from PIL import Image, ImageOps
from sklearn.cluster import KMeans


def cluster_image(image):
    X = image.reshape(-1,3)
    kmeans = KMeans(n_clusters = 2, n_init=10)

    kmeans.fit(X)
    clustered_image = kmeans.cluster_centers_[kmeans.labels_]
    clustered_image = clustered_image.reshape(image.shape)

    return clustered_image

def contour_detection(gray, image):
    # Apply thresholding to binarize the image
    thresh = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)[1]

    contours, hierarchy = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    image_copy_contours = image.copy()

    # Draw contours on the original image
    cv2.drawContours(image_copy_contours, contours, -1, (0, 255, 0), 2)

    return image_copy_contours, contours

def find_largest_contour(contours,image):
    largest_area = 0
    largest_contour_index = -1

    for i, contour in enumerate(contours):
        area = cv2.contourArea(contour)
        if area > largest_area:
            largest_area = area
            largest_contour_index = i
            print(f"largest_contour_index:{largest_contour_index}")

    largest_contour = contours[largest_contour_index]

    cv2.drawContours(image, [largest_contour], -1, (0, 255, 0), 2)

    return largest_contour, image

def make_outside_black(original_image, largest_contour):
    # Create a mask of the largest contour
    mask = np.zeros_like(original_image)
    cv2.drawContours(mask, [largest_contour], -1, (255, 255, 255), thickness=cv2.FILLED)

    # Make the outside of the contour black
    result_image = np.where(mask != 0, original_image, 0)

    return result_image

def do_perspective_transformation(rgb, input_array):
    height, width = rgb.shape[:2]
    input_array = np.float32(input_array)
    output_array = np.float32([(0,0), (width, 0), (width, height), (0, height)])
    matrix = cv2.getPerspectiveTransform(input_array, output_array)
    result = cv2.warpPerspective(rgb, matrix, (width, height), cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(0,0,0))
    return result


def get_transformed_image(black_outside,contours):
    gray = cv2.cvtColor(black_outside, cv2.COLOR_RGB2GRAY)
    blur = cv2.medianBlur(gray, 1)
    _, thresh = cv2.threshold(blur, 0 , 255, cv2.THRESH_OTSU)
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
    for cnt in contours:
        approx = cv2.approxPolyDP(cnt, 0.01*cv2.arcLength(cnt, True), True)
        area = cv2.contourArea(cnt)
        if len(approx) == 4 and area > 100:
            print('approx', approx)
            points = approx.ravel().reshape(-1, 2)
            print('points', points)
            # Sort points based on x and y coordinates
            sorted_list = sorted(points, key=lambda x: (x[0], x[1]))
            c1, c2, c3, c4 = sorted_list
            cv2.circle(black_outside, tuple(c1), 5, 255, -1)
            cv2.circle(black_outside, tuple(c2), 5, 255, -1)
            cv2.circle(black_outside, tuple(c3), 5, 255, -1)
            cv2.circle(black_outside, tuple(c4), 5, 255, -1)
            input_array = [tuple(c2), tuple(c1), tuple(c4), tuple(c3)]
            crop = do_perspective_transformation(black_outside, input_array)
            print("if len(approx) == 4 and area > 100:")
    
    # jika transformed_image memiliki skala 1.333 artinya gambarnya miring dan terbalik
    h,w,_ = crop.shape
    scale = h/w
    
    if scale > 1.2 and scale < 1.4:
        # Rotate the image 90 degrees clockwise
        rotated_image = cv2.rotate(crop, cv2.ROTATE_90_CLOCKWISE)
    
        # Mirror the image horizontally
        mirrored_image = cv2.flip(rotated_image, 1)
        crop = mirrored_image

    # print(f"get_transformed_image returning {crop}")
    return crop

def get_inverted_image(gray):
  
    # Fungsi thresholding biner
    _, binary_thresh_img = cv2.threshold(gray, 128, 255, cv2.THRESH_BINARY)

    # Fungsi inversi warna
    return cv2.bitwise_not(binary_thresh_img)

def get_sorted_contours_lines(sorted_contours_lines, crop):
    img2 = crop.copy()

    for ctr in sorted_contours_lines:
        x,y,w,h = cv2.boundingRect(ctr)
        if (w >= 10 and w <= 1000) and (h >= 20 and h <= 50):
            cv2.rectangle(img2, (x, y), (x + w, y + h), (40, 100, 250), 2)
    
    return img2

def save_contoured_area(sorted_contours_lines,crop):
    # List untuk menyimpan hasil crop
    crop_results = []
    
        
    for ctr in sorted_contours_lines:
        x, y, w, h = cv2.boundingRect(ctr)
    
        # Periksa ukuran bounding box
        if (w >= 10 and w <= 1000) and (h >= 20 and h <= 50):
            # Crop bagian gambar yang ada di dalam bounding box
            cropped_img = crop[y:y+h, x:x+w]
    
            # Tambahkan hasil crop ke dalam list
            crop_results.append(cropped_img)
    
    return crop_results


# Fungsi untuk resize gambar
def resize_img(image, width, height):
    return cv2.resize(image, (width, height))

# Fungsi untuk normalisasi gambar (jika diperlukan)
def normalization(image):
    # Implementasi normalisasi gambar di sini (jika diperlukan)
    pass


# def crop_and_process(contour, crop_results):
#     x, y, w, h = cv2.boundingRect(contour)

#     if (10 <= w <= 1000) and (20 <= h <= 50):
#         cropped_img = crop[y:y+h, x:x+w]
#         gray_img = cv2.cvtColor(cropped_img, cv2.COLOR_BGR2GRAY)
#         _, otsu = cv2.threshold(gray_img, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
#         invertion = 255 - otsu
#         crop_results.append(invertion)
#         segment_letters(invertion)

def segment_letters(image):
    contours_letter, _ = cv2.findContours(image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contours_letter = sorted(contours_letter, key=lambda x: cv2.boundingRect(x)[0])

    for contour in contours_letter:
        x1, y1, w1, h1 = cv2.boundingRect(contour)
        if cv2.contourArea(contour) > 6 and w1/h1 < 2:
            letter = image[y1:y1+h1, x1:x1+w1]
            process_segmented_letter(letter)

def process_segmented_letter(letter):
    pil_img = Image.fromarray(letter)
    padding_size = 8
    padded_letter = ImageOps.expand(pil_img, border=padding_size, fill=(0,))
    numpy_letter = np.array(padded_letter)

def crop_percentage(img, left_percentage, right_percentage):

    # Get image size
    width, height = img.size

    # Calculate pixels to be removed from left and right
    left_crop = int(width * left_percentage)
    right_crop = int(width * right_percentage)

    # Crop the image
    cropped_img = img.crop((left_crop, 0, width - right_crop, height))

    return cropped_img