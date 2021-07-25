# frozen_string_literal: true

p 'Please, input Your name: '
name = gets.chomp.capitalize!
p 'Please, input Your height: '
height = gets.chomp.to_f

ideal_weight = (height - 110) * 1.15

if ideal_weight.negative?
  p 'Your weight is already optimal'
else
  p "#{name}, Your optimal weight is : #{ideal_weight}"
end
