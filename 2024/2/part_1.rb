# Read the input from a file
input = File.read('input.txt')

# Initialize a counter for safe reports
safe_reports_count = 0

# Process each line (report) in the input
input.each_line do |line|
  # Split the line into an array of integers representing levels
  levels = line.split.map(&:to_i)

  # Determine if the sequence is strictly increasing or decreasing
  increasing = levels.each_cons(2).all? { |a, b| b > a }
  decreasing = levels.each_cons(2).all? { |a, b| b < a }

  # Check if all adjacent differences are between 1 and 3
  valid_differences = levels.each_cons(2).all? { |a, b| (b - a).abs.between?(1, 3) }

  # A report is safe if it's monotonic and has valid differences
  if (increasing || decreasing) && valid_differences
    safe_reports_count += 1
  end
end

# Output the number of safe reports
puts safe_reports_count
