import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    setTimeout(() => {
      this.inputTarget.value = ""
    }, 0)
  }
}
