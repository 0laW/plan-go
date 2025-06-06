import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.clearTimer = null

    this.inputTarget.addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        event.preventDefault()
        const query = this.inputTarget.value.trim()
        if (query.length) {
          this.searchUser(query)
          this.inputTarget.value = ""
        }
      }
    })
  }

  searchUser(username) {
    clearTimeout(this.clearTimer)

    this.clearTimer = setTimeout(() => {
      this.clearUI()
    }, 60000)

    fetch(`/users/search_users?username=${encodeURIComponent(username)}`)
      .then(res => res.ok ? res.json() : Promise.reject())
      .then(data => {
        if (!data) {
          this.clearUI()
          return
        }
        this.flyToAndUpdate(data)
      })
      .catch(() => this.clearUI())
  }

  flyToAndUpdate(data) {
    const map = window.mapInstance
    if (!map) {
      console.error("Map instance missing")
      return
    }

    // Remove previous moveend handlers
    map.off("moveend")

    const flyOptions = {
      center: data.first_trip_center || data.center || [2.2137, 46.2276],
      zoom: data.first_trip_center ? 12 : 6,
      speed: 1.2,
      curve: 1.6,
      easing(t) {
        return t * (2 - t)
      }
    }

    // After flyTo ends, update markers and UI
    const onMoveEnd = () => {
      this.updateMarkersAndUI(data)
      map.off("moveend", onMoveEnd)
    }

    map.on("moveend", onMoveEnd)
    map.flyTo(flyOptions)
  }

  updateMarkersAndUI(data) {
    window.dispatchEvent(new CustomEvent("map:updateMarkers", {
      detail: {
        markers: data.markers || [],
        skipFitBounds: true
      }
    }))

    const infoBox = document.getElementById("user-info-box")
    if (infoBox) {
      infoBox.innerHTML = data.user_info_box_html || ""
      infoBox.style.display = "block"
    }

    const mapContainer = document.getElementById("map-container")
    if (mapContainer) {
      mapContainer.classList.add("shrunk")
    }
  }

  clearUI() {
    const infoBox = document.getElementById("user-info-box")
    const mapContainer = document.getElementById("map-container")

    if (infoBox) {
      infoBox.innerHTML = ""
      infoBox.style.display = "none"
    }

    if (mapContainer) {
      mapContainer.classList.remove("shrunk")
    }

    window.dispatchEvent(new CustomEvent("map:updateMarkers", {
      detail: { markers: [] }
    }))
  }
}
