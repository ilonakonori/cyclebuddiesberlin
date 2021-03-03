import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'count' ];

  connect() {
    setInterval(this.refresh, 5000);
  }

  refresh = () => {
    fetch('/users/unread', { headers: { accept: "application/json" } } )
      .then(response => response.json())
      .then((data) => {
        if(data.unread) {
          this.countTarget.className = 'fas fa-bell';
        } else {
          this.countTarget.classList.remove('fas');
          this.countTarget.classList.remove('fa-bell');
        }
        console.log(data.unread);
      });

  }
}
