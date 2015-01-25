class PublicKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil? || value.strip.empty?
    check_valid_key(record, attribute, value) || check_long_enough(record, attribute, value)
  end

  private

  def check_valid_key(record, attribute, value)
    return false if SSHKey.valid_ssh_public_key?(value)
    message = options[:message] || ' ungueltig.'
    record.errors[attribute] << message
    true
  end

  def check_long_enough(record, attribute, value)
    return false if SSHKey.ssh_public_key_bits(value) >= 2048
    message = options[:message] || ' ist zu kurz, 2048 Bits Mindestlaenge.'
    record.errors[attribute] << message
    true
  end
end
