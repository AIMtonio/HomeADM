var montoMax;
var montoMin;
var var_estatus;


$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoConsultaTipoCtaAho = {
  		'principal':1,
  		'foranea':2
	};	
	
	var catTipoActTipoCtaAho = {
  		'apertura':1
	};	
	
	var catTipoTransaccionCtaAho = {
  		'agrega':'1',
  		'modifica':'2',
  		'actualiza':'3'
	};
		var parametroBean = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('autorizar', 'submit');

	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
      	//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaCreditoID');
      	
      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma','mensaje', 'true', 'lineaCreditoID', 
				'accionInicializaRegresoExitoso','accionInicializaRegresoFallo');	
      	
      	deshabilitaBoton('autorizar', 'submit');
      }
   });					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#autorizar').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoCtaAho.apertura);
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
	});
	
	$('#lineaCreditoID').blur(function() {
  		consultaLineaCredito(this.id);
  		$('#fechaAutoriza').val(parametroBean.fechaSucursal);
	});
	
	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#lineaCreditoID').val();
						
			lista('lineaCreditoID', '3', '4', camposLista, parametrosLista, 'lineasCreditoLista.htm');
		}				       
	});
	
	$('#lineaCreditoID').focus();

/*	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			
			parametrosLista[0] = $('#cuentaAhoID').val();
				
						
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	*/
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});
	
	
	$('#autorizado').blur(function() {
		validaMonto();
		
	});

	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			lineaCreditoID: 'required',
			clienteID: 'required',
			usuarioAutoriza: 'required',
			fechaAutoriza: 'required'	,
			autorizado: {
				required: true 
			}
		},
		messages: {
			lineaCreditoID: 'Especificar Línea de Crédito.',
			clienteID: 'Especifique número de Cliente.',
			usuarioAutoriza: 'Especifique el Usuario.',
			fechaAutoriza:'Especifique Fecha de Registro.',
			autorizado: {
				required: 'Especifique el Monto.'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function consultaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCredito = $(jqLinea).val();	
		
		var tipConActualizacion = 3;
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCredito
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){
			lineasCreditoServicio.consulta(tipConActualizacion, lineaCreditoBeanCon,function(linea) {
					if(linea!=null){
						
				 var ProductoCreditoCon = { 
				'producCreditoID':linea.productoCreditoID
				 };
				productosCreditoServicio.consulta(2,ProductoCreditoCon,function(productos){
				if(productos!=null){
				    montoMin = (productos.montoMinimo);
					montoMax = (productos.montoMaximo);

					  }	else{
					mensajeSis("No existe el Producto de crédito.");}
					});
					esTab= true;
						$('#lineaCreditoID').val(linea.lineaCreditoID);							
						$('#clienteID').val(linea.clienteID);
						$('#solicitado').val(linea.solicitado);	
						$('#solicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});			
						$('#autorizado').val(linea.autorizado);
						$('#autorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});			
						$('#usuarioAutoriza').val(linea.usuarioAutoriza);
						$('#fechaAutoriza').val(linea.fechaAutoriza);
						consultaCliente('clienteID');
						consultaUsuario('usuarioAutoriza'); 
							
						var_estatus=(linea.estatus);
						validaEstatus(var_estatus);
						
						if(linea.fechaInicio != parametroBean.fechaSucursal){
							mensajeSis("La Fecha de Autorización no  puede ser Mayor a la Fecha de Inicio de la Línea de Crédito.");
							deshabilitaBoton('autorizar', 'submit');	
							deshabilitaControl('autorizado');
							$('#lineaCreditoID').focus();
							$('#lineaCreditoID').select();
						}else{
							if (var_estatus != 'I'){
								deshabilitaBoton('autorizar', 'submit');	
								deshabilitaControl('autorizado');
							}else{
							habilitaBoton('autorizar', 'submit');	
							habilitaControl('autorizado');
							
							}
						}
						
					}else{
						mensajeSis("No existe la Línea de Crédito.");
						$('#lineaCreditoID').val("");							
						$('#clienteID').val("");
						$('#nombreCte').val("");	
						$('#solicitado').val("");	
						$('#solicitado').val("");			
						$('#estatus').val('');
						$('#autorizado').val("");			
						$('#usuarioAutoriza').val("");
						$('#nombreUsuario').val("");           
						$('#fechaAutoriza').val("");
						$(jqLinea).focus();
						deshabilitaBoton('autorizar', 'submit');	
						$(jqLinea).select();									
					}
			});										
														
		}
	}

	
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){							
							$('#nombreCte').val(cliente.nombreCompleto);	
							
						}else{
							mensajeSis("No existe el Cliente.");
							$(jqCliente).focus();
						}    						
				});
			}
	}
	
	function validaEstatus(var_estatus) {
		var estatusAutorizada 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";


		if(var_estatus == estatusAutorizada){
			 deshabilitaBoton('autorizar', 'submit');
			 $('#estatus').val('AUTORIZADO');
			 $('#autorizado').attr('disabled', 'disabled');
		}
		if(var_estatus == estatusBloqueado){
			 deshabilitaBoton('autorizar', 'submit');
			 $('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			 deshabilitaBoton('autorizar', 'submit');
			 $('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			 habilitaBoton('autorizar', 'submit');
			 $('#estatus').val('INACTIVO');
			 habilitaControl('autorizado');
			$('#usuarioAutoriza').val(parametroBean.numeroUsuario);   
			$('#nombreUsuario').val(parametroBean.nombreUsuario);           
		   $('#fechaAutoriza').val(parametroBean.fechaSucursal);
		   $('#autorizado').focus();
		   $('#autorizado').select();
		   
		}	
	}
	
	function consultaUsuario(idControl) {
	var jqUsuario = eval("'#" + idControl + "'");
	var numUsuario = $(jqUsuario).val();	
	var conUsuario=2;
		var UsuarioBeanCon = {
			'usuarioID'	:numUsuario
		};
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numUsuario != '' && !isNaN(numUsuario) && esTab){ 
		usuarioServicio.consulta(conUsuario,UsuarioBeanCon,function(usuario) {
					if(usuario!= null){
						// $('#usuarioAutoriza').val(usuario.usuarioAutoriza);					
						$('#nombreUsuario').val(usuario.nombreCompleto);								
					}else{
						mensajeSis("No existe el Usuario.");
						$(jqUsuario).focus();
					}    						
			});
		}
	}
	
	
	function validaMonto(){

		var montoaut = $('#autorizado').asNumber();
		var solicita = $('#solicitado').asNumber();
		
		 $('#montoMinimo').val(montoMin);
		 $('#montoMinimo').formatCurrency({
				positiveFormat : '%n',
				negativeFormat : '%n',
				roundToDecimalPlace : 2
			});
		 $('#montoMaximo').val(montoMax);
		 $('#montoMaximo').formatCurrency({
				positiveFormat : '%n',
				negativeFormat : '%n',
				roundToDecimalPlace : 2
			});
		
		var montoMi =  $('#montoMinimo').val();
		var montoMa =  $('#montoMaximo').val();
		
		if(montoaut != '' && !isNaN(montoaut)){
			
				if(montoaut < montoMin ){
					mensajeSis("Para este Producto Puede Seleccionar un Monto Mínimo de: "+ montoMi+".");
					$('#autorizado').val("");
					$('#autorizado').focus();
						deshabilitaBoton('autorizar', 'submit');

				}else{
					if(montoaut > montoMax){
						mensajeSis("Para este Producto Puede Seleccionar un Monto Máximo de: "+ montoMa+".");
						$('#autorizado').val("");
						$('#autorizado').focus();
								deshabilitaBoton('autorizar', 'submit');	
					}else{
						
				if(montoaut <= montoMax && montoaut >= montoMin ){
					        if(var_estatus == 'A' || var_estatus == 'C' || var_estatus == 'B'){
								deshabilitaBoton('autorizar', 'submit');	

					        }else{
							habilitaBoton('autorizar', 'submit');}
						  }
			         }
				 }
				
				if(montoaut > solicita){mensajeSis("El Monto Autorizado no puede ser Mayor al Solicitado.");
				deshabilitaBoton('autorizar', 'submit');
				$('#autorizado').val("");
				$('#autorizado').focus();}

		     }

         } //Termina Funcion validaMonto

});






function accionInicializaRegresoExitoso(){
	$('#clienteID').val("");
	$('#nombreCte').val("");	
	$('#solicitado').val("");	
	$('#solicitado').val("");			
	$('#estatus').val('');
	$('#autorizado').val("");			
	$('#usuarioAutoriza').val("");
	$('#nombreUsuario').val("");           
	$('#fechaAutoriza').val("");
	$('#lineaCreditoID').focus(); 
}

function accionInicializaRegresoFallo(){}
