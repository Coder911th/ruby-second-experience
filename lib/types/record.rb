Record = Struct.new(:first_name, :second_name, :patronymic, :mobile, :phone, :address, :status) do
  def full_name
    "#{second_name} #{first_name}" + (patronymic.empty? ? '' : " #{patronymic}")
  end

  def address?
    address.empty?
  end

  def to_s
    '  ' + full_name + "\r\n" +
      (mobile.empty? ? '' : "  Сотовый: #{mobile}\r\n") +
      (phone.empty? ? '' : "  Домашний: #{phone}\r\n") +
      (address? ? '' : "  Адрес: #{address}\r\n") +
      "  Статус: #{status}"
  end
end
