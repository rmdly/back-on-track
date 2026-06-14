require "test_helper"

class TaskTemplateTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @monday = Date.current.beginning_of_week(:monday)
    @tuesday = @monday + 1
    @saturday = @monday + 5
    @sunday = @monday + 6
  end

  test "requires a title and frequency" do
    template = @user.task_templates.new(title: nil, frequency: nil)
    assert_not template.valid?
    assert_includes template.errors[:title], "can't be blank"
    assert_includes template.errors[:frequency], "can't be blank"
  end

  test "daily templates are due every day" do
    template = @user.task_templates.new(title: "Water", frequency: :daily)
    assert template.due_on?(@monday)
    assert template.due_on?(@saturday)
    assert template.due_on?(@sunday)
  end

  test "weekday templates are due Monday to Friday only" do
    template = @user.task_templates.new(title: "No takeaway", frequency: :weekdays)
    assert template.due_on?(@monday)
    assert_not template.due_on?(@saturday)
    assert_not template.due_on?(@sunday)
  end

  test "weekend templates are due Saturday and Sunday only" do
    template = @user.task_templates.new(title: "Long run", frequency: :weekends)
    assert template.due_on?(@saturday)
    assert template.due_on?(@sunday)
    assert_not template.due_on?(@monday)
  end

  test "custom templates are due only on selected weekdays" do
    monday_bit = 1 << TaskTemplate::WEEKDAY_BITS[:monday]
    template = @user.task_templates.new(title: "Gym", frequency: :custom, weekdays_mask: monday_bit)
    assert template.due_on?(@monday)
    assert_not template.due_on?(@tuesday)
    assert template.weekday_enabled?(:monday)
    assert_not template.weekday_enabled?(:tuesday)
  end
end
