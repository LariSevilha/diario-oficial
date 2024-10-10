$(document).ready(function () {
  // Initialize Select2
  $('.select2').select2({
    placeholder: "Select one or more entities",
    allowClear: true,
    width: '100%'
  });

  // Function to uncheck other user types and reset fields
  function uncheckOtherUserTypes(checkedType) {
    if (checkedType === 'super_user') {
      $('#customCheckAdminUser').prop('checked', false);
      $('#customCheckCommonUser').prop('checked', false);
      toggleSelectFields(false, false); // Hide both selects
      resetFields();
      togglePermissions(false);
    } else if (checkedType === 'admin_user') {
      $('#customCheckSuperUser').prop('checked', false);
      $('#customCheckCommonUser').prop('checked', false);
      toggleSelectFields(true, false); // Show admin select, hide common select
      resetFields();
      togglePermissions(false);
    } else if (checkedType === 'common_user') {
      $('#customCheckSuperUser').prop('checked', false);
      $('#customCheckAdminUser').prop('checked', false);
      toggleSelectFields(false, true); // Show common select, hide admin select
      resetFields();
      togglePermissions(true);
    }
  }

  // Change event handlers for checkboxes
  $('#customCheckSuperUser').on('change', function () {
    if ($(this).is(':checked')) {
      uncheckOtherUserTypes('super_user');
    }
  });

  $('#customCheckAdminUser').on('change', function () {
    if ($(this).is(':checked')) {
      uncheckOtherUserTypes('admin_user');
    }
  });

  $('#customCheckCommonUser').on('change', function () {
    if ($(this).is(':checked')) {
      uncheckOtherUserTypes('common_user');
    } else {
      togglePermissions(false);
    }
  });

  // Function to show or hide select fields
  function toggleSelectFields(showAdmin, showCommon) {
    if (showAdmin) {
      $('#entity_ids_user_admin').closest('.form-group').show();
    } else {
      $('#entity_ids_user_admin').closest('.form-group').hide();
    }

    if (showCommon) {
      $('#entity_ids_common_user').closest('.form-group').show();
    } else {
      $('#entity_ids_common_user').closest('.form-group').hide();
    }
  }

  // Function to show or hide permissions
  function togglePermissions(show) {
    if (show) {
      $('#permissions').show();
    } else {
      $('#permissions').hide();
    }
  }

  // Function to reset fields
  function resetFields() {
    $('#permissions input[type="checkbox"]').prop('checked', false);
    $('.select2').val(null).trigger('change');
  }

  // Initialize the visibility of fields based on the initial state of the checkboxes
  togglePermissions($('#customCheckCommonUser').is(':checked'));
  toggleSelectFields($('#customCheckAdminUser').is(':checked'), $('#customCheckCommonUser').is(':checked'));
});
