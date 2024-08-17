class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include RackSessionFix
  respond_to :json
end
