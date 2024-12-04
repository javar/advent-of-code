def count_x_mas_patterns(file_path)
    # Read the file and split into grid lines
    grid = File.readlines(file_path).map { |line| line.strip.chars }
  
    rows = grid.size
    cols = grid[0].size
    count = 0
  
    # Iterate over the grid
    (0...rows).each do |i|
      (0...cols).each do |j|
        next unless grid[i][j] == 'A' # The center must be 'A'
  
        # Ensure top and bottom rows exist
        if i > 0 && i < rows - 1
          # Get top and bottom diagonals
          top = (grid[i - 1][j - 1].to_s + grid[i - 1][j + 1].to_s)
          bot = (grid[i + 1][j - 1].to_s + grid[i + 1][j + 1].to_s)
  
          # Check all valid X-MAS patterns
          if (top == "MS" && bot == "MS") || 
             (top == "SM" && bot == "SM") || 
             (top == "SS" && bot == "MM") || 
             (top == "MM" && bot == "SS")
            count += 1
          end
        end
      end
    end
  
    count
  end
  
  file_path = "input.txt"
  result = count_x_mas_patterns(file_path)
  puts "Number of X-MAS patterns: #{result}"
  