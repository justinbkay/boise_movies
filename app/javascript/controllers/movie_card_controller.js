import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "showtimes", "icon" ]

  toggleShowtimes() {
    if (this.showtimes === 'show') {
      this.showtimesTarget.style.display = 'none'
      this.showtimes = 'hidden'
      this.iconTarget.innerHTML = 'local_movies'
    } else {
      this.showtimesTarget.style.display = 'block'
      this.showtimes = 'show'
      this.iconTarget.innerHTML = 'close'
    }
  }

  get showtimes() {
    return this.data.get('showtimes')
  }

  set showtimes(value) {
    console.log('setting ', value)
    this.data.set('showtimes', value)
  }
}