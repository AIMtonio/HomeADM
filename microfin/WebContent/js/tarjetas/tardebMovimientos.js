$(document).ready(function() {
		var parametroBean = consultaParametrosSession();  
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		
	var catMovimientosTarjeta = {
			'consultaTarjeta' : 17
			
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
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tarjetaDebID',
	    				  'funcionExitoMovimiento','funcionErrorMovimiento');
	      }
	      
	});	
	
	//Obtiene y valida la fecha de inicio
	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});
	
	//Obtiene y valida la fecha de inicio
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		$('#fechaInicio').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio no debe ser mayor a la Fecha Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaInicio').focus();
		}
	});
	
	//Obtiene y valida la fecha final
	$('#fechaVencimiento').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaVencimiento').val(Xfecha);
				$('#fechaVencimiento').focus();
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			$('#fechaVencimiento').focus();
		}
	});
	
	//Obtiene y valida la fecha final
	$('#fechaVencimiento').change(function() {
		$('#fechaVencimiento').focus();
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha Fin no debe ser menor a la Fecha Inicio.");
				$('#fechaVencimiento').val(Xfecha);
				$('#fechaVencimiento').focus();
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			$('#fechaVencimiento').focus();
		}
	});

	$('#tarjetaDebID').blur(function() {
		consultaTarjeta();
	});
	
	$('#consultar').click(function() {
		consultaMovimientoTarjetas();
	});	

	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tarjetaDebID').bind('keyup',function(e){ 
		 if(this.value.length >= 2  && isNaN($('#tarjetaDebID').val())){
		lista('tarjetaDebID', '1', '13','tarjetaDebID', $('#tarjetaDebID').val(),'tarjetasDevitoLista.htm');	
		 }
	});	

	//------------ Validaciones de Controles -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true
			},
			fechaVencimiento:{
				required: true
			},
			tipoOperacion:{
  				required: true
  			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Especifique la Fecha Inicio.'
			},
			fechaVencimiento :{
				required: 'Especifique la Fecha Final.'
			},
			tipoOperacion: {
				required: 'Especifique el Tipo de Operación.'
			},
		}
	});
	
	//Consulta de Tarjetas
	function consultaTarjeta() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		if (Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID) && esTab) {
			tarjetaDebitoServicio.consulta(catMovimientosTarjeta.consultaTarjeta, TarjetaDebitoCon,function(movimientoTar){
			if(movimientoTar !=null   ){
				habilitaBoton('consultar','submit');
				$('#tarjetaDebID').val(movimientoTar.tarjetaDebID);
				$('#descripcion').val(movimientoTar.descripcion);
				$('#clienteID').val(movimientoTar.clienteID);
				$('#nombreCompleto').val(movimientoTar.nombreCompleto);
				$('#coorporativo').val(movimientoTar.coorporativo);
				$('#cuentaAhoID').val(movimientoTar.cuentaAhoID);
				$('#tipoCuentaID').val(movimientoTar.tipoCuentaID);
				$('#tipoTarjetaDebID').val(movimientoTar.tipoTarjetaDebID);
				$('#nombreTarjeta').val(movimientoTar.nombreTarjeta);
				if (movimientoTar.coorporativo == null || movimientoTar.coorporativo == 0 || movimientoTar.coorporativo == ''){
					$('#cteCorpTr').hide();
				}else {
					$('#cteCorpTr').show();
					consultaTarCoorpo('coorporativo');
				}
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
			
				if(movimientoTar.identificacionSocio=='S'){
					mensajeSis('El Número de Tarjeta es de Identificación.');
					$('#tarjetaDebID').focus();
					$('#tarjetaDebID').val('');
					$('#descripcion').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#cuentaAhoID').val('');
					$('#tipoCuentaID').val('');
					$('#nombreTarjeta').val('');
					$('#tipoTarjetaDebID').val('');
	                $('#nombreTarjeta').val('');
	                $('#nombreCoorp').val('');
	                $('#tipoOperacion').val('');
	                $('#fechaInicio').val(parametroBean.fechaSucursal);
	                $('#fechaVencimiento').val(parametroBean.fechaSucursal);
	                deshabilitaBoton('consultar','submit');
					$('#gridConsultaMovimientos').hide();
					$('#generar').hide();
				}
				
			}else  {
				mensajeSis("Número de Tarjeta Inválida");
				$('#tarjetaDebID').focus();
				$('#tarjetaDebID').val('');
				$('#descripcion').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAhoID').val('');
				$('#tipoCuentaID').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaDebID').val('');
                $('#nombreTarjeta').val('');
                $('#nombreCoorp').val('');
                $('#tipoOperacion').val('');
                $('#fechaInicio').val(parametroBean.fechaSucursal);
                $('#fechaVencimiento').val(parametroBean.fechaSucursal);
                deshabilitaBoton('consultar','submit');
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
			}});
		}else if(isNaN(tarjetaDebID)){
			$('#tarjetaDebID').val('');
			$('#descripcion').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
			$('#cuentaAhoID').val('');
			$('#tipoCuentaID').val('');
			$('#tipoTarjetaDebID').val('');
            $('#nombreTarjeta').val('');
			$('#tarjetaDebID').focus();
		    deshabilitaBoton('consultar','submit');

		}
		else if(Number(tarjetaDebID)== ''){
			$('#tarjetaDebID').val('');
				$('#descripcion').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
			    $('#nombreCoorp').val('');
				$('#cuentaAhoID').val('');
				$('#tipoCuentaID').val('');
				$('#tipoTarjetaDebID').val('');
                $('#nombreTarjeta').val('');
                deshabilitaBoton('consultar','submit');
				$('#gridConsultaMovimientos').hide();
				$('#generar').hide();
		}
	
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
					mensajeSis("No Existe el Corporativo relacionado.");
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
		var reporte1 = 1;
		var reporte2 = 2;
		var tarjetaDebID = $("#tarjetaDebID").val();
		var fechaInicio = $("#fechaInicio").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
      var tipoOperacion = $("#tipoOperacion option:selected").val();
		var fechaEmision = parametroBean.fechaSucursal;
		var nombreUsuario = parametroBean.claveUsuario; 
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var numRegistros = ($('#miTabla >tbody >tr').length ) -1;
		if (numRegistros > 0) {
			if(tipoOperacion == '0'){
				$('#ligaGenerar').attr('href','reporteMovimientos.htm?'+'&fechaInicio='+fechaInicio+'&numeroReporte='+reporte2+
						'&fechaVencimiento='+fechaVencimiento+'&tipoOperacion='+tipoOperacion+'&tarjetaDebID='+
						tarjetaDebID+'&tipoReporte='+tr+'&fechaEmision='+fechaEmision+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&nombreInstitucion='+nombreInstitucion);
			}else{
				$('#ligaGenerar').attr('href','reporteMovimientos.htm?'+'&fechaInicio='+fechaInicio+'&numeroReporte='+reporte1+
					'&fechaVencimiento='+fechaVencimiento+'&tipoOperacion='+tipoOperacion+'&tarjetaDebID='+
					tarjetaDebID+'&tipoReporte='+tr+'&fechaEmision='+fechaEmision+'&nombreUsuario='+nombreUsuario.toUpperCase()+'&nombreInstitucion='+nombreInstitucion);
			}
		}else {
			mensajeSis("No Existen Movimientos a Exportar");
			$('#ligaGenerar').removeAttr('href');
		}
	});	
 
	//Grid para mostrar los movimientos realizados con la tarjeta
	function consultaMovimientoTarjetas(){
		var tarjetaDebID = $("#tarjetaDebID").val();
		var fechaInicio = $("#fechaInicio").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
		var tipoOperacion = $("#tipoOperacion option:selected").val();
		if (tarjetaDebID != '' ){
			var params = {};
			if(tipoOperacion == '0'){
				params['tipoLista'] = 2;	
			}else
			params['tipoLista'] = 1;
			params['tarjetaID'] = tarjetaDebID;
			params['tipoOperacion'] = tipoOperacion;
			params['fechaInicio'] = fechaInicio;
			params['fechaVencimiento'] = fechaVencimiento;
			
			$.post("gridConsultaMovimientos.htm", params, function(data){
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
				
				}else{
					$('#gridConsultaMovimientos').html("");
					$('#gridConsultaMovimientos').show();
					
				}
			});
		}else{
			$('#gridConsultaMovimientos').hide();
			$('#gridConsultaMovimientos').html('');
			}
			 	
	}
	
   //funcion para validar las fechas
	function mayor(fecha, fecha2){
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
				mensajeSis("Formato de Fecha no Válida (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
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
	});


//funcion que se ejecuta cuando el resultado fue exito
	function funcionExitoMovimiento(){
			$('#tarjetaDebID').focus();
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#tarjetaDebID').focus();
			$('#gridConsultaMovimientos').hide();
			$('#generar').hide();
			deshabilitaBoton('consultar','submit');	
}

// funcion que se ejecuta cuando el resultado fue error
	function funcionErrorMovimiento(){
			$('#tarjetaDebID').focus();
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#tarjetaDebID').focus();
			$('#gridConsultaMovimientos').hide();
			$('#generar').hide();
			deshabilitaBoton('consultar','submit');	
}