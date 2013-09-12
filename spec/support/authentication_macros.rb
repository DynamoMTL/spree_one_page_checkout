module AuthenticationMacros
  def sign_in_as!(user = nil)
    user ||= create(:user,
                    email: 'guy@incogni.to',
                    password: 'sekrit',
                    password_confirmation: 'sekrit')

    visit spree.login_path

    within '[data-hook=login] form' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
  end
  alias_method :sign_in!, :sign_in_as!

  def sign_up_as!(user_attributes = {})
    user_attributes.reverse_merge!(
      attributes_for(:user, email: 'guy@incogni.to', password: 'sekrit'))

    visit spree.signup_path

    within '[data-hook=signup] form' do
      fill_in 'Email', with: user_attributes[:email]
      fill_in 'Password', with: user_attributes[:password]
      fill_in 'Password Confirmation', with: user_attributes[:password]
      click_button 'Create'
    end
  end
  alias_method :sign_up!, :sign_up_as!
end

RSpec.configure { |c| c.include AuthenticationMacros, type: :feature }
