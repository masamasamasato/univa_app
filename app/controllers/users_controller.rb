class UsersController < ApplicationController

    def show
        @user = User.find(params[:id]) 
    end

    def index
        @users = User.all
    end

    def favorite_index
        @user = User.find(params[:id])
        @favorite_posts = @user.favorite_posts # 追加
    end
    
end
