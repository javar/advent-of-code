# Using `parallel` gem for processing to speed up the computation of obstruction positions
require 'set'
require 'parallel'

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

# Simulate the guard's patrol and check for loops
def simulate_patrol(map, start_position, start_direction)
  directions = ['^', '>', 'v', '<']
  moves = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }
  visited_states = Set.new
  position = start_position.dup
  direction = start_direction

  loop do
    state = [position, direction]
    return true if visited_states.include?(state) # Loop detected
    visited_states.add(state)

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
    end
  end

  false
end

# Precompute reachable positions from the guard's start
def compute_reachable_positions(map, start_position, start_direction)
  directions = ['^', '>', 'v', '<']
  moves = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }
  visited = Set.new
  queue = [[start_position, start_direction]]

  until queue.empty?
    position, direction = queue.shift
    next if visited.include?([position, direction])
    visited.add([position, direction])

    dr, dc = moves[direction]
    next_position = [position[0] + dr, position[1] + dc]

    # Check if the guard leaves the map
    next if next_position[0] < 0 || next_position[0] >= map.size ||
            next_position[1] < 0 || next_position[1] >= map[0].size

    # Check for obstacles
    if map[next_position[0]][next_position[1]] == '#'
      new_direction = directions[(directions.index(direction) + 1) % 4]
      queue << [position, new_direction]
    else
      queue << [next_position, direction]
    end
  end

  visited.map(&:first).to_set
end

# Parallel simulation of obstruction positions
def find_obstruction_positions(map, start_position, start_direction)
  reachable_positions = compute_reachable_positions(map, start_position, start_direction).to_a
  valid_positions = Parallel.map(reachable_positions, in_threads: 4) do |position|
    next if position == start_position # Exclude guard's starting position

    # Work on a copy of the map to ensure thread safety
    local_map = map.map(&:dup)
    next unless local_map[position[0]][position[1]] == '.' # Consider only empty spaces

    # Temporarily place obstruction and simulate
    local_map[position[0]][position[1]] = '#'
    loop_detected = simulate_patrol(local_map, start_position, start_direction)
    position if loop_detected
  end

  valid_positions.compact.size
end

# Main function
def guard_obstruction_positions(map)
  parsed_map, start_position, start_direction = parse_map(map)
  find_obstruction_positions(parsed_map, start_position, start_direction)
end

# Read the input map from a file
def read_map_from_file(file_path)
  File.readlines(file_path).map(&:chomp)
end

# Main execution
file_path = 'input.txt'
map = read_map_from_file(file_path)
result = guard_obstruction_positions(map)
puts "The number of positions where the guard gets stuck in a loop is: #{result}"
