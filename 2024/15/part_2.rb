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

def left(pos)
  [pos[0], pos[1] - 1]
end

def right(pos)
  [pos[0], pos[1] + 1]
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
    j *= 2
    case char
    when '#'
      walls.add([i, j])
      walls.add([i, j + 1])
    when 'O'
      boxes.add([i, j])
    when '@'
      robot = [i, j]
    end
  end
end

# Method to push a box
def push(box, direction, walls, boxes)
  raise 'Invalid state: box not found!' unless boxes.include?(box)

  next_pos = add_t(box, direction)
  return nil if walls.include?(next_pos) || walls.include?(right(next_pos))

  # Handle vertical movement (up/down)
  if direction[0] != 0
    if boxes.include?(next_pos) && push(next_pos, direction, walls, boxes).nil?
      return nil
    end
    if boxes.include?(left(next_pos)) && push(left(next_pos), direction, walls, boxes).nil?
      return nil
    end
    if boxes.include?(right(next_pos)) && push(right(next_pos), direction, walls, boxes).nil?
      return nil
    end
  end

  # Handle horizontal movement (left/right)
  if direction[1] == 1 && boxes.include?(right(next_pos)) && push(right(next_pos), direction, walls, boxes).nil?
    return nil
  end
  if direction[1] == -1 && boxes.include?(left(next_pos)) && push(left(next_pos), direction, walls, boxes).nil?
    return nil
  end

  boxes.delete(box)
  boxes.add(next_pos)
  true
end

# Process moves
move_directions.each do |move|
  boxes.each do |box|
    raise 'Invalid state: overlapping boxes!' if boxes.include?(right(box))
    raise 'Invalid state: box overlaps wall!' if walls.include?(right(box))
  end

  next_pos = add_t(robot, move)
  if walls.include?(next_pos)
    next
  elsif boxes.include?(next_pos)
    copy = boxes.dup
    unless push(next_pos, move, walls, boxes)
      boxes = copy
      next
    end
  elsif boxes.include?(left(next_pos))
    copy = boxes.dup
    unless push(left(next_pos), move, walls, boxes)
      boxes = copy
      next
    end
  end

  robot = next_pos
end

# Calculate the GPS coordinate sum
gps_sum = boxes.sum { |box| box[0] * 100 + box[1] }
puts gps_sum
