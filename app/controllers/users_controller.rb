class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:index, :approve, :unapprove, :raider, :demote, :admin, :demote_admin, :connect]
  before_action :authenticate_gm!, only: [:guild_master, :demote_guild_master]
  
  def index
    @users = sorted_users_for_index
  end
  
  def show
    @user = User.find(params[:id])
    @unapproved_users = User.where(approved: false)
    @unconnected_users = User.where(raider_id: nil)
    @raiders = Raider.all
  end

  def approve
    user = User.find(params[:id])

    user.update_attributes(:approved => true)
    redirect_to user_index_path
  end

  def unapprove
    user = User.find(params[:id])

    user.update_attributes(:approved => false)
    redirect_to user_index_path
  end

  def raider
    user = User.find(params[:id])

    user.update_attributes(:approved_raider => true)
    redirect_to user_index_path
  end

  def demote
    user = User.find(params[:id])

    user.update_attributes(:approved_raider => false)
    redirect_to user_index_path
  end

  def admin
    user = User.find(params[:id])

    user.update_attributes(:admin => true)
    redirect_to user_index_path
  end

  def demote_admin
    user = User.find(params[:id])

    user.update_attributes(:admin => false)
    redirect_to user_index_path
  end

  def guild_master
    user = User.find(params[:id])

    user.update_attributes(:guild_master => true)
    redirect_to user_index_path
  end

  def demote_guild_master
    user = User.find(params[:id])

    if current_user == user
      redirect_to user_index_path, alert: 'You can not demote yourself from Guild Master.'
    else
      user.update_attributes(:guild_master => false)
      redirect_to user_index_path
    end
  end

  def connect
    user = User.find(params[:user_id])
    raider = Raider.find(params[:raider_id])

    user.raider_id = raider.id
    raider.user_id = user.id
    user.save
    raider.save
    redirect_to user_path(current_user)
  end

  private

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end

  def authenticate_gm!
    if current_user.guild_master != true || current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end

  def sorted_users_for_index
    users = User.all
    guild_master = []
    admins = []
    raiders = []
    approved = []
    unapproved = []
    users.each do |user|
      if user.guild_master
        guild_master << user
        next
      elsif user.admin
        admins << user
        next
      elsif user.approved_raider
        raiders << user
        next
      elsif user.approved
        approved << user
        next
      else
        unapproved << user
      end
    end
    
    return [guild_master, admins, raiders, approved, unapproved]
  end
end
