# frozen_string_literal: true

months_and_days =
  {
    'January' => 31,
    'February' => 28,
    'March' => 31,
    'April' => 30,
    'May' => 31,
    'June' => 30,
    'July' => 31,
    'August' => 31,
    'September' => 30,
    'October' => 31,
    'November' => 30,
    'December' => 31
  }

months_and_days.each { |month, days| p "#{month} - has #{days} days" if days == 30 }

# ===

p arr = (10..100).step(5).to_a

# ===

def fibonacci(n)
  if n < 3
    1
  else
    fibonacci(n - 1) + fibonacci(n - 2)
  end
end

fibonacci_arr = []

start_item = 1

loop do
  fibonacci_item = fibonacci(start_item)
  if fibonacci_item < 100
    fibonacci_arr << fibonacci_item
    start_item += 1
  else
    break
  end
end

p fibonacci_arr

# ===

vowels = 'aeiou'
letters = ('a'..'z').to_a
vowels_and_index = {}
letters.each_with_index do |letter, index|
  vowels_and_index.store(letter, index + 1) if vowels.include?(letter)
end

p vowels_and_index
