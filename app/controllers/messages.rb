class Messages < Application
  provides :log

  def index(page = 1)
    if params.include? 'query' and not params['query'].empty?
      @messages = Message.weight_search(:conditions => [params['query']], :limit => 10, :offset => 10 * (page.to_i-1))
    else
      @messages = Message.all(:limit => 10, :offset => 10 * (page.to_i-1), :order => [:created_at.desc])
    end
    display @messages
  end

  def show(id)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end
  
  def log(host, channel, year, month, day)
    from = Time.local(year.to_i, month.to_i, day.to_i)
    to = from + 1.day
  
    @messages = Server.first(:host=>host).channels.first(:name=>'#' + channel).messages(:created_at => (from..to), :event => :message, :order=>[:created_at.asc])
    
    raise NotFound if @messages.empty?
    
    display @messages
  end
end # Messages
