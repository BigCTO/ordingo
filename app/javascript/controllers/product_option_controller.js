// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import {Controller} from "@hotwired/stimulus"

let OPTION_SEPARATOR = '-op-sep-'
let OPTION_KEY_VAL_SEPARATOR = '-okv-sep-'

function getVariantDisplay(value){
  return value.split(OPTION_SEPARATOR).map((val) => {
    return val.split(OPTION_KEY_VAL_SEPARATOR)[1]
  }).join('/')
}

function clearInvalidVariants(validVariants){
  let allElements = document.getElementsByClassName("variant-field-tr")
  for(let i = allElements.length - 1; i >= 0; i--) {
    if(!validVariants.includes(allElements[i].classList[0])){
      allElements[i].parentNode.removeChild(allElements[i]);
    }
  }
}

export default class extends Controller {
  static targets = [ "links", "template", "variantTemplate", "variantBody"]

  connect() {
    this.wrapperClass = this.data.get("wrapperClass") || "nested-fields"
  }

  add_association(event) {
    event.preventDefault()
    var content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.linksTarget.insertAdjacentHTML('beforebegin', content)
  }

  generate_variant(event){
    event.preventDefault()
    let optionNames = document.getElementsByClassName("option-name")
    let optionValues = document.getElementsByClassName("option-value")
    let optionDestroy = document.getElementsByClassName("option-destroy")
    if(optionNames.length === 0){
      return
    }
    let options = []
    for(let i=0; i < optionNames.length; i++){
      if(optionDestroy[i].value != 1){
        options.push({"name": optionNames[i].value, "value": optionValues[i].value})
      }
    }
    let fd = new FormData();
    fd.append("options", JSON.stringify(options));
    let variantContentElement = this.variantBodyTarget
    let variantTemplateElement = this.variantTemplateTarget
    let validElements = []
    Rails.ajax({
      url: "/products/generate_variants/",
      type:'POST',
      data: fd,
      success: function (data){
        data.forEach((value) => {
          if(document.getElementsByClassName(value).length === 0){
                variantContentElement.insertAdjacentHTML('beforeend', variantTemplateElement.innerHTML
                    .replace(/NEW_RECORD/g, new Date().getTime())
                    .replace(/VARIANT_DISPLAY/g, getVariantDisplay(value))
                    .replace(/VARIANT_VALUE/g, value))
          }
          validElements.push(value)
        })
        clearInvalidVariants(validElements)
      }
    })
  }

  remove_association(event) {
    event.preventDefault()
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