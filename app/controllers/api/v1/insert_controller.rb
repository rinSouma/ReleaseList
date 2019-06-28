module Api
  module V1
    class Api::V1::InsertController < ApplicationController
      def index
        begin
          puts "test"
        rescue=>e
        end
      end
    end
  end
end