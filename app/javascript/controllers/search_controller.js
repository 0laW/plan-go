import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
import mapboxgl from "mapbox-gl"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      flyTo: true
    })
    // this is for the input, it listens to enter when a user pressed it
    this.inputTarget.addEventListener("keydown", (e) => {
      if(e.key === "Enter"){
        e.preventDefault()
        this.handleSearch(this.inputTarget.value.trim())
      }
    })
    this.clearTimer = null
  }
  // this handles the search of a user with small or capital letters, or numbers included, sets a timeout after 1 minute after the search is been made, so the data dissapears after one minute
  handleSearch(query) {
    clearTimeout(this.clearTimer)
    this.clearTimer = setTimeout(() => {
      this.inputTarget.value = ""
    }, 60000);
      this.searchUser(query)
  }


  searchUser(username) {
    fetch(`/search_users?username=${encodeURIComponent(username)}`)
    .then((res) => {
      if (!res.ok) throw new Error("User not found")
      return res.json()
    })
    .then((data) => {
      const map = window.mapInstance
      map.flyTo({ center: data.center, zoom: 6 })

      if (window.userMarkers) {
        window.userMarkers.forEach(marker => marker.remove())
      }

      window.userMarkers = []

      data.markers.forEach((markerData) => {
        const popup = new mapboxgl.Popup().setHTML(markerData.info_window_html)
        const customMarker = document.createElement("div")
        customMarker.innerHTML = markerData.marker_html

        const marker = new mapboxgl.Marker(customMarker)
          .setLngLat([markerData.lng, markerData.lat])
          .setPopup(popup)
          .addTo(map)

        window.userMarkers.push(marker)
      })
    })
    .catch((err) => {
      // If user not found, fall back to geocoder
      console.log(err, "er")
      this.geocoder.query(username)
    })
  }
}
