Rails.application.routes.draw do
  mount Jscov::Engine => "/jscov"
end
