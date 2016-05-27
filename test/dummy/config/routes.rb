Rails.application.routes.draw do

  mount DbSync::Engine => "/db_sync"
end
