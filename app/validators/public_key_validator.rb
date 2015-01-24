class PublicKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.nil? && !value.strip.empty? then
      if not SSHKey.valid_ssh_public_key? value
        record.errors[attribute] << (options[:message] || ' ung�ltig.')
      elsif SSHKey.ssh_public_key_bits(value) < 2048
        record.errors[attribute] << (options[:message] || ' ist zu kurz, 2048 Bits Mindestl�nge.')
      end
    end
  end
end
