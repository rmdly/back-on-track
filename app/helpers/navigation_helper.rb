module NavigationHelper
  # Top-level product sections. Sections without a :path are not built yet and
  # render as disabled "Soon" items so the nav reflects the full product shape.
  def nav_sections
    [
      { key: :today,    label: "Today",    path: root_path },
      { key: :week,     label: "Week" },
      { key: :food,     label: "Food" },
      { key: :shopping, label: "Shopping" },
      { key: :training, label: "Training" },
      { key: :running,  label: "Running" },
      { key: :settings, label: "Settings", path: settings_path }
    ]
  end

  def nav_active?(section)
    case section[:key]
    when :today    then current_page?(root_path) || controller_name == "daily_tasks"
    when :settings then controller_name == "settings"
    else false
    end
  end

  # Small inline SVG icons (heroicons-style, 24x24, stroke).
  def nav_icon(key)
    paths = {
      today:    %(<path d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0V11.25A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/>),
      week:     %(<path d="M8.25 6.75h12M8.25 12h12M8.25 17.25h12M3.75 6.75h.007v.008H3.75V6.75Zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0ZM3.75 12h.007v.008H3.75V12Zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Zm-.375 5.25h.007v.008H3.75v-.008Zm.375 0a.375.375 0 1 1-.75 0 .375.375 0 0 1 .75 0Z"/>),
      food:     %(<path d="M21 15.75v-1.5a2.25 2.25 0 0 0-2.25-2.25H5.25A2.25 2.25 0 0 0 3 14.25v1.5m18 0a2.25 2.25 0 0 1-2.25 2.25H5.25A2.25 2.25 0 0 1 3 15.75m18 0v.75a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3v-.75M12 3v9"/>),
      shopping: %(<path d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25 5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z"/>),
      training: %(<path d="M6 12h12M6.75 8.25v7.5M17.25 8.25v7.5M3.75 9.75v4.5M20.25 9.75v4.5"/>),
      running:  %(<path d="M13.5 4.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3ZM6 21l3-6 3 1.5V21m0-7.5L9.75 9l3-1.5L15 9l2.25.75M9.75 9 7.5 10.5"/>),
      settings: %(<path d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.431l-1.003.827c-.293.241-.438.613-.43.992a7.03 7.03 0 0 1 0 .255c-.008.378.137.75.43.991l1.004.827c.424.35.534.955.26 1.43l-1.298 2.247a1.125 1.125 0 0 1-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.47 6.47 0 0 1-.22.128c-.331.183-.581.495-.644.869l-.213 1.281c-.09.543-.56.94-1.11.94h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 0 1-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 0 1-1.369-.49l-1.297-2.247a1.125 1.125 0 0 1 .26-1.431l1.004-.827c.292-.24.437-.613.43-.991a6.932 6.932 0 0 1 0-.255c.007-.38-.138-.751-.43-.992l-1.004-.827a1.125 1.125 0 0 1-.26-1.43l1.297-2.247a1.125 1.125 0 0 1 1.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.086.22-.128.332-.183.582-.495.644-.869l.214-1.281Z"/><path d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/>)
    }
    tag.svg(paths[key]&.html_safe, xmlns: "http://www.w3.org/2000/svg", fill: "none",
            viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor",
            class: "w-6 h-6", "stroke-linecap": "round", "stroke-linejoin": "round")
  end
end
