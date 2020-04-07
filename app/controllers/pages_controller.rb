class PagesController < ApplicationController
  def frontpage

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
end
