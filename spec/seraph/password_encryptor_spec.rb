require 'spec_helper'
require 'seraph/password_encryptor'

RSpec.describe Seraph::PasswordEncryptor do
  describe '.call' do
    let(:password) { 'foobar12' }
    let(:encrypted) { described_class.call(password) }
    let(:salt) { encrypted.salt }
    subject(:encrypted_password) { encrypted.to_s }

    it 'encrypts the password using BCrypt' do
      expect(encrypted_password).to eq BCrypt::Engine.hash_secret(password, salt)
    end

    context 'when pepper is set' do
      let(:pepper) { '9b8177d1d835fad6cc19b455d41ec64f6dcbe83a1af60eb598973f8fb6e29fb1' }
      before do
        Seraph.configure do |config|
          config.pepper = pepper
        end
      end

      it 'uses the pepper for encrypting the password' do
        expect(encrypted_password).to eq BCrypt::Engine.hash_secret("#{password}:#{pepper}", salt)
      end
    end
  end
end
