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

    def self.calculate(input)
      image = if input.is_a? Vips::Image
        input.thumbnail_image(8, height: 8, size: :force)
      else
        Vips::Image.thumbnail(input, 8, height: 8, size: :force)
      end
      array = DHashVips.bw(image).to_enum.map &:flatten
      d1, i1, d2, i2 = [array, array.transpose].flat_map do |a|
        d = a.zip(a.rotate(1)).flat_map{ |r1, r2| r1.zip(r2).map{ |i, j| i - j } }
        m = median d.map(&:abs).sort
        [
          d.map{ |c| c     <  0 ? 1 : 0 }.join.to_i(2),
          d.map{ |c| c.abs >= m ? 1 : 0 }.join.to_i(2),
        ]
      end
      ((((((i1 << 8 * 8) + i2) << 8 * 8) + d1) << 8 * 8) + d2)
    end
  end

  files = [
"red_water.jpg","red_chb.jpg","noisy_image_1_110.jpg","red.jpg","red_1.jpg","red_2.jpg","red_3.jpg","red_4.jpg","red_5.jpg","red_6.jpg","red_7.jpg","red_8.jpg",
"red_9.jpg","red_10.jpg","red_11.jpg","red_12.jpg","red_13.jpg","red_14.jpg","red_15.jpg","red_16.jpg","red_17.jpg","red_18.jpg","red_19.jpg","red_20.jpg",
"red_21.jpg","red_22.jpg","red_23.jpg","red_24.jpg","red_25.jpg","red_26.jpg","red_27.jpg","red_28.jpg","red_29.jpg","red_30.jpg","red_31.jpg","red_32.jpg",
"red_33.jpg","red_34.jpg","red_35.jpg","red_36.jpg","red_37.jpg","red_38.jpg","red_39.jpg","red_40.jpg","red_41.jpg","red_42.jpg","red_col_4.jpg","red_col_5.jpg",
"red_col_6.jpg","red_col_7.jpg","red_col_8.jpg","red_col_9.jpg","red_col_10.jpg","red_col_11.jpg","red_col_12.jpg","red_col_13.jpg","red_col_14.jpg","red_col_15.jpg",
"red_col_16.jpg","red_col_17.jpg","red_col_18.jpg","red_col_19.jpg","red_col_20.jpg", "red_fred_1.jpg","red_fred_2.jpg","red_fred_3.jpg","red_fred_4.jpg","red_fred_5.jpg",
"red_fred_6.jpg","red_fred_7.jpg","red_fred_8.jpg","red_fred_9.jpg","red_fred_10.jpg","red_fred_11.jpg","red_fred_12.jpg","red_fred_13.jpg","red_fred_14.jpg",
"red_fred_15.jpg","red_fred_16.jpg","red_fred_17.jpg","red_fred_18.jpg","red_fred_19.jpg","red_fred_20.jpg"
]

  original_hash = IDHash.calculate("red.jpg")

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

  book.write('reds_idhash.xls')
end
