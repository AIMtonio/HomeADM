$(document).ready(function() {
	esTab = true;
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var catTransaccionLimiteTarDeb = {
		'agregar':'1',
		'modificar':'2'
	}; 
	
	var catLimiteTarjetaDebido = {
		'limiteTarDeb' :12 
	};
	 
	deshabilitaBoton('agregar','submit');
	deshabilitaBoton('modificar','submit');
	agregaFormatoControles('formaGenerica');
	$('#tipoTarjetaD').focus();
	$(':text').focus(function() {
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) {
	   	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tarjetaDebID', 'funcionExitoLimiteTarDeb','funcionErrorLimiteTarDeb');
		}
	});
	
	$('#agregar').click(function() {
			$('#tipoTransaccion').val(catTransaccionLimiteTarDeb.agregar);
	});
	
	$('#modificar').click(function() {
			$('#tipoTransaccion').val(catTransaccionLimiteTarDeb.modificar);
	});
	
	$('#coorporativo').blur(function() {
		consultaTarCoorpo(this.id);
	});
	$('#tarjetaDebID').blur(function() {
		if($('#tarjetaDebID').val() != ''){
			if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
				consultaTarjeta();	
			}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
				consultaTarjetaCre();
			}
		}else{
			$('#tipoTarjetaD').focus();
		}
	});

	$('#tipoTarjetaD').click(function() {
		limpiarFormulario();
		$('#tarjetaDebID').val('');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modificar', 'submit');
		$('#tipoTarjetaC').attr("checked",false);
		$('#cteCorpTr').hide();
		$('#cuentaAsociada').show();
	});

	$('#tipoTarjetaC').click(function() {
		limpiarFormulario();
		$('#tarjetaDebID').val('');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modificar', 'submit');
		$('#tipoTarjetaD').attr("checked",false);
		$('#cteCorpTr').show();
		$('#cuentaAsociada').hide();
	});

	$('#tipoTarjetaD').blur(function() {
		$('#tipoTarjetaC').focus();
	});
	$('#tipoTarjetaC').blur(function() {
		$('#tarjetaDebID').focus();
	});


	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#tarjetaDebID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			camposLista[0] = "tarjetaDebID";
			parametrosLista[0] = $('#tarjetaDebID').val();
			if(this.value.length >= 2  && isNaN($('#tarjetaDebID').val())){
				lista('tarjetaDebID', '1', '11',camposLista, parametrosLista,'tarjetasDevitoLista.htm');	
			}
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			camposLista[0] = "tarjetaDebID";
			parametrosLista[0] = $('#tarjetaDebID').val();
			lista('tarjetaDebID', '1', '11',camposLista,parametrosLista,'tarjetasCreditoLista.htm');
		}
	});

	$('#montoMaxDia').blur(function () {
		var montoMes = $('#montoMaxMes').asNumber();
		var montoDia = $(this).asNumber();
		if (montoDia > montoMes && montoMes != '') {
			mensajeSis("El Monto Máximo de Disposición Diario No puede ser Mayor al Monto Máximo Mensual");
			$(this).focus();
		}
	});

	$('#montoMaxMes').blur(function () {
		var montoMes = $(this).asNumber();
		var montoDia = $('#montoMaxDia').asNumber();
		if (montoDia > montoMes && montoMes != '') {
			mensajeSis("El Monto Máximo de Disposición Mensual No puede ser Menor al Monto Maximo Diario");
			$(this).focus();
		}
	});
	
$('#montoMaxCompraDia').blur(function () {
		var montoMes = $('#montoMaxComprasMensual').asNumber();
		var montoDia = $(this).asNumber();
		if (montoDia > montoMes && montoMes != '') {
			mensajeSis("El Monto Máximo de Compra Diario No puede ser Mayor al Monto Máximo Mensual");
			$(this).focus();
		}
	});

	$('#montoMaxComprasMensual').blur(function () {
		var montoMes = $(this).asNumber();
		var montoDia = $('#montoMaxCompraDia').asNumber();
		if (montoDia > montoMes && montoMes != '') {
			mensajeSis("El Monto Máximo de Compra Mensual No puede ser Menor al Monto Maximo Diario");
			$(this).focus();
		}
	});	
	
	

	//------------ Validaciones de Controles -------------------------------------
	function consultaTarjeta() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
	
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID) && esTab) {

			limitesTarDebIndividualServicio.consulta(catLimiteTarjetaDebido.limiteTarDeb, TarjetaDebitoCon,function(limitesTarDeb){
				if(limitesTarDeb !=null ){	
					$('#tarjetaDebID').val(limitesTarDeb.tarjetaDebID);
					$('#estatus').val(limitesTarDeb.estatus);
					$('#clienteID').val(limitesTarDeb.clienteID);
					$('#nombreCompleto').val(limitesTarDeb.nombreCompleto);
					$('#coorporativo').val(limitesTarDeb.coorporativo);
					$('#cuentaAho').val(limitesTarDeb.cuentaAho);
					$('#nombreTipoCuenta').val(limitesTarDeb.nombreTipoCuenta);
					$('#tipoTarjetaDebID').val(limitesTarDeb.tipoTarjetaDebID);
					$('#nombreTarjeta').val(limitesTarDeb.nombreTarjeta);  
					if(limitesTarDeb.identificacionSocio=='S'){
						mensajeSis('El Número de Tarjeta es de Identificación.');
						$('#tarjetaDebID').focus();
						$('#tarjetaDebID').val('');
						$('#estatus').val('');
						$('#clienteID').val('');
						$('#nombreCompleto').val('');
						$('#coorporativo').val('');
						$('#cuentaAho').val('');
						$('#nombreTipoCuenta').val('');
						$('#nombreTarjeta').val('');
						$('#tipoTarjetaDebID').val('');
						$('#nombreTarjeta').val('');
						$('#nombreCoorp').val('');
						deshabilitaBoton('agregar','submit');
						deshabilitaBoton('modificar','submit');
					}
					if (limitesTarDeb.coorporativo == 0 || limitesTarDeb.coorporativo == '' || limitesTarDeb.coorporativo == null) {
						$('#cteCorpTr').hide();
					}else {
						$('#cteCorpTr').show();
						consultaTarCoorpo('coorporativo');
					}
					consultaLimiteTarDeb('tarjetaDebID');
				}else  {
					mensajeSis("La Tarjeta No Existe");
					$('#tarjetaDebID').focus();
					$('#tarjetaDebID').val('');
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#cuentaAho').val('');
					$('#nombreTipoCuenta').val('');
					$('#nombreTarjeta').val('');
					$('#tipoTarjetaDebID').val('');
					$('#nombreTarjeta').val('');
            	$('#nombreCoorp').val('');
            	deshabilitaBoton('agregar','submit');
            	deshabilitaBoton('modificar','submit');
				}
			});
		}else if(isNaN(tarjetaDebID)){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#montoMaxDia').val('');
			$('#montoMaxMes').val('');
			$('#montoMaxCompraDia').val('');
			$('#montoMaxComprasMensual').val('');
			$('#bloqueoATM').val('');
			$('#bloqueoPOS').val('');
			$('#bloqueoCashback').val('');
			$('#vigencia').val('');
			$('#operacionesMOTO').val('');
			$('#disposicionesDía').val('');
			$('#tarjetaDebID').focus();
			deshabilitaBoton('agregar','submitz');
			deshabilitaBoton('modificar','submit');
		}
		else if(Number(tarjetaDebID)== ''){
			$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAho').val('');
				$('#nombreTipoCuenta').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaDebID').val('');
				$('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
            $('#montoMaxDia').val('');
				$('#montoMaxMes').val('');
				$('#montoMaxCompraDia').val('');
				$('#montoMaxComprasMensual').val('');
				$('#bloqueoATM').val('');
				$('#bloqueoPOS').val('');
				$('#bloqueoCashback').val('');
				$('#vigencia').val('');
				$('#operacionesMOTO').val('');
				$('#disposicionesDía').val('');
				deshabilitaBoton('agregar','submit');
				deshabilitaBoton('modificar','submit');
		}
	}




	function consultaTarjetaCre() {
		var tarjetaDebID =$('#tarjetaDebID').val();
		var TarjetaDebitoCon = {
			'tarjetaDebID': $('#tarjetaDebID').val()
		};
	
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(tarjetaDebID) != ''  && !isNaN(tarjetaDebID) && esTab) {

			tarjetaCreditoServicio.consulta(9, TarjetaDebitoCon,function(limitesTarCred){
				if(limitesTarCred !=null ){	
					$('#tarjetaDebID').val(limitesTarCred.tarjetaDebID);
					$('#estatus').val(limitesTarCred.descripcion);
					$('#clienteID').val(limitesTarCred.clienteID);
					$('#nombreCompleto').val(limitesTarCred.nombreCompleto);
					$('#coorporativo').val(limitesTarCred.coorporativo);
					$('#cuentaAho').val(limitesTarCred.cuentaAho);
					$('#nombreTipoCuenta').val(limitesTarCred.nombreTipoCuenta);
					$('#tipoTarjetaDebID').val(limitesTarCred.tipoTarjetaDebID);
					$('#nombreTarjeta').val(limitesTarCred.nombreTarjeta);  
					if(limitesTarCred.identificacionSocio=='S'){
						mensajeSis('El Número de Tarjeta es de Identificación.');
						$('#tarjetaDebID').focus();
						$('#tarjetaDebID').val('');
						$('#estatus').val('');
						$('#clienteID').val('');
						$('#nombreCompleto').val('');
						$('#coorporativo').val('');
						$('#cuentaAho').val('');
						$('#nombreTipoCuenta').val('');
						$('#nombreTarjeta').val('');
						$('#tipoTarjetaDebID').val('');
						$('#nombreTarjeta').val('');
						$('#nombreCoorp').val('');
						deshabilitaBoton('agregar','submit');
						deshabilitaBoton('modificar','submit');
					}
					if (limitesTarCred.coorporativo == 0 || limitesTarCred.coorporativo == '' || limitesTarCred.coorporativo == null) {
						$('#cteCorpTr').hide();
					}else {
						$('#cteCorpTr').show();
						consultaTarCoorpo('coorporativo');
					}
					consultaLimiteTarCre('tarjetaDebID');
				}else  {
					mensajeSis("La Tarjeta No Existe");
					$('#tarjetaDebID').focus();
					$('#tarjetaDebID').val('');
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#cuentaAho').val('');
					$('#nombreTipoCuenta').val('');
					$('#nombreTarjeta').val('');
					$('#tipoTarjetaDebID').val('');
					$('#nombreTarjeta').val('');
            	$('#nombreCoorp').val('');
            	deshabilitaBoton('agregar','submit');
            	deshabilitaBoton('modificar','submit');
				}
			});
		}else if(isNaN(tarjetaDebID)){
			$('#tarjetaDebID').val('');
			$('#estatus').val('');
			$('#tarjetaHabiente').val('');
			$('#nombreCli').val('');
			$('#coorporativo').val('');
			$('#nomCorp').val('');
			$('#motivoBloqID').val('');
			$('#descripcion').val('');
			$('#montoMaxDia').val('');
			$('#montoMaxMes').val('');
			$('#montoMaxCompraDia').val('');
			$('#montoMaxComprasMensual').val('');
			$('#bloqueoATM').val('');
			$('#bloqueoPOS').val('');
			$('#bloqueoCashback').val('');
			$('#vigencia').val('');
			$('#operacionesMOTO').val('');
			$('#disposicionesDía').val('');
			$('#tarjetaDebID').focus();
			deshabilitaBoton('agregar','submitz');
			deshabilitaBoton('modificar','submit');
		}
		else if(Number(tarjetaDebID)== ''){
			$('#tarjetaDebID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAho').val('');
				$('#nombreTipoCuenta').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaDebID').val('');
				$('#nombreTarjeta').val('');
            $('#nombreCoorp').val('');
            $('#montoMaxDia').val('');
				$('#montoMaxMes').val('');
				$('#montoMaxCompraDia').val('');
				$('#montoMaxComprasMensual').val('');
				$('#bloqueoATM').val('');
				$('#bloqueoPOS').val('');
				$('#bloqueoCashback').val('');
				$('#vigencia').val('');
				$('#operacionesMOTO').val('');
				$('#disposicionesDía').val('');
				deshabilitaBoton('agregar','submit');
				deshabilitaBoton('modificar','submit');
		}
	}








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
					mensajeSis("No Existe el Corporativo Relacionado.");
					$('#coorporativo').val('');
					$('#nombreCoorp').val('');
				}
			});
		}else{
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
		}
	}
	
	
	function consultaLimiteTarDeb(idControl) {
		var TarjetaDebitoCon = {
				'tarjetaDebID': $('#tarjetaDebID').val()
			};
		var tarjetaDebID =$('#tarjetaDebID').val();
		var consulLimiteTarDeb = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(tarjetaDebID)!='' && !isNaN(tarjetaDebID) ) {
			limitesTarDebIndividualServicio.consulta(consulLimiteTarDeb, TarjetaDebitoCon,function(limite) {
				if (limite != null) {
					$('#montoMaxDia').val(limite.montoMaxDia);
					$('#montoMaxMes').val(limite.montoMaxMes);
					$('#montoMaxCompraDia').val(limite.montoMaxCompraDia);
					$('#montoMaxComprasMensual').val(limite.montoMaxComprasMensual);
					$('#bloqueoATM').val(limite.bloqueoATM);
					$('#bloqueoPOS').val(limite.bloqueoPOS);
					$('#bloqueoCashback').val(limite.bloqueoCashback);
					$('#vigencia').val(limite.vigencia);
					$('#operacionesMOTO').val(limite.operacionesMOTO);
					$('#disposicionesDia').val(limite.disposicionesDia);
					$('#numConsultaMes').val(limite.numConsultaMes);
					$('#montoMaxDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxMes').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxCompraDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxComprasMensual').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					deshabilitaBoton('agregar','submit');
					habilitaBoton('modificar','submit');
				} else {
					$('#montoMaxDia').val('');
					$('#montoMaxMes').val('');
					$('#montoMaxCompraDia').val('');
					$('#montoMaxComprasMensual').val('');
					$('#bloqueoATM').val('');
					$('#bloqueoPOS').val('');
					$('#bloqueoCashback').val('');
					$('#vigencia').val('');
					$('#operacionesMOTO').val('');
					$('#disposicionesDía').val('');
					habilitaBoton('agregar','submit');
					deshabilitaBoton('modificar','submit');  
				}
			});	
		}	
	}
	function consultaLimiteTarCre(idControl) {
		var TarjetaDebitoCon = {
				'tarjetaCredID': $('#tarjetaDebID').val()
			};
		var tarjetaDebID =$('#tarjetaDebID').val();
		var consulLimiteTarDeb = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(tarjetaDebID)!='' && !isNaN(tarjetaDebID) ) {
			limitesTarCreIndividualServicio.consulta(consulLimiteTarDeb, TarjetaDebitoCon,function(limite) {
				if (limite != null) {
					$('#montoMaxDia').val(limite.montoMaxDia);
					$('#montoMaxMes').val(limite.montoMaxMes);
					$('#montoMaxCompraDia').val(limite.montoMaxCompraDia);
					$('#montoMaxComprasMensual').val(limite.montoMaxComprasMensual);
					$('#bloqueoATM').val(limite.bloqueoATM);
					$('#bloqueoPOS').val(limite.bloqueoPOS);
					$('#bloqueoCashback').val(limite.bloqueoCashback);
					$('#vigencia').val(limite.vigencia);
					$('#operacionesMOTO').val(limite.operacionesMOTO);
					$('#disposicionesDia').val(limite.disposicionesDia);
					$('#numConsultaMes').val(limite.numConsultaMes);
					$('#montoMaxDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxMes').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxCompraDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoMaxComprasMensual').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					deshabilitaBoton('agregar','submit');
					habilitaBoton('modificar','submit');
				} else {
					$('#montoMaxDia').val('');
					$('#montoMaxMes').val('');
					$('#montoMaxCompraDia').val('');
					$('#montoMaxComprasMensual').val('');
					$('#bloqueoATM').val('');
					$('#bloqueoPOS').val('');
					$('#bloqueoCashback').val('');
					$('#vigencia').val('');
					$('#operacionesMOTO').val('');
					$('#disposicionesDía').val('');
					habilitaBoton('agregar','submit');
					deshabilitaBoton('modificar','submit');  
				}
			});	
		}	
	}


	$('#formaGenerica').validate({
		rules : {
			tipoTarjetaDebID: {
				required : true
			},
			montoMaxDia: {
				required: true,
				number: true,
			},
			montoMaxMes: {
				required: true,
				number: true,
			},
			montoMaxCompraDia: {
				required: true,
				number: true,
			},
			montoMaxComprasMensual: {
				required: true,
				number: true,
			},
			bloqueoATM: {
				required: true,
			},
			bloqueoPOS: {
				required:true,
			},
			bloqueoCashback: {
				required:true,
			},
			operacionesMOTO: {
				required: true,
				},
			disposicionesDia: {
				required: true,
				number: true
			},
			numConsultaMes :{
				required: true,
				number: true
			},
			vigencia: {
				required : true
			}

		},
		messages : {
			tipoTarjetaDebID:{
				required: 'Especificar el Tipo de Tarjeta.'
			},
			montoMaxDia: {
		    	required: 'Especificar el Monto Max. Disp. Diario.',
				number: 'Sólo Números',
		    },
		    montoMaxMes: {
		    	required: 'Especificar el Monto Max. Disp. Mensual.',
				number: 'Sólo Números',
			},
			montoMaxCompraDia: {
		    	required: 'Especificar el Monto Max. Compra Diario.',
				number: 'Sólo Números',
			},
			montoMaxComprasMensual: {
		    	required: 'Especificar el Monto Max. Compra. Mensual.',
				number: 'Sólo Números',
			},
			bloqueoATM: {
				required: "Especificar el Tipo de Bloqueo ATM"
			},
			bloqueoPOS: {
				required: "Especificar el Tipo de Bloqueo POS"
			},
			bloqueoCashback: {
				required: "Especificar el Tipo de Bloqueo"
			},
			operacionesMOTO: {
				required: "Especificar la Operacion",
			},
			disposicionesDia: {
		    	required: 'Especificar el número de Disposiciones',
				number: 'Sólo Números',
			},
			numConsultaMes :{
				required: 'Especificar el Núm Consultas Mensual',
				number: 'Sólo Números'
			},
			vigencia:{
				required: 'Especificar la Fecha de Vigencia'
			}
		}
	});
});
var parametroBean = consultaParametrosSession(); 
function validaFecha(){
	if (esFechaValida($('#vigencia').val())) {
			$('#vigencia').val(parametroBean.fechaSucursal);
			$('#vigencia').focus();
			$('#vigencia').select();
	}
}


//funcion que valida fecha 
function esFechaValida(fecha){
	var fecha2 = parametroBean.fechaSucursal;
	if(fecha == ""){return false;}
	if (fecha != undefined  ){
		
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de fecha no válido (aaaa-mm-dd)");
			return true;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;
		var mes2=  fecha2.substring(5, 7)*1;
		var dia2= fecha2.substring(8, 10)*1;
		var anio2= fecha2.substring(0,4)*1;
		if(anio<anio2 || anio==anio2&&mes<mes2 || anio==anio2&&mes==mes2&&dia<dia2 ){
			mensajeSis("La Vigencia No Debe Ser Menor a la Fecha Actual.");
			return true;
		}
		
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
		return true;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return true;
		}
		return false;
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
//funcion que se ejecuta cuando el resultado fue exito
function funcionExitoLimiteTarDeb(){
	
	$('#tarjetaDebID').focus();
	
	$('#estatus').val('');
	$('#clienteID').val('');
	$('#nombreCompleto').val('');
	$('#coorporativo').val('');
	$('#cuentaAho').val('');
	$('#nombreTipoCuenta').val('');
	$('#nombreTarjeta').val('');
	$('#tipoTarjetaDebID').val('');
    $('#nombreTarjeta').val('');
    $('#nombreCoorp').val('');
    $('#montoMaxDia').val('');
	$('#montoMaxMes').val('');
	$('#montoMaxCompraDia').val('');
	$('#montoMaxComprasMensual').val('');
	$('#bloqueoATM').val('');
	$('#bloqueoPOS').val('');
	$('#bloqueoCashback').val('');
	$('#vigencia').val('');
	$('#operacionesMOTO').val('');
	$('#disposicionesDia').val('');
	$('#numConsultaMes').val('');
    deshabilitaBoton('agregar','submit');
    deshabilitaBoton('modificar','submit');
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero

function funcionErrorLimiteTarDeb(){	
}
function limpiarFormulario(){
	$('#estatus').val('');
	$('#clienteID').val('');
	$('#nombreCompleto').val('');
	$('#coorporativo').val('');
	$('#cuentaAho').val('');
	$('#nombreTipoCuenta').val('');
	$('#nombreTarjeta').val('');
	$('#tipoTarjetaDebID').val('');
    $('#nombreTarjeta').val('');
    $('#nombreCoorp').val('');
    $('#montoMaxDia').val('');
	$('#montoMaxMes').val('');
	$('#montoMaxCompraDia').val('');
	$('#montoMaxComprasMensual').val('');
	$('#bloqueoATM').val('');
	$('#bloqueoPOS').val('');
	$('#bloqueoCashback').val('');
	$('#vigencia').val('');
	$('#operacionesMOTO').val('');
	$('#disposicionesDia').val('');
	$('#numConsultaMes').val('');
}