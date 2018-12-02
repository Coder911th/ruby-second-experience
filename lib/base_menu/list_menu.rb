require_relative 'selection_menu'

class ListMenu < SelectionMenu
  def initialize(header_text, before_input_text, line_render)
    super(header_text, before_input_text, ->(index) { "№#{index}\r\n" })
    @line_render = line_render
  end

  def add(item)
    new_item = {
      description: @line_render.call(item),
      on_selected: -> { item }
    }
    @items.append(new_item)
    new_item
  end
end
