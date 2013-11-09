module ApplicationHelper
  MAX_QUESTION = 150
  MAX_ANSWER = 50
  MAX_MESSAGE = 400

  ENCODING = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

  def encode_num(num)
    str = ''
    while num > 0
      str = ENCODING[num % ENCODING.length] + str
      num /= 62
    end
    if str == ''
      str = ENCODING[0]
    end
    return str
  end

  def decode_num(str)
    num = 0
    while !str.empty?
      num = num * 62 + ENCODING.index(str[0])
      str = str[1..-1]
    end
    return num
  end

end
