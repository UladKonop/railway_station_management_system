# frozen_string_literal: true

coefficients = { a: 0, b: 0, c: 0 }
p 'Aх^2 + Bx + C = 0'

p 'Please, enter coefficient A: '
coefficients[:a] = gets.chomp.to_f
p 'Please, enter coefficient B: '
coefficients[:b] = gets.chomp.to_f
p 'Please, enter coefficient C: '
coefficients[:c] = gets.chomp.to_f

discriminant = coefficients[:b]**2 - 4 * coefficients[:a] * coefficients[:c]
if discriminant.negative?
  p "Discriminant = #{discriminant}. There are no roots"
elsif discriminant.zero?
  p "Discriminant = #{discriminant}. The root - #{(-coefficients[:b]) / (2 * coefficients[:a])}"
else
  p "Discriminant = #{discriminant}. The roots - #{((-coefficients[:b]) - Math.sqrt(discriminant)) / 2 * coefficients[:a]}, #{((-coefficients[:b]) + Math.sqrt(discriminant)) / 2 * coefficients[:a]}"
end
