require 'sinatra/base'
require 'sinatra/assetpack'
require "sinatra/reloader"
require 'haml'
require 'sass'
require File.expand_path('../record.rb', __FILE__)

Schema.migrate!

class Replication < ::Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::AssetPack

  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use Rack::MethodOverride

  ROOT ||= File.expand_path("..", __FILE__)

  set :public_folder, ROOT + "/public"
  set :views,         ROOT + "/views"


  get "/style.sass" do
    sass :style
  end
  get '/' do
    @history = History.all
    haml :index
  end
end

Replication.run!
