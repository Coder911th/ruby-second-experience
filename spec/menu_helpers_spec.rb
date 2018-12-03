require 'helpers/menu'

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
end
