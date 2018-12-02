require 'csv'
require 'English'
require_relative 'helpers/constants'
require_relative 'helpers/validators'
require_relative 'base_menu/selection_menu'
require_relative 'types/record'

class Core
  def initialize
    @record_set = load_database
  end

  def run
    main_menu = SelectionMenu.new('Записная книжка')
    main_menu.add('Добавить запись', -> { show_add_new_item_menu })
    main_menu.add('Удалить запись', -> { 0 })
    main_menu.add('Редактировать запись', -> { 0 })
    main_menu.add('Создать событие', -> { 0 })
    main_menu.add('Просмотреть все записи', -> { 0 })
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

  def show_add_new_item_menu
    params = []
    Console.clear
    puts 'Добавление новой записи'
    params << Console.read('Фамилия: ', Validators::ONE_WORD)
    params << Console.read('Имя: ', Validators::ONE_WORD)
    params << Console.read('Отчество: ', Validators::ONE_WORD)
    params << Console.read('Сотовый телефон: ')
    params << Console.read('Домашний телефон: ')
    params << Console.read('Адрес: ')
    params << Console.read('Статус: ', Validators::NOT_EMPTY)
    @record_set.append(Record.new(*params))
    save_database
    show_waiting_menu('Запись успешно добавлена!')
  end
end
