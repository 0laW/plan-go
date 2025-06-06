import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.map = window.mapInstance
    this.clearTimer = null
    window.userMarkers = []
    window.locationMarkers = []

    if (this.map) {
      this.initGeocoder()
      this.hideGeocoderInput()
    }

    this.inputTarget.addEventListener("input", () => this.clearAllMarkers())

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
    window.addEventListener('map:updateMarkers', this.handleUpdateMarkers.bind(this))
  }

  handleUpdateMarkers(event) {
  const markersData = event.detail.markers
  if (!markersData || !Array.isArray(markersData)) return

  this.clearAllMarkers()

  markersData.forEach(markerData => {
    const popup = new mapboxgl.Popup({ closeButton: false }).setHTML(markerData.info_window_html)

    const customMarker = document.createElement("div")
    customMarker.innerHTML = markerData.marker_html

    const marker = new mapboxgl.Marker(customMarker)
      .setLngLat([markerData.lng, markerData.lat])
      .setPopup(popup)
      .addTo(this.map)

    window.userMarkers.push(marker)
  })
}

  initGeocoder() {
    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      flyTo: true,
      marker: false
    })

    this.map.addControl(this.geocoder)

    this.geocoder.on("result", (e) => {
      const coords = e.result.center
      const el = document.createElement("div")
      el.className = "custom-marker"
      el.innerHTML = `<i class="fas fa-map-marker-alt fa-2x" style="color: #3b82f6;"></i>`

      this.clearAllMarkers()

      const marker = new mapboxgl.Marker(el).setLngLat(coords).addTo(this.map)
      window.locationMarkers.push(marker)

      this.clearUserUI()
    })
  }

  hideGeocoderInput() {
    const geocoderEl = document.querySelector(".mapboxgl-ctrl-geocoder")
    if (geocoderEl) geocoderEl.style.display = "none"
  }

 handleSearch(query) {
  this.clearAllMarkers()
  clearTimeout(this.clearTimer)

  this.clearTimer = setTimeout(() => {
    this.inputTarget.value = ""
    this.clearUserUI()
  }, 60000)

  this.tryUsernameSearch(query)
}

tryUsernameSearch(query) {
  fetch(`/users/search_users?username=${encodeURIComponent(query)}`)
    .then(res => (res.ok ? res.json() : null))
    .then(data => {
      if (!data) {
        this.clearUserUI()
        this.fallbackToGeocoder(query)
        return
      }

      this.displayUserData(data)
    })
    .catch(err => {
      console.error("Search error:", err)
      this.clearUserUI()
      this.fallbackToGeocoder(query)
    })
}

displayUserData(data) {
  if (data.center && this.map) {
    this.map.flyTo({ center: data.center, zoom: 6 })
  }

  this.clearMarkers(this.userMarkers)
  this.userMarkers = []

  data.markers.forEach(markerData => {
    const popup = new mapboxgl.Popup({ closeButton: false }).setHTML(markerData.info_window_html)

    const customMarker = document.createElement("div")
    customMarker.innerHTML = markerData.marker_html

    const marker = new mapboxgl.Marker(customMarker)
      .setLngLat([markerData.lng, markerData.lat])
      .setPopup(popup)
      .addTo(this.map)

    this.userMarkers.push(marker)
  })

  const infoBox = document.getElementById("user-info-box")
  if (infoBox) {
    infoBox.innerHTML = data.user_info_box_html || ""
    infoBox.style.display = "block"
  }

  const mapContainer = document.getElementById("map-container")
  if (mapContainer) mapContainer.classList.add("shrunk")
}

  clearUserUI() {
    const infoBox = document.getElementById("user-info-box")
    const mapContainer = document.getElementById("map-container")
    if (infoBox) infoBox.innerHTML = ""
    if (mapContainer) mapContainer.classList.remove("shrunk")
  }

  fallbackToGeocoder(query) {
    if (!this.geocoder || typeof this.geocoder.query !== "function") return

    this.clearAllMarkers()
    try {
      this.geocoder.query(query)
    } catch (err) {
      console.error("Geocoder failed:", err)
    }
  }

  clearAllMarkers() {
    this.clearMarkers(window.userMarkers)
    this.clearMarkers(window.locationMarkers)
    window.userMarkers = []
    window.locationMarkers = []
  }

  clearMarkers(markers) {
    if (!Array.isArray(markers)) return
    markers.forEach(marker => marker.remove())
  }
}
