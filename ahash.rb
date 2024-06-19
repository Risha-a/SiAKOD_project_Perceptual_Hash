require 'ruby-vips'
require "spreadsheet"


def hamming(hash1, hash2)
  (hash1.to_i(2) ^ hash2.to_i(2)).to_s(2).count('1')
end

def bw(image)
  (image.has_alpha? ? image.flatten(background: 255) : image).colourspace("b-w")[0]
end

def ahash(input)
  image = if input.is_a? Vips::Image
    input.thumbnail_image(8, height: 8, size: :force)
  else
    Vips::Image.thumbnail(input, 8, height: 8, size: :force)
  end
  pixels = bw(image).to_a.flatten
  avg = pixels.sum / pixels.size
  pixels.map { |p| p >= avg ? 1 : 0 }.join
end

def main
  files = [
"664e1ea0193db_noisy_image_1_1.jpg","black_chb.jpg","noisy_image_1_1.jpg","black.jpg","black_1.jpg","black_2.jpg","black_3.jpg","black_4.jpg","black_5.jpg",
"black_6.jpg","black_32.jpg","black_33.jpg","black_34.jpg","black_35.jpg","black_36.jpg","black_37.jpg","black_38.jpg","black_39.jpg","black_40.jpg",
"black_41.jpg","black_42.jpg","black_col_10.jpg","black_col_11.jpg","black_col_12.jpg","black_col_13.jpg","black_col_14.jpg",
"black_col_15.jpg","black_col_16.jpg","black_col_17.jpg","black_col_18.jpg","black_col_19.jpg","black_col_20.jpg",
"new_1.jpg","new_2.jpg","new_3.jpg","new_4.jpg","new_5.jpg","new_6.jpg","new_7.jpg","new_8.jpg","new_9.jpg","new_10.jpg","new_11.jpg",
"new_12.jpg","new_13.jpg","new_14.jpg","new_15.jpg","new_16.jpg","new_17.jpg","new_18.jpg","new_19.jpg","new_20.jpg","new_21.jpg",
"new_22.jpg","new_23.jpg","new_24.jpg","new_25.jpg","new_26.jpg","new_27.jpg","new_28.jpg","new_29.jpg","new_30.jpg"
]

  original_hash = ahash("black.jpg")

  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet

  sheet1[0, 0] = "Название фото"
  sheet1[0, 1] = "Хэш"
  sheet1[0, 2] = "Время"
  sheet1[0, 3] = "Хэммингово расстояние"

  row = 1

  files.each do |file|
    start_time = Time.now
    hash_value = ahash(file)
    end_time = Time.now

    sheet1[row, 0] = file
    sheet1[row, 1] = hash_value.to_s
    sheet1[row, 2] = end_time - start_time
    sheet1[row, 3] = hamming(original_hash, hash_value)

    row += 1
  end

  book.write('black_check_ahash.xls')
end

main
p 'done'
