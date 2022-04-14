$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	deshabilitaBoton('agrega', 'submit');
	$("#clienteID").focus();
	ocultaLimpiaAutorizacion();
    $('#gridCondona').hide();

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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','clienteID','funcionExito','funcionError');
		}
	});

	$('#formaGenerica').validate({
		rules: {
			clienteID: {
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
			clienteID: {
				required: 'Especificar Número de Cliente'
			},
			usuarioAutorizaID: {
				required: 'Especificar Usuario'
			},
			contraseniaUsuarioAutoriza: {
				required: 'Especificar la contraseña'
			}
		}
	});

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3',	'9', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		var cliente = $('#clienteID').asNumber();
		if (cliente > 0 && esTab==true) {
			setTimeout("$('#cajaLista').hide();", 200);
			consultaCliente(this.id);
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
		$("#tipoActualizacion").val(1);
		validaCamposVaciosGrid('lmotivoProceso,ltipoProceso','S','lseleccionado',',');
	});

});

function consultaCliente(idControl) {
    var jqCliente = eval("'#" + idControl + "'");
    var numCliente = $.trim($(jqCliente).val());

    setTimeout("$('#cajaLista').hide();", 200);
    $('#gridCondona').hide();
    limpiaGrid('gridComisionesSaldoPromedio','S');
    limpiaGrid('gridCuentasCliente','S');
    ocultaLimpiaAutorizacion();
    deshabilitaBoton('agrega','submit');
	clienteServicio.consulta(1,numCliente,{ async: false, callback:function(cliente) {
		if (cliente != null) {
			if(cliente.estatus!="A"){
				deshabilitaBoton('agrega','submit');
				mensajeSis("El cliente no se encuentra <b>ACTIVO</b>.");
				$('#clienteID').val('');
				$('#nombreCte').val('');
				$('#clienteID').focus();
                $('#gridCondona').hide();
				ocultaLimpiaAutorizacion();
				limpiaGrid('gridComisionesSaldoPromedio','S');
				limpiaGrid('gridCuentasCliente','S');
			}else{
				$('#nombreCte').val(cliente.nombreCompleto);
				consultaComicionesPendientesPag("clienteID");
			}
		}else{
			mensajeSis("No Existe el Cliente");
			$(jqCliente).val("");
			$(jqCliente).focus();
			$(jqCliente).select();

		}
	}});
}

function consultaComicionesPendientesPag(idControl) {
    var jqCliente = eval("'#" + idControl + "'");
    var numCliente = $.trim($(jqCliente).val());

    setTimeout("$('#cajaLista').hide();", 200);

	var CLientesBean = {
		'clienteID' : numCliente,
		'cuentaAhoID': ""
	};
	comicionesPendientesCob.consulta(1,CLientesBean,{ async: false, callback:function(comisiones) {
		if(comisiones != null) {
			consultaCtasClienteGrid(numCliente);
		}else{
			mensajeSis("El cliente <b>"+numCliente+"</b> no tiene comisiones pendientes.");
			$("#nombreCte").val("");
			$(jqCliente).val("");
			$(jqCliente).focus();
			$(jqCliente).select();
			deshabilitaBoton('agrega','submit');
            $('#gridCondona').hide();
			ocultaLimpiaAutorizacion();
			limpiaGrid('gridComisionesSaldoPromedio','S');
			limpiaGrid('gridCuentasCliente','S');
		}
	}});
}

function consultaCtasClienteGrid(clienteID){
	bloquearPantalla();
	var params = {
		'tipoLista' 	: 23,
		'clienteID'		: clienteID
	};
	setTimeout("$('#cajaLista').hide();", 200);
	$.post("ctasClienteGirdVista.htm", params, function(data){
		if(data.length > 0) {
			$('#gridCuentasCliente').html(data);
			$('#gridCuentasCliente').show();
			agregaFormatoControles('formaGenerica');
			desbloquearPantalla();
		}else{
			mensajeSis("El cliente <b>"+clienteID+"</b> no tiene cuentas de ahorro.");
			$('#gridCuentasCliente').html("");
			$('#gridCuentasCliente').hide();
			desbloquearPantalla();
		}
	});
}

function consultaComicionesPendientesGrid(jqCuentaAhoID, idEstatus){
	if($("#"+idEstatus).val()=="D"){
		bloquearPantalla();
		var params = {
			'tipoLista' 	: 1,
			'cuentaAhoID'	: jqCuentaAhoID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		$.post("comSaldoPromGirdVista.htm", params, function(data){
			desbloquearPantalla();
			if(data.length > 1677) {
                $('#gridCondona').show();
				$('#gridComisionesSaldoPromedio').html(data);
				$('#gridComisionesSaldoPromedio').show();
				agregaFormatoControles('formaGenerica');
				habilitaBoton('agrega','submit');
				muestraLimpiaAutorizacion();
			}else{
				mensajeSis("La cuenta <b>"+jqCuentaAhoID+"</b> no tiene saldo promedio pendiente de cobro.");
				$('#gridComisionesSaldoPromedio').html("");
				$('#gridComisionesSaldoPromedio').hide();
				deshabilitaBoton('agrega','submit');
			}
		});
	}else{
        $('#gridCondona').hide();
		ocultaLimpiaAutorizacion();
        $('#gridComisionesSaldoPromedio').html("");
		deshabilitaBoton('agrega','submit');
    }

}

function validaUsuario(control) {
	var usuarioBeanCon = {
		'clave' : $('#usuarioAutorizaID').val(),
		'contrasenia' : $('#contraseniaUsuarioAutoriza').val().trim()
	};

	usuarioServicio.consulta(3, usuarioBeanCon, { async: false,callback:function(usuario) {
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


function listaComboCatCondonacion(numDetReg){
	var tipoCon=1;
	var bean = {
		'tipoOperacion' : 'C'
	};
	for(var i = 1; i <= numDetReg; i++){
		var  tipoProceso = eval("'ltipoProceso" + i+ "'");
		comicionesPendientesCob.listaTipoCondonacion(tipoCon,bean, { async: false,callback: function(catComision){
			dwr.util.removeAllOptions(tipoProceso);
			dwr.util.addOptions(tipoProceso, {'0':'SELECCIONA'});
			dwr.util.addOptions(tipoProceso, catComision, 'tipoCondonacionID', 'descripcion');
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
    $('#gridCondona').hide();
	limpiaGrid('gridComisionesSaldoPromedio','S');
	limpiaGrid('gridCuentasCliente','S');
	ocultaLimpiaAutorizacion();
	deshabilitaBoton('agrega', 'submit');
}