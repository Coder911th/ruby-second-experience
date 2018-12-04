require 'core'

RSpec.describe Core do
  describe 'add_new_record_to_database' do
    it 'valid user' do
      allow($stdout).to receive(:puts)
      expect(STDOUT).to receive(:print).with('> ')
      expect($stdin).to receive(:gets).and_return('1')
      expect(STDOUT).to receive(:print).with('Фамилия: ')
      expect($stdin).to receive(:gets).and_return('Zero')
      expect(STDOUT).to receive(:print).with('Имя: ')
      expect($stdin).to receive(:gets).and_return('Robo')
      expect(STDOUT).to receive(:print).with('Отчество: ')
      expect($stdin).to receive(:gets).and_return('Nikolaevi4')
      expect(STDOUT).to receive(:print).with('Сотовый телефон: ')
      expect($stdin).to receive(:gets).and_return('+7 (111) 222-33-44')
      expect(STDOUT).to receive(:print).with('Домашний телефон: ')
      expect($stdin).to receive(:gets).and_return('12-34-56')
      expect(STDOUT).to receive(:print).with('Адрес: ')
      expect($stdin).to receive(:gets).and_return('Paris Tower St. 43 house 3 ap. 52')
      expect(STDOUT).to receive(:print).with('Статус: ')
      expect($stdin).to receive(:gets).and_return('Robot')
      expect(STDOUT).to receive(:puts).with('Запись успешно добавлена!')
      expect(STDOUT).to receive(:puts).with('Чтобы продолжить нажмите ENTER...')
      expect($stdin).to receive(:gets).and_return('')
      expect(STDOUT).to receive(:print).with('> ')
      expect($stdin).to receive(:gets).and_return('6')
      Core.new.run
    end
  end

  describe 'create event' do
    it 'valid creation' do
      allow($stdout).to receive(:puts)
      expect($stdin).to receive(:gets).and_return('4')
      expect($stdin).to receive(:gets).and_return("Test Event #{rand}")
      expect($stdin).to receive(:gets).and_return('1')
      expect($stdin).to receive(:gets).and_return('Hello World')
      expect($stdin).to receive(:gets).and_return('y')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdin).to receive(:gets).and_return('6')
      Core.new.run
    end
  end

  describe 'edit menu' do
    it 'edit phone' do
      allow($stdout).to receive(:puts)
      expect($stdin).to receive(:gets).and_return('3')
      expect($stdin).to receive(:gets).and_return('1')
      expect($stdin).to receive(:gets).and_return('1')
      expect($stdin).to receive(:gets).and_return('2')
      expect($stdin).to receive(:gets).and_return('55-77-99')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdin).to receive(:gets).and_return('6')
      Core.new.run
    end
  end

  describe 'remove item' do
    it 'first' do
      allow($stdout).to receive(:puts)
      expect($stdin).to receive(:gets).and_return('2')
      expect($stdin).to receive(:gets).and_return('1')
      expect($stdin).to receive(:gets).and_return('1')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdin).to receive(:gets).and_return('6')
      Core.new.run
    end
  end
end
