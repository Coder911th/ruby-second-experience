require_relative '../base_menu/list_menu'

module Menu
  def self.show_choice_sorting_type_menu
    menu = SelectionMenu.new(title: 'Отсортировать все записи:')
    menu.add('По фамилии', -> { yield(->(a, b) { a.second_name <=> b.second_name }) })
    menu.add('По статусу', -> { yield(->(a, b) { a.status <=> b.status }) })
    menu.run
  end

  def self.show_list(records, input_message = nil, title = 'Записная книжка')
    show_choice_sorting_type_menu do |sorting|
      menu = ListMenu.new(
        title: title,
        input_message: input_message,
        disable_selection: input_message.nil?,
        sorting: sorting
      )
      records.clone.each { |record| menu.add(record) }
      menu.run
    end
  end

  def self.show_waiting(message = nil)
    puts message if message
    puts 'Чтобы продолжить нажмите ENTER...'
    gets
  end
end
