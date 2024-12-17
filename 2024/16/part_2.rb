require 'set'

# Read the maze input
maze = ARGF.each_line.map(&:chomp)

# Directions and their deltas
DIRECTIONS = {
  north: [-1, 0],
  east: [0, 1],
  south: [1, 0],
  west: [0, -1]
}

LEFT = {
  north: :west,
  west: :south,
  south: :east,
  east: :north
}

RIGHT = {
  north: :east,
  east: :south,
  south: :west,
  west: :north
}

ROWS = maze.size
COLS = maze[0].size

# Find the start and end positions
start_pos = nil
end_pos = nil

maze.each_with_index do |line, i|
  line.chars.each_with_index do |char, j|
    if char == 'S'
      start_pos = [i, j]
    elsif char == 'E'
      end_pos = [i, j]
    end
  end
end

if start_pos.nil? || end_pos.nil?
  puts "Start or End position not found!"
  exit(1)
end

# State representation: [x, y, facing]

# Initialize Dijkstra
require 'priority_queue'

state_cost = {}
state_predecessors = {}

# We'll use a simple array-based min-heap for the priority queue
class MinHeap
  def initialize
    @heap = []
  end

  def push(item, priority)
    @heap << [priority, item]
    @heap.sort_by! { |a| a[0] }
  end

  def pop
    return nil if @heap.empty?
    @heap.shift[1]
  end

  def empty?
    @heap.empty?
  end
end

queue = MinHeap.new
initial_state = [start_pos[0], start_pos[1], :east]
queue.push(initial_state, 0)
state_cost[[start_pos[0], start_pos[1], :east]] = 0
state_predecessors[[start_pos[0], start_pos[1], :east]] = []

visited = {}

while !queue.empty?
  current_state = queue.pop
  x, y, facing = current_state
  current_cost = state_cost[[x, y, facing]]

  # Avoid revisiting
  next if visited[[x, y, facing]]
  visited[[x, y, facing]] = true

  # Possible actions: move forward, rotate left, rotate right

  # Move forward
  dx, dy = DIRECTIONS[facing]
  nx, ny = x + dx, y + dy

  if nx >= 0 && nx < ROWS && ny >= 0 && ny < COLS
    cell = maze[nx][ny]
    if cell != '#'
      next_state = [nx, ny, facing]
      cost = current_cost + 1

      key = [nx, ny, facing]
      if !state_cost.key?(key) || cost < state_cost[key]
        state_cost[key] = cost
        state_predecessors[key] = [[x, y, facing]]
        queue.push(next_state, cost)
      elsif cost == state_cost[key]
        state_predecessors[key] << [x, y, facing]
      end
    end
  end

  # Rotate left
  new_facing = LEFT[facing]
  next_state = [x, y, new_facing]
  cost = current_cost + 1000

  key = [x, y, new_facing]
  if !state_cost.key?(key) || cost < state_cost[key]
    state_cost[key] = cost
    state_predecessors[key] = [[x, y, facing]]
    queue.push(next_state, cost)
  elsif cost == state_cost[key]
    state_predecessors[key] << [x, y, facing]
  end

  # Rotate right
  new_facing = RIGHT[facing]
  next_state = [x, y, new_facing]
  cost = current_cost + 1000

  key = [x, y, new_facing]
  if !state_cost.key?(key) || cost < state_cost[key]
    state_cost[key] = cost
    state_predecessors[key] = [[x, y, facing]]
    queue.push(next_state, cost)
  elsif cost == state_cost[key]
    state_predecessors[key] << [x, y, facing]
  end
end

# Now, backtrack from the end positions to find all tiles part of any minimal path

# End positions can be any facing at the end position
end_states = DIRECTIONS.keys.map { |facing| [end_pos[0], end_pos[1], facing] }

# Find minimal cost to reach any of the end states
min_end_cost = end_states.map { |state| state_cost[state] || Float::INFINITY }.min

# Collect all end states with minimal cost
min_end_states = end_states.select { |state| state_cost[state] == min_end_cost }

# Now perform reverse BFS from end states to collect all positions on minimal paths

tiles_on_min_paths = Set.new

queue = min_end_states.dup
visited_states = Set.new

while !queue.empty?
  state = queue.shift
  x, y, facing = state
  key = [x, y, facing]
  next if visited_states.include?(key)
  visited_states.add(key)
  tiles_on_min_paths.add([x, y])

  predecessors = state_predecessors[key] || []
  predecessors.each do |pred_state|
    queue << pred_state
  end
end

# Count the number of tiles
num_tiles = tiles_on_min_paths.size

puts num_tiles