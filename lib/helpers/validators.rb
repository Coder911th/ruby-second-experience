module Validators
  ONE_WORD = ->(value) { value.include?(' ') ? 'Введите одно слово' : true }
  NOT_EMPTY = ->(value) { value.size.zero? ? 'Это поле обязательно для заполнения' : true }
  REQUIRED_ONE_WORD = lambda do |value|
    one_word_result = ONE_WORD.call(value)
    return one_word_result if one_word_result != true

    NOT_EMPTY.call(value)
  end
end
