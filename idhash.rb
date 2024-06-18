require 'ruby-vips'
require "spreadsheet"

module DHashVips
  def self.bw image
    (image.has_alpha? ? image.flatten(background: 255) : image).colourspace("b-w")[0]
  end
  module IDHash
    def self.median array
      h = array.size / 2
      return array[h] if array[h] != array[h - 1]
      right = array.dup
      left = right.shift h
      right.shift if right.size > left.size
      return right.first if left.last != right.first
      return right.uniq[1] if left.count(left.last) > right.count(right.first)
      left.last
    end

    def self.hamming a, b
      ((a ^ b) & (a | b) >> 128).to_s(2).count "1"
    end

    def self.calculate(input, power = 3)
      size = 2 ** power
      image = if input.is_a? Vips::Image
        input.thumbnail_image(size, height: size, size: :force)
      else
        Vips::Image.thumbnail(input, size, height: size, size: :force)
      end
      array = DHashVips.bw(image).to_enum.map &:flatten
      d1, i1, d2, i2 = [array, array.transpose].flat_map do |a|
        d = a.zip(a.rotate(1)).flat_map{ |r1, r2| r1.zip(r2).map{ |i, j| i - j } }
        m = IDHash.median d.map(&:abs).sort
          [
            d.map{ |c| c     <  0 ? 1 : 0 }.join.to_i(2),
            d.map{ |c| c.abs >= m ? 1 : 0 }.join.to_i(2),
          ]
      end
      ((((((i1 << size * size) + i2) << size * size) + d1) << size * size) + d2)
    end
  end

  files = [
  "664e1ea0193db_noisy_image_1_1.jpg","black_chb.jpg","noisy_image_1_1.jpg","black.jpg","black_1.jpg","black_2.jpg","black_3.jpg","black_4.jpg","black_5.jpg",
"black_6.jpg","black_7.jpg","black_8.jpg","black_9.jpg","black_10.jpg","black_11.jpg","black_12.jpg","black_13.jpg","black_14.jpg","black_15.jpg","black_16.jpg",
"black_17.jpg","black_18.jpg","black_19.jpg","black_20.jpg","black_21.jpg","black_22.jpg","black_23.jpg","black_24.jpg","black_25.jpg","black_26.jpg",
"black_27.jpg","black_28.jpg","black_29.jpg","black_30.jpg","black_31.jpg","black_32.jpg","black_33.jpg","black_34.jpg","black_35.jpg","black_36.jpg",
"black_37.jpg","black_38.jpg","black_39.jpg","black_40.jpg","black_41.jpg","black_42.jpg","black_col_4.jpg","black_col_5.jpg","black_col_6.jpg",
"black_col_7.jpg","black_col_8.jpg","black_col_9.jpg","black_col_10.jpg","black_col_11.jpg","black_col_12.jpg","black_col_13.jpg","black_col_14.jpg",
"black_col_15.jpg","black_col_16.jpg","black_col_17.jpg","black_col_18.jpg","black_col_19.jpg","black_col_20.jpg","black_fred_1.jpg","black_fred_2.jpg",
"black_fred_3.jpg","black_fred_4.jpg","black_fred_5.jpg","black_fred_6.jpg","black_fred_7.jpg","black_fred_8.jpg","black_fred_9.jpg","black_fred_10.jpg",
"black_fred_11.jpg","black_fred_12.jpg","black_fred_13.jpg","black_fred_14.jpg","black_fred_15.jpg","black_fred_16.jpg","black_fred_17.jpg","black_fred_18.jpg",
"black_fred_19.jpg","black_fred_20.jpg"

]

  original_hash = IDHash.calculate("black.jpg")

  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet

  sheet1[0, 0] = "Название фото"
  sheet1[0, 1] = "Хэш"
  sheet1[0, 2] = "Время"
  sheet1[0, 3] = "Хэммингово расстояние"

  row = 1

  files.each do |file|
    start_time = Time.now
    hash_value = IDHash.calculate(file)
    end_time = Time.now

    sheet1[row, 0] = file
    sheet1[row, 1] = hash_value.to_s
    sheet1[row, 2] = end_time - start_time
    sheet1[row, 3] = IDHash.hamming(original_hash, hash_value)

    row += 1
  end

  book.write('black_idhash.xls')
end
