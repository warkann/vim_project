class SearchController < ApplicationController

	# метод для поиска записей, получающий params[:q] из формы
	def search
    @results = PgSearch.multisearch(params[:q])
  end  
end
