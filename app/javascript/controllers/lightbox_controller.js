import { Controller } from "@hotwired/stimulus"
// import 'lightgallery/css/lightgallery.css'
import lightGallery from "lightgallery"

export default class extends Controller {
  static values = {
    options: Object,
  }

  connect() {
    console.log("testando lightbox arquivo ljh,kn")
    this.lightGallery = lightGallery(this.element, {
      ...this.defaultOptions,
      ...this.optionsValue,
    })
  }

  disconnect() {
    this.lightGallery.destroy()
  }

  get defaultOptions() {
    return {}
  }
}
