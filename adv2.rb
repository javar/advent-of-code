data = File.read(ARGV[0]).strip
p1 = 0
p2 = 0

# Only 12 red cubes, 13 green cubes, and 14 blue cubes?
data.split("\n").each do |line|
  ok = true
  id, line = line.split(':')
  cubes = Hash.new(0)

  line.split(';').each do |event|
    event.split(',').each do |balls|
      n, color = balls.split
      n = n.to_i
      cubes[color] = [cubes[color], n].max
      if n > {'red' => 12, 'green' => 13, 'blue' => 14}[color].to_i
        ok = false
      end
    end
  end

  score = cubes.values.reduce(1, :*)
  p2 += score
  p1 += id.split[-1].to_i if ok
end

puts p1
puts p2