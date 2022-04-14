	$(document).ready(function() {
		esTab = true;
		var tab2=false;		
		
		//Definicion de Constantes y Enums  
		var catTipoTransaccion = {  
				'grabar' : '1',
				'modificar' : '2'		
			
			};
			
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');			
		$('#ctaDDIESpei').focus();
		
		$(':text').focus(function() {	
			esTab = false;
		});

		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
			
		$('#modificar').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccion.modificar);			
		
		});
				
		$.validator.setDefaults({
			submitHandler: function(event) { 
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
					'funcionExitoGuiaContable','funcionErrorGuiaContable');				 
			}
		});	
		
		
		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				ctaDDIESpei:{required: true,
				numeroPositivo: true,
				},
				ctaDDIETrans:{required: true,
				numeroPositivo: true,
				},
			},		
			messages: {		
				ctaDDIESpei:{
					required:'Especificar Cuenta Contable',
					numeroPositivo : "Solo números"
				}, 
				ctaDDIETrans:{
					required:'Especificar Cuenta Bancaria',
					numeroPositivo : "Solo números"
				}, 
								
			}		
		});


		
		consultaGuiasContables();

	  	
	});
	
	// funcion para consultar Guias Contables
	function consultaGuiasContables(){
		var numEmpresa = 1;	
		var tipConsulta = 1;		
		var parBeanCon = {
  				'empresaID':numEmpresa,
  				
  		};
		guiaContableSpeiIEServicio.consulta(tipConsulta,parBeanCon,function(data) {
			//si el resultado obtenido de la consulta regreso un resultado
			if (data != null) {					
				//coloca los valores del resultado en sus campos correspondientes
				$('#ctaDDIESpei').val(data.ctaDDIESpei);
				$('#ctaDDIETrans').val(data.ctaDDIETrans);
							
			} 		
		});
	
	}

	function funcionExitoGuiaContable(){
	}

	function funcionErrorGuiaContable(){
	}
	
