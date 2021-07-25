# frozen_string_literal: true

lengths = []

3.times do
  p 'Please, input the length of the triangle side: '
  lengths << gets.chomp.to_f
end

lengths.sort!

if (lengths[0] + lengths[1] > lengths[2]) &&
   (lengths[0] + lengths[2] > lengths[1]) &&
   (lengths[1] + lengths[2] > lengths[0])

  if lengths.last**2 == lengths[0]**2 + lengths[1]**2
    p 'Triangle is right'
  elsif (lengths[0] == lengths[1]) && (lengths[1] == lengths[2])
    p 'Triangle - equilateral'
  elsif (lengths[0] == lengths[1]) || (lengths[1] == lengths[2]) || (lengths[0] == lengths[2])
    p 'Triangle - isosceles'
  end

else
  p 'Such a triangle cannot exist'

end
