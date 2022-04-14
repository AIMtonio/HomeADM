	$(document).ready(function() {
		esTab = false;
				

		//Definicion de Constantes y Enums  
		var catTipoTransaccion = {  
			'agregar' : '1'		
		};
		
		var conPreguntasBean = {  
			'principal' : 1	
		};
			
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');	
		deshabilitaBoton('agregar');	
		$('#preguntaID').focus();
			
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
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','preguntaID',
					'funcionExito','funcionError');						
			}
		});	
		
		// Lista de Ayuda de Preguntas de Seguridad
		$('#preguntaID').bind('keyup',function(e){				
			lista('preguntaID', '2', '1', 'descripcion', $('#preguntaID').val(), 'listaAltaPreguntasSeguridad.htm');	
		});
		
		// Consulta Preguntas de Seguridad
		$("#preguntaID").blur(function() {
			if(esTab){
				if (this.value != '' && Number(this.value) > 0 && !isNaN(this.value)) {
					consultaPreguntaSeguridad("preguntaID");
				} else {
					inicializaValoresNuevaPregunta();				
					if(isNaN(this.value)){
						this.focus();
						$("#preguntaID").val(""); 
					}
				}	
			}
		});
		
		// Agregar Preguntas de Seguridad
		$('#agregar').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccion.agregar);
		});
		
		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				preguntaID: {
					required: true
				},
				descripcion:{
					required: true
				},
			},		
			messages: {	
				preguntaID: {
					required: 'Especifique Número',
				},
				descripcion:{
					required:'Especifique Pregunta',
				}, 				
			}		
		});
		
	// funcion para consultar Preguntas de Seguridad
	function consultaPreguntaSeguridad(idControl){
		var jqCampo = eval("'#" + idControl + "'");
		var numPregunta = $(jqCampo).val();
			
		var preguntaSeguridadBean = {
  				'preguntaID':numPregunta	
  		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numPregunta != '' && !isNaN(numPregunta)) { 
			
			altaPreguntasSeguridadServicio.consulta(conPreguntasBean.principal,preguntaSeguridadBean,function(data) {
				//si el resultado obtenido de la consulta regreso un resultado
				if (data != null) {					
					//coloca los valores del resultado en sus campos correspondientes
					$('#preguntaID').val(data.preguntaID);
					$('#descripcion').val(data.descripcion);
					habilitaBoton('agregar');
				}else{
					mensajeSis("El Número de Pregunta No Existe.");
					limpiaCampos();
				} 
			});
			
		}
	}
	
	});
	
	// Funcion para limpiar campos
	function limpiaCampos(){
		$('#preguntaID').focus();
		$('#preguntaID').val('');
		$('#descripcion').val('');
		deshabilitaBoton('agregar');
	}
	
	// Inicializa los valores de la pantalla para dar de alta una nueva Pregunta de Seguridad
	function inicializaValoresNuevaPregunta(){
		if($('#preguntaID').val() == ''){
			$('#descripcion').val('');
			deshabilitaBoton('agregar');
		}else{
			$('#descripcion').val('');
			habilitaBoton('agregar');
		}
	}
	
	// Funcion Exito
	function funcionExito(){	
		inicializaForma('formaGenerica','preguntaID');
	}
	
	// Funcion Error
	function funcionError(){

	}
	
