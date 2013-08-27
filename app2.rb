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

# entry onto the form
get '/' do
    erb :form
end

# form completed
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
    elsif @chat=="Raisins"
        @user.chat_up_choice="raisins"
        @user.save
        erb :raisins
    else @user.chat_up_choice="drink"
        @user.save
        erb :index
    end
end


# user has hit send page to...
post '/:id' do
    @user=User.find_by(:id => params[:id])
    @user.recipient_email = params[:email]
    @user.save
    @link="http://stormy-crag-1959.herokuapp.com/"+@user.id
    Pony.mail(:to => @user.recipient_email, :subject => "Message from an admirer", :body => erb(:email))
    erb :thanks
end

# link in email has been clicked or list
get '/:id' do
    if params[:id]=="list"
        @users=User.all
        erb :list
    else
        @user=User.find_by(:id => params[:id])
        if @user.chat_up_choice=="alphabet"
            erb:alphabet
        elsif @user.chat_up_choice=="ticket"
            erb :ticket
        elsif @user.chat_up_choice=="nerd"
            erb :nerd
        elsif @user.chat_up_choice=="drink"
            erb :index
        elsif @user.chat_up_choice=="unique"
            erb :unique
        elsif @user.chat_up_choice=="raisins"
            erb :raisins
        elsif @user.chat_up_choice=="phone"
            erb :phone
        end
    end
end

# second page of raisins chat up
get '/date/:id' do
    @user=User.find_by(:id => params[:id])
    erb :date
end
