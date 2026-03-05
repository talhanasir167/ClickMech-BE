class ApplicationController < ActionController::API
  include Authenticable
  before_action :authenticate_request!
end
