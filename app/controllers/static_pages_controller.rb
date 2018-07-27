class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = Micropost.order_mp.feed(current_user.id)
                           .page(params[:page]).per Settings.rows
  end

  def help; end

  def about; end

  def contact; end
end
