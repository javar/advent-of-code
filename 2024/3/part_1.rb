# Read the input from a file
input = File.read('input.txt')

# Initialize a sum to accumulate the results
total_sum = 0

# Define a regular expression to match valid 'mul(X,Y)' patterns
regex = /mul\(\s*(\d+)\s*,\s*(\d+)\s*\)/

# Scan the input for all matches of the regex
input.scan(regex) do |x, y|
  # Convert the captured strings to integers and compute their product
  product = x.to_i * y.to_i
  # Add the product to the total sum
  total_sum += product
end

# Output the total sum
puts total_sum
