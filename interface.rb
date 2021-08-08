# frozen_string_literal: true

require 'tty-prompt'

require_relative('./models/route')
require_relative('./models/station')
require_relative('./models/cargo_train')
require_relative('./models/cargo_wagon')
require_relative('./models/passenger_train')
require_relative('./models/passenger_wagon')

class Interface
  def initialize
    @stations = []
    @trains = []
  end

  def start
    @prompt = TTY::Prompt.new
    menu_loop
  end

  private

  def find_station(station_name)
    @stations.find { |station| station if station.name == station_name }
  end

  def check_station(station)
    @route.starting_station == find_station(station) ||
      @route.end_station == find_station(station) ||
      @route.intermediate_stations.include?(find_station(station))
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

  def create_trains_menu
    train_numbers = []
    @trains.each { |train| train_numbers << train.number }
    train_numbers
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

  def create_train
    types = %w[cargo passenger]
    type = @prompt.select('Choose train type: ', types)
    case type
    when 'cargo'
      @trains << CargoTrain.new(@prompt.ask('Please, enter train number: '))
    when 'passenger'
      @trains << PassengerTrain.new(@prompt.ask('Please, enter train number: '))
    end
  end

  def find_train(train_number)
    @trains.find { |train| train if train.number == train_number }
  end

  def assign_route
    if @route.nil?
      p 'Create route first'
    elsif @trains.empty?
      p 'Create at least one train first'
    else
      train = @prompt.select('Select train to assign Route: ', create_trains_menu)
      find_train(train).route = @route
    end
  end

  def move(train)
    directions = %i[forward backwards]
    direction = @prompt.select('Choose direction: ', directions)
    case direction
    when :forward
      train.move(:forward)
    when :backwards
      train.move(:backwards)
    end
  end

  def move_train
    if @trains.empty?
      p 'Create at least one train first'
    else
      train = @prompt.select('Select train first: ', create_trains_menu)
      choices = ['change speed', 'stop', 'move']
      case @prompt.select('Select option: ', choices)
      when 'change speed'
        find_train(train).speed = @prompt.ask('Enter speed > 0:').to_i
      when 'stop'
        find_train(train).stop
      when 'move'
        move(find_train(train))
      end
    end
  end

  def find_wagon(train, wagon_number)
    train.wagons.find { |wagon| wagon if wagon.number == wagon_number }
  end

  def add_remove_wagons
    if @trains.empty?
      p 'Create at least one train first'
    else

      train = @prompt.select('Select train first: ', create_trains_menu)
      if find_train(train).speed.positive?
        p 'Stop the train first!'
      else

        choices = ['add wagon', 'delete wagon']
        wagon_number = @prompt.ask('Enter wagon number: ')
        case @prompt.select('Select option: ', choices)

        when 'add wagon'

          if find_train(train).type == :cargo
            find_train(train).add_wagon(CargoWagon.new(wagon_number))
          else
            find_train(train).add_wagon(PassengerWagon.new(wagon_number))
          end
        when 'delete wagon'
          find_train(train).delete_wagon(find_wagon(find_train(train), wagon_number))
        end
      end
    end
  end

  def add_manufacturer
    choise = @prompt.select("Choose wagons or trains: ", %w(wagons trains))

    case choise
    when 'wagons'
    when 'trains'
      train = @prompt.select('Select train first: ', create_trains_menu)
      find_train(train).manufacturer = @prompt.ask('Enter manufacturer: ')
    end
  end

  def make_choice
    @prompt.select('Select an action: ', per_page: 10) do |menu|
      menu.choice 'Create station', 1
      menu.choice 'Create train', 2
      menu.choice 'Create route', 3
      menu.choice 'Add intermediate stations to route', 4
      menu.choice 'Assign a train route', 5
      menu.choice 'Manipulations with wagons', 6
      menu.choice 'SpeedUp/SpeedDown/Move train', 7
      menu.choice 'Show route and trains', 8
      menu.choice 'Add manufacturer', 9
      menu.choice 'Exit', 10
    end
  end

  def menu_loop
    loop do
      case make_choice
      when 1
        create_station
      when 2
        create_train
        p @trains
      when 3
        create_route
      when 4
        add_intermediate_stations
      when 5
        assign_route
      when 6
        add_remove_wagons
      when 7
        move_train
      when 8
        show_route
      when 9
        add_manufacturer
      when 10
        break if @prompt.yes?('Do you really want to exit?')
      end
    end
  end
end
