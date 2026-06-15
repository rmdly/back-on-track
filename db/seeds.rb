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

# --- Food (Phase 3) ---

def item_for(user, name)
  user.shopping_items.find_by(name: name)
end

meals = [
  # name, meal_type, protein, effort, prep, cost_pence, [[ingredient, qty, unit, library_name], ...]
  ["Oats with banana", "breakfast", "medium", "easy", 5, 60, [
    ["Oats", 80, "g", "Oats"], ["Banana", 1, nil, "Bananas"], ["Milk", 200, "ml", "Milk"]
  ]],
  ["Greek yoghurt bowl", "breakfast", "high", "easy", 5, 120, [
    ["Greek yoghurt", 200, "g", "Greek yoghurt"], ["Banana", 1, nil, "Bananas"], ["Peanut butter", 1, "tbsp", "Peanut butter"]
  ]],
  ["Egg wraps", "breakfast", "high", "easy", 10, 150, [
    ["Eggs", 3, nil, "Eggs"], ["Wraps", 2, nil, "Wraps"], ["Spinach", 1, "handful", "Spinach"]
  ]],
  ["Chicken rice bowl", "dinner", "high", "medium", 25, 250, [
    ["Chicken breast", 1, nil, "Chicken breast"], ["Rice", 100, "g", "Rice"], ["Broccoli", 1, "head", "Broccoli"]
  ]],
  ["Tuna pasta", "lunch", "high", "easy", 15, 180, [
    ["Tuna", 1, "tin", "Tuna"], ["Pasta", 100, "g", "Pasta"], ["Light mayo", 1, "tbsp", "Light mayo"]
  ]],
  ["Mince and rice", "dinner", "high", "medium", 25, 280, [
    ["Mince", 250, "g", "Mince"], ["Rice", 100, "g", "Rice"], ["Onions", 1, nil, "Onions"]
  ]],
  ["Jacket potato with tuna", "dinner", "high", "easy", 30, 150, [
    ["Potatoes", 1, nil, "Potatoes"], ["Tuna", 1, "tin", "Tuna"], ["Light mayo", 1, "tbsp", "Light mayo"]
  ]]
]

meals.each do |name, meal_type, protein, effort, prep, cost, ingredients|
  meal = user.meals.find_or_create_by!(name: name) do |m|
    m.meal_type = meal_type
    m.protein_level = protein
    m.effort_level = effort
    m.prep_time_minutes = prep
    m.estimated_cost_cents = cost
  end

  next if meal.meal_ingredients.any?

  ingredients.each_with_index do |(ing_name, qty, unit, library_name), index|
    meal.meal_ingredients.create!(
      name: ing_name, quantity: qty, unit: unit, position: index,
      shopping_item: item_for(user, library_name)
    )
  end
end

puts "Seeded #{User.count} user(s), #{user.task_templates.count} routine items, " \
     "#{user.stores.count} stores, #{user.shopping_items.count} shopping items " \
     "and #{user.meals.count} meals."
