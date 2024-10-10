function deleteImage(modelAttribute, id) {
  fetch(`/admin/services/remove_image`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    },
    body: JSON.stringify({ model_attribute: modelAttribute, id: id })
  }).then(response => {
    if (response.ok) {
      response.json().then(data => {
        if (data.success) {
          alert("Imagem removida com sucesso");
          document.getElementById(modelAttribute).style.display = "none";
        }
      });
    } else {
      alert("Erro ao remover a imagem");
    }
  });
}