require "jscov/coverage"

module Jscov
  class CoveragesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      raw_data = JSON.parse(params[:coverage])
      coverage = Jscov::Coverage.new(raw_data)
      coverage.save
      head :no_content
    end
  end
end
