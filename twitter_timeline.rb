
get '/twitter_timeline' do
  @twitter || twitter_init

  screen_name = params['screen_name'] ? params['screen_name'].strip : ""

  if screen_name.size != 0
    @res = @twitter.user_timeline(screen_name)
  else 
    flash.now['msg'] = "Usernameを入力してください"
  end

  if @res 
    if @res.include?('error') || @res.include?('Not found') || @res.include?('Not authorized') || @res.size == 0
       flash.now['msg'] = "Userがみつかりませんでした"
      @res = nil
    end
  end
  
  erb :twitter_timeline
end

private
def twitter_init
  conf = YAML.load_file(File.join('config', 'app_config.yml'))
  @twitter = Twitter.new(conf['user']['username'], conf['user']['password']) 
end
