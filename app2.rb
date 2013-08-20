require 'sinatra'
require 'pony'
require 'mongoid'
require 'json'

Mongoid.load!("mongoid.yml")

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

class User
    include Mongoid::Document
    field :name
    field :recipient
    field :recipient_email
    field :chat_up_choice
    field :number
end

get '/' do
    erb :form
end

post '/' do
    @from = params[:from]
    @to = params[:to]
    @number= params[:number]
    @chat= params[:chat]
    @user=User.new(:name => @from, :recipient => @to, :number => @number)
    if @chat=="Alphabet"
        @user.chat_up_choice="alphabet"
        @user.save
        erb :alphabet
    elsif @chat=="Parking Ticket"
        @user.chat_up_choice="ticket"
        @user.save
        erb :ticket
    elsif @chat=="Me Without You"
        @user.chat_up_choice="nerd"
        @user.save
        erb :nerd
    elsif @chat=="Lost Number"
        @user.chat_up_choice="phone"
        @user.save
        erb :phone
    elsif @chat=="Be Unique"
        @user.chat_up_choice="unique"
        erb :unique
    else @user.chat_up_choice="drink"
        @user.save
        erb :index
    end
end

=begin
post '/:chat/:to/:from/:number' do
    @from = params[:from]
    @to= params[:to]
    @chat=params[:chat]
    @email=params[:email]
    @number=params[:number]
    @user=User.new(:name => @from, :recipient => @to, :chat_up_choice => @chat, :recipient_email => @email)
    @user.save
    @link="http://stormy-crag-1959.herokuapp.com/phone/"+@to+"/"+@from+"/"+@number
    Pony.mail(:to => @email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end
=end

post '/:id' do
    @user=User.find_by(:id => params[:id])
    @user.recipient_email = params[:email]
    @user.save
    if @user.chat_up_choice=="unique"
        @link="http://stormy-crag-1959.herokuapp.com/unique/"+@user.name+"/"+@user.recipient
    elsif @user.chat_up_choice=="drink"
        @link="http://stormy-crag-1959.herokuapp.com/drink/"+@user.name+"/"+@user.recipient
    elsif @user.chat_up_choice=="nerd"
        @link="http://stormy-crag-1959.herokuapp.com/nerd/"+@user.name+"/"+@user.recipient
    elsif @user.chat_up_choice=="ticket"
        @link="http://stormy-crag-1959.herokuapp.com/ticket"+@user.name+"/"+@user.recipient
    elsif @user.chat_up_choice=="alphabet"
        @link="http://stormy-crag-1959.herokuapp.com/alphabet/"+@user.name+"/"+@user.recipient
    elsif @user.chat_up_choice =="phone"
        @link="http://stormy-crag-1959.herokuapp.com/phone/"+@user.name+"/"+@user.recipient+"/"+@user.number
    end
    Pony.mail(:to => @user.recipient_email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end

=begin
post '/:chat/:to/:from' do
    @to=params[:to]
    @from=params[:from]
    @chat=params[:chat]
    @email=params[:email]
    @user=User.new(:name => @from, :recipient => @to, :chat_up_choice => @chat, :recipient_email => @email)
    @user.save
    if @chat=="unique"
        @link="http://stormy-crag-1959.herokuapp.com/unique/"+@to+"/"+@from
    elsif @chat=="drink"
        @link="http://stormy-crag-1959.herokuapp.com/drink/"+@to+"/"+@from
    elsif @chat=="nerd"
        @link="http://stormy-crag-1959.herokuapp.com/nerd/"+@to+"/"+@from
    elsif @chat=="ticket"
        @link="http://stormy-crag-1959.herokuapp.com/ticket"+@to+"/"+@from
    elsif @chat=="alphabet"
        @link="http://stormy-crag-1959.herokuapp.com/alphabet/"+@to+"/"+@from
    end
    Pony.mail(:to => @email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end
=end

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

get '/list' do
    @users = User.all
    erb :list
end
