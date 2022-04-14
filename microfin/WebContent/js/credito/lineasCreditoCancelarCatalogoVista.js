var estatusLinea ="";
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
	$('#usuarioCancela').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaCancelacion').val(parametroBean.fechaSucursal);  

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
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

	$('#cancelar').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoLinCred.cancelar); 
		$('#tipoTransaccion').val(catTipoTransaccionLinCred.actualiza);
	});
	$('#cancelar').attr('tipoActualizacion', '3');

	$('#lineaCreditoID').blur(function() {
		consultaLineaCredito(this.id);
		//$('#fechaAutoriza').val('2011-06-13');
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#lineaCreditoID').val();


			lista('lineaCreditoID', '1', '6', camposLista, parametrosLista, 'lineasCreditoLista.htm');
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

	$('#usuarioCancela').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('usuarioCancela', '4', '1', 'nombre', $('#usuarioCancela').val(), 'listaUsuarios.htm');
		}
	});

	/*$('#usuarioCancela').blur(function() {
		consultaUsuario(this.id);
	});*/

	$('#lineaCreditoID').focus();

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			lineaCreditoID: {
				required: true
			},							
			motivoCancela: { 
				required: true 
			},
		},

		messages: {
			lineaCreditoID: { 
				required: 'Especifique el número de Línea.'
			},

			motivoCancela: {
				required: 'Especifique el Motivo de Cancelación.'
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
		setTimeout("$('#cajaLista').hide();", 200);

		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){
			lineasCreditoServicio.consulta(tipConActualizacion, lineaCreditoBeanCon,function(linea) {
				if(linea!=null){
					$('#lineaCreditoID').val(linea.lineaCreditoID);							
					$('#clienteID').val(linea.clienteID);
					$('#cuentaID').val(linea.cuentaID);
					$('#motivoCancela').val(linea.motivoCancela);
					estatusLinea = linea.estatus;
					if(estatusLinea =='C'){
						$('#fechaCancelacion').val(linea.fechaCancelacion);  
						$('#usuarioCancela').val(linea.usuarioCancela);   
						consultaNombreUsuarioCancela(linea.usuarioCancela);
					}else{
						$('#usuarioCancela').val(parametroBean.numeroUsuario);   
						$('#nombreUsuario').val(parametroBean.nombreUsuario);           
						$('#fechaCancelacion').val(parametroBean.fechaSucursal);
					}
					consultaCliente('clienteID');
					validaEstatus(estatusLinea);				
				}else{
					mensajeSis("No existe la Línea de Crédito.");
					$('#lineaCreditoID').val("");							
					$('#clienteID').val("");
					$('#nombreCte').val("");
					$('#cuentaID').val("");
					$('#motivoCancela').val("");
					$('#usuarioCancela').val("");   
					$('#nombreUsuario').val("");           
					$('#fechaCancelacion').val("");
					$('#estatus').val('');
					$(jqLinea).focus();
					deshabilitaBoton('cancelar', 'submit');	
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
					deshabilitaBoton('cancelar', 'submit');			
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


	function validaEstatus(var_estatus) {
		var estatusAutorizado 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		var estatusRegistrada="R";

		if(var_estatus == estatusAutorizado){
			habilitaBoton('cancelar', 'submit');
			//deshabilitaBoton('desbloquear', 'submit');
			$('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusBloqueado){
			//deshabilitaBoton('bloquear', 'submit');
			habilitaBoton('cancelar', 'submit');
			$('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			//deshabilitaBoton('bloquear', 'submit');
			deshabilitaBoton('cancelar', 'submit');
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			//deshabilitaBoton('bloquear', 'submit');
			deshabilitaBoton('cancelar', 'submit');
			$('#estatus').val('INACTIVO');
		} 
		if(var_estatus == estatusRegistrada){
			//habilitaBoton('bloquear', 'submit');
			deshabilitaBoton('cancelar', 'submit');
			$('#estatus').val('REGISTRADO');
		}		
	}	

	
	function consultaNombreUsuarioCancela(noUsuario){
		var numUsuario= noUsuario;
		var conUsuario= 2;		
		setTimeout("$('#cajaLista').hide();", 200);			
		if(numUsuario != '' && !isNaN(numUsuario)){
			var usuarioBeanCon = {      
	  				'usuarioID':numUsuario 
					};
			usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					dwr.util.setValues(usuario);
					$('#nombreUsuario').val(usuario.nombreCompleto);
					validaEstatus(estatusLinea);	
				}else{
					mensajeSis("No existe el Usuario.");
				}    						
			});
		}
	}

});

function ejecucionExitosa(){
	$('#lineaCreditoID').val();							
	$('#clienteID').val("");
	$('#nombreCte').val("");
	$('#cuentaID').val("");
	$('#motivoCancela').val("");
	$('#usuarioCancela').val("");   
	$('#nombreUsuario').val("");           
	$('#fechaCancelacion').val("");
	$('#estatus').val('');
	$('#lineaCreditoID').focus();
}
function ejecucionFallo(){	
}