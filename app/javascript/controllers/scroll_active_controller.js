import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section"]

  connect() {
    this.addActiveClass();
    window.addEventListener('scroll', () => this.addActiveClass());
  }

  disconnect() {
    window.removeEventListener('scroll', () => this.addActiveClass());
  }

  addActiveClass() {
    this.sectionTargets.forEach(section => {
      if (this.isElementInViewport(section)) {
        section.classList.add('active');
      }
      //  else {
      //   section.classList.remove('active');
      // }
    });
  }

  isElementInViewport(el) {
    const rect = el.getBoundingClientRect();
    const windowHeight = (window.innerHeight || document.documentElement.clientHeight);
    const visibleHeight = Math.min(windowHeight, rect.bottom) - Math.max(0, rect.top);
    const visiblePercentage = (visibleHeight / el.offsetHeight) * 100;
    return visiblePercentage >= 10;
  }
}