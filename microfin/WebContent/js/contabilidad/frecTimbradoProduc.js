var parametroBean = consultaParametrosSession();
$(document).ready(function() {
;
consultaAutTimbradoRol(parametroBean.perfilUsuario);
  //------------ Metodos y Manejo de Eventos -----------------------------------------

 agregaFormatoControles('formaGenerica');
  var esTab = "";
  var catTransaccionfrecTimbrarProduc = {
    'grabar':'2'
  };

  deshabilitaBoton('grabar','submit');
 $('#frecuenciaID').focus();
  $(':text').focus(function() {
    esTab = false;
  });


$(':text').bind('keydown',function(e){
    if (e.which == 9 && !e.shiftKey){
      esTab= true;
    }
  });

  $.validator.setDefaults({
        submitHandler: function(event) {
              grabaFormaTransaccionRetrollamada(event, 'formaGenerica',
                'contenedorForma', 'mensaje','true','frecuenciaID',
                'funcionExitoFrecProduc','funcionErrorFrecProduc');
      }
  });


 
  $('#frecuenciaID').change(function() {
      if($('#frecuenciaID').val()!='' && $('#frecuenciaID').val() !=null){

        consultaFrecuenciaProduc(this.id);
        }else
        { $('#gridfrecTimbrarProduc').html("");
        $('#gridfrecTimbrarProduc').hide(); }
    });

  $('#grabar').click(function() {
    $('#tipoTransaccion').val(catTransaccionfrecTimbrarProduc.grabar);
    guardarFrecuenciaProduc();
  });

  $('#formaGenerica').validate({

    rules: {

    },
    messages: {

    }
  });

    function consultaFrecuenciaProduc(){
    var frecuencia=$('#frecuenciaID').val();

    if (frecuencia == ''){
      mensajeSis("Especifica la Frecuencia");
      $('#frecuenciaID').focus();
      $('#gridfrecTimbrarProduc').html("");
      $('#gridfrecTimbrarProduc').hide();

    } else if(frecuencia != '' ){

      habilitaBoton('grabar');
      var params = {};
      params['tipoLista'] = 3;
      params['frecuenciaID'] = frecuencia;

      $.post("gridfrecTimbradoProduc.htm", params, function(data){
        if(data.length) {
          $('#gridfrecTimbrarProduc').html(data);
          $('#gridfrecTimbrarProduc').show();
        }else {
          $('#gridfrecTimbrarProduc').html("");
          $('#gridfrecTimbrarProduc').hide();
        }
      });
    }

  }

});



function agregarNuevaFrecProduc(){
    var numeroFila=consultaFilas();
    var nuevaFila = parseInt(numeroFila) + 1;
    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
      if(numeroFila == 0){
        tds += '<td>';
        tds += '  <input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="12"  autocomplete="off"  type="hidden" />';
        tds += '  <input  id="producCreditoID'+nuevaFila+'" name="lproducCreditoID"  size="12"  value="" autocomplete="off"   onkeypress="listaProductos(this.id)" onblur="validaProducCredi(this.id);"/>';
        tds += '</td>';
        tds += '<td>';
        tds += '<input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="60"  autocomplete="off" readOnly="true" type="text" onkeyPress="return Validador(event);"/>';
        tds += '</td>';
        tds += '<td >';
        tds += ' <input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarProducCredi(this.id)"/>';
        tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarNuevaFrecProduc()"/>';
        tds += '</td>';
      }
      else{
        var valor = numeroFila+ 1;
        tds += '<td>';
        tds += '  <input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="12"   autocomplete="off"  type="hidden" />';
        tds += '  <input  id="producCreditoID'+nuevaFila+'" name="lproducCreditoID"  size="12"  value="" autocomplete="off"   onkeypress="listaProductos(this.id)" onblur="validaProducCredi(this.id);"/>';
        tds += '</td>';
        tds += '<td>';
        tds += ' <input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="60"  autocomplete="off" readOnly="true" type="text" onkeyPress="return Validador(event);"/>';
        tds += '</td>';
        tds += '<td >';
        tds += ' <input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarProducCredi(this.id)"/>';
        tds += ' <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarNuevaFrecProduc()"/>';
        tds += '</td>';
      }
      tds += '</tr>';

      $("#miTabla").append(tds);
      return false;
    }


  function eliminarProducCredi(control){
    var contador = 0 ;
    var numeroID = control;

    var jqRenglon = eval("'#renglon" + numeroID + "'");
    var jqNumero = eval("'#consecutivoID" + numeroID + "'");
    var jqFrecuencia = eval("'#frecuenciaID" + numeroID + "'");
    var jqDescripcion=eval("'#descripcion" + numeroID + "'");
    var jqAgrega=eval("'#agrega" + numeroID + "'");
    var jqElimina = eval("'#" + numeroID + "'");

    // se elimina la fila seleccionada
    $(jqNumero).remove();
    $(jqFrecuencia).remove();
    $(jqElimina).remove();
    $(jqDescripcion).remove();
    $(jqAgrega).remove();
    $(jqRenglon).remove();

    //Reordenamiento de Controles
    contador = 1;
    var numero= 0;
    $('tr[name=renglon]').each(function() {
      numero= this.id.substr(7,this.id.length);
      var jqRenglon1 = eval("'#renglon"+numero+"'");
      var jqNumero1 = eval("'#consecutivoID"+numero+"'");
      var jqFrecuencia1 = eval("'#frecuenciaID" + numeroID + "'");
      var jqDescripcion1=eval("'#descripcion"+ numero+"'");
      var jqAgrega1=eval("'#agrega"+ numero+"'");
      var jqElimina1 = eval("'#"+numero+ "'");

      $(jqNumero1).attr('id','consecutivoID'+contador);
      $(jqFrecuencia1).attr('id','frecuenciaID'+contador);
      $(jqDescripcion1).attr('id','descripcion'+contador);
      $(jqAgrega1).attr('id','agrega'+contador);
      $(jqElimina1).attr('id',contador);
      $(jqRenglon1).attr('id','renglon'+ contador);
      contador = parseInt(contador + 1);

    });

  }

  //consulta cuantas filas tiene el grid de los productos
function consultaFilas(){
  var totales=0;
  $('input[name=consecutivoID]').each(function() {
    totales++;
  });
  return totales;
}
    function verificaSeleccionado(idCampo){
      var contador = 0;
      var nuevoProduc   =$('#'+idCampo).val();
      var numeroNuevo= idCampo.substr(15,idCampo.length);
      var jqDescripcion   = eval("'descripcion" + numeroNuevo+ "'");
      $('tr[name=renglon]').each(function() {
      var numero= this.id.substr(7,this.id.length);
      var jqIdProduc = eval("'producCreditoID" + numero+ "'");

      var valorProduc = $('#'+jqIdProduc).val();
      if(jqIdProduc != idCampo){
        if(valorProduc == nuevoProduc ){
          mensajeSis("El Número de Producto de Crédito ya Existe.");
          $('#'+idCampo).focus();
          $('#'+idCampo).val("");
          $('#'+jqDescripcion).val("");
              contador = contador+1;
            }
          }
      });
      return contador;
    }

  function listaProductos(idControl){
    var jq = eval("'#" + idControl + "'");
    $(jq).bind('keyup',function(e){
      var jqControl = eval("'#" + this.id + "'");
      var num = $(jqControl).val();

      var camposLista = new Array();
      var parametrosLista = new Array();
      camposLista[0] = "producCreditoID";
      parametrosLista[0] = num;
      lista(idControl, '2', '1', camposLista, parametrosLista, 'listaTimbradoProduc.htm');
    });
  }

  function validaProducCredi(control) {
    var jq = eval("'#" + control + "'");
    var productoCredito = $(jq).val();
  esTab = true;
  var principal=1;
    var jqDescripcion = eval("'#descripcion" + control.substr(15) + "'");
    setTimeout("$('#cajaLista').hide();", 200);
      if(productoCredito != '' && !isNaN(productoCredito) && esTab){
        var productoCreditoBeanCon = {
            'producCreditoID':productoCredito
        };
        if(verificaSeleccionado(control) == 0){

        productosCreditoServicio.consulta(principal,productoCreditoBeanCon,
                function(prodCred) {
            if(prodCred!=null){
              $(jqDescripcion).val(prodCred.descripcion);
              }else{
                mensajeSis("El Número de Producto de Crédito no Existe.");
                $(jq).val("");
                $(jqDescripcion).val("");
                $(jq).focus();

              }
          });
        }
      }else {
        $(jq).val("");
        $(jqDescripcion).val("");
      }
  }

  function guardarFrecuenciaProduc(){
      var mandar = verificarvacios();

      if(mandar!=1){
      var numCodigo = $('input[name=lproducCreditoID]').length;

      $('#frecuencias').val("");
      for(var i = 1; i <= numCodigo; i++){
        if(i == 1){
          $('#frecuencias').val($('#frecuencias').val() +
          $("#producCreditoID"+i).val() + ']' +

          $("#descripcion"+i).val());
        }else{
          $('#frecuencias').val($('#frecuencias').val() + '[' +
          $("#producCreditoID"+i).val()+ ']' +
          $("#descripcion"+i).val());
        }
      }
    }
    else{

      mensajeSis("Especifique el Número de Producto de Crédito.");
      event.preventDefault();
    }
  }

  function verificarvacios(){
    quitaFormatoControles('gridFrecuencias');
    var numCodig = $('input[name=lproducCreditoID]').length;

    $('#frecuencias').val("");
    for(var i = 1; i <= numCodig; i++){
      var idcr = $("#producCreditoID"+i).val();
        if (idcr ==""){
          $("#producCreditoID"+i).focus();
        $(idcr).addClass("error");
          return 1;
        }
      var idcde =$("descripcion"+i).val();
        if (idcde ==""){
          $("#descripcion"+i).focus();
        $(idcde).addClass("error");
          return 1;
        }
    }
  }

    /* consulta un rol */
    function consultaAutTimbradoRol(idControl) {
      var numRol = idControl;
      var conRol=3;
      var rolesBeanCon = {
            'rolID':numRol
          };
      setTimeout("$('#cajaLista').hide();", 200);
      if(numRol != '' && !isNaN(numRol)){
        rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
          if(roles!=null){
            if(roles.autTimbrado != 'S'){
             mensajeSis("El usuario no puede Realizar el Timbrado");
             deshabilitaBoton('frecuenciaID', 'submit');
            }
          }else{
            mensajeSis("No Existe el Rol");
          }
        });
      }
    }
//funcion que se ejecuta cuando el resultado fue exito
  function funcionExitoFrecProduc(){
   
    $('#frecuenciaID').val('');
    $('#frecuenciaID').focus();
    $('#gridfrecTimbrarProduc').html("");
    $('#gridfrecTimbrarProduc').hide(); 


  }

  // funcion que se ejecuta cuando el resultado fue error
  // diferente de cero
  function funcionErrorFrecProduc(){
  }





