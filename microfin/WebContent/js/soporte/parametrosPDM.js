	$(document).ready(function() {
		esTab = false;
				
		//Definicion de Constantes y Enums 
		parametroBean = consultaParametrosSession();

		var catTipoTransaccion = {  
			'modificar' : '1'		
		};
		
		var conParametroBean = {  
			'principal' : 1	
		};
			
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');	
		deshabilitaBoton('modificar');	
		$('#nombreServicio').focus();
		consultaParametros();
			
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
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','nombreServicio',
					'funcionExito','funcionError');						
			}
		});	
			
		// Modificar Parametros Pademobile
		$('#modificar').click(function() {	
			// Valida Numero de Respuestas
				if ($("#numeroRespuestas").asNumber() > $("#numeroPreguntas").asNumber()) { 
					mensajeSis('El Número de Respuestas No Debe ser Mayor al Número de Preguntas.');
					$('#numeroRespuestas').focus();
					$('#numeroRespuestas').val('');
				}


			$('#tipoTransaccion').val(catTipoTransaccion.modificar);
		});
		
		
		


		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				numeroPreguntas: {
					required: true,
					number: true
				},
				numeroRespuestas:{
					required: true,
					number: true
				},
			},		
			messages: {	
				numeroPreguntas: {
					required: 'Especifique Número de Preguntas',
					number: 'Sólo Números'
				},
				numeroRespuestas:{
					required:'Especifique Número de Respuestas',
					number: 'Sólo Números'
				}, 				
			}		
		});
		
	// funcion para consultar Parametros Pademobile
	function consultaParametros(){
		var numEmpresaID = 1;
			
		var parametrosBean = {
  				'empresaID':numEmpresaID	
  		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpresaID != '' && !isNaN(numEmpresaID)) { 
			
			parametrosPDMServicio.consulta(parametrosBean,conParametroBean.principal,function(data) { 	
				//si el resultado obtenido de la consulta regreso un resultado
				if (data != null) {				
					//coloca los valores del resultado en sus campos correspondientes
					$('#nombreServicio').val(data.nombreServicio);
					$('#numeroPreguntas').val(data.numeroPreguntas);
					$('#numeroRespuestas').val(data.numeroRespuestas);
					habilitaBoton('modificar');
				}
				else{
					$('#numeroPreguntas').val(0);
					$('#numeroRespuestas').val(0);
				}
			});
		}
	}
	
	});
	
	// Funcion Exito
	function funcionExito(){	
		consultaParametros();
	}
	
	// Funcion Error
	function funcionError(){

	}
	
