require 'bigdecimal'

# Read and parse the input into configurations and prizes
def parse_input(file, offset = 0)
  File.read(file)
      .scan(/Button A: X\+(\d+), Y\+(\d+).Button B: X\+(\d+), Y\+(\d+).Prize: X=(\d+), Y=(\d+)/m)
      .map { |a_x, a_y, b_x, b_y, p_x, p_y|
        [
          [a_x.to_f, a_y.to_f],
          [b_x.to_f, b_y.to_f],
          [p_x.to_f + offset, p_y.to_f + offset]
        ]
      }
end

# Functions to solve for A and B button presses
def x_presses(a, b, p)
  (p[0] * b[1] - p[1] * b[0]) / (a[0] * b[1] - a[1] * b[0])
end

def y_presses(a, b, p)
  (p[0] * a[1] - p[1] * a[0]) / (b[0] * a[1] - b[1] * a[0])
end

# Calculate the minimum tokens for all machines
def calculate_minimum_tokens(file, offset = 0)
  parse_input(file, offset)
      .map do |a, b, p|
        x = x_presses(a, b, p)
        y = y_presses(a, b, p)
        next nil unless x == x.truncate && y == y.truncate

        (x * 3 + y).to_i
      end
      .compact
      .sum
end

# Input file
input_file = 'input.txt'

# Part 1
puts "The minimum tokens you would have to spend to win all possible prizes is: #{calculate_minimum_tokens(input_file).to_i}"

# Part 2
puts "The minimum tokens you would have to spend to win all possible prizes with offset is: #{calculate_minimum_tokens(input_file, 10_000_000_000_000).to_i}"
