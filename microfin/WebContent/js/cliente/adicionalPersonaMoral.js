esTab = true;

var selectTipoIdenti = '';
var selectNacion = '';
var selectDocEstancia = '';
var numCteRelacionado = '';

var esMenorEdad = '';
//Definicion de Constantes y Enums
var catTipoTransaccionCtaPer = {
	'agrega' : '1',
	'modifica' : '2',
	'elimina' : '3'
};


var catTipoConsultaDirCliente = {
	'principal' : 1,
	'foranea' : 2,
	'oficialDirec' : 3,
	'oficial' : 4,
	'verOficial' : 5
};

var catTipoConsultaSociedad = {
	'principal' : 1,
	'foranea' : 2
};

expedienteBean = {
	'clienteID' : 0,
	'tiempo' : 0,
	'fechaExpediente' : '1900-01-01',
};
listaPersBloqBean = {
	'estaBloqueado' : 'N',
	'coincidencia' : 0
};

var esCliente = 'CTE';
var esAval = 'AVA';
var esGarante = 'GRT';
var catTipoConsultaCargo = {
	'principal' : 1
};
var catTipoPersonaJuridica = {
	'fisica' : 'F',
	'conActividad' : 'A',
	'moral' : 'M',
};

$(document).ready(function() {
	$("#numCliente").focus();
	deshabilitaControl('titulo');

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
	agregaFormatoControles('formaGenerica');
	mostrarCamposTipoAccionesta('I');
	consultaTipoIden();
	ocultaIngresosRealoRecursos();
	$('#infoAccionista').hide();
	$('#sucursalID').val(parametroBean.sucursal);
	$('#nombreSucursal').val(parametroBean.nombreSucursal);

	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc', 'generar', 3);

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({

		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'directivoID', 'exitoTransCuenta', 'falloTransCuenta');

		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	//	Datos de la Cuenta

	$('#numCliente').blur(function() {

		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			mostrarCamposTipoAccionesta('N');
			if (isNaN($('#numCliente').val())) {
				$('#numCliente').val("");
				$('#numCliente').focus();
				$('#nombreCliente').val("");
				esTab = false;

			} else {

				setTimeout("$('#cajaLista').hide();", 200);
				var numeroCliente = $('#numCliente').val();
				consultaClientePrincipal(numeroCliente, 'consultaClienteRel', 'numCliente');

			}
		}
	});

	$('#numCliente').bind('keyup', function(e) {
		lista('numCliente', '2', '38', 'nombreCompleto', $('#numCliente').val(), 'listaCliente.htm');

	});

	$('#numEscPub').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
	
		camposLista[0] = "clienteID";
		camposLista[1] = "esc_Tipo";
		
	
		parametrosLista[0] = $('#numCliente').val();
		parametrosLista[1] = $('#numEscPub').val();
		
	
	lista('numEscPub', '0', '2', camposLista,parametrosLista, 'listaEscrituraPub.htm');  

	});
	$('#garanteID').blur(function() {

		if (isNaN($('#garanteID').val())) {
			$('#garanteID').val("");
			$('#garanteID').focus();
			$('#garanteID').val("");
			esTab = false;

		} else {

			setTimeout("$('#cajaLista').hide();", 200);
			esTab=true;
			consultaGarante(this.id);
			$('#numCliente').val("");
			$('#nombreCliente').val("");
			$('#avalID').val("");
			$('#nombreAval').val("");

		}
	});

	$('#garanteID').bind('keyup',function(e) {
		lista('garanteID', '1', '6', 'nombreCompleto', $('#garanteID').val(), 'listaGarantes.htm');
	});


	$('#garanteRelacion').blur(function() {
		if (isNaN($('#garanteRelacion').val())) {
			$('#garanteRelacion').val("");
			$('#garanteRelacion').focus();
			$('#nombreGaranteRel').val("");
			esTab = false;

		} else {

			setTimeout("$('#cajaLista').hide();", 200);
			var numeroGarante = $('#garanteRelacion').val();
			esTab=true;

			consultaGaranteFisica(numeroGarante);
		}
	});

	$('#garanteRelacion').bind('keyup',function(e) {
		lista('garanteRelacion', '1', '2', 'nombreCompleto', $('#garanteRelacion').val(), 'listaGarantes.htm');
	});

	$('#avalID').blur(function() {
		esTab=true;
		consultaAval(this.id);
		$('#numCliente').val("");
		$('#nombreCliente').val("");
		$('#nombreGarante').val("");
		$('#garanteID').val("");

	});
	$('#avalID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCompleto";
			parametrosLista[0] = $('#avalID').val();
			lista('avalID', '1', '6', camposLista, parametrosLista, 'listaAvales.htm');
		}
	});
	$('#avalRelacion').blur(function() {
		if (isNaN($('#avalRelacion').val())) {
			$('#avalRelacion').val("");
			$('#avalRelacion').focus();
			$('#avalRelacion').val("");

			esTab = false;

		} else {
			setTimeout("$('#cajaLista').hide();", 200);
			var numeroCliente = $('#avalRelacion').val();
			esTab=true;
			if (numeroCliente != '' && numeroCliente != '0' && !isNaN(numeroCliente)) {
				listaPersBloqBean = consultaListaPersBloq(numeroCliente, esAval, 0, 0);
				if (listaPersBloqBean.estaBloqueado != 'S') {
					consultaAvalFisica(numeroCliente);
					desactivarRadiosOcultaDivs();
					ocultaIngresosRealoRecursos();
					deshabilitaBoton('elimina', 'submit');
					limpiaPorcentaje();
				}else{
					mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
					validaLimpiarFormulario('A');
					$('#avalRelacion').focus();
				}
			}
		}
	});



	$('#avalRelacion').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCompleto";
			parametrosLista[0] = $('#avalRelacion').val();
			lista('avalRelacion', '1', '5', camposLista, parametrosLista, 'listaAvales.htm');
		}
	});
	$('#directivoID').blur(function() {
		if (esTab == true) {
			validaDirectivo(this.id);
			esMenorEdad = '';
		}
	});

	$('#directivoID').bind('keyup', function(e) {

		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "numCliente";
		camposLista[1] = "garanteID";
		camposLista[2] = "avalID";
		camposLista[3] = "nombreDirectivo";
		parametrosLista[0] = $('#numCliente').val();
		parametrosLista[1] = $('#garanteID').val();
		parametrosLista[2] = $('#avalID').val();
		parametrosLista[3] = $('#directivoID').val();

		lista('directivoID', '2', '1', camposLista, parametrosLista, 'listaAdicionalPersonaMoral.htm');
	});

	$('#numeroCte').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('numeroCte', '2', '1', 'nombreCompleto', $('#numeroCte').val(), 'listaCliente.htm');
		}
	});

	$('#numeroCte').blur(function() {

		if (isNaN($('#numeroCte').val())) {
			$('#numeroCte').val("");
			$('#numeroCte').focus();
			$('#nombreCompleto').val("");
			esTab = false;
		} else {
			
			if (Number($('#numeroCte').val()) > 0 && Number($('#directivoID').val()) == 0) { //Alta con cliente
				listaPersBloqBean = consultaListaPersBloq($('#numeroCte').val(), esCliente, 0, 0);
				if (listaPersBloqBean.estaBloqueado != 'S') {
				$('#directivoID').val("0");
				consultaCliente($('#numeroCte').val(), 'alta', '');
				consultaDireccionOficial('numeroCte');
				desactivarRadiosOcultaDivs();
				ocultaIngresosRealoRecursos();
				deshabilitaBoton('elimina', 'submit');
				limpiaPorcentaje();
				}else{
					mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
					validaLimpiarFormulario('C');
					$('#numeroCte').val('');
					$('#numeroCte').focus();
				}
			} else {
				if ($('#directivoID').asNumber() > 0) { // Modifica
					if (Number($('#numeroCte').val()) > 0) {
						if ($('#numeroCte').asNumber() != Number(numCteRelacionado)) { // se esta cambiando el cliente ya relacionado por otro cliente
							consultaCliente($('#numeroCte').val(), 'modificaOtroCte', '');
						} else if ($('#numeroCte').asNumber() == Number(numCteRelacionado)) { //se esta modificando informacion del mismo cliente ya relacionado
							validaDirectivo('directivoID');
						}
					} else { // Se modifica el cliente Relacionado por una persona NO cliente
						if (numCteRelacionado != -1) { /* numCteRelacionado == -1  Significa que la persona Relacionada consultada no es un
																								cliente (No inicializar Forma).*/
							inicializaForma('personasRelacionadas', 'directivoID');
							limpiaCombos();// se inicializa la forma SOLO SI se desea cambiar el cliente relacionado por un NO cliente
							habilitaFormularioCuentaPersona(); // habilitamos Los campos para ingresar los datos de uan persona
							$('#nombreCompleto').val('');
						}
					}
				} else {
					validaLimpiarFormulario('C');
				}
			}
		}

	});

	$('#cargoID').bind('keyup', function(e) {
		lista('cargoID', '2', '1', 'descripcionCargo', $('#cargoID').val(), 'listaCargos.htm');
	});

	$('#cargoID').blur(function() {
		validaCargo(this.id);
	});

	//	Tipo de Persona
	$(':checkbox').change(function() {
		tipoPersonaSeleccionadaCheck(); // checamos Tipo de Personas seleccionadas
	});

	//	Datos Generales de la Persona
	$('#paisCompania').blur(function() {
		consultaPais(this.id, true);
	});

	$('#paisNacimiento').blur(function() {
		if (!estaDeshabilitado(this.id)) {
			consultaPais(this.id, true);
			if ($('#paisNacimiento').val() == '700') {
				$('#nacion').val('N');
				selectNacion = 'N';
				$('tr[name=extranjero]').hide(500);
				$('#paisResidencia').val(700);
				$('#paisR').val('MEXICO (PAIS)');
				habilitaControl('edoNacimiento');
				$('#edoNacimiento').focus();
			} else if ($('#paisNacimiento').val() != '700' && $('#paisNacimiento').val() != '') {
				$('#nacion').val('E');
				selectNacion = 'E';
				$('tr[name=extranjero]').show(500);
			}
		}
	});

	$('#fechaNacimiento').change(function() {
		$('#fechaNacimiento').focus();
		$('#fechaNacimiento').select();
		calculaEdad($('#fechaNacimiento').val());

	});

	$('#paisNacimiento').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('paisNacimiento', '2', '1', 'nombre', $('#paisNacimiento').val(), 'listaPaises.htm');
		}
	});

	$('#paisCompania').bind('keyup', function(e) {
		lista('paisCompania', '2', '1', 'nombre', $('#paisCompania').val(), 'listaPaises.htm');
	});

	$('#edoNacimiento').bind('keyup', function(e) {
		lista('edoNacimiento', '2', '1', 'nombre', $('#edoNacimiento').val(), 'listaEstados.htm');

	});

	$('#edoNacimiento').blur(function() {
		consultaEstadoDatosP(this.id);
	});

	$('#munNacimiento').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#edoNacimiento').val();
		parametrosLista[1] = $('#munNacimiento').val();

		lista('munNacimiento', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});






	/************* DATOS DE DIRECCIÓN *************/
	$('#paisIDDom').val('700');
	consultaPaisDir();

	$('#paisIDDom').bind('keyup', function(e) {
		lista('paisIDDom', '2', '1', 'nombre', $('#paisIDDom').val(), 'listaPaises.htm');
	});

	$('#paisIDDom').blur(function() {
		var pais = $('#paisIDDom').val();
		if(!/^[0-9]+$/.test(pais) && esTab) {

			setTimeout(function() {
				$('#paisIDDom').focus();
				$('#paisIDDom').val('');
				mensajeSis('Ingresar un ID de País de Tipo Numérico');
			}, 300);
		} else {
			consultaPaisDir();

			if(esTab && $('#paisIDDom').val() != '700') {
				$('#estadoIDDom').val('0');
				$('#municipioIDDom').val('0');
				$('#localidadIDDom').val('0');
				$('#coloniaIDDom').val('0');

				consultaEdoDir();
				consultaMunDom();
				consultaLocalidadDom();
				consultaColoniaDom();

				$('#estadoIDDom').attr('disabled', true);
				$('#municipioIDDom').attr('disabled', true);
				$('#localidadIDDom').attr('disabled', true);
				$('#coloniaIDDom').attr('disabled', true);
				$('#codigoPostalDom').removeAttr('disabled');

				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
			} else {
				$('#estadoIDDom').removeAttr('disabled');
				$('#estadoIDDom').focus();
				$('#municipioIDDom').removeAttr('disabled');
				$('#localidadIDDom').removeAttr('disabled');
				$('#coloniaIDDom').removeAttr('disabled');

				$('#estadoIDDom').val('');
				$('#nombreEdoNacimiento').val('');
				$('#municipioIDDom').val('');
				$('#nombreMunicipio').val('');
				$('#localidadIDDom').val('');
				$('#nombreLocalidad').val('');
				$('#coloniaIDDom').val('');
				$('#nombreColonia').val('');
				$('#nombreCiudadDom').val('');

				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
			}
		}
	});

	$('#estadoIDDom').bind('keyup', function(e) {
		lista('estadoIDDom', '2', '1', 'nombre', $('#estadoIDDom').val(), 'listaEstados.htm');
	});

	$('#estadoIDDom').blur(function() {
		var edo = $('#estadoIDDom').val();

		if(!/^[0-9]+$/.test(edo) && esTab) {
			setTimeout(function() {
				$('#estadoIDDom').focus();
				$('#estadoIDDom').val('');
				mensajeSis('Ingresar un ID de Estado de Tipo Numérico');
			}, 300);
		} else {
			if(esTab) {
				$('#municipioIDDom').val('');
				$('#nombreMunicipio').val('');
				$('#localidadIDDom').val('');
				$('#nombreLocalidad').val('');
				$('#coloniaIDDom').val('');
				$('#nombreColonia').val('');
				$('#nombreCiudadDom').val('');

				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
				consultaEdoDir();
			}
		}
	});

	$('#municipioIDDom').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoIDDom').val();
		parametrosLista[1] = $('#municipioIDDom').val();
		lista('municipioIDDom', '2', '1', camposLista, parametrosLista, 'listaMunicipios.htm');
	});

	$('#municipioIDDom').blur(function() {
		var municipio = $('#municipioIDDom').val();

		if(!/^[0-9]+$/.test(municipio) && esTab) {
			setTimeout(function() {
				$('#municipioIDDom').focus();
				$('#municipioIDDom').val('');
				mensajeSis('Ingresar un ID de Municipio de Tipo Numérico');
			}, 300);
		} else {
			if(esTab) {
				$('#localidadIDDom').val('');
				$('#nombreLocalidad').val('');
				$('#coloniaIDDom').val('');
				$('#nombreColonia').val('');
				$('#nombreCiudadDom').val('');

				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
				consultaMunDom();
			}
		}
	});

	$('#localidadIDDom').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";


		parametrosLista[0] = $('#estadoIDDom').val();
		parametrosLista[1] = $('#municipioIDDom').val();
		parametrosLista[2] = $('#localidadIDDom').val();

		lista('localidadIDDom', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});

	$('#localidadIDDom').blur(function() {
		var localidad = $('#localidadIDDom').val();

		if(!/^[0-9]+$/.test(localidad) && esTab) {
			setTimeout(function() {
				$('#localidadIDDom').focus();
				$('#localidadIDDom').val('');
				mensajeSis('Ingresar un ID de Localidad de Tipo Numérico');
			}, 300);
		} else {
			if(esTab) {
				$('#coloniaIDDom').val('');
				$('#nombreColonia').val('');

				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
				consultaLocalidadDom();
			}
		}
	});

	$('#coloniaIDDom').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";

		parametrosLista[0] = $('#estadoIDDom').val();
		parametrosLista[1] = $('#municipioIDDom').val();
		parametrosLista[2] = $('#coloniaIDDom').val();

		lista('coloniaIDDom', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});

	$('#coloniaIDDom').blur(function() {
		var colonia = $('#coloniaIDDom').val();

		if(!/^[0-9]+$/.test(colonia) && esTab) {
			setTimeout(function() {
				$('#coloniaIDDom').focus();
				$('#coloniaIDDom').val('');
				mensajeSis('Ingresar un ID de Colonia de Tipo Numérico');
			}, 300);
		} else {
			if(esTab) {
				$('#calleDom').val('');
				$('#numExteriorDom').val('');
				$('#numInteriorDom').val('');
				$('#pisoDom').val('');
				$('#primeraEntreDom').val('');
				$('#segundaEntreDom').val('');
				$('#codigoPostalDom').val('');
				$('#domicilioCompleto').val('');
				consultaColoniaDom();
			}
		}
	});

	$('#numInteriorDom, #pisoDom').blur(function() {
		if($('#numInteriorDom').val() == '') $('#numInteriorDom').val('0');
		if($('#pisoDom').val() == '') $('#pisoDom').val('0');
	});

	$('#codigoPostalDom').blur(function() {
		var cp = $('#codigoPostalDom').val();

		if(!/^[0-9]+$/.test(cp) && esTab) {
			$('#codigoPostalDom').val('');
			$('#codigoPostalDom').focus();
			mensajeSis('El Código Postal Debe ser de Tipo Numérico');
		}
	});

	$('#domicilioCompleto').focus(function() {
		funcionArmarDomicilio();
	});

	function limpiacampos() {
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');
		$('#nombrePaisNac').val('');

		$('#calleDom').val('');
		$('#numExteriorDom').val('');
		$('#nombreColonia').val('');
		$('#codigoPostalDom').val('');
		$('#nombreLocalidad').val('');
		$('#nombreMunicipio').val('');
		$('#nombreEdoNacimiento').val('');
		$('#nombrePaisNac').val('');
		$('#domicilioCompleto').val('');
	}

	function funcionArmarDomicilio() {
		var calle 	  = $('#calleDom').val();
		var num		  = $('#numExteriorDom').val();
		var colonia	  = $('#nombreColonia').val();
		var cp		  = $('#codigoPostalDom').val();
		var localidad = $('#nombreLocalidad').val();
		var municipio = $('#nombreMunicipio').val();
		var estado	  = $('#nombreEdoNacimiento').val();
		var pais	  = $('#nombrePaisNac').val();

		var domicilio = calle + ', ' + num + ', ' + colonia + ', ' + cp + ', ' + localidad +
						', ' + municipio + ', ' + estado + ', ' + pais;

		$('#domicilioCompleto').val(domicilio);
	}

	function consultaPaisDir() {
		var conPais = 2;
		var numPais = $('#paisIDDom').val();

		if(numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais, function(pais) {
				if(pais != null) $('#nombrePaisNac').val(pais.nombre);
				else {
					mensajeSis('No Existe el País.');
					$('#paisIDDom').val('');
					$('#paisIDDom').focus();
				}
			});
		} else {
			$('#paisIDDom').val('');
		}
	}

	function consultaEdoDir() {
		var tipConForanea = 2;
		var numEstado = $('#estadoIDDom').val();

		if(numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea, numEstado, function(estado) {
				if(estado != null) $('#nombreEdoNacimiento').val(estado.nombre);
				else {
					mensajeSis('No Existe el Estado');
					$('#estadoIDDom').val('');
					$('#estadoIDDom').focus();
				}
			});
		}
	}

	function consultaMunDom() {
		var munID = $('#municipioIDDom').val();
		var numEstado = $('#estadoIDDom').val();
		var tipConForanea = 2;

		if (munID != '' && !isNaN(munID)) {
			municipiosServicio.consulta(tipConForanea, numEstado, munID, {async: false, callback: function(municipio) {
				if(municipio != null) $('#nombreMunicipio').val(municipio.nombre);
				else {
					mensajeSis("No Existe el Municipio");
					$('#municipioIDDom').val('');
					$('#municipioIDDom').focus();
				}
			}});
		}
	}

	function consultaLocalidadDom() {
		var numlocalidad = $('#localidadIDDom').val();
		var numMunicipio =	$('#municipioIDDom').val();
		var numEstado =  $('#estadoIDDom').val();
		var tipConPrincipal = 1;

		if(numlocalidad != '' && !isNaN(numlocalidad)){
			if(numEstado != '' && numMunicipio !=''){
				localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numlocalidad,{ async: false, callback: function(localidad) {
					if(localidad!=null){
						$('#nombreLocalidad').val(localidad.nombreLocalidad);
						$('#nombreCiudadDom').val(localidad.nombreLocalidad);
						$('#nombreCiudadDom').attr('disabled', true);
					}else{
						mensajeSis("No Existe la Localidad");
						$('#nombreLocalidad').val("");
						$('#localidadIDDom').val("");
						$('#localidadIDDom').focus();
						$('#nombreCiudadDom').removeAttr('disabled');
					}
				}});
			}else{
				$('#nombreCiudadDom').removeAttr('disabled');
				if(numEstado == ''){
					mensajeSis("Especificar Estado");
					$('#estadoIDDom').focus();
				}else{
					mensajeSis("Especificar Municipio");
					$('#municipioIDDom').focus();
				}
			}

		}
	}

	function consultaColoniaDom() {
		var numColonia= $('#coloniaIDDom').val();
		var numEstado =  $('#estadoIDDom').val();
		var numMunicipio =	$('#municipioIDDom').val();
		var tipConPrincipal = 1;

		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
				if(colonia!=null){
					$('#nombreColonia').val(colonia.asentamiento);
					$('#codigoPostalDom').val(colonia.codigoPostal);
					$('#codigoPostalDom').attr('disabled', true);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaIDDom').val("");
					$('#coloniaIDDom').focus();
					$('#codigoPostalDom').removeAttr('disabled');
				}
			}});
		} else {
			$('#nombreColonia').val('');
			$('#codigoPostalDom').removeAttr('disabled');
		}
	}


	$('#locNacimiento').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";


		parametrosLista[0] = $('#edoNacimiento').val();
		parametrosLista[1] = $('#munNacimiento').val();
		parametrosLista[2] = $('#locNacimiento').val();

		lista('locNacimiento', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});

	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";

		parametrosLista[0] = $('#edoNacimiento').val();
		parametrosLista[1] = $('#munNacimiento').val();
		parametrosLista[2] = $('#coloniaID').val();

		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});

	$('#munNacimiento').blur(function() {
  		consultaMunicipio(this.id);
	});

	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
	});

	$('#locNacimiento').blur(function() {
		consultaLocalidad(this.id);
	});

	$('#generar').click(function() {
		if ($('#fechaNacimiento').val() != '') {
			formaRFC();
			$('#RFC').select();
			$('#RFC').focus();
		} else {
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val() != '') {
			formaCURP();
			$('#CURP').select();
			$('#CURPC').focus();
		} else {
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	$('#paisRFC').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('paisRFC', '2', '1', 'nombre', $('#paisRFC').val(), 'listaPaises.htm');
		}
	});

	$('#paisRFC').blur(function() {
		consultaPais(this.id, true);
	});

	$('#ocupacionID').bind('keyup', function(e) {
		lista('ocupacionID', '1', '1', 'descripcion', $('#ocupacionID').val(), 'listaOcupaciones.htm');
	});

	$('#ocupacionID').blur(function() {
		consultaOcupacion(this.id);
	});
	//	Actividad
	$('#sectorGeneral').blur(function() {
		consultaSecGeneral(this.id);
	});

	$('#sectorGeneral').bind('keyup', function(e) {
		lista('sectorGeneral', '2', '1', 'descripcion', $('#sectorGeneral').val(), 'listaSectores.htm');
	});

	$('#actividadBancoMX').bind('keyup', function(e) {
		if (this.value.length >= 3) {
			lista('actividadBancoMX', '4', '1', 'descripcion', $('#actividadBancoMX').val(), 'listaActividades.htm');
		}
	});

	$('#actividadBancoMX').blur(function() {
		consultaActividadBMX(this.id);
	});

	//	Identificación
	$('#fecExIden').change(function() {
		$('#fecExIden').focus().select();
		if ($('#fecExIden').val() > parametroBean.fechaAplicacion) {
			mensajeSis('La Fecha Capturada es Mayor a la del Sistema');
			$('#fecExIden').val('');
			$('#fecExIden').focus();
		}
	});
	$('#fecVenIden').change(function() {
		$('#fecVenIden').focus().select();
	});
	$('#paisFea').bind('keyup', function(e) {
		lista('paisFea', '1', '1', 'nombre', $('#paisFea').val(), 'listaPaises.htm');
	});

	$('#paisFea').blur(function() {
		consultaPais(this.id, true);
	});

	$('#paisFeaPM').bind('keyup', function(e) {
		lista('paisFeaPM', '1', '1', 'nombre', $('#paisFeaPM').val(), 'listaPaises.htm');
	});

	$('#paisFeaPM').blur(function() {
		consultaPais(this.id, true);
	});

	$('#tipoIdentiID').change(function() {
		var numIden = $('#tipoIdentiID option:selected').val();

		if (numIden != '-1') {
			consultaNumeroCaracteresTipoIdent($('#tipoIdentiID').val());
		} else {
			limpiaFormaCompleta('formaGenerica', true, ['numCliente', 'nombreCliente','avalID','garanteID','nombreGarante',
			                                            'nombreAval', 'sucursalID', 'nombreSucursal', 'directivoID','consejoAdmon','avalRelacion',
			                                            'esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
			                                            'esSolicitante', 'esAutorizador', 'esAdministrador']);
			$('#tipoIdentiID').val('-1');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
			mensajeSis("No Existe la Identificación del Cliente");

		}

	});

	//	Nacionalidad
	$('#nacion').change(function() {
		var nacion = $('#nacion option:selected').val();
		if (nacion != '') {
			validaNacionalidadCte();
		} else {
			mensajeSis("Selecciona una Nacionalidad");
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
		}
	});

	$('#paisResidencia').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('paisResidencia', '2', '1', 'nombre', $('#paisResidencia').val(), 'listaPaises.htm');
		}
	});

	$('#paisResidencia').blur(function() {
		consultaPais(this.id, true);
	});
	$('#docEstanciaLegal').change(function() {
		if (selectDocEstancia != null) {
			$('#docEstanciaLegal').val(selectDocEstancia).selected = true;
		}
	});
	$('#docEstanciaLegal').blur(function() {
		if (selectDocEstancia != '') {
			$('#docEstanciaLegal').val(selectDocEstancia).selected = true;
		}
	});
	$('#fechaVenEst').change(function() {
		$('#fechaVenEst').focus().select();
	});
	//   	Escritura
	$('#numEscPub').blur(function() {
		if($('#numeroCte').val() != 0) {
			consultaEscritura(this.id);
			consultaNotaria('notariaID');
		}
	});

	$('#fechaEscPub').change(function() {
		$('#fechaEscPub').focus().select();
	});

	$('#estadoID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		}
	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
		$('#municipioID').val('');
		$('#nombreMuni').val('');
		$('#notariaID').val('');
		$('#titularNotaria').val('');
		$('#direccion').val('');
	});

	$('#municipioID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";

		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista, 'listaMunicipios.htm');
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
		$('#notariaID').val('');
		$('#titularNotaria').val('');
		$('#direccion').val('');
	});

	$('#notariaID').bind('keyup', function(e) {

		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "municipioID";
		camposLista[2] = "titular";

		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#notariaID').val();

		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
			if($('#municipioID').val()!='' && $('#municipioID').asNumber()>0){
				lista('notariaID', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
			}else{
				if($('#notariaID').val().length >= 3){
					$('#municipioID').focus();
					$('#notariaID').val('');
					$('#titularNotaria').val('');
					mensajeSis('Especificar Municipio');
				}
			}
		}else{
			if($('#notariaID').val().length >= 3){
				$('#estadoID').focus();
				$('#notariaID').val('');
				$('#titularNotaria').val('');
				mensajeSis('Especificar Estado');
			}

		}

	});

	$('#notariaID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#notariaID').val() 	!= 	'' &&	$('#notariaID').val() > 0	&&	!isNaN($('#notariaID').val())){
			if($('#estadoID').val()!=''  ){
				if($('#municipioID').val() !=''){
					consultaNotaria(this.id);
				}else{
					$('#titularNotaria').val('');
					$('#notariaID').val('');
					mensajeSis("Elija un Municipio  antes de buscar Notaria");
				}
			}else{
				$('#titularNotaria').val('');
				$('#notariaID').val('');
				mensajeSis("Elija un Estado  antes de buscar Notaria");
			}
		}else{
			$('#titularNotaria').val('');
			$('#notariaID').val('');
		}

	});

	//Relación
	$('#parentescoID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('parentescoID', '2', '1', 'descripcion', $('#parentescoID').val(), 'listaParentescos.htm');
		}
	});

	$('#parentescoID').blur(function() {
		consultaParentesco(this.id, '');
	});

	//Botones de submit
	$('#agrega').click(function() {

		if ($('#esAccionista').attr('checked') && $("#tipoAccionista option:selected").val() == 'M' ) {
			completaCampoEnvio();
		}
		funcionArmarDomicilio();
		$('#tipoTransaccion').val(catTipoTransaccionCtaPer.agrega);


	});

	$('#modifica').click(function() {
		if ($('#esAccionista').attr('checked') && $("#tipoAccionista option:selected").val() == 'M' ) {
			completaCampoEnvio();
		}
		funcionArmarDomicilio();
		$('#tipoTransaccion').val(catTipoTransaccionCtaPer.modifica);

	});

	$('#esProvRecurso').click(function() {
		ocultaIngresosRealoRecursos();
		$('#ingreRealoRecursos').val('');
	});
	$('#esPropReal').click(function() {
		$('#esPropReal').val('S');
		ocultaIngresosRealoRecursos();
		$('#ingreRealoRecursos').val('');
	});

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#elimina').attr('tipoTransaccion', '3');

	$('#telefonoCasa').setMask('phone-us');
	$('#telefonoCelular').setMask('phone-us');
	$('#telefonoCompania').setMask('phone-us');
	$('#telefonoPM').setMask('phone-us');

	$("#extTelefonoPart").blur(function() {
		if (this.value != '') {
			if ($("#telefonoCasa").val() == '') {
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío");
				$("#telefonoCasa").focus();
			}
		}
	});
	$("#telefonoCasa").blur(function() {
		if (this.value == '') {
			$('#extTelefonoPart').val('');
		}
	});

	$('#tipoAccionista').blur(function() {
		var con_moral = 'M';
		var var_tipoAccionista = $("#tipoAccionista option:selected").val();

		if(var_tipoAccionista == con_moral){
			mostrarCamposTipoAccionesta('S');
		} else {
			mostrarCamposTipoAccionesta('N');
		}
	});

	$('#tipoAccionista').change(function() {
		var con_moral = 'M';
		var var_tipoAccionista = $("#tipoAccionista option:selected").val();

		if(var_tipoAccionista == con_moral){
			mostrarCamposTipoAccionesta('S');
		} else {
			mostrarCamposTipoAccionesta('N');
		}
	});


	$('#porcentajeAccion').blur(function() {
		if (esTab) {
			validarPorcentaje(this.id, this.value);
		}
		asignaPorcentaje(this.id, this.value);
	});


	$('#valorAcciones').blur(function(){
		validaValorAcciones();
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

	rules : {


	   	numCliente: {
			required : function() {
				if (($('#numCliente').val() == ' ') && ($('#avalID').val() == ' ') && ($('#garanteID').val() == '') ) {
					return true;
				} else {
					return false;
				}
		   }
	    },
		numeroCte : {
			required : function() {
				if (($('#numeroCte').val() == ' ') && ($('#avalRelacion').val() == ' ') && ($('#garanteRelacion').val() == ' ' )) {
					return true;
			    } else {
					return false;
		    	}
			}
	    },

	    titulo :{
	       required : function(){
		       	if (($('#numeroCte').val() != '0')|| ($('#garanteRelacion').val() != '0') ) {
					return true;
			    }
			    else{
			      	return false;
			    }
			}
	    },

	    cargoID :'required',

		primerNombre : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},

		RFC : {
			required : function() {
				if ((esMenorEdad == 'N')) {
					return false;
				} else {
					return true;

				}
			},
			maxlength : function() {
				if ((esMenorEdad == 'N')) {
					if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
						return 12;
					} else {
						return 13;
					}
				} else {
					return 13;
				}
			},
		},
		CURP : {
			required : function() {
				var requerido = true;
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					requerido = false;
				}
				return requerido;
			},
			maxlength : function() {
				var requerido = 18;
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					requerido = 0 ;
				}
				return requerido;
			}
		},
		ocupacionID :{
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		correo : 'email',

		directivoID : 'required',

		fechaNacimiento : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			},
			date : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			},
		},
		paisNacimiento :{
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		estadoCivil :{
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		sexo :{
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		nacion : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		actividadINEGI : 'required',

		sectorEconomico : 'required',
		tipoIdentiID :{
	       required : function(){
				if (($('#numeroCte').val() != '0') ) {
					return true;
				}
				else{
					return false;
			    }
			}
        },

		tipoIdentiID : {
			required : function() {
				return esMenorEdad == 'N' ? true : false;
			},
		},
		numIdentific : {
			required : function() {
				if (esMenorEdad == 'N') {
					return true;
				} else {
					return false;
				}
			},
			minlength : 5,
			maxlength : 18
		},
		domicilio : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return false;
				} else {
					return true;
				}
			}
		},
		paisResidencia : {
	          required : function(){
			if (($('#numeroCte').val() != '0') || ($('#garanteRelacion').val() != '0') ) {
					return true;
				}
				else{
					return false;
			    }
			}
		},
		fecExIden : 'date',
		fecVenIden : 'date',
		fechaEscPub : 'date',
		//estas son validaciones de escritura publica si y solo si es apoderado
		numEscPub : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},
		fechaEscPub : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},
		estadoID : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},
		municipioID : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},
		notariaID : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},
		titularNotaria : {
			required : function() {
				return $('#esApoderado').attr('checked');
			}
		},

		ingreRealoRecursos : {
			maxlength : 18,
			number : true
		},
		paisRFC : {
			required : function() {
				if ($('#nacion').val() == 'E') {
					return true;
				} else {
					return false;
				}
			}
		},
		tipoAccionista : {
			required : function() {
				if ($('#esAccionista').val()== 'S') {
					return true;
				} else {
					return false;
				}
			}
		},
		porcentajeAccion : {
			required : function() {
				if ($('#esAccionista').val()== 'S') {
					return true;
				} else {
					return false;
				}
			}
		},
		valorAcciones : {
			required : function() {
				if ($('#esAccionista').val()== 'S') {
					return true;
				} else {
					return false;
				}
			}
		},
		folioMercantil : {
			maxlength : 10
		},
		compania : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		direccion1 : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		edoNacimiento : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		munNacimiento : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		nombreCiudad : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		coloniaID : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		paisCompania : {
			required : function() {
				if ($('#esAccionista').val()== 'S' && $("#tipoAccionista option:selected").val() == 'M' ) {
					return true;
				} else {
					return false;
				}
			}
		},
		paisIDDom: 'required',
		estadoIDDom: 'required',
		municipioIDDom: 'required',
		localidadIDDom: 'required',
		coloniaIDDom: 'required',
		calleDom: 'required',
		numExteriorDom: 'required',
		primeraEntreDom: 'required',
		segundaEntreDom: 'required',
		codigoPostalDom: 'required',
		domicilioCompleto: 'required'
	},

	messages : {
		numCliente : 'Especifique Número de Cliente, Aval o Garante .',
		numeroCte : 'Especifique Cliente Relacionado.',
		cargoID : 'Especifique Cargo.',

		titulo : {
			required : 'Especifique Título.'
		},

		primerNombre : {
			required : 'Especifique Primer Nombre.',
			minlength : 'Mínimo 3 Caracteres.'
		},

		correo : {
			email : 'Dirección de correo Inválida.'
		},
		RFC : {
			required : 'Especifique RFC.',
			maxlength : 'Máximo 13 Caracteres.',
		},
		CURP : {
			required : 'Especifique CURP.',
			maxlength : 'Máximo 18 Caracteres.'
		},
		ocupacionID : 'Especifique la Ocupación.',
		directivoID : 'Especifique Número.',
		fechaNacimiento : {
			required : 'Especifique Fecha de Nacimiento.',
			date : 'Fecha Incorrecta.',
		},
		estadoCivil : 'Especifique Estado Civil.',
		sexo : 'Especifique Género.',
		nacion : 'Especifique Nacionalidad.',
		paisNacimiento : 'Especifique País de Nacimiento.',
		actividadINEGI : 'Especifique Actividad.',
		sectorEconomico : 'Especifique Sector.',

		numIdentific : {
			required : 'Especifique Folio de Identificación',
			minlength : jQuery.format("Se Requieren Mínimo {0} Caracteres"),
			maxlength : jQuery.format("Se Requieren Máximo {0} Caracteres"),
		},

		domicilio : {
			required : function() {
				var mensaje = "";
				if ($('#numeroCte').val().length > 0) {
					mensaje = 'El cliente no tiene Domicilio Oficial.';
				} else {
					mensaje = 'Especifique Domicilio.';
				}
				return mensaje;
			}
		},
		paisResidencia : 'Especifique País.',
		fecExIden : 'Fecha Incorrecta.',
		fecVenIden : 'Fecha Incorrecta.',
		fechaEscPub : 'Fecha Incorrecta.',
		//estas son validaciones de escritura publica si y solo si es apoderado
		numEscPub : {
			required : function() {
				var mensaje = 'Especifique  Número de Escritura Pública.';
				return mensaje;
			}
		},
		fechaEscPub : {
			required : function() {
				var mensaje = 'Especifique  Fecha .';
				return mensaje;
			}
		},
		estadoID : {
			required : function() {
				var mensaje = 'Especifique  Estado.';
				return mensaje;
			}
		},
		municipioID : {
			required : function() {
				var mensaje = 'Especifique   Municipio.';
				return mensaje;
			}
		},
		notariaID : {
			required : function() {
				var mensaje = 'Especifique Notaria.';
				return mensaje;
			}
		},
		titularNotaria : {
			required : function() {
				var mensaje = 'Especifique Nombre del Titular. ';
				return mensaje;
			}
		},

		ingreRealoRecursos : {
			maxlength : 'Máximo 18 Caracteres.',
			number : 'Sólo Números.'
		},
		paisRFC : {
			required : 'Especifique País que Asigna RFC.'
		},
		tipoAccionista : {
			required : 'Especifique el Tipo de Accionista.'
		},
		porcentajeAccion : {
			required : 'Especifique el Porcentaje de Acciones.'
		},
		valorAcciones : {
			required : 'Especifique el Valor de las Acciones'
		},
		folioMercantil : {
			maxlength : 'Máximo 10 Caracteres.'
		},
		compania : {
			required : 'Especifique la Compañia'
		},
		direccion1 : {
			required : 'Especifique una Dirección'
		},
		edoNacimiento : {
			required : 'Especifique un Estado'
		},
		munNacimiento : {
			required : 'Especifique un Municipio'
		},
		nombreCiudad : {
			required : 'Especifique una Ciudad'
		},
		coloniaID : {
			required : 'Especifique una Colonia'
		},
		paisCompania : {
			required : 'Especifique un Pais'
		},
		paisIDDom: 'Especifique País',
		estadoIDDom: 'Especifique Estado',
		municipioIDDom: 'Especifique Municipio',
		localidadIDDom: 'Especifique Localidad',
		coloniaIDDom: 'Especifique Colonia',
		calleDom: 'Especifique Nombre Calle',
		numExteriorDom: 'Especifique Número Exterior',
		primeraEntreDom: 'Especifique Primera Calle',
		segundaEntreDom: 'Especifique Segunda Calle',
		codigoPostalDom: 'Especifique CP',
		domicilioCompleto: 'Especifique Domicilio',
		tipoIdentiID :{
			required: 'Especifique el tipo de identificación'
		}
	}
	});

	//------------ Validaciones de Controles -------------------------------------

	function validaDirectivo(idControl) {
		var jqDirectivo = eval("'#" + idControl + "'");
		var numDirectivo = $(jqDirectivo).val();
		var numCli = $('#numCliente').val();
		var numGar = $('#garanteID').val();
		var numAva = $('#avalID').val();

		var conDirectivos = 1;
		numCteRelacionado = ''; // variable global
		setTimeout("$('#cajaLista').hide();", 200);

		if (numDirectivo != '' && !isNaN(numDirectivo) && esTab) {
			if (numDirectivo == '0') {
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				habilitaFormularioCuentaPersona();
				limpiaFormaCompleta('formaGenerica', true, ['garanteID','avalID','nombreGarante','nombreAval','numCliente',
				                                            'nombreCliente', 'sucursalID', 'nombreSucursal','directivoID','consejoAdmon',
				                                            'esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
				                                            'esSolicitante', 'esAutorizador', 'esAdministrador']);
				limpiaPorcentaje();
				$('#primerNombre').attr('readOnly', false);
				$('#primerNombre').attr('disabled', false);
				$('#titulo').attr('readOnly', false);
				$('#titulo').attr('disabled', false);
				$('#tipoIdentiID').val('');
				$('#miscelaneos').show();
				$('#tipoPersona').val('');
				$('#datosPersonaFisica').show(500);
				$('#escritura').hide();
				mostrarCamposTipoAccionesta('N');
				$('#esApoderado').val('N');
				$('#esAccionista').val('N');
				$('#consejoAdmon').val('N');
				$('#esPropReal').val('N');
				$('#esSolicitante').val('N');
				$('#esAutorizador').val('N');
				$('#esAdministrador').val('N');
				limpiaCombos();
				ajustaComboTipAccionista(4);
			} else {
				if (numDirectivo != '' && !isNaN(numDirectivo) && esTab) {


						var DirectivosBeanCon = {
						'numCliente' : numCli,
						'garanteID'  :numGar,
						'avalID'     :numAva,
						'directivoID' : numDirectivo
						};

					adicionalPersonaMoralServicio.consulta(conDirectivos, DirectivosBeanCon, {
					async : false,
					callback : function(direcCliente) {
						if (direcCliente != null) {
							if(direcCliente.esAccionista == 'S' && direcCliente.tipoAccionista == 'M'){

								$('#compania').val(direcCliente.compania);
								$('#direccion1').val(direcCliente.direccion1);
								$('#direccion2').val(direcCliente.direccion2);
								$('#paisResidencia').val(direcCliente.paisResidencia);
								$('#paisNacimiento').val(direcCliente.paisResidencia);

								$('#paisCompania').val(direcCliente.paisResidencia);
								$('#edoNacimiento').val(direcCliente.edoNacimiento);
								$('#munNacimiento').val(direcCliente.munNacimiento);
								$('#locNacimiento').val(direcCliente.locNacimiento);
								$('#coloniaID').val(direcCliente.coloniaID);

								$('#nombreCiudad').val(direcCliente.nombreCiudad);
								$('#codigoPostal').val(direcCliente.codigoPostal);
								$('#edoExtranjero').val(direcCliente.edoExtranjero);
								$('#telefonoCompania').val(direcCliente.telefonoCasa);
								$('#extensionCompania').val(direcCliente.extTelefonoPart);

								$('#faxCompania').val(direcCliente.fax);
								$('#paisRFC').val(direcCliente.paisResidencia);
							}

							$('#cargoID').val(direcCliente.cargoID);
							$('#titulo').val(direcCliente.titulo);
							$('#paisResidencia').val(direcCliente.paisResidencia);
							$('#numeroCte').val(direcCliente.numeroCte);
							$('#avalRelacion').val(direcCliente.avalRelacion);
							$('#garanteRelacion').val(direcCliente.garanteRelacion);

                            $('#esApoderado').attr('readOnly', true);
                            $('#esAccionista').attr('readOnly', true);

							$('#primerNombre').val(direcCliente.primerNombre);
							$('#segundoNombre').val(direcCliente.segundoNombre);
							$('#tercerNombre').val(direcCliente.tercerNombre);
							$('#apellidoPaterno').val(direcCliente.apellidoPaterno);
							$('#apellidoMaterno').val(direcCliente.apellidoMaterno);
							$('#fechaNacimiento').val(direcCliente.fechaNacimiento);
							$('#paisNacimiento').val(direcCliente.paisNacimiento);
							$('#paisResidencia').val(direcCliente.paisResidencia);
							$('#edoNacimiento').val(direcCliente.edoNacimiento);
							$('#estadoCivil').val(direcCliente.estadoCivil);
							$('#sexo').val(direcCliente.sexo);
							$('#CURP').val(direcCliente.CURP);
							$('#RFC').val(direcCliente.RFC);
							$('#FEA').val(direcCliente.FEA);
							$('#paisFea').val(direcCliente.paisFea);
							$('#ocupacionID').val(direcCliente.ocupacionID);
							$('#puestoA').val(direcCliente.puestoA);
							$('#sectorGeneral').val(direcCliente.sectorGeneral);
							$('#actividadBancoMX').val(direcCliente.actividadBancoMX);
							$('#actividadINEGI').val(direcCliente.actividadINEGI);
							$('#sectorEconomico').val(direcCliente.sectorEconomico);

							$('#tipoIdentiID').val(direcCliente.tipoIdentiID);
							$('#numIdentific').val(direcCliente.numIdentific);
							$('#fecExIden').val(direcCliente.fecExIden);
							$('#fecVenIden').val(direcCliente.fecVenIden);
							$('#telefonoCasa').val(direcCliente.telefonoCasa);
							$('#telefonoCelular').val(direcCliente.telefonoCelular);
							$('#correo').val(direcCliente.correo);
							$('#domicilioCompleto').val(direcCliente.domicilio);
							$('#nacion').val(direcCliente.nacion);

							$('#fechaEscPub').val(direcCliente.fechaEscPub);
							$('#numEscPub').val(direcCliente.numEscPub);
							$('#estadoID').val(direcCliente.estadoID);
							$('#municipioID').val(direcCliente.municipioID);
							$('#notariaID').val(direcCliente.notariaID);
							$('#folioMercantil').val(direcCliente.folioMercantil);

							tipoPersonaSeleccionada(direcCliente.esApoderado, direcCliente.esAccionista,direcCliente.consejoAdmon,  direcCliente.esPropReal, direcCliente.esSolicitante, direcCliente.esAutorizador, direcCliente.esAdministrador);

							calculaEdad(direcCliente.fechaNacimiento);
							consultaActividadBMX('actividadBancoMX');

							$('#fechaEscPub').val(direcCliente.fechaEscPub);
							$('#numEscPub').val(direcCliente.numEscPub);
							$('#telefonoCasa').setMask('phone-us');
							$('#telefonoCelular').setMask('phone-us');

							checaPropietarioReal(direcCliente.esPropReal);
							$('#ingreRealoRecursos').val(direcCliente.ingreRealoRecursos);

							$('#ingreRealoRecursos').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
							});

							ocultaIngresosRealoRecursos();

							consultaPais('paisResidencia', false);
							consultaPais('paisRFC', false);

							if (direcCliente.numeroCte == 0) {
								if (esMenorEdad == 'N') {
									consultaNumeroCaracteresTipoIdent(direcCliente.tipoIdentiID);
								}
							}
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');

							if (direcCliente.sectorGeneral != 0) {
								consultaSecGeneral('sectorGeneral');
							} else {
								$('#sectorGeneral').val('');
								$('#actividadINEGI').val('');
								$('#sectorEconomico').val('');
							}
							if (direcCliente.fechaEscPub == '1900-01-01' || direcCliente.fechaEscPub == '0000-00-00') {
								$('#fechaEscPub').val('');
							}
							if (direcCliente.fechaNacimiento == '1900-01-01' || direcCliente.fechaNacimiento == '0000-00-00') {
								$('#fechaNacimiento').val('');
							}
							if (direcCliente.fecExIden == '1900-01-01' || direcCliente.fecExIden == '0000-00-00') {
								$('#fecExIden').val('');
							}
							if (direcCliente.fecVenIden == '1900-01-01' || direcCliente.fecVenIden == '0000-00-00') {
								$('#fecVenIden').val('');
							}
							if (direcCliente.fechaVenEst == '1900-01-01' || direcCliente.fechaVenEst == '0000-00-00') {
								$('#fechaVenEst').val('');
							}

							if (direcCliente.numeroCte > 0) { // si el relacionado es cliente entonces se consulta y deshabilitan los campos
								esTab = true;
								numCteRelacionado = direcCliente.numeroCte;
								consultaCliente(direcCliente.numeroCte, 'modificaMismoCte', direcCliente);
								 soloLEcturaFomCuentas();

							}else if(direcCliente.garanteRelacion>0){
                               	numCteRelacionado = direcCliente.garanteRelacion;
								consultaGaranteFisica(direcCliente.garanteRelacion, 'modificaMismoCte', direcCliente);
							    soloLEcturaFomCuentas();


							} else if(direcCliente.avalRelacion>0){
							    numCteRelacionado = direcCliente.avalRelacion;
								consultaAvalFisica(direcCliente.avalRelacion);
								 soloLEcturaFomCuentas();
							}else {
								numCteRelacionado = -1;
								habilitaFormularioCuentaPersona();
								$('#nombreCompleto').val('');
								if (direcCliente.nacion == 'N') {
									$('tr[name=extranjero]').hide(500);
								} else {
									$('tr[name=extranjero]').show(500);
								}
							}

							validaCargo('cargoID');
							consultaOcupacion('ocupacionID');
							consultaPaisFea('paisFea');
							consultaEstado('estadoID');
							consultaMunicipio('municipioID');

							if(direcCliente.esAccionista == 'S' && direcCliente.tipoAccionista == 'M'){
								$('#paisNacimiento').val(direcCliente.paisResidencia);
								consultaMunicipio('munNacimiento');
								consultaLocalidad('locNacimiento');
								consultaColonia('coloniaID');
								consultaPais('paisCompania', false);
							} else {
								consultaPais('paisNacimiento', false);
							}

							if (direcCliente.estadoID == '' || direcCliente.estadoID == 0) {
								$('#nombreEstado').val('');
							}
							if (direcCliente.municipioID == '' || direcCliente.municipioID == 0) {
								$('#nombreMuni').val('');
							}

							if (direcCliente.edoNacimiento == '' || direcCliente.edoNacimiento == 0) {
								$('#nomEdoNacimiento').val('');
							} else {
								consultaEstadoDatosP('edoNacimiento');
							}

							if (direcCliente.esApoderado != 'S') {
								$('#escritura').hide();
							} else {

								if (direcCliente.esApoderado == 'S') {
									$('#escritura').show();
									$('#folioMercantil').val(direcCliente.folioMercantil);
									$('#fechaEscPub').val(direcCliente.fechaEscPub);
									$('#numEscPub').val(direcCliente.numEscPub);
									$('#estadoID').val(direcCliente.estadoID);
									$('#municipioID').val(direcCliente.municipioID);
									$('#notariaID').val(direcCliente.notariaID);
									// si no trae numero de escritura entonces no selecciono una existente
									if (numCteRelacionado != -1) {
										if (direcCliente.numeroCte > 0) {
											consultaEscritura('clienteID'); // avales
										}
										consultaEstado('estadoID');
										consultaMunicipio('municipioID');
										consultaNotaria('notariaID');
										habilitaCamposEscritura();

									} else {
										habilitaCamposEscritura();
										consultaEstado('estadoID');
										consultaMunicipio('municipioID');
										consultaNotaria('notariaID');
									}
								}
							}
							$('#porcentajeAccion').val(direcCliente.porcentajeAccion);
							$('#valorAcciones').val(direcCliente.valorAcciones);
							$('#valorAcciones').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
							$('#tipoAccionista').val(direcCliente.tipoAccionista);
							var mostrarAccionista = 'N';
							if(direcCliente.tipoAccionista == 'M'){
								mostrarAccionista = 'S';
							}
							mostrarCamposTipoAccionesta(mostrarAccionista);

							activarDesRadios(direcCliente.esApoderado, direcCliente.esAccionista,direcCliente.consejoAdmon,  direcCliente.esPropReal, direcCliente.esSolicitante, direcCliente.esAutorizador,  direcCliente.esAdministrador);
							if(direcCliente.paisIDDom == 0) {
								$('#paisIDDom').val('700');
							} else {
								$('#paisIDDom').val(direcCliente.paisIDDom);
							}
							$('#estadoIDDom').val(direcCliente.estadoIDDom);
							$('#municipioIDDom').val(direcCliente.municipioIDDom);
							$('#localidadIDDom').val(direcCliente.localidadIDDom);
							$('#coloniaIDDom').val(direcCliente.coloniaIDDom);
							$('#nombreColonia').val(direcCliente.nombreColoniaDom);
							$('#nombreCiudadDom').val(direcCliente.nombreCiudadDom);
							$('#calleDom').val(direcCliente.calleDom);
							$('#numExteriorDom').val(direcCliente.numExteriorDom);
							$('#numInteriorDom').val(direcCliente.numInteriorDom);
							$('#pisoDom').val(direcCliente.pisoDom);
							$('#primeraEntreDom').val(direcCliente.primeraEntreDom);
							$('#segundaEntreDom').val(direcCliente.segundaEntreDom);
							$('#codigoPostalDom').val(direcCliente.codigoPostalDom);
							$('#domicilioCompleto').val(direcCliente.domicilio);

							consultaPaisDir();
							consultaEdoDir();
							consultaMunDom();
							consultaLocalidadDom();
							consultaColoniaDom();

						} else {
							mensajeSis("No Existe la Persona");
							inicializaForma('personasRelacionadas', 'directivoID');
							limpiaCombos();
							habilitaFormularioCuentaPersona();
							$(jqDirectivo).focus();
							$(jqDirectivo).select();
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
							ocultaIngresosRealoRecursos();
							$('#datosPersonaFisica').show(500);
							$('#escritura').hide();
						}
					}
					});
				}
			}
		}
	}

	function consultaAvalFisica(numAval1, tipoTransaccion, cuentasPersonaBean) {
		var conAval = 1;
		var avalBean = {
			'avalID': numAval1
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numAval1 != '' && numAval1 != '0' && !isNaN(numAval1)) {
			var numAval = Number(numAval1);

			if (numAval > 0) {
				habilitaControl('titulo');

			 avalesServicio.consulta(conAval,avalBean, {
			 	async : false,
				callback :function(aval) {
						if (aval != null) {
							listaPersBloqBean = consultaListaPersBloq(numAval, esAval, 0, 0);
							if(listaPersBloqBean.estaBloqueado != 'S'){
							if(aval.tipoPersona!=catTipoPersonaJuridica.moral){

						       limpiaFormaCompleta('formaGenerica', true, ['paisResidencia','titulo','avalRelacion','nombreAvalRel','garanteID','avalID','nombreGarante','nombreAval',
						       	                                           'numCliente', 'nombreCliente', 'sucursalID', 'nombreSucursal','directivoID','consejoAdmon','esApoderado',
						       	                                           'esAccionista','esPropReal', 'ingreRealoRecursos','avalRelacion','cargoID','descCargo',
						       	                                           'esSolicitante', 'esAutorizador', 'esAdministrador']);


								$('#datosPersonaFisica').show(500);
								$('#domicilioOficialPM').hide(500);
								$('#identificacionDiv').show(500);
								$('#nacionalidadDiv').show(500);
								$('#avalRelacion').show(500);

                                $('#esApoderado').attr('readOnly', false);
                                $('#esAccionista').attr('readOnly', false);

								$('#garanteRelacion').val("0");
								$('#numeroCte').val("0");

								$('#nombreAvalRel').val(aval.nombreCompleto);
								$('#paisNacimiento').val(aval.lugarNacimiento);
								consultaPais('paisNacimiento', false);

								$('#edoNacimiento').val(aval.estadoID);
								$('#nacion').val(aval.nacion);
								$('#ocupacionC').val("");
								$('#FEA').val(aval.fea);
								$('#paisFea').val(aval.paisFea);
								consultaPaisFea('paisFea');


								$('#puestoA').val(aval.puesto);
								$('#tipoPersona').val('F');

								$('#primerNombre').val(aval.primerNombre);
								$('#segundoNombre').val(aval.segundoNombre);
								$('#tercerNombre').val(aval.tercerNombre);
								$('#apellidoPaterno').val(aval.apellidoPaterno);
								$('#apellidoMaterno').val(aval.apellidoMaterno);
								$('#fechaNacimiento').val(aval.fechaNac);
								$('#estadoCivil').val(aval.estadoCivil);
								$('#sexo').val(aval.sexo);

								$('#CURP').val(aval.CURP);
								$('#RFC').val(aval.rFC);

								$('#ocupacionID').val(aval.ocupacionID);

								$('#telefonoCasa').val(aval.telefono);
								$('#extTelefonoPart').val(aval.extTelefonoPart);
								$('#correo').val(aval.correo);

							    $('#ocupacionID').val(aval.ocupacionID);
								$('#sectorGeneral').val(aval.sectorGeneral);
								$('#actividadBancoMX').val(aval.actividadBancoMX);
								$('#actividadINEGI').val(aval.actividadINEGI);
								$('#sectorEconomico').val(aval.sectorEconomico);
								$('#tipoIdentiID').val(aval.tipoIdentiID);
								$('#numIdentific').val(aval.numIdentific);
								$('#fecExIden').val(aval.fecExIden);
								$('#fecVenIden').val(aval.fecVenIden);
								$('#telefonoCelular').val(aval.telefonoCel);
								$('#correo').val(aval.correo);
								$('#domicilio').val(aval.direccionCompleta);

								$('#razonSocial').val(aval.razonSocial);
								$('#fax').val(aval.fax);
								soloLEcturaFomCuentas();
								if(calculaEdad(aval.fechaNac)){
									dwr.util.setValues(aval);
								}


								if (aval.nacion == 'N') {
									$('tr[name=extranjero]').hide(500);
								} else {
									$('tr[name=extranjero]').show(500);
									var cteExtBeanCon = {
										'clienteID' : aval.numero
									};
									var consultaCliExtranjeroPrincipal = 1;

								}

								selectNacion = aval.nacion;
								if (selectNacion == null) {
									selectNacion = '';
								}

								if (aval.fechaNacimiento == '1900-01-01' || aval.fechaNacimiento == '0000-00-00') {
									$('#fechaNacimiento').val('');
								}

								validaNacionalidadCte();

								consultaPais('lugarNacimiento', false);

								if (aval.lugarNacimiento == '700') {
									$('#paisRFC').val('700');
								}
								consultaPais('paisRFC', false);
								consultaOcupacion('ocupacionID');

								esMenorEdad = aval.esMenorEdad;
								if (aval.esMenorEdad == 'N') {
									consultaIdenCliente(aval.numero);
								}


								consultaEstadoDatosP('edoNacimiento');

							    $('#cargoID').focus();
								$('#razonSocial').val(aval.razonSocial);
								$('#sectorGeneral').val(aval.sectorGeneral);
								$('#actividadBancoMX').val(aval.actividadBancoMX);
								$('#actividadINEGI').val(aval.actividadINEGI);
								$('#sectorEconomico').val(aval.sectorEconomico);
								consultaActividadBMX('actividadBancoMX');
								consultaSecGeneral('sectorGeneral');
								consultaDireccion('avalRelacion');
								ajustaComboTipAccionista(1);

								$('#paisResidencia').val(aval.lugarNacimiento);
								consultaPais('paisResidencia', false);

							}else{
								$('#avalRelacion').focus();
								mensajeSis("El Aval Es Persona Moral.");
								$('#avalRelacion').val("");
								$('#nombreAvalRel').val("");
							}


							}else{
								mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
								validaLimpiarFormulario('A');
								$('#avalRelacion').focus();
							}
						} else {
							$('#avalRelacion').focus();
							mensajeSis("El Aval no Existe");
							$('#avalRelacion').val('');
							$('#nombreAvalRel').val('');
							}
						}
					});

			// si no existe el Cliente

			}

		} else {

			validaLimpiarFormulario('A');
		}
	}


	function consultaCliente(numCliente, tipoTransaccion, cuentasPersonaBean) {
		var conCliente = 1;
		var rfc = ' ';
		var directivo= $('#directivoID').val();

		setTimeout("$('#cajaLista').hide();", 200);


		if (numCliente != '' && numCliente != '0' && !isNaN(numCliente)) {
			var cliente = Number(numCliente);
			if (cliente > 0) {


			  limpiaFormaCompleta('formaGenerica', true, ['cargoID','numeroCte','nombreCompleto','garanteID','avalID','nombreGarante','nombreAval',
						       	                                           'numCliente', 'nombreCliente', 'sucursalID', 'nombreSucursal', 'directivoID','avalRelacion',
						       	                                           'consejoAdmon','esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
						       	                                           'esSolicitante', 'esAutorizador', 'esAdministrador']);


				listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
				if (listaPersBloqBean.estaBloqueado != 'S') {
					clienteServicio.consulta(conCliente, numCliente, rfc, {
					async : false,
					callback : function(cliente) {

						if (cliente != null) {

								if (cliente.tipoPersona == 'M') {
									mensajeSis("Solo personas Físicas");
									$('#numeroCte').val('');
									$('#nombreCompleto').val('');
									$('#numeroCte').focus();

								} else {
									$('#datosPersonaFisica').show(500);
									$('#domicilioOficialPM').hide(500);
									$('#identificacionDiv').show(500);
									$('#nacionalidadDiv').show(500);
								     habilitaControl('esApoderado');
                                     habilitaControl('esAccionista');

									$('#garanteRelacion').val('0');
									$('#avalRelacion').val('0');

									$('#nombreCompleto').val(cliente.nombreCompleto);
									$('#numeroCte').val(cliente.numero);

									$('#paisNacimiento').val(cliente.lugarNacimiento);
									$('#edoNacimiento').val(cliente.estadoID);
									$('#nacion').val(cliente.nacion);
									$('#ocupacionC').val("");
									$('#FEA').val(cliente.fea);
									$('#paisFea').val(cliente.paisFea);
									consultaPaisFea('paisFea');

									$('#titulo').val(cliente.titulo);
									deshabilitaControl('titulo');

									$('#puestoA').val(cliente.puesto);
									$('#tipoPersona').val('F');
									ajustaComboTipAccionista(1);
									$('#primerNombre').val(cliente.primerNombre);
									$('#segundoNombre').val(cliente.segundoNombre);
									$('#tercerNombre').val(cliente.tercerNombre);
									$('#apellidoPaterno').val(cliente.apellidoPaterno);
									$('#apellidoMaterno').val(cliente.apellidoMaterno);
									$('#fechaNacimiento').val(cliente.fechaNacimiento);
									$('#estadoCivil').val(cliente.estadoCivil);
									$('#sexo').val(cliente.sexo);

									$('#CURP').val(cliente.CURP);
									$('#RFC').val(cliente.RFC);

									$('#ocupacionID').val(cliente.ocupacionID);

									$('#telefonoCasa').val(cliente.telefonoCasa);
									$('#extTelefonoPart').val(cliente.extTelefonoPart);
									$('#telefonoCelular').val(cliente.telefonoCelular);
									$('#correo').val(cliente.correo);

									$('#paisResidencia').val(cliente.paisResidencia);
									$('#razonSocial').val(cliente.razonSocial);
									$('#fax').val(cliente.fax);

									calculaEdad(cliente.fechaNacimiento);
									if (cliente.nacion == 'N') {
										$('tr[name=extranjero]').hide(500);
									} else {
										$('tr[name=extranjero]').show(500);
										var cteExtBeanCon = {
											'clienteID' : cliente.numero
										};
										var consultaCliExtranjeroPrincipal = 1;
										cliExtranjeroServicio.consulta(consultaCliExtranjeroPrincipal, cteExtBeanCon, function(cteExt) {
											if (cteExt != null) {
												$('#docEstanciaLegal').val(cteExt.documentoLegal);
												$('#docExisLegal').val(cteExt.motivoEstancia);
												$('#fechaVenEst').val(cteExt.fechaVencimiento);
												$('#paisRFC').val(cteExt.paisRFC);
												consultaPais('paisRFC', false);
												$('#fea').val(cteExt.fea);
												$('#paisFea').val(cteExt.paisFea);
												consultaPaisFea('paisFea');

												if (cteExt.fechaVencimiento == '1900-01-01' || cteExt.fechaVencimiento == '0000-00-00') {
													$('#fechaVenEst').val('');
												}
												selectDocEstancia = cteExt.documentoLegal;
											} else {
												limpiaFormaCompleta('formaGenerica', true, ['avalID','nombreAval','garanteID','nombreGarante',
												                                            'numCliente', 'nombreCliente', 'sucursalID', 'nombreSucursal', 'avalRelacion',
												                                            'directivoID','consejoAdmon','esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
												                                            'esSolicitante', 'esAutorizador', 'esAdministrador']);
												mensajeSis('El Cliente No tiene una Identificación Oficial Capturada');

												return;
											}
										});
									}

									selectNacion = cliente.nacion;
									if (selectNacion == null) {
										selectNacion = '';
									}

									if (cliente.fechaNacimiento == '1900-01-01' || cliente.fechaNacimiento == '0000-00-00') {
										$('#fechaNacimiento').val('');
									}

									validaNacionalidadCte();
									consultaPais('paisResidencia', false);
									consultaPais('paisNacimiento', false);

									if (cliente.lugarNacimiento == '700') {
										$('#paisRFC').val('700');
									}
									consultaPais('paisRFC', false);
									consultaOcupacion('ocupacionID');

									esMenorEdad = cliente.esMenorEdad;
									if (cliente.esMenorEdad == 'N') {
										consultaIdenCliente(cliente.numero);
									}

									consultaEstadoDatosP('edoNacimiento');
									soloLEcturaFomCuentas();
									$('#cargoID').focus();

								}
								$('#razonSocial').val(cliente.razonSocial);
								$('#sectorGeneral').val(cliente.sectorGeneral);
								$('#actividadBancoMX').val(cliente.actividadBancoMX);
								$('#actividadINEGI').val(cliente.actividadINEGI);
								$('#sectorEconomico').val(cliente.sectorEconomico);
								consultaActividadBMX('actividadBancoMX');
								consultaSecGeneral('sectorGeneral');
								consultaDireccion('numeroCte');

						} else { // si no existe el Cliente

							mensajeSis("No Existe el Cliente");
							inicializaForma('personasRelacionadas', 'directivoID');
							habilitaFormularioCuentaPersona(); // habilitamos Los campos para ingresar los datos de uan persona
							limpiaCombos();

							$('#datosPersonaFisica').show(500);
							$('#domicilioOficialPM').hide(500);
							$('#identificacionDiv').show(500);
							$('#nacionalidadDiv').show(500);
							$('#escritura').hide();

							$('#numeroCte').focus();
							$('#numeroCte').val('');
							$('#nombreCompleto').val('');

						}
					}
					});

				} else {
					mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
					inicializaForma('personasRelacionadas', 'directivoID');
					habilitaFormularioCuentaPersona();
					limpiaCombos();
					$('#numeroCte').focus();
				}
			}

		}

	}

	function consultaClientePrincipal(idControl) {
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(idControl != '' && !isNaN(idControl) && esTab){

			clienteServicio.consulta(conCliente,idControl,function(cliente) {

				if(cliente!=null){
					listaPersBloqBean = consultaListaPersBloq(idControl, esCliente, 0, 0);
					if (listaPersBloqBean.estaBloqueado != 'S') {
						if (cliente.tipoPersona != 'M') {
							mensajeSis("Solo personas Morales");
							$('#numCliente').focus();
							$('#numCliente').val("");
					        $('#nombreCliente').val("");
	
						} else {
							limpiaFormaCompleta('formaGenerica', true, ['clienteID','garanteID','nombreCliente','nombreGarante','numCliente',
							                                            'nombreCliente', 'sucursalID', 'nombreSucursal']);
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#nombreAval').val("");
							$('#avalID').val("0");
							$('#nombreGarante').val("");
							$('#garanteID').val("0");
							$('#directivoID').focus();
	
	
							$('#sucursalID').val(cliente.sucursalOrigen);
							consultaSucursal(cliente.sucursalOrigen);
						}
				} else {
					mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
					$('#numCliente').focus();
					$('#numCliente').select();
					$('#nombreCliente').val("");
					inicializaForma('formaGenerica','clienteID');
				}
				}else{
					mensajeSis("No Existe el Cliente");
					$('#numCliente').focus();
					$('#numCliente').select();
					$('#nombreCliente').val("");
					inicializaForma('formaGenerica','clienteID');
				}
			});
		}
	}

	function consultaAval(idControl) {
		var jqNumAval = eval("'#" + idControl + "'");
		var numAval = $(jqNumAval).val();
		var tipoMoral='M';

		var avalBean = {
			'avalID': numAval
		};

		if(numAval != '' && !isNaN(numAval) && esTab){
			avalesServicio.consulta(1,avalBean, function(avales) {
				if(avales!=null){
					listaPersBloqBean = consultaListaPersBloq(numAval, esAval, 0, 0);
					if (listaPersBloqBean.estaBloqueado != 'S') {
	                    if(avales.tipoPersona==tipoMoral){
	                       limpiaFormaCompleta('formaGenerica', true, ['garanteID','numCliente','nombreCliente','nombreGarante','avalID',
	                                                                   'nombreAval', 'sucursalID', 'nombreSucursal','consejoAdmon','esApoderado','esAccionista',
	                                                                   'esPropReal', 'ingreRealoRecursos', 'esSolicitante', 'esAutorizador', 'esAdministrador']);
							$('#nombreAval').val(avales.nombreCompleto);
							$('#nombreGarante').val("");
							$('#numCliente').val("0");
							$('#garanteID').val("0");
							$('#nombreCliente').val("");
	
	                        $('#directivoID').focus();
	
						}else{
							mensajeSis("El Aval no es tipo persona Moral");
						}
					} else {
						mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
						$('#avalID').focus();
						$('#avalID').select();
						$('#avalID').val("");
						$('#nombreAval').val("");
						inicializaForma('formaGenerica','avalID');
					}
				}else{
					mensajeSis("No Existe el Aval");
					$('#avalID').focus();
					$('#avalID').select();
					$('#avalID').val("");
					$('#nombreAval').val("");
					inicializaForma('formaGenerica','avalID');
				}

			});
		}
	}


	function consultaGarante(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);

		var jqGarante = eval("'#" + idControl + "'");
		var numGarante = $(jqGarante).val();
		var tipConForanea = 1;
		var tipoMoral='M';

		if(numGarante != '' && !isNaN(numGarante) && esTab){
			garantesServicio.consulta(tipConForanea,numGarante,function(garante) {
				if(garante!=null){
					listaPersBloqBean = consultaListaPersBloq(numGarante, esGarante, 0, 0);
					if (listaPersBloqBean.estaBloqueado != 'S') {
						if(garante.tipoPersona==tipoMoral){
						limpiaFormaCompleta('formaGenerica', true, ['avalID','nombreCliente','nombreAval','numCliente','garanteID',
						                                            'nombreGarante', 'sucursalID', 'nombreSucursal','consejoAdmon',
						                                            'esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
						                                            'esSolicitante', 'esAutorizador', 'esAdministrador']);
							$('#nombreGarante').val(garante.nombreCompleto);
							$('#nombreAval').val("");
							$('#avalID').val("0");
							$('#numCliente').val("0");
							$('#nombreCliente').val("");
	                        $('#directivoID').focus();
	
						}else{
							mensajeSis("El garante no es tipo persona Moral");
	
						}
					} else {
						mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
						$('#garanteID').focus();
						$('#garanteID').select();
						$('#garanteID').val("");
						$('#nombreGarante').val("");
						inicializaForma('formaGenerica','garanteID');
					}
				}else{
					mensajeSis("No Existe el Garante");
					$('#garanteID').focus();
					$('#garanteID').select();
					$('#garanteID').val("");
					$('#nombreGarante').val("");
					inicializaForma('formaGenerica','garanteID');
				}
			});
		}
	}

	function consultaGaranteFisica(numgarante1, tipoTransaccion, cuentasPersonaBean) {
		var congarante = 1;
		var numgarante = $('#garanteRelacion').val();
	    var cadenaDomicilio=' ';
		setTimeout("$('#cajaLista').hide();", 200);

		if (numgarante1 != '' && numgarante1 != '0' && !isNaN(numgarante1)) {

			if (numgarante > 0) {
				deshabilitaControl('titulo');
			 garantesServicio.consulta(congarante,numgarante1,{
					async : false,
					callback : function(garante) {
						if (garante != null) {
							listaPersBloqBean = consultaListaPersBloq(numgarante, esGarante, 0, 0);
							if (listaPersBloqBean.estaBloqueado != 'S') {
								if(garante.tipoPersona!=catTipoPersonaJuridica.moral){
							       limpiaFormaCompleta('formaGenerica', true, ['garanteRelacion','nombreGaranteRel','garanteID','avalID','nombreGarante','nombreAval','avalRelacion',
							       	                                           'numCliente', 'nombreCliente', 'sucursalID', 'nombreSucursal', 'directivoID','consejoAdmon',
							       	                                           'esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos','cargoID',
							       	                                           'esSolicitante', 'esAutorizador', 'esAdministrador']);
	
									$('#datosPersonaFisica').show(500);
									$('#domicilioOficialPM').hide(500);
									$('#identificacionDiv').show(500);
									$('#nacionalidadDiv').show(500);
	
	                                $('#esApoderado').attr('readOnly', false);
	                                $('#esAccionista').attr('readOnly', false);
	
	                               	$('#avalRelacion').val("0");
									$('#numeroCte').val("0");
									$('#nombreGaranteRel').val(garante.nombreCompleto);
									$('#paisNacimiento').val(garante.lugarNacimiento);
	
									$('#edoNacimiento').val(garante.estadoID);
									$('#nacion').val(garante.nacionalidad);
									$('#ocupacionC').val("");
									$('#FEA').val(garante.FEA);
									$('#paisFea').val(garante.paisFEA);
									consultaPaisFea('paisFEA');
	
									$('#titulo').val(garante.titulo);
									$('#puestoA').val(garante.puesto);
									$('#tipoPersona').val('F');
									ajustaComboTipAccionista(1);
	
									$('#primerNombre').val(garante.primerNombre);
									$('#segundoNombre').val(garante.segundoNombre);
									$('#tercerNombre').val(garante.tercerNombre);
									$('#apellidoPaterno').val(garante.apellidoPaterno);
									$('#apellidoMaterno').val(garante.apellidoMaterno);
									$('#fechaNacimiento').val(garante.fechaNacimiento);
									$('#estadoCivil').val(garante.estadoCivil);
									$('#sexo').val(garante.sexo);
	
									$('#CURP').val(garante.curp);
									$('#RFC').val(garante.rfc);
	
								    $('#ocupacionID').val(garante.ocupacionID);
									$('#sectorGeneral').val(garante.sectorGeneral);
									$('#actividadBancoMX').val(garante.actividadBancoMX);
									$('#actividadINEGI').val(garante.actividadINEGI);
									$('#sectorEconomico').val(garante.sectorEconomico);
									$('#tipoIdentiID').val(garante.tipoIdentiID);
									$('#numIdentific').val(garante.numIdentific);
									$('#fecExIden').val(garante.fecExIden);
									$('#fecVenIden').val(garante.fecVenIden);
									$('#telefonoCelular').val(garante.telefonoCelular);
									$('#correo').val(garante.correo);
									cadenaDomicilio = "CALLE: " +garante.calle+ " NÚMERO:"+garante.numeroCasa+' CODIGO POSTAL:'+garante.CP;
	
									$('#domicilio').val(cadenaDomicilio);
									$('#telefonoCasa').val(garante.telefono);
									$('#extTelefonoPart').val(garante.extTelefonoPart);
									$('#telefonoCelular').val(garante.telefonoCelular);
									$('#correo').val(garante.correo);
	
									$('#paisResidencia').val(garante.paisResidencia);
									$('#razonSocial').val(garante.razonSocial);
									$('#fax').val(garante.fax);
	
									if(calculaEdad(garante.fechaNacimiento)){
										dwr.util.setValues(garante);
									}
	
	
									if (garante.nacion == 'N') {
										$('tr[name=extranjero]').hide(500);
									} else {
										$('tr[name=extranjero]').show(500);
										var cteExtBeanCon = {
											'clienteID' : garante.numero
										};
										var consultaCliExtranjeroPrincipal = 1;
	
									}
	
									selectNacion = garante.nacion;
									if (selectNacion == null) {
										selectNacion = '';
									}
	
									if (garante.fechaNacimiento == '1900-01-01' || garante.fechaNacimiento == '0000-00-00') {
										$('#fechaNacimiento').val('');
									}
	
									validaNacionalidadCte();
									consultaPais('paisResidencia', false);
									consultaPais('paisNacimiento', false);
	
									if (garante.lugarNacimiento == '700') {
										$('#paisRFC').val('700');
									}
									consultaPais('paisRFC', false);
									consultaOcupacion('ocupacionID');
	
									esMenorEdad = garante.esMenorEdad;
									if (garante.esMenorEdad == 'N') {
										consultaIdenCliente(garante.numero);
									}
	
									consultaEstadoDatosP('edoNacimiento');
									$('#cargoID').focus();
	
									soloLEcturaFomCuentas();
	
									$('#razonSocial').val(garante.razonSocial);
									$('#sectorGeneral').val(garante.sectorGeneral);
									$('#actividadBancoMX').val(garante.actividadBancoMX);
									$('#actividadINEGI').val(garante.actividadINEGI);
									$('#sectorEconomico').val(garante.sectorEconomico);
									consultaActividadBMX('actividadBancoMX');
									consultaSecGeneral('sectorGeneral');
									consultaDireccion('avalRelacion');
	
								}else{
									$('#garanteRelacion').focus();
									mensajeSis("El Garante Es Persona Moral.");
									$('#garanteRelacion').val("");
									$('#nombreGaranteRel').val("");
	
	
								}
							
							} else {
								mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
								$('#garanteRelacion').val('');
								$('#nombreGaranteRel').val('');
							}
							// si no existe el Cliente
						} else {
							$('#garanteRelacion').focus();
							mensajeSis("El garante no Existe");
							$('#garanteRelacion').val('');
							$('#nombreGaranteRel').val('');
						}
						}
					});

		}

		}else {

			validaLimpiarFormulario('G');
		}
	}

	function consultaActividadBMX(idControl) {
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numActividad != '' && !isNaN(numActividad)) {
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividad, function(actividadComp) {
				if (actividadComp != null) {
					$('#descripcionBMX').val(actividadComp.descripcionBMX);
					$('#actividadINEGI').val(actividadComp.actividadINEGIID);
					$('#descripcionINEGI').val(actividadComp.descripcionINE);
					$('#sectorEconomico').val(actividadComp.sectorEcoID);
					$('#descripcionSE').val(actividadComp.descripcionSEC);
				} else {
					mensajeSis("No Existe la Actividad BMX");
					$('#descripcionBMX').val('');
					$('#actividadINEGI').val('');
					$('#descripcionINEGI').val('');
					$('#sectorEconomico').val('');
					$('#descripcionSE').val('');
				}
			});
		} else {
			$('#descripcionBMX').val('');
			$('#actividadINEGI').val('');
			$('#descripcionINEGI').val('');
			$('#sectorEconomico').val('');
			$('#descripcionSE').val('');
		}
	}

	function consultaSecGeneral(idControl) {
		var jqSecG = eval("'#" + idControl + "'");
		var numSec = $(jqSecG).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var sectoresBeanCon = {
			'sectorID' : numSec
		};
		if (numSec != '' && !isNaN(numSec)) {
			sectoresServicio.consulta(tipConForanea, sectoresBeanCon, function(sector) {
				if (sector != null) {
					$('#sectorGral').val(sector.descripcion);
				} else {
					mensajeSis("No Existe el Sector");
					$('#sectorGral').val('');
				}
			});
		} else {
			$('#sectorGral').val('');
		}
	}

	function consultaNumeroCaracteresTipoIdent(numTipoIden) {
		var tipConPrincipal = 1;

		setTimeout("$('#cajaLista').hide();", 200);
		if (numTipoIden != '' && !isNaN(numTipoIden) && $('#avalRelacion').asNumber() == 0 && numTipoIden > 0) {

			tiposIdentiServicio.consulta(tipConPrincipal, numTipoIden, function(tipIdentificacion) {
				if (tipIdentificacion != null) {
					$('#numeroCaracteres').val(tipIdentificacion.numeroCaracteres);
				} else {
					$('#tipoIdentiID').focus();
					mensajeSis("No Existe la Identificación");

				}
			});
		}
	}// fin de la funcion consultaNumeroCaracteresTipoIdent

	function consultaIdenCliente(numCliente) {
		var identificacionCliente = {
			'clienteID' : numCliente
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			identifiClienteServicio.consulta(3, identificacionCliente, function(identificacion) {
				if (identificacion != null) {
					$('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
					$('#numIdentific').val(identificacion.numIdentific);
					$('#fecExIden').val(identificacion.fecExIden);
					$('#fecVenIden').val(identificacion.fecVenIden);
					selectTipoIdenti = identificacion.tipoIdentiID;
					if (selectTipoIdenti == null) {
						selectTipoIdenti = '';
					}
					if (identificacion.fecExIden == '1900-01-01' || identificacion.fecExIden == '0000-00-00') {
						$('#fecExIden').val('');
					}
					if (identificacion.fecVenIden == '1900-01-01' || identificacion.fecVenIden == '0000-00-00') {
						$('#fecVenIden').val('');
					}

					consultaNumeroCaracteresTipoIdent(identificacion.tipoIdentiID);

				} else {
					selectTipoIdenti = '';
					limpiaFormaCompleta('formaGenerica', true, ['garanteID','avalID','nombreGarante','nombreAval','numCliente',
					                                            'nombreCliente', 'sucursalID', 'nombreSucursal', 'directivoID','avalRelacion',
					                                            'consejoAdmon','esApoderado','esAccionista','esPropReal', 'ingreRealoRecursos',
					                                            'esSolicitante', 'esAutorizador', 'esAdministrador']);
					mensajeSis('El Cliente no tiene una Identificación Oficial Capturada');

					$('#numeroCte').focus();
					$('#numeroCte').select();
				}
			});
		}
	}

	function consultaDireccion(idControl) {
		var jqCliente = eval("'#" + idControl + "'");

		var numCliente = $(jqCliente).val();
		var direccionCliente = {
			'clienteID' : numCliente,
			'direccionID' : 0,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficialDirec, direccionCliente, function(direccion) {
				if (direccion != null) {
					$("domicilio").val(direccion.domicilio);
				}
			});
		}
	}

	function consultaDireccionOficial(idControl){
		var jqCliente = eval("'#" + idControl + "'");

		var numCliente = $(jqCliente).val();
		var direccionCliente = {
			'clienteID' : numCliente,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficialDirec, direccionCliente, function(direccion) {
				if (direccion != null) {
					var direcOficial = {
						'clienteID' : numCliente,
						'direccionID' : direccion.direccionID
					};
					direccionesClienteServicio.consulta(catTipoConsultaDirCliente.principal, direcOficial, function(direccionExt) {
						if(direccionExt != null){
							if(direccionExt.paisIDDom == 0) {
								$('#paisIDDom').val('700');
							} else {
								$('#paisIDDom').val(direccionExt.paisID);
							}
							$('#estadoIDDom').val(direccionExt.estadoID);
							$('#municipioIDDom').val(direccionExt.municipioID);
							$('#localidadIDDom').val(direccionExt.localidadID);
							$('#coloniaIDDom').val(direccionExt.coloniaID);
							$('#nombreColonia').val('');
							$('#nombreCiudadDom').val('');
							$('#calleDom').val(direccionExt.calle);
							$('#numExteriorDom').val(direccionExt.numeroCasa);
							$('#numInteriorDom').val(direccionExt.numInterior);
							$('#pisoDom').val(direccionExt.piso);
							$('#primeraEntreDom').val(direccionExt.primEntreCalle);
							$('#segundaEntreDom').val(direccionExt.segEntreCalle);
							$('#codigoPostalDom').val(direccionExt.CP);
							$('#domicilioCompleto').val(direccionExt.direccionCompleta);
							consultaPaisDir();
							consultaEdoDir();
							consultaMunDom();
							consultaLocalidadDom();
							consultaColoniaDom();
						}
					});
				}
			});
		}

	}

	function consultaPais(idControl, origenInput) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var idControlNomPais = '';
		if (idControl == 'paisResidencia') {
			idControlNomPais = 'paisR';
		} else if (idControl == 'paisConstitucionID') {
			idControlNomPais = 'descPaisConst';
		} else if (idControl == 'paisNacimiento') {
			idControlNomPais = 'paisNac';
		} else if (idControl == 'paisRFC') {
			idControlNomPais = 'NomPaisRFC';
		} else if (idControl == 'paisFea') {
			idControlNomPais = 'paisF';
		} else if (idControl == 'paisFeaPM') {
			idControlNomPais = 'paisFPM';
		} else if (idControl == 'paisCompania') {
			idControlNomPais = 'nomPaisCompania';
		}

		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais, function(pais) {
				if (pais != null) {
					$('#' + idControlNomPais).val(pais.nombre);
					if (idControlNomPais == 'paisNac') {
						if (Number(pais.paisID) != 700) {
							$('#edoNacimiento').val(0);
							deshabilitaControl('edoNacimiento');
							consultaEstadoDatosP('edoNacimiento');
						} else {
							if (origenInput) {
								$('#edoNacimiento').focus();
								$('#edoNacimiento').val('');
								$('#nomEdoNacimiento').val('');
								habilitaControl('edoNacimiento');
							}
							consultaEstadoDatosP('edoNacimiento');
						}
					}

				} else {
					mensajeSis("No Existe el País");
					$(jqPais).val('');
					$(jqPais).focus();
					$('#' + idControlNomPais).val('');
					if (idControlNomPais == 'paisNac') {
						$('#edoNacimiento').val('');
						$('#nomEdoNacimiento').val('');
					}
				}
			});
		}

	}

	function consultaPaisFea(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais, function(pais) {
				if (pais != null) {
					$('#paisF').val(pais.nombre);
					$('#paisFPM').val(pais.nombre);
				} else {

					$('#paisFeaPM').val('');
					$('#paisFPM').val('');
					$('#paisFea').val('');
					$('#paisF').val('');

				}
			});
		}
		if (numPais == 0 || numPais == '') {
			$('#paisFeaPM').val('');
			$('#paisFPM').val('');
			$('#paisFea').val('');
			$('#paisF').val('');

		}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea, numEstado, {
			async : false,
			callback : function(estado) {
				if (estado != null) {
					$('#nombreEstado').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado");
					$(jqEstado).focus();
					$('#nombreEstado').val('');
				}
			}
			});
		}
	}

	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado = "";
		var tipConForanea = 2;
		var idNombre = '';

		if (idControl == 'municipioID') {
			idNombre = 'nombreMuni';
			numEstado= $('#estadoID').val();
		} else if (idControl == 'munNacimiento') {
			idNombre = 'nomMunNacimiento';
			numEstado= $('#edoNacimiento').val();
		}

		setTimeout("$('#cajaLista').hide();", 200);

		if (numMunicipio != '' && !isNaN(numMunicipio) && (numMunicipio > 0)) {
			municipiosServicio.consulta(tipConForanea, numEstado, numMunicipio, {
			async : false,
			callback : function(municipio) {
				if (municipio != null) {
					$('#' + idNombre).val(municipio.nombre);
				} else {
					mensajeSis("No Existe el Municipio");
					$(jqMunicipio).focus();
					$('#' + idNombre).val("");
				}
			}
			});
		}
	}

	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#munNacimiento').val();
		var numEstado =  $('#edoNacimiento').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLocalidad != '' && !isNaN(numLocalidad)){
			if(numEstado != '' && numMunicipio !=''){
				localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
					if(localidad!=null){
						$('#nomLocalidad').val(localidad.nombreLocalidad);
						$('#nombreCiudad').val(localidad.nombreLocalidad);
					}else{
						mensajeSis("No Existe la Localidad");
						$('#nomLocalidad').val("");
						$('#locNacimiento').val("");
						$('#locNacimiento').focus();
						$('#locNacimiento').select();
					}
				}});
			}else{
				if(numEstado == ''){
					mensajeSis("Especificar Estado");
					$('#edoNacimiento').focus();
				}else{
					mensajeSis("Especificar Municipio");
					$('#munNacimiento').focus();
				}
			}

		}
	}

	function consultaSucursal(numeroSucursal) {

		var numSucursal = numeroSucursal;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(2, numSucursal, function(sucursal) {
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

	//consulta Colonia y CP
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();
		var numEstado =  $('#edoNacimiento').val();
		var numMunicipio =	$('#munNacimiento').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
				if(colonia!=null){
					$('#nomColoniaID').val(colonia.asentamiento);
					$('#codigoPostal').val(colonia.codigoPostal);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nomColoniaID').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
				}
			}});
		}else{
			$('#nomColoniaID').val("");
		}
	}


	function consultaNotaria(idControl) {
		var jqNotaria = eval("'#" + idControl + "'");
		var numNotaria = $(jqNotaria).val();
		var tipConForanea = 2;
		var notariaBeanCon = {
		'estadoID' : $('#estadoID').val(),
		'municipioID' : $('#municipioID').val(),
		'notariaID' : numNotaria
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if (numNotaria != '' && !isNaN(numNotaria)) {
			notariaServicio.consulta(tipConForanea, notariaBeanCon, {
			async : false,
			callback : function(notaria) {
				if (notaria != null) {
					$('#titularNotaria').val(notaria.titular);
					$('#direccion').val(notaria.direccion);
				} else {
					mensajeSis("El Número de Notaria No Existe");
					$('#titularNotaria').val('');
					$('#direccion').val('');
					$('#notariaID').val('');
					$('#' + idControl).focus();
					$('#' + idControl).select();
				}
			}
			});
		}
	}

	function consultaParentesco(idControl, dato) {
		var numParentesco = dato;
		var jqParentesco = "";
		if (dato == '') {
			jqParentesco = eval("'#" + idControl + "'");
			numParentesco = $(jqParentesco).val();
		}
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var ParentescoBean = {
			'parentescoID' : numParentesco
		};
		if (numParentesco != '' && !isNaN(numParentesco) && esTab) {
			parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
				if (parentesco != null) {
					$('#parentesco').val(parentesco.descripcion);
				} else {
					mensajeSis("No Existe el Parentesco");
					if (dato == '') {
						$(jqParentesco).focus().select();
					}
				}
			});
		}
	}

	function consultaClientePantalla(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 5;
		var rfc = ' ';
		esTab = true;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(conCliente, numCliente, rfc, {
			async : false,
			callback : function(cliente) {
				if (cliente != null) {
					listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
					if (listaPersBloqBean.estaBloqueado != 'S') {
						var tipo = (cliente.tipoPersona);
						if (tipo == "F") {
							$('#nombreCliente').val(cliente.nombreCompleto);;
							$('#tipoPer').val("FÍSICA");
							$('#tipoPersona').val("F");
						}
						if (tipo == "M") {
							$('#nombreCliente').val(cliente.razonSocial);
							$('#tipoPer').val("MORAL");
							$('#tipoPersona').val("M");
						}
						if (tipo == "A") {
							$('#nombreCliente').val(cliente.nombreCompleto);;
							$('#tipoPer').val("FÍSICA CON ACT. EMP.");
							$('#tipoPersona').val("F");
	
							}
						} else {
						mensajeSis('No es posible completar el registro, esta persona hizo coincidencia con la Listas de Personas Bloqueadas');
						$(jqCliente).focus();
					}
				} else {
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
				}
			}
			});
		}
	}

	function consultaClienteRelacion(idControl) {
		var numCliente = idControl;
		var conCliente = 5;
		var rfc = ' ';

		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(conCliente, numCliente, rfc, {
			async : false,
			callback : function(cliente) {
				if (cliente != null) {
					var tipo = (cliente.tipoPersona);
					if (tipo == "M") {
						$('#tipoPersona').val("M");
					} else {
						$('#tipoPersona').val("F");

					}

				}
			}
			});
		}
	}

	function validaNacion(idControl) {
		var jqNacion = eval("'#" + idControl + "'");
		var valNacion = $(jqNacion).val();
		var nacional = 'N';

		if (valNacion == nacional) {
			deshabilitaControl('paisResidencia');
		}
		if (valNacion == 'E') {

		}
	}

	function validaNacionalidadCte() {
		var nacionalidad = $('#nacion').val();
		var pais = $('#paisNacimiento').val();
		var mexico = '700';
		var nacdadMex = 'N';
		var nacdadExtr = 'E';

		if (nacionalidad == nacdadMex) {
			$('tr[name=extranjero]').hide(500);

			if (pais != mexico) {
				mensajeSis("Por la Nacionalidad de la Persona el País debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
			}
		}
		if (nacionalidad == nacdadExtr) {
			$('tr[name=extranjero]').show(500);

			if (pais == mexico) {
				mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
			}
		}
	}

	function consultaOcupacion(idControl) {
		if (esTab) {
			var jqOcupacion = eval("'#" + idControl + "'");
			var numOcupacion = $(jqOcupacion).val();
			var tipConForanea = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			if (numOcupacion != '' && !isNaN(numOcupacion) && numOcupacion > 0) {
				ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
					if (ocupacion != null) {
						$('#ocupacionC').val(ocupacion.descripcion);
					} else {
						mensajeSis("No Existe la Ocupación.");
						$('#ocupacionC').val('');
						$('#ocupacionID').focus();
					}
				});
			} else {
				$('#ocupacionID').val('0');
				$('#ocupacionC').val('');
			}
		}

	}

	function consultaEscritura(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var jqEscritura = eval("'#" + idControl + "'");
		var numEscritura = $(jqEscritura).val();
		var tipConPoderes = 4;
		var numCliente = $('#numCliente').val();
		var numEscPublica = $('#numEscPub').val();

		var EscrituraBeanCon = {
			'clienteID' : numCliente,
			'escrituraPub':numEscPublica
		};
		if (numCliente != '' && Number($('#numEscPub').val()) != 0 && esTab) {
			escrituraServicio.consulta(tipConPoderes, EscrituraBeanCon, {
			async : false,
			callback : function(escritura) {
				if (escritura != null) {

					$('#numEscPub').val(escritura.escrituraPub);
					$('#municipioID').val(escritura.localidadEsc);
					$('#notariaID').val(escritura.notaria);
					$('#escDireccion').show();
					$('#titularNotaria').val(escritura.nomNotario);
					$('#direccion').val(escritura.direcNotaria);
					$('#fechaEscPub').val(escritura.fechaEsc);
					$('#estadoID').val(escritura.estadoIDEsc);

					consultaEstado('estadoID');
					consultaMunicipio('municipioID');
					if ($('#fechaEscPub').val() == '1900-01-01' || $('#fechaEscPub').val() == '0000-00-00') {
						$('#fechaEscPub').val('');
					}
				} else {
					if ($('#numeroCte').asNumber() > 0) {
						mensajeSis("La Escritura Pública No Existe");
						$('#numEscPub').focus();

						$('#numEscPub').val('');
						limpiaCamposEscritura();
					} else {
						habilitaCamposEscritura();
					}
					if ($('#directivoID').asNumber() > 0) {
						// si es mayor a 0 entonces se esta consultando por lo tanto no limpiamos campos
					} else {
						limpiaCamposEscritura();
					}
				}
			}
			});
		}
	}
	function consultaGEmpres(idControl) {
		var jqGempresa = eval("'#" + idControl + "'");
		var numGempresa = $(jqGempresa).val();
		var conGempresa = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numGempresa != '' && !isNaN(numGempresa) && numGempresa > 0) {
			gruposEmpServicio.consulta(conGempresa, numGempresa, function(empresa) {
				if (empresa != null) {
					$('#descripcionGE').val(empresa.nombreGrupo);
				} else {
					if ($('#grupoEmpresarial').val() > '0') {
						mensajeSis("No Existe el Grupo.");
						$('#grupoEmpresarial').focus();
						$('#descripcionGE ').val('');
					}
				}
			});
		} else {
			$('#descripcionGE').val('');
			$('#grupoEmpresarial').val('0');
		}
	}

	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();

		var SociedadBeanCon = {
			'tipoSociedadID' : numSociedad
		};
		if (numSociedad != '' && !isNaN(numSociedad)) {
			tipoSociedadServicio.consulta(catTipoConsultaSociedad.foranea, SociedadBeanCon, function(sociedad) {
				if (sociedad != null) {
					$('#descripSociedad').val(sociedad.descripcion);
				} else {
					var tp = $('#tipoPersona').val();
					if (tp == 'M') {
						mensajeSis("No Existe el Tipo de Sociedad.");
					}
				}
			});
		}
	}

	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var tn = $('#tercerNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
		'primerNombre' : nc,
		'apellidoPaterno' : $('#apellidoPaterno').val(),
		'apellidoMaterno' : $('#apellidoMaterno').val(),
		'fechaNacimiento' : $('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {
				$('#RFC').val(cliente.RFC);
			}
		});
	}

	function consultaTipoIden() {
		dwr.util.removeAllOptions('tipoIdentiID');
		dwr.util.addOptions('tipoIdentiID', {
			'' : 'SELECCIONAR'
		});
		dwr.util.addOptions('tipoIdentiID', {
			0 : 'OTRA'
		});
		tiposIdentiServicio.listaCombo(3, function(tIdentific) {
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});
	}

	// Verifica que tipo de persona esta seleccionada para asicmostrar los divs correspondientes
	function tipoPersonaSeleccionada(esApoderado, esAccionista, consejoAdmon, esRepLegal, esSolicitante, esAutorizador, esAdministrador) {
		if (esAccionista == 'S') {
				$('#infoAccionista').show();
				$('#esAccionista').val("S");
		} else {
			$('#esAccionista').val("N");
			$('#porcentajeAccion').val("0.00");
			$('#valorAcciones').val("0.00");
			$('#infoAccionista').hide();
		}
		if (esApoderado == 'N') {
			$('#escritura').hide();
			$('#esApoderado').val("N");
			limpiaCamposEscritura();

		} else {
			$('#escritura').show();
			var numeroCliente = $('#numeroCte').val();
			if (numeroCliente == 0) {
				habilitaCamposEscritura();
			}
			$('#esApoderado').val("S");
		}

		if (esRepLegal == 'S') {
			$('#esPropReal').val("S");
		} else {
			$('#esPropReal').val("N");
		}

		if (consejoAdmon == 'S') {
			$('#consejoAdmon').val("S");
		} else {
			$('#consejoAdmon').val("N");
		}

		if (esSolicitante == 'S') {
			$('#esSolicitante').val("S");
		} else {
			$('#esSolicitante').val("N");
		}
		if (esAutorizador == 'S') {
			$('#esAutorizador').val("S");
		} else {
			$('#esAutorizador').val("N");
		}
		if (esAdministrador == 'S') {
			$('#esAdministrador').val("S");
		} else {
			$('#esAdministrador').val("N");
		}

	}

	function tipoPersonaSeleccionadaCheck() {
		if ($('#esAccionista').attr('checked')) {
				$('#infoAccionista').show();
				$('#esAccionista').val("S");
		} else {
			$('#esAccionista').val("N");
			$('#porcentajeAccion').val("0.00");
			$('#valorAcciones').val("0.00");
			$('#infoAccionista').hide();
		}
		if ($('#esApoderado').attr('checked') == false) {
			$('#escritura').hide();
			$('#esApoderado').val("N");
			limpiaCamposEscritura();

		} else {
			$('#escritura').show();
			var numeroCliente = $('#numeroCte').val();
			if (numeroCliente == 0) {
				habilitaCamposEscritura();
			}else{
				habilitaControl('numEscPub');
			}
			$('#esApoderado').val("S");
		}
		if ($('#esPropReal').attr('checked')) {
			$('#esPropReal').val("S");
		} else {
			$('#esPropReal').val("N");
		}

		if ($('#consejoAdmon').attr('checked')) {
			$('#consejoAdmon').val("S");
		} else {
			$('#consejoAdmon').val("N");
		}

		if($('#esSolicitante').attr('checked')) $('#esSolicitante').val("S");
		else $('#esSolicitante').val("N");

		if($('#esAutorizador').attr('checked')) $('#esAutorizador').val("S");
		else $('#esAutorizador').val("N");

		if($('#esAdministrador').attr('checked')) $('#esAdministrador').val("S");
		else $('#esAdministrador').val("N");
	}

	//  le quita el check a todos los tipos de Personas
	function quitaTipoPersonaSeleccionada() {
		// quitamos todos los que estan seleccionados y ocultamos divs
		$('#esApoderado').attr('checked', false);
		$('#consejoAdmon').attr('checked', false);

		$('#esSolicitante').attr('checked', false);
		$('#esAutorizador').attr('checked', false);
		$('#esAdministrador').attr('checked', false);

		$('#esTitular').attr('checked', false);
		$('#esCotitular').attr('checked', false);
		$('#esProvRecurso').attr('checked', false);
		$('#esPropReal').attr('checked', false);
		$('#esFirmante').attr('checked', false);
		$('#esBeneficiario').attr('checked', false);

		$('#miscelaneos').hide();
		$('#escritura').hide();
		$('#beneficiarios').hide();
	}
	function consultaIdentificacionSeleccionada() {
		if ($('#tipoIdentiID').val() == 0) {
			$("#lbIOtradentificacion").show();
			$("#otraIdentifi").show();
		} else {
			$("#lbIOtradentificacion").hide();
			$("#otraIdentifi").hide();
			$("#otraIdentifi").val('');
		}
	}

	function calculaEdad(fecha) {
		if (fecha < parametroBean.fechaAplicacion) {
			var fechaNac = (fecha).split('-');
			var fechaActual = (parametroBean.fechaAplicacion).split('-');
			var anioNac = fechaNac[0];
			var anioAct = fechaActual[0];
			var mesNac = fechaNac[1];
			var mesAct = fechaActual[1];
			var diaNac = fechaNac[2];
			var diaAct = fechaActual[2];
			var anios = anioAct - anioNac;

			if (mesAct < mesNac) {
				anios = anios - 1;
			}
			if (mesAct = mesNac) {
				if (diaAct < diaNac) {
					anios = anios - 1;
				}
			}
			if (anios < 18) {
				esMenorEdad = 'S';

			} else {
				esMenorEdad = 'N';
			}
		} else {
			mensajeSis("La Fecha de Nacimiento es Mayor a la del Sistema");
			$('#fechaNacimiento').focus();
			$('#fechaNacimiento').val('');
		}
	}

	//funcion para mostrar u ocultar “Ingresos Propietario Real o Proveedor de Recursos
	function ocultaIngresosRealoRecursos() {
		if (($('#esProvRecurso').is(':checked')) || ($('#esPropReal').is(':checked'))) {
			$('#trIngresoRealoRecursos').show();
		} else {
			$('#trIngresoRealoRecursos').hide();
		}
	}

	function validarPorcentaje(controlID, valor) {
		var porcentajeAcciones = $('#porcentajeAccion').asNumber();
		var porcentajeAccionesVal = $('#porcentajeAccion').val();
		if (porcentajeAccionesVal != '' && porcentajeAccionesVal != NaN ){
			if(porcentajeAcciones <= 0){
				$('#porcentajeAccion').val('');
				mensajeSis('El Porcentaje de las acciones debe ser mayor a CERO');
				$('#porcentajeAccion').focus();

			}else if(porcentajeAcciones > 100.00){
				$('#porcentajeAccion').val('');
				mensajeSis('El Porcentaje de las acciones no debe ser mayor a 100');
				$('#porcentajeAccion').focus();
			}
		}
	}

	function asignaPorcentaje(controlID, valor) {

		/*if (isNaN(parseFloat(valor))) {
			$('#' + controlID).focus();
			$('#' + controlID).val('');
		} else {*/
			$('controlID').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
			});
			$('#porcentajeAccion').val(valor);
	//	}
	}

});

//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
//PRIMER PARAMETRO ID BOTON CURP
//SEGUNDO PARAMETRO ID BOTON RFC
//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
function permiteCalcularCURPyRFC(idBotonCURP, idBotonRFC, tipo) {
	var jqBotonCURP = eval("'#" + idBotonCURP + "'");
	var jqBotonRFC = eval("'#" + idBotonRFC + "'");
	var numEmpresaID = 1;
	var tipoCon = 17;
	var ParametrosSisBean = {
		'empresaID' : numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, {
	async : false,
	callback : function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			//Validacion para mostrarar boton de calcular CURP Y RFC
			if (parametrosSisBean.calculaCURPyRFC == 'S') {
				if (tipo == 3) {
					$(jqBotonCURP).show();
					$(jqBotonRFC).show();
				} else {
					if (tipo == 1) {
						$(jqBotonCURP).show();
					} else {
						if (tipo == 2) {
							$(jqBotonRFC).show();
						}
					}
				}
			} else {
				if (tipo == 3) {
					$(jqBotonCURP).hide();
					$(jqBotonRFC).hide();
				} else {
					if (tipo == 1) {
						$(jqBotonCURP).hide();
					} else {
						if (tipo == 2) {
							$(jqBotonRFC).hide();
						}
					}
				}
			}
		}
	}
	});
}

function formaCURP() {
	var sexo = $('#sexo').val();
	var nacionalidad = $('#paisNacimiento').val();
	if (sexo == "M") {
		sexo = "H";
	} else if (sexo == "F") {
		sexo = "M";
	} else {
		sexo = "H";
		mensajeSis("Especifique el Género");
	}

	if (nacionalidad == "700") {
		nacionalidad = "N";
	} else if (nacionalidad != "") {
		nacionalidad = "S";
	} else {
		nacionalidad = "N";
		mensajeSis("Especifique el País de Nacimiento");
	}
	var CURPBean = {
	'primerNombre' : $('#primerNombre').val(),
	'segundoNombre' : $('#segundoNombre').val(),
	'tercerNombre' : $('#tercerNombre').val(),
	'apellidoPaterno' : $('#apellidoPaterno').val(),
	'apellidoMaterno' : $('#apellidoMaterno').val(),
	'sexo' : sexo,
	'fechaNacimiento' : $('#fechaNacimiento').val(),
	'nacion' : nacionalidad,
	'estadoID' : $('#edoNacimiento').val()

	};
	clienteServicio.formaCURP(CURPBean, function(cliente) {
		if (cliente != null) {
			$('#CURP').val(cliente.CURP);
		}
	});
}

function consultaEstadoDatosP(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado != '' && !isNaN(numEstado)) {
		estadosServicio.consulta(tipConForanea, numEstado, function(estado) {
			if (estado != null) {
				var p = $('#paisNacimiento').val();
				if (p == 700 && estado.estadoID == 0 && esTab) {
					mensajeSis("No Existe el Estado");
					$('#edoNacimiento').focus();
				}
				$('#nomEdoNacimiento').val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado");
				$('#nomEdoNacimiento').val('');
			}
		});
	}
}

function valoresListaEscPub(valor, valor2) {
	cargaValorLista('numEscPub', valor);
	cargaValorLista('fechaEscPub', valor2);
}

function activarDesRadios(esApoderado, esAccionista,consejoAdmon, esRepLegal, esSolicitante, esAutorizador, esAdministrador) {
	if (esApoderado == 'S') {
		$('#esApoderado').attr("checked", true);
		$('#esApoderado').val("S");
		var clienteID = $('#numeroCte').val();
		if (clienteID != 0) {
			deshabilitaCamposEscritura();
		}

	} else {
		$('#esApoderado').attr("checked", false);
		$('#esApoderado').val("N");
	}


	if (esRepLegal == 'S') {
		$('#esPropReal').attr("checked", true);
		$('#esPropReal').val("S");

	} else {
		$('#esPropReal').attr("checked", false);
		$('#esPropReal').val("N");
	}

	if (consejoAdmon == 'S') {
		$('#consejoAdmon').attr("checked", true);
		$('#consejoAdmon').val("S");

	} else {
		$('#consejoAdmon').attr("checked", false);
		$('#consejoAdmon').val("N");
	}

	if(esSolicitante == 'S') {
		$('#esSolicitante').attr('checked', true);
		$('#esSolicitante').val("S")
	} else {
		$('#esSolicitante').attr("checked", false);
		$('#esSolicitante').val("N");
	}

	if(esAutorizador == 'S') {
		$('#esAutorizador').attr('checked', true);
		$('#esAutorizador').val("S")
	} else {
		$('#esAutorizador').attr("checked", false);
		$('#esAutorizador').val("N");
	}

	if(esAdministrador == 'S') {
		$('#esAdministrador').attr('checked', true);
		$('#esAdministrador').val("S")
	} else {
		$('#esAdministrador').attr("checked", false);
		$('#esAdministrador').val("N");
	}

	if (esAccionista == 'S') {
		$('#esAccionista').attr("checked", true);
		$('#esAccionista').val("S");
		$('#infoAccionista').show();
	}else{
		$('#esAccionista').attr("checked", false);
		$('#esAccionista').val("N");
		$('#infoAccionista').hide();
	}
}





function checaPropietarioReal(esPropReal){
	if (esPropReal == 'S') {
		$('#esPropReal').attr("checked", true);
		$('#esPropReal').val("S");

	} else {
		$('#esPropReal').attr("checked", false);
		$('#esPropReal').val("N");
	}
}

function desactivarRadiosOcultaDivs() { // menos titular y div de miselaneos(Es el default)
	$('#esApoderado').attr("checked", false);
	$('#esAccionista').attr("checked", false);
	$('#esPropReal').attr("checked", false);
	$('#esSolicitante').attr("checked", false);
	$('#esAutorizador').attr("checked", false);
	$('#esAdministrador').attr("checked", false);
}
function deshabilitaCamposEscritura() {
	$('#fechaEscPub').attr('readOnly', true);
	$('#estadoID').attr('readOnly', true);
	$('#municipioID').attr('readOnly', true);
	$('#notariaID').attr('readOnly', true);
	$('#direccion').attr('readOnly', true);
	$('#numEscPub').attr('readOnly', false);
	deshabilitaControl('fechaEscPub');
	deshabilitaControl('estadoID');
	deshabilitaControl('municipioID');
	deshabilitaControl('notariaID');
	deshabilitaControl('direccion');

}
function habilitaCamposEscritura() {
	$('#fechaEscPub').attr('readOnly', false);
	$('#estadoID').attr('readOnly', false);
	$('#municipioID').attr('readOnly', false);
	$('#notariaID').attr('readOnly', false);
	$('#direccion').attr('readOnly', false);
	$('#numEscPub').attr('readOnly', false);

	habilitaControl('fechaEscPub');
	habilitaControl('estadoID');
	habilitaControl('municipioID');
	habilitaControl('notariaID');
	habilitaControl('numEscPub');
}
function limpiaCamposEscritura() {
	$('#fechaEscPub').val('');
	$('#estadoID').val('');
	$('#municipioID').val('');
	$('#notariaID').val('');
	$('#nombreEstado').val('');
	$('#direccion').val('');
	$('#nombreMuni').val('');
	$('#titularNotaria').val('');
}
function limpiaPorcentaje() {
	$('#porcentajeAccion').val('');
	$('#valorAcciones').val('');
	$('#infoAccionista').hide();
}

//hoblita el formulario
function habilitaFormularioCuentaPersona() {
	habilitaControl('titulo');
	habilitaControl('estadoCivil');
	habilitaControl('sexo');
	habilitaControl('tipoIdentiID');
	habilitaControl('nacion');

	$('input[name="docEstanciaLegal"]').attr('disabled', false);
	$('#primerNombre').attr('readOnly', false);
	$('#segundoNombre').attr('readOnly', false);
	$('#tercerNombre').attr('readOnly', false);
	$('#apellidoPaterno').attr('readOnly', false);
	$('#apellidoMaterno').attr('readOnly', false);
	$('#fechaNacimiento').removeAttr('readOnly');
	$('#paisNacimiento').attr('readOnly', false);
	$('#edoNacimiento').attr('readOnly', false);
	$('#CURP').attr('readOnly', false);
	$('#RFC').attr('readOnly', false);
	$('#puestoA').attr('readOnly', false);
	$('#telefonoCelular').attr('readOnly', false);
	$('#telefonoCasa').attr('readOnly', false);
	$('#correo').attr('readOnly', false);
	$('#ocupacionID').attr('readOnly', false);
	$('#sectorGeneral').attr('readOnly', false);
	$('#actividadBancoMX').attr('readOnly', false);
	$('#numIdentific').attr('readOnly', false);
	$('#fecExIden').attr('readOnly', false);
	$('#fecVenIden').attr('readOnly', false);
	$('#domicilio').attr('readOnly', false);
	$('#paisResidencia').attr('readOnly', false);
	$('#fechaVenEst').attr('readOnly', false);
	$('#docExisLegal').attr('readOnly', false);
	$('#extTelefonoPart').attr('readOnly', false);

	$('#FEA').attr('readOnly', false);
	$('#paisFea').attr('readOnly', false);
	$('#paisF').attr('readOnly', false);
	$('#paisRFC').attr('readOnly', false);
	//miscelaneos
	$('#fax').attr('readOnly', false);

	agregaCalendario('formaGenerica');
	//Botones
	permiteCalcularCURPyRFC('generarc', 'generar', 3);
	$('#generar').removeAttr('disabled');
	$('#generarc').removeAttr('disabled');

	habilitaControl('primerNombre');
	habilitaControl('segundoNombre');
	habilitaControl('tercerNombre');
	habilitaControl('apellidoPaterno');
	habilitaControl('apellidoMaterno');
	habilitaControl('fechaNacimiento');
	habilitaControl('paisNacimiento');
	habilitaControl('edoNacimiento');
	habilitaControl('CURP');
	habilitaControl('RFC');

	habilitaControl('ocupacionID');
	habilitaControl('puestoA');
	habilitaControl('sectorGeneral');
	habilitaControl('actividadBancoMX');
	habilitaControl('numIdentific');
	habilitaControl('fecExIden');
	habilitaControl('fecVenIden');
	habilitaControl('telefonoCasa');

	habilitaControl('telefonoCelular');
	habilitaControl('correo');
	habilitaControl('domicilio');
	habilitaControl('extTelefonoPart');
	habilitaControl('paisResidencia');
	habilitaControl('fechaVenEst');
	habilitaControl('docExisLegal');
	habilitaControl('FEA');
	habilitaControl('paisFea');
	habilitaControl('paisRFC');

	habilitaControl('fax');
	habilitaControl('generar');
	habilitaControl('generarc');
}

//desactiva formulario
function soloLEcturaFomCuentas() {
	deshabilitaControl('estadoCivil');
	deshabilitaControl('sexo');
	deshabilitaControl('tipoIdentiID');
	deshabilitaControl('nacion');

	$('input[name="docEstanciaLegal"]').attr('disabled', true);

	//campos de Datos Generales de la Persona
	$('#primerNombre').attr('readOnly', true);
	$('#segundoNombre').attr('readOnly', true);
	$('#tercerNombre').attr('readOnly', true);
	$('#apellidoPaterno').attr('readOnly', true);
	$('#apellidoMaterno').attr('readOnly', true);
	$('#fechaNacimiento').attr('readOnly', true);
	$('#paisNacimiento').attr('readOnly', true);
	$('#edoNacimiento').attr('readOnly', true);
	$('#CURP').attr('readOnly', true);
	$('#RFC').attr('readOnly', true);
	$('#ocupacionID').attr('readOnly', true);
	$('#puestoA').attr('readOnly', true);
	//Campos de Actividad
	$('#sectorGeneral').attr('readOnly', true);
	$('#actividadBancoMX').attr('readOnly', true);
	//Campos de Identificacion
	$('#numIdentific').attr('readOnly', true);
	$('#fecExIden').attr('readOnly', true);
	$('#fecVenIden').attr('readOnly', true);
	$('#telefonoCasa').attr('readOnly', true);
	$('#telefonoCelular').attr('readOnly', true);
	$('#correo').attr('readOnly', true);
	$('#domicilio').attr('readOnly', true);
	$('#extTelefonoPart').attr('readOnly', true);

	//		Deshabilitacion de combos relacionados con clientes

	$('#fechaNacimiento').datepicker("destroy");
	$('#fecExIden').datepicker("destroy");
	$('#fecVenIden').datepicker("destroy");
	$('#fechaVenEst').datepicker("destroy");

	//Campos de Nacionalidads
	$('#paisResidencia').attr('readOnly', true);
	$('#fechaVenEst').attr('readOnly', true);
	$('#docExisLegal').attr('readOnly', true);

	$('#FEA').attr('readOnly', true);
	$('#paisFea').attr('readOnly', true);
	$('#paisRFC').attr('readOnly', true);

	//miscelaneos
	$('#fax').attr('readOnly', true);

	//Botones

	$('#generarc').hide();
	$('#generar').hide();
	$('#generar').attr('disabled', true);
	$('#generarc').attr('disabled', true);

	//campos de Datos Generales de la Persona
	deshabilitaControl('primerNombre');
	deshabilitaControl('segundoNombre');
	deshabilitaControl('tercerNombre');
	deshabilitaControl('apellidoPaterno');
	deshabilitaControl('apellidoMaterno');
	deshabilitaControl('fechaNacimiento');
	deshabilitaControl('paisNacimiento');
	deshabilitaControl('edoNacimiento');
	deshabilitaControl('CURP');
	deshabilitaControl('RFC');

	deshabilitaControl('ocupacionID');
	deshabilitaControl('puestoA');
	deshabilitaControl('sectorGeneral');
	deshabilitaControl('actividadBancoMX');
	deshabilitaControl('numIdentific');
	deshabilitaControl('fecExIden');
	deshabilitaControl('fecVenIden');
	deshabilitaControl('telefonoCasa');

	deshabilitaControl('telefonoCelular');
	deshabilitaControl('correo');
	deshabilitaControl('domicilio');
	deshabilitaControl('extTelefonoPart');
	deshabilitaControl('paisResidencia');
	deshabilitaControl('fechaVenEst');
	deshabilitaControl('docExisLegal');
	deshabilitaControl('FEA');
	deshabilitaControl('paisFea');
	deshabilitaControl('paisRFC');

	deshabilitaControl('fax');
	deshabilitaControl('generar');
	deshabilitaControl('generarc');

}
function limpiaDatosPersonaFisica() {
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#paisNacimiento').val('');
	$('#paisNac').val('');
	$('#edoNacimiento').val('');
	$('#nomEdoNacimiento').val('');
	$('#CURP').val('');
	$('#RFC').val('');
	$('#ocupacionID').val('');
	$('#ocupacionC').val('');
	$('#puestoA').val('');
	$('#paisResidencia').val('');
	$('#paisR').val('');
	$('#telefonoCelular').val('');
	$('#telefonoCasa').val('');
	$('#extTelefonoPart').val('');
	$('#correo').val('');

	$('#titulo').val("");
	$('#nacion').val("");
	$('#sexo').val("");
	$('#estadoCivil').val("");
	$('#tipoIdentiID').val("");

}

function limpiaCampos() {
	$('#numCliente').val('');
	$('#nombreCliente').val('');
	$('#tipoCuenta').val('');
	$('#moneda').val('');
	$('#tipoPer').val('');
}

function limpiaCombos() {
	$('#titulo').val("");
	$('#estadoCivil').val("");
	$('#sexo').val("");
	$('#tipoIdentiID').val("");
	$('#nacion').val("");
}

function exitoTransCuenta() {
	limpiaFormaCompleta('formaGenerica', true, ['garanteID','nombreAval','nombreGarante','avalID','numCliente','nombreCliente',
	                                            'sucursalID', 'nombreSucursal', 'directivoID']);

	deshabilitaBoton('elimina', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#nomEdoNacimiento').val("");
	ajustaComboTipAccionista(4);
	limpiaCombos();
	$('#esApoderado').attr("checked", false);
	$('#esAccionista').attr("checked", false);
	$('#esPropReal').attr("checked", false);
	$('#consejoAdmon').attr("checked", false);
	$('#esSolicitante').attr("checked", false);
	$('#esAutorizador').attr("checked", false);
	$('#esAdministrador').attr("checked", false);
	$('#infoAccionista').hide();
}

function falloTransCuenta() {

}

function validaCargo(control) {
	var numcargo = $('#cargoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numcargo != '' && !isNaN(numcargo)) {

		var cargoBeanCon = {
			'cargoID' : numcargo

		};
		cargosServicio.consulta(catTipoConsultaCargo.principal, cargoBeanCon, function(cargo) {
			if (cargo != null) {
				$('#descCargo').val(cargo.descripcionCargo);
					$('#cargoID').val(numcargo);

			} else {

				mensajeSis("No Existe el Cargo");
				$('#cargoID').focus();
				$('#cargoID').val('');
				$('#descCargo').val('');
				$('#cargoID').select();

			}
		});

	}
}

function validaValorAcciones(){
	var valorAcciones = $('#valorAcciones').asNumber();
	var valorAccionesVal = $('#valorAcciones').val();

	if (valorAccionesVal != '' && valorAccionesVal != NaN){
		if(valorAcciones < 0){
			mensajeSis('El valor de las acciones no debe ser menor a CERO');
			$('#valorAcciones').val('');
			$('#valorAcciones').focus(10);
		}
		if(valorAccionesVal != '0.00' && valorAcciones <= 0){
			mensajeSis('Ingrese Sólo numeros');
			$('#valorAcciones').val('');
			$('#valorAcciones').focus(10);
		}
	}
}


function mostrarCamposTipoAccionesta(valor){

	var inicioPantalla = 'I';
	var mostrarAccionista = 'S';
	var noMostrarAccionista = 'N';

	if( valor == mostrarAccionista ){
		$('#trCompania').show();
		$('#trDireciones').show();
		$('#trColonia').show();
		$('#trCodigo').show();
		$('#trFax').show();
		$('#trPaisCompania').show();
		$('#tdMunNacimiento').show();
		$('#munNacimiento').show();
		$('#nomMunNacimiento').show();
		$('#trTitular').hide();
		$('#trNombres').hide();
		$('#trApellido').hide();
		$('#trFecha').hide();
		$('#lblPaisNacimiento').hide();
		$('#tdPaisNacimiento').hide();
		$('#tdSeparador1').hide();
		$('#trIngresoRealoRecursos').hide();
		$('#trOcupaciones').hide();
		$('#trEstadoCivil').hide();
		$('#trFecha').hide();
		$('#trApellido').hide();
		$('#trNombres').hide();
		$('#trTitular').hide();
		$('#lblCurp').hide();
		$('#tdCurp').hide();
		$('#separadorCurp').hide();
		$('#generarc').hide();
		$('#generar').hide();
		$('#identificaciones').hide();
		$('#nacionalidades').hide();
		habilitaControl('compania');
		habilitaControl('direccion1');
		habilitaControl('direccion2');
		habilitaControl('edoNacimiento');
		habilitaControl('munNacimiento');
		habilitaControl('nombreCiudad');
		habilitaControl('codigoPostal');
		habilitaControl('telefonoCompania');
		habilitaControl('extensionCompania');
		habilitaControl('faxCompania');
		habilitaControl('paisCompania');
		habilitaControl('CURP');
		habilitaControl('RFC');
		habilitaControl('FEA');
		habilitaControl('paisFea');
		habilitaControl('edoExtranjero');
		document.getElementById('labelTitulo').innerHTML = 'Datos Generales de la Empresa';
		document.getElementById('lblEdoNacimiento').innerHTML = 'Estado:';
	}

	if( valor == noMostrarAccionista ){

		$('#trCompania').hide();
		$('#trDireciones').hide();
		$('#trColonia').hide();
		$('#trCodigo').hide();
		$('#trFax').hide();
		$('#tdMunNacimiento').hide();
		$('#trPaisCompania').hide();
		$('#munNacimiento').hide();
		$('#nomMunNacimiento').hide();
		$('#trTitular').show();
		$('#trNombres').show();
		$('#trApellido').show();
		$('#trFecha').show();
		$('#lblPaisNacimiento').show();
		$('#tdPaisNacimiento').show();
		$('#tdSeparador1').show();
		$('#trOcupaciones').show();
		$('#trEstadoCivil').show();
		$('#trFecha').show();
		$('#trApellido').show();
		$('#trNombres').show();
		$('#trTitular').show();
		$('#generarc').show();
		$('#generar').show();
		$('#lblCurp').show();
		$('#tdCurp').show();
		$('#separadorCurp').show();
		$('#identificaciones').show();
		$('#nacionalidades').show();
		deshabilitaControl('compania');
		deshabilitaControl('direccion1');
		deshabilitaControl('direccion2');
		deshabilitaControl('edoNacimiento');
		deshabilitaControl('munNacimiento');
		deshabilitaControl('nombreCiudad');
		deshabilitaControl('codigoPostal');
		deshabilitaControl('telefonoCompania');
		deshabilitaControl('extensionCompania');
		deshabilitaControl('faxCompania');
		deshabilitaControl('paisCompania');
		deshabilitaControl('edoExtranjero');
		deshabilitaControl('CURP');
		deshabilitaControl('RFC');
		deshabilitaControl('FEA');
		deshabilitaControl('paisFea');
		document.getElementById('labelTitulo').innerHTML = 'Datos Generales de la Persona';
		document.getElementById('lblEdoNacimiento').innerHTML = 'Entidad Federativa:';
	}

	if( valor == inicioPantalla ) {
		$('#trCompania').hide();
		$('#trDireciones').hide();
		$('#trColonia').hide();
		$('#trCodigo').hide();
		$('#trFax').hide();
		$('#tdMunNacimiento').hide();
		$('#trPaisCompania').hide();
		$('#munNacimiento').hide();
		$('#nomMunNacimiento').hide();
		deshabilitaControl('compania');
		deshabilitaControl('direccion1');
		deshabilitaControl('direccion2');
		deshabilitaControl('edoNacimiento');
		deshabilitaControl('munNacimiento');
		deshabilitaControl('nombreCiudad');
		deshabilitaControl('codigoPostal');
		deshabilitaControl('telefonoCompania');
		deshabilitaControl('extensionCompania');
		deshabilitaControl('faxCompania');
		deshabilitaControl('paisCompania');
		deshabilitaControl('edoExtranjero');
	}
}

function validaLimpiarFormulario(tipoFormulario){

	var con_Cliente = 'C';
	var con_Aval 	= 'A';
	var con_Garante = 'G';

	var directivoID = Number($('#directivoID').val());
	var clienteID 	= Number($('#numeroCte').val());
	var avalID 		= Number($('#avalRelacion').val());
	var garanteID 	= Number($('#garanteRelacion').val());

	if(directivoID == 0 && clienteID == 0 && avalID == 0 && garanteID == 0){
		inicializaForma('personasRelacionadas', 'directivoID');
		limpiaCombos();
		habilitaFormularioCuentaPersona();
		ajustaComboTipAccionista(4);
	}

	switch(tipoFormulario){
		case con_Cliente:
			$('#nombreCompleto').val('');
		break;
		case con_Aval:
			$('#nombreAvalRel').val('');
		break;
		case con_Garante:
			$('#nombreGaranteRel').val('');
		break;
	}
}

function completaCampoEnvio(){
	var faxCompania       = $('#faxCompania').val();
	var edoExtranjero     = $('#edoExtranjero').val();
	var paisCompania      = $('#paisCompania').val();
	var telefonoCompania  = $('#telefonoCompania').val();
	var extensionCompania = $('#extensionCompania').val();

	var nacionalidad = 'N';
	if( edoExtranjero != ''){
		nacionalidad = 'E';
	}

	$('#fax').val(faxCompania);
	$('#nacion').val(nacionalidad);
	$('#paisResidencia').val(paisCompania);
	$('#telefonoCasa').val(telefonoCompania);
	$('#extTelefonoPart').val(extensionCompania);

}

function ajustaComboTipAccionista(tipoCombo){
	var combo_Fisico = 1;
	var combo_FisicoActEmprarial = 2;
	var combo_Moral= 3;
	var combo_Completo = 4;

	if(tipoCombo == combo_FisicoActEmprarial){
		$("#tipoAccionista").children('option[value="F"]').remove();
		$("#tipoAccionista").children('option[value="M"]').remove();
		$("#tipoAccionista").children('option[value="G"]').remove();
	}
	if(tipoCombo == combo_Fisico){
		$("#tipoAccionista").children('option[value="M"]').remove();
		$("#tipoAccionista").children('option[value="A"]').remove();
		$("#tipoAccionista").children('option[value="G"]').remove();
	}
	if(tipoCombo == combo_Moral){
		$("#tipoAccionista").children('option[value="F"]').remove();
		$("#tipoAccionista").children('option[value="A"]').remove();
		$("#tipoAccionista").children('option[value="G"]').remove();
	}
	if(tipoCombo == combo_Completo){
		dwr.util.removeAllOptions('tipoAccionista');
		dwr.util.addOptions('tipoAccionista', {''  : 'SELECCIONAR' });
		dwr.util.addOptions('tipoAccionista', {'F' : 'PERSONA FÍSICA' });
		dwr.util.addOptions('tipoAccionista', {'M' : 'PERSONA MORAL' });
		dwr.util.addOptions('tipoAccionista', {'A' : 'PERSONA FÍSICA A.E.' });
		dwr.util.addOptions('tipoAccionista', {'G' : 'GOBIERNO' });
	}

}
