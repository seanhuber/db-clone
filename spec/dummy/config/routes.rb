Rails.application.routes.draw do

  mount DbClone::Engine => "/db-clone"
end
