// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output", "g", "pg", "pg13", "r" ]

  connect() {
    this.outputTarget.textContent = 'Rating Filter: '
  }

  toggleG() {
    const g = document.querySelectorAll('.rated-G')
    this.toggler(this.gTarget, g)
  }

  togglePG() {
    const pg = document.querySelectorAll('.rated-PG')
    this.toggler(this.pgTarget, pg)
  }

  togglePG13() {
    const pg13 = document.querySelectorAll('.rated-PG-13')
    this.toggler(this.pg13Target, pg13)
  }

  toggleR() {
    const r = document.querySelectorAll('.rated-R')
    this.toggler(this.rTarget, r)
  }

  toggler(target, movies) {
    let add, remove, display
    if (target.classList.contains('green')) {
      add = ['red', 'strikethrough']
      remove = ['green']
      display = 'none'
    } else {
      add = ['green']
      remove = ['red', 'strikethrough']
      display = 'flex'
    }

    [...movies].forEach((movie) => {
      movie.style.display = display
    })

    target.classList.remove(...remove)
    target.classList.add(...add)
  }
}
