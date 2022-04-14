$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();

	// Definicion de Constantes y Enums

	var catListaTipoInstrumento = {
		  	'tipoInstrum'	: 3
	};

	var catConTipoProductoCred = {
		  	'principal'	: 1
	};
	var catTipoConsultaCedes = {
			'general' : 2,

	};
	var catTipoConsultaInversiones = {
			'tercera':3
	};
	
	var catTipoConsulFondeadores = {
			'principal':1
	};

	//Definicion de Constantes y Enums
	var catTipoTransaccion = {
	  		'actualiza':1,
		};
	var catTipoActualizaProduc = {
  		'tipoCuentaAhorro':1,
  		'tipoCredito':2,
  		'tipoCede':3,
  		'tipoInversion':4,
  		'fondeador':5
	};
	var catTipoInstrumento = {
			'cuentaAhorro'	: 2,
		  	'credito'	: 11,
		  	'inversionPlazo'	: 13,
		  	'cedes'	: 28,
		  	'fondeador':12

	};
	var tipoInstrumento = 0;
	var tipoInstrCliente = 0;
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#tipoProducto').focus();
	consultaTipoInstrumentos();
	deshabilitaBoton('actualiza', 'submit');
	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
        submitHandler: function(event) {
            grabaFormaTransaccionRetrollamada({}, 'formaGenerica','contenedorForma', 'mensaje', 'true','tipoProducto', 'inicializa','funcionError');
        }
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#actualiza').click(function() {
		var tipoProducto = $('#tipoProducto').asNumber();
		$('#tipoTransaccion').val(catTipoTransaccion.actualiza);
		switch (tipoProducto){
		case catTipoInstrumento.cuentaAhorro:
			$('#tipoActualizacion').val(catTipoActualizaProduc.tipoCuentaAhorro);
		break;
		case catTipoInstrumento.credito:
			$('#tipoActualizacion').val(catTipoActualizaProduc.tipoCredito);
		break;
		case catTipoInstrumento.cedes:
			$('#tipoActualizacion').val(catTipoActualizaProduc.tipoCede);
		break;
		case catTipoInstrumento.inversionPlazo:
			$('#tipoActualizacion').val(catTipoActualizaProduc.tipoInversion);
		break;
		case catTipoInstrumento.fondeador:
			$('#tipoActualizacion').val(catTipoActualizaProduc.fondeador);
		break;
		}
	});
		/*	----------- Validaciones de la Forma -------------------------------------*/

	$('#formaGenerica').validate({
		rules: {
			  numProducto : 'required',
		},
		messages: {
			numProducto : 'Especifique el Número de Producto.',
		}
	});


	$('#tipoProducto').change(function(){
		$('#numProducto').val('');
		limpiarCampos();
		var tipoProducto = $('#tipoProducto').asNumber();
			if(tipoProducto != '0'){
				 habilitaBoton('actualiza', 'submit');
			}else{
				 deshabilitaBoton('actualiza', 'submit');
			}

	});


	$('#numProducto').bind('keyup',function(e){
		var tipoProducto = $('#tipoProducto').asNumber();

		switch (tipoProducto){
		case catTipoInstrumento.cuentaAhorro:
			lista('numProducto', '2', '1', 'descripcion', $('#numProducto').val(), 'listaTiposCuenta.htm');
		break;
		case catTipoInstrumento.credito:
			lista('numProducto', '2', '1', 'descripcion', $('#numProducto').val(), 'listaProductosCredito.htm');
		break;
		case catTipoInstrumento.cedes:
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "descripcion";
			 parametrosLista[0] = $('#numProducto').val();

			lista('numProducto', 2, 1, camposLista,parametrosLista, 'listaTiposCedes.htm');
		break;
		case catTipoInstrumento.inversionPlazo:
			if(this.value.length >= 3){
				var camposLista = new Array();
				 var parametrosLista = new Array();
				 camposLista[0] = "monedaId";
				 camposLista[1] = "descripcion";
				 parametrosLista[0] = 0;
				 parametrosLista[1] = $('#numProducto').val();

				 lista('numProducto', '2', '1', camposLista, parametrosLista, 'listaTipoInversiones.htm');
			}
		break;
		case catTipoInstrumento.fondeador:
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "desTipoFondeador";
			 parametrosLista[0] = $('#numProducto').val();

			lista('numProducto', 2, 1, camposLista,parametrosLista, 'tipoFondeadorLista.htm');
		break;
		}
	});

	$('#numProducto').blur(function() {

		var tipoProducto = $('#tipoProducto').asNumber();

		if(esTab){
			limpiarCampos();
			switch (tipoProducto){
			case catTipoInstrumento.cuentaAhorro:
				consultaTipoCuenta();
			break;
			case catTipoInstrumento.credito:
				consultaProductoCredito();
			break;
			case catTipoInstrumento.cedes:
				consultaTipoCede();
			break;
			case catTipoInstrumento.inversionPlazo:
				consultaTipoInversion();
			break;
			case catTipoInstrumento.fondeador:
				consultaTipoFondeador();
			break;

			}
		}
	});

	function consultaProductoCredito() {
		var numProdCredito = $('#numProducto').val();

		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCredito != '' && !isNaN(numProdCredito)){

			var prodCreditoBeanCon = {
					'producCreditoID':numProdCredito
			};
			productosCreditoServicio.consulta(catConTipoProductoCred.principal,prodCreditoBeanCon,function(prodCred) {

				if(prodCred!=null){
					$('#nombre').val(prodCred.descripcion);
					$('#nombreCorto').val(prodCred.nombreComercial);
					$('#estatus').val(prodCred.estatus);
				}else{
					mensajeSis("No Existe el Tipo de Crédito.");
					$('#numProducto').focus();
					$('#numProducto').val('');
					limpiarCampos();
				}

			});
		}
	}

	function consultaTipoCuenta() {
		var numCta = $('#numProducto').val();
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta)){
			tiposCuentaServicio.consulta(1, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#nombre').val(tipoCuenta.descripcion);
					$('#nombreCorto').val(tipoCuenta.abreviacion);
					$('#estatus').val(tipoCuenta.estatus);
				}else{
					mensajeSis("No Existe el Tipo de Cuenta.");
					$('#numProducto').focus();
					$('#numProducto').val('');
					limpiarCampos();
				}
			});
		}
	}

	function consultaTipoCede(){
		var tipoCede = $('#numProducto').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(tipoCede != '' && !isNaN(tipoCede)){

				var tiposCedesBean = {
		                'tipoCedeID':tipoCede,
		                'monedaId':0
		        };

				tiposCedesServicio.consulta(catTipoConsultaCedes.general, tiposCedesBean,{ async: false, callback: function(tiposCedes){
					if(tiposCedes!=null){
						$('#nombre').val(tiposCedes.descripcion);
						$('#nombreCorto').val(tiposCedes.nombreComercial);
						$('#estatus').val(tiposCedes.estatus);
					}else{
						mensajeSis("No Existe el Tipo de CEDE.");
						$('#numProducto').focus();
						$('#numProducto').val('');
						limpiarCampos();
					}

				}

			});

			}
	}

	function consultaTipoInversion(){
		var tipoInvercion = $('#numProducto').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(tipoInvercion != '' && !isNaN(tipoInvercion)){
			var tipoInversionBean = {
	                'tipoInvercionID':tipoInvercion,
	                'monedaId':0
	        };

			tipoInversionesServicio.consultaPrincipal(catTipoConsultaInversiones.tercera, tipoInversionBean, function(tipoInver){
				if(tipoInver!=null){
					$('#nombre').val(tipoInver.descripcion);
					$('#nombreCorto').val(tipoInver.nombreComercial);
					$('#estatus').val(tipoInver.estatus);
				}else{
					mensajeSis("No Existe el Tipo de Inversión.");
					$('#numProducto').focus();
					$('#numProducto').val('');
					limpiarCampos();
				}
			});

			}
	}
	
	function consultaTipoFondeador(){
		var tipoFondeador = $('#numProducto').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(tipoFondeador != '' && !isNaN(tipoFondeador)){
			var tipoFondeadoresBean = {
	                'catFondeadorID':tipoFondeador
	        };

			tipoFondeadorServicio.consulta(catTipoConsulFondeadores.principal, tipoFondeadoresBean, function(tipoFondeadores){
				if(tipoFondeadores!=null){
					$('#nombre').val(tipoFondeadores.desTipoFondeador);
					$('#nombreCorto').val("");
					$('#estatus').val(tipoFondeadores.estatus);
				}else{
					mensajeSis("No Existe el Tipo de Fondeador.");
					$('#numProducto').focus();
					$('#numProducto').val('');
					limpiarCampos();
				}
			});

			}
	}

	function consultaTipoInstrumentos() {
		var tipoLista = catListaTipoInstrumento.tipoInstrum;
		dwr.util.removeAllOptions('tipoProducto');
		dwr.util.addOptions('tipoProducto', {'0':'SELECCIONAR'});
		tipoInstrumentosServicio.listaCombo(tipoLista, function(instrumento){
			dwr.util.addOptions('tipoProducto', instrumento, 'tipoInstrumentoID', 'descripcion');

		});
	}

	});

	function limpiarCampos(){
		$('#nombre').val('');
		$('#nombreCorto').val('');
		$('#estatus').val('A');
	}

	function funcionError(){
		$('#numProducto').val('');
		limpiarCampos();
	}

	function inicializa(){
		$('#numProducto').val('');
		limpiarCampos();
	}
