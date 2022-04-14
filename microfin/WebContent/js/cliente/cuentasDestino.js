var domicilia;
var nombreInst;

$(document).ready(function() {
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoTranCuentasTranfer = {
		'alta' : '1',
		'actualiza' : '2',
		'modifica' :'2'
	};
	var catTipoActCuentasTranfer = {
		'actualizaEstatus' : '1',
		'actualizaEstDomicilia' : '3'
	};
	var catTipoConCuentasTranfer = {
		'principal' : '1'
	};
	var catTipoConsultaInstituciones = {
		'foranea' : '2'
	};

	var catTipoConsultaCtaNostro = {
		'folioInstit' : 5,
	};

	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------

	$('#finterna').show();

	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('baja', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#clienteID').focus();


	$.validator.setDefaults({
		submitHandler : function(event) {grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma',
					'mensaje', 'false', 'cuentaTranID','exitoCuentasTranfer','falloCuentasTranfer');
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});
	var parametroBean = consultaParametrosSession();
	$('#fechaRegistro').val(parametroBean.fechaSucursal);

	$('#agregar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCuentasTranfer.alta);
		$('#tipoActualizacion').val(catTipoActCuentasTranfer.actualizaEstatus);
	});

	$('#baja').click(function() {
		$('#tipoTransaccion').val(catTipoTranCuentasTranfer.actualiza);
		$('#tipoActualizacion').val(catTipoActCuentasTranfer.actualizaEstatus);
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCuentasTranfer.modifica);
		$('#tipoActualizacion').val(catTipoActCuentasTranfer.actualizaEstDomicilia);
	});

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '2', '1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
		habilitaTipoCuenta(true);
		$('#aplicaPara').val("");
		$('#estatusDomicilio').val("");
		$('.domiciliacion').hide();
	});

	$('#cuentaTranID').bind('keyup',function(e) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			camposLista[1] = "tipoCuenta";
			parametrosLista[0] = $('#clienteID').val();
			parametrosLista[1] = $('input[name=tipoCuenta]:checked').val();

			if (parametrosLista[1] == "I") { // tipointerna
				lista('cuentaTranID', '2', '2',camposLista,parametrosLista,'cuentasDestinoLista.htm');

			} else if (parametrosLista[1] == "E") { // tipoexterna
				lista('cuentaTranID', '2', '5',camposLista,parametrosLista,'cuentasDestinoLista.htm');
			}
		});

	$('#cuentaTranID').blur(function() {
		if(esTab){
			consultaCuentaTranfer($('#cuentaTranID').val());
		}
	});

	$('#institucionID').bind(
			'keyup',
			function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombre";
				parametrosLista[0] = $('#institucionID').val();
				lista('institucionID', '1', '4', camposLista,
						parametrosLista,
						'listaInstituciones.htm');
			});

	$('#institucionID').blur(function() {
		consultaInstitucion(this.id);

	});

	$('#clabe').blur(function() {
		if ($('#tipoCuentaSpei').val() == '40' && $('#clabe').val() != "" && $('#institucion').val() != "") {
			validaExisteFolio('clabe','institucion');
		}else if ($('#tipoCuentaSpei').val() == '3' && $('#clabe').val() != "" && $('#institucion').val() != "") {
			validaTargeta();
		}else if ($('#tipoCuentaSpei').val() == '10' && $('#clabe').val() != "" && $('#institucion').val() != "") {
			validaNumTelefono();
		}


	});

	$('input[name="tipoCuenta"]').change(function (event){
		mostrartcChange(true);
		habilitaTipoCuenta(true);
	});

	$('#clienteID').blur(function() {
		habilitaTipoCuenta(true);
		$('#tipoCuentaI').attr("checked",true);
		$('input[name="tipoCuenta"]').change();
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');
		$('#clabe').val('');
		$('#beneficiario').val('');
		$('#alias').val('');
		$('#cuentaTranID').val('');
		$('#cuentaAhoIDCa').val("");
		$('#tipoCuentaCa').val("");
		$('#institucionID').val("");
		$('#nombreInstitucion').val("");
		$('#numClienteCa').val("");
		$('#nombreClienteCa').val("");
		$('#estatus').val("");
		$('#fechaRegistro').val(parametroBean.fechaSucursal);
		$('#institucion').val('');
		$('#tipoCuentaSpei').val('');
		$('#beneficiarioRFC').val('');
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('baja', 'submit');
	});

	$('#cuentaAhoIDCa').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#cuentaAhoIDCa').val();
			lista('cuentaAhoIDCa', '2', '3',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
		}
	});

	$('#cuentaAhoIDCa').blur(function() {
		if(esTab){
			consultaCtaAhoCargo($('#cuentaAhoIDCa').val());
		}
	});

	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');
	});

	$('#numCtaInstit').blur(function(){
   		if($('#numCtaInstit').val()!="" && $('#institucionID').val()!=""){
   			validaCtaNostroExiste('numCtaInstit','institucionID');
   		}
   	});

	$('#beneficiarioRFC').blur(function() {
		if ($('#beneficiarioRFC').val() != "" && $('#institucionID').val() != "") {
			var longitudRFC=$('#beneficiarioRFC').val().length;

			if(longitudRFC == 18){
				validarCURP();
			}else if (longitudRFC == 12 || longitudRFC == 13){
				validaRFC();
			}else {
				mensajeSis("Epecificar un valor válido");
				$('#beneficiarioRFC').focus();
			}

		}
	});

	$('#estatusDomicilio').blur(function(){
		var tipo = $('#estatusDomicilio').val();
		var estatusCD = $('#estatus').val();

		if(tipo == 'N' && estatusCD == 'ACTIVO'){

			habilitaBoton('modificar','submit');
		}else{

			deshabilitaBoton('modificar','submit');
		}
	});


	// ------------ Validaciones de la Forma
	// -------------------------------------
	$('#formaGenerica').validate({
		rules : {
			clienteID : {
				required : true
			},
			cuentaTranID : {
				required : true,
				numeroPositivo : true
			},
			institucionID : {
				required: function() {return $('#tipoCuentaE').is(':checked');},
				numeroPositivo : true
			},
			clabe : {
				required : function() {return $('#tipoCuentaE').is(':checked');},
				numeroPositivo : true,
			},
			beneficiario : {
				required : function() {return $('#tipoCuentaE').is(':checked');}
			},
			alias : {
				required : function() {return $('#tipoCuentaE').is(':checked');}
			},
			fechaRegistro : {
				required : true,
				date : true
			},
			cuentaDestino:{
				required : true,
				numeroPositivo : true
			},
			tipoCuentaSpei : {
				required : function() {return $('#tipoCuentaE').is(':checked');}
			},
			aplicaPara : {
				required : function() {return $('#tipoCuentaE').is(':checked');}
			}
		},
		messages : {
			clienteID : {
				required : 'Especificar Cliente',
				numeroPositivo : 'Sólo Números',
			},
			cuentaTranID : {
				required : 'Especificar Cuenta',
				numeroPositivo : 'Sólo Números',
			},
			institucionID : {
				required : 'Especificar Institución',
				numeroPositivo : 'Sólo Números',
			},
			clabe : {
				required : 'Especificar Cuenta',
				numeroPositivo : 'Sólo Números',
			},
			beneficiario : {
				required : 'Especificar el Beneficiario'
			},
			alias : {
				required : 'Especificar Alias'
			},
			fechaRegistro : {
				required : 'Fecha de Registro',
				date : 'Fecha incorrecta'
			},
			tipoCuentaSpei : {
				required : 'Especificar Tipo Cuenta SPEI'
			},
			aplicaPara :{
				required : 'Especificar Aplicación de la cuenta'
			}



								}
	});

	// --------------------------CONSULTAS-----------------------------

	function consultaCuentaTranfer(cuentasTranfer) {

		setTimeout("$('#cajaLista').hide();", 200);
		if (cuentasTranfer != '' && !isNaN(cuentasTranfer)) {
			if (cuentasTranfer == '0') {
				inicializacamposCuenta();
			} else {
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				habilitaBoton('baja', 'submit');

				var Baja="B";
				var Autorizado="A";
				var cuentas = {
					'clienteID' : $('#clienteID').val(),
					'cuentaTranID' : $('#cuentaTranID').val()
				};

				cuentasTransferServicio.consulta(1,cuentas,function(cuenta) {
						if (cuenta != null) {

							dwr.util.setValues(cuenta);
							if (cuenta.estatus == Baja) {
								$('#estatus').val('BAJA');
								deshabilitaControl('aplicaPara');
								deshabilitaControl('estatusDomicilio');
								mensajeSis("La Cuenta Destino fue Cancelada.");
								//$('#cuentaTranID').focus();
								deshabilitaBoton('agregar','submit');
								deshabilitaBoton('baja','submit');

							}else{
								if(cuenta.estatus == Autorizado) {
									$('#estatus').val('ACTIVO');
									deshabilitaBoton('agregar','submit');
									habilitaBoton('baja','submit');
								}
							}
							if (cuenta.tipoCuenta=="E") {
								esTab = true;
								consultaInstitucion('institucionID');
								deshabilitaControl('aplicaPara');
								if(cuenta.estatusDomicilio=='B' && cuenta.estatus == 'A'){

									$("#estatusDomicilio").empty();
									 $("#estatusDomicilio").append('<option value="N">NO AFILIADA</option>');
									 $("#estatusDomicilio").append('<option value="B">BAJA</option>');
									 $("#estatusDomicilio").append('<option value="A">AFILIADA</option>');
									 $("#estatusDomicilio option[value="+ cuenta.estatusDomicilio +"]").attr("selected",true);
									 habilitaControl('estatusDomicilio');
								}else{
									deshabilitaControl('estatusDomicilio');
								}

								if(cuenta.aplicaPara=="S"){
									$('.domiciliacion').hide();
								}
								else{
									$('.domiciliacion').show();
								}

							} else if (cuenta.tipoCuenta=="I") {
								consultaCtaAhoCargo(cuenta.cuentaDestino);
							}
							mostrartcChange(false);
							habilitaTipoCuenta(false);
						} else {
							mensajeSis("No Existe la cuenta Destino");
							deshabilitaBoton('agregar','submit');
							deshabilitaBoton('baja','submit');
							deshabilitaBoton('modificar','submit');
							$('#cuentaTranID').select();
							$('#cuentaTranID').focus();
							$('#institucionID').val('');
							$('#nombreInstitucion').val('');
							$('#clabe').val('');
							$('#beneficiario').val('');
							$('#alias').val('');
							$('#estatus').val('');
							$('#fechaRegistro').val(parametroBean.fechaSucursal);
							$('#cuentaAhoIDCa').val('');
							$('#tipoCuentaCa').val('');
							$('#nombreClienteCa').val('');
							$('#numClienteCa').val('');
							$('#institucion').val('');
							$('#tipoCuentaSpei').val('');
							$('#beneficiarioRFC').val('');

						}
					});

			}
		}
		if (cuentasTranfer != '' && isNaN(cuentasTranfer) && esTab) {
			mensajeSis("No Existe la Cuenta Destino");
			$('#institucionID').val('');
			$('#nombreInstitucion').val('');
			$('#clabe').val('');
			$('#beneficiario').val('');
			$('#alias').val('');
			$('#institucion').val('');
			$('#tipoCuentaSpei').val('');
			$('#beneficiarioRFC').val('');

		}
	}

	// Funcion de consulta para obtener el nombre de la
	// institucion
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID' : numInstituto
		};

		if (numInstituto != ''  && !isNaN(numInstituto) && esTab) {
			institucionesServicio.consultaInstitucion(4,InstitutoBeanCon, function(instituto) {
						if (instituto != null) {
							if (instituto.claveParticipaSpei != '0') {

								$('#nombreInstitucion').val(instituto.nombre);
								$('#institucion').val(instituto.institucionID);
								domicilia = instituto.domicilia;
								nombreInst = instituto.nombreCorto;
							}
							else {
								mensajeSis("No existe la Institución");
								$('#institucionID').val('');
								$('#institucionID').focus();
								$('#nombreInstitucion').val("");
							}

						} else {
							mensajeSis("No existe la Institución");
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nombreInstitucion').val("");
							$('#aplicaPara').val("");
							$('#estatusDomicilio').val("");
							$('.domiciliacion').hide();
						}
					});
		}

	}

	function validaExisteFolio(clabe, institID) {
		var jqclabe = eval("'#" + clabe + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqclabe).val();
		var institucionID = $(jqInstitucionID).val();
		var longitudClabe=$('#clabe').val().length;
		var CtaNostroBeanCon = {
			'institucionID' : institucionID,
			'numCtaInstit' : numCtaInstit
		};


		if (longitudClabe != 18){
					mensajeSis("La Clabe Interbancaria debe Tener 18 Digítos");
					$('#clabe').val("");
					$('#clabe').focus();
					deshabilitaBoton('agregar','submit');
		}
		else if ( numCtaInstit !='' ) {
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.folioInstit,CtaNostroBeanCon,function(ctaNtro) {
				if (ctaNtro != null) {
					var folio = ctaNtro.cuentaClabe;// el de institucion  se paso en el parametro cuentaClabe																	// folio
					var cuentaClabe = $('#clabe').val();
					var substrClabe = cuentaClabe.substr(0, 3);

					if (folio != substrClabe) {
						mensajeSis("La Cuenta Clabe no coincide con la Institución.");
						$('#clabe').select('');
						$('#clabe').focus();


					}else {
						validaCLABE('clabe');
					}
				}
			});
		}else{
			if(numCtaInstit == ''){
				$('#clabe').select('');
				$('#clabe').focus();
			}
		}
	}


	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					 if (cliente.estatus=='I'){
							deshabilitaBoton('agregar','submit');
							deshabilitaBoton('baja','submit');
							deshabilitaBoton('modificar','submit');
							mensajeSis("El Cliente se encuentra Inactivo");
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
					 }
				} else {
					mensajeSis("No Existe el Cliente");
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#clienteID').focus();


				}
			});
		} else {
			$('#nombreCliente').val('');
			$('#cuentaTranID').val('');

		}

	}
	function validaCtaNostroExiste(numCta,institID){
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  		};

		setTimeout("$('#cajaLista').hide();", 200);
  	if(numCtaInstit != '' && !isNaN(numCtaInstit) && institucionID != '' && !isNaN(institucionID) ){

  			cuentaNostroServicio.consultaExisteCta(4,CtaNostroBeanCon, function(ctaNostro){

  				if(ctaNostro!=null){

					var estatuscta=ctaNostro.estatus;
					 nombreInsti=$('#nombreInstitucion').val();

	  				if(estatuscta =='A'){
  					$('#clabe').val(ctaNostro.Clabe);
	  				}
	  				else if(estatuscta =='I'){
	  					mensajeSis("El Número de Cuenta Bancaria esta Inactiva");
						$('#numCtaInstit').focus();
						$('#numCtaInstit').val('');
						$('#cuentaClabe').val('');
	  				}
  				}
  				else{
  					mensajeSis("El Número de Cuenta No Existe");
  					$('#numCtaInstit').focus();
					$('#numCtaInstit').val('');
  					$('#clabe').val('');
  				}
  			});
  		}
  	}



	function mostrartcChange(inicializar) {
		setTimeout("$('#cajaLista').hide();", 200);
		if ($('#tipoCuentaI').is(':checked') == true) {
			$('#finterna').show();
			$('#fexterna').hide();
			if(inicializar){
				$('#estatus').val('ACTIVO');
	            $('#cuentaTranID').val("");
				$('#institucionID').val("");
				$('#nombreInstitucion').val("");
				$('#numClienteCa').val("");
				$('#nombreClienteCa').val("");
				$('#estatus').val("");
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('baja', 'submit');
			}
		} else if ($('#tipoCuentaE').is(':checked') == true) {
			$('#finterna').hide();
			$('#fexterna').show();
			if(inicializar){
				$('#estatus').val('ACTIVO');
				$('#cuentaAhoIDCa').val("");
				$('#tipoCuentaCa').val("");
				$('#beneficiario').val("");
				$('#alias').val("");
				$('#clabe').val("");
				$('#cuentaTranID').val("");
				$('#estatus').val("");
				$('#tipoCuentaSpei').val("");
				$('#beneficiarioRFC').val("");
				$('#nombreInstitucion').val("");
				$('#aplicaPara').val("");
				$('#estatusDomicilio').val("");
				$('.domiciliacion').hide();
				habilitaControl('aplicaPara');
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('baja', 'submit');
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
			}
		}
	}// fin mostrartc

	function consultaCtaAhoCargo(cuentaDestino) {
		var numCta = cuentaDestino;
		var tipConCampos = 4;

		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos,CuentaAhoBeanCon,function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuentaCa').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoIDCa').val(cuenta.cuentaAhoID);
					$('#numClienteCa').val(cuenta.clienteID);
					esTab = "true";
					consultaClienteDestino('numClienteCa');

				} else {
					mensajeSis("No Existe la cuenta de ahorro");
					$('#cuentaAhoIDCa').focus();
					$('#cuentaAhoIDCa').select();
				}
			});
		}
	}

	function consultaClienteDestino(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(tipConForanea, numCliente,
					function(cliente) {
						if (cliente != null) {
							$('#numClienteCa').val(cliente.numero);
							$('#nombreClienteCa').val(cliente.nombreCompleto);

						} else {
							mensajeSis("No Existe el Cliente");
							$('#numClienteCa').val('');
							$('#nombreClienteCa').val('');

						}
					});
		}
	}

}); // cerrar
function exitoCuentasTranfer() {
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#clabe').val('');
	$('#estatus').val('');
	$('#beneficiario').val('');
	$('#alias').val('');
	$('#institucion').val('');
	$('#tipoCuentaSpei').val('');
	$('#beneficiarioRFC').val('');

	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#cuentaAhoIDCa').val('');
	$('#tipoCuentaCa').val('');
	$('#nombreClienteCa').val('');
	$('#numClienteCa').val('');

	$('#aplicaPara').val("");
	$('#estatusDomicilio').val("");
	$('.domiciliacion').hide();

	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('baja', 'submit');
}
function falloCuentasTranfer() {
	$('#fechaRegistro').val(parametroBean.fechaSucursal);

}

function inicializacamposCuenta(){
	$('#estatus').val('ACTIVO');
	if ($('#clienteID').asNumber() > 0) {
		habilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('baja', 'submit');
	} else {
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('baja', 'submit');
	}
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#clabe').val('');
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#clabe').val('');
	$('#beneficiario').val('');
	$('#alias').val('');
	$('#cuentaAhoIDCa').val("");
	$('#tipoCuentaCa').val("");
	$('#institucionID').val("");
	$('#nombreInstitucion').val("");
	$('#numClienteCa').val("");
	$('#nombreClienteCa').val("");
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#alias').val('');
	$('#institucion').val('');
	$('#tipoCuentaSpei').val('');
	$('#beneficiarioRFC').val('');
	habilitaTipoCuenta(true);
	$('#aplicaPara').val("");
	$('#estatusDomicilio').val('N');
	$('.domiciliacion').hide();
	habilitaControl('aplicaPara');
	deshabilitaControl('estatusDomicilio');
}



function validaRFC(){
	esTab=true;
	expr = /^[a-zA-Z]{3,4}(\d{6})((\D|\d){3})?$/;

	var claveRFC = $('#beneficiarioRFC').val();

	if(claveRFC != '' && esTab){
	    if (!expr.test(claveRFC)) {
	       mensajeSis("El RFC no es válido");
	       $('#beneficiarioRFC').focus();

	     }
	}
}

function validarCURP(){
	var curp = $('#beneficiarioRFC').val();
	if(curp.match(/^([a-z]{4})([0-9]{6})([a-z]{6})([0-9]{2})$/i)){
	}else{
	mensajeSis('La CURP no es válida');
	$('#beneficiarioRFC').focus();
	}
}


//VALIDACION ULTIMO DIGITO VERIFICADOR CLABE

function validaCLABE(clabe) {
	var jqclabe = eval("'#" + clabe + "'");
	var cuenClabe= $(jqclabe).val();

	if ( cuenClabe !='' ) {
	// Numeros que componen la CLABE
	var substClabeUno = cuenClabe.substr(0, 1);
	var substClabeDos = cuenClabe.substr(1,1);
	var substClabeTres = cuenClabe.substr(2, 1);
	var substClabeCuatro = cuenClabe.substr(3, 1);
	var substClabeCin = cuenClabe.substr(4, 1);
	var substClabeSeis = cuenClabe.substr(5, 1);
	var substClabeSiete = cuenClabe.substr(6, 1);
	var substClabeOcho = cuenClabe.substr(7, 1);
	var substClabeNue = cuenClabe.substr(8, 1);
	var substClabeDiez = cuenClabe.substr(9, 1);
	var substClabeOnce = cuenClabe.substr(10, 1);
	var substClabeDoce = cuenClabe.substr(11, 1);
	var substClabeTrece = cuenClabe.substr(12, 1);
	var substClabeCator = cuenClabe.substr(13, 1);
	var substClabeQui = cuenClabe.substr(14, 1);
	var substClabeDieSeis = cuenClabe.substr(15, 1);
	var substClabeDieSiete = cuenClabe.substr(16, 1);
	var substClabeDieOch = cuenClabe.substr(17, 1);


	//Factores de ponderación
	var pondeTres = 3;
	var pondeSiete = 7;
	var pondeUno = 1;

	// resultados de multiplicacion de factor de ponderacion por los de numero de la CLABE
	var resultUno = (substClabeUno * pondeTres);
	var resultDos = (substClabeDos * pondeSiete);
	var resultTres = (substClabeTres * pondeUno);
	var resultCuatro = (substClabeCuatro * pondeTres);
	var resultCinco = (substClabeCin * pondeSiete);
	var resultSeis = (substClabeSeis * pondeUno);
	var resultSiete = (substClabeSiete * pondeTres);
	var resultOcho = (substClabeOcho * pondeSiete);
	var resultNueve = (substClabeNue * pondeUno);
	var resultDiez = (substClabeDiez * pondeTres);
	var resultOnce = (substClabeOnce * pondeSiete);
	var resultDoce = (substClabeDoce * pondeUno);
	var resultTrece = (substClabeTrece * pondeTres);
	var resultCatorce = (substClabeCator * pondeSiete);
	var resultQuince = (substClabeQui * pondeUno);
	var resultDieSeis = (substClabeDieSeis * pondeTres);
	var resultDieSiete = (substClabeDieSiete * pondeSiete);

	//resultados de residuo de la division del resultado de la multiplicacion entre 10
	var resModUno = (resultUno%10);
	var resModDos = (resultDos%10);
	var resModTres = (resultTres%10);
	var resModCuatro = (resultCuatro%10);
	var resModCinco = (resultCinco%10);
	var resModSeis = (resultSeis%10);
	var resModSiete = (resultSiete%10);
	var resModOcho = (resultOcho%10);
	var resModNueve = (resultNueve%10);
	var resModDiez = (resultDiez%10);
	var resModOnce = (resultOnce%10);
	var resModDoce = (resultDoce%10);
	var resModTrece = (resultTrece%10);
	var resModCatorce = (resultCatorce%10);
	var resModQuince = (resultQuince%10);
	var resModDieSeis = (resultDieSeis%10);
	var resModDieSiete = (resultDieSiete%10);

	//suma total del resultado de los residuos de cada division
	var suma = (resModUno + resModDos + resModTres + resModCuatro +
			  resModCinco + resModSeis + resModSiete + resModOcho +
			  resModNueve + resModDiez + resModOnce + resModDoce +
			  resModTrece + resModCatorce + resModQuince + resModDieSeis +
			  resModDieSiete );

	//residuo de la suma total entre 10

	var resulTotal = (suma%10);
	//se resta a 10 el resultado del residuo
	var resta = (10-resulTotal);
	//el digito verificador es el residuo de  dividir el resultado de la resta entre 10
	var digVerificador = (resta%10);

	if( substClabeDieOch != digVerificador){
		mensajeSis("Digíto verificador incorrecto.");
		deshabilitaBoton('agregar','submit');
		$('#clabe').focus();

	}else{
		if( domicilia != 'N'){
			habilitaBoton('agregar','submit');
		}
	}
	}else{
		if(numCtaInstit == ''){
			$('#clabe').focus();
		}
	}
	}


function validaLongitudClabe() {
	var longitudClabe=$('#clabe').val().length;

		if (longitudClabe != 18){

					mensajeSis("La Clabe Interbancaria debe Tener 18 Dígitos");
					$('#clabe').val("");
					$('#clabe').focus();
					deshabilitaBoton('agregar','submit');
					}else{
					//	validaExisteFolio('clabe','institucion');
					}
		}


function validaTargeta() {
	var longitudTarjeta=$('#clabe').val().length;

		if (longitudTarjeta != 16){

				var numeroTar=$('#clabe').val();
				var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
					numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
					numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
					numeroTar=numTarIdenAccess;

					$('#clabe').val(numeroTar);
					mensajeSis("El Número de Tarjeta debe Tener 16 Digítos");
					$('#clabe').focus();
					deshabilitaBoton('agregar','submit');
					}else{
					habilitaBoton('agregar','submit');

					}
		}


function validaNumTelefono() {
	var longitudNumTel=$('#clabe').val().length;

		if (longitudNumTel != 10){

					mensajeSis("El Número de Telefono debe Tener 10 Digítos");
					$('#clabe').focus();
					deshabilitaBoton('agregar','submit');
					}else{
					habilitaBoton('agregar','submit');
					}
		}

	function habilitaTipoCuenta(habilita) {
		setTimeout("$('#cajaLista').hide();", 200);
		if(habilita){
			habilitaControl('alias');
			habilitaControl('beneficiario');
			habilitaControl('beneficiarioRFC');
			habilitaControl('clabe');
			habilitaControl('cuentaAhoIDCa');
			habilitaControl('institucionID');
			habilitaControl('tipoCuentaSpei');
			habilitaControl('esPrincipalNo');
			habilitaControl('esPrincipalSi');
		} else {
			deshabilitaControl('alias');
			deshabilitaControl('beneficiario');
			deshabilitaControl('beneficiarioRFC');
			deshabilitaControl('clabe');
			deshabilitaControl('cuentaAhoIDCa');
			deshabilitaControl('institucionID');
			deshabilitaControl('tipoCuentaSpei');
			deshabilitaControl('esPrincipalNo');
			deshabilitaControl('esPrincipalSi');
		}
	}


$('#aplicaPara').change(function(){
	if($('#institucionID').val() != ''  && !isNaN($('#institucionID').val())){
		if($('#aplicaPara').val() == 'C'|| $('#aplicaPara').val() == 'A'){
			$('.domiciliacion').show();
			if(domicilia=='N' && $('#aplicaPara').val() == 'C'){
				$('#estatusDomicilio').val('');
				mensajeSis("No es posible registrar la cuenta clabe del banco "+nombreInst+" debido a que no maneja el servicio de cobro por domiciliación");
				deshabilitaBoton('agregar');
				deshabilitaBoton('modificar');
				deshabilitaBoton('baja');
			}
		}else{
			habilitaBoton('agregar');
			$('.domiciliacion').hide();
		}
	}else{
		$('#estatusDomicilio').val('');
		$('.domiciliacion').hide();
		$('#institucionID').focus();
		$('#aplicaPara').val("");
		mensajeSis("Debe Seleccionar un Banco");

	}
});