import Carousel from 'stimulus-carousel'

// Connects to data-controller="carousel-thumb"
export default class extends Carousel {
  connect() {
    super.connect()

    // The swiper instance.
    this.swiper

    // Default options for every carousels.
    this.defaultOptions
  }

  // You can set default options in this getter.
  get defaultOptions() {
    return {
      // Your default options here
      "navigation": {
        "nextEl": ".swiper-button-next",
        "prevEl": ".swiper-button-prev"
      },
      "pagination": {
        "el": ".swiper-pagination",
        "clickable": true,
      },
      "thumbs": {
        "swiper": {
          "el": ".swiper-thumbs",
          "slidesPerView": 3,
          "spaceBetween": 10,
          "watchSlidesVisibility": true,
          "watchSlidesProgress": true,
          "breakpoints": {
          "768": {
            "slidesPerView": 5
          }
        }
        },
      },
      slidesPerView: 1,
      keyboard: true,
      loop: true,
    }
  }
}
