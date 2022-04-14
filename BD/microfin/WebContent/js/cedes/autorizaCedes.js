var esTab = true;
var contadorCte = "";
var esAnclaje	='N';
var generarFormatoAnexo=true;
var productoInvercamex=1;
var parametroBean = consultaParametrosSession();

var catTipoTransaccion = {
	'autoriza':3
};

var catTipoConsulta = {
		'principal':1
	};

var catTipoLista ={
		'principal' : 1
};

var catStatusCede = {
		'alta':'INACTIVA',
		'vigente':'VIGENTE',
		'pagada' :'PAGADA',
		'cancelada':'CANCELADA',
		'vencida':'VENCIDA'
};

var catStatusPagare = {
		'impreso':'I'
};
$(document).ready(function() {
	$('#lblfechaApertura').hide();
	$('#fechaApertura').hide();
	$('#reinvertirVenSi').attr('checked',false);
	$('#reinvertirVenNo').attr('checked',false);
	$('#reinvertirVenSi').hide();
	$('#reinvertirVenNo').hide();
	$(':text').focus(function() {
	 	esTab = false;
	});
	$('#cedeID').focus();

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	parametroBean = consultaParametrosSession();
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('imprime', 'submit');
	$('#tdCajaRetiro').hide();
	agregaFormatoControles('formaGenerica');
	mostrarTasaVar();


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','cedeID', 'funcionExito', 'funcionFallo');
			}
	});

	$('#cedeID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";
		 parametrosLista[0] = $('#cedeID').val();
		lista('cedeID', 2, catTipoLista.principal, camposLista, parametrosLista, 'listaCedes.htm');
	});

	ocultaTasaVar();

	$('#cedeID').blur(function(){
		if(esTab == true & !isNaN($('#cedeID').val())){
			consultaValOperacion($('#cedeID').val());
		}
	});
	$('#autoriza').click(function() {
		if(esAnclaje == 'N'){
			$('#tipoTransaccion').val(catTipoTransaccion.autoriza);
		}
		else{
			$('#tipoTransaccion').val('7');
		}

	});

	$('#fecha').html(parametroBean.fechaSucursal);

	$('#imprime').click(function() {
		deshabilitaBoton('imprime', 'submit');
		var cedeID = $('#cedeID').val();
		var monedaID = $('#monedaID').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var monto =  ($('#montoAnclar').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
							})).asNumber();
		var dirInst = parametroBean.direccionInstitucion;
		var usuario	= parametroBean.nombreUsuario;
		var sucursalID = parametroBean.sucursal;
		var nombreSucursal = parametroBean.nombreSucursal;
		var nombreCliente = $('#nombreCompleto').val();
		var cuentaAhoID = $('#cuentaAhoID').val();
		var descripcionTipoCede = $('#descripcion').val();
		var plazo = $('#plazo').val();
		var calculoInteres = $('#desCalculoInteres').val();
		var tasaBase = $('#tasaBase').val();
		var tasaISR = $('#tasaISR').val();
		var totalRecibir = $('#monto').val();
		var fechaVencimiento = $('#fechaVencimiento').val();
		var fechaApertura = $('#fechaInicio').val();
		var sobreTasa = $('#sobreTasa').val();
		var pisoTasa = $('#pisoTasa').val();
		var techoTasa = $('#techoTasa').val();
		var tasaNeta = $('#tasaNeta').val();
		var tasaFija = $('#tasaFija').val();
		var interesRecibir = $('#interesRecibir').val();
		var totalRec = $('#monto').asNumber();
		var nombreCaja = $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
		var domicilioInst =  parametroBean.direccionInstitucion;
		var tipoProducto= "CEDE";
		if(generarFormatoAnexo){
			window.open('reporteAnexoPagareInv.htm?inversionID='+cedeID +
					  '&nombreInstitucion=' + nombreInstitucion
					  +'&direccionInstit='+dirInst
					  +'&fechaVencimiento='+fechaVencimiento
					  +'&nombreSucursal='+nombreCaja
					  +'&tipoProducto='+tipoProducto
					  +'&domicilioInst='+domicilioInst);
		}

		if($('#tipoTasa').val() == 'V'){

			var pagina = 'pagareCedeRep.htm?cedeID='+cedeID +
						  '&monedaID=' + monedaID +
						  '&nombreInstitucion=' + nombreInstitucion  +
						  '&monto=' + monto
						  +'&direccionInstit='+dirInst+
						  '&nombreUsuario='+usuario+
						  '&sucursalID='+sucursalID+
						  '&nombreSucursal='+nombreSucursal+
						  '&nombreCompleto='+nombreCliente +
						  '&cuentaAhoID='+cuentaAhoID+
						  '&descripcion='+descripcionTipoCede+
						  '&plazo='+plazo+
						  '&calculoInteres='+calculoInteres+
						  '&tasaBase='+tasaBase+
						  '&tasaISR='+tasaISR+
						  '&totalRecibir='+totalRecibir+
						  '&fechaVencimiento='+fechaVencimiento+
						  '&fechaApertura='+fechaApertura+
						  '&sobreTasa='+sobreTasa+
						  '&pisoTasa='+pisoTasa+
						  '&techoTasa='+techoTasa+
						  '&valorGat='+$('#valorGat').val()+
						  '&total='+totalRec;
			window.open(pagina,'_blank');
			$('#cedeID').focus();
		}else{
			var pagina = 'pagareFijoCedeRep.htm?cedeID='+cedeID +
			  '&monedaID=' + monedaID +
			  '&nombreInstitucion=' + nombreInstitucion  +
			  '&monto=' + monto
			  +'&direccionInstit='+dirInst+
			  '&nombreUsuario='+usuario+
			  '&sucursalID='+sucursalID+
			  '&nombreSucursal='+nombreSucursal+
			  '&nombreCompleto='+nombreCliente +
			  '&cuentaAhoID='+cuentaAhoID+
			  '&descripcion='+descripcionTipoCede+
			  '&plazo='+plazo+
			  '&tasaISR='+tasaISR+
			  '&totalRecibir='+totalRecibir+
			  '&fechaVencimiento='+fechaVencimiento+
			  '&fechaApertura='+fechaApertura +
			  '&tasaNeta='+tasaNeta+
			  '&tasaFija='+tasaFija+
			  '&interesRecibir='+interesRecibir+
			  '&total='+totalRec;
			window.open(pagina,'_blank');
			$('#cedeID').focus();
		}


	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		ignore:  ":hidden",
		rules: {
			cedeID:{
				required: true,
			},
			cuentaAhoID:{
				required: true,
			},
			tipoCedeID:{
				required:true,
			},
			monto:{
				required: true,
			},
			plazo:{
				required: true,
			},
			fechaVencimiento:{
				required: true,
			},
			cajaRetiro: {
				required: function() {
				return generarFormatoAnexo;
				}
			}
		},
		messages: {
			cedeID:{
				required:'Especifique Número de Cede',
			},
			cuentaAhoID:{
				required:'Especifique la Cuenta',
			},
			tipoCedeID:{
				required:'Especifique el Tipo de Cede',
			},
			monto:{
				required:'Especifique el Monto',
			},
			plazo:{
				required:'Especifique el Plazo',
			},
			fechaVencimiento:{
				required:'Especifique la Fecha de Vencimiento',
		},
		cajaRetiro: 'Especifique la Caja de Retiro'
		}
	});


});

function seleccionaEstatus(estatus){
	if(estatus == 'N'){
		$('#estatus').val('VIGENTE');
	}
	if(estatus == 'P'){
		$('#estatus').val('PAGADA');
	}
	if(estatus == 'C'){
		$('#estatus').val('CANCELADA');
	}
	if(estatus == 'I'){
		$('#estatus').val('INACTIVA');
	}
	if(estatus == 'A'){
		$('#estatus').val('REGISTRADA');
	}
}


	/* CONSULTA OPERACION */
	function consultaValOperacion(instrumentoID) {
		setTimeout("$('#cajaLista').hide();", 200);
		operacionBean = {
			'instrumentoID'	: instrumentoID,
			'pantallaOrigen'	: "AC"
		};
		//constulta la operacion
		operacionesCapitalNetoServicio.consulta(2, operacionBean, function(datos) {
			if(datos != null) {
				if(datos.estatusOper=='SIN PROCESAR'){
					mensajeSis(datos.mensaje);
					deshabilitaBoton('autoriza', 'submit');
				}else{
					validaCede('cedeID');
				}
			}else{
				validaCede('cedeID');
			}
		});

	}

	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();
		var cedeBean = {
			'cedeID' : numCede
		};
		if(numCede != 0 && numCede != '' && !isNaN(numCede) && esTab){
			cedesServicio.consulta(catTipoConsulta.principal, cedeBean, function(cedesCon){
				if(cedesCon!=null){
					estatus = cedesCon.estatus;
					seleccionaEstatus(cedesCon.estatus);
					var varError = 1;
					if(cedesCon.cedeMadreID > 0){
						esAnclaje ='S';
					}else{
						esAnclaje='N';
					}

					$('#clienteID').val(cedesCon.clienteID);


					$('#cuentaAhoID').val(cedesCon.cuentaAhoID);
					$('#tipoCedeID').val(cedesCon.tipoCedeID);
					$('#tipoPagoInt').val(cedesCon.tipoPagoInt);

					$('#monto').val(cedesCon.monto);
					$('#plazo').val(cedesCon.plazo);
					$('#plazoOriginal').val(cedesCon.plazoOriginal);
					$('#fechaInicio').val(cedesCon.fechaInicio);
					$('#fechaVencimiento').val(cedesCon.fechaVencimiento);

					$('#tasaFija').val(cedesCon.tasaFija);
					$('#tasaISR').val(cedesCon.tasaISR);
					$('#tasaNeta').val(cedesCon.tasaNeta);
					$('#valorGat').val(cedesCon.valorGat);

					$('#interesGenerado').val(cedesCon.interesGenerado);
					$('#interesRetener').val(cedesCon.interesRetener);
					$('#interesRecibir').val(cedesCon.interesRecibir);
					$('#valorGatReal').val(cedesCon.valorGatReal);
					$('#totalRecibir').val(cedesCon.totalRecibir);
					$('#cajaRetiro').val(cedesCon.cajaRetiro);

					consultaCliente(cedesCon.clienteID);
					consultaDireccion(cedesCon.clienteID);
					consultaCtaCliente(cedesCon.cuentaAhoID);
					consultaSucursalCAJA();
					evaluaReinversion(cedesCon.reinversion,cedesCon.reinvertir);
					$('#sobreTasa').val(cedesCon.sobreTasa);
					$('#pisoTasa').val(cedesCon.pisoTasa);
					$('#techoTasa').val(cedesCon.techoTasa);
					if(cedesCon.fechaApertura != '1900-01-01'){
						$('#lblfechaApertura').show();
						$('#fechaApertura').show();
						$('#fechaApertura').show();
					}else{
						$('#lblfechaApertura').hide();
						$('#fechaApertura').hide();
					}

					if(estatus == 'C'){
						mensajeSis("El CEDE se encuentra Cancelado");
					}
					if(estatus == 'N'){
						mensajeSis("El CEDE se encuentra Autorizado");
					}
					if(estatus == 'P'){
						mensajeSis("El CEDE se encuentra Pagado (Abonado a Cuenta)");
					}
					if(estatus == 'V'){
						mensajeSis("El CEDE se encuentra Vencido");
					}

					if(estatus == 'A'){
						if(cedesCon.fechaInicio != parametroBean.fechaSucursal){
							mensajeSis("El CEDE no es del día de hoy");
						}else{
							varError = 0;
							habilitaBoton('autoriza', 'submit');
							deshabilitaBoton('imprime', 'submit');
							$('#autoriza').focus();
						}
					}
					if (varError > 0){
						$(jqCede).focus();
						$(jqCede).select();
					}

				}else{
					mensajeSis('El CEDE no Existe');
					inicializaForma('formaGenerica','cedeID');
					$(jqCede).focus();
					$(jqCede).select();
				}

			});
		}else{
			mensajeSis('El CEDE no Existe');
			inicializaForma('formaGenerica','cedeID');
			$(jqCede).focus();
			$(jqCede).select();
		}
	}

	function consultaFechaApertura(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();
		var cedeBean = {
			'cedeID' : numCede
		};
		if(numCede != 0 && numCede != ''){
				cedesServicio.consulta(catTipoConsulta.principal, cedeBean, function(cedesCon){
					if(cedesCon!=null){
						if(cedesCon.fechaApertura != '1900-01-01'){
							$('#fechaApertura').val(cedesCon.fechaApertura);
							$('#lblfechaApertura').show();
							$('#fechaApertura').show();
							$('#fechaApertura').show();
						}else{
							$('#lblfechaApertura').hide();
							$('#fechaApertura').hide();
						}
					}
				});
			}
		}

	function consultaCliente(numCliente) {
		var conCliente = 5;
		var rfc = '';
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){

				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								if(estatus != 'N'){
									consultaDatosAdicionales(cliente.numero);
								}
							}
					});
				}
		}
	}

	function consultaDireccion(numCliente) {
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,function(direccion) {
						if(direccion!=null){
							$('#direccion').val(direccion.direccionCompleta);
						}
				});
			}
	}

	function consultaCtaCliente(cuentaID) {
        var numCta = cuentaID;
        var conSaldo =  5;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);

        if(numCta != '' && !isNaN(numCta)){
	          cuentasAhoServicio.consultaCuentasAho(conSaldo,CuentaAhoBeanCon,function(cuenta) {
	          	if(cuenta!=null){
					$('#saldoCuenta').val(cuenta.saldoDispon);
	              	$('#saldoCuenta').formatCurrency({colorize: true, positiveFormat: '%n', roundToDecimalPlace: -1});
	              	$('#tipoMoneda').html(cuenta.descripcionMoneda);
	              	$('#monedaID').val(cuenta.monedaID);
					$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
					ponerFormatoMoneda();
	              	consultaTipoCede();
	          	}else{
	          		mensajeSis("No Existe la Cuenta de Ahorro");
	          	}
	  			});
        }
	}

	function consultaTipoCede(){
		var tipoCede = $('#tipoCedeID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoCedeBean = {
                'tipoCedeID':tipoCede,
        };
			if(tipoCedeBean != 0){
				tiposCedesServicio.consulta(conPrincipal, tipoCedeBean, function(tipoCede){
					if(tipoCede!=null){
						$('#descripcion').val(tipoCede.descripcion);
						$('#tipoTasa').val(tipoCede.tasaFV);
						if($('#tipoTasa').val() == 'F'){
							ocultaTasaVar();
						} else if($('#tipoTasa').val() == 'V'){
							mostrarTasaVar();
							monto = $('#monto').asNumber();
							plazo = $('#plazo').asNumber();
							obtieneTasaVariable(tipoCede.tipoCedeID,monto,plazo);
						}
					}
				});
			}
		}

	function evaluaReinversion(reinversion, tipoReinversion){

	}

	function obtieneTasaVariable(tipoCede, monto,plazo){
		var conTasaVariable = 3;
		var TasasCedesBean ={
			'tipoCedeID' :tipoCede,
			'monto':monto,
			'plazo': plazo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoCede != '' && !isNaN(tipoCede)){
			if(tipoCede != 0){
				tasasCedesServicio.consulta(conTasaVariable,TasasCedesBean, function(tasasCedesBean){
					if(tasasCedesBean!=null){
						$('#tasaBase').val(tasasCedesBean.nombreTasaBase);
						switch(parseInt(tasasCedesBean.calculoInteres)){
							case(1):
									$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
								break;
							case(2):
								$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS');
								break;
							case(3):
									$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
								break;
							case(4):
								$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS');
								break;
							case(5):
								$('#desCalculoInteres').val('TASA INICIO DE MES + PUNTOS CON PISO Y TECHO');
								break;
							case(6):
								$('#desCalculoInteres').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
								break;
							case(7):
								$('#desCalculoInteres').val('TASA PROMEDIO DE MES + PUNTOS CON PISO Y TECHO');
							break;
						}

					}
				});
			}
		}
	}

	function ponerFormatoMoneda(){
		$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}

	function ocultaTasaVar(){
		$('#tdlblCalculoInteres').hide();
		$('#tdcalculoInteres').hide();
		$('#tdlblTasaBaseID').hide();
		$('#tdDesTasaBaseID').hide();
		$('#trVariable1').hide();
	}

	function mostrarTasaVar(){
		$('#tdlblCalculoInteres').show();
		$('#tdcalculoInteres').show();
		$('#tdlblTasaBaseID').show();
		$('#tdDesTasaBaseID').show();
		$('#trVariable1').show();
	}

function funcionExito(){
	deshabilitaBoton('autoriza', 'submit');
	habilitaBoton('imprime', 'boton');

}
function funcionFallo(){
    deshabilitaBoton('imprime', 'submit');
    deshabilitaBoton('autoriza', 'submit');
}

function consultaDatosAdicionales(numeroCli){
	var tipoCon = 25;
	var totalInv="";
	var totalCede="";

	/*Se consulta el total de cuentas del cliente */
	var CuentaAhoBeanCon = {
			'clienteID': numeroCli
			};

	cuentasAhoServicio.consultaCuentasAho(tipoCon,CuentaAhoBeanCon, { async: false, callback: function(cuenta) {
		if (cuenta != null) {

			if(cuenta.numCuentas != "0"){
				contadorCte = parseInt(cuenta.numCuentas);
			}else{
				contadorCte = 0;
			}
		}
	  }
	});

	/*Se consulta el total de Inversiones del cliente */
	var InversionBean = {
			'clienteID': numeroCli
			};

	inversionServicioScript.consulta(5,InversionBean, { async: false, callback: function(inversion) {
		if (inversion != null) {

			if(inversion.numInversiones != "0"){
				totalInv = parseInt(inversion.numInversiones);
			}else{
				totalInv = 0;
			}
			contadorCte = contadorCte + totalInv ;
		}
	  }
	});


	/*Se consulta el total de CEDES del cliente */
	var CedeBean = {
			'clienteID': numeroCli
			};

	cedesServicio.consulta(3,CedeBean, { async: false, callback: function(cede) {
		if (cede != null) {

			if(cede.numCedes != "0"){
			totalCede = parseInt(cede.numCedes);
			}else{
			totalCede = 0;
			}
			contadorCte = contadorCte + totalCede ;
		}
	  }
	});
}



function consultaSucursalCAJA() {
	if(!ocultarCajaRetiro()){
		var numSucursal = $('#cajaRetiro').val();
		var tipoConsulta = 8;
		setTimeout("$('#cajaLista').hide();", 200);
		if (generarFormatoAnexo && numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreCaja').val(sucursal.nombreSucurs);
					$('#cajaRetiro').val(numSucursal);

				} else {
					mensajeSis("La Sucursal No Cuenta con Ventanillas para el Retiro.");
					$('#nombreCaja').val('');
					$('#cajaRetiro').val('');
					$('#cajaRetiro').focus();
				}
			});
		}
	}
}

function ocultarCajaRetiro(){
	var tipoProducto=$('#tipoCedeID').asNumber();
	generarFormatoAnexo = true;
	if(tipoProducto == productoInvercamex){
		$('#tdCajaRetiro').hide();
		$('#nombreCaja').val('');
		$('#cajaRetiro').val('0');
		generarFormatoAnexo = false;
		return true;
	} else {
		$('#tdCajaRetiro').show();
	}
	return false;
}