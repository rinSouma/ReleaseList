class EntryController < ApplicationController
    def trello_entry
        trello = Trello_API.new(session[:token], ENV['TRELLO_API_KEY'])
        trello.name = params[:title]
        trello.desc = params[:desc]
        trello.pos = "bottom"
        trello.due = params[:due].to_time
        trello.due_complete = false
        trello.id_list = params[:list]
        trello.id_labels = params[:label]
        if trello.set_card then
            @status = "success"

            #次回登録用にsessionに保存
            session[:board_id] = params[:board_id]
            session[:list_id] = params[:list]
            session[:label_id] = params[:label]
            session[:input_time] = get_time(params[:due])
        else
            @status = "failed"
        end
    end

    def get_time(date_time)
        _, time = date_time.split("T")
        return "T" + time.to_s
    end

end
