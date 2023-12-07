D = File.read(ARGV[0]).strip
p1 = 0
p2 = 0

D.each_line do |line|
  p1_digits = []
  p2_digits = []

  line.chars.each_with_index do |c, i|
    if c.match?(/\d/)
      p1_digits << c
      p2_digits << c
    end

    ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'].each_with_index do |val, d|
      if line[i..-1].start_with?(val)
        p2_digits << (d + 1).to_s
      end
    end
  end

  p1 += "#{p1_digits.first}#{p1_digits.last}".to_i
  p2 += "#{p2_digits.first}#{p2_digits.last}".to_i
end

puts p1
puts p2
