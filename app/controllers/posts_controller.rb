class PostsController < ApplicationController

    before_action :authenticate_user!
    
    def index
        if params[:search_1] == nil or params[:search_1] == ''
            if params[:search_2] == nil or params[:search_2] == ''
                @posts= Post.all.page(params[:page]).per(8)
            else
                @posts = Post.where("teacher_name LIKE ? ",'%' + params[:search_2] + '%').page(params[:page]).per(3)
            end
        else
            if params[:search_2] == nil or params[:search_2] == ''
                @posts = Post.where("content LIKE ? ",'%' + params[:search_1] + '%').page(params[:page]).per(3)
            else
                @posts = Post.where("content LIKE ? AND teacher_name LIKE ?", "%#{params[:search_1]}%", "%#{params[:search_2]}%").page(params[:page]).per(3)
            end
        end
        @rank_posts = Post.all.sort {|a,b| b.liked_users.count <=> a.liked_users.count}
    end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)
        @post.user_id = current_user.id
        
        if @post.save
            flash[:success] = '投稿しました'
            redirect_to :action => "index"
        else
            flash[:success] = '投稿に失敗しました'
            redirect_to :action => "new"
        end
    end

    def show
        @post = Post.find(params[:id])
        @comments = @post.comments
        @comment = Comment.new
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        @post = Post.find(params[:id])
        if @post.update(post_params)    #@postの中身の更新をupdateアクションを用いておこなっている
            flash[:success] = '編集に成功しました'
            redirect_to :action => "show", :id => @post.id
        else
            flash[:success] = '編集に失敗しました'
            redirect_to :action => "new"
        end
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to action: :index
    end

    private
    def post_params
        params.require(:post).permit(:content,:teacher_name,:image)
    end

end
