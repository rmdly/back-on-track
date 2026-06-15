module MoneyHelper
  # Format integer cents as currency, e.g. money(1250) => "£12.50".
  def money(cents)
    return "—" if cents.blank?

    "£#{format('%.2f', cents / 100.0)}"
  end

  # Colour class for a budget-bearing record (responds to over_budget?).
  def budget_status_class(record)
    return "text-gray-500" unless record.respond_to?(:over_budget?)

    record.over_budget? ? "text-red-600" : "text-emerald-600"
  end
end
