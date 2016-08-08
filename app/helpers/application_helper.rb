module ApplicationHelper
  def isFavorite(summoner_id)
    @current_user = current_user
    if @current_user && Favorite.exists?(:user_id => @current_user.id, :summoner_id => summoner_id)
      return true
    else
      return false
    end
  end
end
