import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.map = window.mapInstance
    this.clearTimer = null
    window.userMarkers = window.userMarkers || []
    window.locationMarkers = window.locationMarkers || []

    if (this.map) {
      this.initGeocoder()
      this.hideGeocoderInput()
    }

    this.inputTarget.addEventListener("input", () => {
      this.clearMarkers(window.userMarkers)
      window.userMarkers.length = 0
      this.clearMarkers(window.locationMarkers)
      window.locationMarkers.length = 0
    })

    this.inputTarget.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault()
        const query = this.inputTarget.value.trim()
        if (query) {
          this.handleSearch(query)
          this.inputTarget.value = ""
        }
      }
    })
  }

  initGeocoder() {
    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      flyTo: true,
      marker: false // We'll use our own custom marker
    })

    this.map.addControl(this.geocoder)

    this.geocoder.on("result", (e) => {
      this.clearMarkers(window.locationMarkers)
      window.locationMarkers.length = 0

      const coords = e.result.center

      const el = document.createElement("div")
      el.className = "custom-marker"
      el.innerHTML = `<i class="fas fa-map-marker-alt fa-2x" style="color: #3b82f6;"></i>`

      const locationMarker = new mapboxgl.Marker(el)
        .setLngLat(coords)
        .addTo(this.map)

      window.locationMarkers.push(locationMarker)

      // Clear user markers too
      this.clearMarkers(window.userMarkers)
      window.userMarkers.length = 0
    })
  }

  hideGeocoderInput() {
    const geocoderEl = document.querySelector(".mapboxgl-ctrl-geocoder")
    if (geocoderEl) geocoderEl.style.display = "none"
  }

  handleSearch(query) {
    clearTimeout(this.clearTimer)
    this.clearTimer = setTimeout(() => {
      this.inputTarget.value = ""
    }, 60000)

    this.clearMarkers(window.userMarkers)
    window.userMarkers.length = 0
    this.clearMarkers(window.locationMarkers)
    window.locationMarkers.length = 0

    fetch(`/users/search_users?username=${encodeURIComponent(query)}`)
      .then(res => res.ok ? res.json() : null)
      .then(data => {
        const infoBox = document.getElementById("user-info-box")
        if (!data) {
          if (infoBox) infoBox.innerHTML = ""
          this.fallbackToGeocoder(query)
          return
        }

        if (data.center) {
          this.map.flyTo({ center: data.center, zoom: 6 })
        }

        data.markers.forEach(markerData => {
          const popup = new mapboxgl.Popup().setHTML(markerData.info_window_html)

          const customMarker = document.createElement("div")
          customMarker.innerHTML = markerData.marker_html

          const marker = new mapboxgl.Marker(customMarker)
            .setLngLat([markerData.lng, markerData.lat])
            .setPopup(popup)
            .addTo(this.map)

          window.userMarkers.push(marker)
        })

        if (infoBox) {
          infoBox.innerHTML = data.user_info_box_html || "<p class='text-muted'>No user info available.</p>"
        }
      })
      .catch(err => {
        console.error("Unexpected error during search:", err)
        this.fallbackToGeocoder(query)
      })
  }

  fallbackToGeocoder(query) {
    if (!this.geocoder || typeof this.geocoder.query !== "function") {
      console.warn("Geocoder not available or not ready.")
      return
    }

    this.clearMarkers(window.userMarkers)
    window.userMarkers.length = 0
    this.clearMarkers(window.locationMarkers)
    window.locationMarkers.length = 0

    try {
      this.geocoder.query(query)
    } catch (err) {
      console.error("Fallback geocoder query failed:", err)
    }
  }

  clearMarkers(markerArray) {
    if (Array.isArray(markerArray)) {
      markerArray.forEach(marker => marker.remove())
    }
  }
}
