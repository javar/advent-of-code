require 'set'

# Read the input data
input_file = 'input.txt'
data = File.read(input_file).strip.split("\n\n")

warehouse_map = data[0].split("\n")
moves = data[1].gsub("\n", '')

# Helper methods
def add_t(pos, delta)
  [pos[0] + delta[0], pos[1] + delta[1]]
end

# Direction mapping
DIRS = {
  '>' => [0, 1],
  '<' => [0, -1],
  'v' => [1, 0],
  '^' => [-1, 0]
}

# Parse moves
move_directions = moves.chars.map { |m| DIRS[m] }

# Parse the map
walls = Set.new
boxes = Set.new
robot = nil

warehouse_map.each_with_index do |line, i|
  line.chars.each_with_index do |char, j|
    case char
    when '#'
      walls.add([i, j])
    when 'O'
      boxes.add([i, j])
    when '@'
      robot = [i, j]
    end
  end
end

# Method to push a box
def push(box, direction, walls, boxes)
  next_pos = add_t(box, direction)
  return false if walls.include?(next_pos)
  if boxes.include?(next_pos)
    return false unless push(next_pos, direction, walls, boxes)
  end
  boxes.delete(box)
  boxes.add(next_pos)
  true
end

# Process moves
move_directions.each do |move|
  next_pos = add_t(robot, move)
  if walls.include?(next_pos)
    next
  elsif boxes.include?(next_pos)
    next unless push(next_pos, move, walls, boxes)
  end
  robot = next_pos
end

# Calculate the GPS coordinate sum
gps_sum = boxes.sum { |box| box[0] * 100 + box[1] }
puts gps_sum
