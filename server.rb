require 'sinatra'
require 'sinatra/namespace'
require 'json'
require './controllers/user_controller'

namespace '/api' do 

    before do
        content_type :json
    end

    post '/user/create' do 
        if params["username"].nil? 
            halt 400, { 
            status:'fail',
            message:'please enter username' }.to_json
        end
        if params["email"].nil?
            halt 400, { 
            status:'fail',
            message:'please enter email' }.to_json
        end
        
        user_id = UserController.add_user(params)
        if user_id
            halt 200, { 
              status:'success',
              message:'successfully added user',
              user_id: user_id }.to_json
        else
            halt 400, {
                status:'fail',
                message:'failed to add user' }.to_json
        end
    end
end


