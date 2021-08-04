# frozen_string_literal: true

require 'tty-prompt'

require_relative('./models/route')
require_relative('./models/train')
require_relative('./models/station')

# starting_station = Station.new('starting_station')
# end_station = Station.new('end_station')

# second_station = Station.new('second_station')
# third_station = Station.new('third_station')
# fourth_station = Station.new('4th_station')

# route = Route.new(starting_station, end_station)

# # p route
# # p route.starting_station
# # p route.end_station
# # p route.intermediate_stations

# route.intermediate_stations = second_station
# route.intermediate_stations = third_station
# # route.intermediate_stations = fourth_station
# # p route.intermediate_stations
# # route.delete_intermediate_station(third_station)
# # p route.intermediate_stations

# train = Train.new('aa111', :cargo, 33)
# # p train
# # p train.number
# # p train.type
# # p train.wagons_amount
# train.change_wagon_amount(-1)
# # p train.wagons_amount
# # p train.speed

# # train.speed = 10
# # train.change_wagon_amount(-1)

# # p train.speed
# train.stop
# # p train.speed
# train.change_wagon_amount(-1)
# # p train.wagons_amount

# train.route = route
# # p train.route

# p train.current_station
# # binding.irb
# # p train.next_station
# p '========'
# # binding.irb
# # p train.move(:forward)
# # p '========'
# train.move(:forward)
# # p train.current_station
# # p train.next_station
# # train.move(:forward)
# # train.move(:forward)
# # train.move(:backwards)
# # train.move(:backwards)
# train.move(:backwards)
# p '========'
# # p train.previous_station

# p train.current_station
# # p train.next_station
# # binding.irb

@stations = []

def find_station(station_name)
  @stations.find { |station| station if station.name == station_name }
end

def check_station(station)
  if @route.starting_station == find_station(station)
    true
  elsif @route.end_station == find_station(station)
    return true
    binding.irb
  else
    @route.intermediate_stations.include?(find_station(station))
  end
end

def add_intermediate_stations
  if @route.nil?
    p 'Create route first'
  else
    intermediate_stations = @prompt.multi_select('Select intermediate stations: ',
                                                 create_stations_menu)
    intermediate_stations.each do |intermediate_station|
      if check_station(intermediate_station)
        p 'Choose another stations!'
        p 'These stations are already on the route!'
      else

        @route.intermediate_stations = find_station(intermediate_station)
        break
      end
    end
  end
end

def show_route
  if @route.nil?
    p 'Create route first'
  else
    p @route.stations
  end
end

def create_stations_menu
  station_names = []
  @stations.each { |station| station_names << station.name }
  station_names
end

def create_station
  name = @prompt.ask('Enter station name:')
  @stations << Station.new(name)
end

def create_route
  if @stations.empty? || @stations.size == 1
    p 'Create at least TWO stations first'
  else
    start_end_stations = []
    loop do
      start_end_stations = @prompt.multi_select('Select the start and end station: ',
                                                create_stations_menu)
      if start_end_stations.size == 2
        break
      else
        p 'Choose TWO stations'
      end
    end
    @route = Route.new(find_station(start_end_stations.first),
                       find_station(start_end_stations.last))
  end
end

@prompt = TTY::Prompt.new

loop do
  cmd = @prompt.select('Select an action: ', per_page: 9) do |menu|
    menu.choice 'Create station', 1
    menu.choice 'Create train', 2, disabled: ''
    menu.choice 'Create route', 3
    menu.choice 'Add intermediate stations to route', 4
    menu.choice 'Assign a train route', 5, disabled: ''
    menu.choice 'Manipulations with wagons', 6, disabled: ''
    menu.choice 'Move train', 7, disabled: ''
    menu.choice 'Show route and trains', 8
    menu.choice 'Exit', 9
  end

  case cmd
  when 1
    create_station
  when 2
    create_train
  when 3
    create_route
  when 4
    add_intermediate_stations
  when 8
    show_route
  when 9
    break if @prompt.yes?('Do you really want to exit?')
  end
end
