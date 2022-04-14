var existeCuenta = 0;
var montosIguales =0;
var nombreInstitNom ='';
var institNomID =0;
var verificaPagos='';
var tipoTrans=0;

var listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

var consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente           ='CTE';


$(document).ready(function() {
	var tipoTransaccion= {
		'pagar'    : '2',
		'cancelar' : '3',
	};

	var parametroBean = consultaParametrosSession();

	esTab = true;
	deshabilitaBoton('realizarPagos');
	deshabilitaBoton('cancelarPagos');
	deshabilitaBoton('verificaPagoBancos');
	deshabilitaControl('seleccionaTodos');
	$('#ligaGenerar').removeAttr("href");
	$('#institNominaID').focus();

	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	agregaFormatoControles('formaGenerica');
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {
		esTab = false;
	});

	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			if($('#totalPagos').val()!=0){
				if(validaMonto()==1){
					tipoTrans= $('#tipoTransaccion').val();
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institNominaID',
					'funcionExito', 'funcionError');
				}else{
					mensajeSis("La Suma de los Pagos Seleccionados debe de ser Igual al Depósito en Bancos");
				}
			}else{
				mensajeSis("Seleccione al Menos un Movimiento para Procesar.");
			}
		}
	});

	$('#foliosPendientes').change(function(){
		consultaMonto(this.value);
		consultaFoliosPendientes(this.value);
		$('#seleccionaTodos').attr('checked', false);
		deshabilitaBoton('realizarPagos');
		deshabilitaBoton('cancelarPagos');
		$('#totalPagos').val('');
	});

	$('#institNominaID').bind('keyup',function(e){
		lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function() {

		consultaInstitucionNomina(this.id);
		requiereVerificacion(this.id);
		deshabilitaBoton('realizarPagos');
		deshabilitaBoton('cancelarPagos');
		deshabilitaBoton('verificaPagoBancos');

		$('#montoPagos').val('');
		$('#totalPagos').val('');
		$('#gridPagosPendientes').html("");
		$('#ligaGenerar').removeAttr("href");
		$('#depositoBancos').hide();
		$('#lbldepositoBancos').hide();
	});

	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val()!=""){
			consultaNombreBanco(this.id);
		}
	});

	$('#fechaAplica').val(parametroBean.fechaAplicacion);

	$('#numCuenta').blur(function() {
		validaCtaNostroExiste('numCuenta','institucionID');
	});

	/*asigna el tipo de transaccion */
	$('#realizarPagos').click(function() {
		validaMonto();
		$('#tipoTransaccion').val(tipoTransaccion.pagar);
	});

	$('#cancelarPagos').click(function() {
		// montosIguales= 1;
		$('#tipoTransaccion').val(tipoTransaccion.cancelar);
	});

	$('#verificaPagoBancos').click(function() {
		listaComboMovsTeso();
	});

	/* =============== VALIDACIONES DE LA FORMA ================= */
	$('#formaGenerica').validate({
		rules: {
			institNominaID :{
				required:true
			},
			numCuenta :{
				required:true
			},
			motivoCancela : {
				required:function() {return   $('#tipoTransaccion').val()==tipoTransaccion.cancelar;},
				maxlength : 100
			}
		},
		messages: {
			institNominaID :{
				required:'Ingrese una Empresa de Nómina.'
			},
			numCuenta :{
				required:'Ingrese el Número de Cuenta.'
			},
			motivoCancela : {
				required : 'Ingrese un Motivo de Cancelación.',
				maxlength: 'Máximo 100 caracteres.'
			}
		}
	});


});// fin document.ready

/* =================== FUNCIONES ========================= */

//Funcion de consulta para obtener el nombre de la institucion bancaria
function consultaNombreBanco(idControl) {
	var jqInstituto = eval("'#" + idControl + "'");
	var numInstituto = $(jqInstituto).val();
	var numCta = $('#numCuenta').val();
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoCon= 2;
	var InstitutoBeanCon = {
		'institucionID':numInstituto
	};
	if(numInstituto != '' && !isNaN(numInstituto)){
		institucionesServicio.consultaInstitucion(tipoCon,InstitutoBeanCon,{
			async: false, callback:function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);

				}else{
					mensajeSis("No Existe la Empresa ");
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#nombreInstitucion').val('');
				}
			}
		});
	}
}

// Funcion que consulta el numero de cuenta de depósito de una Institucion de Nomina
function consultaBancoCuenta(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();
	var tipoCon = 5;
	var institucionBean = {
			'institNominaID': institucionID,
			'clienteID' :0
	};
	if(institucionID != '' && !isNaN(institucionID) && esTab){
		institucionNomServicio.consulta(tipoCon,institucionBean,{
			async: false, callback:function(institNomina) {
				if(institNomina!= null){
					$('#institucionID').val(institNomina.institucionID);
					consultaNombreBanco('institucionID');
					$('#numCuenta').val(institNomina.cuentaDeposito);
				} else {
					mensajeSis("La Empresa No Cuenta con un Banco de Depósito");
					$('#institucionID').focus();
					$('#nombreInstitucion').val('');
					$('#institucionID').val('');
					$('#numCuenta').val('');
				}
			}
		});
	}
	listaComboPorAplicar();
 }

// Consulta de Institucion de Nomina
function consultaInstitucionNomina(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionID = $(jqNombreInst).val();
	var tipoConsulta = 1 ;
	var institucionBean = {
		'institNominaID': institucionID
	};

	if(institucionID != '' && !isNaN(institucionID) && esTab){
		institucionNomServicio.consulta(tipoConsulta,institucionBean,{
			async: false, callback:function(institNomina) {
				if(institNomina!= null){
					esTab=true;

					$('#nombreEmpresa').val(institNomina.nombreInstit);
					institNomID= $('#institNominaID').val();
					nombreInstitNom=institNomina.nombreInstit;
					existeCuenta=1;
					consultaBancoCuenta('institNominaID');
				} else {
					mensajeSis("La Empresa de Nómina No Existe");
					$('#institNominaID').focus();
					$('#institNominaID').val('');
					$('#nombreEmpresa').val('');
				}
			}
		});
	}
	$('#seleccionaTodos').attr('checked', false);
	deshabilitaControl('seleccionaTodos');
}

// lista el combo los pagos pendientes por aplicar
function listaComboPorAplicar() {
	var tipoLis= 2;
	var institNomina=$('#institNominaID').val();
	var cargaPagosBean = {
			'institNominaID': institNomina,
	};
	dwr.util.removeAllOptions('foliosPendientes');
	dwr.util.addOptions('foliosPendientes', {'0':'SELECCIONA'});

	bitacoraPagoNominaServicio.listaCombo(tipoLis ,cargaPagosBean, function(folios){
		dwr.util.addOptions('foliosPendientes',folios, 'folioCargaID','folioCargaID');
	});

}

// Consulta el monto del folio seleccionado
function consultaMonto(idFolio){
	var tipoConsulta = 3 ;
	var institNomina=$('#institNominaID').val();
	var cargaPagosBean = {
			'folioCargaID' :  idFolio,
			'institNominaID': institNomina
	};

	bitacoraPagoNominaServicio.consulta(tipoConsulta,cargaPagosBean,{
		async: false, callback:function(monto) {
			if(monto!= null){
				$('#montoPagos').val(monto.montoPagos);
				$('#montoPagos').formatCurrency({ //es para regresar el formato moneda
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			}
		}
});
}

//Consulta para el grid de pagos de credito pendientes por aplicar
function consultaFoliosPendientes(idFolio){
	var institNomina=$('#institNominaID').val();
	var params = {};
	params['folioCargaID'] = idFolio;
	params['institNominaID'] = institNomina;
	params['tipoLista'] = 1;
	$.post("aplicacionPagossGrid.htm", params, function(data){
		if(data.length >0) {
			$('#gridPagosPendientes').html(data);
			$('#gridPagosPendientes').show();
			agregaMonedaFormat();
			habilitaControl('seleccionaTodos');
		}else{
			$('#gridPagosPendientes').html("");
			$('#gridPagosPendientes').show();
			$('#seleccionaTodos').attr('checked', false);
			deshabilitaControl('seleccionaTodos');
		}
	});

}

//Función para sumar los montos de los folios seleccionados
function sumaCheck(idControl, registroID){
	var sumaTotal = 0;
	var montoAutorizaGridID = "";
	var jqMontoAutoriza = "";
	var jqAutoriza = "";
	var varAutoriza = "";
	var variable="";
	existenMovsSelec = 0;

	$('input[name=seleccionaCheck]').each(function() {
		jqAutoriza= eval("'#" + this.id + "'");
		varAutoriza = this.id;
		montoAutorizaGridID = varAutoriza.substr(15);
		jqMontoAutoriza= eval("'#montoPagos" + montoAutorizaGridID + "'");

		if ($(jqAutoriza).is(":checked")){
			if(listaPersBloqBean.estaBloqueado == 'N'){
				montoAutoriza = $(jqMontoAutoriza).asNumber();
				sumaTotal = parseFloat(sumaTotal) + parseFloat(montoAutoriza);
				$('#seleccionado'+montoAutorizaGridID).val('S');
				$('#esSeleccionado'+montoAutorizaGridID).val('S');
				habilitaBoton('realizarPagos');
				habilitaBoton('cancelarPagos');
				habilitaBoton('verificaPagoBancos');
			}
		}else{
			$('#seleccionado'+montoAutorizaGridID).val('N');
			$('#esSeleccionado'+montoAutorizaGridID).val('N');
		}
		if 	($('#seleccionado'+montoAutorizaGridID).val()=='N'){
			variable="N";
		}
	});

	$('#totalPagos').val(sumaTotal);

	$('#totalPagos').formatCurrency({ //es para regresar el formato moneda
		positiveFormat: '%n',
		roundToDecimalPlace: 2
	});
	if (variable=="N"){
		$('#seleccionaTodos').attr('checked', false);
	}else{
		$('#seleccionaTodos').attr('checked', true);
	}
	var jqEsSeleccionado = eval("'#esSeleccionado" + registroID+"'");
	var jqConsecutivoID  = eval("'#consecutivoID" + registroID+"'");
	var esSeleccionado = $(jqEsSeleccionado).val();
	var consecutivoID  = $(jqConsecutivoID).val();
	var tipoLista = '';
	var tipoSeleccion = 'I';
	validaTotales(esSeleccionado, consecutivoID, tipoLista, tipoSeleccion);

}

// Funcion para validar si la cuenta registrada o proporcionada por la Institucion de Nomina existe
function validaCtaNostroExiste(numCta,institID){
	var tipoCon = 4;
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
		cuentaNostroServicio.consultaExisteCta(tipoCon,CtaNostroBeanCon, {
			async: false, callback:function(ctaNostro){
				if(ctaNostro!=null){
					existeCuenta =1;
					$('#centroCostoID').val(ctaNostro.centroCostoID);
				}else{
					mensajeSis('La Cuenta Depósito No Existe');
					$('#numCuenta').val('');
					$('#numCuenta').focus();
				}
			}
		});
	}
	return existeCuenta;
}

// Funcion para consultar si la empresa requiere verificacion de los pagos en Bancos
function requiereVerificacion(idControl) {
	var jqNombreInst = eval("'#" + idControl + "'");
	var institucionNomID = $(jqNombreInst).val();
	var tipoConsulta= 1;
	var institucionBean = {
		'institNominaID':institucionNomID
	};

	institucionNomServicio.consulta(tipoConsulta,institucionBean,{
		async: false, callback:function(datos) {
			if(datos != null){
				verificaPagos=datos.reqVerificacion;
				if(verificaPagos == 'S'){
					$('#verificaPagoBancos').show();
					validaCtaNostroExiste('numCuenta','institucionID');
				}else{
					if(verificaPagos == 'N'){
						$('#verificaPagoBancos').hide();
					}
				}
			}else{
				$('#verificaPagoBancos').hide();
			}
		}
	});
}

//lista el combo los movimientos que coincidan con las Institucion de Nomina y no esten conciliados
function listaComboMovsTeso() {
	if(existeCuenta == 1){
		var tipoLis= 2;
		var institNomina=$('#institNominaID').val();
		var bancoID = $('#institucionID').val();
		var numCta  = $('#numCuenta').val();

		var pagosNomBean = {
			'institucionID' : bancoID,
			'numCuenta': numCta,
			'institNominaID': institNomina
		};

		dwr.util.removeAllOptions('depositoBancos');
		dwr.util.addOptions('depositoBancos', {'0':'SELECCIONA'});

		pagoNominaServicio.listaCombo(tipoLis ,pagosNomBean, {
			async: false, callback:function(movs){
				if(movs != ''){
					$('#depositoBancos').show();
					$('#lbldepositoBancos').show();
					dwr.util.addOptions('depositoBancos',movs, 'folioCargaTeso','depositoBancos');
				}else{
					$('#depositoBancos').hide();
					$('#lbldepositoBancos').hide();
					mensajeSis('No se Localizó Depósito en Bancos');
					deshabilitaBoton('realizarPagos');
				}
			}
		});
	}
}

// validar que el monto a aplicar sea el mismo que el registrado en Tesoreria
function validaMonto(){
	var totalPago   = $('#totalPagos').val();
	var totalMovTeso = $('#depositoBancos option:selected').text();
	montosIguales=0;

	if(totalPago == totalMovTeso){
		montosIguales = 1;
	}else{
		if(verificaPagos=='N' || $('#tipoTransaccion').val() == '3'){
			montosIguales=1;
		}
	}
	return montosIguales;
}


function agregaMonedaFormat(){
	$('input[name=listaMontoPagos]').each(function() {
		numero= this.id.substr(10,this.id.length);
		varCapitalID = eval("'#montoPagos"+numero+"'");
		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	});
}

function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) {
		mensajeAlert=setInterval(function() {
			if($(jQmensaje).is(':hidden')) {
				clearInterval(mensajeAlert);


				if(tipoTrans==2){
				}

				if(tipoTrans == 3){
					$('#gridPagosPendientes').html("");
					consultaFoliosPendientes($('#foliosPendientes').val());
					$('#totalPagos').val('');
					$('#motivoCancela').val('');
					deshabilitaBoton('realizarPagos');
					deshabilitaBoton('cancelarPagos');
					deshabilitaBoton('verificaPagoBancos');
				}else{
					$('#gridPagosPendientes').html("");
					$('#nombreEmpresa').val('');
					$('#montoPagos').val('');
					$('#numCuenta').val('');
					$('#totalPagos').val('');
					$('#motivoCancela').val('');
					$('#institucionID').val('');
					$('#nombreInstitucion').val('');

					$('#verificaPagoBancos').hide();
					$('#depositoBancos').hide();
					$('#lbldepositoBancos').hide();

					dwr.util.removeAllOptions('foliosPendientes');
					dwr.util.addOptions('foliosPendientes', {'0':'SELECCIONA'});

					dwr.util.removeAllOptions('depositoBancos');
					dwr.util.addOptions('depositoBancos', {'0':'SELECCIONA'});


					deshabilitaBoton('realizarPagos');
					deshabilitaBoton('cancelarPagos');
				}
				montosIguales=0;
				$('#seleccionaTodos').attr('checked',false);
			}
      	}, 50);
	}
}

function funcionError(){
	agregaFormatoControles('formaGenerica');
}

function seleccionarTodos(){
	var esSeleccionado = '';
	if($("#seleccionaTodos").is(':checked')) {
		esSeleccionado = 'S';
		$('input[name=listaMontoPagos]').each(function() {
			numero= this.id.substr(10,this.id.length);
			$('#seleccionaCheck'+numero).attr('checked', true);
			$('#seleccionado'+numero).val('S');
		});
		habilitaBoton('realizarPagos');
		habilitaBoton('cancelarPagos');
		habilitaBoton('verificaPagoBancos');
	} else {
		esSeleccionado = 'N';
		$('input[name=listaMontoPagos]').each(function() {
			numero= this.id.substr(10,this.id.length);
			$('#seleccionaCheck'+numero).attr('checked', false);
			$('#seleccionado'+numero).val('N');
		});
		deshabilitaBoton('realizarPagos');
		deshabilitaBoton('cancelarPagos');
		deshabilitaBoton('verificaPagoBancos');
		tipoSeleccion = 'T';
	}
	var tipoLista 		= '';
	var tipoSeleccion 	= 'T';
	var consecutivoID 	= 0;
	validaTotales(esSeleccionado, consecutivoID, tipoLista, tipoSeleccion);
}

function validaTotales(esSeleccionado, consecutivoID, tipoLista, tipoSeleccion){
	var params = {};
	params['esSeleccionado'] = esSeleccionado;
	params['consecutivoID']  = consecutivoID;
	params['tipoLista'] 	 = tipoLista;
	params['tipoSeleccion']  = tipoSeleccion;

	bloquearPantalla();
	$.post("aplicaPagoVistaTotales.htm",params,	function(datosResponse) {
		desbloquearPantalla();
		if (datosResponse != null) {
			$('#totalPagos').val(datosResponse.totalAplicaPago);
			$('#totalPagos').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			// Si seleccionaron el Check de Todos en Registros del Folio
			if(datosResponse.checkPagosTodos == 'S'){
				$('#seleccionaTodos').attr('checked',true);
			}else{
				$('#seleccionaTodos').attr('checked',false);
			}

			$('input[name=listaMontoPagos]').each(function() {
				$(this).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			});

			if($('#totalPagos').asNumber() == $('#montoPagos').asNumber() ){
				$('#seleccionaTodos').attr('checked',true);
			}else{
				$('#seleccionaTodos').attr('checked',false);
			}

			if(datosResponse.totalAplicaPago > 0 ){
				habilitaBoton('realizarPagos');
				habilitaBoton('cancelarPagos');
				habilitaBoton('verificaPagoBancos');
			} else {
				deshabilitaBoton('realizarPagos');
				deshabilitaBoton('cancelarPagos');
				deshabilitaBoton('verificaPagoBancos');
				$('#depositoBancos').hide(500);
				$('#lbldepositoBancos').hide();
			}


		} else {
			mensajeSis("Error en sumatoria de montos de Grid.");
		}
	});
}


function validaCredito(idControl,idSelccionado,idCheck){
	var jqCredito = eval("'#"+idControl+"'");
	var jqSeleccionado = eval("'#"+idSelccionado+"'");
	var jqCheck = eval("'#"+idCheck+"'");

	var numCredito = $(jqCredito).val();

	var creditoBeanCon = {
		'creditoID' : numCredito
	};

	creditosServicio.consulta(1,creditoBeanCon, {
		async: false, callback: function(credito) {
			if (credito != null) {
				listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
				consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				if(listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'N'){
					$(jqSeleccionado).val('N');
					$(jqCheck).attr('checked',false);
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				}
		 	}
	 	}
	});
}