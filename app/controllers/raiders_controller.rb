class RaidersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]
  before_action :authenticate_admin!, only: [:new, :create, :update]

  def index
    raiders = Raider.all
    @melee = sorted_melee(raiders)
    @ranged = sorted_ranged(raiders)
    @healers = sorted_healers(raiders)
    @retired = Raider.where(role: 'Retired')
  end

  def show
    @raider = Raider.find(params[:id])
  end

  def new
    @raider = Raider.new
  end

  def create
    @raider = Raider.create(raider_params)
    if @raider.valid?
      redirect_to raider_path(@raider)
    else
      redirect_to new_raider_path, alert: 'The information you have entered is incomplete.'
    end
  end

  def update
    @raider = Raider.find(params[:id])
    @raider.assign_attributes(raider_params)
    @raider.save
    if @raider.valid?
      redirect_to raider_path(@raider)
    else
      redirect_to raider_path(@raider), alert: 'That update is invalid.'
    end
  end

  private

  def raider_params
    params.require(:raider).permit(:name, :which_class, :role)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end

  def sorted_melee(raiders)
    active_warriors_sorted = raiders.where(which_class: 'Warrior').where.not(role: 'Retired').order(created_at: :asc)
    active_rogues_sorted = raiders.where(which_class: 'Rogue').where.not(role: 'Retired').order(created_at: :asc)
    active_enhancement_sorted = raiders.where(role: 'Enhancement').order(created_at: :asc)
    active_feral_sorted = raiders.where(role: 'Feral').order(created_at: :asc)
    sorted_melee = active_warriors_sorted + active_rogues_sorted + active_enhancement_sorted + active_feral_sorted
    return sorted_melee
  end

  def sorted_ranged(raiders)
    active_hunters_sorted = raiders.where(which_class: 'Hunter').where.not(role: 'Retired').order(created_at: :asc)
    active_mages_sorted = raiders.where(which_class: 'Mage').where.not(role: 'Retired').order(created_at: :asc)
    active_warlocks_sorted = raiders.where(which_class: 'Warlock').where.not(role: 'Retired').order(created_at: :asc)
    active_shadow_sorted = raiders.where(role: 'Shadow').order(created_at: :asc)
    active_elemental_sorted = raiders.where(role: 'Elemental').order(created_at: :asc)
    active_moonkin_sorted = raiders.where(role: 'Moonkin').order(created_at: :asc)
    sorted_ranged = active_hunters_sorted + active_mages_sorted + active_warlocks_sorted + active_shadow_sorted + active_elemental_sorted + active_moonkin_sorted
    return sorted_ranged
  end

  def sorted_healers(raiders)
    active_priests_sorted = raiders.where(which_class: 'Priest', role: 'Healer').order(created_at: :asc)
    active_shamans_sorted = raiders.where(which_class: 'Shaman', role: 'Healer').order(created_at: :asc)
    active_druids_sorted = raiders.where(which_class: 'Druid', role: 'Healer').order(created_at: :asc)
    sorted_healers = active_priests_sorted + active_shamans_sorted + active_druids_sorted
    return sorted_healers
  end   
end
