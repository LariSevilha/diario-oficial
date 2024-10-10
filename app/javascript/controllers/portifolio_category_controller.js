import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["category", "portifolio"];

  connect() {
    console.log("PortifolioCategory controller connected");
  }

  categoryClick(e) {
    const category = e.target.dataset.category;
    this.filterPortifolios(category);
  }

  filterPortifolios(category) {
    setTimeout(() => {
      const portifolioElements = this.portifolioTargets;
      console.log("cards dos portifolios", portifolioElements);
  
      if (!portifolioElements) {
        console.log("Os elementos alvos 'portifolio' não foram encontrados.");
        return;
      }
  
      portifolioElements.forEach((element) => {
        if (category === "Todos" || element.dataset.category === category) {
          element.classList.remove("hidden");
        } else {
          element.classList.add("hidden");
        }
      });
    });
  }
}
