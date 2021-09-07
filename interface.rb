# frozen_string_literal: true

require 'tty-prompt'

class Interface
  def initialize
    @prompt = TTY::Prompt.new(track_history: false)
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
  
  def exit?
    @prompt.yes?('Do you really want to exit?')
  end

  def print_message(text)
    p text.to_s
  end

  def select(message, choices_array)
    @prompt.select(message, choices_array)
  end

end
