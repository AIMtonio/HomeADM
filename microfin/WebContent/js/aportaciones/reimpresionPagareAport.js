var esTab = true;
var generarFormatoAnexo=true;
var productoInvercamex=99999;
var parametroBean = consultaParametrosSession();

var catTipoConsulta = {
		'principal':1
	};

var catTipoLista ={
		'principal' : 1
};

var catStatusAport = {
		'alta':'INACTIVA',
		'vigente':'N',
		'pagada' :'PAGADA',
		'cancelada':'CANCELADA',
		'vencida':'VENCIDA'
};
$(document).ready(function() {
	$('#lblfechaApertura').hide();
	$('#fechaApertura').hide();
	$('#aportacionID').focus();
	$('#tdCajaRetiro').hide();
	deshabilitaControl('plazo');
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$(':text').focus(function() {
	 	esTab = false;
	});

	 parametroBean = consultaParametrosSession();
	deshabilitaBoton('imprimePagare', 'submit');
	agregaFormatoControles('formaGenerica');

	ocultaTasaVar();
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','aportacionID', 'funcionExito', 'funcionFallo');
			}
	});

	$('#aportacionID').blur(function(){
		if(esTab == true){

			validaAport(this.id);
		}
	});

	$('#fecha').html(parametroBean.fechaSucursal);

	$('#imprimePagare').click(function() {
		var aportacionID		= $('#aportacionID').val();
		var monedaID			= $('#monedaID').val();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var monto				= ($('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2 })).asNumber();
		var dirInst				= parametroBean.direccionInstitucion;
		var usuario				= parametroBean.nombreUsuario;
		var sucursalID			= parametroBean.sucursal;
		var nombreSucursal		= parametroBean.nombreSucursal;
		var nombreCliente		= $('#nombreCompleto').val();
		var cuentaAhoID			= $('#cuentaAhoID').val();
		var descTipoAportacion	= $('#descripcion').val();
		var plazo				= $('#plazo').val();
		var calculoInteres		= $('#desCalculoInteres').val();
		var tasaBase			= $('#destasaBaseID').val();
		var tasaISR				= $('#tasaISR').val();
		var totalRecibir		= $('#monto').val();
		var fechaVencimiento	= $('#fechaVencimiento').val();
		var fechaApertura		= $('#fechaApertura').val();
		var sobreTasa			= $('#sobreTasa').val();
		var pisoTasa			= $('#pisoTasa').val();
		var techoTasa			= $('#techoTasa').val();
		var tasaNeta			= $('#tasaNeta').val();
		var tasaFija			= $('#tasaFija').val();
		var interesRecibir		= $('#interesRecibir').val();
		var totalRec			= $('#monto').asNumber();
		var nombreCaja			= $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
		var tipoProducto		= "Aportacion";

		var pagina = '';
		if($('#tipoTasa').val() == 'V'){
			pagina = 'pagareVarAportRep.htm?';
		} else {
			pagina = 'pagareFijoAportRep.htm?';
		}

		pagina = pagina +
			'aportacionID='			+ aportacionID +
			'&monedaID='			+ monedaID +
			'&nombreInstitucion='	+ nombreInstitucion +
			'&monto='				+ monto +
			'&direccionInstit='		+ dirInst +
			'&nombreUsuario='		+ usuario +
			'&sucursalID='			+ sucursalID +
			'&nombreSucursal='		+ nombreSucursal +
			'&nombreCompleto='		+ nombreCliente +
			'&cuentaAhoID='			+ cuentaAhoID +
			'&descripcion='			+ descTipoAportacion +
			'&plazo='				+ plazo +
			'&calculoInteres='		+ calculoInteres +
			'&tasaBase='			+ tasaBase +
			'&tasaISR='				+ tasaISR +
			'&totalRecibir='		+ totalRecibir +
			'&fechaVencimiento='	+ fechaVencimiento +
			'&fechaApertura='		+ fechaApertura +
			'&sobreTasa='			+ sobreTasa +
			'&pisoTasa='			+ pisoTasa +
			'&techoTasa='			+ techoTasa +
			'&valorGat='			+ $('#valorGat').val() +
			'&tasaNeta='			+ tasaNeta +
			'&tasaFija='			+ tasaFija +
			'&interesRecibir='		+ interesRecibir +
			'&total='				+ totalRec;

		window.open(pagina,'_blank');
		$('#aportacionID').focus();

		generarReciboMexi(aportacionID);
	});


	$('#aportacionID').bind('keyup',function(e){
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";
			 parametrosLista[0] = $('#aportacionID').val();
			lista('aportacionID', 2, 7, camposLista, parametrosLista, 'listaAportaciones.htm');
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			aportacionID:{
				required: true,
			},
			cuentaAhoID:{
				required: true,
			},
			tipoAportacionID:{
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
			}
		},
		messages: {
			aportacionID:{
				required:'Especifique Número de Aportación.',
			},
			cuentaAhoID:{
				required:'Especifique la Cuenta.',
			},
			tipoAportacionID:{
				required:'Especifique el Tipo de Aportación.',
			},
			monto:{
				required:'Especifique el Monto.',
			},
			plazo:{
				required:'Especifique el Plazo.',
			},
			fechaVencimiento:{
				required:'Especifique la Fecha de Vencimiento.',
		}
		}
	});
});
function validaAport(idControl){
	var jqAport = eval("'#" + idControl + "'");
	var numAport = $(jqAport).val();
	var aportaBean = {
		'aportacionID' : numAport
	};
	if(numAport != 0 && numAport != '' && !isNaN(numAport)){
			aportacionesServicio.consulta(catTipoConsulta.principal, aportaBean, function(aportBean){
				if(aportBean!=null){
					estatus = aportBean.estatus;
					var varError = 1;
					dwr.util.setValues(aportBean);
					consultaCliente(aportBean.clienteID);
					consultaDireccion(aportBean.clienteID);
					consultaCtaCliente(aportBean.cuentaAhoID);
					consultaSucursalCAJA();
					$('#sobreTasa').val(aportBean.sobreTasa);
					$('#pisoTasa').val(aportBean.pisoTasa);
					$('#techoTasa').val(aportBean.techoTasa);
					if(aportBean.fechaApertura != '1900-01-01'){
						$('#lblfechaApertura').show();
						$('#fechaApertura').show();
						$('#fechaApertura').show();
					}else{
						$('#lblfechaApertura').hide();
						$('#fechaApertura').hide();
					}
					if(estatus == 'C'){
						$('#estatus').val('CANCELADO');
					}

					if(estatus == 'L'){
						$('#estatus').val('AUTORIZADO');
					}

					if(estatus == 'A'){
						$('#estatus').val('REGISTRADO');
					}

					if(estatus == 'N'){
						$('#estatus').val('VIGENTE');
					}

					if(estatus == 'P'){
						$('#estatus').val('PAGADO');
					}

					if(estatus == 'C' || estatus == 'A'){
						if(estatus == 'C'){
							mensajeSis('La Aportación se encuentra Cancelada y no se puede Reimprimir el Pagaré.');
						}
						if(estatus == 'A'){
							mensajeSis('La Aportación no se encuentra Autorizada.');
						}
						deshabilitaBoton('imprimePagare');
					}else{
						habilitaBoton('imprimePagare');
					}

					switch(aportBean.calculoInteres){
						case('2'):
								$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS');
							break;
						case('3'):
								$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
							break;
						case('4'):
								$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS');
							break;
						case('5'):
								$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS CON PISO Y TECHO');
							break;
						case('6'):
								$('#desCalculoInteres').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
							break;
						case('7'):
								$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS CON PISO Y TECHO');
							break;
					}
					if(aportBean.tasaBase != 0){
						validaTasaBase(aportBean.tasaBase);
					}

				}else{
					mensajeSis('La Aportación no Existe.');
					inicializaForma('formaGenerica','aportacionID');
					$(jqAport).focus();
					$(jqAport).select();
				}

			});
		}
	}

function validaTasaBase(tasaBase){


		var TasaBaseBeanCon = {
  			'tasaBaseID':tasaBase
		};

	tasasBaseServicio.consulta(1,TasaBaseBeanCon , { async: false, callback: function(tasasBaseBean) {
		if(tasasBaseBean!=null){
			$('#destasaBaseID').val(tasasBaseBean.nombre);
		}else{
			mensajeSis("No Existe la tasa base");
			}
	}
});

}


function consultaFechaApertura(idControl){
	var jqAport = eval("'#" + idControl + "'");
	var numAport = $(jqAport).val();
	var aportaBean = {
		'aportacionID' : numAport
	};
	if(numAport != 0 && numAport != ''){
			aportacionesServicio.consulta(catTipoConsulta.principal, aportaBean, function(aportBean){
				if(aportBean!=null){
					if(aportBean.fechaApertura != '1900-01-01'){
						$('#fechaApertura').val(aportBean.fechaApertura);
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
          		consultaCliente("clienteID");
          		consultaDireccion("clienteID");
              	consultaTipoAport();
          	}else{
          		mensajeSis("No Existe la Cuenta de Ahorro");
          	}
  			});
    }
}

function consultaTipoAport(){
	var tipoAport = $('#tipoAportacionID').val();
	var conPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);

	var tipoAportBean = {
            'tipoAportacionID':tipoAport,
    };
		if(tipoAportBean != 0){
			tiposAportacionesServicio.consulta(conPrincipal, tipoAportBean, function(tipoAport){
				if(tipoAport!=null){
					$('#descripcion').val(tipoAport.descripcion);
					$('#tipoTasa').val(tipoAport.tasaFV);
					if($('#tipoTasa').val() == 'F'){
						ocultaTasaVar();
					}else if($('#tipoTasa').val() == 'V'){
						mostrarTasaVar();
						monto = $('#monto').asNumber();
						plazo = $('#plazo').asNumber();

					}
				}
			});
		}
}

	function obtieneTasaVariable(tipoAport, monto,plazo){
		var conTasaVariable = 3;
		var TasasAportacionesBean ={
			'tipoAportacionID' :tipoAport,
			'monto':monto,
			'plazo': plazo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoAport != '' && !isNaN(tipoAport)){
			if(tipoAport != 0){
				tasasAportacionesServicio.consulta(conTasaVariable,TasasAportacionesBean, function(tasasAportacionesBean){
					if(tasasAportacionesBean!=null){
						$('#tasaBase').val(tasasAportacionesBean.nombreTasaBase);
						switch(tasasAportacionesBean.calculoInteres){
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
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
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
	habilitaBoton('imprimePagare', 'boton');
	consultaFechaApertura('aportacionID');
	ponerFormatoMoneda();
}
function funcionFallo(){

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
	$('#tdCajaRetiro').hide();
	$('#nombreCaja').val('');
	$('#cajaRetiro').val('0');
	generarFormatoAnexo = false;
	return true;
}
