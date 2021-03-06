class CommentsController < ApplicationController

  def create
    @comment_hash = params[:comment]
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    @user_id = current_user.id
    # Not implemented: check to see whether the user has permission to create a comment on this object
    @comment = Comment.build_from(@obj, @user_id, @comment_hash[:body])

    if @comment.save
      # layout: false removes header and footer.
      # status: created returns HTTP status code 201 when appropriate.
      render partial: "comments/comment", locals: { :comment => @comment }, layout: false, status: :created
    else
      render :js => "alert('Your comment failed to post.');"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: @comment, status: :ok
      #respond_to do |format|
      #  format.html { redirect_to comments_url }
      #  format.json { head :no_content }
      #end
    else
      render js: "alert('Error deleting comment')"
    end
  end

end
