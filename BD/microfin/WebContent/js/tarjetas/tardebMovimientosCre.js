$(document).ready(function() {
	var parametroBean = consultaParametrosSession(); 
	var fechaHoy = parametroBean.fechaSucursal;
	var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	$('#tarjetaID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	var catMovimientosTarjeta = {
			'consultaTarjeta' : 17,
			'consultaTarCred' : 7
			
	};
	var catTipoRepMovimiento = { 
			'PDF' : 1
	};
	deshabilitaBoton('consultar','submit');
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({			
	      submitHandler: function(event) { 	    	  
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tarjetaID',
	    				  'funcionExitoMovimiento','funcionErrorMovimiento');
	      }
	      
	});	
	
	$('#tarjetaID').blur(function() {
		consultaTarjetaCred();
	});
	
	$('#consultar').click(function() {
		if( $("#fechaPeriodo option:selected").val() != '' && $("#mesPeriodo option:selected").val() != 0 ){
			consultaMovimientoTarjetasCred();
		}else{
			if($("#fechaPeriodo option:selected").val() == ''){
				mensajeSis('Seleccione la Fecha del Periodo');
			}else{
				if($("#mesPeriodo option:selected").val() == 0){
					mensajeSis('Seleccione el Mes del Periodo');					
				}
			}
		}	
	});	

	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tarjetaID').bind('keyup',function(e){ 
		 if(this.value.length >= 2  && isNaN($('#tarjetaID').val())){
		 	lista('tarjetaID', '1','12','tarjetaDebID', $('#tarjetaID').val(),'tarjetasCreditoLista.htm');
		 }
	});	

	//------------ Validaciones de Controles -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			fechaPeriodo :{
				required: true
			},
			mesPeriodo:{
				required: true
			}
		},
		
		messages: {
			fechaPeriodo :{
				required: 'Especifique el Año del Periodo.'
			},
			mesPeriodo :{
				required: 'Especifique el Mes del Periodo.'
			}
		}
	});


	//CONSULTA INFORACION DE LINEA DE CREDITO
	function infoLineacredito(lineaCredID) {
		var TarjetaCreditoCon = {
			'lineaTarjetaCredID': lineaCredID,
			'fechaConsulta': fechaHoy
		};
		setTimeout("$('#cajaLista').hide();", 200);

			tCPeriodoLineaServicio.consulta(1, TarjetaCreditoCon,function(infoLinea){
				if (infoLinea != null) {
					var saldoPago =(infoLinea.saldoCorte) -(infoLinea.pagos);
					var saldoTotalFecha =(parseFloat((infoLinea.saldoCorte) -(infoLinea.pagos))+parseFloat(infoLinea.cargos)).toFixed(2);
					$('#pagos').val(infoLinea.pagos);
					$('#cargosRecientes').val(infoLinea.cargos);
					$('#fechaLimPago').val(infoLinea.fechaExigible);

					$('#saldoCorte').val(infoLinea.saldoCorte);
					$('#pagoNoGenInt').val(infoLinea.pagoNoGenInteres);
					$('#pagoMinimo').val(infoLinea.pagoMinimo);
					$('#interes').val(infoLinea.interes);
					$('#comisiones').val(infoLinea.comisiones);
					$('#proximoCorte').val(infoLinea.fechaProxCorte);
					$('#pagos').val(infoLinea.pagos);
					$('#limiteCredito').val(infoLinea.montoLinea);
					$('#saldoFecha').val(infoLinea.saldoFecha);
					$('#saldoFavor').val(infoLinea.saldoFavor);
					$('#creditoDisponible').val(infoLinea.montoDisponible);
					agregaFormatoControles('formaGenerica');
				} 
				else {
					$('#pagos').val(0);
					$('#cargosRecientes').val(0);
					$('#fechaLimPago').val('');
					$('#saldoCorte').val(0);
					$('#pagoNoGenInt').val(0);
					$('#pagoMinimo').val(0);
					$('#interes').val(0);
					$('#comisiones').val(0);
					$('#proximoCorte').val('');
					$('#pagos').val(0);
					$('#limiteCredito').val(0);
					$('#saldoFecha').val(0);
					$('#saldoFavor').val(0);
					$('#creditoDisponible').val(0);
				}
			});
	}



	//Consulta de Tarjetas
	function consultaTarjetaCred() {
		var tarjetaID =$('#tarjetaID').val();
		var TarjetaCreditoCon = {
			'tarjetaDebID': $('#tarjetaID').val()
		};
		$('#gridConsultaMovimientos').html("");
		$('#gridConsultaMovimientos').hide();
		$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
		$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
		$('#generar').hide();
		setTimeout("$('#cajaLista').hide();", 200);
		if (Number(tarjetaID) != ''  && !isNaN(tarjetaID) && esTab) {
			tarjetaCreditoServicio.consulta(7, TarjetaCreditoCon,function(movimientoTarCred){
			if(movimientoTarCred !=null   ){
				habilitaBoton('consultar','submit');
				$('#tarjetaID').val(movimientoTarCred.tarjetaID);
				$('#descripcion').val(movimientoTarCred.descripcion);
				$('#clienteID').val(movimientoTarCred.clienteID);
				$('#nombreCompleto').val(movimientoTarCred.nombreCompleto);
				$('#coorporativo').val(movimientoTarCred.coorporativo);
				$('#productoID').val(movimientoTarCred.productoID);
				if (movimientoTarCred.lineaCreditoID!='' && movimientoTarCred.lineaCreditoID!=null) {
					infoLineacredito(movimientoTarCred.lineaCreditoID);
					listaPeriodos(movimientoTarCred.lineaCreditoID);
				}
				
				$('#descripcionProd').val(movimientoTarCred.descripcionProd);
				$('#tipoTarjetaDebID').val(movimientoTarCred.tipoTarjetaID);
				$('#nombreTarjeta').val(movimientoTarCred.nombreTarjeta);
				if (movimientoTarCred.coorporativo == null || movimientoTarCred.coorporativo == 0 || movimientoTarCred.coorporativo == ''){
					$('#cteCorpTr').hide();
				}else {
					$('#cteCorpTr').show();
					consultaTarCoorpo('coorporativo');
				}
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
			
				if(consultaTarCoorpo.identificacionSocio=='S'){
					mensajeSis('El Número de Tarjeta es de Identificación.');
					$('#tarjetaID').focus();
					$('#tarjetaID').val('');
					$('#descripcion').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#productoID').val('');
					$('#descripcionProd').val('');
					$('#nombreTarjeta').val('');
					$('#tipotarjetaID').val('');
	                $('#nombreTarjeta').val('');
	                $('#nombreCoorp').val('');
	                deshabilitaBoton('consultar','submit');
					$('#gridConsultaMovimientos').hide();
					$('#generar').hide();
					
				}
				
			}else  {
				
				mensajeSis("Número de Tarjeta Inválida");
				$('#tarjetaID').focus();
				$('#tarjetaID').val('');
				$('#descripcion').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#productoID').val('');
				$('#descripcionProd').val('');
				$('#nombreTarjeta').val('');
				$('#tipotarjetaID').val('');
                $('#nombreTarjeta').val('');
                $('#nombreCoorp').val('');
                $('#saldoInicial').val('');
				$('#pagoNoGenInt').val('');
				$('#cargosRecientes').val('');
				$('#pagoMinimo').val('');
				$('#pagos').val('');
				$('#fechaLimPago').val('');
				$('#saldoCorte').val('');
				$('#proximoCorte').val('');
				$('#pagos').val('');
				$('#cargosRecientes').val('');
				$('#saldoFavor').val('');
				$('#creditoDisponible').val('');
				$('#saldoFecha').val('');
				$('#limiteCredito').val('');
				$('#interes').val('');
				$('#comisiones').val('');
				$('#tipoTarjetaDebID').val('');
				$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
				$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
                deshabilitaBoton('consultar','submit');
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
				
			}});
		}else if(isNaN(tarjetaID)){
			$('#tarjetaID').val('');
			$('#descripcion').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
			$('#productoID').val('');
			$('#descripcionProd').val('');
			$('#tipotarjetaID').val('');
            $('#nombreTarjeta').val('');
            $('#saldoInicial').val('');
			$('#pagoNoGenInt').val('');
			$('#cargosRecientes').val('');
			$('#pagoMinimo').val('');
			$('#pagos').val('');
			$('#fechaLimPago').val('');
			$('#saldoCorte').val('');
			$('#proximoCorte').val('');
			$('#pagos').val('');
			$('#cargosRecientes').val('');

			$('#saldoFavor').val('');
			$('#creditoDisponible').val('');
			$('#saldoFecha').val('');
			$('#limiteCredito').val('');
			$('#interes').val('');
			$('#comisiones').val('');
			$('#tipoTarjetaDebID').val('');
			$('#tarjetaID').focus();
			$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
			$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
		    deshabilitaBoton('consultar','submit');
		    
		}
		else if(Number(tarjetaID)== ''){
				$('#tarjetaID').val('');
				$('#descripcion').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
			    $('#nombreCoorp').val('');
				$('#productoID').val('');
				$('#descripcionProd').val('');
				$('#tipotarjetaID').val('');
                $('#nombreTarjeta').val('');
                $('#saldoInicial').val('');
				$('#pagoNoGenInt').val('');
				$('#cargosRecientes').val('');
				$('#pagoMinimo').val('');
				$('#pagos').val('');
				$('#fechaLimPago').val('');
				$('#saldoCorte').val('');
				$('#proximoCorte').val('');
				$('#pagos').val('');
				$('#cargosRecientes').val('');
				$('#saldoFavor').val('');
				$('#creditoDisponible').val('');
				$('#saldoFecha').val('');
				$('#limiteCredito').val('');
				$('#interes').val('');
				$('#comisiones').val('');
				$('#tipoTarjetaDebID').val('');
				$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
				$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
                deshabilitaBoton('consultar','submit');
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
				
		}
	
	}

	function listaPeriodos(lineaCreditoID) {
		
		var motivoBean = {
			'lineaTarjetaCredID' : lineaCreditoID
		};			 	
		tCPeriodoLineaServicio.lista(1,motivoBean, function(motivos){
			dwr.util.removeAllOptions('fechaPeriodo'); 
			dwr.util.addOptions('fechaPeriodo', {'':'SELECCIONAR'});
			dwr.util.addOptions('fechaPeriodo', motivos, 'fechaCorte', 'fechaCorte');
			$("#fechaPeriodo option[value="+ anioActual +"]").attr("selected",true);
			$("#mesPeriodo option[value="+ mesSistema +"]").attr("selected",true);
		});
	}	

	
	//Consulta de Cliente Corporativo
	function consultaTarCoorpo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(coorporativo)>0  && !isNaN(coorporativo) ) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {
					$('#coorporativo').val(cliente.numero);
					$('#nombreCoorp').val(cliente.nombreCompleto);
				} else {
					alert("No Existe el Corporativo relacionado.");
					$('#coorporativo').val('');
					$('#nombreCoorp').val('');
				}
			});
		}else{
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
		}
	}
	
	//Generar la consulta del movimiento en PDF
$('#generar').click(function() {
	var tr = catTipoRepMovimiento.PDF;
	var reporte = 1;
	var tarjetaID = $("#tarjetaID").val();
	var anioPeriodo = $("#fechaPeriodo option:selected").val();
	var mesPeriodo = $("#mesPeriodo option:selected").val();
	var fechaEmision = parametroBean.fechaSucursal;
	var nombreUsuario = parametroBean.claveUsuario; 
	var nombreInstitucion =  parametroBean.nombreInstitucion;
	var numRegistros = ($('#miTabla >tbody >tr').length ) -1;
	if (numRegistros > 0) {
		$('#ligaGenerar').attr('href','reporteMovimientosTarCred.htm?'+'&tarjetaID='+tarjetaID+'&anioPeriodo='+anioPeriodo+'&mesPeriodo='+mesPeriodo+
			'&numeroReporte='+reporte+'&tipoReporte='+tr+'&fechaEmision='+fechaEmision+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&nombreInstitucion='+nombreInstitucion);
    }else {
		mensajeSis("No Existen Movimientos a Exportar");
		$('#ligaGenerar').removeAttr('href');
	}
});	
 

	//Grid para mostrar los movimientos realizados con la tarjeta de credito
	function consultaMovimientoTarjetasCred(){
		var tarjetaID = $("#tarjetaID").val();
		var anioPeriodo = $("#fechaPeriodo option:selected").val();
		var mesPeriodo = $("#mesPeriodo option:selected").val();
		if (tarjetaID != '' ){
			var params = {};
			params['tipoLista'] = 1;
			params['tarjetaID'] = tarjetaID;
			params['anioPeriodo'] = anioPeriodo;
			params['mesPeriodo'] = mesPeriodo;
			
			$.post("gridConsultaMovimientosCred.htm", params, function(data){
				if(data.length >0) {
					$('#gridConsultaMovimientos').html(data);
					$('#gridConsultaMovimientos').show();
					$('#generar').show();
					var contador = 0;
					var jqMontoID ="";
					$('input[name=montoGrid]').each(function() {	
						contador = contador + 1;
						jqMontoID = eval("'#monto"+contador+"'");
						$(jqMontoID).formatCurrency({
									positiveFormat: '%n', 
									roundToDecimalPlace: 2	
						});
					});
					agregaFormatoControles('formaGenerica');
				}else{
					$('#gridConsultaMovimientos').html("");
					$('#gridConsultaMovimientos').show();
					agregaFormatoControles('formaGenerica');
				}
			});
		}else{
			$('#gridConsultaMovimientos').hide();
			$('#gridConsultaMovimientos').html('');
			}
			 	
	}
});
function limpiarCampos() {
	$('#tarjetaID').val('');
	$('#clienteID').val('');
	$('#descripcion').val('');
	$('#nombreCompleto').val('');
	$('#cuentaAhoID').val('');
	$('#tipoCuentaID').val('');
	$('#descripcionProd').val('');
	$('#productoID').val('');
	$('#tipoTarjetaDebID').val('');
	$('#nombreTarjeta').val('');
	$('#gridConsultaMovimientos').html("");
	$('#gridConsultaMovimientos').hide();
	$('#generar').hide();
	$('#saldoInicial').val('');
	$('#pagoNoGenInt').val('');
	$('#cargosRecientes').val('');
	$('#pagoMinimo').val('');
	$('#pagos').val('');
	$('#fechaLimPago').val('');
	$('#saldoCorte').val('');
	$('#proximoCorte').val('');
	$('#saldoFavor').val('');
	$('#creditoDisponible').val('');
	$('#saldoFecha').val('');
	$('#limiteCredito').val('');
	$('#interes').val('');
	$('#comisiones').val('');
	$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
	$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);

}

//funcion que se ejecuta cuando el resultado fue exito
	function funcionExitoMovimiento(){
			$('#tarjetaID').focus();
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#tarjetaID').focus();
			$('#gridConsultaMovimientos').hide();
			$('#generar').hide();
			$('#saldoFavor').val('');
			$('#creditoDisponible').val('');
			$('#saldoFecha').val('');
			$('#limiteCredito').val('');
			$('#interes').val('');
			$('#comisiones').val('');
			$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
			$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
			deshabilitaBoton('consultar','submit');	
}

// funcion que se ejecuta cuando el resultado fue error
	function funcionErrorMovimiento(){
			$('#tarjetaID').focus();
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#tarjetaID').focus();
			$('#gridConsultaMovimientos').hide();
			$('#generar').hide();
			$('#saldoFavor').val('');
			$('#creditoDisponible').val('');
			$('#saldoFecha').val('');
			$('#limiteCredito').val('');
			$('#interes').val('');
			$('#comisiones').val('');
			$("#fechaPeriodo option[value="+ '' +"]").attr("selected",true);
			$("#mesPeriodo option[value="+ 0 +"]").attr("selected",true);
			deshabilitaBoton('consultar','submit');	
}
