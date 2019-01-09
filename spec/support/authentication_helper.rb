module AuthenticationHelper
  def login(user)
    headers = {
      'Accept' => 'application/json', 
      'Content-Type' => 'application/json' 
    }
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end
