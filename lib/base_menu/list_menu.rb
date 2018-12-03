require_relative 'selection_menu'

class ListMenu < SelectionMenu
  def initialize(hash)
    hash[:index_template] = hash[:index_template] || ->(index) { "№#{index}\r\n" }
    super(hash)
    @line_render = hash[:line_render] || ->(item) { item.to_s }
    @sorting = hash[:sorting]
  end

  def add(item)
    new_item = {
      description: @line_render.call(item),
      on_selected: -> { item }
    }
    @items.append(new_item)
    new_item
  end

  def run
    @items.sort! { |a, b| @sorting.call(a[:on_selected].call, b[:on_selected].call) } if @sorting

    super()
  end

  private

  def index_template(index); end
end
