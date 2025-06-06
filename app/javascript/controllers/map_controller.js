import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.markers = []
    this.currentPopup = null

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [2.2137, 46.2276], // France center
      zoom: 4
    })

    window.mapInstance = this.map

    this.map.on("load", () => {
      // No initial markers, wait for search events
    })

    window.addEventListener("map:updateMarkers", (event) => {
      const { markers, skipFitBounds = false } = event.detail
      this.updateMarkers(markers, skipFitBounds)
    })
  }

  updateMarkers(markers, skipFitBounds = false) {
    // Clear old markers
    this.clearMarkers()

    if (!markers || markers.length === 0) {
      if (!skipFitBounds) this.resetMapView()
      return
    }

    markers.forEach(m => {
      if (typeof m.lng !== "number" || typeof m.lat !== "number") return

      const popup = new mapboxgl.Popup({ closeButton: false })
        .setHTML(m.info_window_html || "")

      popup.on("open", () => {
        if (this.currentPopup && this.currentPopup.isOpen()) {
          this.currentPopup.remove()
        }
        this.currentPopup = popup
      })

      const el = document.createElement("div")
      el.innerHTML = m.marker_html || `<div style="width:20px;height:20px;background:#798645;border-radius:50%;"></div>`

      const marker = new mapboxgl.Marker(el)
        .setLngLat([m.lng, m.lat])
        .setPopup(popup)
        .addTo(this.map)

      this.markers.push(marker)
    })

    if (!skipFitBounds) this.fitBoundsToMarkers()
  }

  clearMarkers() {
    this.markers.forEach(m => m.remove())
    this.markers = []
  }

  fitBoundsToMarkers() {
    if (this.markers.length === 0) {
      this.resetMapView()
      return
    }

    const bounds = new mapboxgl.LngLatBounds()
    this.markers.forEach(m => bounds.extend(m.getLngLat()))
    this.map.fitBounds(bounds, { padding: 60, maxZoom: 12 })
  }

  resetMapView() {
    this.map.setCenter([2.2137, 46.2276])
    this.map.setZoom(4)
  }
}
