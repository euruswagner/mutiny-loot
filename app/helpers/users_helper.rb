module UsersHelper
  def user_approve_path(u)
      return "/users/approve/#{u.id}"
  end
end
