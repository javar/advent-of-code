# Function to parse the disk map into files and free spaces
def parse_disk_map(disk_map)
    parsed = []
    disk_map.chars.each_slice(2) do |file, free|
      parsed << { type: :file, size: file.to_i } if file.to_i > 0
      parsed << { type: :free, size: free.to_i } if free.to_i > 0
    end
    parsed
  end
  
  # Function to compact the disk by moving whole files
  def compact_disk_part_two(disk_map)
    parsed = parse_disk_map(disk_map)
    layout = []
  
    # Generate initial layout
    file_id = 0
    parsed.each do |segment|
      if segment[:type] == :file
        layout.concat([file_id] * segment[:size])
        file_id += 1
      else
        layout.concat([nil] * segment[:size])
      end
    end
  
    # Identify initial free spans
    free_spans = []
    span_start = nil
  
    layout.each_with_index do |block, index|
      if block.nil?
        span_start ||= index
      else
        if span_start
          free_spans << [span_start, index - span_start]
          span_start = nil
        end
      end
    end
    # Add the last free span if it exists
    free_spans << [span_start, layout.size - span_start] if span_start
  
    # Sort spans for efficient leftmost span selection
    free_spans.sort_by!(&:first)
  
    # Process files in descending order of file ID
    files = layout.uniq.compact.sort.reverse
  
    files.each do |file_id|
      # Find current positions of the file
      file_positions = layout.each_index.select { |i| layout[i] == file_id }
      next if file_positions.empty?
  
      file_size = file_positions.size
      file_start = file_positions.min
  
      # Find the leftmost span that can fit the file
      target_span_index = free_spans.find_index { |start, length| length >= file_size && start < file_start }
      next unless target_span_index
  
      target_start, target_length = free_spans[target_span_index]
  
      # Move the file to the target span
      target_start.upto(target_start + file_size - 1) do |i|
        layout[i] = file_id
      end
  
      # Clear the file's original positions
      file_positions.each { |i| layout[i] = nil }
  
      # Update the free span
      if target_length == file_size
        free_spans.delete_at(target_span_index)
      else
        free_spans[target_span_index] = [target_start + file_size, target_length - file_size]
      end
  
      # Merge free spans
      if target_span_index > 0 && free_spans[target_span_index - 1][0] + free_spans[target_span_index - 1][1] == target_start
        free_spans[target_span_index - 1][1] += free_spans[target_span_index][1]
        free_spans.delete_at(target_span_index)
      end
      if target_span_index < free_spans.size - 1 && target_start + file_size == free_spans[target_span_index + 1][0]
        free_spans[target_span_index][1] += free_spans[target_span_index + 1][1]
        free_spans.delete_at(target_span_index + 1)
      end
    end
  
    layout
  end
  
  # Function to calculate the checksum
  def calculate_checksum(compacted_layout)
    compacted_layout.each_with_index.sum do |file_id, position|
      file_id.nil? ? 0 : file_id * position
    end
  end
  
  # Main function to process the disk map and calculate the checksum
  def process_disk_map_part_two(disk_map)
    compacted_layout = compact_disk_part_two(disk_map)
    calculate_checksum(compacted_layout)
  end
  
  # Read the input file
  input_file = 'input.txt'
  disk_map = File.read(input_file).strip
  
  # Calculate and print the checksum for Part Two
  checksum = process_disk_map_part_two(disk_map)
  puts "The resulting filesystem checksum is: #{checksum}"
  