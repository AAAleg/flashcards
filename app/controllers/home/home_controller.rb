class Home::HomeController < Home::BaseController

  def index
    result = FindCard.call(
      id: params[:id],
      user: current_user
    )

    @card = result.card
  end
end
