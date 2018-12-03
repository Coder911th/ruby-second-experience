require_relative 'validators'

module Console
  class StopInput < RuntimeError; end

  def self.clear
    system('clear') || system('cls')
  end

  def self.read(prefix = '> ', validator = nil)
    loop do
      STDOUT.print prefix
      raise StopInput if !input = $stdin.gets

      input = input.strip
      break input if !validator

      result = validator.call(input)
      break input if result == true

      puts result
    end
  end

  def self.read_int(prefix = '> ')
    read(prefix).to_i
  end

  def self.read_yes_no(prefix = '> ')
    read(prefix, Validators::ANSWER) == 'y'
  end
end
