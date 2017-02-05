class Dashboard::TrainerController < Dashboard::BaseController
  
  def index
    result = FindCard.call(
      id: params[:id],
      user: current_user
    )

    @card = result.card
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])

    result = CheckTranslation.call(
      card: @card,
      user_translation: trainer_params[:user_translation]
    )

    redirect_to trainer_path, result.key => result.message
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end
end
