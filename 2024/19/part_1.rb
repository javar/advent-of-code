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

# Function to check if a design can be formed using the towel patterns
def can_form_design(design, towel_patterns_set)
  n = design.length
  dp = Array.new(n + 1, false)
  dp[0] = true  # Empty string can be formed

  for i in 1..n
    for j in 0...i
      if dp[j] && towel_patterns_set.include?(design[j...i])
        dp[i] = true
        break
      end
    end
  end

  dp[n]
end

# For each design, check if it can be formed
possible_designs_count = 0

designs.each do |design|
  if can_form_design(design, towel_patterns_set)
    possible_designs_count += 1
  end
end

puts possible_designs_count