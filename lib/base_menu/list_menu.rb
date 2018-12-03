require_relative 'selection_menu'

class ListMenu < SelectionMenu
  def initialize(header_text, before_input_text, line_render, sorting = nil)
    super(header_text, before_input_text)
    @line_render = line_render
    @sorting = sorting
  end

  def add(item)
    new_item = {
      description: @line_render.call(item),
      on_selected: -> { item }
    }
    @items.append(new_item)
    new_item
  end

  def run(blocking_selection = false)
    @items.sort! { |a, b| @sorting.call(a[:on_selected].call, b[:on_selected].call) } if @sorting

    super(blocking_selection)
  end

  private

  def index_template(index)
    "№#{index}\r\n"
  end
end
