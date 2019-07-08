require "date"

class HomeController < ApplicationController
    include Trello
    def index
        now = Date.today
        max = List.maximum(:release_date)
        min = List.minimum(:release_date)

        max_year = max.year
        min_year = min.year
        @year_data = {}
        for y in max_year..min_year do
            @year_data[y] = y
        end
        @year_key = params[:year]
        @year_key = now.year if @year_key.blank?

        @month_data = {"1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "11" => 11, "12" => 12}
        @month_key = params[:month]
        @month_key = now.month if @month_key.blank?

        if params[:year].present? and params[:month].present? then
            now = Date.new(params[:year].to_i, params[:month].to_i, 1)
        end
        @lists = List.where(:release_date=>now.beginning_of_month..now.end_of_month).order(:release_date)
    end
end
