document
	.getElementById("new_section_form")
	.addEventListener("submit", function (event) {
		event.preventDefault(); // Prevents default form submission
		const formData = new FormData(this);
		const method = this.dataset.method || "post";
		const action = this.action;

		fetch(action, {
			method: method.toUpperCase(),
			headers: {
				"X-CSRF-Token": document
					.querySelector('meta[name="csrf-token"]')
					.getAttribute("content"),
			},
			body: formData,
		})
			.then((response) => {
				if (response.ok) {
					response.json().then((data) => {
						if (data.success) {
							if (method === "patch") {
								// Updates the corresponding row in the table
								updateSectionInTable(data.section);
							} else {
								// Add a new row to the table
								addSectionToTable(data.section);
							}

							// Close the modal after successfully saving
							$("#sectionModal").modal("hide");
						} else {
							alert("Erro ao salvar a Seção.");
						}
					});
				} else {
					alert("Erro ao enviar a solicitação.");
				}
			})
			.catch((error) => {
				console.error("Erro:", error);
				alert("Erro ao enviar a solicitação.");
			});
	});

function addSectionToTable(section) {
	const tableBody = document.querySelector("table tbody");

	// Create a new row in the table for the new section
	const newRow = document.createElement("tr");
	newRow.id = `section_${section.id}`;

	newRow.innerHTML = `
    <th scope="row">${tableBody.children.length + 1}</th>
    <td>${section.branch_government_name || ""}</td>
    <td>${section.diary_category_name || ""}</td>
    <td>${section.diary_sub_category_name || ""}</td>
		<td>${section.title || ""}</td>
    <td>
      <a class="btn btn-sm btn-warning text-white" onclick="editSection(${section.id
		})">
        Editar
      </a>
      <a class="btn btn-sm btn-danger text-white" onclick="deleteSection(${section.id
		})">
        Excluir
      </a>
    </td>
  `;

	// Add the new row to the end of the table body
	tableBody.appendChild(newRow);
}

function updateSectionInTable(section) {
	const row = document.getElementById(`section_${section.id}`);
	row.innerHTML = `
    <th scope="row">${row.rowIndex}</th>
    <td>${section.branch_government_name || ""}</td>
    <td>${section.diary_category_name || ""}</td>
    <td>${section.diary_sub_category_name || ""}</td>
		<td>${section.title || ""}</td>   
    <td>
      <a class="btn btn-sm btn-warning text-white" onclick="editSection(${section.id
		})">
        Editar
      </a>
      <a class="btn btn-sm btn-danger text-white" onclick="deleteSection(${section.id
		})">
        Excluir
      </a>
    </td>
  `;
}

function editSection(sectionId) {
	// Fetch section data via AJAX
	fetch(`/admin/sections/${sectionId}/edit`, {
		headers: {
			"X-CSRF-Token": document
				.querySelector('meta[name="csrf-token"]')
				.getAttribute("content"),
		},
	})
		.then((response) => response.json())
		.then((data) => {
			if (data.success) {
				// Fill in the modal fields with the section data
				document.getElementById("title").value = data.section.title || "";
				document.getElementById("sectionModalLabel").innerText = "Editar Seção";
				document.getElementById("branch_government_id").value =
					data.section.branch_government_id || "";
				document.getElementById("diary_category_id").value =
					data.section.diary_category_id || "";

				// Make AJAX request to load subcategories
				var categoryId = data.section.diary_category_id;
				if (categoryId) {
					fetch(`/admin/diary_categorys/${categoryId}/subcategories`)
						.then((response) => response.json())
						.then((subcategories) => {
							var subCategorySelect = document.getElementById(
								"diary_sub_category_id"
							);
							subCategorySelect.innerHTML =
								'<option value="">Selecione</option>';
							subcategories.forEach(function (subcategory) {
								var option = document.createElement("option");
								option.value = subcategory.id;
								option.text = subcategory.name;
								if (subcategory.id === data.section.diary_sub_category_id) {
									option.selected = true;
								}
								subCategorySelect.appendChild(option);
							});
						})
						.catch((error) =>
							console.error("Erro ao buscar subcategorias:", error)
						);
				} else {
					// Reset subcategory if no category is selected
					document.getElementById("diary_sub_category_id").innerHTML =
						'<option value="">Selecione</option>';
				}

				document.getElementById("content-type-radio").style.display = "none";

				if (data.section.content_type == "Arquivo") {
					document.getElementById("text_area_field").style.display = "none";
					document.getElementById("file_upload_field").style.display = "block";
					document.getElementById("table-file").style.display = "block";

					// Set the tableBody variable within the correct scope
					const tableBody = document.querySelector("#table-file tbody");
					tableBody.innerHTML = ""; // Clear the table before adding new files

					data.section.files.forEach((file) => {
						const row = document.createElement("tr");
						row.id = `file_section_${file.id}`;
						row.innerHTML = `
              <th scope="row">${file.id}</th>
              <td>${file.file_name}</td>
              <td>
                <a href="${file.file_url}" target="_blank" class="btn btn-sm btn-primary">Visualizar</a>
                <a class="btn btn-sm btn-danger" onclick="deleteFileSection(${file.id})" style="color:white">Excluir</a>
              </td>
            `;
						tableBody.appendChild(row);
					});
				} else {
					document.getElementById("text_area_field").style.display = "block";
					document.getElementById("file_upload_field").style.display = "none";
					document.getElementById("table-file").style.display = "none";
					$("#option2")
						.prop("checked", true)
						.closest("label")
						.addClass("active");
					$("#description").summernote("code", data.section.description || "");
				}

				document.getElementById(
					"new_section_form"
				).action = `/admin/sections/${sectionId}`;
				document.getElementById("new_section_form").dataset.method = "patch";

				// Open the modal
				$("#sectionModal").modal("show");
			} else {
				alert("Erro ao carregar os dados da Seção.");
			}
		});
}

function deleteFileSection(fileSectionId) {
	if (confirm("Tem certeza que deseja excluir este arquivo?")) {
		fetch(`/admin/file_sections/${fileSectionId}`, {
			method: "DELETE",
			headers: {
				"X-CSRF-Token": document
					.querySelector('meta[name="csrf-token"]')
					.getAttribute("content"),
			},
		})
			.then((response) => {
				if (response.ok) {
					//Remove the table row corresponding to the deleted file
					document.getElementById(`file_section_${fileSectionId}`).remove();
					alert("Arquivo excluído com sucesso.");
				} else {
					alert("Erro ao excluir o arquivo.");
				}
			})
			.catch((error) => {
				console.error("Erro:", error);
				alert("Erro ao enviar a solicitação.");
			});
	}
}

function deleteSection(sectionId) {
	alertify.confirm(
		"Tem certeza que deseja excluir esta seção?",
		function () {
			// If the user confirms, execute the DELETE request
			fetch(`/admin/sections/${sectionId}`, {
				method: "DELETE",
				headers: {
					"X-CSRF-Token": document
						.querySelector('meta[name="csrf-token"]')
						.getAttribute("content"),
				},
			})
				.then((response) => {
					if (response.ok) {
						document.getElementById(`section_${sectionId}`).remove();
						alertify.success("Seção excluída com sucesso.");
					} else {
						alertify.error("Erro ao excluir a Seção.");
					}
				})
				.catch((error) => {
					console.error("Erro:", error);
					alertify.error("Erro ao enviar a solicitação");
				});
		},
		function () {
			// If the user cancels, display a cancellation message
			alertify.error("A exclusão da seção foi cancelada.");
		}
	);
}

function truncate(str, n) {
	return str.length > n ? str.substr(0, n - 1) + "..." : str;
}

//Control the fields
$(document).ready(function () {
	// Initially shows/hides fields based on selected value
	toggleFields();

	// Adds an event to radio buttons to change the displayed fields
	$('input[name="section[content_type]"]').change(function () {
		toggleFields();
	});

	function toggleFields() {
		const contentType = $('input[name="section[content_type]"]:checked').val();

		if (contentType === "Arquivo") {
			$("#file_upload_field").show();
			$("#text_area_field").hide();
		} else if (contentType === "Texto") {
			$("#file_upload_field").hide();
			$("#text_area_field").show();
		}
	}
	document.getElementById("table-file").style.display = "none";
	// Launch Summernote
	$(".summernote").summernote({
		height: 200,
	});
});

$(document).ready(function () {
	$("#sectionModal").on("hidden.bs.modal", function () {
		document.getElementById("title").value = "";
		document.getElementById("sectionModalLabel").innerText = "Adicionar Seção";
		document.getElementById("branch_government_id").value = "";
		document.getElementById("diary_category_id").value = "";
		document.getElementById("diary_sub_category_id").value = "";
		$("#description").summernote("code", "");
		document.getElementById("table-file").style.display = "none";
		$('#file_upload_field input[type="file"]').val("");

		// clear form submit route
		$("#new_section_form").attr("action", "/admin/sections");
		$("#new_section_form").removeAttr("data-method");

		// Reset the content type buttons
		document.getElementById("content-type-radio").style.display = "block";
		$("#option1").prop("checked", true).closest("label").addClass("active");
		$("#option2").prop("checked", false).closest("label").removeClass("active");

		$("#file_upload_field").show();
		$("#text_area_field").hide();
	});
});

// Set subcategory
document.addEventListener("DOMContentLoaded", function () {
	//Adds a change event listener to the Diary Category field
	document
		.getElementById("diary_category_id")
		.addEventListener("change", function () {
			var categoryId = this.value;

			// Make an AJAX request to obtain subcategories based on the selected category
			if (categoryId) {
				fetch("/admin/diary_categorys/" + categoryId + "/subcategories")
					.then((response) => response.json())
					.then((data) => {
						// Clears the current subcategory field
						var subCategorySelect = document.getElementById(
							"diary_sub_category_id"
						);
						subCategorySelect.innerHTML = '<option value="">Selecione</option>';

						// Adds new subcategory options
						data.forEach(function (subcategory) {
							var option = document.createElement("option");
							option.value = subcategory.id;
							option.text = subcategory.name;
							subCategorySelect.appendChild(option);
						});
					})
					.catch((error) =>
						console.error("Erro ao buscar subcategorias:", error)
					);
			} else {
				// If no category is selected, clears the subcategory field
				document.getElementById("diary_sub_category_id").innerHTML =
					'<option value="">Selecione</option>';
			}
		});
});

// Disable links in diary link
document.addEventListener("DOMContentLoaded", function () {
	const disabledLinks = document.querySelectorAll('.disabled-link');
	disabledLinks.forEach(function (link) {
		link.addEventListener('click', function (event) {
			event.preventDefault();
		});
	});
});