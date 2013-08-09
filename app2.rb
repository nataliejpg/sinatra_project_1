require 'sinatra'
require 'pony'
require 'json'

Pony.options = { 
  :via => 'smtp',
  :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => ENV['USER_NAME'],
      :password             => ENV['PASSWORD'],
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  }

get '/' do
    erb :form
end

post '/' do
    @from = params[:from]
    @to = params[:to]
    @number= params[:number]
    if params[:chat]=="Alphabet"
        erb :alphabet
    elsif params[:chat]=="Parking Ticket"
        erb :ticket
    elsif params[:chat]=="Me Without You"
        erb :nerd
    elsif params[:chat]=="Lost Number"
        erb :phone
    elsif params[:chat]=="Be Unique"
        erb :unique
    else erb :index
    end
end

post '/:chat/:to/:from/:number' do
    @from = params[:from]
    @to= params[:to]
    chat=params[:chat]
    @email=params[:email]
    @number=params[:number]
    @link="http://stormy-crag-1959.herokuapp.com/phone/"+@to+"/"+@from+"/"+@number
    Pony.mail(:to => @email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end

post '/:chat/:to/:from' do
    @to=params[:to]
    @from=params[:from]
    chat=params[:chat]
    @email=params[:email]
    if chat=="unique"
        @link="http://stormy-crag-1959.herokuapp.com/unique/"+@to+"/"+@from
    elsif chat=="drink"
        @link="http://stormy-crag-1959.herokuapp.com/drink/"+@to+"/"+@from
    elsif chat=="nerd"
        @link="http://stormy-crag-1959.herokuapp.com/nerd/"+@to+"/"+@from
    elsif chat=="ticket"
        @link="http://stormy-crag-1959.herokuapp.com/ticket"+@to+"/"+@from
    elsif chat=="alphabet"
        @link="http://stormy-crag-1959.herokuapp.com/alphabet/"+@to+"/"+@from
    end
    Pony.mail(:to => @email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end

get '/:chat/:to/:from' do
    @from = params[:from]
    @to = params[:to]
    if params[:chat]=="alphabet"
        erb :alphabet
    elsif params[:chat]=="ticket"
        erb :ticket
    elsif params[:chat]=="nerd"
        erb :nerd
    elsif params[:chat]=="drink"
        erb :index
    elsif params[:chat]=="unique"
        erb :unique
    end
end


get '/:chat/:to/:from/:number' do
    @to = params[:to]
    @number= params[:number]
    @from= params[:from]
    erb :phone
end
