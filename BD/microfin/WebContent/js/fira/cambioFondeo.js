var catFormTipoCalInt = {
	'principal'	: 1,
};
var parametrosBean = consultaParametrosSession();
var tipoInstitucion = 0; // Para determinar si es SOFIPO o SOFOM, SOCAP
var tipoSOFIPO		= 3; // Clave del Tipo de Institucion SOFIPO
var numeroTransaccion;
var catTipoConsultaCredito = {
	  'principal'	: 1,
	  'foranea'	: 2
};
var catTipoTransaccionInstFonde = {
	  'agrega':'33'
  };

$(document).ready(function(){
esTab = true;
consultaTipoInstitucion();

//-----------------------Métodos y manejo de eventos-----------------------
deshabilitaBoton('agrega', 'submit');
deshabilitaBoton('genPoliza', 'submit');
$('#creditoID').focus();
$('#usuarioSesion').val(parametroBean.claveUsuario);
mostrarElementoPorClase('mostrarAcredFIRA', false);
mostrarElementoPorClase('mostrarAcred', false);
mostrarElementoPorClase('mostrarCred', false);

$(':text').focus(function() {
	 esTab = false;
});

agregaFormatoControles('formaGenerica');

$(':text').bind('keydown',function(e){
	if (e.which == 9 && !e.shiftKey){
		esTab= true;
	}
});

$.validator.setDefaults({
		submitHandler: function(event) {

			   grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','exito','fallo');
		   }
	});

$('#formaGenerica').validate({
	rules: {
		creditoID: {
			required: true,
			numeroPositivo : true,
		},
		institFondeoID: {
			required: true,
			numeroPositivo : true,
		},
		lineaFondeo: {
			required : function() {return $('#institFondeoID').val() != 0;}
		},
		usuarioAutoriza: {
			required: true,
		},
		contrasenia: {
			required: true,
		},
		tasaPasiva: {
			required : function() {return $('#lineaFondeo').val() != 0;}
		},
		acreditadoIDFIRA : {
			required : function() {
				return $('#acreditadoIDFIRA').is(':visible');
			}
		},
		creditoIDFIRA : {
			required : function() {
				return $('#creditoIDFIRA').is(':visible');
			}
		}
	},
	messages: {
		creditoID: {
			required: 'Especifique el número de Crédito',
			numeroPositivo : "Sólo números",
		},
		institFondeoID: {
			required: 'Especifique Fondeador',
			numeroPositivo : "Sólo números",
		},
		lineaFondeo: {
			required: 'Especifique Línea de Fondeo',
		},
		usuarioAutoriza: {
			required: 'Especifique Usuario',
		},
		contrasenia: {
			required: 'Especifique Contrasenia',
		},
		tasaPasiva: {
			required: 'Especifique la Tasa Pasiva.',
		},
		acreditadoIDFIRA : {
			required : 'El ID del Acreditado es Requerido.'
		},
		creditoIDFIRA : {
			required : 'El Número de Credito es Requerido.'
		}
	}
});



$('#creditoID').blur(function(){
	if (esTab) {
		consultaCredito(this.id);
		$('#campoGenerico').val('');
	}
});

$('#creditoID').bind('keyup', function(e){
	lista('creditoID', '2', '50', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
});

$('#institFondeoID').bind('keyup',function(e){
	lista('institFondeoID', '1', '3', 'nombreInstitFon', $('#institFondeoID').val(), 'intitutFondeoLista.htm');
});

$('#institFondeoID').blur(function(){
	if (esTab) {
		consultaFondeador(this.id,2);
	}
});

$('#usuarioAutoriza').blur(function() {
	if(esTab){
		consultaClaveUsuario(this.id);
	}
});

$('#agrega').click(function() {
	$('#tipoTransaccion').val(catTipoTransaccionInstFonde.agrega);
});

$('#lineaFondeo').bind('keyup',function(e){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "descripLinea";
	camposLista[1] = "institutFondID";
	parametrosLista[0] = $('#lineaFondeo').val();
	parametrosLista[1] = $('#institFondeoID').val();
	listaAlfanumerica('lineaFondeo', '0', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
});

$('#lineaFondeo').blur(function() {
	if(esTab){
		consultaLineaFondeo(this.id,2);
	}
});

// evento para generar reporte de la poliza
$('#genPoliza').click(function(){

	var url='RepPoliza.htm?fechaInicial='+parametroBean.fechaSucursal+'&fechaFinal='+parametroBean.fechaSucursal+
	'&nombreUsuario='+parametroBean.nombreUsuario+'&numeroTransaccion='+numeroTransaccion;
	window.open(url,"_blank");
	$('#creditoID').focus();
});


//-------------Validaciones de controles---------------------

});

function consultaCredito(controlID){
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' && !isNaN(numCredito) && esTab){
		var creditoBeanCon = {
			'creditoID':$('#creditoID').val()
			};
		$('#acreditadoIDFIRA').val("");
		$('#creditoIDFIRA').val("");
		mostrarElementoPorClase('mostrarAcredFIRA', false);
		mostrarElementoPorClase('mostrarAcred', false);
		mostrarElementoPorClase('mostrarCred', false);
		inicializaForma('formaGenerica','creditoID');
		creditosServicio.consulta(30, creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
			if(credito!=null){
				var validar =validaGarantia(credito.fechaMinistrado,credito.tipoGarantiaFIRAID);

					if(validar==0){
						esTab=true;
						dwr.util.setValues(credito);
						$('#tipoPrepago').val(credito.tipoPrepago);
						$('#institFondeoIDN').val(credito.institFondeoID);
						$('#institFondeoID').val('');
						$('#lineaFondeoN').val(credito.lineaFondeo);
						$('#solicitudCreditoID').val(credito.solicitudCreditoID);
						$('#lineaFondeo').val('');
						$('#fecha').val(parametroBean.fechaAplicacion);
						$('#estatus').val('VIGENTE');
						consultaCliente('clienteID');
						consultaMoneda('monedaID');
						consultaProducCredito('producCreditoID');
						consultaFiniquitoLiqAnticipada();
						consultaFondeador('institFondeoIDN',1);
						consultaLineaFondeo('lineaFondeoN',1);
						camposCambioFondeo(Number(credito.institFondeoID));
						$('#contrasenia').val('');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('genPoliza', 'submit');
					}else{
						inicializaForma('formaGenerica','creditoID');
						mensajeSis("No Cuenta con Garantias Asociadas");
						$('#creditoID').focus();
						$('#creditoID').val('');
						$('#contrasenia').val('');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('genPoliza', 'submit');
					}

			}else{
				inicializaForma('formaGenerica','creditoID');
				mensajeSis("No Existe el Crédito o el Estatus del Crédito no es Vigente");
				$('#creditoID').focus();
				$('#creditoID').val('');
				$('#contrasenia').val('');
			}
		});
	}
}

// Validacion para garantias
function validaGarantia(fechaMinistrado, tipoGarantiaFIRAID) {

	if(tipoGarantiaFIRAID>0){
			return 0;
	}else{
		if(parametroBean.fechaAplicacion <= fechaMinistrado){
			return 0;
		}else{
			return 1;
		}
	}

}
function consultaFiniquitoLiqAnticipada(){
	try{
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numCredito != '' && !isNaN(numCredito) ){
		var Con_PagoCred = 17;
		var creditoBeanCon = {
				'creditoID':$('#creditoID').val(),
				'fechaActual':$('#fechaSistema').val()
				};
		$('#gridAmortizacion').hide();
		$('#gridMovimientos').hide();
		creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{
			callback :function(credito) {//catTipoConsultaCredito.saldos
			if(credito!=null){
					$('#saldoCapVigent').val(credito.saldoCapVigent);
					$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
					$('#saldoCapVencido').val(credito.saldoCapVencido);
					$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
					$('#totalCapital').val(credito.totalCapital);
					$('#saldoInterOrdin').val(credito.saldoInterOrdin);
					$('#saldoInterAtras').val(credito.saldoInterAtras);
					$('#saldoInterAtras').val(credito.saldoInterAtras);
					$('#saldoInterVenc').val(credito.saldoInterVenc);
					$('#saldoInterProvi').val(credito.saldoInterProvi);
					$('#saldoIntNoConta').val(credito.saldoIntNoConta);
					$('#totalInteres').val(credito.totalInteres);
					$('#saldoIVAInteres').val(credito.saldoIVAInteres);
					$('#saldoMoratorios').val(credito.saldoMoratorios);
					$('#saldoIVAMorator').val(credito.saldoIVAMorator);
					$('#saldoComFaltPago').val(credito.saldoComFaltPago);
					$('#saldoOtrasComis').val(credito.saldoOtrasComis);
					$('#totalComisi').val(credito.totalComisi);
					$('#salIVAComFalPag').val(credito.salIVAComFalPag);
					$('#saldoIVAComisi').val(credito.saldoIVAComisi);
					$('#totalIVACom').val(credito.totalIVACom);
					$('#saldoTotal').val(credito.adeudoTotal);

					var total= $('#totalCapital').asNumber() + $('#saldoInterOrdin').asNumber();
					$('#adeudoTotal').val(total);

					/*SEGURO CUOTA*/
					$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
					$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
					/*FIN SEGURO CUOTA*/
					/*COM ANUAL CRED*/
					$('#saldoComAnual').val(credito.saldoComAnual);
					$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
					/*FIN COM ANUAL CRED*/

					$('#saldoAdmonComis').val(credito.saldoAdmonComis);
					$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);

			}else{
				mensajeSis("No Existe");
			}
		},
		errorHandler : function(errorString,exception) {
			mensajeSis("Error en consulta de Total de Adeudo."
			+ errorString);
		}
		});
	}
	}
	catch (err) {
		mensajeSis(err);
	}
}

function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCliente != '' && !isNaN(numCliente) && esTab){
		clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
					if(cliente!=null){
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
					}else{
						mensajeSis("No Existe el Cliente");
						$('#clienteID').focus();
						$('#clienteID').select();
					}
			});
		}
	}


function consultaMoneda(idControl) {
	var jqMoneda = eval("'#" + idControl + "'");
	var numMoneda = $(jqMoneda).val();
	var conMoneda=2;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numMoneda != '' && !isNaN(numMoneda)){
		monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
		});
	}
}


function consultaProducCredito(idControl) {
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
		  'producCreditoID':ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#descripProducto').val(prodCred.descripcion);
					if(prodCred.permitePrepago=='S'){
					$('#tipoPrepagoTD').show();
					$('#tipoPrepagoTD1').show();
					$('#separador').show();
					}
					else{
					$('#tipoPrepagoTD').hide();
					$('#tipoPrepagoTD1').hide();
					$('#separador').hide();
					}

				}else{
					mensajeSis("No Existe el Producto de Crédito");
				}
		});
		}
	}


// Funcion que consulta la tasa base
function consultaTasaBase(idControl) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
			'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#desTasaBase').val(tasasBaseBean.nombre);
				$('#tasaBaseValor').val(tasasBaseBean.valor+'%');
				$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				$('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
			} else {
				$('#desTasaBase').val('');
				$('#tasaBaseValor').val('');
			}
		});
	}
}

function consultaFondeador(control, tipoConsulta) {
var numInst = eval("'#" + control + "'");
var insFondeador = $(numInst).val();
setTimeout("$('#cajaLista').hide();", 200);
var instFondeoBeanCon = {
	'institutFondID' : insFondeador
};

mostrarElementoPorClase('mostrarAcredFIRA', false);
mostrarElementoPorClase('mostrarAcred', false);
mostrarElementoPorClase('mostrarCred', false);

if (insFondeador != '' && !isNaN(insFondeador) && esTab) {
	fondeoServicio.consulta(1, instFondeoBeanCon, {
	async : false,
	callback : function(instFondeo) {
		if (instFondeo != null) {
			habilitaControl('lineaFondeo');
			if (tipoConsulta == 2) {
				if (instFondeo.estatus != 'A') {
					mensajeSis("La Institución de Fondeo No Está Activa");
					deshabilitaBoton('agrega', 'submit');
					$('#institFondeoID').val('');
					$('#institFondeoID').focus();
					$('#nombreFondeoN').val('');
					$('#lineaFondeo').val('');
					$('#descripLineaFon').val('');
					$('#tasaPasiva').val('');
				}
				else {
					$('#nombreFondeoN').val(instFondeo.nombreInstitFon);
					$('#lineaFondeo').val('');
					$('#descripLineaFon').val('');
					$('#tasaPasiva').val('');
					habilitaBoton('agrega', 'submit');
				}
			} else {
				$('#nombreFondeo').val(instFondeo.nombreInstitFon);
			}
			if (instFondeo.capturaIndica != null && instFondeo.capturaIndica != '') {
				if(busca(instFondeo.capturaIndica,'A')){
					mostrarElementoPorClase('mostrarAcred', true);
					mostrarElementoPorClase('mostrarCredS', true);
					mostrarElementoPorClase('mostrarAcredFIRA', true);
				}

				if(busca(instFondeo.capturaIndica,'C')){
					mostrarElementoPorClase('mostrarAcredFIRA', true);
					if(busca(instFondeo.capturaIndica,'A')){
						mostrarElementoPorClase('mostrarCredS', true);
					} else {
						mostrarElementoPorClase('mostrarCredS', false);
					}

					mostrarElementoPorClase('mostrarCred', true);
				}
			}
			if(insFondeador == 0){
				$('#tasaPasiva').focus();
				$('#lineaFondeo').val('0');
				$('#descripLineaFon').val('');
				deshabilitaControl('lineaFondeo');
			} else {
				$('#lineaFondeo').focus();
			}
		} else {
			if (tipoConsulta == 2) {
				mensajeSis("No Existe la Institución de Fondeo");
				deshabilitaBoton('agrega', 'submit');
				$('#institFondeoID').focus();
				$('#institFondeoID').select();
				$('#nombreFondeoN').val('');
				$('#lineaFondeo').val('');
				$('#descripLineaFon').val('');
				$('#tasaPasiva').val('');
			} else {
				$('#institFondeoIDN').val('');
				$('#nombreFondeo').val('');
			}
		}
	},
	errorHandler : function(message, exception) {
		mensajeSis("Error en Consulta de la Institución de Fondeo.<br>" + message + ":" + exception);
	}
	});
}
}

// consulta de la linea de fondeo
function consultaLineaFondeo(idControl,tipoConsulta){
	var jqLineaFon = eval("'#" + idControl + "'");
	var numLinea = $(jqLineaFon).val();
	var tipoCon = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var lineaFondBeanCon = {
		'lineaFondeoID' : numLinea
	};
	var totalCredito = $('#adeudoTotal').asNumber();
	if (numLinea != '' && !isNaN(numLinea)) {
		lineaFonServicio.consulta(tipoCon, lineaFondBeanCon,{ async: false, callback:  function(lineaFond) {
			if (lineaFond != null) {
				if(tipoConsulta==2){
					$('#saldoLinea').val(lineaFond.saldoLinea);
					var saldoTotalLinea = $('#saldoLinea').asNumber();
					$('#tasaPasiva').val(lineaFond.tasaPasiva);
					if(parseFloat(saldoTotalLinea) < parseFloat(totalCredito)){
						mensajeSis("El Saldo dela Línea es Insuficiente.");
						$('#lineaFondeo').focus();
						$('#lineaFondeo').select();
					}else{
						if($('#institFondeoID').val()!=''){

							$('#descripLineaFon').val(lineaFond.descripLinea);

						}else{
							mensajeSis("Seleccione La Institución de Fondeo.");
							deshabilitaBoton('agrega', 'submit');
							$('#institFondeoID').focus();
							$('#institFondeoID').select();
							$('#nombreFondeoN').val('');
							$('#lineaFondeo').val('');
							$('#descripLineaFon').val('');
							$('#tasaPasiva').val('');
						}
					}
				}else{
					$('#descripLineaFonN').val(lineaFond.descripLinea);
				}
			} else {
				if(tipoConsulta==2){
					mensajeSis("No Existe la Línea de Fondeo");
					$('#lineaFondeo').focus();
					$('#lineaFondeo').select();
					$('#tasaPasiva').val('');
				}else{
					$('#lineaFondeoN').val('');
					$('#descripLineaFonN').val('');
					$('#tasaPasiva').val('');
				}
			}
		}
		});
	}
}// fin consultaLineaFondeo


// FUNCION CONSULTA LA CLAVE DEL USUARIO
function consultaClaveUsuario(idClaveUsu) {
	var claveID = eval("'#" + idClaveUsu + "'");
	var claveUsu = $(claveID).val();
	var usuarioSesion = $('#usuarioSesion').val();
	var numCon = 3;
	var usuarioBean = {
		'clave':claveUsu
	};
	if(claveUsu != ''){
		usuarioServicio.consulta(numCon, usuarioBean, function(usuario) {
			if(usuario!=null){
				if(usuarioSesion==claveUsu){
					mensajeSis("El Usuario que Autoriza debe ser Diferente al Usuario de Sesión.");
					$('#usuarioAutoriza').focus();
				}else{
					$('#usuarioID').val(usuario.usuarioID);
				}
			}else{
				mensajeSis("El usuario no Existe");
				$('#usuarioAutoriza').focus();
			}
		});
	}
}

// Consulta el tipo de institucion
function consultaTipoInstitucion() {
	var parametrosSisCon ={
			  'empresaID' : 1
	};
	parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
		if (institucion != null) {
			tipoInstitucion = institucion.tipoInstitID;

			if(tipoInstitucion == tipoSOFIPO){
				$('.tipoSofipo').show();
			}else{
				$('.tipoSofipo').hide();
			}
		}
	});
}

function limpiarPantalla(){
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#cuentaID').val('');
	$('#monedaID').val('');
	$('#monedaDes').val('');
	$('#estatus').val('');
	$('#producCreditoID').val('');
	$('#descripProducto').val('');
	$('#diasFaltaPago').val('');
	$('#tasaFija').val('');
	$('#origen').val('');
	$('#institFondeoIDN').val('');
	$('#nombreFondeo').val('');
	$('#lineaFondeoN').val('');
	$('#tasaPasiva').val('');
	$('#descripLineaFonN').val('');
	$('#institFondeoID').val('');
	$('#nombreFondeoN').val('');
	$('#lineaFondeo').val('');
	$('#descripLineaFon').val('');
	$('#usuarioAutoriza').val('');
	$('#contrasenia').val('');

	$('#saldoCapVigent').val('');
	$('#saldoCapAtrasad').val('');
	$('#saldoCapVencido').val('');
	$('#saldCapVenNoExi').val('');
	$('#totalCapital').val('');
	$('#saldoInterOrdin').val('');
	$('#saldoInterAtras').val('');
	$('#saldoInterAtras').val('');
	$('#saldoInterVenc').val('');
	$('#saldoInterProvi').val('');
	$('#saldoIntNoConta').val('');
	$('#totalInteres').val('');
	$('#saldoIVAInteres').val('');
	$('#saldoMoratorios').val('');
	$('#saldoIVAMorator').val('');
	$('#saldoComFaltPago').val('');
	$('#saldoOtrasComis').val('');
	$('#totalComisi').val('');
	$('#salIVAComFalPag').val('');
	$('#saldoIVAComisi').val('');
	$('#totalIVACom').val('');
	$('#saldoTotal').val('');
	$('#saldoSeguroCuota').val('');
	$('#saldoIVASeguroCuota').val('');
	$('#saldoComAnual').val('');
	$('#saldoComAnualIVA').val('');

	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('genPoliza','button');
	$('#creditoID').focus();
}

function camposCambioFondeo(institucionFondeoID){

	habilitaControl('institFondeoID');
	habilitaControl('lineaFondeo');
	habilitaControl('tasaPasiva');
	habilitaControl('usuarioAutoriza');
	habilitaControl('contrasenia');
	habilitaBoton('agrega','submit');
	deshabilitaBoton('genPoliza','submit');
	$('#institFondeoID').focus();

	$('#institFondeoID').val('');
	$('#nombreFondeoN').val('');
	$('#lineaFondeo').val('');
	$('#descripLineaFon').val('');
	$('#tasaPasiva').val('');
	$('#usuarioAutoriza').val('');
	$('#contrasenia').val('');
}

//Funcion de exito al realizar una transaccion
function exito(){

	$('#genPoliza').focus();
	habilitaBoton('genPoliza', 'button');
	deshabilitaBoton('agrega', 'submit');
	numeroTransaccion = $('#campoGenerico').val();

}
//Funcion de error al realizar una trasaccion

function fallo(){
}
