require 'set'

data = File.read(ARGV[0]).strip
lines = data.split("\n")
grid = lines.map { |line| line.chars }
grid_rows = grid.length
grid_columns = grid[0].length

p1 = 0
nums = Hash.new { |hash, key| hash[key] = [] }

(0...grid_rows).each do |r|
  gears = Set.new
  n = 0
  has_part = false

  (0...grid_columns + 1).each do |c|
    if c < grid_columns && grid[r][c] =~ /\d/
      n = n * 10 + grid[r][c].to_i
      [-1, 0, 1].each do |rr|
        [-1, 0, 1].each do |cc|
          if (0..(grid_rows - 1)).cover?(r + rr) && (0..(grid_columns - 1)).cover?(c + cc)
            ch = grid[r + rr][c + cc]
            has_part = true if !ch.match?(/\d/) && ch != '.'
            gears.add([r + rr, c + cc]) if ch == '*'
          end
        end
      end
    elsif n > 0
      gears.each { |gear| nums[gear] << n }
      p1 += n if has_part
      n = 0
      has_part = false
      gears = Set.new
    end
  end
end

puts p1
p2 = 0
nums.each do |_k, v|
  p2 += v[0] * v[1] if v.length == 2
end
puts p2
