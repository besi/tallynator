require 'rubygems'
require 'rmagick'


def create_tally(seq)

  print "Creating image '" + seq + ".png' ... \n"
  canvas = Magick::Image.new(85, 75)

  red = Magick::ImageList.new("assets/stroke.png")
  red.background_color = 'none';
  cols = red.columns
  rows = red.rows
  gray = red.quantize(256, Magick::GRAYColorspace).modulate(2.5)
  black = gray.modulate(0.001)

  strokes={'y'=> black, 'n'=> red, '-' => gray}

  draw = Magick::Draw.new

  # The fifth stroke is diagonal
  rotated = strokes[seq[4]]
  rotated = rotated.resize(cols, rows * 1.5).rotate(-55)

  draw.composite(-3, 0, rotated.columns, rotated.rows, rotated)

  # draw four vertical lines
  draw.composite(15, 0, cols, rows, strokes[seq[0]])
  draw.composite(30, 0, cols, rows, strokes[seq[1]])
  draw.composite(45, 0, cols, rows, strokes[seq[2]])
  draw.composite(60, 0, cols, rows, strokes[seq[3]])

  # Overpaint again if 'y' or 'n'
  if (!seq[4].eql?('-'))
    draw.composite(-3, 0, rotated.columns, rotated.rows, rotated)
  end

  draw.draw(canvas)
  
  canvas.write('output/' + seq + '.png')
end

task :clean do
  
  FileUtils.rm_rf('output')
  
end

task :default => :clean do
  
  Dir::mkdir('output/')

  create_tally('-----')
  for i in 0...6
    for x in 0...2**i
      binary = x.to_s(2).rjust(i,'0');
      string = binary.gsub(/0/, 'n').gsub(/1/, 'y').ljust(5, '-')
      create_tally(string);
    end
  end
  
end


