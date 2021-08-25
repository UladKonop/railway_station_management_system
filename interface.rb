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
    @prompt = TTY::Prompt.new(track_history: false)
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
    begin
      @stations << Station.new(name)
    rescue StandardError => e
      p e.message
    end
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
      begin
        @route = Route.new(find_station(start_end_stations.first),
                           find_station(start_end_stations.last))
      rescue StandardError => e
        p e.message
      end
    end
  end

  def choose_train_type
    types = %w[cargo passenger]
    @prompt.select('Choose train type: ', types)
  end

  def create_cargo_train
    @trains << CargoTrain.new(@prompt.ask('Please, enter train number: '))
  rescue StandardError => e
    p e.message
    retry
  end

  def create_passenger_train
    @trains << PassengerTrain.new(@prompt.ask('Please, enter train number: '))
  rescue StandardError => e
    p e.message
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
    @prompt.select('Select train: ', create_trains_menu)
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
      find_train(select_train_number).route = @route
    end
  end

  def move(train)
    directions = %w[forward backwards]
    case @prompt.select('Choose direction: ', directions)
    when 'forward'
      train.move(:forward)
    when 'backwards'
      train.move(:backwards)
    end
  end

  def move_train
    if @trains.empty?
      p 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      choices = ['change speed', 'stop', 'move']
      case @prompt.select('Select option: ', choices)
      when 'change speed'
        train.speed = @prompt.ask('Enter speed > 0:').to_i
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
    volume = @prompt.ask('Enter amount of wagon volume: ').to_f
    begin
      train.add_wagon(CargoWagon.new(wagon_number, volume))
    rescue StandardError => e
      p e.message
    end
  end

  def add_passenger_wagon(train, wagon_number)
    seats_amount = @prompt.ask('Enter amount of wagon seats: ')
    begin
      train.add_wagon(PassengerWagon.new(wagon_number, seats_amount))
    rescue StandardError => e
      p e.message
    end
  end

  def add_remove_wagons
    if @trains.empty?
      p 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      if train.speed.positive?
        p 'Stop the train first!'
      else
        choices = ['add wagon', 'delete wagon']
        wagon_number = @prompt.ask('Enter wagon number: ')

        case @prompt.select('Select option: ', choices)
        when 'add wagon'
          if train.type == :cargo
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
    @prompt.ask('Enter manufacturer: ')
  end

  def add_manufacturer
    case @prompt.select('Choose wagons or trains: ', %w[wagons trains])
    when 'wagons'
      train_number = select_train_number
      train = find_train(train_number)
      if  train.wagons.empty?
        p 'Add wagons to train first!'
      else
        wagon_number = @prompt.select('Select wagon: ', create_wagons_menu(train_number))
        find_wagon(train, wagon_number).manufacturer = enter_manufacturer
      end
    when 'trains'
      train_number = select_train_number
      train.manufacturer = enter_manufacturer
    end
    p train
  end

  def occupy
    if @trains.empty?
      p 'Create at least one train first'
    else
      train_number = select_train_number
      train = find_train(train_number)
      if  train.wagons.empty?
        p 'Add wagons to train first!'
      else
        wagon_number = @prompt.select('Select wagon: ', create_wagons_menu(train_number))
        case train.type
        when :cargo
          find_wagon(train, wagon_number).occupy_volume(@prompt.ask('Enter volume: ').to_f)
        when :passenger
          find_wagon(train, wagon_number).occupy_seat
        end
      end
    end
  end

  def print_trains_on_station
    station_name = @prompt.select('Select station: ', create_stations_menu)
    station = find_station(station_name)
    station.return_trains_for_print {|train| p "Train number: #{train.number}, train type: #{train.type}, wagons amount: #{train.wagons.size}"}
  end

  def make_choice
    @prompt.select('Select an action: ', per_page: 13) do |menu|
      menu.choice 'Create station', 1
      menu.choice 'Create train', 2
      menu.choice 'Create route', 3
      menu.choice 'Add intermediate stations to route', 4
      menu.choice 'Assign a route to train ', 5
      menu.choice 'Manipulations with wagons', 6
      menu.choice 'SpeedUp / SpeedDown / Move train', 7
      menu.choice 'Occupy seat / volume', 8
      menu.choice 'Show route and trains', 9
      menu.choice 'Add manufacturer', 10
      menu.choice 'Print trains on station', 11
      menu.choice 'Print train wagons', 12
      menu.choice 'Exit', 13
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
        break if @prompt.yes?('Do you really want to exit?')
      end
    end
  end
end
