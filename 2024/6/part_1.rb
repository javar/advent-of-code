require 'set'

map = File.readlines('input.txt', chomp: true)

# Parse the input map to find the guard's initial position and direction
def parse_map(map)
  directions = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }
  guard_position = nil
  guard_direction = nil

  map.each_with_index do |row, r|
    row.chars.each_with_index do |cell, c|
      if directions.key?(cell)
        guard_position = [r, c]
        guard_direction = cell
        map[r][c] = '.' # Replace guard symbol with empty space
        break
      end
    end
    break if guard_position
  end

  [map, guard_position, guard_direction]
end

# Simulate the guard's patrol based on the rules
def simulate_patrol(map, start_position, start_direction)
  directions = ['^', '>', 'v', '<'] # Clockwise order of directions
  moves = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }
  visited_positions = Set.new
  position = start_position.dup
  direction = start_direction

  visited_positions.add(position)

  loop do
    dr, dc = moves[direction]
    next_position = [position[0] + dr, position[1] + dc]

    # Check if the guard leaves the map
    if next_position[0] < 0 || next_position[0] >= map.size ||
       next_position[1] < 0 || next_position[1] >= map[0].size
      break
    end

    # Check for obstacles
    if map[next_position[0]][next_position[1]] == '#'
      # Turn right (90 degrees)
      direction = directions[(directions.index(direction) + 1) % 4]
    else
      # Move forward
      position = next_position
      visited_positions.add(position)
    end
  end

  visited_positions
end

# Main function to execute the patrol simulation
def guard_patrol(map)
  parsed_map, start_position, start_direction = parse_map(map)
  visited_positions = simulate_patrol(parsed_map, start_position, start_direction)
  visited_positions.size
end

# Execute the patrol simulation and output the result
result = guard_patrol(map)
puts "The number of distinct positions visited by the guard is: #{result}"
