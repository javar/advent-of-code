# Function to calculate the number of stones after blinking using growth tracking
def calculate_stone_count(stones, blinks)
    # Memoization for fast computation of stone growth
    growth_cache = {}
  
    # Function to calculate growth for a single stone
    calculate_growth = lambda do |stone, remaining_blinks|
      return 1 if remaining_blinks == 0 # Base case: 1 stone remains without blinks
  
      key = [stone, remaining_blinks]
      return growth_cache[key] if growth_cache.key?(key)
  
      if stone == 0
        result = calculate_growth.call(1, remaining_blinks - 1)
      elsif stone.digits.size.even?
        mid = stone.digits.size / 2
        left = stone.digits.reverse[0...mid].join.to_i
        right = stone.digits.reverse[mid..].join.to_i
        result = calculate_growth.call(left, remaining_blinks - 1) +
                 calculate_growth.call(right, remaining_blinks - 1)
      else
        result = calculate_growth.call(stone * 2024, remaining_blinks - 1)
      end
  
      growth_cache[key] = result
    end
  
    # Sum the growth for all initial stones
    stones.sum { |stone| calculate_growth.call(stone, blinks) }
  end
  
  # Read the input file
  input_file = 'input.txt'
  initial_stones = File.read(input_file).strip.split.map(&:to_i)
  
  # Number of blinks for Part Two
  blinks = 75
  
  # Calculate the total number of stones after 75 blinks
  total_stones = calculate_stone_count(initial_stones, blinks)
  
  # Output the result
  puts "Number of stones after #{blinks} blinks: #{total_stones}"
  