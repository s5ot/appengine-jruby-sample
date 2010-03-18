enable :sessions

get '/analyze' do
  @yahoo || yahoo_init
  @sentence = params['sentence'] ? params['sentence'].strip : ""
  if @sentence.size != 0
    @res = @yahoo.analyze(@sentence)
  else 
     flash.now['msg'] = "Sentenceを入力してください"
   end

#  if @res.include?('error') || @res.size == 0
#    flash.now['msg'] =  "結果がみつかりませんでした"
#    redirect '/analyze'
#    return
#  end
 
  erb :analyze
end

private
def yahoo_init
  conf = YAML.load_file(File.join('config', 'app_config.yml')) 
  @yahoo = Yahoo.new(conf['yahoo']['application_id']) 
end
