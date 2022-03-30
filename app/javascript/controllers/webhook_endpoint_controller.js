import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
    static targets = []


    initialize() {
        super.initialize()
    }

    enableOrDisable(id){
        Rails.ajax({
            url: "/webhook_endpoints/change_enabled/"+id,
            type:'POST',
            success: function (){
                alert("Status changed successfully.")
            }
        })
    }

    handleChange(e) {
        let id = e.target.id.replace( /^\D+/g, '');
        this.enableOrDisable(id)
    }
}
