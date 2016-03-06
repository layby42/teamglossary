$(function(){
  $(document).on('change', '#glossary_term_reference_type_id', function(){
    if ($('#glossary_term_reference_type_id > option:selected').data('code') == 'M'){
      $('#glossary_term_glossary_term_id').val('');
      $('#glossary_term_glossary_term_id').prop('disabled', true);
      $('#glossary_term_glossary_term_id').prop('required', false);
    } else {
      $('#glossary_term_glossary_term_id').prop('disabled', false);
      $('#glossary_term_glossary_term_id').prop('required', true);
    }
  });

  $(document).on('change', '#glossary_name_proper_name_type_id', function(){
    if ($('#glossary_name_proper_name_type_id > option:selected').data('has-dates')){
      $('#glossary_name_dates').prop('disabled', false);
    } else {
      $('#glossary_name_dates').val('');
      $('#glossary_name_dates').prop('disabled', true);
    }
  });

  $(document).on("click", ".button.rtl", function(){
    var $this = $(this);
    $this.parents('.input-group').find('.form-control').each(function(){
      $(this).attr("dir", "rtl");

      $this.html("LTR");
      $this.removeClass("rtl");
      $this.addClass("ltr");
    });
  });

  $(document).on("click", ".button.ltr", function(){
    var $this = $(this);
    $this.parents('.input-group').find('.form-control').each(function(){
      $(this).attr("dir", "ltr");

      $this.html("RTL");
      $this.removeClass("ltr");
      $this.addClass("rtl");
    });
  });
});
