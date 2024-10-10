import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    
    const linkAbout = document.getElementById('link-about');
    const linkNews = document.getElementById('link-news');
    const mobileMenu = document.getElementById('mobile-menu');

    mobileMenuButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('mobile-menu-visible');
    });
    linkAbout.addEventListener('click', () => {
      mobileMenu.classList.toggle('mobile-menu-visible');
    });
    linkNews.addEventListener('click', () => {
      mobileMenu.classList.toggle('mobile-menu-visible');
    });

    const navElement = document.getElementById('nav');

    window.addEventListener('scroll', () => {
      if (window.scrollY > 100) {
        navElement.classList.add('blur-bg');
      } else {
        navElement.classList.remove('blur-bg');
      }
    });
  }
}
