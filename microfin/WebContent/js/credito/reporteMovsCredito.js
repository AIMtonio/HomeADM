var montoCre;
var montoTot;


$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();
	
	//Definicion de Constantes y Enums  
	consultaMoneda();
	agregaFormatoControles('formaGenerica');
	
	
	var catTipoTransaccionCredito = {
			'agrega':'1',
			'modifica':'2',
			'actualiza':'3',
			'actNumTraSim':'5', 
			'actuaCredi':'6',  
			'actTmp':'7',		
			'simulador':'9'
	};	

	$('#pantalla').attr("checked",true) ; 
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#creditoID').focus();
	$('#fechaSistema').val(parametroBean.fechaSucursal);
	deshabilitaBoton('generar','submit');

	var catTipoActCredito = {
			'autoriza':1,
			'autorizaPagImp':2,
			'actNumTransacSim':3,
			'actualizaCred':4,
			'actTmpPagAmor':5


	};	

	var catTipoConsultaCredito = { 
			'principal'	: 1,
			'foranea'	: 2,
			'pagareImp' : 3,
			'ValidaCredAmor':4,
			'resumenCredito' :13

	};		

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}

		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var fechaSistema = $('#fechaSistema').val();
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		$('#fechaFin').focus();
		if(Yfecha>fechaSistema){
			mensajeSis("La Fecha de Fin no Debe ser Mayor a la Fecha del Sistema.");
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es Mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

	});

	$('#creditoID').blur(function() { 
		validaCredito(this.id);		
	});

	$('#pdf').click(function() {	
		var credito = $('#creditoID').val();	 
		$('#ligaGenerar').attr('href','RepPDFMovsCredito.htm?creditoID='+credito);
		//deshabilitaBoton('generar','submit');
	});
	

	$('#generar').click(function() {
		
		if($('#detallado').is(':checked')){
		if($('#pdf').is(':checked')){	   
			var credito = $('#creditoID').val();	 
			var fechaIni = $('#fechaInicio').val();	 
			var fechFin = $('#fechaFin').val();	 
			var nombreInstit =  parametroBean.nombreInstitucion; 
			var nombreUsu = parametroBean.claveUsuario; 
			var cliente = $('#clienteID').val();
			var nombreCte = $('#nombreCliente').val();
			var ClienteConCaracter = nombreCte;
			nombreCte = ClienteConCaracter.replace(/\&/g, "%26");
			monto =	 montoCre;
			var producto = $('#producCreditoID').val();
			var nombreProduc = $('#nombreProd').val();
			var fechaDesembolso = $('#fechaMinistrado').val();
			adeudoTotal =	 montoTot;
			var estatus = $('#estatus').val();
			var moneda=$('#monedaID').val();				
			var fechaEmision = parametroBean.fechaSucursal;
			
			$('#ligaGenerar').attr('href','RepPDFMovsCredito.htm?creditoID='+credito+'&fechaInicio='+fechaIni+'&fechaVencimien='+fechFin+
					'&nombreInstitucion='+nombreInstit+'&nombreUsuario='+nombreUsu+'&clienteID='+cliente+'&nombreCliente='+nombreCte+'&parFechaEmision='+fechaEmision+
					'&montoCredito='+monto+'&producCreditoID='+producto+'&nombreProducto='+nombreProduc+'&fechaMinistrado='+fechaDesembolso+
					'&adeudoTotal='+adeudoTotal+'&estatus='+estatus+'&monedaID='+moneda);
		}

		if($('#pantalla').is(':checked')){	   
			var credito = $('#creditoID').val();	 
			var fechaIni = $('#fechaInicio').val();	 
			var fechFin = $('#fechaFin').val();	 
			var nombreInstit =  parametroBean.nombreInstitucion; 
			var nombreUsu = parametroBean.claveUsuario; 
			var cliente = $('#clienteID').val();
			var nombreCte = $('#nombreCliente').val();
			var ClienteConCaracter = nombreCte;
			nombreCte = ClienteConCaracter.replace(/\&/g, "%26");
			monto =	 montoCre;
			var producto = $('#producCreditoID').val();
			var nombreProduc = $('#nombreProd').val();
			var fechaDesembolso = $('#fechaMinistrado').val();
			adeudoTotal = montoTot;
			var estatus = $('#estatus').val();
			var moneda=$('#monedaID').val();	
			var tipoReporte=1;			
			var fechaEmision = parametroBean.fechaSucursal;

			$('#ligaGenerar').attr('href','ReporteMovsCred.htm?creditoID='+credito+'&fechaInicio='+fechaIni+'&fechaVencimien='+fechFin+
					'&nombreInstitucion='+nombreInstit+'&nombreUsuario='+nombreUsu+'&clienteID='+cliente+'&nombreCliente='+nombreCte+'&parFechaEmision='+fechaEmision+ 
					'&montoCredito='+monto+'&producCreditoID='+producto+'&nombreProducto='+nombreProduc+'&fechaMinistrado='+fechaDesembolso+
					'&adeudoTotal='+adeudoTotal+'&estatus='+estatus+'&monedaID='+moneda+'&tipoReporte='+tipoReporte);
		}

		if($('#excel').is(':checked')){	   
			var credito = $('#creditoID').val();	 
			var fechaIni = $('#fechaInicio').val();	 
			var fechFin = $('#fechaFin').val();	 
			var nombreInstit =  parametroBean.nombreInstitucion; 
			var nombreUsu = parametroBean.claveUsuario; 
			var cliente = $('#clienteID').val();
			var nombreCte = $('#nombreCliente').val();
			var ClienteConCaracter = nombreCte;
			nombreCte = ClienteConCaracter.replace(/\&/g, "%26");
			monto =	 montoCre; 
			var producto = $('#producCreditoID').val();
			var nombreProduc = $('#nombreProd').val();
			var fechaDesembolso = $('#fechaMinistrado').val();
			adeudoTotal =	 montoTot;
			var estatus = $('#estatus').val();
			var moneda=$('#monedaID').val();	
			var tipoReporte=3;
			var tipoLista=9;	
			var fechaEmision = parametroBean.fechaSucursal;

			$('#ligaGenerar').attr('href','ReporteMovsCred.htm?creditoID='+credito+'&fechaInicio='+fechaIni+'&fechaVencimien='+fechFin+
					'&nombreInstitucion='+nombreInstit+'&nombreUsuario='+nombreUsu+'&clienteID='+cliente+'&nombreCliente='+nombreCte+'&parFechaEmision='+fechaEmision+ 
					'&montoCredito='+monto+'&producCreditoID='+producto+'&nombreProducto='+nombreProduc+'&fechaMinistrado='+fechaDesembolso+
					'&adeudoTotal='+adeudoTotal+'&estatus='+estatus+'&monedaID='+moneda+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista);
		}
		}else{
			if($('#pdf').is(':checked')){	   
				var credito = $('#creditoID').val();	 
				var fechaIni = $('#fechaInicio').val();	 
				var fechFin = $('#fechaFin').val();	 
				var nombreInstit =  parametroBean.nombreInstitucion; 
				var nombreUsu = parametroBean.claveUsuario; 
				var cliente = $('#clienteID').val();
				var nombreCte = $('#nombreCliente').val();
				var ClienteConCaracter = nombreCte;
				nombreCte = ClienteConCaracter.replace(/\&/g, "%26");
				monto =	 montoCre;
				var producto = $('#producCreditoID').val();
				var nombreProduc = $('#nombreProd').val();
				var fechaDesembolso = $('#fechaMinistrado').val();
				adeudoTotal =	 montoTot;
				var estatus = $('#estatus').val();
				var moneda=$('#monedaID').val();				
				var fechaEmision = parametroBean.fechaSucursal;
				var tipoReporte = 2;
				
				$('#ligaGenerar').attr('href','RepPDFMovsCreditoSum.htm?creditoID='+credito+'&fechaInicio='+fechaIni+'&fechaVencimien='+fechFin+
						'&nombreInstitucion='+nombreInstit+'&nombreUsuario='+nombreUsu+'&clienteID='+cliente+'&nombreCliente='+nombreCte+'&parFechaEmision='+fechaEmision+
						'&montoCredito='+monto+'&producCreditoID='+producto+'&nombreProducto='+nombreProduc+'&fechaMinistrado='+fechaDesembolso+
						'&adeudoTotal='+adeudoTotal+'&estatus='+estatus+'&monedaID='+moneda+'&tipoReporte='+tipoReporte);
			}
			
			if($('#excel').is(':checked')){	   
				var credito = $('#creditoID').val();	 
				var fechaIni = $('#fechaInicio').val();	 
				var fechFin = $('#fechaFin').val();	 
				var nombreInstit =  parametroBean.nombreInstitucion; 
				var nombreUsu = parametroBean.claveUsuario; 
				var cliente = $('#clienteID').val();
				var nombreCte = $('#nombreCliente').val();
				var ClienteConCaracter = nombreCte;
				nombreCte = ClienteConCaracter.replace(/\&/g, "%26");
				monto =	 montoCre;
				var producto = $('#producCreditoID').val();
				var nombreProduc = $('#nombreProd').val();
				var fechaDesembolso = $('#fechaMinistrado').val();
				adeudoTotal =	 montoTot;
				var estatus = $('#estatus').val();
				var moneda=$('#monedaID').val();	
				var tipoReporte=3;
				var tipoLista=15;	
				var fechaEmision = parametroBean.fechaSucursal;

				$('#ligaGenerar').attr('href','RepPDFMovsCreditoSum.htm?creditoID='+credito+'&fechaInicio='+fechaIni+'&fechaVencimien='+fechFin+
						'&nombreInstitucion='+nombreInstit+'&nombreUsuario='+nombreUsu+'&clienteID='+cliente+'&nombreCliente='+nombreCte+'&parFechaEmision='+fechaEmision+ 
						'&montoCredito='+monto+'&producCreditoID='+producto+'&nombreProducto='+nombreProduc+'&fechaMinistrado='+fechaDesembolso+
						'&adeudoTotal='+adeudoTotal+'&estatus='+estatus+'&monedaID='+moneda+'&tipoReporte='+tipoReporte+'&tipoLista='+tipoLista);
			}
		}
	});	
	//------------ Validaciones de la Forma -------------------------------------	

	$('#formaGenerica').validate({

		rules: {

			creditoID: {
				required: true
			},			
		},
		messages: {
			creditoID: {
				required: 'Especifique el Número de Crédito.'
			},
		}		
	});
	

	deshabilitaBoton('generarMovs', 'button');
	deshabilitaBoton('exportarPDF', 'button');	

	//------------ Validaciones de Controles -------------------------------------

	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		if(numCredito==''){
			limpiarPantalla();
			deshabilitaBoton('generar','submit');
			$('#creditoID').focus();
			$('#fechaFin').val(parametroBean.fechaSucursal);
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		if(numCredito != '' && !isNaN(numCredito) ){

			var creditoBeanCon = { 
					'creditoID':numCredito
			};	
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCredito==0){
				limpiarPantalla();
				deshabilitaBoton('generar','submit');
				$('#creditoID').focus();
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			else{
				creditosServicio.consulta(catTipoConsultaCredito.resumenCredito,creditoBeanCon,function(credito) {
					if(credito!=null){
						var fechaIni = $('#fechaInicio').val();
											
						$('#producCreditoID').val(credito.producCreditoID);
						$('#montoCredito').val(credito.montoCredito);
						montoCre = credito.montoCredito;
						$('#fechaMinistrado').val(credito.fechaMinistrado);
						$('#adeudoTotal').val(credito.adeudoTotal);
						montoTot = credito.adeudoTotal;
						$('#monedaID').val(credito.monedaID);

						esTab=true; 	

						$('#clienteID').val(credito.clienteID);
						consultaCliente('clienteID');
						habilitaBoton('generar', 'button');

						validaEstatus(credito.estatus);  
						consultaProducCredito('producCreditoID');
						$('#fechaInicio').val(fechaIni);
						$('#adeudoTotal').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n', 
							roundToDecimalPlace: 2	
						});
						
						$('#montoCredito').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n', 
							roundToDecimalPlace: 2	
						});
						
						
					}else{
						mensajeSis("No Existe el Crédito.");
						$('#creditoID').focus();
						$('#creditoID').val('');
						$('#fechaFin').val(parametroBean.fechaSucursal);
						$('#fechaInicio').val(parametroBean.fechaSucursal);
						limpiarPantalla();
						deshabilitaBoton('generar','submit');

					}
				});
			}

		}
	}


	function limpiarPantalla(){
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#producCreditoID').val('');
		$('#nombreProd').val('');
		$('#estatus').val('');
		$('#fechaMinistrado').val('');
		$('#adeudoTotal').val('');
		$('#montoCredito').val('');		

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
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').focus();
					$('#clienteID').select();	
				}    	 						
			});
		}
	}

	function validaEstatus(estatus){

		if(estatus == 'I'){
			$('#estatus').val('INACTIVO');
		}
		if(estatus == 'A'){
			$('#estatus').val('AUTORIZADO');
		}
		if(estatus == 'V'){
			$('#estatus').val('VIGENTE');
		}
		if(estatus == 'C'){
			$('#estatus').val('CANCELADO');
		}
		if(estatus == 'P'){
			$('#estatus').val('PAGADO');
		}
		if(estatus == 'B'){
			$('#estatus').val('VENCIDO');
		}
		if(estatus == 'K'){
			$('#estatus').val('CASTIGADO');
		}
		if(estatus == 'S'){
			$('#estatus').val('SUSPENDIDO');
		}

	}  

	function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
				'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();


		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
			productosCreditoServicio.consulta(catTipoConsultaCredito.foranea,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProd').val(prodCred.descripcion);

				}else{							
					mensajeSis("No Existe el Producto de Credito.");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();																					
				}
			});
		}				 					
	}

	function consultaMoneda() {			
		dwr.util.removeAllOptions('monedaID'); 

		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'});
		monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			
		});
	}

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){
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

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea");
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
	/***********************************/


});