var parametroBean = consultaParametrosSession();

$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	$("#ejercicio").focus();

    /******* VALIDACIONES DE LA FORMA *******/
	$.validator.setDefaults({submitHandler: function(event) {
	}});

	$('#formaGenerica').validate({		
	});

	/******* MANEJO DE EVENTOS *******/
	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '8', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {	
		if(esTab){
			consultaCliente(this.id);
		}  		
	});
			
	$('#generar').click(function() { 
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});
	
	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/
	//CONSULTA CLIENTE
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numCon = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente > 0) {		
			clienteServicio.consulta(numCon, numCliente, function(cliente) {
				if (cliente != null) {
					if(cliente.tipoPersona == 'F' || cliente.tipoPersona == 'A'){
						$('#clienteID').val(cliente.numero);							
						$('#nombreCompletoCte').val(cliente.nombreCompleto);						
					}else{
						$(jqCliente).val("0");
						$('#nombreCompletoCte').val("TODOS");
						$(jqCliente).focus();
						mensajeSis('El Aportante debe ser tipo de persona Física o Física con Actividad Empresarial.');						
					}					
				} else {
					$(jqCliente).val("0");
					$('#nombreCompletoCte').val("TODOS");
					$(jqCliente).focus();
					mensajeSis('El Aportante no Existe.');
				}
			});
		}else{
			$(jqCliente).val("0");
			$('#nombreCompletoCte').val("TODOS");
		}
	}
	
	// FUNCION QUE GENERA EL REPORTE EN EXCEL
	function generaExcel(){
		var tipoReporte 	= 1;
		var tipoLista   	= 1;  
		
		var pagina ='reporteRelFiscalesRetencion.htm?'+
							'ejercicio='+$('#ejercicio').val()+
							'&clienteID='+$('#clienteID').val()+
							'&nombreCompletoCte='+$('#nombreCompletoCte').val()+
							'&tipoReporte='+tipoReporte+
							'&tipoLista='+tipoLista+
							'&nombreInstitucion='+parametroBean.nombreInstitucion+
							'&claveUsuario='+parametroBean.claveUsuario.toUpperCase()+
							'&fechaSistema='+parametroBean.fechaSucursal;
		window.open(pagina);
	
	}
	
}); // FIN $(DOCUMENT).READY()


//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','ejercicio');	
	agregaFormatoControles('formaGenerica');
	$('#clienteID').val("0");
	$('#nombreCompletoCte').val("TODOS");
	
	llenaComboAnios(parametroBean.fechaAplicacion,10);
}

//FUNCION LLENA COMBO DE ANIOS PARA EL EJERCICIO
function llenaComboAnios(fechaActual, numRango){
   var anioActual = fechaActual.substring(0, 4);
   var anioMax = parseInt(anioActual) + parseInt(numRango);
   var numOpciones = parseInt(numRango) * 2;
  
   for(var i=0; i < numOpciones; i++){
	   $('#ejercicio').append('<option value="'+anioMax+'">'+anioMax+'</option>');
	   anioMax = parseInt(anioMax) - 1;
   }
   $("#ejercicio").val(anioActual);
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
}