module Console
  def self.clear
    system('clear') || system('cls')
  end

  def self.read(prefix = '> ', validator = nil)
    loop do
      print prefix
      exit 0 if !input = $stdin.gets

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
end
