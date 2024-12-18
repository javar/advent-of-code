# Initialize the grid
GRID_SIZE = 71  # Coordinates from 0 to 70 inclusive
grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, '.') }

# Read the first 1024 bytes falling into the memory space
corrupted_positions = []

ARGF.each_line.with_index do |line, index|
  break if index >= 1024  # Only consider the first 1024 bytes

  line.strip!
  next if line.empty?
  x_str, y_str = line.strip.split(',')
  x = x_str.to_i
  y = y_str.to_i
  corrupted_positions << [x, y]
end

# Mark corrupted positions
corrupted_positions.each do |x, y|
  if x >= 0 && x < GRID_SIZE && y >= 0 && y < GRID_SIZE
    grid[y][x] = '#'  # Note: grid is accessed as [row][col], i.e., [y][x]
  end
end

# Check if start or end positions are corrupted
if grid[0][0] == '#'
  puts "Cannot reach exit: starting position is corrupted."
  exit(1)
end

if grid[GRID_SIZE - 1][GRID_SIZE - 1] == '#'
  puts "Cannot reach exit: exit position is corrupted."
  exit(1)
end

# Perform BFS to find the shortest path
require 'set'

start_pos = [0, 0]
end_pos = [GRID_SIZE - 1, GRID_SIZE - 1]

queue = []
queue << [start_pos[0], start_pos[1], 0]  # x, y, steps

visited = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, false) }
visited[start_pos[1]][start_pos[0]] = true

found = false
min_steps = nil

while !queue.empty?
  x, y, steps = queue.shift

  if x == end_pos[0] && y == end_pos[1]
    found = true
    min_steps = steps
    break
  end

  # Try moving in four directions
  [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
    nx, ny = x + dx, y + dy

    if nx >= 0 && nx < GRID_SIZE && ny >= 0 && ny < GRID_SIZE &&
       !visited[ny][nx] && grid[ny][nx] != '#'
      visited[ny][nx] = true
      queue << [nx, ny, steps + 1]
    end
  end
end

if found
  puts min_steps
else
  puts "Cannot reach exit: No path found."
end