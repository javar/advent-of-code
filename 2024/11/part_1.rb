# Function to simulate the blinking process
def blink_stones(stones, blinks)
    blinks.times do
      stones = stones.flat_map do |stone|
        if stone == 0
          [1]
        elsif stone.digits.size.even?
          mid = stone.digits.size / 2
          left = stone.digits.reverse[0...mid].join.to_i
          right = stone.digits.reverse[mid..].join.to_i
          [left, right]
        else
          [stone * 2024]
        end
      end
    end
    stones
  end
  
  # Read the input file
  input_file = 'input.txt'
  initial_stones = File.read(input_file).strip.split.map(&:to_i)
  
  # Number of blinks
  blinks = 25
  
  # Simulate the process
  final_stones = blink_stones(initial_stones, blinks)
  
  # Output the number of stones after 25 blinks
  puts "Number of stones after #{blinks} blinks: #{final_stones.size}"
  