class SessionsController < ApplicationController
    
    before_action :redirect_if_logged_in, except: [:destroy]

    def welcome
    end

    def new
        @user = User.new
    end

    def destroy 
        session.delete(:user_id)
        redirect_to '/login'
    end

    def create 
        #if the user logs in directly from app
        u = User.find_by_username(params[:user][:username])
        if u && u.authenticate(params[:user][:password])
            session[:user_id] = u.id
            redirect_to user_path(u)
        else
            flash[:message] = "Your credentials are invalid! Please try again."
            redirect_to '/login'
        end
    end

    def omniauth #if they are logging in with oauth
        # if that user has already logged in this way
        user = User.find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |u|
            u.email = auth["info"]["email"]
            u.password = SecureRandom.hex(15)
            u.username = auth["info"]["email"]
        end

        # check that they register successful
        if user.valid? 
            session[:user_id] = user.id   #log them in
            redirect_to user_path(user)
        else
            flash[:message] = "Oopsie! Something's wrong!"
            redirect_to login_path
        end
       
    end

    private 

    def auth 
        request.env['omniauth.auth']
    end


end