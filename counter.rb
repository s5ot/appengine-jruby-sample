class Counter
  include DataMapper::Resource
  include DataMapper::Transaction::Resource
  property :id, Serial
  property :name, Text
  property :count, Integer

  def self.create_or_increment(name, delta)
    begin
      begin_transaction
      counter = self.class.first(:name => name)
      if counter
        counter.count += delta
      else
        self.class.new(:name => name, :count => delta)
        save
      end
      commit
    rescue
      rollback
    end
  end
end

# fix appengine-apis bug
module AppEngine::Labs::TaskQueue
  class Task
    def add(queue=nil)
      # queue = Queue.new(queue) unless Queue.kind_of? Queue
      queue = Queue.new(queue) unless queue.kind_of? Queue
      @handle = queue.java_queue.add(_task)
      self
    end
  end
end

