class RaidsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy]
  
  def index
    @raids = Raid.all
  end

  def show
    @raid = raid
    @organized_signups = organized_signups
    @signup = Signup.new
  end

  def create
    @raid = Raid.create(raid_params)
    if @raid.valid?
      redirect_to calendar_path
    else
      redirect_to calendar_path, alert: 'The information you have entered is incomplete.'
    end
  end

  def update
    raid.assign_attributes(raid_params)
    raid.save
    if raid.valid?
      redirect_to raid_path(raid)
    else
      redirect_to raid_path(raid), alert: 'That update is invalid.'
    end
  end

  def destroy
    raid.destroy
    redirect_to calendar_path, notice: 'You have successfully deleted a raid.'
  end
  
  private
    
  def raid
    @raid ||= Raid.find(params[:id])
  end

  def raid_params
    params.require(:raid).permit(:name, :start_time)
  end

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end

  def organized_signups
    tanks = []
    healing_priests = []
    healing_shamans = []
    healing_druids = []
    dps_warriors = []
    rogues = []
    ferals = []
    enhancements = []
    hunters = []
    mages = []
    warlocks = []
    shadows = []
    moonkins = []
    elementals = []
    healer_standbys = []
    dps_standbys = []
    healers_count = 0
    damage_dealers = 0
    signups = Signup.where(raid_id: raid)
    if raid.zg? || raid.aq?
      signups.each do |signup|
        raider = Raider.find(signup.user.raider_id)

        if raider.name == 'Ezpzlul' && tanks.count < 2
          tanks << signup
          next
        elsif raider.role == 'Tank' && tanks.count < 2
          tanks << signup
          next
        elsif  raider.role == 'Tank' && tanks.count >= 2 && damage_dealers < 13
          dps_warriors << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Healer' && healers_count < 5
          healing_priests << signup if raider.which_class == 'Priest'
          healing_shamans << signup if raider.which_class == 'Shaman' 
          healing_druids << signup if raider.which_class == 'Druid'
          healers_count += 1
          next
        elsif raider.role == 'Healer' && healers_count >= 5
          healer_standbys << signup
          healers_count += 1
          next
        elsif damage_dealers >= 13
          dps_standbys << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Fury'
          dps_warriors << signup 
          damage_dealers += 1
          next
        elsif raider.which_class == 'Rogue'
          rogues << signup 
          damage_dealers += 1
          next
        elsif raider.role == 'Feral'
          ferals << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Enhancement'
          enhancements << signup
          damage_dealers += 1
          next
        elsif raider.which_class == 'Hunter'
          hunters << signup 
          damage_dealers += 1
          next
        elsif raider.which_class == 'Mage'
          mages << signup
          damage_dealers += 1
          next
        elsif raider.which_class == 'Warlock'  
          warlocks << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Shadow'
          shadows << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Moonkin'
          moonkins << signup
          damage_dealers += 1
          next
        elsif raider.role == 'Elemental'
          elementals << signup
          damage_dealers += 1
          next
        else 
          next
        end
      end
    else
      signups.each do |signup|
        raider = Raider.find(signup.user.raider_id)

        if raider.role == 'Friends and Family-Healer' 
          healer_standbys << signup
          next
        end
        if raider.role == 'Friends and Family-DPS' 
          dps_standbys << signup
          next
        end
        tanks << signup if raider.role == 'Tank'
        healing_priests << signup if raider.role == 'Healer' && raider.which_class == 'Priest'
        healing_shamans << signup if raider.role == 'Healer' && raider.which_class == 'Shaman'
        healing_druids << signup if raider.role == 'Healer' && raider.which_class == 'Druid'
        dps_warriors << signup if raider.role == 'Fury'
        rogues << signup if raider.which_class == 'Rogue'
        ferals << signup if raider.role == 'Feral'
        enhancements << signup if raider.role == 'Enhancement'
        hunters << signup if raider.which_class == 'Hunter'
        mages << signup if raider.which_class == 'Mage'
        warlocks << signup if raider.which_class == 'Warlock'
        shadows << signup if raider.role == 'Shadow'
        moonkins << signup if raider.role == 'Moonkin'
        elementals << signup if raider.role == 'Elemental'
        next
      end
    end
    healers = healing_priests + healing_shamans + healing_druids
    melee = dps_warriors + rogues + ferals + enhancements
    ranged = hunters + mages + warlocks + shadows + moonkins + elementals
    raid = [tanks, healers, melee, ranged, healer_standbys, dps_standbys]
    return raid
  end
end
