// map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.currentPopup = null // Track currently opened popup

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [0, 51], // Center on UK/Europe
      zoom: 4
    })

    window.mapInstance = this.map

    // Parse markers if passed as a JSON string
    if (typeof this.markersValue === "string") {
      try {
        this.markersValue = JSON.parse(this.markersValue)
      } catch (e) {
        console.error("Invalid JSON for markers", e)
        this.markersValue = []
      }
    }

    this.#addMarkersToMap()

    if (!this.markersValue || this.markersValue.length === 0) {
      this.map.setCenter([2.2137, 46.2276]) // fallback center France
      this.map.setZoom(4)
    } else {
      this.#fitMapToMarkers()
    }

    this.map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // When popup opens, close the previous one
      popup.on('open', () => {
        if (this.currentPopup && this.currentPopup.isOpen()) {
          this.currentPopup.remove()
        }
        this.currentPopup = popup
      })

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => {
      bounds.extend([marker.lng, marker.lat])
    })
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
