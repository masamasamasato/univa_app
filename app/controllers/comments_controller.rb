class CommentsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      post = Post.find(params[:post_id])
      comment = post.comments.build(comment_params) #buildを使い、contentとtweet_idの二つを同時に代入
      comment.user_id = current_user.id
      if comment.save
        if comment.image
          flash[:success] = "投稿しました"
          redirect_to request.referer
        else
          flash[:success] = "投稿しました"
          redirect_to request.referer
        end
      else
        flash[:alert] = "投稿できませんでした"
        redirect_to request.referer
      end
    end
  
    private
  
      def comment_params
        params.require(:comment).permit(:content,:image)
      end
  end
