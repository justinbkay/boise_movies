import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["showtimes", "icon", "trailer"];

  toggleShowtimes() {
    const show = this.showtimes === "show";

    this.showtimesTarget.style.display = show ? "none" : "block";
    this.showtimes = show ? "hidden" : "show";
    this.iconTarget.innerHTML = show ? "local_movies" : "close";
  }

  renderTrailer(evt) {
    this.trailerTarget.innerHTML = evt.detail[0].body.innerHTML;
  }

  get showtimes() {
    return this.data.get("showtimes");
  }

  set showtimes(value) {
    console.log("setting ", value);
    this.data.set("showtimes", value);
  }
}
