require 'unirest'


class PortfolioListsController < ApplicationController
    
    before_action :authorized, only: [:create, :destroy]

    def index
        portfolio_lists = PortfolioList.all
        
        render json: portfolio_lists
    end

    def create

        portfolio_list = PortfolioList.create(portfolio_list_params)

        # send the request to the API
        # check the price comparison for buying/selling 
        # update portfolio_list pending if necessary
        # either way you HAVE TO render json 

        ## YOU WILL NOT SEND A REQUEST DURING YOUR CRON JON UPDATE
        # if everyday you check the price, and it is low/high enough, it will update your db
        # it will NOT send that update to the frontend
        # the front has to make a reqeust to get that info 

        check_price(portfolio_list)
        # check_price_everyday(portfolio_list)
    end

    def check_price(portfolio_list)
        response = Unirest.get "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-quotes?region=US&lang=en&symbols=#{Stock.find(portfolio_list_params["stock_id"]).Symbol}",
            headers:{
                "X-RapidAPI-Host" => "apidojo-yahoo-finance-v1.p.rapidapi.com",
                # "X-RapidAPI-Key" => "cda4f230dcmsh426d91d9da3a340p1f9a8cjsnce4ac5f11d9f"
                "X-RapidAPI-Key" => "b7a05bf1admsh4d9bad370e6f604p1641ddjsn555780791a33"
            }
        current_price = response.body["quoteResponse"]["result"][0]["regularMarketPrice"]
        list_price = portfolio_list_params["price"].to_i
        # buy order
        if (portfolio_list_params["volume"].to_i > 0) & (list_price >= current_price)
            portfolio_list.update(pending: false)

            render json: portfolio_list 

        # sell order
        elsif (portfolio_list_params["volume"].to_i < 0) & (list_price <= current_price)
            portfolio_list.update(pending: false)

            render json: portfolio_list
        else
            render json: portfolio_list
        end
        
    end

    def check_price_everyday(portfolio_list)
        if portfolio_list
            response = Unirest.get "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-quotes?region=US&lang=en&symbols=#{Stock.find(portfolio_list_params["stock_id"]).Symbol}",
                headers:{
                    "X-RapidAPI-Host" => "apidojo-yahoo-finance-v1.p.rapidapi.com",
                    "X-RapidAPI-Key" => "b7a05bf1admsh4d9bad370e6f604p1641ddjsn555780791a33"
                    }
            current_price = response.body["quoteResponse"]["result"][0]["regularMarketPrice"]
            list_price = portfolio_list_params["price"].to_f

            if (portfolio_list_params["volume"].to_i > 0) & (list_price >= current_price)
                portfolio_list.update(pending: false)

            # sell order
            elsif (portfolio_list_params["volume"].to_i < 0) & (list_price <= current_price)
                portfolio_list.update(pending: false)

            else
                sleep 86400
                check_price_everyday
            end
        end
    end
    
    def destroy
        portfolio_list = PortfolioList.find(params[:id])
        portfolio_list.destroy
        
        render json: portfolio_list
    end

    private
    def portfolio_list_params 
        params.require(:portfolio_list).permit(:user_id, :stock_id, :price, :volume, :pending)
    end
end
