	$(document).ready(function() {
		esTab = false;
				

		//Definicion de Constantes y Enums  
		var catTipoTransaccion = {  
			'agregar' : '1'		
		};
		
		var conSoporteBean = {  
			'principal' : 1	
		};
			
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');	
		deshabilitaBoton('agregar');	
		$('#tipoSoporteID').focus();
			
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
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoSoporteID',
					'funcionExito','funcionError');						
			}
		});	
		
		// Lista de Ayuda de Tipos de Soporte
		$('#tipoSoporteID').bind('keyup',function(e){				
			lista('tipoSoporteID', '2', '1', 'descripcion', $('#tipoSoporteID').val(), 'listaAltaTiposSoporte.htm');	
		});
		
		// Consulta Tipos de Soporte
		$("#tipoSoporteID").blur(function() {
			if(esTab){
				if (this.value != '' && Number(this.value) > 0 && !isNaN(this.value)) {
					consultaTipoSoporte("tipoSoporteID");
				} else {
					inicializaValoresNuevoSoporte();				
					if(isNaN(this.value)){
						this.focus();
						$("#tipoSoporteID").val(""); 
					}
				}	
			}
		});
		
		// Agregar Tipos de Soporte
		$('#agregar').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccion.agregar);
		});
		
		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				tipoSoporteID: {
					required: true
				},
				descripcion:{
					required: true
				},
			},		
			messages: {	
				tipoSoporteID: {
					required: 'Especifique Número',
				},
				descripcion:{
					required:'Especifique Descripción Soporte',
				}, 				
			}		
		});
		
	// funcion para consultar Tipos de Soporte
	function consultaTipoSoporte(idControl){
		var jqCampo = eval("'#" + idControl + "'");
		var numSoporte = $(jqCampo).val();
			
		var tiposSoporteBean = {
  				'tipoSoporteID':numSoporte
  		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSoporte != '' && !isNaN(numSoporte)) { 
			
			altaTiposSoporteServicio.consulta(conSoporteBean.principal,tiposSoporteBean,function(data) {
				//si el resultado obtenido de la consulta regreso un resultado
				if (data != null) {					
					//coloca los valores del resultado en sus campos correspondientes
					$('#tipoSoporteID').val(data.tipoSoporteID);
					$('#descripcion').val(data.descripcion);
					habilitaBoton('agregar');
				}else{
					mensajeSis("El Número Tipo de Soporte No Existe.");
					limpiaCampos();
				} 
			});
			
		}
	}
	
	});
	
	// Funcion para limpiar campos
	function limpiaCampos(){
		$('#tipoSoporteID').focus();
		$('#tipoSoporteID').val('');
		$('#descripcion').val('');
		deshabilitaBoton('agregar');
	}
	
	// Inicializa los valores de la pantalla para dar de alta un nuevo Tipo de Soporte
	function inicializaValoresNuevoSoporte(){
		if($('#tipoSoporteID').val() == ''){
			$('#descripcion').val('');
			deshabilitaBoton('agregar');
		}else{
			$('#descripcion').val('');
			habilitaBoton('agregar');
		}
	}
	
	// Funcion Exito
	function funcionExito(){	
		inicializaForma('formaGenerica','tipoSoporteID');
	}

	// Funcion Error
	function funcionError(){

	}
	
