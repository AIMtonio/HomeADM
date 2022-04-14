	$(document).ready(function() {
		esTab = true;
		var tab2=false;

		
		
		//Definicion de Constantes y Enums  
		var catTipoTransaccion = {  
				'procesar':'1',
			
			};
		
		var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
		 	};
		
		var catTipoConsultaCtaNostro = {
			
				'resumen':4,
			};	

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		agregaFormatoControles('formaGenerica');
		deshabilitaBoton('procesar');
		$('#institucionID').focus();


		$(':text').focus(function() {	
			esTab = false;
		});

		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
		
		consultaSpeiSaldo();
		actualizaFormatoMoneda('formaGenerica');
		


		$('input[name="cierre"]').change(function() {
			var radioSeleccionado = $('input[name="cierre"]:checked').val();
			 if(radioSeleccionado=='P'){
				 	habilitaControl('monto');
					$('#monto').val('');
				} else {
					deshabilitaControl('monto');
					$('#monto').val($('#saldo').val());
				}
		});
		
		$.validator.setDefaults({
			submitHandler: function(event) { 
				if($('#cuentaBancos').val()!=""){
				var transaccion = $('#tipoTransaccion').val();
					  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
					  'funcionExitoCierre','funcionErrorCierre');
				}
				else {
				mensajeSis("Seleccionar una Cuenta Bancaria");
				$('#cuentaBancos').focus();
				}
				 
			}
		});	


		$('#procesar').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccion.procesar);
		});
		
		$('#institucionID').bind('keyup',function(e){
			lista('institucionID', '2', '5', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
		});
		
		$('#institucionID').blur(function() {
	  		    if($('#institucionID').val()!=""){
	  		    	$('#cuentaBancos').val('');
	  		    	consultaInstitucion(this.id);  
	  		    }
	 	});	
		

		$('#cuentaBancos').bind('keyup',function(e){
	       	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID";
			parametrosLista[0] = $('#institucionID').val();
			listaAlfanumerica('cuentaBancos', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
		});	

		$('#cuentaBancos').blur(function(){
	   		if($('#cuentaBancos').val()!="" && $('#institucionID').val()!=""){
	   			validaCtaNostroExiste('cuentaBancos','institucionID');
	   		}		
	   	});
		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				institucionID:{required: true
				},
				cuentaBancos:{required: true
				},
				monto:{required: true
				},

			},		
			messages: {		
				institucionID:{
					required:'Especificar Institución'
				}, 
				cuentaBancos:{
					required:'Especificar Cuenta Bancaria'
				}, 
				monto:{
					required:'Especificar Monto'
				}, 
				
			}		
		});


		

		//------------ Validaciones de Controles -------------------------------------

		   //Funcion de consulta para obtener el nombre de la institucion	
		function consultaInstitucion(idControl) {
			var jqInstituto = eval("'#" + idControl + "'");
			var numInstituto = $(jqInstituto).val();
			setTimeout("$('#cajaLista').hide();", 200);	
			var InstitutoBeanCon = {
				'institucionID':numInstituto
			};
			if(numInstituto!='' && !isNaN(numInstituto)){
					institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
						if(instituto!=null){							
							$('#nombreInstitucion').val(instituto.nombre);
						}else{
							mensajeSis("No existe la Institución"); 
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nombreInstitucion').val("");
						}    						
					});
			}else{
				$('#institucionID').focus();
				$('#institucionID').val('');
				$('#nombreInstitucion').val("");
			}
			
		}
		
		//Funcion para validar si existe la cuenta de banco
	
		function validaCtaNostroExiste(numCta,institID){
	  		var jqNumCtaInstit = eval("'#" + numCta + "'");
	  		var jqInstitucionID = eval("'#" + institID + "'");
	  		var numCtaInstit = $(jqNumCtaInstit).val();
	  		var institucionID = $(jqInstitucionID).val();
	  		var CtaNostroBeanCon = {
	  				'institucionID':institucionID,
	  				'numCtaInstit':numCtaInstit
	  		};

		setTimeout("$('#cajaLista').hide();", 200);
	  	if(numCtaInstit != '' && !isNaN(numCtaInstit) && esTab == true){
	  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){
	  				  				
	  				if(ctaNostro!=null){   		
						if(ctaNostro.estatus !='A'){
							mensajeSis("El Número de Cuenta Bancaria esta Inactiva");
		  					deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit'); 
							deshabilitaBoton('cancelar', 'submit');
							$('#cuentaBancos').focus();
							deshabilitaBoton('procesar');
		  				}else{
		  					habilitaBoton('procesar');
		  				}	
						
	  				}
	  				else{
	  				mensajeSis("El Numero de Cueta Bancaria no Existe");
	  				$('#cuentaBancos').focus();
	  				$('#cuentaBancos').val('');
						
	  				} 
	  			});
	  		}else{
	  			$('#cuentaBancos').val('');
	  			$('#cuentaBancos').focus();
	  			}
	  	}
	  	
	});
	
	// Función para obtener el Saldo Actual Spei
	function consultaSpeiSaldo(){
		var numEmpresa = 1;	
		var tipoConsulta = 1;
		  
		  	consultaSpeiServicio.consulta(tipoConsulta, numEmpresa, function(data){
				if(data!=null){
					$('#saldo').val(data.saldoActual);
					$('#monto').val(data.saldoActual);
				}else{
					mensajeSis("No tiene Saldo en SPEI ");
					$('#saldo').val('');
					$('#monto').val('');
				}
		  	}
					
			);
	}
	
	function limpiarCampos(){
		$('#cuentaBancos').val('');
		$('#institucionID').focus();
		$('#institucionID').val('');
		$('#nombreInstitucion').val("");
	}
			
	function funcionExitoCierre (){
		$('#monto').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		deshabilitaBoton('procesar');
		limpiarCampos();
		
	}

	function funcionErrorCierre (){
	
	
	}
