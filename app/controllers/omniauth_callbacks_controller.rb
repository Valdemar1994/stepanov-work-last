class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
  
    auth ||= request.env['omniauth.auth']

    user = User.find_by(email: auth.info.email)
   
    if user.present?
      sign_out_all_scopes
      sign_in_and_redirect user, event: :authentication
    else
      redirect_to new_user_session_path,
      alert: t('devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized.")
    end
  end
end
