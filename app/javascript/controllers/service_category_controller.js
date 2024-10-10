import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "category", "service" ];

  connect() {
    console.log("ServiceCategory controller connected");
  }

  categoryClick(e) {
    console.log("Category clicked", e.target.dataset.categoryId);
    this.filterServices(e.target.dataset.categoryId);
  }

  filterServices(categoryId) {
    const url = `/home/category_services?category_id=${categoryId}`;
    fetch(url)
     .then((response) => response.text())
     .then((html) => {
        const serviceCardsContainer = document.querySelector('.service-cards-container');
        serviceCardsContainer.innerHTML = html;
      });
  }
}