require "date"

class HomeController < ApplicationController
    def index
        getUser
        @genre_data = {"漫画" => 0, "小説" => 1}
        @genre_key = params[:genre]
        @genre_key = 0 if @genre_key.blank?

        #DBの最小から最大までの年を取得してリストにする
        now = Date.today
        max = List.maximum(:release_date)
        min = List.minimum(:release_date)
        max_year = max.year
        min_year = min.year
        @year_data = {}
        for y in max_year..min_year do
            @year_data[y.to_s+"年"] = y
        end
        @year_key = params[:year]
        @year_key = now.year if @year_key.blank?

        #月は判定めんどくさいので12ヶ月固定
        @month_data = {"1月" => 1, "2月" => 2, "3月" => 3, "4月" => 4, \
                        "5月" => 5, "6月" => 6, "7月" => 7, "8月" => 8, \
                        "9月" => 9, "10月" => 10, "11月" => 11, "12月" => 12}
        @month_key = params[:month]
        @month_key = now.month if @month_key.blank?

        if params[:year].present? and params[:month].present? then
            now = Date.new(params[:year].to_i, params[:month].to_i, 1)
        end

        #指定ジャンル・指定年月の一か月分を取得
        @lists = List.where(:genre => @genre_key, \
                            :release_date=>now.beginning_of_month..now.end_of_month)\
                            .order(:release_date, {decision_flg: :desc})
    end

    def input
        @isbn = params[:isbn]
        @data = List.find_by(isbn: params[:isbn])
        trello = Trello_API.new(session[:token], ENV['TRELLO_API_KEY'])
        board_list = trello.get_boards
        @board_data = {}
        board_list.each do | data |
            @board_data[data[:name].to_sym] = data[:id]
        end
        #前回値情報を取得する
        if session[:input_time].present? then
            @input_time = session[:input_time]
        else
            @input_time = "T12:00:00"
        end
        puts session[:board_id]
        if session[:board_id].present? then
            @board_id = session[:board_id]
        else
            @board_id = board_list[0][:id]
        end

        list_list = trello.get_lists(@board_id)
        @list_data = {}
        list_list.each do | data |
            @list_data[data[:name].to_sym] = data[:id]
        end
        if session[:list_id].present? then
            @list_id = session[:list_id]
        else
            @list_id = list_list[0][:id]
        end

        label_list = trello.get_labels(@board_id)
        @label_data = {}
        @label_data["ラベルを使用しない"] = ""
        label_list.each do | data |
            @label_data[data[:name].to_sym] = data[:id]
        end
        if session[:label_id].present? then
            @label_id = session[:label_id]
        else
            @label_id = ""
        end
    end

    def get_item
        trello = Trello_API.new(session[:token], ENV['TRELLO_API_KEY'])
        @board_id = params[:board_id]
        list_list = trello.get_lists(@board_id)
        @list_data = {}
        list_list.each do | data |
            @list_data[data[:name].to_sym] = data[:id]
        end
        if session[:list_id].present? then
            @list_id = session[:list_id]
        else
            if list_list[0].present? then
                @list_id = list_list[0][:id]
            end
        end

        label_list = trello.get_labels(@board_id)
        @label_data = {}
        @label_data["ラベルを使用しない"] = ""
        label_list.each do | data |
            @label_data[data[:name].to_sym] = data[:id]
        end
        if session[:label_id].present? then
            @label_id = session[:label_id]
        else
            @label_id = ""
        end
    end
end
