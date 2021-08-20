require 'sinatra'
require 'sinatra/namespace'
require 'json'
require './controllers/user_controller'
require './controllers/hashtag_controller'
require './controllers/post_controller'

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

    get '/hashtag/trend' do
        HashtagController.get_by_trend.to_json
    end

    post '/post/create' do
        if params["content"].nil? 
            halt 400, { 
            status:'fail',
            message:'please submit content' }.to_json
        end
        if params["user_id"].nil?
            halt 400, { 
            status:'fail',
            message:'please submit user_id' }.to_json
        end
        if params["content"].length >1000
            halt 400, { 
            status:'fail',
            message:'Maximum limit of a text is 1000 characters' }.to_json
        end

        post_id = PostController.add_post(params)

        if post_id
            halt 200, { 
            status:'success',
            message:'successfully added post',
            post_id: post_id }.to_json
        else
            halt 400, { 
            status:'fail',
            message:'failed add a post' }.to_json
        end
    end

    get '/post/:hashtag_name' do
        PostController.get_by_hashtag_name(params).to_json
    end
end


