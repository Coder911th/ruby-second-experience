require 'csv'
require 'English'
require_relative 'helpers/constants'
require_relative 'helpers/validators'
require_relative 'base_menu/selection_menu'
require_relative 'base_menu/list_menu'
require_relative 'types/record'

class Core
  def initialize
    @record_set = load_database
  end

  def run
    main_menu = SelectionMenu.new('Записная книжка')
    main_menu.add('Добавить запись', -> { show_add_new_record_menu })
    main_menu.add('Удалить запись', -> { show_remove_record_menu })
    main_menu.add('Редактировать запись', -> { show_edit_record_menu })
    main_menu.add('Создать событие', -> { 0 })
    main_menu.add('Просмотреть все записи', lambda do
      choice_sorting_type_menu { |sorting| show_list(@record_set.clone, sorting) }
      show_waiting_menu
    end)
    main_menu.add('Выход', -> { :stop })
    main_menu.infinite_run
  end

  private

  def load_database
    record_set = []
    record_size = Record.new.length

    begin
      CSV.foreach(Constants::PATH_TO_DATABASE) do |line|
        raise "В строке #{$INPUT_LINE_NUMBER} ожидалось #{record_size} столбцов" if line.size != record_size

        record_set.append(Record.new(*line))
      end
    rescue Errno::ENOENT
      record_set.clear
    rescue StandardError => error_message
      puts error_message
      exit 0
    end

    record_set
  end

  def save_database
    CSV.open(Constants::PATH_TO_DATABASE, 'wb') { |file| @record_set.each { |record| file << record.to_a } }
  end

  def show_waiting_menu(message = nil)
    puts message if message
    puts 'Чтобы продолжить нажмите ENTER...'
    gets
  end

  def show_add_new_record_menu
    params = []
    Console.clear
    puts 'Добавление новой записи'
    params << Console.read('Фамилия: ', Validators::REQUIRED_ONE_WORD)
    params << Console.read('Имя: ', Validators::REQUIRED_ONE_WORD)
    params << Console.read('Отчество: ', Validators::ONE_WORD)
    params << Console.read('Сотовый телефон: ')
    params << Console.read('Домашний телефон: ')
    params << Console.read('Адрес: ')
    params << Console.read('Статус: ', Validators::NOT_EMPTY)
    @record_set.append(Record.new(*params))
    save_database
    show_waiting_menu('Запись успешно добавлена!')
  end

  def choice_sorting_type_menu
    menu = SelectionMenu.new('Отсортировать все записи:')
    menu.add('По фамилии', -> { yield(->(a, b) { a.second_name <=> b.second_name }) })
    menu.add('По статусу', -> { yield(->(a, b) { a.status <=> b.status }) })
    menu.run
  end

  def show_list(records, sorting, input_message = nil, title = 'Записная книга')
    menu = ListMenu.new(
      title,
      input_message,
      ->(record) { record.to_s },
      sorting
    )
    records.each { |record| menu.add(record) }
    menu.run
  end

  def show_remove_record_menu
    choice_sorting_type_menu do |sorting|
      target = show_list(@record_set.clone, sorting, 'Введите номер записи, которую хотите удалить: ')
      @record_set.delete_if { |record| record == target }
      save_database
      show_waiting_menu('Запись успешно удалена!')
    end
  end

  def show_edit_record_menu
    choice_sorting_type_menu do |sorting|
      target = show_list(@record_set.clone, sorting, 'Введите номер записи, которую хотите отредактировать: ')
      menu = SelectionMenu.new('Выберите то, что хотите отредактировать:')
      menu.add('Адрес', -> { edit_record(target, :address) })
      menu.add('Домашний телефон', -> { edit_record(target, :phone) })
      menu.add('Мобильный телефон', -> { edit_record(target, :mobile) })
      menu.run
      save_database
      show_waiting_menu('Запись успешно обновлена!')
    end
  end

  def edit_record(record, field)
    record[field] = Console.read('Введите новое значение: ')
  end
end
