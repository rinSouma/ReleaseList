class HomeController < ApplicationController
    include Trello
    def index
        test = Trello_API.new(session[:token], ENV['TRELLO_API_KEY'])
        test.name = "test_name "
        test.desc = "test_desc "
        test.pos = "bottom"
        test.due = Time.now
        test.due_complete = false
        test.id_list = "5d22c4a0039fd444064481de"
        test.id_labels = "5d22c498af988c41f2ae98c1"
        test.set_card

        @board = test.get_boards
        @list = []
        @label = []
        @board.each do | board_data |
            @list << test.get_lists(board_data[:id])
            @label << test.get_labels(board_data[:id])
        end
    end
end
