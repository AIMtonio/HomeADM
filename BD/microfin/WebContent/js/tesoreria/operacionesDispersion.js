
var catTipoConsultaDispersion = {
	'principal':1,
	'autoriza':3, // para colsultar las pendientes para autorizar
	'NumTransaccion': 7

};

var catTipoConsultaCtaNostro = {
	'resumen':4,
	'folio': 14
};
var  catTipoConsultaEstatusFecha={
	'estatus' :4
};

var numeroPoliza;
var numChequeUsar = "0";
var numChequeUsarEstan = "0";
var jqInstitucionID;
var jqNumCtaInstit;
var institucionID;
var numCtaInstit;
var nomBenefi;
var monto;
var rutaCheque ="";
var rutaChequeEstan ="";
var rutaUsar;
var rutaUsarEstan;
var nombreRutaCheque;
var nombreRutaChequeEstan;
var numTran = "0";
var numSucursal = parametroBean.sucursal;
var moneda = '1';
var fechaEmision = parametroBean.fechaSucursal;
var nombreOperacion='Dispersion de Recursos';
var montoNumer;
var nombreBene='' ;
var enlace ;
var ID;
var requisicion =1 ;
var controlFP = 0;
var numeroCliente = 0;
var CliEspSofi = 15;
var permiteVer;
var estatusSPEI = "N";
var Var_ManejaSPEI = "N";

// funcion para consultar Parametros Spei
function consultaParametrosSPei() {
	var numEmpresa = 1;
	var tipConsulta = 1;
	var parBeanCon = {
		'empresaID': numEmpresa,
	};
	//setTimeout("$('#cajaLista').hide();", 200);
	if (numEmpresa != '' && !isNaN(numEmpresa)) {

		parametrosSpeiServicio.consulta(tipConsulta, parBeanCon, function (data) {
			//si el resultado obtenido de la consulta regreso un resultado
			if (data != null) {
				estatusSPEI = data.habilitado; 
				if(estatusSPEI == "S"){
					$('#trAportaciones').hide();

				}else{
					$('#trAportaciones').show();
				}

			} else {
				mensajeSis("No Existe Empresa");
				limpiaCampos();
			}
		});
	}

}

$(document).ready(function() {

validaManejaSPEI();
if (Var_ManejaSPEI == 'S') {
	consultaParametrosSPei();
}

consultaFechaDisp();
var parametroBean = consultaParametrosSession();
$('#fechaActual').val(parametroBean.fechaSucursal);
consultaParametro();
$('#ui-datepicker-div').hide();
esTab = true;
agregaFormatoControles('formaGenerica');

$(':text').focus(function() {	
 	esTab = false;
});
$(':text').bind('keydown',function(e){
	if (e.which == 9 && !e.shiftKey){
	esTab= true;
	}
});
$('#folioOperacion').focus();
$('#tableCon').hide();
$('#tablaAutoriza').hide();
$('#tablaExporta').hide();
	
//Definicion de Constantes y Enums  
var catTipoTransaccionConciliacion = {
		'graba':'1',
		'modifica':'2',
		'elimina':'3'
};

var catTipoConsultaConciliacion = {
		'principal':1,
		'foranea':2
};	

var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
};

var catTipoConsultaSucursales = {
		'principal':1, 
		'foranea':2,
		'porCuentasAho':3
};

var catTipoTransaccionCtaAho = {
		'grabar':'1',
		'autoriza':'3'
};

catTipoConsultaDispersion = {
		'principal':1,
		'autoriza':3, // para colsultar las pendientes para autorizar
		'NumTransaccion': 7

};


var catTipoAccion = {
		'valida' : 1,
		'autoriza' : 2,
		'exporta' : 3
};

//------------ Metodos y Manejo de Eventos -----------------------------------------
deshabilitaBoton('grabar', 'submit');
deshabilitaBoton('modificar', 'submit');
deshabilitaBoton('autorizaBoton', 'submit');
deshabilitaBoton('agregar', 'submit');
deshabilitaBoton('exportarArchivo', 'submit');
deshabilitaBoton('imprimeCheque','submit');


$('#fechaActual').change(function(){
	var fechax=parametroBean.fechaSucursal;
	if($('#fechaActual').val()== ''){				
		$('#fechaActual').val(fechax);
	}else{			
			if(esFechaValida($('#fechaActual').val())){
				if($('#fechaActual').val()> fechax){
					mensajeSis('La Fecha Especificada no puede ser Mayor a la Fecha Actual');
					$('#fechaActual').val(fechax);
					$('#fechaActual').focus();
				}else{
					consultaEstatus('fechaActual');
				}
			}else{
				$('#fechaActual').val(fechax);			
			}
		
			$('#institucionID').focus();
	}
});

$('#fechaConsulta').change(function(){
	var fechax=parametroBean.fechaSucursal;
	var fechaCons = $('#fechaConsulta').val();
	if(fechaCons != '' && fechaCons != undefined){
		if(esFechaValida(fechaCons)){
			if($('#fechaConsulta').val()> fechax){
				mensajeSis('La Fecha Especificada no puede ser Mayor a la Fecha Actual');
				$('#fechaConsulta').focus();
				$('#fechaConsulta').val('');
			}
		}else{
			$('#fechaConsulta').focus();
			$('#fechaConsulta').val('');
		}	
	}			
});

$('#importarMov').click(function(){
	var tipoConsul = 4;
	$('#tipoTransaccion').val(tipoConsul); 
	$('#tabs').tabs('select', 1);
	$('#tipoAccion').val(catTipoAccion.autoriza);
	$('#folioOperacion').focus();
	$('#estatusRequisicion').val('S');
});

$('#importarMovReq').click(function(){
	var tipoTranImp = 5; // tipo de transaccion para importar movs de req
	$('#tipoTransaccion').val(tipoTranImp); 
	$('#tabs').tabs('select', 1);
	$('#folioOperacion').focus();
	$('#estatusRequisicion').val('S');
	requisicion = 1;
});


$('#importarPagoServ').click(function(){
	var tipoTranImp = 6; // tipo de transaccion para importar movs de req
	$('#tipoTransaccion').val(tipoTranImp); 
	$('#tabs').tabs('select', 1);
	$('#folioOperacion').focus();	
	requisicion = 1;
	
});

$('#importarAnticipos').click(function(){
	var tipoTranImp = 7; // tipo de transaccion para importar anticipos 
	$('#tipoTransaccion').val(tipoTranImp); 
	$('#tabs').tabs('select', 1);
	$('#folioOperacion').focus();
	$('#estatusRequisicion').val('S');
	requisicion = 1;
});

$('#importarBonificaciones').click(function(){
	var importaBonificaciones = 8; // tipo de transaccion para importar Bonificaciones
	$('#tipoTransaccion').val(importaBonificaciones);
	$('#tabs').tabs('select', 1);
	$('#folioOperacion').focus();
	$('#estatusRequisicion').val('S');
	requisicion = 1;
});


$('#importarAportaciones').click(function(){
	var importarAportaciones = 9;
	$('#tipoTransaccion').val(importarAportaciones); 
	$('#tabs').tabs('select', 1);
	$('#folioOperacion').focus();
	$('#estatusRequisicion').val('S');		
	requisicion = 1;

});

$('#verifica').click(function(){ 
	if($('#folioOperacion').val() > 0){
		setTimeout("$('#tabs').tabs('select',1);", 150);		
	}
	else {
		$('#tipoAccion').val(catTipoAccion.valida); 
			validaFolio("folioOperacion");			
		limpiaTablaAutoriza();
		$('#tablaAutoriza').hide();
		$('#tablaExporta').hide();
	}

});

$('#autoriza').click(function(){
	if($('#folioOperacion').val()==0){
		setTimeout("$('#tabs').tabs('select',0);", 150);
		mensajeSis("No existen dispersiones para Autorizar.");	
	}
	else{
		$('#tipoAccion').val(catTipoAccion.autoriza);
			validaFolio("folioOperacion");
		$('#tableCon').hide();
		$('#tablaExporta').hide();		
	}
});

$('#exporta').click(function(){ 
	$('#tipoAccion').val(catTipoAccion.exporta); 
	limpiaTablaVerifica();
	$('#tableCon').hide();
	limpiaTablaAutoriza();
	$('#tablaAutoriza').hide();
});

$('#impPoliza').click(function(){
	$('#enlace').attr('href','RepPoliza.htm?polizaID='+numeroPoliza+'&fechaInicial='+parametroBean.fechaSucursal+
			'&fechaFinal='+parametroBean.fechaSucursal+'&nombreUsuario='+parametroBean.nombreUsuario);
$('#impPoliza').hide();	
});

$('#folioOperacion').blur(function(){	
	$('#ui-datepicker-div').hide();
	varEsCheque = 'N';
	$('#reimprimirCheque').hide();
	$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
	if($('#folioOperacion').val() != "" ){
	
		if($('#folioOperacion').val() == 0){
			limpiaEncabezado();
			limpiaTablaAutoriza();
			limpiaTablaVerifica();
			borraPartidasVerifica();	
			borraPartidasAutoriza();		
			$('#tablaAutoriza').hide();
			$('#tablaExporta').hide();
			habilitaBoton('grabar', 'submit');
			$('#fechaActual').val(parametroBean.fechaSucursal);
			$('#protecOrdenPagoB').hide();
			$('#reimprimeOrdenPago').hide();
		}else if($('#folioOperacion').val()>0 && $('#tipoAccion').val()!=3){			
			$('#tipoAccion').val(2);
			borraPartidasVerifica();
			$('#tableCon').hide();
			$('#reimprimirCheque').hide();
		}

		var tipoAccionBoton = $('#tipoAccion').val(); 						
		if(tipoAccionBoton == catTipoAccion.valida)	{ 
			
			(this.id); 
			$('#tablaAutoriza').hide();
			$('#tablaExporta').hide();
			limpiaTablaAutoriza();
			


		}
		if(tipoAccionBoton == catTipoAccion.autoriza){
			validaFolio(this.id);
			limpiaTablaVerifica();
			$('#tableCon').hide();
			$('#tablaExporta').hide();
			
		}
		if(tipoAccionBoton == catTipoAccion.exporta)	{ 
			validaFolio(this.id);
		}
	}

	
});	

$('#folioOperacion').bind('keyup',function(e){
	var tipoAccionBoton = $('#tipoAccion').val(); 						
	var camposLista = new Array();
	var tipoLista='1';
	var parametrosLista = new Array();
	camposLista[0] = "institucionID";
	parametrosLista[0] = $('#folioOperacion').val();

	if(tipoAccionBoton == catTipoAccion.exporta)	{ 
		tipoLista='2';
	}
	else{
		tipoLista='1';
	}
	listaAlfanumerica('folioOperacion', '2', tipoLista, camposLista, parametrosLista, 'dispersionListaVista.htm');
});


$('#grabar').click(function(event) {

	if(cicloConsultaCuentas()== true){
		if(validaGridVerificar()==0){
			$('#tipoTransaccion').val(catTipoTransaccionCtaAho.grabar);
		}
		else{
			return false;
		}
	}
	else{
		return false;
	}
});	
$('#agregar').click(function(event) {	
	agregaNuevoDetalle();		
	habilitaBoton('grabar', 'submit');
	
});

$('#modificar').click(function(event) {	
	$('#tipoTransaccion').val(catTipoTransaccionConciliacion.modifica);	
});

$('#autorizaBoton').click(function(event) {	
	
	if(validaGridAutorizar()==0){			
		if($('#tipoAccion').val()==1){
			limpiaTablaAutoriza();
		}else if($('#tipoAccion').val()==2){
			limpiaTablaVerifica();	
			$('#tableCon').remove();						
		}		
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.autoriza);			
	}else{
		return false;
	}
	
});

$('#grabar').attr('tipoTransaccion', '1');


$('#institucionID').bind('keyup',function(e){
	//TODO Agregar Libreria de Constantes Tipo Enum
	listaAlfanumerica('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
});

$('#institucionID').blur(function() {
	if($('#institucionID').val() != ''  ){
		consultaInstitucion(this.id);
		var tipoAccionBoton = $('#tipoAccion').val(); 		

	}
});


$('#cuentaAhorro').bind('keyup',function(e){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "institucionID";
	parametrosLista[0] = $('#institucionID').val();

	camposLista[1] = "cuentaAhoID";
	parametrosLista[1] = $('#cuentaAhorro').val();

	listaAlfanumerica('cuentaAhorro', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');	       
});


$('#cuentaAhorro').blur(function() {
	if($('#cuentaAhorro').val() != '' && !isNaN($('#cuentaAhorro').val()) ){
		validaCuentaAhorro();
		$('#tableCon').show();
	}
	$('#numCtaInstit').val($('#cuentaAhorro').val());	

});


// imprimir cheque
$('#imprimeCheque').click(function(){
 var CtaNostroBeanCon = {
			'institucionID':$('#institucionID').val(),
			'numCtaInstit':$('#cuentaAhorro').val()
	};				
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon,{ async: false, callback:function(ctaNostro){
					if(ctaNostro!=null){ 
						if(ctaNostro.rutaCheque == '' && ctaNostro.rutaCheque == null){
							nombreRutaCheque = '';							
						}else{					
							rutaCheque = ctaNostro.rutaCheque;							
							rutaUsar = rutaCheque.split(".");
							nombreRutaCheque =rutaUsar[0];
						}
						if(ctaNostro.rutaChequeEstan == '' && ctaNostro.rutaChequeEstan == null){
							nombreRutaChequeEstan = '';							
						}else{					
							rutaChequeEstan = ctaNostro.rutaChequeEstan;							
							rutaUsarEstan = rutaChequeEstan.split(".");
							nombreRutaChequeEstan =rutaUsarEstan[0];
							
						}
						
						imprimeCheques();
					}
				}

});

});

$('#reimprimirCheque').click(function(){
	 var CtaNostroBeanCon = {
		'institucionID':$('#institucionID').val(),
		'numCtaInstit':$('#cuentaAhorro').val()
};				
		cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon,{ async: false, callback:function(ctaNostro){
				if(ctaNostro!=null){ 
					if(ctaNostro.rutaCheque == '' && ctaNostro.rutaCheque == null){
						nombreRutaCheque = '';							
					}else{					
						rutaCheque = ctaNostro.rutaCheque;							
						rutaUsar = rutaCheque.split(".");
						nombreRutaCheque =rutaUsar[0];
					}
					if(ctaNostro.rutaChequeEstan == '' && ctaNostro.rutaChequeEstan == null){
						nombreRutaChequeEstan = '';							
					}else{					
						rutaChequeEstan = ctaNostro.rutaChequeEstan;							
						rutaUsarEstan = rutaChequeEstan.split(".");
						nombreRutaChequeEstan =rutaUsarEstan[0];
						
					}
					
					reImprimeCheques();
				}
			}

});
});

$('#reimprimeOrdenPago').click(function(){
imprimeOrdenPago();
});

$('#protecOrdenPagoB').click(function(){

var tipoReporte		= 2;
var institucionID	= $('#institucionID').val();
var numCtaInstit	= $('#numCtaInstit').val();
var folioOpe		= $('#folioOperacion').val();
		
$('#enlaceProtecOrdenPago').attr('href','RepDispOrdenPagPDF.htm?institucionID='+institucionID+
				'&folioOperacion='+folioOpe+'&cuentaAhorro='+numCtaInstit+'&tipoReporte='+tipoReporte);
});

function validaCuentaAhorro(){
	var tipoConsulta = 9;
	var institucion=$('#institucionID').val();
	var cuenta =$('#cuentaAhorro').val();
	if(institucion=='')institucion=0;
	if(cuenta=='')cuenta=0;

	var DispersionBeanCta = {
			'institucionID': institucion,
			'numCtaInstit': cuenta
	};
	setTimeout("$('#cajaLista').hide();", 200);	
	if(cuenta >0 && esTab){
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){
				$('#sobregirarSaldo').val(data.sobregirarSaldo);
				$('#cuentaAhorro').val(data.numCtaInstit);
				$('#numCtaInstit').val(data.numCtaInstit);
				$('#nombreSucurs').val(data.nombreCuentaInst);
				$('#protecOrdenPago').val(data.protecOrdenPago);
				consultaSaldoCuentaTesoreria(data.numCtaInstit,$('#institucionID').val());					
			}else{
				mensajeSis("No existe el numero de Cuenta.");
				$('#cuentaAhorro').val('');
				$('#numCtaInstit').val('');
				$('#nombreSucurs').val('');
				$('#saldo').val('');
				$('#cuentaAhorro').focus();
			}
		});
	}
	var verificarNumDetalle=0;
	if($('#folioOperacion').val()== 0){				
		$('input[name=consecutivoID]').each(function(){
			verificarNumDetalle++;
			$('#numeroDetalle').val(verificarNumDetalle);
		});					
		if($('#numeroDetalle').val()<1){
			agregaNuevoDetalle();						
		}
		habilitaBoton('agregar','submit');
		habilitaBoton('grabar', 'submit');
	}	   
}


// funcion para consultar el saldo de la cuenta bancaria de Tesoreria
function consultaSaldoCuentaTesoreria(numCta, institucion){
	var tipoConsulta = 10;
	var cuentaTesoreria = {
			'institucionID': institucion,
			'numCtaInstit':numCta
	};	
	cuentaNostroServicio.consulta(tipoConsulta, cuentaTesoreria, function(cuentaTeso){
		if(cuentaTeso!=null){
			$('#saldo').val(cuentaTeso.saldo);
			if($('#tipoAccion').val() == 2){
				agregaTotalesAutorizar();
			}


		}
	});   
}

function validaFolio(idControl){
	setTimeout("$('#cajaLista').hide();", 200);
	var jqFolio = eval("'#" + idControl + "'");
	var numFolio = $(jqFolio).val();		
	$('#ui-datepicker-div').hide();

	tiposChequera = {};
	if(numFolio == 0 && numFolio != ''){			
		habilitaBoton('grabar', 'submit');			
		limpiaTablaVerifica();
		$('#miTabla').show();
		$('#tipoAccion').val(1);
		$('#tabs').tabs('select', 0);				
	}else{
		
		if(numFolio != 0 && numFolio != '' && !isNaN(numFolio)){
			var DispersionBeanCta = {
					'folioOperacion': $('#folioOperacion').val()
			};
								 
			operDispersionServicio.consulta( catTipoConsultaDispersion.principal, DispersionBeanCta, { async: false, callback:function(dispBean){
				if(dispBean!=null){
			 		
					esTab=true;
					var fechaDeOp = dispBean.fechaOperacion;
					if(fechaSI=="S"){
						$('#fechaActual').val(fechaDeOp.substr(0,10));//sin formato (yyyy-mm-dd hh-mm-ss)
					}else{
						$('#fechaActual').val(parametroBean.fechaSucursal);
					}
					
					
					$('#institucionID').val(dispBean.institucionID);
					consultaInstitucion('institucionID');
					$('#cuentaAhorro').val(dispBean.cuentaAhorro);
					validaCuentaAhorro(); 
					//cargarTipoChequera('cuentaAhorro','institucionID');

					if($('#tipoAccion').val() == 2){
						if(dispBean.estatusEnc == "C"){
							var folio = $('#folioOperacion').val();					 			
				 			deshabilitaBoton('autorizaBoton','submit');
				 			$('#estatusFolio').val('C');
							if($('#impPoliza').is(':visible')==false && $('#imprimeCheque').is(':visible')==false ) {

									operDispersionServicio.consulta( catTipoConsultaDispersion.NumTransaccion, DispersionBeanCta, function(dispBean){
										

										if(dispBean!=null ){
											var chequesEmitidosBean = {
												'numeroCheque':dispBean.folioOperacion,
											};

											chequesEmitidosServicio.consulta(3,chequesEmitidosBean,function(cheque) {													
											if(cheque!=null){
												if(cheque.estatus != 'C' || cheque.estatus != 'R' || cheque.estatus != 'O' || cheque.estatus != 'P'){
												numeroPoliza=cheque.numeroCheque;														
													$('#reimprimirCheque').show();														
												}
													
											}
											});

										}
									
									});

									mensajeSis("El Folio de Dispersión: "+folio+" ya ha sido Autorizado.");
									$('#institucionID').focus();

							}
							
					 		
						  
					 		
				 			$('#estatusDisper').val(dispBean.estatusEnc);
				 			
				 		}else{					 			
				 			 if ($('#estatusDisper').val() == 'C'){
								  deshabilitaBoton('autorizaBoton', 'submit');
							  }else{
								  habilitaBoton('autorizaBoton', 'submit');
							  }
				 			$('#estatusFolio').val('');	 			
				 			$('#estatusDisper').val("A");
				 		}							
						pegaHtmlAutoriza(catTipoConsultaDispersion.autoriza, "tablaAutoriza");								
						limpiaTablaVerifica();
						$('#miTabla').hide();
						$('#tablaAutoriza').show();		
						$('#tabs').tabs('select', 1);							
					}
					agregaFormatoControles('formaGenerica');
					$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
				}else{
					mensajeSis("No existe el Folio de Operación");
					$('#folioOperacion').focus();
					limpiaEncabezado();
					limpiaTablaVerifica();
					$('#tableCon').hide();
					limpiaTablaAutoriza();
					$('#tablaAutoriza').hide();
					$('#folioOperacion').val('');
					$('#folioOperacion').focus();
					$('#tabs').tabs('select', 0);

				}
			}});
		}
	}
		$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2}); 		

}

function pegaHtml(folioOperacion){
	if(!isNaN(folioOperacion)){
		var params = {};	

		params['folioOperacion'] = folioOperacion;
		params['tipoConsulta'] =  catTipoConsultaConciliacion.principal;

		$.post("operDispersionGrid.htm", params, function(data){
			if(data.length >0 && folioOperacion!=''){
				$('#tableCon').replaceWith(data); 
				agregaNombresClientes('tipoMov','cuentaAhoID','nombreCte','clienteID');
				corrigeNumeroDetalle('numeroDetalle');
				validaOrdenPago();

			}else{
				mensajeSis('No se han encontrado movimientos con los datos proporcionados');
				$('#folioOperacion').val("");
			}
		}); 
	}		 
}

function pegaHtmlAutoriza(tipoConsulta, divReceptor){
	var folioDispersion = $('#folioOperacion').val();
	if(!isNaN(folioDispersion)){

		var params = {};
		params['folioOperacion'] = folioDispersion;
		params['tipoConsulta'] =  3;
		
		var jqDiv = eval("'#" + divReceptor + "'");
		$.post("operDispersionGrid.htm", params, function(data){
			if(data.length > 0 && folioDispersion != ''){
				$(jqDiv).html(data); 
				agregaNombresClientes('formaPagoA','cuentaAhoIDA','nombreCteA','clienteIDA');					
				corrigeNumeroDetalle('numeroDetalleAuto');
				agregaFormatoMontos();
				limpiaTablaVerifica();	


					$('input[name=consecutivoIDA]').each(function(){
						 var i = this.id.substring(14);
						cargarCombo(i);

					}); 
					
				$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
				$('input[name=montoA]').each(function() {
					var id =this.id.substring(6);
					var jqMonto = eval("'#" + this.id + "'");
					
					$(jqMonto).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
					
					
				});							

				if($('#estatusDisper').val() == 'A'){
					var banderaFormaPago ='';
						$('input[name=montoA]').each(function() {
							var id =this.id.substring(6);							
							$('#nombreBenefiA'+id).attr('readonly',true);
							if($('#formaPagoA'+id).val() == 2){
								banderaFormaPago ='S';
							}								
						});
						
			
						if( banderaFormaPago == 'S'){							
								//validaCtaNostroChequera2('cuentaAhorro','institucionID');						
						}
				}else if	
					($('#estatusDisper').val() == 'C'){
					$('input[name=montoA]').each(function() {
						var id =this.id.substring(6);						
						$('#nombreBenefiA'+id).attr('readonly',true);
						$('#cuentaClabeA'+id).attr('readonly',true);	
						deshabilitaControl(('stipoChequera'+id));

					});
					validaOrdenPago();
				}
				
					$('input[name=tipoMovA]').each(function() {
						var id =this.id.substring(8);
						var claveDisp = $('#tipoMovA'+id).val();
						if(claveDisp == 12 || claveDisp == 2 || claveDisp == 700){
							cargaConcepto(id);
						}else{
							$('#sConceptoDisp'+id).empty();
							$('#sConceptoDisp'+id).append( new Option('SELECCIONAR', '', true, true));
							deshabilitaControl(('sConceptoDisp'+id));
						}
					});
			}else{
				mensajeSis('No se han Encontrado Movimientos con los Datos Proporcionados');
				$('#folioOperacion').val("");
			}
		}); 
	}
}




//Método de consulta de Institución

function consultaInstitucion(idControl) {
	var jqInstituto = eval("'#" + idControl + "'");
	var numInstituto = $(jqInstituto).val();
	var cuenta = $('#cuentaAhorro').val();

	setTimeout("$('#cajaLista').hide();", 200);	
	var InstitutoBeanCon = {
			'institucionID':numInstituto
	};

	if(numInstituto != '' && !isNaN(numInstituto) ){
		institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
			if(instituto!=null){							
				$('#nombreInstitucion').val(instituto.nombre);
				if(cuenta != ''){
					validaCuentaAhorro();
				}
			}else{
				mensajeSis("No existe la Institución");
				$('#nombreInstitucion').val('');
				$('#institucionID').val('');
				$('#institucionID').focus();				
				if(cuenta != ''){
					validaCuentaAhorro();
				}
			}    						
		});
	}
	if(isNaN(numInstituto)){
		$('#nombreInstitucion').val('');


	}
}


//Método de consulta para el nombre de sucursal
function consultaSucursal(idControl){
	var jqControl = eval("'#" + idControl + "'");
	var numControl = $(jqControl).val();
	setTimeout("$('#cajaLista').hide();", 200);

	var sucursalesBean = {
			'nombreSucurs': numControl,
			'sucursalID': $('#institucionID').val()
	};	

	if(numControl != '' && !isNaN(numControl) ){
		sucursalesServicio.consulta(sucursalesBean,catTipoConsultaSucursales.porCuentasAho,function(sucursal){
			if(sucursal!=null){							
				$('#nombreSucurs').val(sucursal.nombreSucurs);									
			}   						
		});
	}		
}


$.validator.setDefaults({
	submitHandler: function(event) { 
		var envia = guardarFechas();
  		if(envia!=2){
  		
  			habilitaControl('fechaActual');
			  verParametrosDispersion();
			  if(permiteVer == 'S' && $('#tipoTransaccion').val() == catTipoTransaccionCtaAho.autoriza){
				  if(validaFormaDispersion()){
					  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioOperacion',
								'funcionExitoDisper','funcionFalloDisper');
				  }else{
					  mensajeSis('El folio para autorizar contiene dispersiones diferentes a Tran. Santanrder u Orden de Pago');
				  }
				 
			  }else{
  			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioOperacion',
				'funcionExitoDisper','funcionFalloDisper');
			  }
			  
  		}else{
  			
  			mensajeSis("Faltan datos");
	  	}
	 
  	}
	
});



//------------ Validaciones de la Forma -------------------------------------

$('#formaGenerica').validate({
	rules: {
		institucionID: 'required',
		cuentaAhorro		: 'required'
	},

	messages: {
		institucionID: 'Especifique Institución',
		cuentaAhorro		: 'Especifique Cuenta Bancaria'
	}		
});


$('#exportarArchivo').click(function(event) {
	var folioOperacion = $('#folioOperacion').val();
	var institucionID=$('#institucionID').val();
	if(validaExisteLayout(parseInt(institucionID))==false){
		return false;
	}else{
		$('#enlaceExp').attr('href','exportaDispercionTxt.htm?folioOperacion='+folioOperacion+'&institucionID='+institucionID);
	}
});


function validaExisteLayout(institucion){
	/* Esta funcion se actualizara conforme a los layoutys que hayamos creado en
	 * tesoreria.reporte.DispercionRepControlador si agregamos un nuevo layout Editamos a funcion
	 * comentamos  mensaje+="institucion"; y retorno = true
	 * 
	 * */
	var mensaje="No existe el formato para:";
	var retorno= true;
	switch(institucion){
	case 1: mensaje+=" Nafin" ;				retorno=false; break;		
	case 2: mensaje+="Bancomext";			retorno=false; break;
	case 3: mensaje+="Banobras"	;			retorno=false; break;	
	case 4: mensaje+="SHF"	;				retorno=false; break;
	case 5: mensaje+="Banjercito"	;		retorno=false; break;	
	case 6: mensaje+="Bansefi"	;			retorno=false; break;
	case 7: mensaje+="ABC Capital"	;		retorno=false; break;
	case 8: mensaje+="American	Express";	retorno=false; break;
	case 9: mensaje+="Banamex"	;			retorno=false; break;
	case 10:mensaje+="Afirme";				retorno=false; break;
	case 11:/*mensaje+="Mifel"	;*/			retorno=true;  break;	// ya existe el layout en controlador
	case 12:mensaje+="Actinver";			retorno=false; break;	
	case 13:mensaje+="Famsa"	;			retorno=false; break;	
	case 14:mensaje+="Autofin"	;			retorno=false; break;	
	case 15:mensaje+="Banco Azteca";		retorno=false; break;
	case 16:mensaje+="Compartamos"	;		retorno=false; break;	
	case 17:mensaje+="Credit Suisse"	;	retorno=false; break;
	case 18:mensaje+="Banco del Bajio";		retorno=false; break;
	case 19:mensaje+="Banco Facil";			retorno=false; break;
	case 20:mensaje+="Inbursa"	;			retorno=false; break;
	case 21:mensaje+="Interacciones";		retorno=false; break;	
	case 22:mensaje+="Invex"	;			retorno=false; break;
	case 23:mensaje+="J.P. Morgan"	;		retorno=false; break;
	case 24:/*mensaje+="Banorte"	;*/		retorno=true;  break;// ya existe el layout en controlador	
	case 25:mensaje+="Monex"	;			retorno=false; break;
	case 26:mensaje+="Multiva"	;			retorno=false; break;	
	case 27:mensaje+="Banregio";			retorno=false; break;	
	case 28:mensaje+="Santander";			retorno=false; break;	
	case 29:mensaje+="Ve por Mas" 	;		retorno=false; break;
	case 30:mensaje+="Wall Mart";			retorno=false; break;
	case 31:mensaje+="Coppel"	;			retorno=false; break;
	case 32:mensaje+="Merril Lynch";		retorno=false; break;
	case 33:mensaje+="New	York"	;		retorno=false; break;
	case 34:mensaje+="Tokyo Mitsubishi";	retorno=false; break;
	case 35:mensaje+="BanSi"	;			retorno=false; break;
	case 36:mensaje+="Barclays";			retorno=false; break;	
	case 37:mensaje+="Bancomer	";			retorno=false; break;
	case 38:mensaje+="CI Banco";			retorno=false; break;
	case 39:mensaje+="Deutsche Bank";		retorno=false; break;
	case 40:mensaje+="HSBC	"	;			retorno=false; break;
	case 41:mensaje+="ING"	;				retorno=false; break;
	case 42:mensaje+="Inter Banco"	;		retorno=false; break;
	case 43:mensaje+="IXE"	;				retorno=false; break;
	case 44:mensaje+="Scotiabank"	;		retorno=false; break;	
	case 45:mensaje+="Royal Scotland"	;	retorno=false; break;
	case 46:mensaje+="UBS	Bank";			retorno=false; break;
	case 47:mensaje+="Volkswagen"	;		retorno=false; break;	
	case 48:mensaje+="FinSur SOFIPO";		retorno=false; break;
	case 49:mensaje+="FinSur SOFOM";		retorno=false; break;	
	case 50:mensaje+="FIRA"	;				retorno=false; break;	
	case 51:mensaje+="INVERLAT";			retorno=false; break;	
	case 52:mensaje+="AMIGO";				retorno=false; break;	
	case 53:mensaje+="Autofin"	;			retorno=false; break;	
	case 54:mensaje+="Bcext"	;			retorno=false; break;	
	case 55:mensaje+="Banco"	;			retorno=false; break;	
	case 56:mensaje+="Deuno"	;			retorno=false; break;	
	case 57:mensaje+="Balza"	;			retorno=false; break;	
	case 58:mensaje+="Prude"	;			retorno=false; break;	
	case 59:mensaje+="Regio"	;			retorno=false; break;	
	case 60:mensaje+="Financier Rural"	;	retorno=false; break;	

	}

	if(retorno==false){
		mensajeSis(mensaje);
	}
	return retorno;
}




function limpiaEncabezado(){
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#cuentaAhorro').val('');
	$('#numCtaInstit').val('');
	$('#nombreSucurs').val('');
	$('#saldo').val('');

}



function validaGridVerificar(){
	var existenVacios = 0;		
	//cuenta cargo
	$('input[name=cuentaAhoID]').each(function() {		
		numero= this.id.substr(11,this.id.length);
		var jqCuentaAhoID = eval("'#" + this.id + "'");
		var jqCuentaContable = eval("'#cuentaCompletaID" + numero + "'");
		var cuenta = $(jqCuentaAhoID).val();	
		var ctaCompleta = $(jqCuentaContable).val();
		
		if( ( $.trim(cuenta) == '' && $.trim(ctaCompleta) == '') && existenVacios ==  0){
			mensajeSis('Elija una Cuenta');
			$(jqCuentaAhoID).focus();
			existenVacios=1;
		}
	});

	// Descripcion
	if(existenVacios ==  0) {
		$('input[name=descripcion]').each(function() {		
			var jqDescripcion = eval("'#" + this.id + "'");	
			var descripcion = $(jqDescripcion).val();	
			if($.trim(descripcion) == '' && existenVacios ==  0){
				mensajeSis('La descripción esta vacía.');
				$(jqDescripcion).focus();
				existenVacios=1;
				return;
			}			 
		});
	}

	// Referencia
	if(existenVacios ==  0) {
		$('input[name=referencia]').each(function() {		
			var jqReferencia = eval("'#" + this.id + "'");	
			var referencia = $(jqReferencia).val();	
			if($.trim(referencia) == '' && existenVacios ==  0){
				mensajeSis('La Referencia Está Vacía.');
				$(jqReferencia).focus();
				existenVacios=1;
				return;
			}			 
		});
	}	
	// Monto
	if(existenVacios ==  0) {
		$('input[name=monto]').each(function() {		
			var jqMonto = eval("'#" + this.id + "'");	
			var monto = $(jqMonto).val();	
			var montoNumer = $(jqMonto).asNumber();
			if($.trim(monto) == '' && existenVacios ==  0){
				mensajeSis('El Monto Está Vacío.');
				$(jqMonto).focus();
				existenVacios=1;
				return;
			}	
			else if(montoNumer <=0 && existenVacios ==  0){
				mensajeSis('El Monto debe ser Mayor a $0.00');
				$(jqMonto).focus();
				existenVacios=1;
				return;
			}
		});
	}
	//  Cta Clabe
	if(existenVacios ==  0) {
		$('input[name=cuentaClabe]').each(function() {		
				var jqCtaClave = eval("'#" + this.id + "'");	
			var cuentaClabe = $(jqCtaClave).val();	

				if($.trim(cuentaClabe) == '' && existenVacios ==  0){
					mensajeSis('La Cta Clabe, Número de Cheque, Tarjeta, Orden de Pago o Cta Cheques Esta Vacía.');
					$(jqCtaClave).focus();
					existenVacios=1;
					return;
				}

				if( isNaN(cuentaClabe)  && existenVacios ==  0){
					mensajeSis('La Cta Clabe, Número de Cheque, Tarjeta, Orden de Pago o Cta Cheques Acepta Solo Números.');
					$(jqCtaClave).focus();
					existenVacios=1;
					return;
				}
			 						 
		});
	}
	//  Nombre beneficiario si es spei
	if(existenVacios ==  0) {
		$('input[name=elimina]').each(function() {		
			var jqNombreBenefi = eval("'#nombreBenefi" + this.id + "'");	
			var jqFormaPago = eval("'#formaPago" + this.id + "'");
			var NombreBen = $(jqNombreBenefi).val();
			var formaPag = $(jqFormaPago).val();
			if($.trim(NombreBen) == '' && formaPag==1  && existenVacios ==  0){
				mensajeSis('El Nombre del Beneficiario Está Vacío.');
				$(jqNombreBenefi).focus();
				existenVacios=1;
				return;
			}			 
		});
	}		

	if(existenVacios ==  0) {
		$('input[name=tipoChequera]').each(function() {	
			var ID = this.id.substring(12);				
			var jqFormaPago = eval("'#formaPago" + ID + "'");
			var jsTipoChequera 	= eval("'#stipoChequera" + ID+ "'");
			var valorTipoChequera	= $(jsTipoChequera).val();
			formaPag = $(jqFormaPago).val();
			if($.trim(valorTipoChequera) == '' && formaPag ==2  && existenVacios ==  0){
				mensajeSis('El Formato Cheque Está Vacío.');
				$(jsTipoChequera).focus();
				existenVacios=1;					
				return;
			}
		});
	}
	
	return existenVacios;
}



function validaGridAutorizar(){		
	var existenVacios = 0;
		if(existenVacios ==  0) {
		$('input[name=descripcion]').each(function() {		
			var jqDescripcion = eval("'#" + this.id + "'");	
			var descripcion = $(jqDescripcion).val();	
			if($.trim(descripcion) == '' && existenVacios ==  0){
				mensajeSis('La Descripción Está Vacía.');
				$(jqDescripcion).focus();
				existenVacios=1;
				return;
			}			 
		});
	}
	if(existenVacios ==  0) {
		$('input[name=referencia]').each(function() {		
			var jqReferencia = eval("'#" + this.id + "'");	
			var referencia = $(jqReferencia).val();	
			if($.trim(referencia) == '' && existenVacios ==  0){
				mensajeSis('La Referencia Está Vacía.');
				$(jqReferencia).focus();
				existenVacios=1;
				return;
			}			 
		});
	}	
	if(existenVacios ==  0) {
		$('input[name=monto]').each(function() {		
			var jqMonto = eval("'#" + this.id + "'");	
			var monto = $(jqMonto).val();	
			 montoNumer = $(jqMonto).asNumber();
			if($.trim(monto) == '' && existenVacios ==  0){
				mensajeSis('El Monto Esta Vacío.');
				$(jqMonto).focus();
				existenVacios=1;
				return;
			}	
			else if(montoNumer <=0 && existenVacios ==  0){
				mensajeSis('El Monto debe ser Mayor a $0.00');
				$(jqMonto).focus();
				existenVacios=1;
				return;
			}
			
		});
	}
	
	
	//  Cta Clave
	if(existenVacios ==  0) {
		$('input[name=cuentaClabe]').each(function() {		
			numero= this.id.substr(11,this.id.length);
			var jqCtaClave = eval("'#" + this.id + "'");	
			var cuentaClabe = $(jqCtaClave).val();	
			var jqchekaut = eval("'#autorizaCheckHidden" + numero+ "'");	
			if( $(jqchekaut).val() == 'A'){
				if($.trim(cuentaClabe) == '' && existenVacios ==  0){
					mensajeSis('La Cta Clabe, Número de Cheque, Tarjeta, Orden de Pago o Cta Cheques Esta Vacía.');
					$(jqCtaClave).focus();
					existenVacios=1;
					controlFP = 0;
					return;
				}

				if( isNaN(cuentaClabe)  && existenVacios ==  0){
					mensajeSis('Solo Números.');
					$(jqCtaClave).focus();
					existenVacios=1;
					return;
				}
			}
			controlFP = 0;
		});
	}
	//  Nombre beneficiario si es spei
	if(existenVacios ==  0) {
		$('input[name=elimina]').each(function() {
			var ID = this.id.substring(7);
			var jqNombreBenefi = eval("'#nombreBenefi" + ID + "'");	
			var jqFormaPago = eval("'#formaPago" + ID + "'");
			var NombreBen = $(jqNombreBenefi).val();
			var formaPag = $(jqFormaPago).val();
			if($.trim(NombreBen) == '' && formaPag==1  && existenVacios ==  0){
				mensajeSis('El Nombre del Beneficiario Está Vacío.');
				$(jqNombreBenefi).focus();
				existenVacios=1;					
				return;
			}
			controlFP = 0; //forma de pago diferente de cheque
		});
	}
	
	//  Nombre beneficiario si es cheque
	if(existenVacios ==  0) {
			$('input[name=nombreBenefi]').each(function() {	
				var ID = this.id.substring(12);				
				var jqNomBeneficiario = eval("'#" + this.id + "'");	
				var jqFormaPago = eval("'#formaPago" + ID + "'");
				formaPag = $(jqFormaPago).val();
				nombreBene = $(jqNomBeneficiario).val();	

			if($.trim(nombreBene) == '' && formaPag==2  && existenVacios ==  0){
				mensajeSis('El Nombre del Beneficiario Está Vacío.');
				$(jqNomBeneficiario).focus();
				existenVacios=1;					
				return;
			}
			controlFP = 1; // forma de pago cheque
		});
	}


	if(existenVacios ==  0) {
			$('input[name=tipoChequera]').each(function() {	
				var ID = this.id.substring(12);				
				var jqFormaPago = eval("'#formaPago" + ID + "'");
				var jsTipoChequera 	= eval("'#stipoChequera" + ID+ "'");
				var valorTipoChequera	= $(jsTipoChequera).val();
				formaPag = $(jqFormaPago).val();	
			if($.trim(valorTipoChequera) == '' && formaPag ==2  && existenVacios ==  0){
				mensajeSis('El Formato Cheque Está Vacío.');
				$(jsTipoChequera).focus();
				existenVacios=1;					
				return;
			}

			controlFP = 1; // forma de pago cheque
		});
	}
	
	if(controlFP == 1){				
	validaCtaNostroChequera('cuentaAhorro','institucionID',ID);

	}

	return existenVacios;
}

function cicloConsultaCuentas(){ 	
	var existenTodas= true;
	$('input[name=elimina]').each(function() {		
		var jqCuentaAhoID = eval("'#cuentaAhoID" + this.id + "'");	
		var jqCliente = eval("'#nombreCte" + this.id + "'");
		var cuenta = $(jqCuentaAhoID).val();
		var numCta=($.trim(cuenta));
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta
		};
		if($.trim(numCta) != '' && !isNaN(numCta)  && (numCta.length <=12) ){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	

				}else{
					mensajeSis("No Existe la Cuenta de Ahorro");
					$(jqCuentaAhoID).focus();
					$(jqCuentaAhoID).val('');
					$(jqCliente).val('');
					existenTodas=false;
				}
			});															
		}
		if(isNaN(numCta)){
			mensajeSis("No Existe la Cuenta de Ahorro");

			$(jqCuentaAhoID).val('');
			$(jqCliente).val('');
			$(jqCuentaAhoID).focus();
			existenTodas=false;
		}


	});
	return existenTodas;
}

//Funcion para consultar parametro tabla PARAMGENERALES
function consultaParametro(){
	var tipoConsulta = 1;
		paramGeneralesServicio.consulta(tipoConsulta, function(valor){
			if(valor!=null){							
				if (valor.valorParametro=="S"){
						habilitaControl('fechaActual');
						$('.ui-datepicker-trigger').show();
						fechaSI="S";
				}else{
					deshabilitaControl('fechaActual');
					$('.ui-datepicker-trigger').hide();
					fechaSI="N";
				}
			}else{
				deshabilitaControl('fechaActual');
				$('.ui-datepicker-trigger').hide();
				fechaSI="N";
			}
});

}




});// Fin del Document Ready

function limpiaTablaVerifica(){

var tabla = ' <table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">';
tabla += ' <tbody>';	
tabla += ' <tr align="center">	<td class="label"> 	<label for="lblNumero">N&uacute;mero</label> </td>';
tabla += ' <td class="label"> 	<label for="lblCuenta">Cuenta Cargo</label>  </td>';  
tabla += ' <td class="label"> 	<label for="lblClienteID">Nombre Cliente</label></td>';
tabla += ' <td class="label"> 	<label for="lblNombreCte">Cuenta Contable</label> </td>';
tabla += ' <td class="label"> 	<label for="lblNombreCte">Descripci&oacute;n</label> </td>'; 
tabla += ' <td class="label"> 	<label for="lblReferencia">Referencia</label></td>';    
tabla += ' <td class="label"> 	<label for="lblTipoMov">Forma Pago</label> 	</td> ';
tabla += ' <td class="label">	<label for="lblTipoChequera">Formato <br>Cheque</label></td> ';
tabla += ' <td class="label">	<label for="lblMonto">Monto</label> </td>';
tabla += ' <td class="label"> 	<label for="lblClabe">Cuenta CLABE<br> Núm. de Cheque <br> Núm. Tarjeta/Cta Cheques <br>Ref. Orden Pago</label>  	</td> ';
tabla += ' <td class="label"> 	<label for="lblNombreBen">Nombre del<br>Beneficiario</label> 	</td> ';
tabla += ' <td class="label"> 	<label for="lblRFC">RFC</label>	</td>';     	
tabla += ' <td class="label" nowrap="nowrap"> 	<label for="lblVacio"></label>	</td> ';
tabla += ' </tr></tbody>';
tabla += ' </table>';
tabla += ' <input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />';

$('#tableCon').replaceWith(tabla);		


}

function limpiaTablaAutoriza(){

var tabla = '<div id="tablaAutoriza">';	
tabla += ' <table id="miTablaAutoriza" border="0" cellpadding="0" cellspacing="0" width="100%">';
tabla += ' <tbody>';	
tabla += ' <tr align="center">	<td class="label"> 	<label for="lblNumero"></label> </td>';
tabla += ' <td class="label"> 	<label for="lblCuenta">Cuenta Cargo</label>  </td>';  
tabla += ' <td class="label"> 	<label for="lblClienteID">Nombre Cliente</label></td>';
tabla += ' <td class="label"> 	<label for="lblNombreCte">Descripci&oacute;n</label> </td>'; 
tabla += ' <td class="label"> 	<label for="lblReferencia">Referencia</label></td>';    
tabla += ' <td class="label"> 	<label for="lblTipoMov">Forma Pago</label> 	</td> ';
tabla += ' <td class="label"> 	<label for="lblConcepDisp">Concepto Dispersi&oacute;n</label> 	</td> ';
tabla += ' <td class="label">	<label for="lblTipoChequera">Formato <br>Cheque</label></td> ';
tabla += ' <td class="label">	<label for="lblMonto">Monto</label> </td>';
tabla += ' <td class="label"> 	<label for="lblClabe">Cuenta CLABE<br> Núm. de Cheque <br> Núm. Tarjeta/Cta Cheques <br>Ref. Orden Pago</label>  	</td> ';
tabla += ' <td class="label"> 	<label for="lblNombreBen">Nombre del<br>Beneficiario</label> 	</td> ';
tabla += ' <td class="label" align="left"><label for="lblFfechaEnvio">Fecha de<br>Envio</label></td>';
tabla += ' <td class="label"> 	<label for="lblRFC">RFC</label>	</td>';     	
tabla += ' <td class="label"> 	<label for="lblEstatus">Autorizar</label> </td> ';
tabla += ' </tr></tbody>';
tabla += ' </table>';
tabla += ' <input type="hidden" value="0" name="numeroDetalleAuto" id="numeroDetalleAuto" />';
tabla += ' </div>';

$('#tablaAutoriza').replaceWith(tabla);

}




/******************************************
* 
* FIN DE   $(document).ready
* BAJO DE ESTE COMENTARIO EMPIEZAN LAS FUNCIONES NATIVAS
* DE JAVASCRIPT. FUNCIONES DENTRO DE LOS INPUTS DEL GRID
*/


function obtenerCuenta(idControl){	

var camposLista = new Array();
var parametrosLista = new Array();

camposLista[0] = "clienteID";
parametrosLista[0] = document.getElementById(idControl).value;

if(document.getElementById(idControl).value != ""){
	listaAlfanumerica(idControl, '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
}
}

function obtenCtaContable(idControl){
var cuenta  = eval("'#" + idControl + "'");	 
var camposLista = new Array();
var parametrosLista = new Array();			
camposLista[0] = "descripcion"; 
parametrosLista[0] = $(cuenta).val();
listaAlfanumerica(idControl, '1', '5', camposLista, parametrosLista, 'listaCuentasContables.htm');

}


function maestroCuentasDescripcion(cuentaCargo, nombreCte, cliente, saldo, beneficiario,nuevaFila){

cuentaCargo = eval("'#" +cuentaCargo + "'");
nombreCte =eval("'#" +nombreCte + "'");
cliente = eval("'#"+cliente + "'");
saldo = eval("'#" +saldo+ i + "'");

setTimeout("$('#cajaLista').hide();", 200);
var numCta = $(cuentaCargo).val();
var jqMonto		 	= eval("'#monto" + nuevaFila + "'");	
var jqCuentaCntable	= eval("'#cuentaCompletaID" + nuevaFila + "'");
var jqDescCtaContab	= eval("'#descriCtaCompleta" + nuevaFila + "'");
var monto = 0;
var tipConCampos= 4;
var CuentaAhoBeanCon = {
		'cuentaAhoID'	:numCta
};

if($.trim(numCta) != '' && !isNaN(numCta)  && (numCta.length <=12) ){

	//limpia la cuenta contable
	$(jqCuentaCntable).val('');
	$(jqDescCtaContab).val('');

	cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
		if(cuenta!=null){			
			$(cliente).val(cuenta.clienteID);			
			$(cuentaCargo).val(cuenta.cuentaAhoID);		
			consultaClientePantalla(cuenta.clienteID, nombreCte, beneficiario);
			consultaCtaAho(cuentaCargo, cuenta.clienteID, saldo,jqMonto);

		}else{
			mensajeSis("No Existe la Cuenta de Ahorro");
			$(cuentaCargo).focus();
			$(cuentaCargo).val('');
			$(nombreCte).val('');
		}
	});															
}
}



function validaCuentaContable(idControl,idDescrip, nuevaFila) { 
var jqCtaContable = eval("'#" + idControl + "'");
var jqDescrContable = eval("'#" + idDescrip + "'");
var jqCuentaCliente	= eval("'#cuentaAhoID" + nuevaFila + "'");
var jqDescCtaCliente	= eval("'#nombreCte" + nuevaFila + "'");

var numCtaContable = $(jqCtaContable).val();
var conPrincipal = 1;
var CtaContableBeanCon = {
		'cuentaCompleta':numCtaContable
};

setTimeout("$('#cajaLista').hide();", 200);
if( $.trim(numCtaContable) != '' && !isNaN(numCtaContable)){
	//limpia la cuenta contable
	$(jqCuentaCliente).val('');
	$(jqDescCtaCliente).val('');

	cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
		if(ctaConta!=null){
			if(ctaConta.grupo != "E"){
				$(jqDescrContable).val(ctaConta.descripcion);
			}else{
				mensajeSis("Sólo Cuentas Contables De Detalle");
				$(jqCtaContable).val("");
				$(jqCtaContable).focus();
				$(jqDescrContable).val("");
			}
		}
		else{
			mensajeSis("No Existe la Cuenta Contable.");
			$(jqCtaContable).val("");
			$(jqCtaContable).focus();
			$(jqDescrContable).val("");
			
		}
	}); 
}  
}



function consultaClientePantalla(numCliente, fila, beneficiario) {
var conCliente =5;
var rfc = ' ';
if(numCliente != '' && !isNaN(numCliente) ){
	clienteServicio.consulta(conCliente, numCliente, rfc, function(cliente){
		if(cliente!=null){		
			var tipo = (cliente.tipoPersona);
			if(tipo=="M"){
				$(fila).val(cliente.razonSocial);
			}else{
				$(fila).val(cliente.nombreCompleto);
			}	
			
		}else{
			mensajeSis("No Existe el Cliente");
		}    						
	});
}
}

function consultaCtaAho(cuenta, clienteID, saldo,jqMonto) {
setTimeout("$('#cajaLista').hide();", 200);
var numCta = $(cuenta).val();
var catTipoConsultaCuentas = 5;
var monto=0;
var saldoDispon=0;
var CuentaAhoBeanCon = {
		'cuentaAhoID': numCta,
		'clienteID': clienteID
};
if(numCta != '' && !isNaN(numCta)  ){
	cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas, CuentaAhoBeanCon, function(cuenta) {
		if(cuenta.saldoDispon!=null){
			$(saldo).val(cuenta.saldoDispon);
			if ( $(jqMonto).val()!=''){
				monto = $(jqMonto).asNumber();
				saldoDispon = $(saldo).val();

				if(monto > saldoDispon ){
					if(saldoDispon <=0){
						mensajeSis("La Cuenta Cargo No Tiene Saldo.");
					}else{
						mensajeSis("El Monto es Superior al Disponible: "+$(saldo).val());
					}
					$(jqMonto).val('0.00');
				}
			}
		}else{
			mensajeSis("La Cuenta no Existe");
		}
	});                                                                                                                        
}
}	

function validarMonto(idControl, saldo, numeroFila){
recalculaTotal();// en operDispersionGrid
var iqCtaAhoID  =  eval("'#cuentaAhoID" + numeroFila + "'");
var jqCtaContable =  eval("'#cuentaCompletaID" + numeroFila + "'");
var cuentaAho = $(iqCtaAhoID).val();
var cuentaContable = $(jqCtaContable).val();
if($.trim(cuentaAho)!='') {
	var monto = convierteStrInt(document.getElementById(idControl).value);
	var saldoDisponible = convierteStrInt(document.getElementById(saldo).value);
	if(monto !=''){
		if(monto > saldoDisponible){
			if(saldoDisponible <=0){
				mensajeSis("La Cuenta Cargo No Tiene Saldo.");
			}else{
				mensajeSis("El Monto es Superior al Disponible: "+document.getElementById(saldo).value);
			}
			document.getElementById(idControl).focus();
			document.getElementById(idControl).value="0.00";
		}
	}
}
}  

function validaSpei(idControl, cuentaClabe,stipoChequera){
var esSpei = document.getElementById(idControl).value;
var numero = document.getElementById(cuentaClabe).value;
var actualChequera = document.getElementById(stipoChequera).value;
if(esSpei == '1' && numero != ''){
	if(numero.length == 18 && numero != ''){
		if(!isNaN(numero)){
			var institucion= numero.substr(0,3);
			var tipoConsulta = 3;
			var DispersionBean = {
					'institucionID': institucion
			};

			institucionesServicio.consultaInstitucion(tipoConsulta, DispersionBean, function(data){
				if(data==null){
					mensajeSis('La Cuenta Clabe no Coincide con Ninguna Institución Financiera Registrada');
					document.getElementById(cuentaClabe).focus();
				}
			});
		}
	}else{
		mensajeSis("La Cuenta Clabe Debe de Tener 18 Caracteres");
		document.getElementById(cuentaClabe).value="";
		document.getElementById(cuentaClabe).focus();
	}
}else{
	
	$('input[name=cuentaClabe]').each(function() {	
		var ID = this.id.substring(11);				
		var jqFormaPago = eval("'#formaPago" + ID + "'");
		var jqCuentaClabe = eval("'#cuentaClabe" + ID + "'");
		var jqCuentaCla = eval("'#" + cuentaClabe + "'");

		var jqTipoChequera = eval("'#stipoChequera" + ID + "'");

		formaPag = $(jqFormaPago).val();
		valcuentaClabe = $(jqCuentaClabe).val();
		valTipChequera = $(jqTipoChequera).val();
	if(formaPag==2 && valcuentaClabe == numero && cuentaClabe != "cuentaClabe" + ID  && actualChequera==valTipChequera ){
		mensajeSis('El Número de Cheque está Repetido.');
		$(jqCuentaCla).focus();
		existenVacios=1;
	}else{
		existenVacios=0;
	}
	return existenVacios;
});
}
return false;
}

function validaTar(idControl, cuentaClabe){
var esSpei = document.getElementById(idControl).value;
var numero = document.getElementById(cuentaClabe).value;
if(esSpei == '4' && numero != ''){
	if(numero.length != 16 && numero != ''){
		mensajeSis("El Número de Tarjeta Debe Ser de 16 Caracteres");
		document.getElementById(cuentaClabe).value="";
		document.getElementById(cuentaClabe).focus();
	}
	
}
return false;
}


function verificaSeleccionado(idCampo,nuevaFila){
var nuevaFrecuencia=$('#'+idCampo).val();
var monto=eval("'monto" + nuevaFila + "'");
var montos=$('#'+monto).asNumber();
$('tr[name=renglon]').each(function() {
	var numero= this.id.substr(10,this.id.length);
	var jqIdFrecuencias = eval("'cuentaAhoID" + numero+ "'");
	var montoT=eval("'monto" + numero + "'");
	var montoTotal=$('#'+montoT).asNumber();
	var valorFrecuencias=$('#'+jqIdFrecuencias).val();
	if(jqIdFrecuencias != idCampo && montoT!= monto){
		if(valorFrecuencias == nuevaFrecuencia && montoTotal==montos){
			if($('#'+idCampo).val()!=''){
				mensajeSis("Imposible Dispersar el Movimiento, ya Existe un Movimiento con la misma Cuenta y el mismo Monto");
			$('#'+monto).focus();
			$('#'+monto).select();
			$('#'+monto).val('');
			}
		}
	}
});

}

function convierteStrInt(cadena){
var re = /,/g;
var cantidad  = cadena.replace(re, "");
return  parseFloat(cantidad);
} 

varEsCheque = 'N';
var botonProtec=false;
function funcionExitoDisper(){
consultaParametro();
varEsCheque = 'N';
if(	$('#tipoTransaccion').val() == 3){
	var valorFPago;
	var ordPago;
	numeroPoliza = $('#campoGenerico').val(); // se obtiene el numero de poliza generado en el proceso		
	if(numeroPoliza > 0){	
	$('#impPoliza').show();	
	$('#imprimeCheque').show();	
	habilitaBoton('impPoliza', 'submit');
	habilitaBoton('imprimeCheque', 'submit');
	$('#enlace').attr('href');		
		
	}
	
	var totalfilas =  $('input[name=consecutivoIDA]').length;			
		if(totalfilas > 0){ 
 		for(var i = 1; i <= totalfilas; i++){
 			 var fPago =eval("'#labelSpei"+i+ "'"); //requisicion de pago de servicios
 			 valorFPago = $(fPago).val(); 		
 			 var ordenPago = eval("'#labelOrdenPago"+i+"'"); // requisicion de gastos anticipos
 			 ordPago =$(ordenPago).val(); 	
 			 var autCheque = eval("'#autorizaCheckHidden"+i+"'");	
 			if(requisicion == 1 && ordPago == 'CHEQUE' && $(autCheque).val() =="A"){
				$('#imprimeCheque').show();	
				varEsCheque = 'S';
 			}
 			
 			var formaPago =eval("'#formaPagoA"+i+ "'"); //requisicion de pago de servicios
 			var valorFormaPago = $(formaPago).val();
 			if ($(autCheque).val() =="A" && valorFormaPago=='5') {
 				botonProtec=true;
 			}
 			 		
 		}
 		if(varEsCheque == "S"){
 			$('#imprimeCheque').show();	
			}else{	 	 			
				$('#imprimeCheque').hide();	
				varEsCheque = 'N';
			}
			if(botonProtec && $('#protecOrdenPago').val()=='S' && $('#institucionID').val()=='37'){
			$('#reimprimeOrdenPago').show();
			$('#protecOrdenPagoB').show();
			imprimeOrdenPago();
		}else if(botonProtec && $('#institucionID').val()=='37'){
			$('#protecOrdenPagoB').hide();
			$('#reimprimeOrdenPago').show();
		}else {
			$('#reimprimeOrdenPago').hide();
			$('#protecOrdenPagoB').hide();
		}
		$('#folioOperacion').blur();
		}
}else {

		$('#imprimeCheque').hide();	
		$('#impPoliza').hide();
		varEsCheque = 'N';
	
}

$('#tablaExporta').html('');
deshabilitaBoton('grabar', 'submit');
deshabilitaBoton('modificar', 'submit');
deshabilitaBoton('autorizaBoton', 'submit');
limpiaTablaVerifica();
$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});

$("'#cuentaClabeA").each(function(){		
	var i = this.id.substring(12);
	$("'#cuentaClabeA"+i).attr("readonly",true);
});


}




function funcionFalloDisper(){
consultaParametro();

}

// Funcion que valida si la institucion maneja chequera  dispersiones manuales
function validaCtaNostroChequera(numCta,institID,fila){
	 jqInstitucionID = eval("'#" + institID + "'");
	 jqNumCtaInstit = eval("'#" + numCta + "'");
	 institucionID = $(jqInstitucionID).val();
	 numCtaInstit = $(jqNumCtaInstit).val();
	 var CtaNostroBeanCon = {
			'institucionID':institucionID,
			'numCtaInstit':numCtaInstit
	};  		
	setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaInstit != '' && !isNaN(numCtaInstit)){				
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, { async: false, callback:function(ctaNostro){
				if(ctaNostro!=null){ 					
					if(ctaNostro.chequera == 'S'){								
						$('#manejaChequera').val('S');
						cargarTipoChequera(numCta,institID);
			  
					}else{
						
						$('#manejaChequera').val('N');
					}  
					
				}
			}});
	}
}

//Funcion que valida folio por tipo de chequera
function validafolioChequera(numCta,institID,fila){
	 jqInstitucionID = eval("'#" + institID + "'");
	 jqNumCtaInstit = eval("'#" + numCta + "'");
	 institucionID = $(jqInstitucionID).val();
	 numCtaInstit = $(jqNumCtaInstit).val();
	 var tipoChequera= $('#stipoChequera'+fila+' option:selected').val();
	 var CtaNostroBeanCon = {
			'institucionID':institucionID,
			'numCtaInstit':numCtaInstit
	};  		
	setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaInstit != '' && !isNaN(numCtaInstit)){				
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, { async: false, callback:function(ctaNostro){
				if(ctaNostro!=null){ 
					cargarTipoChequera(numCta,institID);
					if(tipoChequera == 'P'){
						if(ctaNostro.folioUtilizar != null && ctaNostro.folioUtilizar != ''){					
							numChequeUsar = parseInt(ctaNostro.folioUtilizar);
							}
							else{								
								numChequeUsar ='';
							}
							if(ctaNostro.rutaCheque == '' && ctaNostro.rutaCheque == null){
								nombreRutaCheque = '';							
							}else{					
								rutaCheque = ctaNostro.rutaCheque;							
								rutaUsar = rutaCheque.split(".");
								nombreRutaCheque =rutaUsar[0];	
							}		
				    		validaCtaNostroFolioEmiPro('cuentaAhorro','institucionID',fila);
							validaCtaNostroFolioEmiProA('cuentaAhorro','institucionID',fila);
				    		

					}else if(tipoChequera == 'E'){
						if(ctaNostro.folioUtilizarEstan != null && ctaNostro.folioUtilizarEstan != ''){					
							numChequeUsarEstan = parseInt(ctaNostro.folioUtilizarEstan);
							}
							else{								
								numChequeUsarEstan ='';
							}
							if(ctaNostro.rutaChequeEstan == '' && ctaNostro.rutaChequeEstan == null){
								nombreRutaCheque = '';							
							}else{					
								rutaCheque = ctaNostro.rutaChequeEstan;							
								rutaUsar = rutaCheque.split(".");
								nombreRutaCheque =rutaUsar[0];	
							}		
				    		validaCtaNostroFolioEmiEstan('cuentaAhorro','institucionID',fila);
				    		validaCtaNostroFolioEmiEstanA('cuentaAhorro','institucionID',fila);

					}
												  
					return numChequeUsar;
					return numChequeUsarEstan;
				}
			}});
	}
}
	
// Funcion que obtiene numero de cheque emitido proforma
	function validaCtaNostroFolioEmiPro(numCta,institID,ID){
		 jqInstitucionID = eval("'#" + institID + "'");
		 jqNumCtaInstit = eval("'#" + numCta + "'");   		
		 var numCheque =eval("'#cuentaClabe"+ID+ "'"); 
		 var tipoChequera= $('#stipoChequera'+ID+' option:selected').val();
     var valorNueCheque = 0;
 	 var ordenPago = eval("'#formaPago"+ID+"'"); 
	   	 ordPago   =$(ordenPago).val(); 

		if( ordPago == 2){
			 $(numCheque).val(0);
		}
		var numeroMaximoChe = numeroMaximoChequePro(tipoChequera);

		 institucionID = $(jqInstitucionID).val();
		 numCtaInstit = $(jqNumCtaInstit).val();
		 CtaNostroBeanCon = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit, 
				'tipoChequera':tipoChequera
		};  		
	setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaInstit != '' && !isNaN(numCtaInstit)&& $('#manejaChequera').val() == 'S'){
			cuentaNostroServicio.consulta(catTipoConsultaCtaNostro.folio,CtaNostroBeanCon,{ async: false, callback:function(ctaNostro){  
				if(ctaNostro!=null){												
					mensajeSis('El Folio ya fue Emitido');						
					}else{   						
						if(numChequeUsar == '' || numChequeUsar == null || numChequeUsar == "0"){  						
							 $(numCheque).val('');
						}else{ 	
  						 if( numeroMaximoChe == 0){
  								valorNueCheque = numChequeUsar+1;
  							}else{
  								if($(numCheque).asNumber() == numeroMaximoChe ) {
									   valorNueCheque = numeroMaximoChe;
									}else{
										valorNueCheque = numeroMaximoChe + 1;
									}
  								
  							}
  						 $(numCheque).val(valorNueCheque);  						
  						} 						
						}
					}
			});
		}
	}
	

// Funcion que obtiene numero de cheque emitido estandar
 	function validaCtaNostroFolioEmiEstan(numCta,institID,ID){
 		 jqInstitucionID = eval("'#" + institID + "'");
  		 jqNumCtaInstit = eval("'#" + numCta + "'");   		
 		 var numCheque =eval("'#cuentaClabe"+ID+ "'");  
 		 var tipoChequera= $('#stipoChequera'+ID+' option:selected').val();
 		 var valorNueCheque = 0;
 		 
     	 var ordenPago = eval("'#formaPago"+ID+"'"); 
	   	 ordPago   =$(ordenPago).val(); 

		if( ordPago == 2){
	 		 $(numCheque).val(0);
		}
		
		


			 var numeroMaximoChe = numeroMaximoChequePro(tipoChequera);
  		
  		 institucionID = $(jqInstitucionID).val();
  		 numCtaInstit = $(jqNumCtaInstit).val();
  		 CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit, 
  				'tipoChequera':tipoChequera
  		};  		

		setTimeout("$('#cajaLista').hide();", 200);		
			if(numCtaInstit != '' && !isNaN(numCtaInstit)&& $('#manejaChequera').val() == 'S'){
				cuentaNostroServicio.consulta(catTipoConsultaCtaNostro.folio,CtaNostroBeanCon,{ async: false, callback:function(ctaNostro){  			
					if(ctaNostro!=null){												
						mensajeSis('El Folio ya fue Emitido');						
  					}else{   
  						if(numChequeUsarEstan == '' || numChequeUsarEstan == null || numChequeUsarEstan == "0"){  						
  							 $(numCheque).val('');
  						}else{
	  						 if( numeroMaximoChe == 0){
  								valorNueCheque = numChequeUsarEstan+1;
  							}else{
  								if($(numCheque).asNumber() == numeroMaximoChe ) {
									   valorNueCheque = numeroMaximoChe;
									}else{
										valorNueCheque = numeroMaximoChe + 1;
									}
  								
  							}
	  						 $(numCheque).val(valorNueCheque);  						
	  						} 						
  						}
  					}
				});
			}
  	}

	

// Funcion que obtiene numero de cheque emitido proforma
	function validaCtaNostroFolioEmiProA(numCta,institID,ID){
		 jqInstitucionID = eval("'#" + institID + "'");
		 jqNumCtaInstit = eval("'#" + numCta + "'");   		
		 var numCheque =eval("'#cuentaClabeA"+ID+ "'"); 
		 var tipoChequera= $('#stipoChequera'+ID+' option:selected').val();
		 var valorNueCheque = 0;

 	 var ordenPago = eval("'#formaPagoA"+ID+"'"); 
   	 ordPago   =$(ordenPago).val(); 
   	 
	if( ordPago == 2){
 		 $(numCheque).val(0);
	}

		var numeroMaximoChe = numeroMaximoCheque(tipoChequera);
		 
		 institucionID = $(jqInstitucionID).val();
		 numCtaInstit = $(jqNumCtaInstit).val();
		 
		 CtaNostroBeanCon = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit, 
				'tipoChequera':tipoChequera
		};

	setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaInstit != '' && !isNaN(numCtaInstit)){
			cuentaNostroServicio.consulta(catTipoConsultaCtaNostro.folio,CtaNostroBeanCon,{ async: false, callback: function(ctaNostro){  	
				if(ctaNostro!=null){												
					mensajeSis('El Folio ya fue Emitido');						
					}else{   						
						if(numChequeUsar == '' || numChequeUsar == null || numChequeUsar == "0"){  						
							 $(numCheque).val('');
						}else{ 	
							if( numeroMaximoChe == 0){
								valorNueCheque = numChequeUsar+1;
							}else{
								if($(numCheque).asNumber() == numeroMaximoChe ) {
								   valorNueCheque = numeroMaximoChe;
								}else{
									valorNueCheque = numeroMaximoChe + 1;
								}
								
							}
						 $(numCheque).val(valorNueCheque);  						
						}
					}
			}});
		}
	}
	

// Funcion que obtiene numero de cheque emitido estandar
 	function validaCtaNostroFolioEmiEstanA(numCta,institID,ID){
 		 jqInstitucionID = eval("'#" + institID + "'");
  		 jqNumCtaInstit = eval("'#" + numCta + "'");   		
 		 var numCheque =eval("'#cuentaClabeA"+ID+ "'");  
 		 var tipoChequera= $('#stipoChequera'+ID+' option:selected').val();
 		 var valorNueCheque = 0;

     	 var ordenPago = eval("'#formaPagoA"+ID+"'"); 
	   	 ordPago   =$(ordenPago).val(); 

		if( ordPago == 2){
	 		 $(numCheque).val(0);
		}

			 var numeroMaximoChe = numeroMaximoCheque(tipoChequera);

  		 institucionID = $(jqInstitucionID).val();
  		 numCtaInstit = $(jqNumCtaInstit).val();
  		 CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit, 
  				'tipoChequera':tipoChequera
  		};  		

		setTimeout("$('#cajaLista').hide();", 200);		
			if(numCtaInstit != '' && !isNaN(numCtaInstit)){
				cuentaNostroServicio.consulta(catTipoConsultaCtaNostro.folio,CtaNostroBeanCon,{ async: false, callback: function(ctaNostro){  			
					if(ctaNostro!=null){												
						mensajeSis('El Folio ya fue Emitido');						
  					}else{   			
  						if(numChequeUsarEstan == '' || numChequeUsarEstan == null || numChequeUsarEstan == "0"){  						
  							 $(numCheque).val('');
  						}else{
		  						if( numeroMaximoChe == 0){
	  								valorNueCheque = numChequeUsarEstan+1;
	  							}else{
	  								if($(numCheque).asNumber() == numeroMaximoChe ) {
										   valorNueCheque = numeroMaximoChe;
										}else{
											valorNueCheque = numeroMaximoChe + 1;
										}
	  								
	  							}
	  						 $(numCheque).val(valorNueCheque);  						
	  						} 						
  						}
  					}
				});
			}
  	}
	


function numeroMaximoCheque(tipoChequera){
var numMaximoCheque = 0;

	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var valorChequera= $('#stipoChequera'+numero+' option:selected').val();
		var numChequeAnt= eval("'#cuentaClabeA"+numero+ "'"); 
		var ordenPago = eval("'#formaPagoA"+numero+"'"); 
 			ordPago =$(ordenPago).val(); 
	if( ordPago == 2){
		if(valorChequera == tipoChequera){
			if(numMaximoCheque < $(numChequeAnt).asNumber()){
				numMaximoCheque = $(numChequeAnt).asNumber();
			}
		}
	}

	});
	return numMaximoCheque;
}



function numeroMaximoChequePro(tipoChequera){
var numMaximoCheque = 0;

	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var valorChequera= $('#stipoChequera'+numero+' option:selected').val();
		var numChequeAnt= eval("'#cuentaClabe"+numero+ "'"); 
		var ordenPago = eval("'#formaPago"+numero+"'"); 
 			ordPago =$(ordenPago).val(); 

	if( ordPago == 2){
		if(valorChequera == tipoChequera){
			if(numMaximoCheque < $(numChequeAnt).asNumber()){
				numMaximoCheque = $(numChequeAnt).asNumber();
			}
		}
	}

	});
	return numMaximoCheque;
}

// INICIO SECCIÓN PARA IMPRIMER ORDEN DE PAGO
function imprimeOrdenPago(){
		var sesion = consultaParametrosSession();
		var nombreUsuario = sesion.claveUsuario;

		$('input[name=consecutivoIDA]').each(function(){
		  	var i = this.id.substring(14);
		  	
		  	var jqAutorizaCheck = eval("'#autorizaCheck" + i + "'");			
		var jqOrdenPago = eval("'#formaPagoA" + i + "'");
		
		var jqNombreBenefi = eval("'#nombreBenefiA" + i + "'");			
		var jqMonto	= eval("'#montoA"+ i + "'");
		
		var jqcuentaClabeA = eval("'#cuentaClabeA" + i + "'");

		var jqReferencia = eval("'#referenciaA" + i + "'");
		var jqFechaEnvio = eval("'#fechaEnvioA" + i + "'");
				
		var montoC = $(jqMonto).val();
			montoC=montoC.replace(/,/g,"");
			

		
		if($(jqOrdenPago).val()=='5' && $(jqAutorizaCheck).is(":checked") ){
			var enlaceOrdenPagRep =	'RepDispOrdenPagPDF.htm?fechaEmision='+fechaEmision+'&nombreOperacion='+
						nombreOperacion+'&nombreBeneficiario='+$(jqNombreBenefi).val()+'&monto='+montoC+'&referencia='+$(jqReferencia).val()+'&folioOperacion='+$('#folioOperacion').val()+'&institucionID='+$('#institucionID').val()+'&cuentaAhorro='+$('#cuentaAhorro').val()+'&cuentaClabe='+$(jqcuentaClabeA).val()+'&fechaEnvio='+$(jqFechaEnvio).val();
	 			window.open(enlaceOrdenPagRep);
		}
		$('#reimprimeOrdenPago').show();
	  	}); 
}

// FIN SECCIÓN PARA IMPRIMIR ODEN DE PAGO




 function imprimeCheques(){
		var sesion = consultaParametrosSession();
		var nombreUsuario = sesion.claveUsuario;
		var nombreRutaChequeFin = '';
		$('input[name=consecutivoIDA]').each(function(){
		  var i = this.id.substring(14);
		  
		  	var jqAutorizaCheck = eval("'#autorizaCheck" + i + "'");			
		var jqOrdenPago = eval("'#formaPagoA" + i + "'");
		
		var jqNombreBenefi = eval("'#nombreBenefiA" + i + "'");			
		var jqMonto	= eval("'#montoA"+ i + "'");
		
		var jqcuentaClabeA = eval("'#cuentaClabeA" + i + "'");
		
				
		var montoC = $(jqMonto).val();
			montoC=montoC.replace(/,/g,"");
			

			var jqtipoChequeraA = eval("'#tipoChequera" + i + "'");
			
			if ($(jqtipoChequeraA).val() == 'P'){
				nombreRutaChequeFin = nombreRutaCheque;
			}else if($(jqtipoChequeraA).val() == 'E'){
				nombreRutaChequeFin = nombreRutaChequeEstan;
				
			}
		
		if($(jqOrdenPago).val()=='2' && $(jqAutorizaCheck).is(":checked") ){
		var enlace =	'imprimeChequeDispersion.htm?polizaID='+numeroPoliza+'&nombreReporte='+nombreRutaChequeFin+'&numeroTransaccion='+numTran+
						'&sucursalID='+numSucursal+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+'&nombreOperacion='+
						nombreOperacion+'&nombreBeneficiario='+$(jqNombreBenefi).val()+'&monto='+montoC+'&nombreUsuario='+nombreUsuario+
						'&numeroCheque='+$(jqcuentaClabeA).val();
	 window.open(enlace);
				
		}
		$('#imprimeCheque').hide(); 
		$('#reimprimirCheque').show();
	  }); 
		
		
	}
	
	function reImprimeCheques(){ 	
		var sesion = consultaParametrosSession();
		var nombreUsuario = sesion.claveUsuario;
		var nombreRutaChequeFin = '';
		$('input[name=consecutivoIDA]').each(function(){
		  var i = this.id.substring(14);
		  	var jqAutorizaCheck = eval("'#autorizaCheck" + i + "'");			
		var jqOrdenPago = eval("'#formaPagoA" + i + "'");
		
		var jqNombreBenefi = eval("'#nombreBenefiA" + i + "'");			
		var jqMonto	= eval("'#montoA"+ i + "'");
		
		var jqcuentaClabeA = eval("'#cuentaClabeA" + i + "'");					
		var montoC = $(jqMonto).val();
			montoC=montoC.replace(/,/g,"");

			var jqtipoChequeraA = eval("'#tipoChequera" + i + "'");
			
			if ($(jqtipoChequeraA).val() == 'P'){
				nombreRutaChequeFin = nombreRutaCheque;
			}else if($(jqtipoChequeraA).val() == 'E'){
				nombreRutaChequeFin = nombreRutaChequeEstan;
				
			}
		
		if($(jqOrdenPago).val()=='2' && $(jqAutorizaCheck).is(":checked") ){
		var enlace =	'imprimeChequeDispersion.htm?polizaID='+numeroPoliza+'&nombreReporte='+nombreRutaChequeFin+'&numeroTransaccion='+numTran+
						'&sucursalID='+numSucursal+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+'&nombreOperacion='+
						nombreOperacion+'&nombreBeneficiario='+$(jqNombreBenefi).val()+'&monto='+montoC+'&nombreUsuario='+nombreUsuario+
						'&numeroCheque='+$(jqcuentaClabeA).val();
	 window.open(enlace);
				
		}
		$('#imprimeCheque').hide(); 
	  }); 
		
		
	}
	
	function borraPartidasVerifica(){
		$('input[name=consecutivoID]').each(function(){
			
			var ID = this.id.substring(13);
			
			var jqTr = eval("'#renglon" + ID + "'");
			
			var jqConsecutivoID = eval("'#consecutivoID" + ID + "'");
			var jqTipoMov = eval("'#tipoMov" + ID + "'");	
			var jqClaveDispMov = eval("'#claveDispMov" + ID + "'");	
			var jqCuentaAhoID = eval("'#cuentaAhoID" + ID + "'");	
			var jqSaldo = eval("'#saldo" + ID + "'");	
			var jqNombreCte = eval("'#nombreCte" + ID + "'");
			var jqClienteID = eval("'#clienteID" + ID + "'");
			var jqDescripcion = eval("'#descripcion" + ID + "'");
			var jqReferencia = eval("'#referencia" + ID + "'");
			var jqFormaPago = eval("'#formaPago" + ID + "'");
			var jqTipoChequera= eval("'#stipoChequera" + ID + "'");
			var jqTipoCheque= eval("'#tipoChequera" + ID + "'");
			var jqMonto = eval("'#monto" + ID + "'");
			var jqCuentaClabe = eval("'#cuentaClabe" + ID + "'");
			var jqNombreBenefi = eval("'#nombreBenefi" + ID + "'");
			var jqTrrenglonCta = eval("'#renglonCta" + ID + "'");
			var jqdescriCtaCompleta= eval("'#descriCtaCompleta" + ID + "'");
			var jqcuentaCompletaID= eval("'#cuentaCompletaID" + ID + "'");
		 
			var jqRFC = eval("'#rfc" + ID + "'");
			var jqEstatus = eval("'#estatus" + ID + "'");
			var jqEstatusHidden = eval("'#estatusHidden" + ID + "'");
			
			var jqElimina = eval("'#" + ID + "'");
			var jqAgrega = eval("'#agrega" + ID + "'");
		

			$(jqConsecutivoID).remove();
			$(jqClaveDispMov).remove();
			$(jqTipoMov).remove();
			$(jqCuentaAhoID).remove();
			$(jqSaldo).remove();
			$(jqNombreCte).remove();
			$(jqClienteID).remove();
			$(jqDescripcion).remove();
			$(jqReferencia).remove();
			$(jqFormaPago).remove(); 
			$(jqTipoChequera).remove();
			$(jqTipoCheque).remove(); 
			$(jqMonto).remove();
			$(jqCuentaClabe).remove();
			$(jqNombreBenefi).remove();
			$(jqRFC).remove();
			$(jqEstatus).remove();	
			$(jqEstatusHidden).remove();
			$(jqdescriCtaCompleta).remove();
			$(jqcuentaCompletaID).remove();
			$(jqElimina).remove();
			$(jqAgrega).remove();
			
			$(jqTrrenglonCta).remove();
			$(jqTr).remove();
		}); 		 		
		$('#numeroDetalle').val(0);
	}
	
	function borraPartidasAutoriza(){
		$('input[name=consecutivoID]').each(function(){
			
			var ID = this.id.substring(13);
			
			var jqTr = eval("'#renglonA" + ID + "'");
			
			var jqConsecutivoID = eval("'#consecutivoIDA" + ID + "'");
			var jqTipoMov = eval("'#tipoMovA" + ID + "'");	
			var jqClaveDispMov = eval("'#claveDispMovA" + ID + "'");	 			
			var jqCuentaAhoID = eval("'#cuentaAhoIDA" + ID + "'"); 			 			 		
			var jqSaldo = eval("'#saldoA" + ID + "'");	
			var jqNombreCte = eval("'#nombreCteA" + ID + "'");
			var jqClienteID = eval("'#clienteIDA" + ID + "'");
			var jqDescripcion = eval("'#descripcionA" + ID + "'");
			var jqReferencia = eval("'#referenciaA" + ID + "'");
			var jqFormaPago = eval("'#formaPagoA" + ID + "'");
 		 var jqConceptoDisp = eval("'#conceptoDisp" + ID + "'");
 		 var jqConcepDisp = eval("'#sConceptoDisp" + ID + "'");
			var jqTipoChequera = eval("'#stipoChequera" + ID + "'");
			var jqTipoCheque= eval("'#tipoChequera" + ID + "'");
			var jqMonto = eval("'#montoA" + ID + "'");
			var jqCuentaClabe = eval("'#cuentaClabeA" + ID + "'");
			var jqNombreBenefi = eval("'#nombreBenefiA" + ID + "'");
			var jqTrrenglonCta = eval("'#renglonCtaA" + ID + "'");
			var jqdescriCtaCompleta= eval("'#descriCtaCompletaA" + ID + "'");
			var jqcuentaCompletaID= eval("'#cuentaCompletaIDA" + ID + "'");
		 
			var jqRFC = eval("'#rfcA" + ID + "'");
			var jqEstatus = eval("'#estatusA" + ID + "'"); 			 		
		

			$(jqConsecutivoID).remove();
			$(jqClaveDispMov).remove();
			$(jqTipoMov).remove();
			$(jqCuentaAhoID).remove();
			$(jqSaldo).remove();
			$(jqNombreCte).remove();
			$(jqClienteID).remove();
			$(jqDescripcion).remove();
			$(jqReferencia).remove();
			$(jqFormaPago).remove();
 		 $(jqConceptoDisp).remove();
 		 $(jqConcepDisp).remove();
			$(jqTipoChequera).remove();
			$(jqTipoCheque).remove();
			$(jqMonto).remove();
			$(jqCuentaClabe).remove();
			$(jqNombreBenefi).remove();
			$(jqRFC).remove();
			$(jqEstatus).remove();	
			$(jqEstatusHidden).remove();
			$(jqdescriCtaCompleta).remove();
			$(jqcuentaCompletaID).remove();
			$(jqElimina).remove();
			$(jqAgrega).remove();
			
			$(jqTrrenglonCta).remove();
			$(jqTr).remove();
		});
		$('#numeroDetalle').val(0);
	}
	
	
	
	
/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
			mensajeSis("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
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



//consulta el estatus del periodo contable con la fecha que se ingresa 
function consultaEstatus(idControl){
	var jqfecha = eval("'#" + idControl + "'");
	var fecha = $(jqfecha).val();	
	var tipoConsulta = catTipoConsultaEstatusFecha.estatus;		
		var fechaBean = {
      	'fecha':fecha
		};		
	if(fecha != '' ){
		periodoContableServicio.consulta(tipoConsulta, fechaBean, function(fechaEstatus){			
			if(fechaEstatus!=null){
				if(fechaEstatus.status=='C'){
					mensajeSis("El Período Contable para la Fecha Seleccionada se encuentra Cerrado");
					$(jqfecha).val(parametroBean.fechaSucursal);
					$(jqfecha).focus();
				}else{
					$('#institucionID').focus();
				}
			}
		});
	}
}
	
function consultaParametro(){
	var tipoConsulta = 1;
		paramGeneralesServicio.consulta(tipoConsulta, function(valor){
			if(valor!=null){							
				if (valor.valorParametro=="S"){
						habilitaControl('fechaActual');
						$('.ui-datepicker-trigger').show();
				}else{
					deshabilitaControl('fechaActual');
					$('.ui-datepicker-trigger').hide();
				}
			}else{
				deshabilitaControl('fechaActual');
				$('.ui-datepicker-trigger').hide();
			}   						
		});
					
}



function guardarFechas(){
	var mandar = verificarvacios();
	if(mandar!=1){
		var numCodigo = $('input[name=consecutivoIDA]').length;
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodigo; i++){
			if(i == 1){
				$('#datosGrid').val($('#datosGrid').val() +
						document.getElementById("cuentaClabeA"+i+"").value);
				return 1;
			}else{
				$('#datosGrid').val($('#datosGrid').val() + '[' +
						document.getElementById("cuentaClabeA"+i+"").value);
				return 1;
			}
		}
	}
	else{
		 return 2;
	}
}


function verificarvacios() {
    quitaFormatoControles('datosGrid');
    var numCodig = $('input[name=consecutivoIDA]').length;

    $('#tableCon').val("");

    for (var i = 1; i <= numCodig; i++) {
        if ($('#' + "autorizaCheck" + i + "").attr('checked') == true) {
            var idsu = document.getElementById("cuentaClabeA" + i + "").value;
            if (idsu == "") {
                document.getElementById("cuentaClabeA" + i + "").focus();
                $(idsu).addClass("error");
                return 1;
            }
        }

    }
}

function generaSeccion(pageValor) {

		var divReceptor = "tablaAutoriza";

		var params = {};		


		var folioDispersion = $('#folioOperacion').val();
		if(!isNaN(folioDispersion)){

			var params = {};
			params['folioOperacion'] = folioDispersion;
			params['tipoConsulta'] =  3;
			params['page'] = pageValor;	
			
		var jqDiv = eval("'#" + divReceptor + "'");
		$.post("operDispersionGrid.htm", params, function(data){
			if(data.length > 0 && folioDispersion != ''){
				$(jqDiv).html(data); 
				agregaNombresClientes('formaPagoA','cuentaAhoIDA','nombreCteA','clienteIDA');					
				corrigeNumeroDetalle('numeroDetalleAuto');
				agregaFormatoMontos();
				limpiaTablaVerifica();	


					$('input[name=consecutivoIDA]').each(function(){
						 var i = this.id.substring(14);
						cargarCombo(i);

					}); 
					
				$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
				$('input[name=montoA]').each(function() {
					var id =this.id.substring(6);
					var jqMonto = eval("'#" + this.id + "'");
					
					$(jqMonto).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
					
					
				});							

				if($('#estatusDisper').val() == 'A'){
					var banderaFormaPago ='';
						$('input[name=montoA]').each(function() {
							var id =this.id.substring(6);							
							$('#nombreBenefiA'+id).attr('readonly',true);
							if($('#formaPagoA'+id).val() == 2){
								banderaFormaPago ='S';
							}								
						});
						
			
						if( banderaFormaPago == 'S'){							
								//validaCtaNostroChequera2('cuentaAhorro','institucionID');						
						}
				}else if	
					($('#estatusDisper').val() == 'C'){
					$('input[name=montoA]').each(function() {
						var id =this.id.substring(6);						
						$('#nombreBenefiA'+id).attr('readonly',true);
						$('#cuentaClabeA'+id).attr('readonly',true);	
						deshabilitaControl(('stipoChequera'+id));

					});
								
				}
				
			}else{
				mensajeSis('No se han Encontrado Movimientos con los Datos Proporcionados');
				$('#folioOperacion').val("");
			}
		}); 
	}
	

	}

	function agregaNombresClientes(varTipoMov, varCuentaAhoID, varNombreCte, varClienteID){
	if($('#tipoAccion').val() == 1){
		var total = $('#numeroDetalle').val();
	}
	if($('#tipoAccion').val() == 2){ // opcion cheque
		var total = $('#numeroDetalleAuto').val();
	}

	var totalInt= parseInt(total);
	for(var i=1;i<=totalInt; i++){
		var cuentaAhoID = eval("'#" +varCuentaAhoID+ i + "'");
		var nombreCte =eval("'#" +varNombreCte+ i + "'");
		var clienteId = eval("'#"+varClienteID + i + "'");
		var saldo = eval("'#saldo" + i + "'");
		var beneficiario = eval("'#nombreBenefi" + i + "'");
		var jqtipoMovID = eval("'#"+varTipoMov + i+ "'");

		if($(jqtipoMovID).asNumber()=="2" || $(jqtipoMovID).asNumber()=="12" || $(jqtipoMovID).asNumber()=="3" || $(jqtipoMovID).asNumber()=="4" || $(jqtipoMovID).asNumber()=="26" ||$(jqtipoMovID).asNumber()=="1" || $(jqtipoMovID).asNumber()=="5" || $(jqtipoMovID).asNumber()=="6"){
			if($(cuentaAhoID).asNumber()>0){
				maestroCuentasDescripcion(varCuentaAhoID+ i, varNombreCte+ i ,varClienteID + i, "saldo" + i, beneficiario);
			}
			else{
				$(cuentaAhoID).val('');
			}
		}			

		var tipoMov= eval("'tipoMov" + i + "'");
		var nombreBenefi= eval("'nombreBenefi" + i + "'");
		var fechaEnvio= eval("'fechaEnvio" + i + "'");
		validaTipoMov(tipoMov,nombreBenefi,fechaEnvio);
	}

}

function corrigeNumeroDetalle(idControl){
	var jqNumeroDetalle = eval("'#" + idControl + "'");
	var numero = $(jqNumeroDetalle).val();
	if(isNaN(numero) || numero==''){
		$(jqNumeroDetalle).val('0');
	}
}


function agregaFormatoMontos(){

	$('input[name=monto]').each(function() {		
		var jqMonto = eval("'#" + this.id + "'");	
		$(jqMonto).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});		
	});


}

function consultaFechaDisp(){
var tipoConsulta = 18;
var ParametrosSisBean = {
		'empresaID'	:1
};

parametrosSisServicio.consulta(tipoConsulta,ParametrosSisBean,function(parametrosSisBean) {
	if (parametrosSisBean != null) {
		if(parametrosSisBean.fechaConsDisp == 'S'){
			$('#tdceldaFechaCons').show();
		}else{
			$('#tdceldaFechaCons').hide();
		}
	}
});
}

function validaOrdenPago () {
if($('#protecOrdenPago').val()=='S' && $('#institucionID').val()=='37'){;
	$('#protecOrdenPagoB').show();
}else{
	$('#protecOrdenPagoB').hide();
}

if($('#institucionID').val()=='37'){
	$('input[name=consecutivoIDA]').each(function(){
 	  	var i = this.id.substring(14);
 	  	
 	  	var jqAutorizaCheck = eval("'#autorizaCheck" + i + "'");			
		var jqOrdenPago = eval("'#formaPagoA" + i + "'");

		if($(jqOrdenPago).val()=='5' && $(jqAutorizaCheck).is(":checked") ){
			$('#reimprimeOrdenPago').show();
			return false;
		}
 	});
}else {
	$('#reimprimeOrdenPago').hide();
}

}

function limpiaCampos() {
$('#folioOperacion').val("");
$('#institucionID').val("");
$('#cuentaAhorro').val("");
$('#saldo').val("");
}

function verParametrosDispersion(){
	paramGeneralesServicio.consulta(43,{},{async : false , callback: function(parametro){
		if (parametro != null) {
			permiteVer = parametro.valorParametro;
			$('#permiteVer').val(permiteVer);
		}
	}});
}

function validaFormaDispersion(){
	var totalOpciones = 0;
	var checksMarcados = 0;
	var fila = 1;
	$('input[name=autorizaCheck]').each(function() {
		if($(this).attr('checked') == true){
			totalOpciones++;
		}
	});
	
	$('input[name=autorizaCheck]').each(function() {
		var tipo= eval("'#formaPagoA"  +fila+ "'");
	    var value = $(tipo).val();
	    var tMov= parseInt(value);
	     
		if($(this).attr('checked') == true && (tMov == 5 || tMov == 6)){
			checksMarcados++;
		}
		
		fila++;
	});
	
	if(checksMarcados != totalOpciones){
		//validamos si los marcados es 0 significa que no hay de orde ni de transfer asi que se puede procesar
		if(checksMarcados == 0){
			return true;
		}else{
			return false;
		}
		
	}else{
		return true;
	}
}

function validaManejaSPEI(){

	var tipoConsulta = 45;
		paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
		if(valor!=null){
				Var_ManejaSPEI=valor.valorParametro;
			}
		}
	});
}
