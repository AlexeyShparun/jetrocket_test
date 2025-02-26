class Api::V1::RatingsController < ApplicationController
  def create
    post = Post.find_by(id: params[:post_id])
    return render_not_found("Post") unless post

    post.with_lock do # лок от гонок
      if post.ratings.exists?(user_id: params[:user_id])
        return render json: { error: "User has already rated this post" }, status: :unprocessable_entity
      end

      rating = post.ratings.new(rating_params)

      if rating.save
        render json: { average_rating: post.reload.average_rating }, status: :created
      else
        render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def rating_params
    params.permit(:user_id, :value)
  end

  def render_not_found(entity)
    render json: { error: "#{entity} not found" }, status: :not_found
  end
end
