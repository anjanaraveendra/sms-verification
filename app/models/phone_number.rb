class PhoneNumber < ActiveRecord::Base
  require 'rubygems'
  require 'twilio-ruby'

  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def verify(entered_pin)
    update(verified: true) if self.pin == entered_pin
  end

  def twilio_client
    account_sid = 'ACe5b628fd02f846e46219326f483b908c'
    auth_token = '{{ aa89dad95a005059894da13059f25d45 }}'
    Twilio::REST::Client.new account_sid, auth_token
  end

  def send_pin
    account_sid = 'ACe5b628fd02f846e46219326f483b908c'
    auth_token = 'aa89dad95a005059894da13059f25d45'
    from_number = +14158057710
    phone_number = '+91' + ' ' + self.phone_number.to_s.scan(/.{5}/)[0] + ' ' + self.phone_number.to_s.scan(/.{5}/)[1]
    twilio_client = Twilio::REST::Client.new account_sid, auth_token
    twilio_client.messages.create(
      to: phone_number,
      from: from_number,
      body: "Your PIN is #{pin}"
    )
  end
end
