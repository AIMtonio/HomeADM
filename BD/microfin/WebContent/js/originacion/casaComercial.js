$(document).ready(function() {
	esTab = false;

	//Definicion de Constantes y Enums
	var catTipoTransCasa = {
  		'agrega':'1',
  		'modifica':'2'};

	var catTipoConsultaCasa = {
  		'principal'	: 1
	};

	var catTipoConsultaInstituciones = {
	  		'principal':1,
	  		'foranea':2
	};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('modifica', 'submit');

    $('#casaID').focus();
    $('#divinstitucionID').hide();
	$('#divcuentaClabe').hide();
	$('#divRFC').hide();

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','casaID','funcionExito', 'funcionError');
		}
    });

	$('#casaID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCasa";
			parametrosLista[0] = $('#casaID').val();
			listaAlfanumerica('casaID', '2', '1', camposLista, parametrosLista, 'listaCasaComercial.htm');
		}
	});

	$('#casaID').blur(function() {
  		validaCasa(this.id);
	});

	$('#tipoDispersion').change(function() {
		$('#institucionID').val('');
		$('#cuentaClabe').val('');
		$('#descripInst').val("");
		$('#rfc').val('');

		if ($('#tipoDispersion').val() == 'S') {
			$('#divinstitucionID').show();
			$('#divcuentaClabe').show();
			$('#divRFC').show();
			habilitaControl('institucionID');
			habilitaControl('cuentaClabe');
			habilitaControl('rfc');
			$('#institucionID').select();
		} else {
			$('#divinstitucionID').hide();
			$('#divcuentaClabe').hide();
			$('#divRFC').hide();
			deshabilitaControl('institucionID');
			deshabilitaControl('cuentaClabe');
			deshabilitaControl('rfc');
		}
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
    });

     $('#institucionID').blur(function() {
    	consultaInstitucion(this.id);
    });

     $('#cuentaClabe').blur(function() {
		validaCuenta('cuentaClabe','institucionID');
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransCasa.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransCasa.modifica);
	});

	$('#rfc').blur(function() {
		validaRFC($('#rfc').val());
	});



	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			casaID: {
				required: true,
				numeroPositivo: true
			},
			nombreCasa: {
				required: true,
				maxlength: 100,
				minlength: 5
			},
			tipoDispersion:{
				required: true
			},
			institucionID: {
				required : function() {
					return $('#tipoDispersion').val() == 'S';
				},
				numeroPositivo: true
			},
			cuentaClabe : {
				required : function() {
					return $('#tipoDispersion').val() == 'S';
				},
				number : true,
				maxlength : 18
			},
			estatus:{
				required: true
			},
			rfc:{
				required : function() {
					return $('#tipoDispersion').val() == 'S';
				},
				maxlength: 13,
				minlength: 12
			}
		},
		messages: {
			casaID: {
				required: 'Especificar No. de Casa Comercial.',
				numeroPositivo: 'Solo Números'
			},
			nombreCasa: {
				required: 'Especificar Nombre de Casa Comercial.',
				maxlength: 'maximo 200 caracteres',
				minlength: 'minimo 5 caracteres'
			},
			tipoDispersion: {
				required: 'Especificar Tipo de Dispersion.'
			},
			institucionID: {
				required: 'Especificar la Institucion Bancaria.',
				numeroPositivo: 'Solo Números'
			},
			cuentaClabe: {
				required: 'Especificar cuenta CLABE.',
				number : 'Solo Números.',
				maxlength : 'Máximo 18 Números.'
			},
			estatus: {
				required: 'Especificar Estatus.'
			},
			rfc: {
				required: 'Especificar RFC.',
				maxlength: 'maximo 13 caracteres',
				minlength: 'minimo 12 caracteres'
			}

		}
	});

	//------------ Validaciones de Controles -------------------------------------

	function validaCasa(control) {
		var tipoConcepto = $('#casaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoConcepto != '' && !isNaN(tipoConcepto)){
			if(tipoConcepto=='0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				$('#nombreCasa').val("");
				$('#descripcion').val("");
				$('#institucionID').val("");
				$('#descripInst').val("");
				$('#cuentaClabe').val("");
				$('#tipoDispersion').val("");
				$('#estatus').val("");
				$('#rfc').val("");

				habilitaControl("estatus");
				habilitaControl("tipoDispersion");
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var tipoCasaBeanCon = {
  					'casaID':$('#casaID').val()
				};

				casasComercialesServicio.consulta(catTipoConsultaCasa.principal,tipoCasaBeanCon,function(casa) {
					if(casa!=null){
						$('#nombreCasa').val(casa.nombreCasa);
						$('#tipoDispersion').val(casa.tipoDispersion);
						$('#estatus').val(casa.estatus);

						if (casa.tipoDispersion == 'S') {
							$('#divinstitucionID').show();
							$('#divcuentaClabe').show();
							$('#divRFC').show();
							$('#institucionID').val(casa.institucionID);
							$('#cuentaClabe').val(casa.cuentaClabe);
							$('#rfc').val(casa.rfc);
							consultaInstitucion('institucionID');
							habilitaControl('institucionID');
							habilitaControl('cuentaClabe');
							habilitaControl('rfc');
						}else{
							$('#divinstitucionID').hide();
							$('#divcuentaClabe').hide();
							$('#divRFC').hide();
						}

						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						habilitaControl("estatus");
						habilitaControl("tipoDispersion");
					}else{
						mensajeSis("No Existe la Casa Comercial");
						$('#casaID').val("");
						$('#nombreCasa').val("");
						$('#tipoDispersion').val("");
						$('#institucionID').val("");
						$('#descripInst').val("");
						$('#cuentaClabe').val("");
						$('#estatus').val("");
						$('#rfc').val("");

						$('#casaID').focus();

						habilitaControl("estatus");
						habilitaControl("tipoDispersion");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
					}
				});
			}
		}
	}

	//Método de consulta de Institución
    function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};

		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, { async: false, callback:function(instituto){
				if(instituto!=null){
					$('#descripInst').val(instituto.nombre);
					habilitaBoton('grabar','submit');
				}else{
					mensajeSis("No Existe la Institución");
					$(jqInstituto).focus();
					$(jqInstituto).val('');
					$('#descripInst').val('');
					$('#cuentaClabe').val('');
					$('#rfc').val('');
					deshabilitaBoton('grabar','submit');
				}
			}});
		}else{
			$(jqInstituto).val('');
			$('#descripInst').val('');
			$('#cuentaClabe').val('');
			$('#rfc').val('');
			deshabilitaBoton('grabar','submit');
		}
	}

	function validaCuenta(numCta,institID) {
		esTab=true;
		agregaFormatoNumMaximo('formaGenerica');
		var jqCtaClabe = eval("'#" + numCta + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaClabe = $(jqCtaClabe).val();
  		var institucionID = $(jqInstitucionID).val();
		var tipoDisper = $('#tipoDispersion').val();
		if(institucionID != '' && !isNaN(institucionID)){
			if (tipoDisper == 'S' && numCtaClabe != '') {
				if (isNaN(numCtaClabe)) {
					mensajeSis("Ingresar Sólo Números.");
					$('#cuentaClabe').focus();
					$('#cuentaClabe').val('');
				}
				if (numCtaClabe.length == 18 && numCtaClabe != '') {
					if (!isNaN(numCtaClabe)) {
						var folioCta = numCtaClabe.substr(0, 3);
						var tipoConsulta = 5;
						var CtaNostroBeanCon = {
								'institucionID':institucionID,
								'numCtaInstit':0
						};
						cuentaNostroServicio.consultaExisteCta( tipoConsulta, CtaNostroBeanCon,
								{ async: false, callback:function(data) {
									if(data!=null){
										var folio = data.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
										if(folio!=folioCta){
											mensajeSis("La Cuenta Clabe no coincide con la Institución.");
											$('#cuentaClabe').focus();
											$('#cuentaClabe').val('');
										}else{
											validaCLABE('cuentaClabe');
										}
									}
								}
						});
					}
				} else {
					mensajeSis("La Cuenta Clable debe de Tener 18 Caracteres.");
					$('#cuentaClabe').focus();
				}
			}
		}else{
			mensajeSis("Especificar la Institución Bancaria.");
			$('#institucionID').focus();
			$('#institucionID').val('');
			$('#cuentaClabe').val('');
		}
		return false;
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
				$('#cuentaClabe').focus();
			}else{
				habilitaBoton('agregar','submit');
			}
		}else{
			if(numCtaInstit == ''){
				$('#cuentaClabe').focus();
			}
		}
	}

	function validaRFC(rfc){
		var regexp=/^([A-Z,Ñ,&]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})$/;
		if(regexp.test(rfc) == false){
			mensajeSis('El RFC es Incorrecto.');
			$('#rfc').focus();
		}
	}

}); // DOCUMENT READY FIN


//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaForma('formaGenerica','casaID');
	$('#nombreCasa').val("");
	$('#tipoDispersion').val("");
	$('#institucionID').val("");
	$('#descripInst').val("");
	$('#cuentaClabe').val("");
	$('#estatus').val("");
	$('#rfc').val("");

	habilitaControl("estatus");
	habilitaControl("tipoDispersion");
	$('#divinstitucionID').hide();
	$('#divcuentaClabe').hide();
	$('#divRFC').hide();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
}