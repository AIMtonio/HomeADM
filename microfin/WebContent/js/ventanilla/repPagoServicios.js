$(document).ready(function() {
	var esTab = true;
		// ------------ Metodos y Manejo de Eventos
//	deshabilitaBoton('generar', 'submit');	
	agregaFormatoControles('formaGenerica');
	fechaHabilInicio('fechaCargaInicial',parametroBean.fechaSucursal);
	fechaHabilInicio('fechaCargaFinal',parametroBean.fechaSucursal);
	$('#nombreOrigenPago').val("TODOS");
	var parametrosBean = consultaParametrosSession();
	consultaComboSucursales();		
	llenaComboCatalogoServicios();
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','catalogoServID');
	      }
	 });
	$(':text').focus(function() {	
	 	esTab = false;
	});	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	$('#fechaCargaInicial').change(function() {		
		if(!esTab){			
			$('#fechaCargaInicial').focus();
		}
		var Xfecha= $('#fechaCargaInicial').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
				$('#fechaCargaInicial').focus();
			
			}
			var Yfecha= $('#fechaCargaFinal').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
				$('#fechaCargaInicial').focus();
			}
		}else{
			$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
			$('#fechaCargaInicial').focus();
		}
	});
	$('#fechaCargaFinal').change(function() {
		if(!esTab){			
			$('#fechaCargaFinal').focus();
		}
	});	
	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaFinal').blur(function() {
		
		var Xfecha= $('#fechaCargaInicial').val();
		var Yfecha= $('#fechaCargaFinal').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaCargaFinal').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaCargaFinal').val(parametroBean.fechaSucursal);
				$('#fechaCargaFinal').focus();
			}
		}else{
			$('#fechaCargaFinal').val(parametroBean.fechaSucursal);
			$('#fechaCargaFinal').focus();
		}
	});	
	$('#origenPago').change(function(){	
		if($('#origenPago').val()=="T"){
			$('#nombreOrigenPago').val("TODOS");
		}else if($('#origenPago').val()=="B"){
			$('#nombreOrigenPago').val("BANCA ELECTRONICA");
		}else if($('#origenPago').val()=="V"){
			$('#nombreOrigenPago').val("VENTANILLA");
		}
	});
		
	$('#excel').click(function(){
		$('#excel').attr('checked',true);
		$('#pdf').removeAttr('checked');
	});
	$('#pdf').click(function(){
		$('#pdf').attr('checked',true);
		$('#excel').removeAttr('checked');
	});
	
	$('#generar').click(function() {
		var tipoReporte	= 0;				
		var sucursal			= $('#sucursal').val();
		var nombreSucurs		= $('#sucursal option:selected').text();
		var servicio			= $('#servicio').val();
		var nombreServicio		= $('#servicio option:selected').text();
		var fechaCargaInicial 	= $('#fechaCargaInicial').val();
		var fechaCargaFinal 	= $('#fechaCargaFinal').val();
		var origenPago			= $('#origenPago').val();
		var nombreOrigenPago	= $('#nombreOrigenPago').val();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var claveUsuario1		= parametroBean.claveUsuario;
		var fechaactual			= parametroBean.fechaAplicacion;
		if( $('#excel').is(':checked') ){
			tipoReporte = 2;
		}
		if( $('#pdf').is(':checked') ){
			tipoReporte = 1;
		}
		var pagina='repPagoServicios.htm?sucursal='+sucursal+'&nombreSucurs='+nombreSucurs+'&servicio='+servicio+'&nombreServicio='+nombreServicio+
		'&fechaCargaInicial='+fechaCargaInicial+'&fechaCargaFinal='+fechaCargaFinal+
		'&nomInstitucion='+nombreInstitucion+'&claUsuario='+claveUsuario1+'&fecha='+fechaactual+
		'&origenPago='+origenPago+"&nombreOrigenPago="+nombreOrigenPago+"&tipoReporte="+tipoReporte;
		
		window.open(pagina);
	});
	
//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({			
		rules: {
			
			catalogoServID: {
				required: true,
				numeroPositivo: true
			},
			
			nombreServicio: {
				required: true				
			},											
			razonSocial: {
				required : function() {return $('#origen1:checked').val() == 'T';}
			},
			montoServicio: {
				required : function() {return $('#origen2:checked').val() == 'I';},
				numeroPositivo: true
			},
			montoComision: {
				required : function() {return $('#cobraComision1:checked').val() == 'S';},
				numeroPositivo: true		
			},
			
		},		
		messages: {
			nombreServicio: {
				required: 'Especificar nombre del servicio',
				numeroPositivo:'Sólo Números'
			},											
			razonSocial: {
				required :'Ingrese la Razón Social',				
			},
			montoServicio: {
				required :'Ingrese el monto del servicio',				
			},
			catalogoServID: {
				required :'Ingrese el número de Servicio',	
				numeroPositivo:'Sólo Números'
			},
			montoComision: {
				required :'Ingrese el monto de la Comisión',
				numeroPositivo:'Sólo Números'
			}
		}		
	});
	
//-------------------- Métodos------------------
function validarFecha(idcontrol){
		
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var anioFechaSucursal	= valorFechaSucursal.substr(0,4);
		var mesFechaSucursal = valorFechaSucursal.substr(5,2);
		var diaFechaSucursal = valorFechaSucursal.substr(8,2);

		var jqvalorFechaCarga	= eval("'#"+idcontrol+"'");
		var valorFechaCarga 	= $(jqvalorFechaCarga).val();
		if(valorFechaCarga == null || valorFechaCarga == ''){
			return;
		}
		var anioFechaCarga	= valorFechaCarga.substr(0,4);
		var mesFechaCarga = valorFechaCarga.substr(5,2);
		var diaFechaCarga = valorFechaCarga.substr(8,2);
		var separadorUnoFechaCarga = valorFechaCarga.substr(4,1);
		var separadorDosFechaCarga = valorFechaCarga.substr(7,1);

		if(separadorUnoFechaCarga == "-"){
			if(separadorDosFechaCarga == "-"){
				if(anioFechaCarga>anioFechaSucursal){  
					alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
					$(jqvalorFechaCarga).focus().select();
					fechaHabilInicio(idcontrol,valorFechaSucursal);
				}else{
					if(anioFechaCarga==anioFechaSucursal){ 
						if(mesFechaCarga>mesFechaSucursal){ 
							alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
							$(jqvalorFechaCarga).focus().select();
							fechaHabilInicio(idcontrol,valorFechaSucursal);
						}else{
							if(mesFechaCarga==mesFechaSucursal){
								if(diaFechaCarga>diaFechaSucursal){
									alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
									$(jqvalorFechaCarga).focus().select();
									fechaHabilInicio(idcontrol,valorFechaSucursal);	        
								}
							}
						}	
					}
				}
			}else{
				alert("Formato de fecha incorrecto 'aaaa-mm-dd'");
				$(jqvalorFechaCarga).focus().select();
				fechaHabilInicio(idcontrol,valorFechaSucursal);
			}
		}else{
			alert("Formato de fecha incorrecto 'aaaa-mm-dd'");
			$(jqvalorFechaCarga).focus().select();
			fechaHabilInicio(idcontrol,valorFechaSucursal);
		}

	}
	function comparaFechas(idControl,fechaIni,fechaFin){
		var jqControl = eval("'#"+idControl+"'");
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var xYear=fechaIni.substring(0,4);
		var xMonth=fechaIni.substring(5, 7);
		var xDay=fechaIni.substring(8, 10);
		var yYear=fechaFin.substring(0,4);
		var yMonth=fechaFin.substring(5, 7);
		var yDay=fechaFin.substring(8, 10);
		if (yYear<xYear ){
    		alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
    		fechaHabilInicio(idControl,valorFechaSucursal);
    		$(jqControl).focus().select();
    		return false;
		}else{
			if (xYear == yYear){
				if (yMonth<xMonth){
					
					alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
					fechaHabilInicio(idControl,valorFechaSucursal);
					$(jqControl).focus().select();
		    		return false;
				}else{
					if (xMonth == yMonth){
						if (yDay<xDay){
							alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
							fechaHabilInicio(idControl,valorFechaSucursal);
							$(jqControl).focus().select();
	    		    		return false;

						}
					}
				}
			}
		}
	return true;
    }
	function fechaHabilInicio(idcontrol,fecha){
		// solo la fecha del sistema
		var jqControl = eval("'#"+idcontrol+"'");
//		var diaFestivoBean = {
//				'fecha':fecha,
//				'numeroDias':1,
//				'salidaPantalla':'S'
//		};
//		diaFestivoServicio.calculaDiaFestivo(2,diaFestivoBean,function(diaAnt) {
//			if(diaAnt!=null){
//				$(jqControl).val(diaAnt.fecha);
//				
//			}else{
//				$(jqControl).val(parametroBean.fechaSucursal);
//				
//			}
//		});
		$(jqControl).val(parametroBean.fechaSucursal);

	}
	function llenaComboCatalogoServicios() {	
		var tipoCombo = 5;
		catalogoServicios.listaCombo(tipoCombo, function(catalogoServBean){
			dwr.util.removeAllOptions('servicio'); 		
			dwr.util.addOptions('servicio', {'0':'TODOS'});		
			dwr.util.addOptions('servicio', catalogoServBean, 'catalogoServID', 'nombreServicio');
		});
	}
	function consultaComboSucursales(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			if(sucursales != null){
				dwr.util.addOptions('sucursal', {0:'TODOS'});
				dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
			}
		});
	} 	
	
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
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
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

function funcionExitoCatalogo(){
	
	
}
function funcionErrorCatalogo(){
	agregaFormatoMoneda('formaGenerica');
}