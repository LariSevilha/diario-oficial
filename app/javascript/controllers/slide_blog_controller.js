import Carousel from 'stimulus-carousel'

// Connects to data-controller="slider"
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
      centeredSlides: true,
      slidesPerView: 1,
      grabCursor: true,
      freeMode: false,
      loop: true,
      mousewheel: false,
      speed: 1000,
      keyboard: {
        enabled: true
      },

      // Enabled autoplay mode
      autoplay: {
        delay: 4000,
        disableOnInteraction: false
      },

      // If we need pagination
      pagination: {
        el: ".swiper-pagination",
        dynamicBullets: false,
        clickable: true
      },

      // If we need navigation
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      },

      // Responsive breakpoints
      breakpoints: {
        640: {
          slidesPerView: 1.25,
          spaceBetween: 20
        },
        1024: {
          slidesPerView: 3,
          spaceBetween: 20
        }
      }
    }
  }
}
