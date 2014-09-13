class CommentsController < ApplicationController

  def create
    @comment_hash = params[:comment]
    #@comment = comment.new(comment_params)
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    # Not implemented: check to see whether the user has permission to create a comment on this object
    
    @comment = Comment.build_from(@obj, current_user.id, @comment_hash[:body])
    if @comment.save
      # layout: false removes header and footer.
      # status: created returns HTTP status code 201 when appropriate.
      render partial: "comments/comment", locals: { :comment => @comment }, layout: false, status: :created
    else
      render :js => "alert('Your comment failed to post.');"
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Your comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
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
