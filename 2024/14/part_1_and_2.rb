class RobotSimulation
    LOBBY_WIDTH = 101
    LOBBY_HEIGHT = 103
  
    def load_input
      File.readlines(File.join(__dir__, "input.txt"))
    end
  
    def parse_robot_attributes
      @robot_attributes ||= load_input.map do |line|
        line.scan(/-?\d+/).map(&:to_i)
      end
    end
  
    class Robot
      attr_reader :x_velocity, :y_velocity
      attr_accessor :x_position, :y_position
  
      def initialize(x_position, y_position, x_velocity, y_velocity)
        @x_position = x_position
        @y_position = y_position
        @x_velocity = x_velocity
        @y_velocity = y_velocity
      end
  
      def move(steps)
        @x_position = (@x_position + (@x_velocity * steps)) % LOBBY_WIDTH
        @y_position = (@y_position + (@y_velocity * steps)) % LOBBY_HEIGHT
      end
    end
  
    def robots
      @robots ||= parse_robot_attributes.map do |attributes|
        Robot.new(*attributes)
      end
    end
  
    def calculate_danger_level
      top_left = robots.count { |robot| robot.x_position < LOBBY_WIDTH / 2 && robot.y_position < LOBBY_HEIGHT / 2 }
      top_right = robots.count { |robot| robot.x_position >= LOBBY_WIDTH / 2 && robot.y_position < LOBBY_HEIGHT / 2 }
      bottom_left = robots.count { |robot| robot.x_position < LOBBY_WIDTH / 2 && robot.y_position >= LOBBY_HEIGHT / 2 }
      bottom_right = robots.count { |robot| robot.x_position >= LOBBY_WIDTH / 2 && robot.y_position >= LOBBY_HEIGHT / 2 }
  
      [top_left, top_right, bottom_left, bottom_right].reduce(1, :*)
    end
  
    def solve_part1
      reset_robots
      robots.each { |robot| robot.move(100) }
      calculate_danger_level
    end
  
    def solve_part2
      reset_robots
      minimum_danger_level = calculate_danger_level
      minimum_danger_step = 0
  
      (1..(LOBBY_WIDTH * LOBBY_HEIGHT)).each do |step|
        robots.each { |robot| robot.move(1) }
        current_danger_level = calculate_danger_level
  
        if current_danger_level < minimum_danger_level
          minimum_danger_level = current_danger_level
          minimum_danger_step = step
        end
      end
  
      minimum_danger_step
    end
  
    def reset_robots
      @robots = nil
    end
  
    def display_solutions
      part1_result = solve_part1
      puts "Part 1 Result: #{part1_result}"
  
      part2_result = solve_part2
      puts "Part 2 Result: #{part2_result}"
    end
  end
  
  # Execute the simulation
  RobotSimulation.new.display_solutions
  