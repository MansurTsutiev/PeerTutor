Rails.application.routes.draw do

  get 'chat/index'

  get 'tutor/index'

  get 'tutor/incoming_requests'

  get 'tutor/complete_tutoring_session'

  get 'tutor/currently_tutoring'

  get 'tutor/tutor_profile'

  get 'tutor/piggy_bank'

  get 'tutor/messenger'

  get 'tutor/toggle_is_live'

  get 'tutor/is_live'

  post 'tutor/toggle_is_live'

  get 'tutee/index'

  get 'tutee/find_tutor'
  post 'tutee/find_tutor' => 'tutee#create'

  get 'tutee/tutoring_sessions'

  get 'tutee/tips_management'

  get 'tutee/currency'

  get 'tutee/schedule'

  get 'tutee/messenger'

  get 'tutee/being_tutored'

  get 'tutee/list_of_tutors'

  get 'tutee/pick_tutor'

  get 'tutee/cancel_tutor'

  get 'tutee/cancel_tutoring_session'

  get 'tutee/profile'

  root 'home#index'

  get 'home/authentication'

  get 'tutor/first_time_tutor'
  post 'tutor/first_time_tutor' => 'tutor#create'

  post 'tutor/update'

  get 'thanks' , to: 'currencies#thanks', as: 'thanks'

  get 'stripe_accounts/full', to: 'stripe_accounts#full'

  post 'currency/update'

  get 'tutee/get_courses'

  get 'tutee/update'

  post 'tutor/update'

  get 'tutor/accept_request'
  get 'tutor/toggle_is_live'
  post 'tutor/add_location'

  get 'tutee/temp'

  get 'tutor/decline_request'

  devise_for :users,
  controllers: { sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    unlocks: 'users/unlocks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :conversations, only: [:create] do
    member do
      post :close
    end

    resources :messages, only: [:create]
  end

  resources :tutee, only: [:find_tutor] do
    collection do
      get 'get_courses'  # /tutee/get_courses
    end
  end
  resources :tutors
  resource :currency
  resources :stripe_accounts
  resources :bank_accounts

  resources :tutor, only: [:first_time_tutor] do
    collection do
      get 'get_courses'
    end
  end

  resources :tutor, only: [:first_time_tutor] do
    collection do
      get 'get_tags' # /tutor/get_tags
    end
  end
end
