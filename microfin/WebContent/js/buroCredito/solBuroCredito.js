var fechaCon;
var fecha;
var fech;
var confirmar = false;
var diasRestantes= 0;
var parametroBean = consultaParametrosSession();

var banderaConsulta = 0;
var varAlert = '';
var mostrar = 0;
var cadenaFolioBur = '';
var varFolioBuro = '';
var enlace = '';
var usuarioValidoCirculo = 'N';
var usuarioValidoBuro = 'N';
var numeroCliente = 0;
var cliEspSFG = 29; // IALDANA


$(document).ready(function() {
$('#ligaAutorizacionPDF').removeAttr('href');
	esTab = true;

	//Definicion de Constantes y Enums
	var catTipoConsultaBuro = {
  		'principal':1,
  		'foranea':2,
  		'porRFC':3
	};

	var catTipoTranBuro = {
  		'agrega':1,
  		'modifica':2,
  		'agregaCirculo':3
	};
	parametroBean = consultaParametrosSession();
	consultaParametrosSistema(); // funcion para validar la opcion por default.
	//------------ Metodos y Manejo de Eventos -----------------------------------------

 	agregaFormatoControles('formaGenerica');
 	deshabilitaBoton('generarRepAutCred');
 	deshabilitaBoton('autorizaSolCredito');
 	deshabilitaBoton('consulta');
 	deshabilitaBoton('generarRep');

	//Validacion para mostrarar boton de calcular  RFC
	permiteCalcularCURPyRFC('','generar',2);
	$('#origenDatos').val(parametroBean.origenDatos);

	$(':text').focus(function() {
	 	esTab = false;
	});


	$.validator.setDefaults({
		submitHandler: function(event) {
			if($('#diasVigenciaBC').asNumber() == 0 || $('#diasVigenciaBC').asNumber() == ''){
			 grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioConsulta','exitoConsulta','falloConsulta');
			}else{
			 if($('#folioConsulta').val() != ''){
				 confirmar = confirm("Consulta Vigente. ¿Está seguro que desea realizar nuevamente la Consulta?");
				 if(confirmar == true){
				 	ClienteEspeficio(); // Agregado IALDANA
				 	if (numeroCliente == cliEspSFG) { // IALDANA
				 		consultaUsuarioCirculo(parametroBean.numeroUsuario); // agregado AEUAN	
				 	}
					 grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioConsulta','exitoConsulta','falloConsulta');
				 }
			 }else{
				 mensajeSis("Error");
			 }
			}
	  	}
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$('#consulta').click(function() {
		banderaConsulta = 1;
		if($('#consultaBC').is(':checked')){
			$('#tipoTransaccion').val(catTipoTranBuro.agrega);
		}
		if($('#consultaCC').is(':checked')){
			$('#tipoTransaccion').val(catTipoTranBuro.agregaCirculo);
		}

	});

	$('#generar').click(function() {
		if ($('#primerNombre').val() == ''){
			mensajeSis('Especificar Primer Nombre');
		}
		if ($('#apellidoPaterno').val() == ''){
			mensajeSis('Especificar Apellido Paterno');
		}
		if ($('#fechaNacimiento').val() == ''){
			mensajeSis('Especificar Fecha de Nacimiento');
		}
		if ($('#primerNombre').val() != '' && $('#apellidoPaterno').val() != '' && $('#fechaNacimiento').val() != ''){
			formaRFC();
		}
	});

	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
	});



	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
	});

	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id);
	});

	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function(){
		if($('#clienteID').val()== '' || $('#clienteID').val() == 0){
			limpiaCampos();
			habilitaControl('sexo');
			habilitaControl('estadoCivil');
		}else{
			if(banderaConsulta == 0){
				if($('#folioConsulta').asNumber()!=0){
					consultaCliente(this.id);
				}else{
					consultaCliente(this.id);
				}
			}
			banderaConsulta = 0;
		}

  		$('#ligaPDF').removeAttr("href");
	});

	$('#prospectoID').bind('keyup',function(e) {
		lista('prospectoID', '1', '1','prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#prospectoID').blur(function() {
		if(banderaConsulta == 0){
			consultaProspecto(this.id);
		}

  		$('#ligaPDF').removeAttr("href");
  		banderaConsulta = 0;
	});

	$('#fechaNacimiento').change(function(){
		var fechaAplic = parametroBean.fechaAplicacion;
		var fechaNac = $('#fechaNacimiento').val();

		if(fechaNac==''){
			$('#fechaNacimiento').val(fechaAplic);
		}else{
			if(esFechaValida(fechaNac)){
				if(mayor(fechaNac,fechaAplic)){
					mensajeSis("La Fecha Capturada es Mayor a la de Hoy");
					$('#fechaNacimiento').val(fechaAplic);
					regresarFoco('fechaNacimiento');
				}else{
					if(!esTab){
						regresarFoco('fechaNacimiento');
					}
				}
			}else{
				$('#fechaNacimiento').val(fechaAplic);
				regresarFoco('fechaNacimiento');
			}
		}
	});

	$('#RFC').blur(function() {
		if(banderaConsulta == 0){
			if($('#clienteID').val()=='' || $('#prospectoID').val()== '' || $('#clienteID').val()=='0' || $('#prospectoID').val()=='0'){
				if($('#consultaBC').is(':checked')){
					consultaBuro($('#RFC').val());
				}
				if($('#consultaCC').is(':checked')){
					consultaCirculoCreditoEstatus($('#RFC').val());
				}
			}
		}
		banderaConsulta = 0 ;
	});

	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "localidadID";
		camposLista[3] = "asentamiento";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = '0';
		parametrosLista[3] = $('#coloniaID').val();

		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});


	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();

		lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});

	$('#generarRep').click(function(event) {
		event.preventDefault();
		quitaFormatoControles('formaGenerica');
		var tipoReporte = 2;
		var tipoReporteCirculo = 1;
		var nombreInst = 	parametroBean.nombreInstitucion;
		var fechaCon = $('#fechaConsulta').val().substring(0,10);
		var fech =$('#fechaConsulta').val().substring(11,16);
	    $('#hora').val(fech);
		var hrCon	 =   $('#hora').val();
		var folio	=		varFolioBuro[0];
		var usuario	= parametroBean.claveUsuario;
		//Se agrega la variable apellidoMaterno y la validación
		var apellidoMaterno = $('apellidoMaterno').val();
		if (apellidoMaterno == 'NO PROPORCIONADO'){
			apellidoMaterno = '';
		}
		enlace = '';
		if($('#consultaBC').is(':checked')){
			enlace = 'ReporteBC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio+'&usuario='+$('#claveUsuariob').val()+"&tipoReporte="+tipoReporte;
		}
		if($('#consultaCC').is(':checked')){
			folio = $('#folioConsulta').val();
			enlace = 'ReporteCC.htm?programaID='+nombreInst+'&fechaConsulta='+fechaCon+'&fechaActual='+hrCon+'&folioConsulta='+folio+'&usuario='+$('#claveUsuario').val()+"&tipoReporte="+tipoReporteCirculo
			+"&nombreConsultado="+$('apellidoPaterno').val()+" "+apellidoMaterno+" "+$('primerNombre').val()+" "+$('segundoNombre').val()+" "+" "+$('tercerNombre').val()+" "
			+"&direccion="+"CALLE "+$('calle').val()+" NÚMERO INTERIOR "+", NÚMERO EXTERIOR "+", PISO "+", COLONIA"
			+"&municipio="+$('#nombreMuni').val()
			+"&edocp="+tipoReporteCirculo+"&usuarioCirculo="+$('#usuarioCirculo').val();
		}
		window.open(enlace,'_blank');
	});


	   $('#autorizaSolCredito').click(function(event) {
			event.preventDefault();
			var form = 	$('#formaGenerica');
			if(form.valid()){
				var clienteID = $('#clienteID').val();
				var primerNombre = $('#primerNombre').val();
				var segundoNombre = $('#segundoNombre').val();
				var tercerNombre = $('#tercerNombre').val();
				var apellidoPaterno =$('#apellidoPaterno').val();
				var apellidoMaterno = $('#apellidoMaterno').val();
				var CP = $('#CP').val();
				var RFC = $('#RFC').val();
				var nombreColonia = $('#nombreColonia').val();
				var nombreEstado = $('#nombreEstado').val();
				var nombreMuni = $('#nombreMuni').val();
				var calle = $('#calle').val();
				var numeroExterior = $('#numeroExterior').val();
				var tipoReporte = 3;
				var sucursalID = parametroBean.sucursal;

				var tipoPersona = $('input:radio[name=tipoPersona]:checked').val();
				var telefono = $('#telefono').val();
				var telefonoCelular = $('#telefonoCelular').val();
				var telTrabajo = $('#telTrabajo').val();
				var fechaConsulta = $('#fechaConsulta').val();
				var folioConsulta = varFolioBuro[1];
				enlace = '';

				// Agregado
				
				if (apellidoMaterno == 'NO PROPORCIONADO') {
					apellidoMaterno = '';
				}

				if($('#consultaBC').is(':checked')){
					enlace = 'RepPDFAutorizacionSolRepCredito.htm?clienteID='+clienteID+
						'&primerNombre='+primerNombre+'&segundoNombre='+segundoNombre+'&tercerNombre='+tercerNombre+
						'&apellidoPaterno='+apellidoPaterno+'&apellidoMaterno='+apellidoMaterno+'&CP='+CP+
						'&RFC='+RFC+'&nombreColonia='+nombreColonia+'&nombreEstado='+nombreEstado+'&nombreMuni='+nombreMuni+
						'&sucursalID='+sucursalID+'&calle='+calle+'&numeroExterior='+numeroExterior+'&tipoReporte='+tipoReporte
						+'&tipoPersona='+tipoPersona
						+'&telefono='+telefono
						+'&telefonoCelular='+telefonoCelular
						+'&telTrabajo='+telTrabajo
						+'&folioConsulta='+folioConsulta
						+'&fechaConsulta='+fechaConsulta;
					window.open(enlace,'_blank');
				}
			}
		});

	$('#consultaBC').blur(function (){
		if(esTab){
			diasRestantes= 0
			$('#autorizaSolCredito').show();
			$('#legendtext').text('Consulta Buró Crédito');
			$('#consultaCC').attr("checked",false);
			$('#consultaBC').attr("checked",true);
			$('#consulta').val('Consultar en BC');
			$('#circuloItems').hide();
			$('#tipoCuenta').hide();
			$('#lblTipoCuenta').hide();
			$('#tipoContratoCCIDDes').hide();
			$('#generarRepAutCred').hide();
			$('#consulta').show();
			$('#generarRep').show();
			consultaUsuarioBuro(parametroBean.numeroUsuario);
			if($('#RFC').val() != ''){
				consultaBuro($('#RFC').val());
			}
		}
	});

	$('#consultaCC').click(function (){
		consultaAbreviaturaCirculo();
		habilitaBoton('generarRepAutCred');
		diasRestantes= 0;
		$('#autorizaSolCredito').hide();
		$('#consultaCC').attr("checked",true) ;
		$('#consultaBC').attr("checked",false) ;
		$('#consultaCC').focus();
		$('#generarRepAutCred').show();
		$('#consulta').hide();
		$('#generarRep').hide();
		esTab = true;
		consultaUsuarioCirculo(parametroBean.numeroUsuario);
		if($('#RFC').val() != ''){
			consultaCirculoCreditoEstatus($('#RFC').val());
		}
		mostrarSeccionCirculoCredito();
	});

	$('#tipoCuenta').blur(function() {
		consultaTipoContratoCirculoCredito(this.id);
	});

	$('#tipoCuenta').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#tipoCuenta').val();
			listaAlfanumerica('tipoCuenta', '1', '1', camposLista, parametrosLista, 'listaCirculoCreTipCon.htm');
		};
	});

	$('#generarRepAutCred').click(function(event) {
		event.preventDefault();
		var form = 	$('#formaGenerica');
		if(form.valid()){
			generarReporteAutCred();
		}
	});

	 $('#clienteID').blur(function(){
	    	validarfcCtePros();
	    });
	  $('#prospectoID').blur(function(){
	    	validarfcCtePros();
	    });

	//------------ Validaciones de la Forma -------------------------------------


	$('#formaGenerica').validate({
		rules: {
			primerNombre: {
				required: true
			},			
			RFC: {
				required: true
			},
			fechaNacimiento: {
				required: true,
				date : true
			},
			calle: {
				required: true,
				maxlength : 40
			},
			estadoID: {
				required: true,
				number : true
			},
			municipioID: {
				required: true,
				number : true
			},
			localidadID: {
				required: true,
				number : true
			},
			coloniaID: {
				required: true,
				number : true
			},
			CP: {
				required: true
			},
			importe : {
				required : function() {return $('#consultaCC').is(':checked'); }
			},
			tipoCuenta :{
				required : function() {return $('#consultaCC').is(':checked'); }
			},
			numeroExterior :{
				required : true
			}
		},

		messages: {
			primerNombre: {
				required: 'Especificar Nombre.'
			},
			apellidoPaterno: {
				required: 'Especificar Apellido Paterno.'
			},
			RFC: {
				required: 'Especificar RFC.'
			},
			fechaNacimiento: {
				required: 'Especificar Fecha.',
				date : 'Fecha Incorrecta.'
			},
			calle: {
				required: 'Especificar Calle.',
				maxlength : 'Maximo 40 caracteres '
			},
			coloniaID: {
				required: 'Especificar Colonia.',
				number : 'Solo Números'
			},
			estadoID: {
				required: 'Especificar Estado.',
				number : 'Solo Números'
			},
			municipioID: {
				required: 'Especificar Municipio.',
				number : 'Solo Números'
			},
			localidadID: {
				required: 'Especificar Localidad.',
				number : 'Solo Números'
			},
			CP: {
				required: 'Especificar C.P.'
			},
			importe: {
				required: 'Especificar Monto Solicitado.'
			},
			tipoCuenta :{
				required:  'Especificar Contrato Círculo de Crédito.'
			},
			numeroExterior :{
				required:  'Especificar Número Exterior.'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------

	//----------Funcion consultaTipoContratoBC---------------------//
	function consultaTipoContratoCirculoCredito(idControl) {
		var jqTipCont = eval("'#" + idControl + "'");
		var numTipoCont = $(jqTipCont).val();
		var conTipCont = 1;
		var TipoContratoBCBeanCon = {
  				'tipoContratoCCID':numTipoCont
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numTipoCont != ''  && esTab) {
			circuloCreTipConServicio.consulta(conTipCont,TipoContratoBCBeanCon, function(contrato) {
				if (contrato != null) {
					$('#tipoContratoCCIDDes').val(contrato.descripcion);
				}
				else{
					mensajeSis("No Existe el Contrato "+ numTipoCont);
					$('#tipoContratoCCIDDes').val("");
					$('#tipoCuenta').focus();
					$('#tipoCuenta').select();
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
				$('#RFC').focus();
			}
		});
	}


	function consultaEstado(idControl) {
	  esTab = true;
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){
					$('#nombreEstado').val(estado.nombre);
					if($('#consultaBC').is(':checked')){
						$('#claveEstado').val(estado.eqBuroCredito);
					} else if($('#consultaCC').is(':checked')){
						$('#claveEstado').val(estado.eqCirCre);
					}
				}else{
							mensajeSis("No Existe el Estado");
							$('#estadoID').focus();
							$('#estadoID').select();
						}
				});
			}else {
				$(jqEstado).val('');
				$('#nombreEstado').val('');
			}
	}

	/* funcion para consultar un municipio*/
	function consultaMunicipio(idControl) {
		esTab = true;
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();
		var numEstado =  $('#estadoID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){
						if(municipio.nombre!=null){
							$('#nombreMuni').val(municipio.nombre.substring(0, 40));
						}else{
							$('#nombreMuni').val("");
						}
					}else{
						mensajeSis("No Existe el Municipio");
						$('#municipioID').focus();
						$('#municipioID').select();
					}
				});
		}else {
			$(jqMunicipio).val('');
			$('#nombreMuni').val('');
		}
	}

	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
			if (numEstado != '') {
				if (numMunicipio != '') {
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
						if(localidad!=null){
							if(localidad.nombreLocalidad!=null){
								$('#nombreLocalidad').val(localidad.nombreLocalidad.substring(0, 40));
							}else{
								$('#nombreLocalidad').val("");
							}
							esTab = true;
							consultaColonia('coloniaID');
						}else{
							mensajeSis("No Existe la Localidad");
							$('#nombreLocalidad').val("");
							$('#localidadID').val("");
							$('#localidadID').focus();
							$('#localidadID').select();
						}
					});
				}else {
					mensajeSis("Especifique el Municipio");
					$('#municipioID').focus();
					$('#localidadID').val('');
					$('#nombreLocalidad').val('');
				}
			}else {
				mensajeSis("Especifique la Entidad Federativa");
				$('#estadoID').focus();
			}
		}else {
			$(jqLocalidad).val('');
			$('#nombreLocalidad').val('');
		}
	}

	//consulta Colonia y CP
	function consultaColonia(idControl) {
		esTab = true;
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();
		var numEstado =  $('#estadoID').val();
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numColonia != '' && !isNaN(numColonia) && esTab){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){
					if(colonia.asentamiento!=null){
						$('#nombreColonia').val(colonia.asentamiento.substring(0, 40));
					}else{
						$('#nombreColonia').val("");
					}

					$('#CP').val(colonia.codigoPostal);
				}else{
					mensajeSis("No Existe la Colonia");
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#coloniaID').focus();
					$('#coloniaID').select();
					$('#CP').val("");
				}
			});
		}else {
			$(jqColonia).val('');
			$('#nombreColonia').val('');
		}
	}

	function consultaCliente(idControl,varAlert) {
	   esTab=true;
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) && esTab){

			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					$('#primerNombre').val(cliente.primerNombre);
					$('#segundoNombre').val(cliente.segundoNombre);
					$('#tercerNombre').val(cliente.tercerNombre);
					$('#apellidoPaterno').val(cliente.apellidoPaterno);
					$('#apellidoMaterno').val(cliente.apellidoMaterno);
					$('#RFC').val(cliente.RFC);
					$('#fechaNacimiento').val(cliente.fechaNacimiento);
					$('#estadoCivil').val(cliente.estadoCivil);
					$('#nacionalidad').val(cliente.nacion);
					$('#sexo').val(cliente.sexo);
					$('#telefono').val(cliente.telefono);
					$('#telefonoCelular').val(cliente.telefonoCelular);
					$('#telTrabajo').val(cliente.telTrabajo);

					deshabilitaControl('telefono');
					deshabilitaControl('telefonoCelular');
					deshabilitaControl('telTrabajo');

					if(cliente.tipoPersona == 'M'){
						$('#labeltelTrabajo').hide();
						$('#telTrabajo').hide();
						$('#RFC').val(cliente.RFCpm);
					}else{
						$('#labeltelTrabajo').show();
						$('#telTrabajo').show();
						$('#RFC').val(cliente.RFC);
					}

					 // solo fisicas
					if($('#consultaBC').is(':checked')){
						consultaBuro(cliente.RFC);
						// agregado
						if($('#apellidoPaterno').val() == '' && $('#apellidoMaterno').val() != ''){ // abrir el if
							$('#apellidoPaterno').val($('#apellidoMaterno').val());
							$('#apellidoMaterno').val('NO PROPORCIONADO');
						}else{
							if($('#apellidoPaterno').val() != '' && $('#apellidoMaterno').val() == ''){ // abrebif
								$('#apellidoMaterno').val('NO PROPORCIONADO') ;
									}// cierra if
						}// cierra else
						// fin agregado

					}else{
						consultaCirculoCreditoEstatus(cliente.RFC);

								habilitaBoton('generarRepAutCred', 'submit');
							 	$('#generarRepAutCred').show();
								$('#consulta').hide();
								$('#generarRep').hide();
							    $('#prospectoID').val('');
							    $('#ligaAutorizacionPDF').removeAttr('href');

					}
					consultaDirCliente('clienteID',varAlert);
					deshabilitaControl('sexo');
					deshabilitaControl('estadoCivil');


					$('#importe').val("");
					$('#tipoCuenta').val("");
					$('#tipoContratoCCIDDes').val("");


				}else{
					mensajeSis("El "+$('#socioCliente').val()+" No Existe.");
					limpiaCampos();
					deshabilitaBoton('generarRep', 'submit');
					$('#clienteID').focus();
					$('#clienteID').select();
					$('#clienteID').val('');
					habilitaControl('sexo');
					habilitaControl('estadoCivil');
					habilitaControl('telefono');
					habilitaControl('telefonoCelular');
					habilitaControl('telTrabajo');
					$('#telefono').show();
					$('#telefonoCelular').show();
					$('#telTrabajo').show();
				}
			});
		}


	}

	/* COnsulta la direccion oficial del cliente */
	function consultaDirCliente(control, varAlert) {
		setTimeout("$('#cajaLista').hide();", 200);
		var direccionesCliente ={
				'clienteID' : $('#clienteID').val(),
				'tipoDireccionID' : '0',
				'direccionID' : '0'
		};
		direccionesClienteServicio.consulta(6,direccionesCliente,function(direccion) {
			if(direccion!=null){
				dwr.util.setValues(direccion);
				$('#numeroExterior').val(direccion.numeroCasa);
				$('#numeroInterior').val(direccion.numInterior);
				esTab=true;
				$('#estadoID').val(direccion.estadoID);
				$('#municipioID').val(direccion.municipioID);
				$('#localidadID').val(direccion.localidadID);
				$('#coloniaID').val(direccion.coloniaID);
				if(direccion.colonia!=null){
					$('#nombreColonia').val(direccion.colonia.substring(0, 40));
				}else{
					$('#nombreColonia').val("");
				}

				consultaEstado('estadoID');
				consultaMunicipio('municipioID');
				consultaLocalidad('localidadID');
			}else{
				if(varAlert=="S"){
					mensajeSis("No Existe la Dirección del "+$('#socioCliente').val()+".");
				}

				$('#calle').val("");
				$('#numeroExterior').val("");
				$('#numeroInterior').val("");
				$('#piso').val("");
				$('#lote').val("");
				$('#manzana').val("");
				$('#coloniaID').val("");
				$('#nombreColonia').val("");
				$('#estadoID').val("");
				$('#nombreEstado').val("");
				$('#municipioID').val("");
				$('#nombreMuni').val("");
				$('#localidadID').val("");
				$('#nombreLocalidad').val("");
				$('#CP').val("");

				$('#calle').select();
				$('#calle').focus();
			}
		});
	}

	// consulta el prospecto
	function consultaProspecto(idControl) {
		esTab = true;
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var prospectoBeanCon ={
				'prospectoID' : numProspecto
		};

		tipoConProsp=1;
		tipoConProspForanea=2;

		if (numProspecto != '' && !isNaN(numProspecto) && esTab && numProspecto > 0) {
		   $('#clienteID').val("");
			prospectosServicio.consulta(tipoConProspForanea,prospectoBeanCon,function(prospecFor) {
				if(prospecFor!=null){
					deshabilitaControl('sexo');
					deshabilitaControl('estadoCivil');
					if(prospecFor.cliente != '' && prospecFor.cliente != null){
						$('#clienteID').val(prospecFor.cliente);
						esTab= true;
						consultaCliente('clienteID', varAlert);
						$('#nombreProspecto').val("");
						$('#prospectoID').val("");
					}else{
						prospectosServicio.consulta(tipoConProsp,prospectoBeanCon,function(prospectos) {
							if(prospectos!=null){
								dwr.util.setValues(prospectos);
								esTab= true;
								consultaEstado('estadoID');
								consultaMunicipio('municipioID');
								consultaColonia('coloniaID');
								$('#numeroExterior').val(prospectos.numExterior);
								$('#numeroInterior').val(prospectos.numInterior);
								if($('#consultaBC').is(':checked')){
									consultaBuro(prospectos.RFC); // aqui agregar validacion
									if($('#apellidoPaterno').val() == '' && $('#apellidoMaterno').val() != ''){ // abrir el if
										$('#apellidoPaterno').val($('#apellidoMaterno').val());
										$('#apellidoMaterno').val('NO PROPORCIONADO');
									}else{
										if($('#apellidoPaterno').val() != '' && $('#apellidoMaterno').val() == ''){ // abrebif
												$('#apellidoMaterno').val('NO PROPORCIONADO') ;
										}// cierra if
									}// cierra else

								}else{
									consultaCirculoCreditoEstatus(prospectos.RFC);
								}
								$('#telefono').show();
								$('#telefonoCelular').hide();
								$('#telTrabajo').show();
								habilitaControl('telefono');
								deshabilitaControl('telefonoCelular');
								habilitaControl('telTrabajo');
							}else{
								mensajeSis("No Existe el Prospecto");
								limpiaCampos();
								$('#prospectoID').focus();
								$('#prospectoID').select();
								deshabilitaBoton('generarRep', 'submit');
								$('#prospectoID').val('');
								$('#telefono').show();
								$('#telefonoCelular').show();
								$('#telTrabajo').show();
								habilitaControl('telefono');
								habilitaControl('telefonoCelular');
								habilitaControl('telTrabajo');
							}
						});
					}
				}else{
					mensajeSis("No Existe el Prospecto");
					limpiaCampos();
					$('#prospectoID').focus();
					$('#prospectoID').select();
					deshabilitaBoton('generarRep', 'submit');
					$('#prospectoID').val('');
					habilitaControl('sexo');
					habilitaControl('estadoCivil');
				}
			});
		}
	 }

	// funcion para validar si el usuario puede realizar consultas a circulo de credito.
	function consultaUsuarioCirculo(numUsuario) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) ){ // se quito && esTab
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(1,usuarioBeanCon,{ async: false, callback: function(usuario) {
				if(usuario!=null){
					if(usuario.realizaConsultasCC == 'S'){
						$('#usuarioCirculo').val(usuario.usuarioCirculo);
						$('#contrasenaCirculo').val(usuario.contrasenaCirculo);
						$('#realizaConsultasCC').val('S');
						habilitaBoton('consulta');
						habilitaBoton('generarRepAutCred');
						usuarioValidoCirculo = 'S';
					}else if(usuario.realizaConsultasCC == 'N'){
						$('#usuarioCirculo').val('');
						$('#contrasenaCirculo').val('');
						$('#realizaConsultasCC').val('N');
						usuarioValidoCirculo = 'N';
						mensajeSis("El Usuario No Puede Realizar Consultas a Círculo de Crédito ");
						deshabilitaBoton('consulta', 'submit');
						deshabilitaBoton('generarRepAutCred', 'submit');
						$('#consultaBC').trigger('click');
					}
					else{
						$('#usuarioCirculo').val('');
						$('#contrasenaCirculo').val('');
						$('#realizaConsultasCC').val('N');
						usuarioValidoCirculo = 'N';
						mensajeSis("El Usuario No Puede Realizar Consultas a Círculo de Crédito ");
						deshabilitaBoton('consulta', 'submit');
						deshabilitaBoton('generarRepAutCred', 'submit');
						$('#consultaBC').trigger('click')
					}

				}else{
					$('#usuarioCirculo').val('');
					$('#contrasenaCirculo').val('');
					$('#realizaConsultasCC').val('N');
				}
			}	
			});

		}
	}

	// funcion para validar si el usuario puede realizar consultas a Buro de Credito.
	function consultaUsuarioBuro(numUsuario) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					if(usuario.realizaConsultasBC == 'S'){
						$('#usuarioBuroCredito').val(usuario.usuarioBuroCredito);
						$('#contraseniaBuroCredito').val(usuario.contrasenaBuroCredito);
						$('#realizaConsultasBC').val('S');
						$('#usuario').val(usuario.usuarioID);
						usuarioValidoBuro = 'S';
						habilitaBoton('consulta');
						habilitaBoton('autorizaSolCredito');
					}else if(usuario.realizaConsultasBC == 'N'){
						$('#usuarioBuroCredito').val('');
						$('#contraseniaBuroCredito').val('');
						$('#realizaConsultasBC').val('N');
						$('#usuario').val('');
						usuarioValidoBuro = 'N';
						mensajeSis("El Usuario No Puede Realizar Consultas a Buró de Crédito ");
						deshabilitaBoton('consulta', 'submit');
						deshabilitaBoton('autorizaSolCredito', 'submit');
						$('#consultaBC').trigger('click');
					}
					else{
						$('#usuarioBuroCredito').val('');
						$('#contraseniaBuroCredito').val('');
						$('#realizaConsultasBC').val('N');
						$('#usuario').val('');
						usuarioValidoBuro = 'N';
						mensajeSis("El Usuario No Puede Realizar Consultas a Buró de Crédito ");
						deshabilitaBoton('consulta', 'submit');
						deshabilitaBoton('autorizaSolCredito', 'submit');
						$('#consultaBC').trigger('click');
					}
				}else{
					$('#usuarioBuroCredito').val('');
					$('#contraseniaBuroCredito').val('');
					$('#realizaConsultasBC').val('N');
					$('#usuario').val('');
				}
			});

		}
	}

	// Consulta de Parametro de sistema para obtener valor a seleccionar por default
	function consultaParametrosSistema() {
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {
				if (varParamSistema.conBuroCreDefaut == 'B') {	// si tiene por default Buro
 					$('#consultaBC').focus();
					$('#consultaCC').attr("checked",false);
					$('#consultaBC').attr("checked",true);
					$('#circuloItems').hide();
					$('#tipoCuenta').hide();
					$('#lblTipoCuenta').hide();
					$('#tipoContratoCCIDDes').hide();
					mostrarBotonesBuro();
				}else{	// si tiene por default Circulo
					esTab = true;
 					$('#consultaCC').focus();
					$('#consultaCC').attr("checked",true);
					$('#consultaBC').attr("checked",false);
					mostrarSeccionCirculoCredito();
					consultaUsuarioCirculo(parametroBean.numeroUsuario);
					$('#abreviaturaCirculo').val(varParamSistema.abreviaturaCirculo);
					 mostrarBotonesBuro();
				}
			} else {
				deshabilitaBotones();
			}
		});
	}

	//Valida que esten vacios los campos para generar reporte de autorizacion para solicitar credito
	function validaCamposParaSolCredito(event){
		   var clienteID = $('#clienteID').val();
		   var primerNombre = $('#primerNombre').val();
		   var apellidoPaterno =$('#apellidoPaterno').val();
		   var fechaNacimiento	= $('#fechaNacimiento').val();
		   var calle = $('#calle').val();
		   var numeroExterior  = $('#numeroExterior').val();
		   var estado	 = $('#estadoID').val();
		   var municipioID = $('#municipioID').val();
		   var localidadID = $('#localidadID').val();
			var coloniaID = $('#coloniaID').val();
		   var CP = $('#CP').val();
		   var RFC = $('#RFC').val();
			var nombreEstado = $('#nombreEstado').val();
			var nombreMuni = $('#nombreMuni').val();
			var nombreLocalidad = $('#nombreLocalidad').val();
		   var nombreColonia = $('#nombreColonia').val();

		   var mostrarAlert = 1;
		   var procede = 1;

		   if(primerNombre == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("El Primer Nombre está Vacío");
				  	$('#primerNombre').focus();
					event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		   if(apellidoPaterno == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("El Apellido Paterno está Vacío");
			   	$('#apellidoPaterno').focus();
					event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(fechaNacimiento == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("La Fecha de Nacimiento está Vacío");
			   	$('#fechaNacimiento').focus();
					event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(RFC == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("El RFC está Vacío");
			   	$('#RFC').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(calle == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("La Calle está Vacía");
			   	$('#calle').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(numeroExterior == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("El Número Exterior está Vacío");
			   	$('#numeroExterior').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(estado == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("La Entidad Federativa está Vacía");
			   	$('#estadoID').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(municipioID == ''){
		   	if (mostrarAlert == 1) {
					mensajeSis("El Municipio está Vacío");
			   	$('#municipioID').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
			if(localidadID == ''){
		   	if (mostrarAlert == 1) {
					mensajeSis("La Localidad está Vacío");
			   	$('#localidadID').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
		   if(coloniaID == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("La Colonia está Vacía");
			   	$('#coloniaID').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }

		   if(CP == ''){
		   	if (mostrarAlert == 1) {
				  	mensajeSis("El Código Postal está Vacío");
			   	$('#CP').focus();
			   	event.preventDefault();
					mostrarAlert = 0;
					procede = 0;
				}
		   }
		   if (procede == 0){
				return false;
			}else {
				return true;
			}
	   }

	    function validarfcCtePros(){
		    	if($('#clienteID').val()!=0 || $('#prospectoID').val() != 0){
		    		$('#RFC').attr('readonly','true');
		    		$('#generar').hide();
		    	}else{
		    		permiteCalcularCURPyRFC('','generar',2);
		    	}
	    }

	    function mostrarBotonesBuro(){
	    	if($('#consultaBC').is(':checked')){
	    		$('#generarRepAutCred').hide();
			 	habilitaBoton('autorizaSolCredito');
			 	habilitaBoton('consulta');
			}
			if($('#consultaCC').is(':checked')){
		    	$('#consulta').hide();
		    	$('#generarRep').hide();
		     	$('#autorizaSolCredito').hide();//genera reporte de autorización para solicitar reporte de credito
		     	$('#generarRepAutCred').show();
 				habilitaBoton('generarRepAutCred');
			}

	    }

		/***********************************/
		//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
		//PRIMER PARAMETRO ID BOTON CURP
		//SEGUNDO PARAMETRO ID BOTON RFC
		//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
		function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
			var jqBotonCURP = eval("'#" + idBotonCURP + "'");
			var jqBotonRFC = eval("'#" + idBotonRFC + "'");
			var numEmpresaID = 1;
			var tipoCon = 17;
			var ParametrosSisBean = {
					'empresaID'	:numEmpresaID
			};
			parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
				if (parametrosSisBean != null) {
					//Validacion para mostrarar boton de calcular CURP Y RFC
					if(parametrosSisBean.calculaCURPyRFC == 'S'){
						if(tipo == 3){
							$(jqBotonCURP).show();
							$(jqBotonRFC).show();
						}else{
							if(tipo == 1){
								$(jqBotonCURP).show();
							}else{
								if(tipo == 2){
									$(jqBotonRFC).show();
								}
							}
						}
					}else{
						if(tipo == 3){
							$(jqBotonCURP).hide();
							$(jqBotonRFC).hide();
						}else{
							if(tipo == 1){
								$(jqBotonCURP).hide();
							}else{
								if(tipo == 2){
									$(jqBotonRFC).hide();
								}
							}
						}
					}
				}
			});
		}

});// fin document ready

// consulta mediante el rfc si ya ha sido consultado anteriormente y cuantos dias tiene de vigencia la consulta
function consultaBuro(rfc){

	var solBuroBean ={
			'RFC' : rfc,
			'empresaID':1
	};
	solBuroCredServicio.consulta(3,solBuroBean,function(folio) {
		if(folio !=null){
			if(folio.folioConsulta != '' || folio.folioConsulta != null){
				cadenaFolioBur = folio.folioConsulta;
				varFolioBuro = cadenaFolioBur.split("&");
				$('#folioConsulta').val(varFolioBuro[1]);
				$('#fechaConsulta').val(folio.fechaConsulta.substring(0,16));
				fecha = folio.fechaConsulta;
				fech =fecha.substring(11,16);
				$('#hora').val(fech);
				$('#diasVigenciaBC').val(folio.diasVigencia);
				diasRestantes = folio.diasVigencia;
				if(folio.folioConsulta<='0'){
					$('#diasVigenciaBC').val('0');
					diasRestantes=0;
				}
				validaFolioBoton(folio.folioConsulta);
			}else{
				$('#folioConsulta').val("");
				$('#fechaConsulta').val("");
				$('#diasVigenciaBC').val('');
				validaFolioBoton("");
			}
		}else{
			$('#folioConsulta').val("");
			$('#fechaConsulta').val("");
			$('#diasVigenciaBC').val('');
			validaFolioBoton("");
		}
	});
}


// función éxito consulta

	function exitoConsulta(){
		validaFolioBoton($('#folioConsulta').val());
		fechaCon = $('#campoGenerico').val();
    	$('#fechaConsulta').val(fechaCon.substring(0,16));
	  	fecha =fechaCon;
	  	fech =fecha.substring(11,16);
		$('#hora').val(fech);
		$('#RFC').focus();
		if($('#clienteID').asNumber()>0){
			$('#RFC').focus();
		}else{
			if($('#prospectoID').asNumber()> 0){
				$('#RFC').focus();
			}else{
				$('#RFC').focus();
				$('#RFC').select();
			}
		}
	}

function falloConsulta(){

 }

 //valida que el folio sea diferente de cero para prender el boton  de ver reporte
function validaFolioBoton(folio){
	 if(folio == 0 || folio == '' ){
		 deshabilitaBoton('generarRep', 'submit');

	 	if( usuarioValidoCirculo  == 'N'){
	 	 	deshabilitaBoton('generarRepAutCred');
	 	}


		 $('#diasVigenciaBC').val('0');
		 $('#claveUsuariob').val(parametroBean.claveUsuario);
		 $('#claveUsuario').val(parametroBean.claveUsuario);
	 }else{
		habilitaBoton('generarRep', 'submit');

		if($('#consultaBC').is(':checked')){
			consultaFolioBC(folio) ;
		}else{
			if($('#consultaCC').is(':checked')){
				consultaFolioCC(folio);
			}
		}
	 }
}

//Funcion para consultar el folio de Buro de Credito
function consultaFolioBC(folioNum) {
	var folio= completaCerosIzquierda(folioNum, 10);
	var solicitudBeanCon = {
			'folioConsulta' :folio,
			'empresaID':1
			};

	setTimeout("$('#cajaLista').hide();", 200);
	if( folio != '' && !isNaN(folio) && esTab){
			habilitaBoton('generar', 'submit');
			solBuroCredServicio.consulta(1, solicitudBeanCon,function(solicitud) {

					if(solicitud!=null){
						$('#claveUsuariob').val(solicitud.claveUsuario);
						var fecha = solicitud.fechaConsulta.substring(0,16);
						$('#fechaConsulta').val(fecha);
						var fech =fecha.substring(11,16);
						$('#hora').val(fech);
						/* Obtener el Folio de Buró */
						var solBuroBean ={
								'RFC' : $('#RFC').val(),
								'empresaID':1
						};
						solBuroCredServicio.consulta(3,solBuroBean,function(folio) {
							if(folio !=null){
									cadenaFolioBur = folio.folioConsulta;
									varFolioBuro = cadenaFolioBur.split("&");
									$('#folioConsulta').val(varFolioBuro[1]);
									$('#diasVigenciaBC').val(folio.diasVigencia);
									diasRestantes = folio.diasVigencia;

							}
						});

					}else{
						$('#claveUsuariob').val("");
					}
			});

	}
}



//Funcion para consultar el folio de Circulo de credito
	function consultaFolioCC(folio) {
		var solicitudBeanCon = {
		'folioConsultaC' :folio
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if( folio != '' && !isNaN(folio)){
			habilitaBoton('generar', 'submit');
			  solBuroCredServicio.consulta(2, solicitudBeanCon,function(solicitud) {
				if(solicitud!=null){
						$('#claveUsuario').val(solicitud.claveUsuario);
						var fecha = solicitud.fechaConsulta.substring(0,16);
						$('#fechaConsulta').val(fecha);
						var fech =fecha.substring(11,16);
						$('#hora').val(fech);
						$('#usuarioCirculo').val(solicitud.usuario);
					}else{
						$('#claveUsuario').val("");
						}
				});

		}
	}

 /*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha NO Válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Errónea");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);

	if (xAnio > yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				return true;
			}
			if (xMes == yMes){
				if (xDia > yDia){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}else{
			return false ;
		}
	}
}

//Regresar el foco a un campo de texto. Habia problemas al regresar el foco a un input en el nav. firefox
function regresarFoco(idControl){
	var jqControl=eval("'#"+idControl+"'");
	setTimeout(function(){
		$(jqControl).focus();
	 },0);
}

// funcion para limpiar el formulario
function limpiaCampos(){
	$('#primerNombre').val("");
	$('#segundoNombre').val("");
	$('#tercerNombre').val("");
	$('#apellidoPaterno').val("");
	$('#apellidoMaterno').val("");
	$('#fechaNacimiento').val("");
	$('#RFC').val("");
	$('#folioConsulta').val("");
	$('#fechaConsulta').val("");

	$('#calle').val("");
	$('#numeroExterior').val("");
	$('#numeroInterior').val("");
	$('#piso').val("");
	$('#lote').val("");
	$('#manzana').val("");
	$('#coloniaID').val("");
	$('#nombreColonia').val("");
	$('#estadoID').val("");
	$('#municipioID').val("");
	$('#nombreEstado').val("");
	$('#nombreMuni').val("");
	$('#CP').val("");
	$('#localidadID').val("");
	$('#nombreLocalidad').val("");
	$('#numeroFirma').val("");
	$('#estadoCivil').val("");
	$('#sexo').val("");
	$('#importe').val("");
	$('#tipoCuenta').val("");
	$('#tipoContratoCCIDDes').val("");
	$('#diasVigenciaBC').val("");
	$('#prospectoID').val("");
	$('#telefono').val("");
	$('#telefonoCelular').val("");
	$('#telTrabajo').val("");
}

function consultaCirculoCreditoEstatus(rfc) {
	if(rfc != "" ){
		var consultaCCporRFC = 4;
		bean = {
				'RFC':rfc
		};
		if(rfc != '' ){
			solBuroCredServicio.consulta(consultaCCporRFC,bean,function(ccrebean) {
				if(ccrebean!=null){
					var varCliente = "";
					if($('#clienteID').asNumber()==0){
						varCliente = ("00000000" + $('#prospectoID').asNumber()).slice (-8); // completa con 8 ceros a la izquierda
					}else{
						varCliente = ("00000000" + $('#clienteID').asNumber()).slice (-8); // completa con 8 ceros a la izquierda
					}
					$('#numeroFirma').val($('#abreviaturaCirculo').val()+
							("0000" + parametroBean.sucursal).slice (-4)+ // completa con 4 ceros a la izquierda
							varCliente+
							ccrebean.consecutivoFol);
					if(ccrebean.folioConsultaC != '' && ccrebean.folioConsultaC!=null && ccrebean.diasVigencia >0 ){
						$('#folioConsulta').val(ccrebean.folioConsultaC);
						$('#diasVigenciaBC').val(ccrebean.diasVigencia);
						$('#fechaConsulta').val(ccrebean.fechaConsulta.substring(0,16));
						diasRestantes = ccrebean.diasVigencia;
						validaFolioBoton(ccrebean.folioConsultaC);
					}else{
						$('#folioConsulta').val('');
						$('#diasVigenciaBC').val('');
						$('#fechaConsulta').val('');

						validaFolioBoton("");
					}
				} else{
					$('#folioConsulta').val('');
					$('#diasVigenciaBC').val('');
					$('#fechaConsulta').val('');
					validaFolioBoton("");
				}
			});
		}else{
			mensajeSis("El RFC del "+$('#socioCliente').val()+" es Incorrecto, Generar Nuevamente.");
		}
	}
}


//funcion para mostrar campos de circulo de credito
function mostrarSeccionCirculoCredito(){
	$('#legendtext').text('Consulta Círculo Crédito');
	$('#consulta').val('Consultar en CC');
	$('#circuloItems').show();

	$('#tipoContratoCCIDDes').show();
	$('#lblTipoCuenta').show();
	$('#tipoCuenta').show();
}

// funcion para Completar con Ceros a la Izquierda de una Cadena
function   completaCerosIzquierda(cadena, longitud) {
  var strPivote = '';
  var i=0;
  var longitudCadena=cadena.toString().length;
  var cadenaString=cadena.toString();

  for ( i = longitudCadena; i < longitud; i++) {
	strPivote = strPivote + '0';
  }

  return strPivote +cadenaString;
}



function generarReporteAutCred() {
	var tipoReporteCC = 2;
	var nombreInst  = 	parametroBean.nombreInstitucion;
	var fechaCon    =   $('#fechaConsulta').val();
	var fechaAct    =   parametroBean.fechaSistema;
    var nombreCom   =   $('#primerNombre').val()+" "+$('#segundoNombre').val()+" "+$('#tercerNombre').val()+" "+$('#tercerNombre').val()+""+$('#apellidoPaterno').val()+" "+ $('#apellidoMaterno').val();
    var primerNom   =   $('#primerNombre').val();
    var segundoNom  =   $('#segundoNombre').val();
    var tercerNom   =   $('#tercerNombre').val();
    var apellidoPat =   $('#apellidoPaterno').val();
    var apellidoMat =   $('#apellidoMaterno').val();
    var calle       =   $('#calle').val();
    var numeroExt   =   $('#numeroExterior').val();
    var numeroInt   =   $('#numeroInterior').val();
    var nomColonia  =   $('#nombreColonia').val();
    var nombreLocalidad =   $('#nombreLocalidad').val();
    var	municipio      =   $('#nombreMuni').val();
    var nombreEstado	= $('#nombreEstado').val();
    var cp              =   $('#CP').val();
    var sucursalID      =   parametroBean.sucursal;
    var numFirma        =   $('#numeroFirma').val();
    var fechaSis        =   parametroBean.fechaSucursal;

    var fechaNac    =   $('#fechaNacimiento').val();
	var rfc         =   $('#RFC').val();
	var importe     =   $('#importe').val();
	var tipoCuenta  =   $('#tipoCuenta').val();
	var estadoID    =   $('#estadoID').val();
	var municipioID =   $('#municipioID').val();
	var coloniaID   =   $('#coloniaID').val();
	var folio	    =	$('#folioConsulta').val();
	var localidadID	=	$('#localidadID').val();
	var piso = $('#piso').val();
	var lote	 = $('#lote').val();
	var manzana	 = $('#manzana').val();
	enlace = '';
	var nomCompleto	=	primerNom;

	if(segundoNom != ''){
	   nomCompleto = nomCompleto + ' '+  segundoNom;
	}
	if(tercerNom != ''){
	    nomCompleto = nomCompleto + ' ' + tercerNom;
	}
	nomCompleto = nomCompleto + ' '+ apellidoPat;
	if (apellidoMat != '') {
	  nomCompleto = nomCompleto + ' '+ apellidoMat;
	}

   var direccion= calle +', No.'+ numeroExt;

	if (numeroInt != ''){
	    direccion = direccion + ', Int.: ' + numeroInt;
	}
	if (piso != ''){
	    direccion = direccion + ', Piso: ' + piso;
	}
	if (lote != ''){
	    direccion = direccion + ', Lote: ' + lote;
	}
 	if (manzana != ''){
	    direccion = direccion + ', Mz.: ' + manzana;
	}

	direccion = direccion + ', ' + nomColonia + ', ' + nombreLocalidad + ', ' + municipio + ', '+ nombreEstado + ', CP: '+ cp;

	var contadorError = 0;

		if($('#folioConsulta').val() != ''){
			 confirmar = confirm("Consulta Vigente,¿Está seguro que desea realizar nuevamente la Consulta?");
			 if(confirmar == true && contadorError == 0){

				 enlace ='ReporteAutorizacionCred.htm?programaID='+nombreInst+
							'&folioConsulta='+folio+'&tipoReporte='+tipoReporteCC+'&nombreCompleto='+nombreCom+
							'&direccion='+direccion+'&sucursalID='+sucursalID+'&numeroFirma='+numFirma;
							deshabilitaBoton('generarRepAutCred', 'submit');
				 window.open(enlace,'_blank');
							$('#consulta').show();
							$('#generarRep').show();
			 }
			 else {
				 return false;
			 }
		}



    if($('#folioConsulta').val() == ''){
    	if(contadorError == 0){
    		enlace = 'ReporteAutorizacionCred.htm?programaID='+nombreInst+
    		'&fechaConsulta='+fechaCon+
    		'&fechaActual='+fechaAct+
    		'&folioConsulta='+folio+
    		'&usuario='+$('#claveUsuario').val()+
    		"&tipoReporte="+tipoReporteCC+
    		"&primerNombre="+primerNom+
    		"&segundoNombre="+segundoNom+
    		"&tercerNombre="+tercerNom+
    		"&apellidoPaterno="+apellidoPat+
    		"&apellidoMaterno="+apellidoMat+
    		'&nombreCompleto='+nombreCom+

    		'&calle='+calle+
    		'&numeroExterior='+numeroExt+

    		'&numeroInterior='+numeroInt+
    		'&nombreColonia='+nomColonia+
    		'&municipio='+municipio+
    		'&CP='+cp+

    		'&direccion='+direccion+
    		'&sucursalID='+sucursalID+
    		'&numeroFirma='+numFirma+
    		'&fechaSistema='+fechaSis;
			window.open(enlace,'_blank');
    		deshabilitaBoton('generarRepAutCred', 'submit');
    		$('#consulta').show();
    		$('#generarRep').show();
    	}else{
        	return false;
        }
    }
}

function consultaAbreviaturaCirculo(){
		setTimeout("$('#cajaLista').hide();", 200);
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(1,parametrosSisCon, function(varParamSistema) {
			if (varParamSistema != null) {
				if ( $('#consultaCC').is(':checked') ) {	// si selecciona Buro
					$('#abreviaturaCirculo').val(varParamSistema.abreviaturaCirculo);
				}
			}
		});
	}

// IALDANA

function ClienteEspeficio(){

		var tipoConsulta = 13;
			paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
			if(valor!=null){
					
					numeroCliente=valor.valorParametro;
				}
			}
		});
	}
