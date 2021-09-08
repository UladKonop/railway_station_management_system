# frozen_string_literal: true

require_relative('interface')

require_relative('./models/route')
require_relative('./models/station')
require_relative('./models/cargo_train')
require_relative('./models/cargo_wagon')
require_relative('./models/passenger_train')
require_relative('./models/passenger_wagon')

class ManagmentSystem
  def initialize
    @stations = []
    @trains = []
  end

  def start
    @interface = Interface.new
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

  def create_stations_menu
    station_names = []
    @stations.each { |station| station_names << station.name }
    station_names
  end

  def add_intermediate_stations
    if @route.nil?
      @interface.print_message 'Create route first'
    else
      @interface.multi_select('Choose intermediate stations: ', create_stations_menu).each do |intermediate_station|
        if check_station(intermediate_station)
          @interface.print_message 'Choose another station!'
          @interface.print_message "This station: #{intermediate_station} - are already on the route!"
        else
          @route.intermediate_stations = find_station(intermediate_station)
          break
        end
      end
    end
  end

  def show_route
    if @route.nil?
      @interface.print_message 'Create route first'
    else
      @interface.print_message @route.stations
    end
  end

  def create_trains_menu
    train_numbers = []
    @trains.each { |train| train_numbers << train.number }
    train_numbers
  end

  def create_station
    @stations << Station.new(@interface.ask('Enter station name:'))
  rescue StandardError => e
    @interface.print_message e.message
  end

  def new_route(first_station, last_station)
    @route = Route.new(first_station, last_station)
  rescue StandardError => e
    @interface.print_message e.message
  end

  def create_route
    if @stations.empty? || @stations.size == 1
      @interface.print_message 'Create at least TWO stations first'
    else
      start_end_stations = []
      loop do
        start_end_stations = @interface.multi_select('Select the start and end station: ',
                                                  create_stations_menu)
        if start_end_stations.size == 2
          break
        else
          @interface.print_message 'Choose TWO stations'
        end
      end
      new_route(find_station(start_end_stations.first), find_station(start_end_stations.last))
    end
  end

  def choose_train_type
    @interface.select('Choose train type: ', %w[cargo passenger])
  end

  def create_cargo_train
    @trains << CargoTrain.new(@interface.ask('Please, enter train number: '))
  rescue StandardError => e
    @interface.print_message e.message
    retry
  end

  def create_passenger_train
    @trains << PassengerTrain.new(@interface.ask('Please, enter train number: '))
  rescue StandardError => e
    @interface.print_message e.message
    retry
  end

  def create_train
    case choose_train_type
    when 'cargo'
      create_cargo_train
    when 'passenger'
      create_passenger_train
    end
  end

  def select_train_number
    @interface.select('Select train: ', create_trains_menu)
  end

  def find_train(train_number)
    @trains.find { |train| train if train.number == train_number }
  end

  def assign_route
    if @route.nil?
      @interface.print_message 'Create route first'
    elsif @trains.empty?
      @interface.print_message 'Create at least one train first'
    else
      find_train(select_train_number).route = @route
    end
  end

  def move(train)
    directions = %w[forward backwards]
    case @interface.select('Choose direction: ', directions)
    when 'forward'
      train.move(:forward)
    when 'backwards'
      train.move(:backwards)
    end
  end

  def move_train
    if @trains.empty?
      @interface.print_message 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      case @interface.select('Select option: ', ['change speed', 'stop', 'move'])
      when 'change speed'
        train.speed = @interface.ask('Enter speed > 0:').to_i
      when 'stop'
        train.stop
      when 'move'
        move(train)
      end
    end
  end

  def find_wagon(train, wagon_number)
    train.wagons.find { |wagon| wagon if wagon.number == wagon_number }
  end

  def add_cargo_wagon(train, wagon_number)
    volume = @interface.ask('Enter amount of wagon volume: ').to_f
    begin
      train.add_wagon(CargoWagon.new(wagon_number, volume))
    rescue StandardError => e
      @interface.print_message e.message
    end
  end

  def add_passenger_wagon(train, wagon_number)
    seats_amount = @interface.ask('Enter amount of wagon seats: ')
    begin
      train.add_wagon(PassengerWagon.new(wagon_number, seats_amount))
    rescue StandardError => e
      @interface.print_message e.message
    end
  end

  def add_remove_wagons
    if @trains.empty?
      @interface.print_message 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      if train.speed.positive?
        @interface.print_message 'Stop the train first!'
      else
        wagon_number = @interface.ask('Enter wagon number: ')
        case @interface.select('Select option: ', ['add wagon', 'delete wagon'])
        when 'add wagon'
          if train.instance_variable_get(:@type) == :cargo
            add_cargo_wagon(train, wagon_number)
          else
            add_passenger_wagon(train, wagon_number)
          end
        when 'delete wagon'
          train.delete_wagon(find_wagon(train, wagon_number))
        end
      end
    end
  end

  def create_wagons_menu(train_number)
    wagons_numbers = []
    find_train(train_number).wagons.each { |wagon| wagons_numbers << wagon.number }
    wagons_numbers
  end

  def enter_manufacturer
    @interface.ask('Enter manufacturer: ')
  end

  def add_manufacturer
    case @interface.select('Choose wagons or trains: ', %w[wagons trains])
    when 'wagons'
      train_number = select_train_number
      train = find_train(train_number)
      if  train.wagons.empty?
        @interface.print_message 'Add wagons to train first!'
      else
        wagon_number = @interface.select('Select wagon: ', create_wagons_menu(train_number))
        find_wagon(train, wagon_number).manufacturer = enter_manufacturer
      end
    when 'trains'
      train_number = select_train_number
      train = find_train(train_number)
      train.manufacturer = enter_manufacturer
    end
    p train
  end

  def occupy
    if @trains.empty?
      @interface.print_message 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      if  train.wagons.empty?
        @interface.print_message 'Add wagons to train first!'
      else
        wagon_number = @interface.select('Select wagon: ', create_wagons_menu(train_number))
        case train.instance_variable_get(:@type)
        when :cargo
          find_wagon(train, wagon_number).occupy_volume(@interface.ask('Enter volume: ').to_f)
        when :passenger
          find_wagon(train, wagon_number).occupy_seat
        end
      end
    end
  end

  def print_trains_on_station
    station_name = @interface.select('Select station: ', create_stations_menu)
    station = find_station(station_name)
    station.return_trains_for_print do |train|
      @interface.print_message "Train number: #{train.number}, train type: #{train.instance_variable_get(:@type)}, wagons amount: #{train.wagons.size}"
    end
  end

  def print_train_wagons
    train_number = select_train_number
    train = find_train(train_number)
    type = train.instance_variable_get(:@type)
    if type == :cargo
      train.return_wagons_for_print do |wagon|
        p "Wagon number: #{wagon.number}, wagon type: #{type}, free volume amount: #{wagon.free_volume_amount}, occupied volume amount: #{wagon.occupied_volume}"
      end
    else
      train.return_wagons_for_print do |wagon|
        p "Wagon number: #{wagon.number}, wagon type: #{type}, free seats amount: #{wagon.free_seats_amount}, occupied volume amount: #{wagon.occupied_seats}"
      end
    end
  end

  def menu_loop
    loop do
      case @interface.make_choice
      when 1
        create_station
      when 2
        create_train
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
        occupy
      when 9
        show_route
      when 10
        add_manufacturer
      when 11
        print_trains_on_station
      when 12
        print_train_wagons
      when 13
        break if @interface.exit?
      end
    end
  end
end
