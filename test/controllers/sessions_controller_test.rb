

class SessionsControllerTest < ActionController::TestCase


  test "should get create" do
  	MYSTRING = "ABC"
  	@request.env["omniauth.auth"] = { "info" => {"name" => MYSTRING, "nickname" => MYSTRING,  "image"=> MYSTRING }, "uid" => 42, "credentials"=>{"secret"=>MYSTRING, "token"=>MYSTRING}}
  	assert_difference 'User.count', 1 do
  		get :create
  	end
  	assert_redirected_to :root
  end

  test "should get failure" do	
    get :failure
    assert_response :success
  end

  test "should get destroy" do
  	MYSTRING = "ABC"
  	@request.env["omniauth.auth"] = { "info" => {"name" => MYSTRING, "nickname" => MYSTRING,  "image"=> MYSTRING }, "uid" => 42, "credentials"=>{"secret"=>MYSTRING, "token"=>MYSTRING}}
  	get :create
  	assert_difference 'User.count', -1 do
  		get :destroy
  	end
  	assert_redirected_to :root
  end

  test "should get logout" do
    MYSTRING = "ABC"
    @request.env["omniauth.auth"] = { "info" => {"name" => MYSTRING, "nickname" => MYSTRING,  "image"=> MYSTRING }, "uid" => 42, "credentials"=>{"secret"=>MYSTRING, "token"=>MYSTRING}}
  	get :create
  	assert_no_difference 'User.count' do
  		get :logout
  	end
  	assert_redirected_to :root
  end
end
