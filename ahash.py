import numpy as np
from PIL import Image
import time
import openpyxl

def ahash(image_path):
  image = Image.open(image_path).convert('L').resize((8, 8), Image.Resampling.LANCZOS)
  pixels = np.array(image)
  average = pixels.mean()
  bits = [(1 if pixel > average else 0) for row in pixels for pixel in row]
  hash_value = int("".join(str(bit) for bit in bits))

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
  "664e1ea0193db_noisy_image_1_1.jpg","black_chb.jpg","noisy_image_1_1.jpg","black.jpg","black_1.jpg","black_2.jpg","black_3.jpg","black_4.jpg","black_5.jpg",
"black_6.jpg","black_7.jpg","black_8.jpg","black_9.jpg","black_10.jpg","black_11.jpg","black_12.jpg","black_13.jpg","black_14.jpg","black_15.jpg","black_16.jpg",
"black_17.jpg","black_18.jpg","black_19.jpg","black_20.jpg","black_21.jpg","black_22.jpg","black_23.jpg","black_24.jpg","black_25.jpg","black_26.jpg",
"black_27.jpg","black_28.jpg","black_29.jpg","black_30.jpg","black_31.jpg","black_32.jpg","black_33.jpg","black_34.jpg","black_35.jpg","black_36.jpg",
"black_37.jpg","black_38.jpg","black_39.jpg","black_40.jpg","black_41.jpg","black_42.jpg","black_col_4.jpg","black_col_5.jpg","black_col_6.jpg",
"black_col_7.jpg","black_col_8.jpg","black_col_9.jpg","black_col_10.jpg","black_col_11.jpg","black_col_12.jpg","black_col_13.jpg","black_col_14.jpg",
"black_col_15.jpg","black_col_16.jpg","black_col_17.jpg","black_col_18.jpg","black_col_19.jpg","black_col_20.jpg"
]
original_hash = ahash("black.jpg")

book = openpyxl.Workbook() 
sheet = book.active 
sheet.append(['Фото', 'Хэш', 'Время обработки', 'Хэммингово расстояние'])

for image_path in image_paths: 
    start_time = time.time() 
    hash_value = ahash(image_path) 
    end_time = time.time()
    distance = hamming_distance(original_hash, hash_value)
    timing = (end_time - start_time).__round__(6)
    sheet.append([image_path, hash_value, timing, distance])

book.save('black_ahash.xlsx')