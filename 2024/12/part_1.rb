require 'set'

# Function to calculate the area and perimeter of a region using BFS
def calculate_area_and_perimeter(grid, visited, start, plant_type)
  directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  queue = [start]
  visited.add(start)
  area = 0
  perimeter = 0

  while !queue.empty?
    x, y = queue.shift
    area += 1

    directions.each do |dx, dy|
      nx, ny = x + dx, y + dy

      if nx < 0 || ny < 0 || ny >= grid.size || nx >= grid[0].size
        # Out of bounds contributes to perimeter
        perimeter += 1
      elsif grid[ny][nx] != plant_type
        # Neighboring a different plant type contributes to perimeter
        perimeter += 1
      elsif !visited.include?([nx, ny])
        # Same plant type and not visited
        visited.add([nx, ny])
        queue << [nx, ny]
      end
    end
  end

  [area, perimeter]
end

# Function to calculate the total price of fencing all regions
def calculate_total_price(grid)
  visited = Set.new
  total_price = 0

  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if visited.include?([x, y]) # Skip already visited cells

      # Calculate area and perimeter for the region
      area, perimeter = calculate_area_and_perimeter(grid, visited, [x, y], cell)

      # Add the price of this region to the total
      total_price += area * perimeter
    end
  end

  total_price
end

# Parse the input grid
def parse_grid(input)
  input.lines.map { |line| line.chomp.chars }
end

# Read the input file
input_file = 'input.txt'
grid = parse_grid(File.read(input_file).strip)

# Calculate the total price
total_price = calculate_total_price(grid)
puts "The total price of fencing all regions is: #{total_price}"
