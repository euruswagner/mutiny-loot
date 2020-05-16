class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:incomplete_items]

  def frontpage

  end

  def calendar
    @raids = Raid.all
    @raid = Raid.new
  end

  def search
    if params[:search].blank? then  
      redirect_to(root_path, alert: "Empty field!") and return  
    else  
      @parameter = params[:search].downcase  
      @items = Item.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")
      @raiders = Raider.all.where("lower(name) LIKE :search", search: "%#{@parameter}%") 
    end  
  end

  def naxx

  end

  def aq
    @aq_items = Item.where(zone: 'Temple of Ahn\'Qiraj')
  end

  def bwl
    @bwl_items = Item.where(zone: 'Blackwing Lair')
  end

  def mc
    @mc_items = Item.where(zone: ['Molten Core', 'Onyxia'])
  end

  def world_bosses
    @world_bosses_items = Item.where(zone: ['Nightmare Dragons', 'Emeriss', 'Lethon', 'Taerar', 'Ysondre', 'Lord Kazzak', 'Azuregos'])
  end

  def incomplete_items
    @items_missing_zone = Item.where(zone: [nil, ''])
    @items_missing_priority = Item.where(priority: [nil, ''])
    @items_missing_category = Item.where(category: [nil, ''])
  end

  private

  def authenticate_admin!
    if current_user.admin != true
      redirect_to root_path, alert: 'You do not have the privileges required to do that.'
    end
  end 
end
