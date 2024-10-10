$(document).ready(function() {
  function limpa_formulário_cep() {
    $("#street").val("");
    $("#neighborhood").val("");
    $("#city").val("");
    $("#uf").val("");
  }
  $("#cep").blur(function() {    
    var cep = $(this).val().replace(/\D/g, '');
    if (cep != "") {      
      var validacep = /^[0-9]{8}$/;     
      if(validacep.test(cep)) {       
        $("#street").val("...");
        $("#neighborhood").val("...");
        $("#city").val("...");
        $("#uf").val("...");        
        $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {

          if (!("erro" in dados)) {          
            $("#street").val(dados.logradouro);
            $("#neighborhood").val(dados.bairro);
            $("#city").val(dados.localidade);
            $("#uf").val(dados.uf);
          } else {           
            limpa_formulário_cep();
          }
        });
      } else {   
        limpa_formulário_cep();
      }
    } else {   
      limpa_formulário_cep();
    }
  });
});