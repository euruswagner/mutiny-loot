require 'rails_helper'

RSpec.describe "attendances/index", type: :view do
  before(:each) do
    assign(:attendances, [
      Attendance.create!(),
      Attendance.create!()
    ])
  end

  it "renders a list of attendances" do
    render
  end
end
