get '/counter_index' do
  @counter = Counter.all(:name => "thecounter")
  erb :counter_index
end

post '/simple_counter' do
  queue = AppEngine::Labs::TaskQueue::Queue.new
  task = AppEngine::Labs::TaskQueue::Task.new({:url => '/workers/simplecounter', :countdown => 5, :params => {'name' => "thecounter", 'delta' => "1"}})
  #task = AppEngine::Labs::TaskQueue::Task.new(nil, {:url => '/workers/simplecounter', :params => {'name' => "thecounter", 'delta' => "1"}})
  queue.add(task)

  redirect '/counter_index'
end

get '/workers/simplecounter' do
  puts "called /workers/simplecounter"
  #Counter.begin_transaction
  #begin
  #  puts "name is #{params['name']}"
  #  puts "delta is #{params['delta']}"
  #  counter = Counter.first(:name => "thecounter")
  #  if counter
  #    puts "counter exists!"
  #    couter.count += delta
  #  else
  #    puts "counter not exists!"
  #    counter = Counter.new()
  #    counter.name = name
  #    counter.count = delta
  #    puts counter
  #    counter.save
  #  end
  #  Counter.commit
  #rescue
  #  Counter.rollback
  #end
  Counter.create_or_increment(params['name'], params['delta'])
end
