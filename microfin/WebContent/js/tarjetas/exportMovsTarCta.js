$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = true;

	var catTipoRepMovimiento = { 
			'PDF' : 1
	};
	var catMovimientosTarjeta = {
			'consultaTarjeta' : 17
			
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
    $('#fechaInicio').focus();


	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({			
	   submitHandler: function(event) { 	    	  
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoOperacion');	   	 
		}
	});

	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		
	});


	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (esFechaValida(Xfecha)) {
			if (Xfecha == '') {
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}

			var Yfecha = $('#fechaVencimiento').val();
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			} else {
				if ($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				} else if ($("#sucursalID").val() == 0) {
					fechaVencimiento = sumaMesesFechaHabil($('#fechaInicio').val(), 1);
					if (fechaVencimiento > parametroBean.fechaSucursal) {
						fechaVencimiento = parametroBean.fechaSucursal;
					}
					if ($('#fechaVencimiento').val() > fechaVencimiento) {
						$('#fechaVencimiento').val(fechaVencimiento);
					}
				}
			}

		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});




	$('#fechaVencimiento').change(function() {
		if (!validacion.esFechaValida($('#fechaInicio').val())) {
			$('#fechaInicio').val('');
			$('#fechaInicio').focus();
		} else {
			var Xfecha = $('#fechaInicio').val();
			var Yfecha = $('#fechaVencimiento').val();
			if (esFechaValida(Yfecha)) {
				if (Yfecha == '') {
					$('#fechaVencimiento').val(parametroBean.fechaSucursal);
				}
				if (mayor(Xfecha, Yfecha)) {
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaVencimiento').val(parametroBean.fechaSucursal);
					$('#fechaVencimiento').focus();
				} else {
					if ($('#fechaVencimiento').val() > parametroBean.fechaSucursal) {
						mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
						$('#fechaVencimiento').val(parametroBean.fechaSucursal);
						$('#fechaVencimiento').focus();
					} else if ($('#sucursalID').asNumber()==0 && $('#fechaVencimiento').val() > fechaVencimiento) {
						$('#fechaVencimiento').val(fechaVencimiento);
					}
				}
			} else {
				$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			}
		}
	});


    $('#cuentaAhoID').bind('keyup',function(e){
				 var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "clienteID";
					camposLista[1]="tipoCuentaID";
					camposLista[2]="institucionID";
					camposLista[3]="cuentaAhoID";
					parametrosLista[0] = $('#clienteID').val();
					parametrosLista[1]='0';
					parametrosLista[2]='0';
					parametrosLista[3]=$('#cuentaAhoID').val();
				listaAlfanumerica('cuentaAhoID', '2', '14', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	
	});
	$('#cuentaAhoID').blur (function(){
		if($('#cuentaAhoID').asNumber()>0){
			consultaCtaAho(this.id);
		}else{
			setTimeout("$('#cajaLista').hide();", 200);
			$('#cuentaAhoID').val('0');
			$('#tipoCuenta').val('TODAS');
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
			}			
		},
		
		messages: {
			fechaInicio :{
				required: 'Especifique la Fecha de Inicio.'
			},
			fechaVencimiento :{
				required: 'Especifique la Fecha Final.'
			}
		}
	});


	//Función que Consulta la Descripción de la Cuenta de Ahorro
	function consultaCtaAho(idControl) {
		var jqCtaAho = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCtaAho
		};
		var conCtaAho = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCtaAho != '' && !isNaN(numCtaAho) && esTab) {
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho) {
				if (ctaAho != null) {
					$('#cuentaAhoID').val(ctaAho.cuentaAhoID);
					consultaCliente(ctaAho.clienteID);
					$('#tarjetaDebID').val("0");
				    $('#nombreCliente').val("TODAS");
				} else {
					mensajeSis("No Existe la Cuenta de Ahorro");

					$(jqCtaAho).focus();
					$('#cuentaAhoID').val("0");
					$('#tipoCuenta').val("TODAS");
					$('#tarjetaDebID').val("0");
				    $('#nombreCliente').val("TODAS");
				    $('#cuentaAhoID').focus();
				}
			});
		}
			$('#cuentaAhoID').val("0");

	}
	//Validacion al generar los reportes en CSV y Excel
	$('#ligaGenerar').click(function(){
		$('#ligaGenerar').removeAttr("href");
        if($('#fechaReporte').val()==''){
				mensajeSis('Especifique una Fecha de Reporte');
				$('#fechaReporte').focus();
		}else{
			generaCSV();
					
		}

	});
     // Lista las tarjetas pertenecientes a la cuenta de ahorro
    $('#tarjetaDebID').bind('keyup',function(e){
		 if(this.value.length >= 2  && isNaN($('#tarjetaDebID').val())){
		 	 			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tarjetaDebID";
			camposLista[1]="tipoCuentaID";
			camposLista[2]="institucionID";
			camposLista[3]="cuentaAhoID";
			parametrosLista[0] = $('#tarjetaDebID').val();
			parametrosLista[1]='0';
			parametrosLista[2]='0';
			parametrosLista[3]=$('#cuentaAhoID').val();

	           lista('tarjetaDebID', '1', '17',camposLista, parametrosLista,'tarjetasDevitoLista.htm');
	        }

		 
	});

	$('#tarjetaDebID').blur(function() {
	    if($('#tarjetaDebID').asNumber()>0){
		consultaTarjeta();
		}else{
			setTimeout("$('#cajaLista').hide();", 200);
			$('#tarjetaDebID').val('0');
			$('#nombreCliente').val('TODAS');
		}
	});
	
	/* Funcion para generar el reporte en CSV */
	function generaCSV(){	
		$('#ligaGenerar').attr('href','reporteExportaMovCtaRep.htm?fechaInicio='+$('#fechaInicio').val()+
				'&fechaVencimiento='+$('#fechaVencimiento').val()+'&cuentaAhoID='+$('#cuentaAhoID').val()+
				'&tarjetaDebID='+$('#tarjetaDebID').val());
	}

	//Función que consulta el Nombre del Cliente
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		varclienteID=idControl;
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
				if(cliente!=null){		
						$('#tipoCuenta').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
					$('#cuentaAhoID').val("0");
					$('#tipoCuenta').val("TODAS");
					$(jqCliente).val('0');
					$('#tarjetaDebID').val("0");
					$('#nombreCliente').val("TODOS");
					
				}    						
			});
		}
	}	

	// Funcion para limipar campos
function lipiaCampos() {
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
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
//	FIN VALIDACIONES DE REPORTES

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


		//Consulta de Tarjetas
	function consultaTarjeta() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
		if (Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID) && esTab) {
			tarjetaDebitoServicio.consulta(catMovimientosTarjeta.consultaTarjeta, TarjetaDebitoCon,function(movimientoTar){
			if(movimientoTar !=null   ){
				$('#tarjetaDebID').val(movimientoTar.tarjetaDebID);
				$('#nombreCliente').val(movimientoTar.nombreCompleto);
			}else  {
				mensajeSis("Número de Tarjeta Inválida");
				$('#tarjetaDebID').focus();
				$('#tarjetaDebID').val("0");
				$('#nombreCliente').val("TODAS");
			}});
		}
      $('#tarjetaDebID').val("0");
	}	
});