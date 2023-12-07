data = File.read(ARGV[0]).strip
lines = data.split("\n")
p1 = 0
N = Hash.new(0)

lines.each_with_index do |line, i|
  N[i] += 1
  first, rest = line.split('|')
  id_, card = first.split(':')
  card_nums = card.split.map(&:to_i)
  rest_nums = rest.split.map(&:to_i)
  val = (card_nums & rest_nums).uniq.length

  if val > 0
    p1 += 2**(val - 1)
  end

  val.times do |j|
    N[i + 1 + j] += N[i]
  end
end

puts p1
puts N.values.sum
