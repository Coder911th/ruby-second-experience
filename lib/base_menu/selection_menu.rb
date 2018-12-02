require_relative '../helpers/console'

class SelectionMenu
  def initialize(header_text = nil, before_input_text = '> ', index_template = ->(index) { "#{index}) " })
    @header_text = header_text
    @before_input_text = before_input_text
    @index_template = index_template
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

  def run(blocking_selection = false)
    Console.clear
    puts @header_text if @header_text
    @items.each_with_index do |item, index|
      puts "#{@index_template.call(index + 1)}#{item[:description]}"
    end

    return if blocking_selection

    choise = 0
    available_input = (1..@items.size)

    loop do
      break if available_input.cover?(choise = Console.read_int(@before_input_text))

      puts "Введите число из диапазона [#{available_input}]"
    end

    @items[choise - 1][:on_selected].call
  end

  def infinite_run
    until run == :stop; end
  end
end
