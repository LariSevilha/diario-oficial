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
      slidesPerView: 2,
      spaceBetween: 4,
      keyboard: true,
      centeredSlides: true,
      loop: true,
      speed: 1000,
      autoplay: {
        delay: 3000,
        disableOnInteraction: false,
      },
      breakpoints: {
        1024: {
          slidesPerView: 5,
        },
        990: {
          slidesPerView: 4,
        },
        790: {
          slidesPerView: 3,
        },
        470: {
          slidesPerView: 2,
        }
      }
    }
  }
}
