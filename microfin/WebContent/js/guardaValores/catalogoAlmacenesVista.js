$(document).ready(function() {
	$("#almacenID").focus();
	var parametroBean = consultaParametrosSession();
	var clavePuestoID = parametroBean.clavePuestoID;
	var numeroUsuario = parametroBean.numeroUsuario;
	validarUsuario(clavePuestoID, numeroUsuario);
	esTab = true;
	deshabilitarCampos();
	//Definicion de Constantes y Enums
	var catTransaccionAlmacenes = {
		'agrega'   : '1',
		'modifica' : '2'
	};

	var con_Almacen= {
		'principal'	: 1
	};

	var con_sucursal= {
		'foranea'	: 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','almacenID', 'funcionExito', 'funcionError');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTransaccionAlmacenes.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTransaccionAlmacenes.modifica);
	});

	$('#almacenID').blur(function(){
		if(esTab){
			if($('#almacenID').val() == '0'){
				habilitarCampos();
				limpiarCampos();
				deshabilitaControl('estatus');
				$('#nombreAlmacen').focus();
				$('#estatus').val('A');
				habilitaBoton('agrega','submit');
				deshabilitaBoton('modifica','submit');
			} else {
				consultaAlmacen(this.id);
			}
		}
	});

	$('#almacenID').bind('keyup',function(e) {
		lista('almacenID', '2', '1', 'nombreAlmacen', $('#almacenID').val(), 'listaCatalogoAlmacenes.htm');
	});

	$('#sucursalID').blur(function(){
		consultaSucursal(this.id);
	});

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			nombreAlmacen: {
				required: true
			},
			estatus: {
				required: true
			},
			sucursalID: {
				required: true
			}
		},
		messages: {
			nombreAlmacen: {
				required: 'Especifica el Nombre del Almacén'
			},
			estatus: {
				required: 'Especifica el Estatus'
			},
			sucursalID: {
				required: 'Especifica la Sucursal'
			}
		}
	});

	// funciones
	function consultaAlmacen(idControl) {
		var jqAlmacen = eval("'#" + idControl + "'");
		var numAlmacen = $(jqAlmacen).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var catalogoAlmacenesBean = {
				'almacenID':numAlmacen
		};

		if (numAlmacen != '' && !isNaN(numAlmacen) && esTab) {

			catalogoAlmacenesServicio.consulta(con_Almacen.principal, catalogoAlmacenesBean, function(catalogoAlmacen) {

				if (catalogoAlmacen != null) {
					habilitarCampos();
					$('#almacenID').val(catalogoAlmacen.almacenID);
					$('#nombreAlmacen').val(catalogoAlmacen.nombreAlmacen);
					$('#estatus').val(catalogoAlmacen.estatus);
					$('#sucursalID').val(catalogoAlmacen.sucursalID);
					consultaSucursal('sucursalID');
					deshabilitaBoton('agrega','submit');
					habilitaBoton('modifica','submit');
					$('#nombreAlmacen').focus();
				} else {
					mensajeSis("No Existe el Almacén Consultado.");
					limpiarCampos();
					deshabilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					$('#almacenID').focus();
				}
			});
		} else{
			$('#nombreAlmacen').val('');
			$('#estatus').val('');
			$('#sucursalID').val('');
			$('#nombreSucursal').val('');
			deshabilitaBoton('agrega','submit');
			deshabilitaBoton('modifica','submit');
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(con_sucursal.foranea, numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#sucursalID').val(sucursal.sucursalID);
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("No Existe la Sucursal");
					$('#sucursalID').val('');
					$('#nombreSucursal').val('');
					$('#sucursalID').focus();
				}
			});
		}
	}

	function validarUsuario(clavePuestoID, numeroUsuario){

		var validaUsuario = 0;
		var puestoFacultadoBean = {
			'puestoFacultado' : clavePuestoID
		};
		var consultaPuestoFacultado = 1;

		paramGuardaValoresServicio.consultaFacultados(consultaPuestoFacultado,puestoFacultadoBean,{ async: false, callback:function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.usrGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Puestos Facultados");
			}
		}});

		var usuarioFacultadoBean = {
			'usuarioFacultadoID' : numeroUsuario
		};
		var consultaUsuarioFacultaos = 2;

		paramGuardaValoresServicio.consultaFacultados(consultaUsuarioFacultaos,usuarioFacultadoBean, { async: false, callback:function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.usrGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Usuarios Facultados");
			}
		}});

		var usuarioAdmonBean = {
			'paramGuardaValoresID' : 1,
			'usuarioAdmon': numeroUsuario
		};
		var numeroConsulta = 3;

		paramGuardaValoresServicio.consulta(numeroConsulta,usuarioAdmonBean,{ async: false, callback: function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.paramGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Usuario Administración.");
			}
		}});

		if(validaUsuario == 0){
			deshabilitaPantalla();
		}
	}

	function limpiarCampos(){
		$('#nombreAlmacen').val('');
		$('#estatus').val('');
		$('#sucursalID').val('');
		$('#nombreSucursal').val('');
	}
});

function funcionExito(){
	$('#nombreAlmacen').val('');
	$('#estatus').val('');
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	deshabilitarCampos();
}

function funcionError(){

}

function habilitarCampos(){
	habilitaControl('nombreAlmacen');
	habilitaControl('estatus');
	habilitaControl('claveUsuario');
	habilitaControl('sucursalID');
	habilitaControl('nombreSucursal');
}

function deshabilitarCampos(){
	deshabilitaControl('nombreAlmacen');
	deshabilitaControl('estatus');
	deshabilitaControl('claveUsuario');
	deshabilitaControl('sucursalID');
	deshabilitaControl('nombreSucursal');
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}

function deshabilitaPantalla(){
	mensajeSis("Estimado Usuario no Cuenta con los Permisos Necesarios para el Módulo Guarda Valores.");
	deshabilitaControl('almacenID');
	deshabilitaControl('nombreAlmacen');
	deshabilitaControl('estatus');
	deshabilitaControl('claveUsuario');
	deshabilitaControl('sucursalID');
	deshabilitaControl('nombreSucursal');
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}