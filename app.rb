require 'sinatra'

get '/' do
    erb :index
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
    end
end

get '/:to' do
    @to =params[:to]
    erb :unique
end

get '/:to/:number' do
    @to = params[:to]
    @number= params[:number]
    erb :phone
end