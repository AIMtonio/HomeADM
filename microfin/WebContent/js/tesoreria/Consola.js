$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
		
	$('#fechaDelDia').val(parametroBean.fechaSucursal);
	$('#sucursalDelDia').val(parametroBean.nombreSucursalMatriz);
	
	//Oculto la tabla contenedora del detalle
	$('#tablaDetalle').hide();
	
	// Carga Informacion del dia
	consultaInformacionAlDia();
	
	agregaFormatoControles('formaGenerica');
	


	//Arreglo para saber que busqueda realizara
	var catTipoConsulta={};
		catTipoConsulta['bancos']=1;
		catTipoConsulta['bancosColumnas']=4;
		catTipoConsulta['inversiones']=2;
		catTipoConsulta['inversionesColumnas']=5;
		catTipoConsulta['creditosVencidos']=3;
		catTipoConsulta['creditosVencidosColumnas']=8;
		catTipoConsulta['caja']=4;
		catTipoConsulta['cajaColumnas']=3;
		catTipoConsulta['dispersion']=5;
		catTipoConsulta['dispersionColumnas']=2;
		catTipoConsulta['gastos']=6;
		catTipoConsulta['gastosColumnas']=3;
		catTipoConsulta['fondeadorVencimiento']=7;
		catTipoConsulta['fondeadorVencimientoColumnas']=3;
		catTipoConsulta['gastosAutorizados']=8;
		catTipoConsulta['gastosAutorizadosColumnas']=3;
		catTipoConsulta['interes']=9;
		catTipoConsulta['interesColumnas']=8;
		//Detalle de las proyecciones
		catTipoConsulta['creditosVencidos15']=10;
		catTipoConsulta['creditosVencidos15Columnas']=8;
		catTipoConsulta['creditosVencidos30']=11;
		catTipoConsulta['creditosVencidos30Columnas']=8;
		catTipoConsulta['creditosVencidos60']=12;
		catTipoConsulta['creditosVencidos60Columnas']=8;
		
		catTipoConsulta['totalInv15dia']=13;
		catTipoConsulta['totalInv15diaColumnas']=8;
		catTipoConsulta['totalInv30dia']=14;
		catTipoConsulta['totalInv30diaColumnas']=8;
		catTipoConsulta['totalInv60dia']=15;
		catTipoConsulta['totalInv60diaColumnas']=8;
	
		
	$('.detalle').click( function(){
		
		var idConsulta = this.id;
		var jqTipo = eval("'" + idConsulta + "'");
		var jqColumas = eval("'" + jqTipo + "Columnas'");
		
		var consulta =  catTipoConsulta[jqTipo];
		var numCol = catTipoConsulta[jqColumas];
		
		$('#detalleConsola').html('');
				
		var beanConsola = {
				'tipoConsulta'	: consulta,
				'sucursalID'	: 1,
				'fechadia'		: parametroBean.fechaSucursal
			};
		
		consolaServicioScript.obtieneDetalleConsola(beanConsola, function(data){
			if(data != null){
				$('#tablaDetalle').show();
				 creaTabla(data, numCol, consulta);
				 sumarSaldos();
			}
		});
		
		
	});
	
	
	function consultaInformacionAlDia(){
		
		var beanConsola = {
			'sucursalID'	: '1',
			'fechadia'		: parametroBean.fechaSucursal
		};
		
		consolaServicioScript.obtieneConcentrado(beanConsola, function(data){
			if(data != null){
				//dwr.util.setValues(data);

				//Ingresos
				$('#cuentasBancos').val(formatoMiles(data.cuentasBancos, 2, [',', ",", '.']));
				$('#inversionBancarias').val(formatoMiles(data.inversionBancarias, 2, [',', ",", '.']));
				$('#efectivoCaja').val(formatoMiles(data.efectivoCaja, 2, [',', ",", '.']));
				$('#montoCreVencidos').val(formatoMiles(data.montoCreVencidos, 2, [',', ",", '.']));
				
				$('#totalEfectivo').val(formatoMiles(data.totalEfectivo, 2, [',', ",", '.']));
				$('#totalCirculante').val(formatoMiles(data.totalCirculante, 2, [',', ",", '.']));
				
				
				//Egresos
				$('#desPendientesDis').val(formatoMiles(data.desPendientesDis, 2, [',', ",", '.']));
				$('#presuGasAuto').val(formatoMiles(data.presuGasAuto, 2, [',', ",", '.']));
				$('#vencimientoFonde').val(formatoMiles(data.vencimientoFonde, 2, [',', ",", '.']));
				$('#gastosPendientes').val(formatoMiles(data.gastosPendientes, 2, [',', ",", '.']));
				$('#pagoInteresCaptacion').val(formatoMiles(data.pagoInteresCaptacion, 2, [',', ",", '.']));
				
				
				$('#totalCompInm').val(formatoMiles(data.totalComproInme, 2, [',', ",", '.']));
				$('#totalCompAut').val(formatoMiles(data.totalComproAut, 2, [',', ",", '.']));
				
				//Vencimientos de creditos
				$('#totalCred15dias').val(formatoMiles(data.totalCred15dias, 2, [',', ",", '.']));
				$('#totalCred30dias').val(formatoMiles(data.totalCred30dias, 2, [',', ",", '.']));
				$('#totalCred60dias').val(formatoMiles(data.totalCred60dias, 2, [',', ",", '.']));
								
				//Proyecciones
				$('#total15Dias').val(formatoMiles(data.total15Dias, 2, [',', ",", '.']));
				$('#total30Dias').val(formatoMiles(data.total30Dias, 2, [',', ",", '.']));
				$('#total60Dias').val(formatoMiles(data.total60Dias, 2, [',', ",", '.']));
				
				//Vencimiento PRLV
				$('#totalInv15dias').val(formatoMiles(data.totalInv15dias, 2, [',', ",", '.']));
				$('#totalInv30dias').val(formatoMiles(data.totalInv30dias, 2, [',', ",", '.']));
				$('#totalInv60dias').val(formatoMiles(data.totalInv60dias, 2, [',', ",", '.']));
				
				
				
				//Dibuja las graficas
				dibujaGraficaActivoCirculante(data);
				dibujaGraficaEgresos(data);
				dibujaGraficaBarras(data);
				
			}else{
				alert("Error al consultar información...");
			}
			
		});
	}
	
	//Metodo para crear el contenido del detalle de la consulta
	function creaTabla(data, numCol, tipoConsulta){
		
		var tds = "";
		var colTd = 0;
		var i = 0;
		var renglon = 0;
		var colspan = numCol - 1;
		
		tds += creaEncabezadoTabla(tipoConsulta);
		tds += "<tr>";
		
		for(i=0; i< data.length; i++){
			$.each(data[i], function(key, value){
								
				tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</td>';
								
				colTd = colTd + 1;
				
				if(colTd == numCol){
					tds += "</tr>";
					tds += "<tr>";
					colTd = 0;
				}
				renglon = renglon + 1;
			});
		}
		tds += '<tr><td colspan="'+colspan+'" id="totalFinal"><b>Total:</b></td><td><input type="text" name="sumatoriaFinal" id="sumatoriaFinal" size="35" value="" class="cajatexto" readOnly="true"></td></tr>';
		$('#detalleConsola').append(tds);
	}
	
	//Metodo para crear los encabezados de cada detalle
	function creaEncabezadoTabla(tipoConsulta){
		
		var trs = '';
		
		switch(tipoConsulta){
			case 1:
				trs += '<tr align="center"><td class="label"><label for="lblDes">Descripción</label></td><td class="label"><label for="lblInst">Institución</label></td><td class="label"><label for="lblNoCuen">No. Cuenta</label></td><td class="label"><label for="lblsal">Saldo</label></td></tr>';
					$('#nombre').html('Cuentas Bancarias');
				break;
			case 2:
				trs += '<tr align="center"><td class="label"><label for="lblDes">Descripción</label></td><td class="label"><label for="lblInst">Institución</label></td><td class="label"><label for="lblNoInst">No Instrumento</label></td><td class="label"><label for="lblfecVen">Fecha Vencimiento</label></td><td class="label"><label for="lblMonto">Monto Cap. + Int.</label></td></tr>';
					$('#nombre').html('Inversiones Bancarias');
				break;
			case 3:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Vencimientos de Créditos');
				break;
			case 4:
				trs += '<tr align="center"><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblCajaDe">Caja</label></td><td class="label"><label for="lblMonEx">Monto Exigible</label></td></tr>';
					$('#nombre').html('Efectivo en Cajas');	
				break;
			case 5:	
				trs += '<tr align="center"><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonMinis">Monto a Ministrar</label></td></tr>';
					$('#nombre').html('Deseembolsos Pendientes');
				break;
			case 6:
				trs += '<tr align="center"><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lbltipGasto">Tipo Gasto</label></td><td class="label"><label for="lblMonGas">Monto</label></td></tr>';
					$('#nombre').html('Gastos Pendientes');
				break;
			case 7:
				trs += '<tr align="center"><td class="label"><label for="lblSucur">Fondeador</label></td><td class="label"><label for="lbltipGasto">Nombre Linea</label></td><td class="label"><label for="lblMonGas">Monto a Pagar</label></td></tr>';
					$('#nombre').html('Vencimientos de Fondeadores');
				break;
			case 8:
				trs += '<tr align="center"><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lbltipGasto">Tipo Gasto</label></td><td class="label"><label for="lblMonGas">Monto</label></td></tr>';
					$('#nombre').html('Presupuesto de Gastos Autorizado');
				break;
			case 9:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Pago Inversiones Plazo');
				break;		
			case 10:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Vencimientos de Créditos Ma&ntilde;ana a 15 d&iacute;as');
				break;
			case 11:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
				$('#nombre').html('Vencimientos de Créditos 16 a 30 d&iacute;as');
				break;
			case 12:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
				$('#nombre').html('Vencimientos de Créditos 31 a 60 d&iacute;as');
				break;
			case 13:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Pago Inversiones Plazo Ma&ntilde;ana a 15 d&iacute;as');
				break;
			case 14:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Pago Inversiones Plazo 16 a 30 d&iacute;as');
				break;
			case 15:
				trs += '<tr align="center"><td class="label"><label for="lblNumSucur">NoSucursal</label></td><td class="label"><label for="lblSucur">Sucursal</label></td><td class="label"><label for="lblMonGas">Capital</label></td><td class="label"><label for="lblInte">Interés</label></td><td class="label"><label for="lblMora">Moratorios</label></td><td class="label"><label for="lblComision">Comisiones</label></td><td class="label"><label for="lblIVA">IVA</label></td><td class="label"><label for="lbltotal">Total</label></td></tr>';
					$('#nombre').html('Pago Inversiones Plazo 31 a 60 d&iacute;as');
				break;
				
		}
							
		return trs;
	}
	
	//Metodo para cerrar el detalle y limpair la tabla del mismo
	$('#cerrarDetalle').click(function() {	
		$('#detalleConsola').html('');
		$('#tablaDetalle').hide();
	});
	
	
	function sumarSaldos(){
		var sumatoria = 0;
		$("input[name=saldo]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			sumatoria += parseFloat($(jqSaldo).val());
			$(jqSaldo).val(formatoMiles($(jqSaldo).val(), 2, [',', ",", '.']));
			$("input[name=saldo]").css({"text-align":"right"});
		});
		$('#sumatoriaFinal').val(formatoMiles(sumatoria , 2, [',', ",", '.']));
		$('#totalFinal').css({"text-align":"right"});
	}
	
	
	// Grafica de Activo Circulante
	function dibujaGraficaActivoCirculante(data){
		
		var chart = new Highcharts.Chart({
			chart: {
				renderTo: 'contenedorActivos',
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			title: {
				text: 'Distribución Activo Circulante'
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
				}
			},
			exporting: {
				buttons:{
					exportButton:{
						enabled:false					
					},
					printButton:{
						enabled:true
					}
				}
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
						enabled: true,
						color: '#000000',
						connectorColor: '#000000',
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
						}
					}
				}
			},
			series: [{
				type: 'pie',
				name: 'Activo Circulante',
				data: [
					['Cta. Bancarias',	 		parseFloat(data.cuentasBancos)],
					['Inv. Bancarias',	 		parseFloat(data.inversionBancarias)],
					['Vencimiento de Créditos',	parseFloat(data.montoCreVencidos)],
					['Efectivo en Cajas',	 	parseFloat(data.efectivoCaja)]
				]
			}]
		});		
	}
	
	// Grafica de Egresos
	function dibujaGraficaEgresos(data){
		
		var chart = new Highcharts.Chart({
			chart: {
				renderTo: 'contenedorEgresos',
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			title: {
				text: 'Distribución Egresos'
			},
			tooltip: {
				formatter: function() {
					return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
				}
			},
			exporting: {
				buttons:{
					exportButton:{
						enabled:false					
					},
					printButton:{
						enabled:true
					}
				}
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
						enabled: true,
						color: '#000000',
						connectorColor: '#000000',
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage, 2) +' %';
						}
					}
				}
			},
			series: [{
				type: 'pie',
				name: 'Activo Circulante',
				data: [
					['Deseembolsos Pendientes Disp.',	parseFloat(data.desPendientesDis)],
					['Gastos Aut. Pendientes',	 		parseFloat(data.gastosPendientes)],
					['Vencimientos Fondeadores',	parseFloat(data.vencimientoFonde)],
					['Presupuestos Gasto. Aut.',	parseFloat(data.presuGasAuto)],
					['Pago de Interés Captación',	parseFloat(data.pagoInteresCaptacion)]
				]
			}]
		});		
	}
	

	// Circulante vs Compromiso
	function dibujaGraficaBarras(datos){
		
		var chartBarras = new Highcharts.Chart({
			chart: {
				renderTo: 'contenedorCompromiso',
				type: 'bar'
			},
			title: {
				text: 'Circulante vs Compromiso'
			},
			xAxis: {
				categories: ['Actual'],
				title: {
					text: null
				},
				formatter : function() {
					return Highcharts.numberFormat(this.value);
				}
			},
			yAxis: {
				min: 0,
				title: {
					text: 'Montos',
					align: 'middle'
				},
				labels: {
					y:40,
					rotation: 90,
					formatter: function() {
						return Highcharts.numberFormat(this.value);
					}
				}
			},
			tooltip: {
				formatter: function() {
					return ''+ this.series.name;
				}
			},
			plotOptions: {
				bar: {
					dataLabels: {
						enabled: true
					}
				}
			},
			exporting: {
				buttons:{
					exportButton:{
						enabled:false					
					},
					printButton:{
						enabled:true
					}
				}
			},
			legend: {
				layout: 'horizontal',
				align: 'center',
				verticalAlign: 'top',
				x: 100,
				y: 40,
				floating: true,
				borderWidth: 1,
				backgroundColor: '#FFFFFF',
				shadow: true
			},
			credits: {
				enabled: false
			},
			series: [{
						name: 'Efectivo',
						data: [parseFloat(datos.totalCirculante)]
					}, {
						name: 'Compromiso',
						data: [parseFloat(datos.totalComproInme)]
					}]
		});
	}
	
	// Grafica de liquidez
	function liquidez(){
		
	}
});



// rutina para separador de miles
function formatoMiles(value, decimals, separators) {
    decimals = decimals >= 0 ? parseInt(decimals, 0) : 2;
    separators = separators || [',', ',', '.'];
    
    var number = (parseFloat(value) || 0).toFixed(decimals);
    
    if (number.length <= (4 + decimals)){
        return number.replace('.', separators[separators.length - 1]);
    }
    var parts = number.split(/[-.]/);
    
    value = parts[parts.length > 1 ? parts.length - 2 : 0];
    
    var result = value.substr(value.length - 3, 3) + (parts.length > 1 ? separators[separators.length - 1] + parts[parts.length - 1] : '');
    
    var start = value.length - 6;
    var idx = 0;
   
    while (start > -3) {
        result = (start > 0 ? value.substr(start, 3) : value.substr(0, 3 + start)) + separators[idx] + result;
        idx = (++idx) % 2;
        start -= 3;
    }
    
    return (parts.length == 3 ? '-' : '') + result;
}