
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

	$('#usuarioBloqueo').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaBloqueo').val(parametroBean.fechaSucursal); 
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaCreditoID');
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

	$('#bloquear').click(function() {

		$('#tipoActualizacion').val(catTipoActTipoLinCred.bloquea); 
		$('#tipoTransaccion').val(catTipoTransaccionLinCred.actualiza);
	});

	$('#bloquear').attr('tipoActualizacion', '2');


	$('#lineaCreditoID').blur(function() {
		consultaLineaCredito(this.id);
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#lineaCreditoID').val();


			lista('lineaCreditoID', '1', '3', camposLista, parametrosLista, 'lineasCreditoLista.htm');
		}				       
	});	
	$('#cuentaID').blur(function() {
		consultaCtaAho(this.id);
	});

	$('#cuentaID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";

			parametrosLista[0] = $('#cuentaID').val();


			lista('cuentaID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#usuarioBloqueo').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('usuarioBloqueo', '4', '1', 'nombre', $('#usuarioBloqueo').val(), 'listaUsuarios.htm');
		}
	});
	
	$('#usuarioBloqueo').blur(function() {
		consultaUsuario(this.id);
	});
	
	$('#lineaCreditoID').focus();

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({

		rules: {
			lineaCreditoID: {
				required: true
			},					
			motivoBloquea: {
				required: true
			},
		},

		messages: {

			lineaCreditoID: {
				required: 'Especifique el número de Línea.'
			},				
			motivoBloquea:{
				required:'Especifique el Motivo de Bloqueo.'
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
					$('#lineaCreditoID').val(linea.lineaCreditoID);							
					$('#clienteID').val(linea.clienteID);
					$('#cuentaID').val(linea.cuentaID);
					$('#motivoBloquea').val(linea.motivoBloquea);
					
					 var var_estatus=(linea.estatus);
					
					if(var_estatus =='B'){		
						$('#usuarioBloqueo').val(linea.usuarioBloqueo);            
						$('#fechaBloqueo').val(linea.fechaBloqueo);
						consultaUsuario('usuarioBloqueo'); 

					}else{
						$('#usuarioBloqueo').val(parametroBean.numeroUsuario);   
						$('#nombreUsuario').val(parametroBean.nombreUsuario);           
						$('#fechaBloqueo').val(parametroBean.fechaSucursal);

					}
					consultaCliente('clienteID');
					validaEstatus(var_estatus);
					

				}else{
					mensajeSis("No existe la Línea de Crédito.");
					$('#lineaCreditoID').val("");							
					$('#clienteID').val("");
					$('#cuentaID').val("");
					$('#nombreCte').val("");
					$('#motivoBloquea').val("");
					$('#usuarioBloqueo').val("");   
					$('#nombreUsuario').val("");           
					$('#fechaBloqueo').val("");
					$('#estatus').val('');
					$(jqLinea).focus();
					deshabilitaBoton('bloquear', 'submit');	
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
		if(numCtaAho != '' && !isNaN(numCtaAho ) ){
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
					deshabilitaBoton('bloquear', 'submit');			
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
		var estatusActivo 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		var estatusRegistrada="R";

		if(var_estatus == estatusActivo){
			habilitaBoton('bloquear', 'submit');
			$('#estatus').val('AUTORIZADO');
			$('#motivoBloquea').focus();
			$('#motivoBloquea').select();
		}
		if(var_estatus == estatusBloqueado){
			deshabilitaBoton('bloquear', 'submit');
			$('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			deshabilitaBoton('bloquear', 'submit');
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			deshabilitaBoton('bloquear', 'submit');
			$('#estatus').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			habilitaBoton('bloquear', 'submit');
			$('#estatus').val('REGISTRADO');
		}		
	}



});

function ejecucionExitosa(){
	$('#lineaCreditoID').val();							
	$('#clienteID').val("");
	$('#cuentaID').val("");
	$('#nombreCte').val("");
	$('#motivoBloquea').val("");
	$('#usuarioBloqueo').val("");   
	$('#nombreUsuario').val("");           
	$('#fechaBloqueo').val("");
	$('#estatus').val('');
	$('#lineaCreditoID').focus();
}
function ejecucionFallo(){	
}