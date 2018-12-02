require_relative '../helpers/console'

class SelectionMenu
  def initialize(header_text = nil)
    @header_text = header_text
    @items = []
  end

  def add(description, on_selected)
    new_item = {
      description: description,
      on_selected: on_selected
    }
    @items.append(new_item)
    new_item
  end

  def run
    Console.clear
    puts @header_text if @header_text
    @items.each_with_index do |item, index|
      puts "#{index + 1}) #{item[:description]}"
    end

    choise = 0
    available_input = (1..@items.size)

    loop do
      break if available_input.cover?(choise = Console.read_int)

      puts "Введите число из диапазона [#{available_input}]"
    end

    @items[choise - 1][:on_selected].call
  end

  def infinite_run
    until run == :stop; end
  end
end
