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

    def followings
        @user = User.find(params[:id])
        @followings = @user.followings
    end

    def followers
        @user = User.find(params[:id])
        @followers = @user.followers
    end

end
