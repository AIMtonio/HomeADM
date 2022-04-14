$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();   
		
	var catTipoConParam = { 
  		'principal'	: 1,
	};				
	var catTipoTranParam = { 
  		'modifica'	: 1,
	};		
		//-----------------------MÃ©todos y manejo de eventos-----------------------	
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroInstitu1'); 
	      }
	 });
		   	
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTranParam.modifica);
	});	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			numeroInstitu1: {
				required: true,
				numeroPositivo: true
			},
			numeroInstitu2: {
				numeroPositivo: true
			},
			numeroInstitu3: {
				numeroPositivo: true
			},
			rutaMasivos: {
				required: true
			},
			numDigitosTel: {
				required:  true,
				numeroPositivo: true
			},
			numMsmEnv: {
				required: true,
				numeroPositivo: true
			},
		},
		messages: {
			numeroInstitu1: {
				required: 'Ingrese el número de Institución',
				numeroPositivo: 'Sólo números positivos'
			},
			numeroInstitu2: {
				numeroPositivo: 'Sólo números positivos'
			},
			numeroInstitu3: {
				numeroPositivo: 'Sólo números positivos'
			},
			rutaMasivos: {
				required: 'Ingrese la ruta de Archivos'
			},
			numDigitosTel: {
				required:  'Ingrese el númeo de digitos del teléfono',
				numeroPositivo: 'Sólo números positivos'
			},
			numMsmEnv: {
				required: 'Ingrese el número de mensajes enviados',
				numeroPositivo: 'Sólo números positivos'
			},			
		}		
	});
	parametrosSMS();
//-------------------Métodos-------
	function parametrosSMS(){
		setTimeout("$('#cajaLista').hide();", 200);		
				parametrosSMSServicio.consulta(catTipoConParam.principal,function(parametros) {
					if(parametros!=null){
						dwr.util.setValues(parametros);		
						habilitaBoton('modificar', 'submit');
						if(parametros.enviarSiNoCoici=='S'){
							// alert(parametros.enviarSiNoCoici);
							$('#enviarSiNoCoici').attr("checked",true);
						}else if(parametros.enviarSiNoCoici=='N'){
							$('#enviarSiNoCoici1').attr("checked",true);
						}
						
					}else{															
						deshabilitaBoton('modificar', 'submit');
					}
				});
		}
	
	});