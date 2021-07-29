# frozen_string_literal: true

require_relative('./models/route')
require_relative('./models/train')
require_relative('./models/station')

starting_station = Station.new('starting_station')
end_station = Station.new('end_station')

second_station = Station.new('second_station')
third_station = Station.new('third_station')
fourth_station = Station.new('4th_station')

route = Route.new(starting_station, end_station)

# p route
# p route.starting_station
# p route.end_station
# p route.intermediate_stations

route.intermediate_stations = second_station
route.intermediate_stations = third_station
route.intermediate_stations = fourth_station
# p route.intermediate_stations
route.delete_intermediate_station(third_station)
# p route.intermediate_stations

train = Train.new('aa111', :cargo, 33)
# p train
# p train.number
# p train.type
# p train.wagons_amount
train.change_wagon_amount(-1)
# p train.wagons_amount
# p train.speed

# train.speed = 10
# train.change_wagon_amount(-1)

# p train.speed
train.stop
# p train.speed
train.change_wagon_amount(-1)
# p train.wagons_amount

train2 = Train.new('b22', :passenger, 3)
# p train2
starting_station.trains = train
starting_station.trains = train2

starting_station.delete_train(train2)
second_station.delete_train(train)

train.route = route.make_full_route
# p train.route

# p train.nearest_stations[:current_station]
# p train.nearest_stations

train.move(:forward)
train.move(:forward)
train.move(:forward)
# p train.move(:forward)
train.move(:backwards)
p train.current_station
# p train.next_station
# p train.previous_station
