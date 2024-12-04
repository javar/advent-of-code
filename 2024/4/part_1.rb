
def count_xmas_occurrences(grid)
    rows = grid.length
    cols = grid[0].length
    word = "XMAS"
    word_len = word.length
    count = 0
  
    # Helper to check if a word exists starting from (r, c) in a given direction
    def check_direction(grid, r, c, dr, dc, word)
      word_len = word.length
      rows = grid.length
      cols = grid[0].length
  
      word_len.times do |i|
        nr = r + dr * i
        nc = c + dc * i
        return false if nr < 0 || nr >= rows || nc < 0 || nc >= cols || grid[nr][nc] != word[i]
      end
      true
    end
  
    # Check all directions for each cell in the grid
    rows.times do |r|
      cols.times do |c|
        # Horizontal: left-to-right (dr=0, dc=1), right-to-left (dr=0, dc=-1)
        count += 1 if check_direction(grid, r, c, 0, 1, word)
        count += 1 if check_direction(grid, r, c, 0, -1, word)
        # Vertical: top-to-bottom (dr=1, dc=0), bottom-to-top (dr=-1, dc=0)
        count += 1 if check_direction(grid, r, c, 1, 0, word)
        count += 1 if check_direction(grid, r, c, -1, 0, word)
        # Diagonal: top-left to bottom-right (dr=1, dc=1), bottom-right to top-left (dr=-1, dc=-1)
        count += 1 if check_direction(grid, r, c, 1, 1, word)
        count += 1 if check_direction(grid, r, c, -1, -1, word)
        # Diagonal: top-right to bottom-left (dr=1, dc=-1), bottom-left to top-right (dr=-1, dc=1)
        count += 1 if check_direction(grid, r, c, 1, -1, word)
        count += 1 if check_direction(grid, r, c, -1, 1, word)
      end
    end
  
    count
  end
  
  # Read the input data from a local file
  grid = File.readlines("input.txt", chomp: true)
  
  # Call the function and print the result
  result = count_xmas_occurrences(grid)
  puts "Total occurrences of XMAS: #{result}"
  