# Function to parse the disk map into files and free spaces
def parse_disk_map(disk_map)
    parsed = []
    disk_map.chars.each_slice(2) do |file, free|
      parsed << { type: :file, size: file.to_i } if file.to_i > 0
      parsed << { type: :free, size: free.to_i } if free.to_i > 0
    end
    parsed
  end
  
  # Function to compact the disk
  def compact_disk(disk_map)
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
  
    # Compact the layout
    left = 0
    right = layout.size - 1
  
    while left < right
      # Find the leftmost free space
      left += 1 while left < layout.size && !layout[left].nil?
  
      # Find the rightmost file block
      right -= 1 while right >= 0 && layout[right].nil?
  
      # Swap the free space and file block if valid
      if left < right
        layout[left], layout[right] = layout[right], layout[left]
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
  def process_disk_map(disk_map)
    compacted_layout = compact_disk(disk_map)
    calculate_checksum(compacted_layout)
  end
  
  # Read the input file
  input_file = 'input.txt'
  disk_map = File.read(input_file).strip
  
  # Calculate and print the checksum
  checksum = process_disk_map(disk_map)
  puts "The resulting filesystem checksum is: #{checksum}"
  