#!/usr/bin/env ruby

# Read the input
input_lines = ARGF.readlines.map(&:chomp)

# Separate towel patterns and designs
towel_patterns_line = input_lines.shift
towel_patterns = towel_patterns_line.split(',').map(&:strip)

# Skip blank lines
input_lines.shift while input_lines.first.strip.empty?

designs = input_lines.reject { |line| line.strip.empty? }

# Create a Set for the towel patterns for efficient lookup
require 'set'
towel_patterns_set = Set.new(towel_patterns)

# Function to count the number of ways to form a design
def count_ways(design, towel_patterns_set)
  n = design.length
  dp = Array.new(n + 1, 0)
  dp[0] = 1  # Empty string can be formed in 1 way

  for i in 1..n
    for j in 0...i
      if towel_patterns_set.include?(design[j...i])
        dp[i] += dp[j]
      end
    end
  end

  dp[n]
end

# For each design, count the number of ways it can be formed
total_ways = 0

designs.each do |design|
  ways = count_ways(design, towel_patterns_set)
  total_ways += ways
end

puts total_ways