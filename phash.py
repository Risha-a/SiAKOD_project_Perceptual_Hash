import numpy as np
from PIL import Image
from scipy.fftpack import dct
import time 
import openpyxl

def phash(image_path):
    image = Image.open(image_path).convert("L") 
    image = image.resize((32, 32), Image.Resampling.LANCZOS)
    pixels = np.array(image)
    dct_matrix = dct(dct(pixels, axis=0), axis=1)
    dct_block = dct_matrix[:8, :8]
    average = np.mean(dct_block)
    binary_dct = np.where(dct_block > average, 1, 0)
    hash_value = int(''.join(str(x) for x in binary_dct.flatten()))

    return str(hash_value)

def hamming_distance(hash1, hash2):
    bin1 = bin(int(hash1, 16))[2:].zfill(64)
    bin2 = bin(int(hash2, 16))[2:].zfill(64)
    distance = 0
    for i in range(len(bin1)):
        if bin1[i] != bin2[i]:
            distance += 1

    return distance

image_paths = [
  "664e1ea025ae4_noisy_image_1.jpg","noisy_image_1.jpg","photochka_chb.jpg","white.jpg","white_1.jpg","white_2.jpg","white_3.jpg","white_4.jpg","white_5.jpg","white_6.jpg",
"white_7.jpg","white_8.jpg","white_9.jpg","white_10.jpg","white_11.jpg","white_12.jpg","white_13.jpg","white_14.jpg","white_15.jpg","white_16.jpg","white_17.jpg", "white_18.jpg","white_19.jpg","white_20.jpg","white_21.jpg","white_22.jpg","white_23.jpg","white_24.jpg","white_25.jpg","white_26.jpg","white_27.jpg","white_28.jpg","white_29.jpg",
"white_30.jpg","white_31.jpg","white_32.jpg","white_33.jpg","white_34.jpg","white_35.jpg","white_36.jpg","white_37.jpg","white_38.jpg","white_39.jpg","white_40.jpg",
"white_41.jpg","white_42.jpg","white_col_4.jpg","white_col_5.jpg","white_col_6.jpg","white_col_7.jpg","white_col_8.jpg","white_col_9.jpg","white_col_10.jpg",
"white_col_11.jpg","white_col_12.jpg","white_col_13.jpg","white_col_14.jpg","white_col_15.jpg","white_col_16.jpg","white_col_17.jpg","white_col_18.jpg","white_col_19.jpg",
"white_col_20.jpg"
]
original_hash = phash("white.jpg")

book = openpyxl.Workbook() 
sheet = book.active 
sheet.append(['Фото', 'Хэш', 'Время обработки', 'Хэммингово расстояние'])

for image_path in image_paths: 
    start_time = time.time() 
    hash_value = phash(image_path) 
    end_time = time.time()
    distance = hamming_distance(original_hash, hash_value)
    timing = (end_time - start_time).__round__(6)
    sheet.append([image_path, hash_value, timing, distance])

book.save('white_phash.xlsx')
