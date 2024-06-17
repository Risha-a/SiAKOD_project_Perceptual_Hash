import os
import cv2

def sort_images_by_size(input_folder, output_folder):
    os.makedirs(output_folder, exist_ok=True)
    image_files = [f for f in os.listdir(input_folder) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    sorted_files = sorted(image_files, key=lambda f: get_image_size(os.path.join(input_folder, f)))
    for i, file in enumerate(sorted_files):
        file_name, ext = os.path.splitext(file)
        new_file_name = f"white_{i+1}{ext}" 
        cv2.imwrite(os.path.join(output_folder, new_file_name), cv2.imread(os.path.join(input_folder, file)))

def get_image_size(image_path):
    
    img = cv2.imread(image_path)
    return img.shape[0] * img.shape[1] 

input_folder = "resize" 
output_folder = "white_size" 

sort_images_by_size(input_folder, output_folder)