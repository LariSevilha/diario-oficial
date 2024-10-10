import { Controller } from "@hotwired/stimulus"
import IframeLightbox from '@stimulus-components/lightbox'

export default class extends Controller {
  static targets = ['lightbox', 'iframe']

  connect() {
    this.lightbox = IframeLightbox.attach(this.lightboxTarget)
  }

  openLightbox() {
    this.lightboxTarget.classList.remove('hidden')
    this.lightboxTarget.classList.add('flex')
    this.lightbox.open()
    this.iframeTarget.contentWindow.postMessage('{"command": "mute", "property": true}', '*') // mute the video
    this.iframeTarget.contentWindow.postMessage('{"command": "playVideo"}', '*') // play the video
  }
  
  closeLightbox() {
    this.lightboxTarget.classList.remove('flex')
    this.lightboxTarget.classList.add('hidden')
    this.lightbox.close()
    this.iframeTarget.contentWindow.postMessage('{"command": "pauseVideo"}', '*') // pause the video
  }
}