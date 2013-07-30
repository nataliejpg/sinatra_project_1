require 'sinatra'

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