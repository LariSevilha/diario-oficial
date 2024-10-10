document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('.delete-button').forEach(function (button) {
    button.addEventListener('click', function (event) {
      event.preventDefault();

      // Configurar a ação do botão de confirmação
      var confirmButton = document.getElementById('confirmDeleteButton');
      var formAction = this.getAttribute('formaction');

      confirmButton.onclick = function () {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = formAction;

        var methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'delete';
        form.appendChild(methodInput);

        var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        var csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'authenticity_token';
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);

        document.body.appendChild(form);
        form.submit();
      };

      // Exibir o modal
      $('#deleteConfirmationModal').modal('show');
    });
  });
});
