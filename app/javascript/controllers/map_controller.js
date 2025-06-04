// map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: { type: Array, default: [] }
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.currentPopup = null

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [2.2137, 46.2276], // Default: France center
      zoom: 4
    })

    window.mapInstance = this.map

    this.map.on("load", () => {
      this.#initializeMarkers()
      this.#maybeAddGeocoder()
    })
  }

  #initializeMarkers() {
    // Parse markers if needed
    if (typeof this.markersValue === "string") {
      try {
        this.markersValue = JSON.parse(this.markersValue)
      } catch (e) {
        console.error("Invalid JSON for markers", e)
        this.markersValue = []
      }
    }

    if (!this.markersValue || this.markersValue.length === 0) {
      this.map.setCenter([2.2137, 46.2276]) // fallback center France
      this.map.setZoom(4)
    } else {
      this.#addMarkersToMap()
      this.#fitMapToMarkers()
    }
  }

  #maybeAddGeocoder() {
    try {
      this.geocoder = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
        marker: false,
        placeholder: "Search for a place..."
      })

      this.map.addControl(this.geocoder)
    } catch (error) {
      console.warn("⚠️ Geocoder failed to initialize:", error)
    }
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      popup.on("open", () => {
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

    this.map.fitBounds(bounds, {
      padding: 70,
      maxZoom: 15,
      duration: 0
    })
  }
}
