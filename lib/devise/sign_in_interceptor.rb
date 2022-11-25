module Devise
  class SignInInterceptor
    def initialize(app, opts)
      @app    = app
      Rails.logger.info(app)
      @scope  = opts[:scope]
      @secret = opts[:secret]
      @klass  = opts[:klass]
    end

    def call(env)
      if user = Rack::Request.new(env).cookies[@secret]
        env['warden'].session_serializer.store(@klass.constantize.find(user), @scope)
      end

      @app.call(env)
    end
  end
end

# application.rb
# require File.expand_path('../../lib/devise/sign_in_interceptor', __FILE__)
# config.middleware.use Devise::SignInInterceptor, { :scope  => :user, :klass => 'User',
#                                            :secret => "our_very_very_long_secret" }
