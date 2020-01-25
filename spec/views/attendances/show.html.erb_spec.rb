require 'rails_helper'

RSpec.describe "attendances/show", type: :view do
  before(:each) do
    @attendance = assign(:attendance, Attendance.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
