$(function() {
  $(document).on('change', '#search_glossary_type_id', function(){
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
});
