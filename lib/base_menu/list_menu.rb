require_relative 'selection_menu'

class ListMenu < SelectionMenu
  def initialize(header_text, line_render)
    super.initialize(header_text)
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
