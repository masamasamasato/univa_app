class PostsController < ApplicationController

    before_action :authenticate_user!
    
    def index
        #--------------投稿一覧・検索機能部分-----------------
        if params[:search_1] == nil or params[:search_1] == ''
            if params[:search_2] == nil or params[:search_2] == ''  #何も検索してないデフォルトの状態
                @sorted_posts = Post.includes(:user).sort {|a,b| b.likes.size <=> a.likes.size} #ページごとではなく、全ページでソートされた状態であって欲しいから先にソート
                @posts= Kaminari.paginate_array(@sorted_posts).page(params[:page]).per(8)   #配列である＠sorted _postsにpageメソッドを適用するため
            else
                @search_posts = Post.where("teacher_name LIKE ? ",'%' + params[:search_2] + '%')    # 絞り込んでからソート
                @posts = @search_posts.page(params[:page]).per(8)
            end
        else
            if params[:search_2] == nil or params[:search_2] == ''
                @search_posts = Post.where("content LIKE ? ",'%' + params[:search_1] + '%')     # 絞り込んでからソート
                @posts = @search_posts.page(params[:page]).per(8)
            else
                @search_posts = Post.where("content LIKE ? AND teacher_name LIKE ?", "%#{params[:search_1]}%", "%#{params[:search_2]}%")    # 絞り込んでからソート
                @posts = @search_posts.page(params[:page]).per(8)
            end
        end
    end

    def new
        @post = Post.new
    end

    def create  #@tweetの中身がない場合実行される
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
        @users = @post.liked_users.page(params[:page]).per(5)
        @sorted_users = @users.sort {|a,b| b.followers.size <=> a.followers.size}

    end

    def edit
        @post = Post.find(params[:id])
    end

    def update  #@tweet中身がある場合実行される
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

    private #ストロングパラメーターの記述部分postモデルの投稿可能な内容の絞り込み
    def post_params
        params.require(:post).permit(:content,:teacher_name,:image) #モデルの必要なカラムに絞り込んでいる
    end

end
