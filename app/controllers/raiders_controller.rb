class RaidersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :enchanted, :warlock]
  before_action :authenticate_admin!, only: [:new, :create, :update, :enchanted, :warlock]

  def index
    @raiders = sorted_raiders_for_index
  end

  def show
    @raider = Raider.find(params[:id])
    @phase_three_priorities = @raider.priorities.where(phase: 3)
    @phase_five_priorities = @raider.priorities.where(phase: 5)
  end

  def search
    if params[:search].blank? then  
      redirect_to(root_path, alert: "Empty field!") and return  
    else  
      @parameter = params[:search].downcase  
      @items = Item.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")
    end 
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

  def enchanted
    raider = Raider.find(params[:raider_id])
    if raider.enchanted?
      raider.write_attribute(:enchanted, false)
      raider.save
      raider.update_total_points_earned(-0.1)
    else
      raider.write_attribute(:enchanted, true)
      raider.save
      raider.update_total_points_earned(0.1)
    end
    redirect_to raider_path(raider)
  end

  def warlock
    raider = Raider.find(params[:raider_id])
    if raider.warlock?
      raider.write_attribute(:warlock, false)
      raider.save
      raider.update_total_points_earned(-0.1)
    else
      raider.write_attribute(:warlock, true)
      raider.save
      raider.update_total_points_earned(0.1)
    end
    redirect_to raider_path(raider)
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

  def sorted_raiders_for_index
    active_warriors = []
    active_rogues = []
    active_enhancement = []
    active_feral = []
    active_hunters = []
    active_mages = []
    active_warlocks = []
    active_shadow = []
    active_elemental = []
    active_moonkin = []
    active_priests = []
    active_shamans = []
    active_druids = []
    friends_and_family_healer = []
    friends_and_family_dps = []
    retired = []

    raiders = Raider.all.order(:created_at)
    raiders.each do |raider|
      if raider.role == 'Retired'
        retired << raider
        next
      elsif raider.role == 'Friends and Family-Healer'
        friends_and_family_healer << raider
        next
      elsif raider.role == 'Friends and Family-DPS'
        friends_and_family_dps << raider
        next
      elsif raider.which_class == 'Warrior'
        active_warriors << raider
        next
      elsif raider.which_class == 'Rogue'
        active_rogues << raider
        next
      elsif raider.which_class == 'Shaman' && raider.role == 'Enhancement'
        active_enhancement << raider
        next
      elsif raider.which_class == 'Druid' && raider.role == 'Feral'
        active_feral << raider
        next
      elsif raider.which_class == 'Hunter'
        active_hunters << raider
        next
      elsif raider.which_class == 'Mage'
        active_mages << raider
        next
      elsif raider.which_class == 'Warlock'
        active_warlocks << raider
        next
      elsif raider.which_class == 'Priest' && raider.role == 'Shadow' 
        active_shadow << raider
        next
      elsif raider.which_class == 'Shaman' && raider.role == 'Elemental'
        active_elemental << raider
        next
      elsif raider.which_class == 'Druid' && raider.role == 'Moonkin'
        active_moonkin << raider
        next
      elsif raider.which_class == 'Priest' && raider.role == 'Healer' 
        active_priests << raider
        next
      elsif raider.which_class == 'Shaman' && raider.role == 'Healer'
        active_shamans << raider
        next
      elsif raider.which_class == 'Druid' && raider.role == 'Healer'
        active_druids << raider
        next 
      else
        next 
      end           
    end
    active_melee = active_warriors + active_rogues + active_enhancement + active_feral
    active_ranged = active_hunters + active_mages + active_warlocks + active_shadow + active_elemental + active_moonkin
    active_healers = active_priests + active_shamans + active_druids
    sorted_raiders_for_index = [active_melee, active_ranged, active_healers, friends_and_family_healer, friends_and_family_dps, retired]
    return sorted_raiders_for_index
  end
end
