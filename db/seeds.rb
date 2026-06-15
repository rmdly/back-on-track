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

# --- Shopping (Phase 2) ---

["Aldi", "Lidl", "Tesco", "Iceland", "Home Bargains"].each_with_index do |name, index|
  user.stores.find_or_create_by!(name: name) { |s| s.position = index }
end

aldi = user.stores.find_by(name: "Aldi")

shopping_items = [
  # [name, category, default_quantity, default_unit, price_pence, store]
  ["Chicken breast",   "protein",   1,   "kg",   549, aldi],
  ["Eggs",             "protein",   12,  "pack", 189, aldi],
  ["Tuna",             "protein",   4,   "pack", 350, aldi],
  ["Greek yoghurt",    "dairy",     1,   "tub",  150, aldi],
  ["Mince",            "protein",   500, "g",    279, aldi],
  ["Turkey slices",    "protein",   1,   "pack", 149, aldi],
  ["Rice",             "carbs",     1,   "kg",   175, aldi],
  ["Pasta",            "carbs",     500, "g",     69, aldi],
  ["Oats",             "carbs",     1,   "kg",   135, aldi],
  ["Potatoes",         "carbs",     2.5, "kg",   199, aldi],
  ["Wraps",            "carbs",     8,   "pack", 110, aldi],
  ["Bagels",           "carbs",     5,   "pack", 119, aldi],
  ["Bananas",          "fruit_veg", 5,   "pack",  79, aldi],
  ["Apples",           "fruit_veg", 6,   "pack", 165, aldi],
  ["Frozen mixed veg", "fruit_veg", 1,   "bag",  119, aldi],
  ["Spinach",          "fruit_veg", 1,   "bag",   89, aldi],
  ["Broccoli",         "fruit_veg", 1,   "head",  59, aldi],
  ["Onions",           "fruit_veg", 1,   "bag",   89, aldi],
  ["Coffee",           "drinks",    200, "g",    329, aldi],
  ["Milk",             "dairy",     2,   "litre", 125, aldi],
  ["Peanut butter",    "other",     1,   "jar",  155, aldi],
  ["Light mayo",       "other",     1,   "jar",  120, aldi],
  ["Pasta sauce",      "other",     1,   "jar",   95, aldi]
]

shopping_items.each do |name, category, qty, unit, pence, store|
  user.shopping_items.find_or_create_by!(name: name) do |item|
    item.category = category
    item.default_quantity = qty
    item.default_unit = unit
    item.estimated_unit_price_cents = pence
    item.store = store
  end
end

puts "Seeded #{User.count} user(s), #{user.task_templates.count} routine items, " \
     "#{user.stores.count} stores and #{user.shopping_items.count} shopping items."
