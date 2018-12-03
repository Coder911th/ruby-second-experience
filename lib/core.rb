require 'csv'
require 'English'
require_relative 'helpers/constants'
require_relative 'helpers/validators'
require_relative 'helpers/menu'
require_relative 'base_menu/selection_menu'
require_relative 'base_menu/list_menu'
require_relative 'types/record'
require_relative 'event_menu'

class Core
  def initialize
    @record_set = load_database
  end

  def run
    main_menu = SelectionMenu.new(title: 'Записная книжка')
    main_menu.add('Добавить запись', -> { show_add_new_record_menu })
    main_menu.add('Удалить запись', -> { show_remove_record_menu })
    main_menu.add('Редактировать запись', -> { show_edit_record_menu })
    main_menu.add('Создать событие', -> { EventMenu.new(@record_set.clone).run })
    main_menu.add('Просмотреть все записи', lambda do
      return if !Menu.check_empty_notebook(@record_set)

      Menu.show_list(@record_set)
      Menu.show_waiting
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
      nil
    rescue StandardError => error_message
      puts error_message
      exit 0
    end

    record_set
  end

  def save_database(message = nil)
    CSV.open(Constants::PATH_TO_DATABASE, 'wb') { |file| @record_set.each { |record| file << record.to_a } }
    Menu.show_waiting(message)
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
    save_database('Запись успешно добавлена!')
  end

  def show_remove_record_menu
    return if !Menu.check_empty_notebook(@record_set)

    target = Menu.show_list(@record_set, 'Введите номер записи, которую хотите удалить: ')
    @record_set.delete_if { |record| record == target }
    save_database('Запись успешно удалена!')
  end

  def show_edit_record_menu
    return if !Menu.check_empty_notebook(@record_set)

    target = Menu.show_list(@record_set, 'Введите номер записи, которую хотите отредактировать: ')
    menu = SelectionMenu.new(title: 'Выберите то, что хотите отредактировать:')
    menu.add('Адрес', -> { edit_record(target, :address) })
    menu.add('Домашний телефон', -> { edit_record(target, :phone) })
    menu.add('Мобильный телефон', -> { edit_record(target, :mobile) })
    menu.run
    save_database('Запись успешно обновлена!')
  end

  def edit_record(record, field)
    record[field] = Console.read('Введите новое значение: ')
  end
end
