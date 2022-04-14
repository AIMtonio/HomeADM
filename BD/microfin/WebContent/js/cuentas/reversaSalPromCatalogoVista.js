$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	deshabilitaBoton('agrega', 'submit');
	$("#cuentaAhoID").focus();
	ocultaLimpiaAutorizacion();
	$("#seccionCliente").hide();
	$('#gridReversa').hide();
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','cuentaAhoID','funcionExito','funcionError');
		}
	});

	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: {
				required: true
			},
			usuarioAutorizaID:{
				required: true
			},
			contraseniaUsuarioAutoriza:{
				required: true
			}
		},
		messages: {
			cuentaAhoID: {
				required: 'Especificar Número de la Cuenta.'
			},
			usuarioAutorizaID: {
				required: 'Especificar Usuario'
			},
			contraseniaUsuarioAutoriza: {
				required: 'Especificar la contraseña'
			}
		}
	});

	$('#cuentaAhoID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = $('#cuentaAhoID').val();
		lista('cuentaAhoID', '3', '24',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
	});

	$('#cuentaAhoID').blur(function() {
		var cuenta = $('#cuentaAhoID').asNumber();
		if (cuenta > 0 && esTab==true) {
			setTimeout("$('#cajaLista').hide();", 200);
			consultaCuenta(this.id);
		}
	});

	$('#usuarioAutorizaID').blur(function(){
		if(parametroBean.claveUsuario == $("#usuarioAutorizaID").val()){
			mensajeSis("El Usuario que Autoriza no puede ser el mismo que el Usuario Logeado.");
			$('#usuarioAutorizaID').focus();
		}else{
			if($('#usuarioAutorizaID').val()!=""){
				validaUsuario(this);
			}

		}
	});


	$('#agrega').click(function() {
		$("#tipoActualizacion").val(2);
		validaCamposVaciosGrid('lmotivoProceso,ltipoProceso','S','lseleccionado',',');
	});

});

function consultaCuenta(idControl) {
    var jqCuenta = eval("'#" + idControl + "'");
    var numCuenta = $.trim($(jqCuenta).val());

	var CuentaAhoBeanCon = {
		'cuentaAhoID' : numCuenta
	};

	setTimeout("$('#cajaLista').hide();", 200);
	cuentasAhoServicio.consultaCuentasAho(1,CuentaAhoBeanCon,{ async: false, callback: function(cuenta) {
		if (cuenta != null) {
			if(cuenta.estatus!="A"){
				mensajeSis("La cuenta "+numCuenta+" no se encuentra <b>ACTIVA</b>");
				$('#cuentaAhoID').val("");
				$('#cuentaAhoID').focus();
				$('#clienteID').val('');
				$('#nombreCte').val('');
				$("#seccionCliente").hide();
				deshabilitaBoton('agrega','submit');

			}else{
				consultaCliente(cuenta.clienteID);
			}
		}else{
			mensajeSis("No Existe la Cuenta.");
			$(jqCuenta).val("");
			$(jqCuenta).focus();
			$(jqCuenta).select();
			$('#clienteID').val('');
			$('#nombreCte').val('');
			ocultaLimpiaAutorizacion();
			limpiaGrid('gridComisionesSaldoPromedio','S');
			deshabilitaBoton('agrega','submit');
			$("#seccionCliente").hide();
			$('#gridReversa').hide();
		}
	}});
}

function consultaCliente(clienteID) {
	setTimeout("$('#cajaLista').hide();", 200);
	clienteServicio.consulta(1,clienteID, { async: false, callback:function(cliente) {
		if (cliente != null) {
			if(cliente.estatus!="A"){
				deshabilitaBoton('agrega','submit');
				mensajeSis("El cliente no se encuentra <b>ACTIVO</b>.");
				$('#clienteID').val('');
				$('#nombreCte').val('');
				$('#clienteID').focus();
				ocultaLimpiaAutorizacion();
				limpiaGrid('gridComisionesSaldoPromedio','S');
				$("#seccionCliente").hide();
				deshabilitaBoton('agrega','submit');
			}else{
				$('#clienteID').val(clienteID);
				$('#nombreCte').val(cliente.nombreCompleto);
				consultaComicionesPendientesPag("cuentaAhoID", clienteID);
			}
		}else{
			mensajeSis("No Existe el Cliente");
			$('#clienteID').val('');
			$('#nombreCte').val('');
			$('#cuentaAhoID').focus();
			ocultaLimpiaAutorizacion();
			limpiaGrid('gridComisionesSaldoPromedio','S');
			deshabilitaBoton('agrega','submit');
			$("#seccionCliente").hide();
			$('#gridReversa').hide();
		}
	}}
	);
}

function consultaComicionesPendientesPag(idControl, clienteID) {
    var jqCuenta = eval("'#" + idControl + "'");
    var numCuenta = $.trim($(jqCuenta).val());

    setTimeout("$('#cajaLista').hide();", 200);

	var CLientesBean = {
		'clienteID' : clienteID,
		'cuentaAhoID': numCuenta
	};
	comicionesPendientesCob.consulta(2,CLientesBean,
		{async: false, callback:function(comisiones) {
			if(comisiones != null) {
				consultaComicionesPendientesGrid(numCuenta);
			}else{
				mensajeSis("La cuenta <b>"+numCuenta+"</b> no tiene comisiones pagadas.");
				$('#nombreCte').val("");
				$('#clienteID').val("");
				$(jqCuenta).val("");
				$(jqCuenta).focus();
				$(jqCuenta).select();
				deshabilitaBoton('agrega','submit');
				ocultaLimpiaAutorizacion();
				limpiaGrid('gridComisionesSaldoPromedio','S');
				$("#seccionCliente").hide();
				$('#gridReversa').hide();
			}
		}
	});
}


function consultaComicionesPendientesGrid(cuentaAhoID){
	bloquearPantalla();
	var params = {
		'tipoLista' 	: 2,
		'cuentaAhoID'	: cuentaAhoID
	};
	setTimeout("$('#cajaLista').hide();", 200);
	$.post("comSaldoPromGirdVista.htm", params, function(data){
		desbloquearPantalla();
		if(data.length > 1811) {
			$('#gridComisionesSaldoPromedio').html(data);
			$('#gridComisionesSaldoPromedio').show();
			agregaFormatoControles('formaGenerica');
			habilitaBoton('agrega','submit');
			muestraLimpiaAutorizacion();
			$("#seccionCliente").show();
			$('#gridReversa').show();
		}else{
			mensajeSis("La cuenta <b>"+cuentaAhoID+"</b> no tiene saldo promedio pagado.");
			$('#gridComisionesSaldoPromedio').html("");
			$('#gridComisionesSaldoPromedio').hide();
			deshabilitaBoton('agrega','submit');
			$("#seccionCliente").hide();
			$('#gridReversa').hide();
		}
	});
}

function validaUsuario(control) {
	var usuarioBeanCon = {
		'clave' : $('#usuarioAutorizaID').val(),
		'contrasenia' : $('#contraseniaUsuarioAutoriza').val().trim()
	};

	usuarioServicio.consulta(3, usuarioBeanCon,  { async: false, callback:function(usuario) {
			$('#usuarioID').val(0);
			if(usuario!=null){
				if(usuario.estatus !="A"){
					mensajeSis('El usuario <b>'+$('#usuarioAutorizaID').val()+'</b> no se encuentra <b>ACTIVO</b>.');
					$('#contraseniaUsuarioAutoriza').val('');
					$('#contraseniaUsuarioAutoriza').focus();
					deshabilitaBoton('agrega','submit');
				}else{
					$('#usuarioID').val(usuario.usuarioID);
					habilitaBoton('agrega','submit');
				}
			}else{
				mensajeSis("No Existe el Usuario <b>"+$('#usuarioAutorizaID').val()+"</b>");
				$('#usuarioAutorizaID').val('');
				$('#contraseniaUsuarioAutoriza').val('');
				$('#usuarioAutorizaID').focus();
				deshabilitaBoton('agrega','submit');
			}
	}});

}


function listaComboCatReversa(numDetReg){
	var tipoCon=1;
	var bean = {
		'tipoOperacion' : 'R'
	};
	for(var i = 1; i <= numDetReg; i++){
		var  tipoProceso = eval("'ltipoProceso" + i+ "'");
		comicionesPendientesCob.listaTipoReversa(tipoCon,bean, { async: false,callback: function(catComision){
			dwr.util.removeAllOptions(tipoProceso);
			dwr.util.addOptions(tipoProceso, {'0':'SELECCIONA'});
			dwr.util.addOptions(tipoProceso, catComision, 'tipoReversaID', 'descripcion');
		}});
	}
}

function ocultaLimpiaAutorizacion(){
	$("#usuarioContrasenia").hide();
	$('#usuarioAutorizaID').val('');
	$('#contraseniaUsuarioAutoriza').val('');
	// los readonly se usa para evitar el autocomplete
	$('#usuarioAutorizaID').attr('readonly', 'readonly');
	$('#contraseniaUsuarioAutoriza').attr('readonly', 'readonly');
}
function muestraLimpiaAutorizacion(){
	$('#usuarioAutorizaID').val('');
	$('#contraseniaUsuarioAutoriza').val('');
	// los readonly se usa para evitar el autocomplete
	$('#usuarioAutorizaID').removeAttr('readonly');
	$('#contraseniaUsuarioAutoriza').removeAttr('readonly');
	$("#usuarioContrasenia").show();
}

function funcionError(){
}

function funcionExito(){
	limpiaGrid('gridComisionesSaldoPromedio','S');
	ocultaLimpiaAutorizacion();
	deshabilitaBoton('agrega', 'submit');
}