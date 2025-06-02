// <!-- search_controller.js -->
import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = ["input"]

  connect() {
  this.geocoder = new MapboxGeocoder({
    accessToken: mapboxgl.accessToken,
    mapboxgl: mapboxgl,
    flyTo: true
  })

  const map = window.mapInstance
  if (map) {
    map.addControl(this.geocoder)
    const geocoderEl = document.querySelector('.mapboxgl-ctrl-geocoder')
    if (geocoderEl) geocoderEl.style.display = 'none'
  }

  // Clear markers as soon as user types anything new
  this.inputTarget.addEventListener("input", () => {
    if (window.userMarkers) {
      window.userMarkers.forEach(marker => marker.remove())
      window.userMarkers = []
    }
  })

  this.inputTarget.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault()
      const query = this.inputTarget.value.trim()
      if (query) {
        this.handleSearch(query)
        this.inputTarget.value = ""  // Reset input right after submit
      }
    }
  })

  this.clearTimer = null
}

  handleSearch(query) {
  clearTimeout(this.clearTimer)

  this.clearTimer = setTimeout(() => {
    this.inputTarget.value = ""
  }, 60000)

  fetch(`/search_users?username=${encodeURIComponent(query)}`)
  .then((res) => {
    if (!res.ok) throw new Error("User not found")
    return res.json()
  })
  .then((data) => {
    const map = window.mapInstance
    if (!map) return

    // 🧹 Clear ALL existing markers (user or location)
    if (window.userMarkers) {
      window.userMarkers.forEach(marker => marker.remove())
    }
    if (window.locationMarkers) {
      window.locationMarkers.forEach(marker => marker.remove())
    }
    window.userMarkers = []
    window.locationMarkers = []

    // 🗺️ Move camera to new center
    map.flyTo({ center: data.center, zoom: 6 })

    // 🧿 Add new markers from searched user trips
    data.markers.forEach(markerData => {
      const popup = new mapboxgl.Popup().setHTML(markerData.info_window_html)
      const customMarker = document.createElement("div")
      customMarker.innerHTML = markerData.marker_html

      const marker = new mapboxgl.Marker(customMarker)
        .setLngLat([markerData.lng, markerData.lat])
        .setPopup(popup)
        .addTo(map)

      window.userMarkers.push(marker)
    })

    // 🧾 Update the user info box
    const infoBox = document.getElementById("user-info-box")
    if (infoBox && data.user_info_html) {
      infoBox.innerHTML = data.user_info_html
    } else if (infoBox) {
      infoBox.innerHTML = "" // Clear if user not found
    }
  })
  .catch((err) => {
    console.log("Falling back to geocoder:", err)

    // 🌍 Trigger Mapbox Geocoder only
    if (this.geocoder && window.mapInstance) {
      // Clean up previous markers before searching a place
      if (window.userMarkers) {
        window.userMarkers.forEach(marker => marker.remove())
      }
      if (window.locationMarkers) {
        window.locationMarkers.forEach(marker => marker.remove())
      }
      window.userMarkers = []
      window.locationMarkers = []

      this.geocoder.query(query)
    }
  })
  }
}
