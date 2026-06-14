import { Controller } from "@hotwired/stimulus"

// Shows/hides a target element based on the value of a <select>.
// Usage:
//   data-controller="toggle" data-toggle-show-when-value="custom"
//   <select data-action="toggle#refresh" data-toggle-target="trigger">
//   <div data-toggle-target="field">…</div>
export default class extends Controller {
  static targets = ["trigger", "field"]
  static values = { showWhen: String }

  connect() {
    this.refresh()
  }

  refresh() {
    const shouldShow = this.triggerTarget.value === this.showWhenValue
    this.fieldTarget.classList.toggle("hidden", !shouldShow)
  }
}
