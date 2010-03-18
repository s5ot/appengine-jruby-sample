require 'appengine-rack'
require 'appengine-apis/urlfetch'
require 'appengine-apis/memcache'
require 'appengine-apis/users'
require 'appengine-apis/images'
require 'appengine-apis/mail'
require 'appengine-apis/labs/taskqueue'
require 'appengine-apis/datastore'
require 'dm-core'

require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'yaml'
require 'json'
require 'rexml/document'
require 'exifr'

require 'twitter_timeline'
require 'twitter'
require 'yahoo_analyze'
require 'yahoo'
require 'application_helper'
require 'image_controller'
require 'image'
require 'mail_controller'
require 'counter'
require 'counter_controller'


AppEngine::Rack.configure_app(          
    :application => "sample-app",           
    :precompilation_enabled => true,
    :version => "1")

run Sinatra::Application
