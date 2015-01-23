class Admin::StatisticsRepositoriesController < StatisticsRepositoriesController
  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find(params[:id])
    @statistics = repository_statistics @repository
  end
end
