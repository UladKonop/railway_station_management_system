# frozen_string_literal: true

cart = {}

loop do
  p 'Please, enter name of the product: '
  product_name = gets.chomp
  break if product_name == 'stop'

  product_name = product_name.to_sym

  cart.store(product_name, nil)

  price_and_amount = { price: 0.0, amount: 0.0 }

  p 'Please, enter price of the product: '
  price_and_amount[:price] = gets.chomp.to_f

  p 'Please, enter amount of the product: '
  price_and_amount[:amount] = gets.chomp.to_f

  cart.store(product_name, price_and_amount)
  p cart
end

total_sum = 0
cart.each_pair do |key, value|
  total_for_product = value[:price] * value[:amount]
  p "In total for #{key} = #{total_for_product}"
  total_sum += total_for_product
end

p "In total for all cart = #{total_sum}"
