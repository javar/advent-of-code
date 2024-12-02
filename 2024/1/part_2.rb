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

# Count occurrences of each number in the right list
right_count = Hash.new(0)
right_list.each { |num| right_count[num] += 1 }

# Calculate the similarity score
similarity_score = left_list.sum { |num| num * right_count[num] }

# Output the result
puts similarity_score
