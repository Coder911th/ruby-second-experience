require 'helpers/menu'
require 'types/record'

RSpec.describe Menu do
  describe '#show_waiting' do
    it 'without custom message' do
      expect(STDOUT).to receive(:puts).with('Чтобы продолжить нажмите ENTER...')
      allow($stdin).to receive(:gets).and_return('')
      Menu.show_waiting
    end

    it 'with custom message' do
      expect(STDOUT).to receive(:puts).with('Hello World')
      expect(STDOUT).to receive(:puts).with('Чтобы продолжить нажмите ENTER...')
      allow($stdin).to receive(:gets).and_return('')
      Menu.show_waiting('Hello World')
    end
  end

  describe '#check_empty_notebook' do
    it 'is not empty' do
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:gets).and_return('')
      expect(Menu.check_empty_notebook([])).to eq(false)
    end

    it 'is empty' do
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:gets).and_return('')
      expect(Menu.check_empty_notebook([Record.new])).to eq(true)
    end
  end
end
