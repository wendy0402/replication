require 'bundler/setup'
require 'sinatra/base'
require 'padrino-helpers'
require 'kaminari/sinatra'
require 'haml'
require 'sass'
require File.expand_path('../record.rb', __FILE__)

Schema.migrate!

class Replication < ::Sinatra::Base
  register Kaminari::Helpers::SinatraHelpers

  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use Rack::MethodOverride

  ROOT ||= File.expand_path("..", __FILE__)

  set :public_folder, ROOT + "/public"
  set :views,         ROOT + "/views"


  get "/style.sass" do
    sass :style
  end
  get '/' do
    @histories = History.order(:id).page(params[:page]).per(5)
    haml :index
  end
end

Replication.run!
