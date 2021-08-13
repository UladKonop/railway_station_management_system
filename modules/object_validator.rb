# frozen_string_literal: true

module ObjectValidator
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
