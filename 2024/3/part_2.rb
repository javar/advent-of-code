# Load the input data
input = File.read('input.txt').strip

# Initialize state and result
mul_enabled = true
result_sum = 0

# Regex to parse instructions: do(), don't(), and mul(x,y)
instruction_regex = /do\(\)|don't\(\)|mul\((\d+),(\d+)\)/

# Parse and process the input
input.scan(instruction_regex) do |x, y|
  # Check the current match string
  case input[$~.begin(0), $~.end(0) - $~.begin(0)]
  when "do()"
    mul_enabled = true
  when "don't()"
    mul_enabled = false
  else
    # It's a mul(x, y) instruction
    if mul_enabled
      result_sum += x.to_i * y.to_i
    end
  end
end

# Output the result
puts "Sum of enabled multiplications: #{result_sum}"
