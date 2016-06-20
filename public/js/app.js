$(document).ready(function(){
  $(".input").change(function(){
    $form=$('#form_for_table_input');
    selected_value = $('#table_select').val();
    $.ajax({
     	type: "POST",
     	url: $form.attr('action'),
     	data: $form.serialize()
     }).done(function (response) {
        response = JSON.parse(response)
        $('#output').val(response.data);
        var options = "<option>All</option>";
        for(var i = 1; i < response.count; i++ ) {
          options += "<option>"+i+"</option>";
        }
        $('#table_select').html( options );
        $('#table_select').val(selected_value);
    });
  });
  $(".download").click(function(e){
    e.preventDefault();
    if ($('#output').val().length != 0)
    {
      csv_form=$('#form_for_table_output');
      csv_form.attr('action',$(this).attr('href'));
      csv_form.submit();
    }
    else
     return false
  });
});
