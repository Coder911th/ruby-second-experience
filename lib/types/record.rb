Record = Struct.new(:first_name, :second_name, :patronymic, :mobile, :phone, :address, :status) do
  def to_s
    "  #{second_name} #{first_name}" +
      (patronymic.empty? ? "\r\n" : " #{patronymic}\r\n") +
      (mobile.empty? ? '' : "  Сотовый: #{mobile}\r\n") +
      (phone.empty? ? '' : "  Домашний: #{phone}\r\n") +
      (address.empty? ? '' : "  Адрес: #{address}\r\n") +
      "  Статус: #{status}"
  end
end
