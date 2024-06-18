require 'ruby-vips'
require 'fileutils'

image = Vips::Image.new_from_file("black.jpg")
output_dir = "rot"
FileUtils.mkdir_p(output_dir)
i = 0

for i in 1..20 do
  x = i * 5
  image.write_to_file(File.join(output_dir, "black_fred_#{21-i}.jpg"), Q: x)
end
