import Rails from 'rails-ujs'

export default {
  init() {
    var submit = false

    let orderRowList = document.querySelectorAll('tr.admin-orders')

    for(let orderRow of orderRowList) {
      let ownerNameEdit = orderRow.querySelector('.ticket-owner-name.edit')
      let ownerNameSave = orderRow.querySelector('.ticket-owner-name.save')
      let ownerNameInput = orderRow.querySelector('input.ticket-owner-name')
      let ownerEmailEdit = orderRow.querySelector('.ticket-owner-email.edit')
      let ownerEmailSave = orderRow.querySelector('.ticket-owner-email.save')
      let ownerEmailInput = orderRow.querySelector('input.ticket-owner-email')

      editInputOnClick(ownerNameInput, ownerNameEdit, ownerNameSave)
      editInputOnClick(ownerEmailInput, ownerEmailEdit, ownerEmailSave)
      submitOnClick(ownerNameSave, ownerNameInput.form)
      submitOnClick(ownerEmailSave, ownerEmailInput.form)
      beforeSubmit(ownerNameInput, ownerNameEdit, ownerNameSave)
      beforeSubmit(ownerEmailInput, ownerEmailEdit, ownerEmailSave)
      inputOnAjaxSuccess(ownerNameInput, ownerNameSave)
      inputOnAjaxSuccess(ownerEmailInput, ownerEmailSave)
    }

    function editInputOnClick(input, editButton, saveButton) {
      var currentValue = input.value
      editButton.addEventListener('click', function(e) {
        currentValue = input.value
        submit = false
        input.disabled = false
        input.classList.remove('has-background-success')
        input.classList.remove('is-static')
        input.removeAttribute('readonly')
        input.focus()
        editButton.classList.add('is-hidden')
        saveButton.classList.remove('is-hidden')
      })

      input.addEventListener('focusout', function(e) {
        if(submit || e.relatedTarget === saveButton) {
          return
        }
        input.value = currentValue
        input.classList.add('is-static')
        input.setAttribute('readonly','')
        editButton.classList.remove('is-hidden')
        saveButton.classList.add('is-hidden')
      })
    }

    function beforeSubmit(input, editButton, saveButton) {
      let form = input.form
      form.addEventListener('submit', function(e) {
        submit = true
        input.classList.add('is-static')
        input.setAttribute('readonly','')
        editButton.classList.remove('is-hidden')
        saveButton.classList.add('is-hidden')
      })
    }

    function submitOnClick(button, form) {
      button.addEventListener('click', function(e) {
        Rails.fire(form, 'submit')
      })
    }

    function inputOnAjaxSuccess(input, saveButton) {
      let form = input.form
      form.addEventListener('ajax:success', function(e) {
        input.classList.add('has-background-success')
        input.classList.add('is-static')
        input.setAttribute('readonly','')
        input.disabled = true
      })
    }
  }
}
