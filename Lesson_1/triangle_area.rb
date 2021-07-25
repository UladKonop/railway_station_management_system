# frozen_string_literal: true

p 'Please, input the length of the triangle base (a): '
base = gets.chomp.to_f
p 'Please, input the length of the triangle height (h): '
height = gets.chomp.to_f

p "The area (S) of the triangle is equal to: #{(base * height) / 2}"
