import { Application } from "@hotwired/stimulus"
import Lightbox from '@stimulus-components/lightbox'
import AnimatedNumber from '@stimulus-components/animated-number'

const application = Application.start()
application.register('lightbox', Lightbox)
application.register('animated-number', AnimatedNumber)

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
