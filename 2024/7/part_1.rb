# Function to evaluate all combinations of operators
def evaluate_combinations(target, numbers)
    operators = %w[+ *]
    n = numbers.size
  
    # Generate all combinations of operators
    operator_combinations = (operators.repeated_permutation(n - 1)).to_a
  
    # Evaluate each combination
    operator_combinations.each do |ops|
      # Start with the first number
      result = numbers[0]
  
      # Apply operators left-to-right
      numbers[1..].each_with_index do |num, index|
        result = result.send(ops[index], num)
      end
  
      # Check if result matches the target
      return true if result == target
    end
  
    # No combination matched
    false
  end
  
  # Function to process the input and calculate the total calibration result
  def total_calibration_result(input)
    total = 0
  
    input.each do |line|
      # Parse the line into target and numbers
      target, *numbers = line.scan(/\d+/).map(&:to_i)
  
      # Check if any combination of operators matches the target
      if evaluate_combinations(target, numbers)
        total += target
      end
    end
  
    total
  end
  
  # Read the input map
  def read_input_file(file_path)
    File.readlines(file_path).map(&:chomp)
  end
  
  # Main execution
  file_path = 'input.txt'
  input = read_input_file(file_path)
  result = total_calibration_result(input)
  puts "The total calibration result is: #{result}"
  