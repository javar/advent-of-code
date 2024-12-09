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
  
    # Process files in descending order of file ID
    files = layout.uniq.compact.sort.reverse
  
    files.each do |file_id|
      # Find current positions of the file
      file_positions = layout.each_index.select { |i| layout[i] == file_id }
      next if file_positions.empty?
  
      file_size = file_positions.size
  
      # Look for the leftmost span of free space that can fit the file
      best_free_span_start = nil
      free_span_start = nil
      free_span_length = 0
  
      layout.each_with_index do |block, index|
        if block.nil?
          free_span_start ||= index
          free_span_length += 1
        else
          free_span_start = nil
          free_span_length = 0
        end
  
        # Check if the free span fits the file
        if free_span_length == file_size && (free_span_start < file_positions.min)
          best_free_span_start = free_span_start
          break
        end
      end
  
      # If a valid span is found, move the file
      if best_free_span_start
        best_free_span_start.upto(best_free_span_start + file_size - 1) do |i|
          layout[i] = file_id
        end
        # Clear the file's original positions
        file_positions.each { |i| layout[i] = nil }
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
  