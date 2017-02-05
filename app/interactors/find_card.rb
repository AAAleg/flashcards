class FindCard
  include Interactor

  def call
    if context.id
      context.card = context.user.cards.find(context.id)
    else
      if context.user.current_block
        context.card = context.user.current_block.cards.pending.first
        context.card ||= context.user.current_block.cards.repeating.first
      else
        context.card = context.user.cards.pending.first
        context.card ||= context.user.cards.repeating.first
      end
    end
  end
end
