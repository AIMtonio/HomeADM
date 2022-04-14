var esTab = true;
var generarFormatoAnexo=true;
var productoInvercamex=1;
var parametroBean = consultaParametrosSession();

var catTipoConsulta = {
		'principal':1
	};

var catTipoLista ={
		'principal' : 1
};

var catStatusCede = {
		'alta':'INACTIVA',
		'vigente':'N',
		'pagada' :'PAGADA',
		'cancelada':'CANCELADA',
		'vencida':'VENCIDA'
}; 
$(document).ready(function() {
	$('#lblfechaApertura').hide();
	$('#fechaApertura').hide();
	$('#cedeID').focus();
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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','cedeID', 'funcionExito', 'funcionFallo');				
			}
	});

	$('#cedeID').blur(function(){
		if(esTab == true){

			validaCede(this.id);
		}		
	});
		
	$('#fecha').html(parametroBean.fechaSucursal);
	
	$('#imprimePagare').click(function() {
			var cedeID = $('#cedeID').val();
			var monedaID = $('#monedaID').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var monto =  ($('#monto').formatCurrency({
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
			var tasaBase = $('#destasaBaseID').val();
			var tasaISR = $('#tasaISR').val();
			var totalRecibir = $('#monto').val();
			var fechaVencimiento = $('#fechaVencimiento').val();
			var fechaApertura = $('#fechaApertura').val();
			var sobreTasa = $('#sobreTasa').val();
			var pisoTasa = $('#pisoTasa').val();
			var techoTasa = $('#techoTasa').val();
			var tasaNeta = $('#tasaNeta').val();
			var tasaFija = $('#tasaFija').val();
			var interesRecibir = $('#interesRecibir').val();
			var totalRec = $('#monto').asNumber();
			var nombreCaja = $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
			var tipoProducto= "CEDE";
			
			if($('#tipoTasa').val() == 'V'){
				var liga = 'pagareCedeRep.htm?cedeID='+cedeID +
							  '&monedaID=' + monedaID + 
							  '&nombreInstitucion=' + nombreInstitucion  + 
							  '&monto=' + monto+
							  '&direccionInstit='+dirInst+
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
				$('#enlace').attr('href',liga);
			}else{
				var liga = 'pagareFijoCedeRep.htm?cedeID='+cedeID +
				  '&monedaID=' + monedaID + '&nombreInstitucion=' + nombreInstitucion  + '&monto=' + monto
				  +'&direccionInstit='+dirInst+'&nombreUsuario='+usuario+'&sucursalID='+sucursalID+'&nombreSucursal='+nombreSucursal+
				  '&nombreCompleto='+nombreCliente + '&cuentaAhoID='+cuentaAhoID+'&descripcion='+descripcionTipoCede+'&plazo='+plazo+
				  '&tasaISR='+tasaISR+'&totalRecibir='+totalRecibir+'&fechaVencimiento='+fechaVencimiento+
				  '&fechaApertura='+fechaApertura +'&tasaNeta='+tasaNeta+'&tasaFija='+tasaFija+'&interesRecibir='+interesRecibir+'&total='+totalRec;
				$('#enlace').attr('href',liga);				
			}
			if(generarFormatoAnexo){
				window.open('reporteAnexoPagareInv.htm?inversionID='+cedeID +
						  '&nombreInstitucion=' + nombreInstitucion  
						  +'&direccionInstit='+dirInst
						  +'&fechaVencimiento='+$('#fechaVencimiento').val()
						  +'&nombreSucursal='+nombreCaja
						  +'&tipoProducto='+tipoProducto
						  +'&domicilioInst='+dirInst);
			}
	});
	
	
	$('#cedeID').bind('keyup',function(e){				
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";		
			 parametrosLista[0] = $('#cedeID').val();			
			lista('cedeID', 2, 7, camposLista, parametrosLista, 'listaCedes.htm');		
	});
	
			
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
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
		}
		}
	});
});	
function validaCede(idControl){
	var jqCede = eval("'#" + idControl + "'");
	var numCede = $(jqCede).val();			
	var cedeBean = {
		'cedeID' : numCede
	};
	if(numCede != 0 && numCede != '' && !isNaN(numCede)){					
			cedesServicio.consulta(catTipoConsulta.principal, cedeBean, function(cedesCon){
				if(cedesCon!=null){	
					estatus = cedesCon.estatus;
					var varError = 1;
					dwr.util.setValues(cedesCon);
					consultaCliente(cedesCon.clienteID);
					consultaDireccion(cedesCon.clienteID);
					consultaCtaCliente(cedesCon.cuentaAhoID);
					consultaSucursalCAJA();
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
						$('#estatus').val('CANCELADO');
					}
					
					if(estatus == 'A'){
						$('#estatus').val('AUTORIZADO');
					}
					
					if(estatus == 'N'){
						$('#estatus').val('VIGENTE');
					}
					
					if(estatus == 'P'){
						$('#estatus').val('PAGADO');
					}
					
					if(estatus == 'C' || estatus == 'A'){
						if(estatus == 'C'){
							mensajeSis('El CEDE se encuentra Cancelado y no se puede Reimprimir el Pagare.');
						}	
						if(estatus == 'A'){
							mensajeSis('El CEDE aun no se encuentra Autorizado.');
						}
						deshabilitaBoton('imprimePagare');
					}else{
						habilitaBoton('imprimePagare');
					}										

					switch(cedesCon.calculoInteres){
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
					if(cedesCon.tasaBase != 0){
						validaTasaBase(cedesCon.tasaBase);				
					}				
						
				}else{
					mensajeSis('La Cede no Existe');
					inicializaForma('formaGenerica','cedeID');
					$(jqCede).focus();
					$(jqCede).select();
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
					}else if($('#tipoTasa').val() == 'V'){
						mostrarTasaVar();
						monto = $('#monto').asNumber();
						plazo = $('#plazo').asNumber();
						
					}					
				}				
			});
		}
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
						switch(tasasCedesBean.calculoInteres){						
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
	consultaFechaApertura('cedeID');
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