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
      translated_text: trainer_params[:user_translation]
    )

    if result.success?
      if result.distance == 0
        flash[:notice] = t(:correct_translation_notice)
      else
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: @card.original_text,
                          translated_text: @card.translated_text
      end
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end
end
