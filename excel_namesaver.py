import os
import openpyxl

def create_excel_table(input_folder, output_file):
    
    workbook = openpyxl.Workbook()
    worksheet = workbook.active

    image_files = [f for f in os.listdir(input_folder) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

    for i, file in enumerate(image_files):
        worksheet[f'A{i+1}'] =  f'"{file}"' 

    workbook.save(output_file)

input_folder = "black"  
output_file = "black.xlsx" 

create_excel_table(input_folder, output_file)