$(function() {
  $(document).on('change', '#search_glossary_type_id', function(){
    $(this).parents('form').submit();
  });
  $(document).on('change', '#search_language_id', function(){
    $(this).parents('form').submit();
  });
});
