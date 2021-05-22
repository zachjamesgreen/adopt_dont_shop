class AdminController < ApplicationsController

  def shelter_index
    @shelters = Shelter.all_rev_alpha
  end
end