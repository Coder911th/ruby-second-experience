require 'helpers/validators'

RSpec.describe Validators do
  describe 'NOT_EMPTY' do
    it 'should return true' do
      expect(Validators::NOT_EMPTY.call('Hello World')).to eq(true)
    end

    it 'should return error message' do
      expect(Validators::NOT_EMPTY.call('')).to eq('Это поле обязательно для заполнения')
    end
  end

  describe 'ONE_WORD' do
    it 'should return true' do
      expect(Validators::ONE_WORD.call('Hello')).to eq(true)
    end

    it 'should return error message' do
      expect(Validators::ONE_WORD.call('Hello World')).to eq('Введите одно слово')
    end
  end

  describe 'REQUIRED_ONE_WORD' do
    it 'should return true' do
      expect(Validators::REQUIRED_ONE_WORD.call('Hello')).to eq(true)
    end

    it 'should return error message (one word)' do
      expect(Validators::REQUIRED_ONE_WORD.call('Hello World')).to eq('Введите одно слово')
    end

    it 'should return error message (not empty)' do
      expect(Validators::REQUIRED_ONE_WORD.call('')).to eq('Это поле обязательно для заполнения')
    end
  end

  describe 'ANSWER' do
    it 'should return true (positive answer)' do
      expect(Validators::ANSWER.call('y')).to eq(true)
    end

    it 'should return true (negative answer)' do
      expect(Validators::ANSWER.call('n')).to eq(true)
    end

    it 'should return error message' do
      expect(Validators::ANSWER.call('N')).to eq("Введите либо 'y', либо 'n'")
    end
  end
end
