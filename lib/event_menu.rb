require 'set'
require_relative 'helpers/console'
require_relative 'helpers/constants'
require_relative 'helpers/menu'
require_relative 'base_menu/list_menu'

class EventMenu
  def initialize(record_set)
    @record_set = record_set
  end

  def run
    Console.clear
    return Menu.show_waiting('В записной книжке ни одного знакомого!') if @record_set.size.zero?

    show_create_event_menu
  end

  private

  def show_create_event_menu
    puts 'Создание события'
    event_name = Console.read('Введите название события: ')
    menu = ListMenu.new(
      title: 'Список доступных статусов:',
      index_template: ->(index) { "#{index}) " },
      input_message: 'Введите номер статуса, всем знакомым с которым нужно отправить приглашения: ',
      autoclear: false
    )
    Set.new(@record_set.map(&:status)).each { |status| menu.add(status) }
    invited_status = menu.run
    message = Console.read('Введите текст приглашения: ')
    should_add_address = Console.read_yes_no('Добавить адрес получателя к тексту сообщения? (y/n) ')
    show_invited_list(invited_status, event_name, message, should_add_address)
  end

  def show_invited_list(invited_status, event_name, message, should_add_address)
    menu = ListMenu.new(
      title: 'Список приглашенных:',
      index_template: ->(index) { "#{index}) " },
      disable_selection: true
    )
    invited = []
    @record_set.each do |record|
      next if record.status != invited_status

      invited.append(record)
      menu.add(record.full_name)
    end
    menu.run
    invitations_folder = File.expand_path("#{Constants::PATH_TO_DATA}/#{event_name}")
    save_invitations(invitations_folder, invited, message, should_add_address)
    Menu.show_waiting("Все приглашения сохранены в папке #{invitations_folder}")
  end

  def save_invitations(path, targets, message, should_add_address)
    Dir.mkdir(path)
    targets.each do |target|
      file = File.new(File.expand_path("#{path}/#{target.full_name}.txt"), 'w')
      file.puts(target.full_name)
      file.puts("Адрес: #{target.address}") if should_add_address && target.address?
      file.puts(message)
      file.close
    end
  end
end
