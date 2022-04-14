$(document).ready(function() {

	inicializaForma('formaGenerica');
	agregaFormatoControles('formaGenerica');
	parametros = consultaParametrosSession();
	deshabilitaBoton('grabar','submit');
	// esTab = true;
	encontradoResultado = false;
	$("#paramGuardaValoresID").focus();

	//Definicion de Constantes y Enums
	var catParamGuardaValores = {
		'grabar'   : '1',
		'modifica' : '2'
	};

	var consulta = {
		'principal' : 1,
		'foranea'	: 2
	};

	esTab = false;
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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','paramGuardaValoresID', 'funcionExito', 'funcionError');
		}
	});

	$('#grabar').click(function() {
		var validacionFacultado = verificarVacioFacultado();
		if( validacionFacultado == 0){
			var validacionDocumento = verificarVacioDocumento();
			if( validacionDocumento== 0 ){
				if($('#paramGuardaValoresID').val() == '0'){
					$('#tipoTransaccion').val(catParamGuardaValores.grabar);
				} else {
					$('#tipoTransaccion').val(catParamGuardaValores.modifica);
				}
			} else {
				mensajeSis("Ingresar un Documento");
				event.preventDefault();
			}
		} else {
			mensajeSis("Ingresar un Puesto o usuario Facultado");
		}
	});

	$('#paramGuardaValoresID').blur(function(){
		if($('#paramGuardaValoresID').val() == '0'){
			consultarParametrizacion(this.id);
		} else {
			consultaParametros(this.id);
		}
	});

	$('#paramGuardaValoresID').bind('keyup',function(e) {
		lista('paramGuardaValoresID', '1', '1', 'nombreEmpresa', $('#paramGuardaValoresID').val(), 'listaParamGuardaValores.htm');
	});

	$('#usuarioAdmon').bind('keyup',function(e){
		lista('usuarioAdmon', '2', '1', 'nombreCompleto', $('#usuarioAdmon').val(), 'listaUsuarios.htm');
	});

	$('#usuarioAdmon').blur(function() {
		validaUsuarioAdmon(this.id);
	});

	$('#correoRemitente').blur(function() {
		var correo = $('#correoRemitente').val();
		if( correo != ''){
			validarCorreo(correo, 'correoRemitente');
		}
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			usuarioAdmon: {
				required: true
			},
			correoRemitente: {
				required: true
			},
			servidorCorreo: {
				required: true
			},
			puerto: {
				required: true
			},
			usuarioServidor: {
				required: true
			},
			contrasenia: {
				required: true
			},
			listaDocumentoID: {
				required: true
			}
		},
		messages: {
			usuarioAdmon: {
				required: 'Especificar el Usuario Admon'
			},
			correoRemitente: {
				required: 'Especificar el Correo Remitente'
			},
			servidorCorreo: {
				required: 'Especificar el Servidor de Correo'
			},
			puerto: {
				required: 'Especificar el Puerto'
			},
			usuarioServidor: {
				required: 'Especificar el Usuario del Servidor'
			},
			contrasenia: {
				required: 'Especificar el Contraseña'
			},
			listaDocumentoID: {
				required: 'Especificar el Tipo de Documento'
			}
		}
	});

	// funciones
	function consultaParametros(idControl) {
		var jqParamGuardaValoresID = eval("'#" + idControl + "'");
		var numParametro = $(jqParamGuardaValoresID).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var paramGuardaValoresBean = {
			'paramGuardaValoresID':numParametro
		};

		if (numParametro != '' && !isNaN(numParametro) && esTab) {
			paramGuardaValoresServicio.consulta(consulta.principal, paramGuardaValoresBean, function(parametros) {

				if (parametros != null) {
					$('#paramGuardaValoresID').val(parametros.paramGuardaValoresID);
					$('#usuarioAdmon').val(parametros.usuarioAdmon);
					$('#nombreUsuarioAdmon').val(parametros.nombreUsuarioAdmon);
					$('#correoRemitente').val(parametros.correoRemitente);

					$('#nombreEmpresa').val(parametros.nombreEmpresa);
					$('#servidorCorreo').val(parametros.servidorCorreo);
					$('#puerto').val(parametros.puerto);
					$('#usuarioServidor').val(parametros.usuarioServidor);
					$('#contrasenia').val(parametros.contrasenia);

					consultaGrid(parametros.paramGuardaValoresID);
					consultaGridDocumentos(parametros.paramGuardaValoresID);
					habilitaBoton('grabar','submit');
				} else {
					mensajeSis("No Existe Parametrizacion.");
					limpiarCampos();
					$('#paramGuardaValoresGrid').hide();
					$('#paramGuardaValoresDocGrid').hide();
					deshabilitaBoton('grabar','submit');
					$('#paramGuardaValoresID').focus();
				}
			});
		} else{
			limpiarCampos();
			$('#paramGuardaValoresGrid').hide();
			$('#paramGuardaValoresDocGrid').hide();
			deshabilitaBoton('grabar','submit');
		}
	}

	// funciones
	function consultarParametrizacion(idControl) {
		var jqParamGuardaValoresID = eval("'#" + idControl + "'");
		var numParametro = $(jqParamGuardaValoresID).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var paramGuardaValoresBean = {
			'paramGuardaValoresID':numParametro
		};

		if (numParametro != '' && !isNaN(numParametro) && esTab) {

			paramGuardaValoresServicio.consulta(consulta.foranea, paramGuardaValoresBean, function(parametros) {

				if (parametros != null) {

					if(parametros.paramGuardaValoresID == 0){
						habilitaBoton('grabar', 'submit');
						deshabilitaBoton('modifica', 'submit');
						limpiarCampos();
						consultaGrid(0);
						consultaGridDocumentos(0);
					} else {
						mensajeSis("Ya Existe una Parametrización.");
						limpiarCampos();
						$('#paramGuardaValoresGrid').hide();
						$('#paramGuardaValoresDocGrid').hide();
						deshabilitaBoton('grabar','submit');
						$('#paramGuardaValoresID').focus();
					}
				} else {
					mensajeSis("No Existe una Parametrización.");
					limpiarCampos();
					$('#paramGuardaValoresGrid').hide();
					$('#paramGuardaValoresDocGrid').hide();
					deshabilitaBoton('grabar','submit');
					$('#paramGuardaValoresID').focus();
				}
			});
		} else{
			limpiarCampos();
			$('#paramGuardaValoresGrid').hide();
			$('#paramGuardaValoresDocGrid').hide();
			deshabilitaBoton('grabar','submit');
		}
	}

	$('#usuarioAdmon').bind('keyup',function(e){
		lista('usuarioAdmon', '2', '1', 'nombreCompleto', $('#usuarioAdmon').val(), 'listaUsuarios.htm');
	});

	function validaUsuarioAdmon(control) {
		var numUsuario = $('#usuarioAdmon').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario >0){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(consulta.principal,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					switch(usuario.estatus){
						case "A":
							$('#usuarioAdmon').val(usuario.usuarioID);
							$('#nombreUsuarioAdmon').val(usuario.nombreCompleto);
						break;
						case "B":
							mensajeSis('El Usuario Consultado está Bloqueado');
							$('#nombreUsuarioAdmon').val('');
							$('#usuarioAdmon').focus();
							break;
						case "C":
							mensajeSis('El Usuario Consultado está Cancelado o en Baja');
							$('#nombreUsuarioAdmon').val('');
							$('#usuarioAdmon').focus();
							break;
						default:
							$('#usuarioAdmon').val('');
							$('#nombreUsuarioAdmon').val('');
						break;
					}
				} else {
					mensajeSis("No Existe el Usuario.");
					$('#nombreUsuarioAdmon').val('');
					$('#usuarioAdmon').focus();
				}
			});
		}
	}


	function validarCorreo(correo, controlID){
		var jControlID  = eval("'#" + controlID + "'");
		var expresionRegular = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

		if( !expresionRegular.test(correo)== true){
			mensajeSis("El correo no es valido");
			$(jControlID).focus();
		}
	}

	function limpiarCampos(){
		$('#usuarioAdmon').val('');
		$('#nombreUsuarioAdmon').val('');
		$('#correoRemitente').val('');
		$('#nombreEmpresa').val('');
		$('#servidorCorreo').val('');
		$('#puerto').val('');
		$('#usuarioServidor').val('');
		$('#contrasenia').val('');
	}

});

	esTab = false;

var listaGrid = {
	'consulta'		  : 1,
	'listaFacultados' : 2,
	'listaDocumentos' : 3
};

function consultaGrid(paramGuardaValoresID){

	var params = {
		'paramGuardaValoresID':paramGuardaValoresID,
	};
	params['paramGuardaValoresID'] = paramGuardaValoresID;
	params['tipoLista'] = listaGrid.listaFacultados;

	$('#paramGuardaValoresGrid').show();
	$.post("paramGuardaValoresGrid.htm", params, function(data) {

		if (data.length > 1315) {
			$('#agregaEsquema').hide();
			agregaFormatoControles('formaGenerica');
			$('#paramGuardaValoresGrid').html(data);
			$('#paramGuardaValoresGrid').show();
		} else {
			$('#agregaEsquema').show();
			$('#paramGuardaValoresGrid').html(data);
			$('#paramGuardaValoresGrid').show();
		}
	});
}

function consultaGridDocumentos(paramGuardaValoresID){

	var params = {
		'paramGuardaValoresID':paramGuardaValoresID,
	};
	params['paramGuardaValoresID'] = paramGuardaValoresID;
	params['tipoLista'] = listaGrid.listaDocumentos;

	$('#paramGuardaValoresDocGrid').show();
	$.post("paramGuardaValoresDocGrid.htm", params, function(data) {
		if (data.length > 1199) {
			$('#agregaEsquemaDocumento').hide();
			agregaFormatoControles('formaGenerica');
			$('#paramGuardaValoresDocGrid').html(data);
			$('#paramGuardaValoresDocGrid').show();
		} else {
			$('#agregaEsquemaDocumento').show();
			$('#paramGuardaValoresDocGrid').html(data);
			$('#paramGuardaValoresDocGrid').show();
		}
	});
}

//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

//Agregar nuevo esquema al grid
function agregaNuevoEsquema(){
	var numeroFila = consultaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	if(numeroFila == 0){
		tds += '<td><input type="text" id="puestoFacultado'		  +nuevaFila+'" name="lisPuestoFacultado"  		 path="lisPuestoFacultado" 		  size="10" value="" maxlength="11"  autocomplete="off" onkeyPress="listaPuestos(this.id)" onblur="validarPuestoFacultado(this.id)"/></td>';
		tds += '<td><input type="text" id="nombrePuestoFacultado' +nuevaFila+'" name="lisNombrePuestoFacultado"  path="lisNombrePuestoFacultado"  size="60" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true" /></td>';
		tds += '<td><input type="text" id="usuarioFacultadoID'	  +nuevaFila+'" name="lisUsuarioFacultadoID"	 path="lisUsuarioFacultadoID" 	  size="10" value="" maxlength="11"  autocomplete="off" onkeyPress="listaUsuariosRol(this.id)" onblur="validaUsuarioFacultado(this.id)"/></td>';
		tds += '<td><input type="text" id="nombreUsuarioFacultado'+nuevaFila+'" name="lisNombreUsuarioFacultado" path="lisNombreUsuarioFacultado" size="60" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true" /></td>';

	} else{
		tds += '<td><input type="text" id="puestoFacultado'		  +nuevaFila+'" name="lisPuestoFacultado"  		 path="lisPuestoFacultado" 		  size="10" value="" maxlength="11"	 autocomplete="off" onkeyPress="listaPuestos(this.id)" onblur="validarPuestoFacultado(this.id)"/></td>';
		tds += '<td><input type="text" id="nombrePuestoFacultado' +nuevaFila+'" name="lisNombrePuestoFacultado"  path="lisNombrePuestoFacultado"  size="60" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="usuarioFacultadoID'	  +nuevaFila+'" name="lisUsuarioFacultadoID" 	 path="lisUsuarioFacultadoID"     size="10" value="" maxlength="11"  autocomplete="off" onkeyPress="listaUsuariosRol(this.id)" onblur="validaUsuarioFacultado(this.id)"/></td>';
		tds += '<td><input type="text" id="nombreUsuarioFacultado'+nuevaFila+'" name="lisNombreUsuarioFacultado" path="lisNombreUsuarioFacultado" size="60" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true"/></td>';
	}
	tds += '<td><input type="button" name="agregaE" id="agregaE'+nuevaFila+'" value="" class="btnAgrega"  onclick="agregaNuevoEsquema()" />';
	tds += '<input type="button" name="elimina" id="'+nuevaFila+'" 		  value="" class="btnElimina" onclick="eliminarEsquema(this.id)" /></td>';
	tds += '</tr>';
	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	agregaEsquema();
	return false;

}

//consulta cuantas filas tiene el grid de documentos
function consultaFilasDocumentos(){
	var totales=0;
	$('tr[name=renglonDoc]').each(function() {
		totales++;
	});
	return totales;
}

//Agregar nuevo esquema al grid
function agregaNuevoEsquemaDoc(){
	var numeroFila = consultaFilasDocumentos();
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglonDoc' + nuevaFila + '" name="renglonDoc">';
	if(numeroFila == 0){
		tds += '<td><input type="text" id="documentoID'		+nuevaFila+'" name="listaDocumentoID"  		 path="listaDocumentoID" 	 size="18" value="" maxlength="20"  autocomplete="off" onkeyPress="listaDocumentos(this.id)" onblur="validarDocumento(this.id)"/></td>';
		tds += '<td><input type="text" id="nombreDocumento' +nuevaFila+'" name="listaNombreDocumento"  path="listaNombreDocumento"	 size="124" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true" /></td>';

	} else{
		tds += '<td><input type="text" id="documentoID'		+nuevaFila+'" name="listaDocumentoID"  		 path="listaDocumentoID" 	 size="18" value="" maxlength="20"	 autocomplete="off" onkeyPress="listaDocumentos(this.id)" onblur="validarDocumento(this.id)"/></td>';
		tds += '<td><input type="text" id="nombreDocumento'	+nuevaFila+'" name="listaNombreDocumento"  path="listaNombreDocumento"	 size="124" value="" maxlength="100" autocomplete="off" readOnly="true" disabled="true"/></td>';

	}
	tds += '<td><input type="button" name="agregaDoc" id="agregaDoc'+nuevaFila+'"   value="" class="btnAgrega" onclick="agregaNuevoEsquemaDoc()" />';
	tds += '<input type="button" name="eliminaDoc" id="eliminaDoc'+nuevaFila+'"  value="" class="btnElimina"  onclick="eliminarEsquemaDocumento(this.id)" /></td>';
	tds += '</tr>';
	document.getElementById("numeroDetalleDoc").value = nuevaFila;
	$("#tablaDocumentos").append(tds);
	agregaEsquema();
	return false;

}

function listaUsuariosRol(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaUsuarios.htm');
	});
}

function validaUsuarioFacultado(control) {
	var usuarioRol = eval("'#" + control + "'");
	var numUsuarioRol = $(usuarioRol).val();

	var nombreUsuarioRol = eval("'#nombreUsuarioFacultado" + control.substr(18) + "'");

	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuarioRol != '' && !isNaN(numUsuarioRol) && numUsuarioRol >0){
		var usuarioBeanCon = {
			'usuarioID':numUsuarioRol
		};
		usuarioServicio.consulta(listaGrid.consulta,usuarioBeanCon,function(usuario) {
			if(usuario!=null){
				switch(usuario.estatus){
					case "A":
						$(usuarioRol).val(usuario.usuarioID);
						$(nombreUsuarioRol).val(usuario.nombreCompleto);
						buscarPuesto(usuario.clavePuestoID, usuarioRol, nombreUsuarioRol);
						buscarEmpleado(usuario.usuarioID, usuarioRol, nombreUsuarioRol);
					break;
					case "B":
						mensajeSis('El Usuario Consultado está Bloqueado');
						$(nombreUsuarioRol).val('');
						$(usuarioRol).focus();
						break;
					case "C":
						mensajeSis('El Usuario Consultado está Cancelado o en Baja');
						$(nombreUsuarioRol).val('');
						$(usuarioRol).focus();
						break;
					default:
						$(nombreUsuarioRol).val('');
						$(usuarioRol).val('');
				}
			} else {
				mensajeSis("No Existe el Usuario.");
				$(nombreUsuarioRol).val('');
				$(usuarioRol).focus();
			}
		});
	}
	else {
		$(nombreUsuarioRol).val('');

	}
}

function listaPuestos(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		listaAlfanumerica(idControl, '2', '1',camposLista, parametrosLista,'listaPuestos.htm');
	});
}

function validarPuestoFacultado(control) {
	setTimeout("$('#cajaLista').hide();", 200);
	var puestoFacultado = eval("'#" + control + "'");
	var clavePuesto = $(puestoFacultado).val();
	var  expresionRegular = /^([%])*$/;
	var nombrePuestoFacultado = eval("'#nombrePuestoFacultado" + control.substr(15) + "'");
	esTab = true;

	if((!expresionRegular.test(clavePuesto)) && esTab && clavePuesto != ''){
		var puestosBeanCon = {
			'clavePuestoID':clavePuesto
		};

		puestosServicio.consulta(listaGrid.consulta,puestosBeanCon,function(puesto) {
			if(puesto != null){
				$(puestoFacultado).val(puesto.clavePuestoID);
				$(nombrePuestoFacultado).val(puesto.descripcion);
				buscarPuesto( puesto.clavePuestoID, puestoFacultado, nombrePuestoFacultado);
			} else {
				mensajeSis("No Existe el Puesto.");
				$(nombrePuestoFacultado).val('');
				$(puestoFacultado).focus();
			}
		});
	} else{
		$(nombrePuestoFacultado).val('');

	}
}

function listaDocumentos(idControl){
	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;
		listaAlfanumerica(idControl, '2', '3',camposLista, parametrosLista,'ListaTiposDocumentos.htm');
	});
}

function validarDocumento(control) {
	var evalDocumento = eval("'#" + control + "'");
	var numeroDocumento = $(evalDocumento).val();
	var nombreDocumento = eval("'#nombreDocumento" + control.substr(11) + "'");
	setTimeout("$('#cajaLista').hide();", 200);

	if(numeroDocumento != '' && numeroDocumento != 0 && !isNaN(numeroDocumento)){
		var documentoBean = {
			'tipoDocumentoID':numeroDocumento
		};
		tiposDocumentosServicio.consulta(3,documentoBean,function(tipoDocumento) {
			if(tipoDocumento != null){
				$(nombreDocumento).val(tipoDocumento.descripcion);
				buscarDocumento( numeroDocumento, evalDocumento, nombreDocumento);
			} else {
				mensajeSis("No Existe el Documento.");
				$(nombreDocumento).val('');
				$(evalDocumento).focus();
			}
		});
	} else{
		$(evalDocumento).val('');

	}
}

function eliminarEsquema(control){
	var contador = 0 ;
	var numeroID = control;
	var jqRenglon 	= eval("'#renglon" + numeroID + "'");
	var jqProd 		= eval("'#puestoFacultado" + numeroID + "'");
	var jqNombre 	= eval("'#nombrePuestoFacultado" + numeroID + "'");
	var jqAlter 	= eval("'#usuarioFacultadoID" + numeroID + "'");
	var jqFor 		= eval("'#nombreUsuarioFacultado" + numeroID + "'");
	var jqAgrega 	= eval("'#agregaE" + numeroID + "'");
	var jqElimina 	= eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqProd).remove();
	$(jqNombre).remove();
	$(jqAlter).remove();
	$(jqFor).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1  = eval("'#renglon" + numero + "'");
		var jqProd1 	= eval("'#puestoFacultado" + numero + "'");
		var jqNombre1 	= eval("'#nombrePuestoFacultado" + numero + "'");
		var jqAlter1 	= eval("'#usuarioFacultadoID" + numero + "'");
		var jqFor1		= eval("'#nombreUsuarioFacultado" + numero + "'");
		var jqAgrega1	= eval("'#agregaE" + numero + "'");
		var jqElimina1 	= eval("'#" + numero + "'");

		$(jqRenglon1).attr('id','renglon'+ contador);
		$(jqProd1).attr('id','puestoFacultado'+contador);
		$(jqNombre1).attr('id','nombrePuestoFacultado'+contador);
		$(jqAlter1).attr('id','usuarioFacultadoID'+contador);
		$(jqFor1).attr('id','nombreUsuarioFacultado'+contador);
		$(jqAgrega1).attr('id','agregaE'+contador);
		$(jqElimina1).attr('id',contador);
		contador = parseInt(contador + 1);
	});
}

function agregaEsquema(){
	var contador = 0 ;

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 	= eval("'#renglon" + numero + "'");
		var jqProd1 	= eval("'#puestoFacultado" + numero + "'");
		var jqNombre1 	= eval("'#nombrePuestoFacultado" + numero + "'");
		var jqAlter1 	= eval("'#usuarioFacultadoID" + numero + "'");
		var jqFor1 		= eval("'#nombreUsuarioFacultado" + numero + "'");
		var jqAgrega1 	= eval("'#agregaE" + numero + "'");
		var jqElimina1 	= eval("'#" + numero + "'");

		$(jqRenglon1).attr('id','renglon'+ contador);
		$(jqProd1).attr('id','puestoFacultado'+contador);
		$(jqNombre1).attr('id','nombrePuestoFacultado'+contador);
		$(jqAlter1).attr('id','usuarioFacultadoID'+contador);
		$(jqFor1).attr('id','nombreUsuarioFacultado'+contador);
		$(jqAgrega1).attr('id','agregaE'+contador);
		$(jqElimina1).attr('id',contador);
		contador = parseInt(contador + 1);
	});
}

function eliminarEsquemaDocumento(control){
	var contador = 0 ;
	var numeroID = control.substr(10,control.length);

	var jqRenglon 	= eval("'#renglonDoc" + numeroID + "'");
	var jqDocumento	= eval("'#documentoID" + numeroID + "'");
	var jqNombre 	= eval("'#nombreDocumento" + numeroID + "'");
	var jqAgrega 	= eval("'#agregaDoc" + numeroID + "'");
	var jqElimina 	= eval("'#eliminaDoc" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqDocumento).remove();
	$(jqNombre).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglonDoc]').each(function() {
		numero= this.id.substr(10,this.id.length);
		var jqRenglon1  = eval("'#renglonDoc" + numero + "'");
		var jqProd1 	= eval("'#documentoID" + numero + "'");
		var jqNombre1 	= eval("'#nombreDocumento" + numero + "'");
		var jqAgrega1	= eval("'#agregaDoc" + numero + "'");
		var jqElimina1 	= eval("'#eliminaDoc" + numero + "'");

		$(jqRenglon1).attr('id','renglonDoc'+ contador);
		$(jqProd1).attr('id','documentoID'+contador);
		$(jqNombre1).attr('id','nombreDocumento'+contador);
		$(jqAgrega1).attr('id','agregaDoc'+contador);
		$(jqElimina1).attr('id','eliminaDoc'+contador);
		contador = parseInt(contador + 1);
	});
}

function agregaNuevoEsquemaDocumento(){
	var contador = 0 ;

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglonDoc]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 	= eval("'#renglonDoc" + numero + "'");
		var jqDocumento1 = eval("'#documentoID" + numero + "'");
		var jqNombre1 	= eval("'#nombreDocumento" + numero + "'");
		var jqAgrega1 	= eval("'#agregaDoc" + numero + "'");
		var jqElimina1 	= eval("'#eliminaDoc" + numero + "'");

		$(jqRenglon1).attr('id','renglonDoc'+ contador);
		$(jqDocumento1).attr('id','documentoID'+contador);
		$(jqNombre1).attr('id','nombreDocumento'+contador);
		$(jqAgrega1).attr('id','agregaDoc'+contador);
		$(jqElimina1).attr('id','eliminaDoc'+contador);
		contador = parseInt(contador + 1);
	});
}

function buscarPuesto( valorBuscar, jControlID, jNombreControlID){

	//utilizamos esta variable solo de ayuda y mostrar que se encontro
	var existe = 0;

	//realizamos el recorrido solo por las celdas que contienen el código, que es la primera
	var numero = 0;
	var contador = 1;
	$('tr[name=renglon]').each(function() {

		//obtenemos el codigo de la celda a comparar
		numero= this.id.substr(7,this.id.length);
		var puestoFacultado = eval("'#puestoFacultado" + numero + "'");
		var clavePuesto  	=  $(puestoFacultado).val();

		//comparamos para ver si el código es igual a la busqueda para todas las filas excepto la consultada
		if(puestoFacultado != jControlID){
			if(clavePuesto == valorBuscar){
				existe = existe + 1;
			}
		}
		contador = parseInt(contador + 1);
	});

	//si se encontra resultado mostramos que existe.
	if(existe > 0){
		mensajeSis("El puesto ya se encuentra parametrizado.");
		$(jNombreControlID).val('');
		$(jControlID).focus();
	}
}

function buscarEmpleado( valorBuscar, jControlID, jNombreControlID){

	//utilizamos esta variable solo de ayuda y mostrar que se encontro
	var existe = 0;

	//realizamos el recorrido solo por las celdas que contienen el código, que es la primera
	var numero = 0;
	var contador = 1;
	$('tr[name=renglon]').each(function() {

		//obtenemos el codigo de la celda a comparar
		numero= this.id.substr(7,this.id.length);
		var usuarioFacultado = eval("'#usuarioFacultadoID" + numero + "'");
		var usuarioID  	 =  $(usuarioFacultado).val();

		//comparamos para ver si el código es igual a la busqueda para todas las filas excepto la consultada
		if(usuarioFacultado != jControlID){
			if(usuarioID == valorBuscar){
				existe = existe + 1;
			}
		}
		contador = parseInt(contador + 1);
	});

	//si se encontra resultado mostramos que existe.
	if(existe > 0){
		mensajeSis("El usuario ya se encuentra parametrizado.");
		$(jNombreControlID).val('');
		$(jControlID).focus();
	}
}

function buscarDocumento( valorBuscar, jControlID, jNombreControlID){

	//utilizamos esta variable solo de ayuda y mostrar que se encontro
	var existe = 0;

	//realizamos el recorrido solo por las celdas que contienen el código, que es la primera
	var numero = 0;
	var contador = 1;
	$('tr[name=renglonDoc]').each(function() {

		numero = this.id.substr(10,this.id.length);
		var tipoDocumentoID = eval("'#documentoID" + numero + "'");
		var numeroDocumento  	=  $(tipoDocumentoID).val();

		//comparamos para ver si el código es igual a la busqueda para todas las filas excepto la consultada
		if(tipoDocumentoID != jControlID){
			if(numeroDocumento == valorBuscar){
				existe = existe + 1;
			}
		}
		contador = parseInt(contador + 1);
	});

	//si se encontra resultado mostramos que existe.
	if(existe > 0){
		mensajeSis("El Documento ya se encuentra parametrizado.");
		$(jNombreControlID).val('');
		$(jControlID).focus();
	}
}

function funcionError(){
}

function funcionExito(){
	$('#usuarioAdmon').val('');
	$('#nombreUsuarioAdmon').val('');
	$('#correoRemitente').val('');
	$('#nombreEmpresa').val('');
	$('#servidorCorreo').val('');
	$('#puerto').val('');
	$('#usuarioServidor').val('');
	$('#contrasenia').val('');
	$('#paramGuardaValoresGrid').hide();
	$('#paramGuardaValoresGrid').html("");
	$('#paramGuardaValoresDocGrid').hide();
	$('#paramGuardaValoresDocGrid').html("");
	$('#agregaEsquema').hide();
	$('agregaNuevoEsquemaDocumento').hide();
}

function verificarVacioDocumento(){
	var validacion = 0;
	var numeroItereciones = $('input[name=listaDocumentoID]').length;
	if(numeroItereciones == 0){
		validacion = 1;
		return validacion;
	}

	for(var iteracion = 1; iteracion <= numeroItereciones; iteracion++){

		var listaOrigenDocumento  = document.getElementById("documentoID"+iteracion+"").value;

		if(listaOrigenDocumento == ""){
			document.getElementById("documentoID"+iteracion+"").focus();
			$(listaOrigenDocumento).addClass("error");
			validacion = 1;
			return validacion;
		}

	}
	return validacion;
}

function verificarVacioFacultado(){
	var validacion = 0;
	var numeroItereciones = $('input[name=lisPuestoFacultado]').length;
	if(numeroItereciones == 0){
		validacion = 1;
		return validacion;
	}

	for(var iteracion = 1; iteracion <= numeroItereciones; iteracion++){

		var puestoFacultado  = document.getElementById("puestoFacultado"+iteracion+"").value;
		var lisUsuarioFacultadoID  = document.getElementById("usuarioFacultadoID"+iteracion+"").value;

		if(puestoFacultado == "" && lisUsuarioFacultadoID == ""){
			document.getElementById("puestoFacultado"+iteracion+"").focus();
			validacion = 1;
			return validacion;
		}

	}
	return validacion;
}