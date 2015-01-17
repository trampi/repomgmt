Rails.application.routes.draw do
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"

	# Registered user
	authenticated :user do

		root :to => 'index#index', :as => :authenticated_root

		# projects
		resources :repositories, controller: 'projects', path: 'projects', only: [:index, :show] do
			resources :versions
		end
		resources :tasks do
			post :solve, on: :member
			resources :comments, only: [:create]
		end
		get 'tasks/:name/new' => 'tasks#new', as: :new_task_name

		# statistics for current user and repositories he belongs to
		resources :statistics_repositories, only: [:index, :show]
		resources :statistics_users, only: [:index, :show] # :index is not accessible but needed in statistics_users.js.erb for path helper

		# settings for current user
		get 'settings/user' => 'settings_user#index'
		patch 'settings/user' => 'settings_user#update'
	end

	# Admin
	authenticated :user, lambda { |user| user.admin? } do
		# administration stuff
		namespace 'admin' do
			# repositories
			resources :repositories, only: [:index, :create, :new, :edit, :update, :destroy]
			get 'repositories/:name/new' => 'repositories#new', as: :new_repository_name

			# users
			resources :users, only: [:index, :create, :new, :edit, :update, :destroy] do
				post :reset_two_factor_auth, on: :member
			end
			get 'users/:name/new' => 'users#new', as: :new_user_name

			# statistics
			resources :statistics_repositories, only: [:index, :show]
			resources :statistics_users, only: [:index, :show]
			get 'statistics/system' => 'statistics_system#index'

			# settings
			get 'system/index'
			post 'system/reindex_repositories'
		end
	end

	# everyone
	get 'reindex' => 'reindex#index'
	root :to => redirect('auth/sign_in')
	devise_for :users, path: 'auth'

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Example resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end
end
