require 'set'

# PriorityQueue Implementation
class PriorityQueue
  def initialize
    @queue = []
  end

  def push(item, priority)
    @queue << [item, priority]
    @queue.sort_by! { |_, prio| prio }
  end

  def delete_min
    @queue.shift
  end

  def empty?
    @queue.empty?
  end
end

# Define directions and their corresponding movements
DIRECTIONS = [:east, :south, :west, :north]
MOVES = {
  east:  [0, 1],
  south: [1, 0],
  west:  [0, -1],
  north: [-1, 0]
}

# Parse the input map
def parse_map(file)
  map = []
  start = nil
  goal = nil
  File.readlines(file).each_with_index do |line, row|
    map_row = line.chomp.chars
    map << map_row
    if col = map_row.index('S')
      start = [row, col]
    end
    if col = map_row.index('E')
      goal = [row, col]
    end
  end
  [map, start, goal]
end

# Check if a position is within the map bounds and not a wall
def valid_position?(map, position)
  row, col = position
  row.between?(0, map.size - 1) &&
    col.between?(0, map[0].size - 1) &&
    map[row][col] != '#'
end

# Find the minimum cost and all best path tiles
def find_best_path_tiles(map, start, goal)
  start_state = [start, :east]
  goal_state = [goal, nil] # We don't care about the final orientation

  # Priority queue to store [cost, [position, direction], path]
  queue = PriorityQueue.new
  queue.push([start_state, 0, Set.new([start])], 0)

  # Set to track visited states
  visited = {}

  # Track all best path tiles
  best_tiles = Set.new

  until queue.empty?
    (current_state, current_cost, current_path), _ = queue.delete_min
    current_position, current_direction = current_state

    # Skip if this state was already visited with a lower cost
    if visited[current_state] && visited[current_state] <= current_cost
      next
    end
    visited[current_state] = current_cost

    # If we reach the goal, record the path
    if current_position == goal
      best_tiles.merge(current_path)
      next
    end

    # Consider moving forward
    move = MOVES[current_direction]
    next_position = [current_position[0] + move[0], current_position[1] + move[1]]
    if valid_position?(map, next_position)
      next_state = [next_position, current_direction]
      next_path = current_path.dup.add(next_position)
      unless visited[next_state] && visited[next_state] <= current_cost + 1
        queue.push([next_state, current_cost + 1, next_path], current_cost + 1)
      end
    end

    # Consider rotating left and right
    [-1, 1].each do |rotation|
      next_direction = DIRECTIONS[(DIRECTIONS.index(current_direction) + rotation) % DIRECTIONS.size]
      next_state = [current_position, next_direction]
      unless visited[next_state] && visited[next_state] <= current_cost + 1000
        queue.push([next_state, current_cost + 1000, current_path.dup], current_cost + 1000)
      end
    end
  end

  best_tiles
end

# Main execution
if __FILE__ == $0
  map, start, goal = parse_map('sample_input.txt')
  if start.nil? || goal.nil?
    puts "Start or goal not found in the map."
  else
    best_tiles = find_best_path_tiles(map, start, goal)
    marked_map = map.map.with_index do |row, r|
      row.map.with_index { |tile, c| best_tiles.include?([r, c]) ? 'O' : tile }.join
    end

    puts "The number of tiles in the best paths: #{best_tiles.size}"
    puts "Map with best path tiles marked (O):"
    puts marked_map
  end
end
