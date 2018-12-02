module Validators
  ONE_WORD = ->(value) { value.include?(' ') ? 'Введите одно слово' : true }
  NOT_EMPTY = ->(value) { value.size.zero? ? 'Это поле обязательно для заполнения' : true }
end
