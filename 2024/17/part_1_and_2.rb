# Open file and parse integers using a regular expression
input_data = File.read('input.txt').scan(/\d+/).map(&:to_i)
a, b, c, *prog = input_data

def run(a, b, c, prog)
  i = 0
  result = []

  while i < prog.length
    # Use a local variable instead of a constant
    c_map = { 0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => a, 5 => b, 6 => c }

    cmd = prog[i]
    op = prog[i + 1]

    case cmd
    when 0 then a = a >> c_map[op]
    when 1 then b = b ^ op
    when 2 then b = 7 & c_map[op]
    when 3 then i = a != 0 ? op - 2 : i
    when 4 then b = b ^ c
    when 5 then result += [(c_map[op] & 7)]
    when 6 then b = a >> c_map[op]
    when 7 then c = a >> c_map[op]
    end

    i += 2
  end

  result
end

# Run the function and print results
puts run(a, b, c, prog).join(',')

# Main logic to iterate through values
todo = [[1, 0]]

todo.each do |i, a_start|
  (a_start...(a_start + 8)).each do |a|
    if run(a, 0, 0, prog) == prog[-i..-1]
      todo << [i + 1, a * 8]
      puts a if i == prog.size
    end
  end
end
