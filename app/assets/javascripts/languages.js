$(function() {
  $.closeFolder = function(parent_id){
    $("tr[data-parent='" + parent_id + "']").each(function(){
      $.closeFolder($(this).data('id'));
    });
    $("tr[data-parent='" + parent_id + "']").remove();
  }

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
    } else {
      $('#advanced_search').hide();
      $('#advanced_search').find('input[type="checkbox"]').each(function(){
        $(this).prop('checked', false);
      });
    }
  });
});
