// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "links", "template" ]

  connect() {
    this.wrapperClass = this.data.get("wrapperClass") || "nested-fields"
    console.log(this.wrapperClass)
  }

  add_association(event) {
    event.preventDefault()

    console.log("it should add")

    var content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.linksTarget.insertAdjacentHTML('beforebegin', content)
  }

  remove_association(event) {
    event.preventDefault()
    console.log("it should remove")
    let wrapper = event.target.closest("." + this.wrapperClass)

    // New records are simply removed from the page
    if (wrapper.dataset.newRecord == "true") {
      wrapper.remove()

    // Existing records are hidden and flagged for deletion
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = 1
      wrapper.style.display = 'none'
    }
  }
}