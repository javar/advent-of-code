# Initialize the grid
GRID_SIZE = 71  # Coordinates from 0 to 70 inclusive
grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, '.') }

# Read the byte positions from input
byte_positions = []

ARGF.each_line do |line|
  line.strip!
  next if line.empty?
  x_str, y_str = line.strip.split(',')
  x = x_str.to_i
  y = y_str.to_i
  byte_positions << [x, y]
end

require 'set'

start_pos = [0, 0]
end_pos = [GRID_SIZE - 1, GRID_SIZE - 1]

byte_positions.each do |x, y|
  # Mark the current byte position as corrupted
  grid[y][x] = '#'

  # Check if the starting or ending positions are corrupted
  if grid[start_pos[1]][start_pos[0]] == '#'
    puts "#{x},#{y}"
    exit(0)
  end
  if grid[end_pos[1]][end_pos[0]] == '#'
    puts "#{x},#{y}"
    exit(0)
  end

  # Perform BFS to check if a path exists
  visited = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, false) }
  queue = []
  queue << [start_pos[0], start_pos[1]]  # x, y
  visited[start_pos[1]][start_pos[0]] = true

  found = false

  while !queue.empty?
    cx, cy = queue.shift
    if cx == end_pos[0] && cy == end_pos[1]
      found = true
      break
    end

    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
      nx, ny = cx + dx, cy + dy
      if nx >= 0 && nx < GRID_SIZE && ny >= 0 && ny < GRID_SIZE &&
         !visited[ny][nx] && grid[ny][nx] != '#'
        visited[ny][nx] = true
        queue << [nx, ny]
      end
    end
  end

  unless found
    # Path is blocked by the current byte
    puts "#{x},#{y}"
    exit(0)
  end
end

puts "All bytes processed, exit still reachable."