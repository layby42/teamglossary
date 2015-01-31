CKEDITOR.editorConfig = function (config) {
  config.toolbar = "Full";

  config.toolbar_Full = [
      { name: 'styles', items : [ 'Format','Font','FontSize' ] },
      { name: 'colors', items : [ 'TextColor','BGColor' ] },
      { name: 'basicstyles', items : [ 'Bold','Italic','Underline','-','RemoveFormat' ] },
      { name: 'paragraph', items : [ 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote' ] },
      { name: 'links', items : [ 'Link','Unlink' ] },
      { name: 'insert', items : [ 'Table','HorizontalRule','Smiley','SpecialChar' ] },
      { name: 'mode', items : [ 'Source' ] }
  ];

  config.height = '400px';
  // ... rest of the original config.js  ...
}
