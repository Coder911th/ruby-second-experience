require_relative '../helpers/console'

class SelectionMenu
  def initialize(hash)
    @title = hash[:title]
    @disable_selection = hash[:disable_selection] == true
    @input_message = hash[:input_message] || '> '
    @autoclear = hash[:autoclear] != false
    @index_template = hash[:index_template] || ->(index) { "#{index}) " }
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
    Console.clear if @autoclear
    puts @title if @title
    @items.each_with_index do |item, index|
      puts "#{@index_template.call(index + 1)}#{item[:description]}"
    end
    return if @disable_selection

    choise = 0
    available_input = (1..@items.size)
    loop do
      break if available_input.cover?(choise = Console.read_int(@input_message))

      puts "Введите число из диапазона [#{available_input}]"
    end
    @items[choise - 1][:on_selected].call
  end

  def infinite_run
    until run == :stop; end
  rescue Console::StopInput
    infinite_run
  end
end
