# Read the input from a file
input = File.read('input.txt')

# Initialize arrays to hold the two lists
left_list = []
right_list = []

# Parse the input
input.each_line do |line|
  left, right = line.split.map(&:to_i)
  left_list << left
  right_list << right
end

# Sort both lists
left_list.sort!
right_list.sort!

# Calculate the total distance
total_distance = left_list.zip(right_list).sum { |left, right| (left - right).abs }

# Output the result
puts total_distance
