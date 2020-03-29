import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "showtimes", "icon" ]

  toggleShowtimes() {
    const show = this.showtimes === 'show'

    this.showtimesTarget.style.display = show ? 'none' : 'block'
    this.showtimes = show ? 'hidden' : 'show'
    this.iconTarget.innerHTML = show ? 'local_movies' : 'close'
  }

  get showtimes() {
    return this.data.get('showtimes')
  }

  set showtimes(value) {
    console.log('setting ', value)
    this.data.set('showtimes', value)
  }
}