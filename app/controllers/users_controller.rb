class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /microposts/1
  # GET /microposts/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @public_user = User.find_by_user_id(params[:id])
      @single_user = [@public_user.tweets]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:public_user).permit(:name, :user_id)
    end

end