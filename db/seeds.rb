# Seed data for Back On Track (Phase 1).
# Idempotent: safe to run repeatedly.

user = User.find_or_create_by!(email_address: "me@backontrack.app") do |u|
  u.name = "Ronan"
  u.password = "password"
  u.password_confirmation = "password"
  u.time_zone = "Europe/London"
  u.week_starts_on = "monday"
end

task_templates = [
  { title: "Drink 2L water",          category: "health",  frequency: "daily" },
  { title: "Go for a walk",           category: "fitness", frequency: "daily" },
  { title: "Eat a good breakfast",    category: "food",    frequency: "daily" },
  { title: "No takeaway",             category: "money",   frequency: "weekdays" },
  { title: "Prep lunch for tomorrow", category: "food",    frequency: "weekdays" },
  { title: "10-minute tidy",          category: "home",    frequency: "daily" },
  { title: "Sleep before midnight",   category: "health",  frequency: "daily", important: true }
]

task_templates.each_with_index do |attrs, index|
  user.task_templates.find_or_create_by!(title: attrs[:title]) do |template|
    template.category  = attrs[:category]
    template.frequency = attrs[:frequency]
    template.important = attrs.fetch(:important, false)
    template.position  = index
  end
end

puts "Seeded #{User.count} user(s) and #{user.task_templates.count} routine items."
