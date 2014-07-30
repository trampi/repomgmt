require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test "user without public key should not respond as if the user had one" do
		assert_not users(:user_without_public_key).has_public_key?
	end

	test "user with public key should respond accordingly" do
		assert users(:user_with_long_public_key).has_public_key?
	end

	test "public key length should be checked" do
		assert users(:user_with_long_public_key).valid?
	end

	test "user with too short public key (256 bit in this example) should be invalid" do
		user = users(:user_without_public_key)
		user.public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAACEAtZGdHB9KtpoZe3YY9bZdal8i9GdyScb5mkQH2ooCDAc= rsa-key-20140727"
		user.valid?
		assert user.errors.include?(:public_key)
	end

	test "user with invalid public key should not be saveable" do
		user = users(:user_without_public_key)
		user.public_key = "invalid string"
		user.valid?
		assert user.errors.include?(:public_key)
	end
end
