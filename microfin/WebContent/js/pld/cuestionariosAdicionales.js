var esTab;
//INICIO document.ready
$(document).ready(function() {
    var catTipoConsultaCliente = {
        'principal': 1
    };
    deshabilitaBoton('imprimir', 'submit');
		
    $('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
    });
    
    $('#clienteID').blur(function() {
        limpiaCampos();
        consultaCliente(this.id);
    });

    $('#imprimir').click(function() {
        var nivelRiesgo = $('#nivelRiesgo').val();
        var tipoPersona = $('#tipoPersona').val();
        
        if(nivelRiesgo == 'B' && tipoPersona ==  'F')
          mensajeSis('No existe formato de Cuestionario para los valores establecidos');
        else
          generaPDF();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID:{
				required: true
			}
		},
		messages: {
			clienteID:{
				required: 'Ingrese el ID del Cliente'
			}
		}
    });
    

    function consultaCliente(idControl) {
        var jqCliente = eval("'#" + idControl + "'");
        var varClienteID = $(jqCliente).val();
        setTimeout("$('#cajaLista').hide();", 200);
          
          if (varClienteID != '' && Number(varClienteID) > 0) {
              clienteServicio.consulta(catTipoConsultaCliente.principal, varClienteID, function(cliente) {
                  if (cliente != null) {
                      $('#nombreCompleto').val(cliente.nombreCompleto);
                      $('#nivelRiesgo').val(cliente.nivelRiesgo);
                      $('#tipoPersona').val(cliente.tipoPersona);
                      nivelRiesgo(cliente.nivelRiesgo);
                      tipoPersona(cliente.tipoPersona);
                      habilitaBoton('imprimir', 'submit');
                  } else {
                    mensajeSis('No Existe el Cliente');
                    $('#clienteID').focus();
                    $('#clienteID').val('');
                    $('#nombreCompleto').val('');
                    $('#nivelRiesgo').val('');
                    $('#tipoPersona').val('');
                    $('#nivelDeRiesgo').val('');
                    $('#tipoPer').val('');
                    deshabilitaBoton('imprimir', 'submit');
                  }
              });
          }
      }
}); //FIN document.ready

function nivelRiesgo(nivelRiesgo){
    if(nivelRiesgo == 'A')
        $('#nivelDeRiesgo').val('ALTO');
    if(nivelRiesgo == 'M')
        $('#nivelDeRiesgo').val('MEDIO');
    if(nivelRiesgo == 'B')
        $('#nivelDeRiesgo').val('BAJO'); 
}

function tipoPersona(tipoPersona){
   if(tipoPersona == 'F')
        $('#tipoPer').val('Fisica');
    if(tipoPersona == 'M')
        $('#tipoPer').val('Moral');
}

function limpiaCampos(){
    $('#nombreCompleto').val('');
    $('#nivelRiesgo').val('');
    $('#tipoPersona').val('');
    $('#nivelDeRiesgo').val('');
    $('#tipoPer').val('');
    deshabilitaBoton('imprimir', 'submit');
}

function generaPDF() {
    var clienteID = $('#clienteID').val();
    var nivelRiesgo = $('#nivelRiesgo').val();
    var tipoPersona = $('#tipoPersona').val();
    var reportePDF = 1;
    var sucursalID = consultaParametrosSession().sucursal;

    var url = 'generaCuestionariosAdicionales.htm?' + 
                '&clienteID=' + clienteID  + '&nivelRiesgo=' + nivelRiesgo + 
                '&tipoPersona=' + tipoPersona + '&tipoReporte='+reportePDF + '&sucursalID='+sucursalID;

    window.open(url);
}