$(function() {
  $.closeFolder = function(parent_id){
    $("tr[data-parent='" + parent_id + "']").each(function(){
      $.closeFolder($(this).data('id'));
    });
    $("tr[data-parent='" + parent_id + "']").remove();
  };

  $.refreshAdvancedAllCheckboxes = function(){
    var checked = ($('input:not(:checked)[type="checkbox"][id^="search_columns_"]').length == 0);
    $('#search_all_columns').prop('checked', checked);

    checked = ($('input:not(:checked)[type="checkbox"][id^="search_translation_columns_"]').length == 0);
    $('#search_all_translation_columns').prop('checked', checked);

    checked = ($('input:not(:checked)[type="checkbox"][id^="search_states_"]').length == 0);
    $('#search_all_states').prop('checked', checked);

    checked = ($('input:not(:checked)[type="checkbox"][id^="search_extra_"]').length == 0);
    $('#search_all_extra').prop('checked', checked);
  };

  $(document).on('change', '#search_glossary_type_id', function(){
    $('#search_advanced').prop('checked', false);
    $('#advanced_search').hide();
    $(this).parents('form').submit();
    $('#search_result').html('<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Searching...</div>');
  });

  $(document).on('change', '#search_language_id', function(){
    $(this).parents('form').submit();
    $('#search_result').html('<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Searching...</div>');
  });

  $(document).on('submit', '#search_form', function(){
    $('#search_result').html('<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Searching...</div>');
  });

  $(document).on('click', '#add_translation_link', function(){
    var a = $(this).data('url').split('/');
    a[4] = $('#new_translation_language_id').val();
    window.location.href = a.join('/');
  });

  $(document).on('click', '#search_advanced', function(){
    if ($(this).is(':checked')){
      $('#advanced_search').show();
      $('#advanced_search').find('input[type="checkbox"]').each(function(){
        $(this).prop('checked', $(this).data('default'));
      });

      $.refreshAdvancedAllCheckboxes();
    } else {
      $('#advanced_search').hide();
      $('#advanced_search').find('input[type="checkbox"]').each(function(){
        $(this).prop('checked', false);
      });
      $('#search_all_columns').prop('checked', false);
      $('#search_all_translation_columns').prop('checked', false);
    }
  });

  $(document).on('click', '#search_all_columns', function(){
    var check = $(this).is(':checked');
    $('#advanced_search').find('input[type="checkbox"][id^="search_columns_"]').each(function(){
      $(this).prop('checked', check);
    });
  });

  $(document).on('click', '#search_all_translation_columns', function(){
    var check = $(this).is(':checked');
    $('#advanced_search').find('input[type="checkbox"][id^="search_translation_columns_"]').each(function(){
      $(this).prop('checked', check);
    });
  });

  $(document).on('click', '#search_all_states', function(){
    var check = $(this).is(':checked');
    $('#advanced_search').find('input[type="checkbox"][id^="search_states_"]').each(function(){
      $(this).prop('checked', check);
    });
  });

  $(document).on('click', '#search_all_extra', function(){
    var check = $(this).is(':checked');
    $('#advanced_search').find('input[type="checkbox"][id^="search_extra_"]').each(function(){
      $(this).prop('checked', check);
    });
  });

  $(document).on('click', 'input[type="checkbox"][id^="search_columns_"]', function(){
    $.refreshAdvancedAllCheckboxes();
  });

  $(document).on('click', 'input[type="checkbox"][id^="search_translation_columns_"]', function(){
    $.refreshAdvancedAllCheckboxes();
  });

  $(document).on('click', 'input[type="checkbox"][id^="search_states_"]', function(){
    $.refreshAdvancedAllCheckboxes();
  });

  $(document).on('click', 'input[type="checkbox"][id^="search_extra_"]', function(){
    $.refreshAdvancedAllCheckboxes();
  });

  $(document).on('change', '#help_glossary_type_id', function(){
    $(this).parents('form').submit();
    $('#articles_result').html('<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Searching...</div>');
  });
});
