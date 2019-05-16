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
  static targets = [ "output", "g", "pg", "pg13", "r", "unrated" ]

  connect() {
    this.outputTarget.textContent = ''
  }

  titleSearch(e) {
    const term = e.currentTarget.value
    const titles = document.querySelectorAll('.title-rating > h2')

    const display = term.length === 0 ? 'flex' : 'none'

    document.querySelectorAll('.card.horizontal.hoverable').forEach((movie) => {
      movie.style.display = display
    })

    titles.forEach((title) => {
      const result = title.innerHTML.toLowerCase().indexOf(term.toLowerCase())
      if (result !== -1) {
        title.parentNode.parentNode.parentNode.parentNode.style.display = 'flex'
      }
    })
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

  toggleUnrated() {
    const unrated = document.querySelectorAll('.rated-')
    this.toggler(this.unratedTarget, unrated)
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
