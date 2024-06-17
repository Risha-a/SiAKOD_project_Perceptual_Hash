from PIL import Image
import os

def adjust_saturation(image_path, saturation_value):
   
    image = Image.open(image_path)
    image = image.convert("RGB") 
    image = image.point(lambda p: p * (1 + saturation_value / 100))
    return image

input_image_path = "black.jpg"  

output_folder = "black_col"
os.makedirs(output_folder, exist_ok=True)

image = adjust_saturation(input_image_path, -100)

for i in range(20): 
    saturation_value = -100
    saturation_value += i * 10 
    modified_image = adjust_saturation(input_image_path, saturation_value)
    modified_image.save(os.path.join(output_folder, f"black_col_{i+1}.jpg"))