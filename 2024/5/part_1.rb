input = File.read('input.txt').split("\n")

# Separate ordering rules and updates
ordering_rules = []
updates = []
parsing_rules = true

input.each do |line|
  if line.strip.empty?
    parsing_rules = false
    next
  end

  if parsing_rules
    ordering_rules << line
  else
    updates << line.split(',').map(&:to_i)
  end
end

# Parse the ordering rules into a hash for easy lookup
rules = {}
ordering_rules.each do |rule|
  x, y = rule.split('|').map(&:to_i)
  rules[x] ||= []
  rules[x] << y
end

# Function to check if an update is in the correct order
def valid_order?(update, rules)
  # Map page number to its position in the update
  positions = update.each_with_index.to_h
  rules.each do |x, ys|
    # Skip if the page x is not in the update
    next unless positions.key?(x) 
    ys.each do |y|
      # Skip if the page y is not in the update
      next unless positions.key?(y) 
      # Rule is violated
      return false if positions[x] > positions[y] 
    end
  end
  true
end

# Filter valid updates and calculate their middle page number
valid_updates = updates.select { |update| valid_order?(update, rules) }
middle_pages = valid_updates.map { |update| update[update.size / 2] }

# Calculate the sum of middle pages
result = middle_pages.sum

# Output the result
puts "The sum of the middle page numbers is: #{result}"
