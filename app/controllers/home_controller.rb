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
end
