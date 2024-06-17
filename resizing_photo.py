import cv2
import os

def resize_and_save(image_path, output_folder, iterations, pixel_increment):
    image = cv2.imread(image_path)
    os.makedirs(output_folder, exist_ok=True)
    resized_image = cv2.resize(image, (229, 229))
    cv2.imwrite(os.path.join(output_folder, "resized_0.jpg"), resized_image)
    current_area = 229 * 229
    for i in range(iterations):
        new_area = current_area + pixel_increment
        new_width = int(new_area ** 0.5)
        new_height = new_width
        resized_image = cv2.resize(resized_image, (new_width, new_height))
        cv2.imwrite(os.path.join(output_folder, f"resized_{i+1}.jpg"), resized_image)
        current_area = new_area

image_path = "white.jpg"  
output_folder = "resize"  
iterations = 20 
pixel_increment = 2500  

resize_and_save(image_path, output_folder, iterations, pixel_increment)