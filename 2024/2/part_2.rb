# Read the input from a file
input = File.read('input.txt')

# Initialize a counter for safe reports
safe_reports_count = 0

# Helper method to check if a sequence is safe
def safe?(levels)
  # Determine if the sequence is strictly increasing or decreasing
  increasing = levels.each_cons(2).all? { |a, b| b > a }
  decreasing = levels.each_cons(2).all? { |a, b| b < a }

  # Check if all adjacent differences are between 1 and 3
  valid_differences = levels.each_cons(2).all? { |a, b| (b - a).abs.between?(1, 3) }

  # A sequence is safe if it's monotonic and has valid differences
  (increasing || decreasing) && valid_differences
end

# Process each line (report) in the input
input.each_line do |line|
  # Split the line into an array of integers representing levels
  levels = line.split.map(&:to_i)

  # Check if the report is safe without removing any levels
  if safe?(levels)
    safe_reports_count += 1
    next
  end

  # Check if removing one level can make the report safe
  levels.each_with_index do |_, index|
    modified_levels = levels[0...index] + levels[index + 1..]
    if safe?(modified_levels)
      safe_reports_count += 1
      break
    end
  end
end

# Output the number of safe reports
puts safe_reports_count
