# Parse the ordering rules into a hash for easy lookup
def parse_rules(ordering_rules)
    rules = {}
    ordering_rules.each do |rule|
      x, y = rule.split('|').map(&:to_i)
      rules[x] ||= []
      rules[x] << y
    end
    rules
  end
  
  # Check if an update is in the correct order
  def valid_order?(update, rules)
    positions = update.each_with_index.to_h
    rules.each do |x, ys|
      next unless positions.key?(x)
      ys.each do |y|
        next unless positions.key?(y)
        return false if positions[x] > positions[y]
      end
    end
    true
  end
  
  # Correct the order of an update based on the rules
  def correct_order(update, rules)
    result = []
    remaining = update.dup
    until remaining.empty?
      # Find the next page that has no remaining dependencies
      next_page = remaining.find do |page|
        rules[page].to_a.all? { |dependent| !remaining.include?(dependent) }
      end
      result << next_page
      remaining.delete(next_page)
    end
    result
  end
  
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
  
  # Parse rules
  rules = parse_rules(ordering_rules)
  
  # Separate valid and invalid updates
  valid_updates = []
  invalid_updates = []
  
  updates.each do |update|
    if valid_order?(update, rules)
      valid_updates << update
    else
      invalid_updates << update
    end
  end
  
  # Correct invalid updates
  corrected_updates = invalid_updates.map { |update| correct_order(update, rules) }
  
  # Calculate middle pages for corrected updates
  middle_pages = corrected_updates.map { |update| update[update.size / 2] }
  
  # Sum the middle pages
  result = middle_pages.sum
  
  # Output the result
  puts "The sum of the middle page numbers is: #{result}"
  