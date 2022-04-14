$(document).ready(function() {
	esTab = true;

	//Definicion de Constantes y Enums   
	var catTipoConsultaTipoLinCred = {
			'principal':1,
			'foranea':2
	};	

	var catTipoActTipoLinCred = {//CtaAho
			'apertura':1,
			'bloquea':2,
			'desbloqueo':3,
			'cancelar':4
	};	

	var catTipoTransaccionLinCred = {
			'agrega':'1',
			'modifica':'2',
			'actualiza':'3'
	};

	var parametroBean = consultaParametrosSession();
	$('#usuarioDesbloquea').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaDesbloqueo').val(parametroBean.fechaSucursal);  
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
		//	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaCreditoID');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma',  'mensaje',
					'false', 'lineaCreditoID','ejecucionExitosa',
					'ejecucionFallo');
		
		}
	});					

	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$('#desbloquear').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoLinCred.desbloqueo); 
		$('#tipoTransaccion').val(catTipoTransaccionLinCred.actualiza);
	});
	$('#desbloquear').attr('tipoActualizacion', '3');

	$('#lineaCreditoID').blur(function() {
		consultaLineaCredito(this.id);
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#lineaCreditoID').val();


			lista('lineaCreditoID', '1', '5', camposLista, parametrosLista, 'lineasCreditoLista.htm');
		}				       
	});	
	$('#cuentaID').blur(function() {
		consultaCtaAho(this.id);
	});


	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});


	$('#usuarioDesbloquea').blur(function() {
		consultaUsuario(this.id);
	});

	$('#lineaCreditoID').focus();

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			lineaCreditoID: {
				required: true 
			},				
			motivoDesbloqueo:{ 
				required: true
			},
		},

		messages: {
			lineaCreditoID:{ 
				required: 'Especifique el número de Línea.'
			},
			motivoDesbloqueo: {
				required: 'Especifique el Motivo de Desbloqueo.'
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
		var var_estatus;
		var noUsuario;
		setTimeout("$('#cajaLista').hide();", 200);

		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){
			lineasCreditoServicio.consulta(tipConActualizacion, lineaCreditoBeanCon,function(linea) {
				if(linea!=null){
					$('#lineaCreditoID').val(linea.lineaCreditoID);							
					$('#clienteID').val(linea.clienteID);
					$('#cuentaID').val(linea.cuentaID);
					
						
					noUsuario =(linea.usuarioDesbloquea);
					var_estatus=(linea.estatus);
					if(var_estatus=='B'){
						$('#usuarioDesbloquea').val(parametroBean.numeroUsuario);   
						$('#nombreUsuario').val(parametroBean.nombreUsuario);           
						$('#fechaDesbloqueo').val(parametroBean.fechaSucursal); 
						$('#motivoDesbloqueo').val("");
						consultaCliente('clienteID'); 
						validaEstatus(var_estatus);
						$('#motivoDesbloqueo').focus();
						$('#motivoDesbloqueo').select();
					}else{
						if(noUsuario !=null && noUsuario > 0){
							$('#usuarioDesbloquea').val(noUsuario); 
							consultaUsuario('usuarioDesbloquea');         
							$('#fechaDesbloqueo').val(linea.fechaDesbloqueo); 
							$('#motivoDesbloqueo').val(linea.motivoDesbloqueo);
							consultaCliente('clienteID'); 
							validaEstatus(var_estatus);
						}
						else{
							mensajeSis("La Línea de Crédtio no esta Bloqueada.");
							$('#lineaCreditoID').val((linea.lineaCreditoID));
							$('#lineaCreditoID').focus();
							$('#lineaCreditoID').select();
							$('#clienteID').val("");
							$('#nombreCte').val("");
							$('#cuentaID').val("");
							$('#motivoDesbloqueo').val("");
							$('#usuarioDesbloquea').val("");   
							$('#nombreUsuario').val("");           
							$('#fechaDesbloqueo').val(""); 
							$('#estatus').val(""); 
							deshabilitaBoton('desbloquear', 'submit');	
						}
					}
									
				}else{
					mensajeSis("No existe la Línea de Crédito.");
					$('#lineaCreditoID').val("");
					$('#clienteID').val("");
					$('#nombreCte').val("");
					$('#cuentaID').val("");
					$('#motivoDesbloqueo').val("");
					$('#usuarioDesbloquea').val("");   
					$('#nombreUsuario').val("");           
					$('#fechaDesbloqueo').val(""); 
					$('#estatus').val(""); 
					$(jqLinea).focus();
					deshabilitaBoton('desbloquear', 'submit');	
					$(jqLinea).select();									
				}
			});										

		}
	}
	function consultaCtaAho(idControl) {
		var jqCtaAho  = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();	
		var CuentaAhoBeanCon = {
				'cuentaID'	:numCtaAho
		};
		var conCtaAho =3;
		var var_estatus;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaAho != '' && !isNaN(numCtaAho) && esTab){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
				if(ctaAho!=null){						
					$('#cuentaID').val(ctaAho.cuentaAhoID);	
					$('#clienteID').val(ctaAho.clienteID);

					var_estatus=(ctaAho.estatus);
					consultaCliente('clienteID');
					validaEstatus(var_estatus);						
				}else{
					mensajeSis("No existe la Cuenta de Ahorro.");
					$(jqCtaAho).focus();
					deshabilitaBoton('desbloquear', 'submit');			
				}    						
			});
		}	
	}


	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =2;
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


	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var conUsuario=2;		
			var UsuarioBeanCon = {
				'usuarioID'	:numUsuario
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){ 
			usuarioServicio.consulta(conUsuario,UsuarioBeanCon,function(usuario) {
						if(usuario!= null){					
							$('#nombreUsuario').val(usuario.nombreCompleto);								
						}else{
							mensajeSis("No existe el Usuario.");
							$(jqUsuario).focus();
						}    						
				});
			}
		}

	function validaEstatus(var_estatus) {
		var estatusAutorizado 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		var estatusRegistrada="R";

		if(var_estatus == estatusAutorizado){
			deshabilitaBoton('desbloquear', 'submit');
			$('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusBloqueado){
			habilitaBoton('desbloquear', 'submit');
			$('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			deshabilitaBoton('desbloquear', 'submit');
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			deshabilitaBoton('desbloquear', 'submit');
			$('#estatus').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			deshabilitaBoton('desbloquear', 'submit');
			$('#estatus').val('REGISTRADO');
		}		
	}

});

function ejecucionExitosa(){
	$('#lineaCreditoID').val();							
	$('#clienteID').val("");
	$('#nombreCte').val("");
	$('#cuentaID').val("");
	$('#motivoDesbloqueo').val("");
	$('#usuarioDesbloquea').val("");   
	$('#nombreUsuario').val("");           
	$('#fechaDesbloqueo').val(""); 
	$('#estatus').val(""); 
	$('#lineaCreditoID').focus();
}
function ejecucionFallo(){	
}
