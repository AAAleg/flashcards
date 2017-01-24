class Home::HomeController < Home::BaseController
  include Common
  
  def index
    find_card
  end
end
