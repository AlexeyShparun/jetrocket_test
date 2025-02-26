class Api::V1::PostsController < ApplicationController
    def create
      if params[:login].blank?
        return render json: { error: "Login can't be blank" }, status: :unprocessable_entity
      end

      user = User.find_or_create_by(login: params[:login])
      post = user.posts.new(post_params)

      if post.save
        render json: post.as_json(include: :user), status: :created
      else
        render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def top
      top_n = [ params[:n].to_i, 100 ].min # поставил сотку дабы при передаче параметта top? не было много
      posts = Post.joins(:ratings)
                 .select("posts.id, posts.title, posts.body, AVG(ratings.value) as avg_rating")
                 .group("posts.id")
                 .order("avg_rating DESC")
                 .limit(top_n)

      render json: posts, status: :ok
    end

    def ip_list
      ips = Post.joins(:user)
                .group(:ip)
                .having("COUNT(DISTINCT users.id) > 1")
                .select(:ip, "ARRAY_AGG(DISTINCT users.login) AS logins")

      render json: ips.map { |post| { ip: post.ip, authors: post.logins } }, status: :ok
    end

    private

    def post_params
      params.permit(:title, :body, :ip)
    end
end
