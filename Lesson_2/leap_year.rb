# frozen_string_literal: true

def leap_year?(year)
  (year % 4).zero? && year % 100 != 0 || (year % 400).zero?
end

days_count = 0

p 'Please, enter the date of the month: '
day = gets.chomp.to_i
p 'Please, enter the serial number of the month: '
month = gets.chomp.to_i
p 'Please, enter the year: '
year = gets.chomp.to_i

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

month_numbers = months_and_days.keys

(0...month - 1).each do |i|
  days_count += months_and_days[month_numbers[i]]
end

days_count += day

days_count += 1 if (month > 2) && leap_year?(year)

p "#{day}.#{month}.#{year} - is #{days_count} day of the year"
