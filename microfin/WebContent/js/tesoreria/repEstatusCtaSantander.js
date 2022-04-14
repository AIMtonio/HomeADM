/**
 * 
 */
$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
	inicializarPantalla();
	$('#excel').attr("checked",true) ; 
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if(mayor(Yfecha,parametroBean.fechaSucursal)){
				alert("La Fecha de Fin es mayor a la Fecha del Sistema.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});
	
	$('#solicitudCreditoID').bind('keyup',function(e){  
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "clienteID";
		 	parametrosLista[0] = $('#solicitudCreditoID').val();
					
			lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}	
	});
	
	
	$('#solicitudCreditoID').blur(function() {
		if(isNaN($('#solicitudCreditoID').val()) ){
			$('#solicitudCreditoID').val("");
			$('#solicitudCreditoID').focus();
		 }else{ 
			 var longitudSolicitud=$('#solicitudCreditoID').val().length;
			 var credito=$('#solicitudCreditoID').val();
			 if(longitudSolicitud>11){
				 credito=credito.substring(0,11);
				 $('#solicitudCreditoID').val(credito);
			 }
			 validaSolicitudCredito('solicitudCreditoID');
		}
	});
	
	
	$('#sucursalID').bind('keyup', function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	
	$('#generar').click(function() {
		generaReporte();
	});
	
});

function inicializarPantalla() {
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#solicitudCreditoID').val("");
	$('#sucursalID').val("0");
	$('#nombreSucursal').val("TODAS");
	$('#estatus').val("");
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').focus();
}



function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal)) {
		sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#sucursalID').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			} else {
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	}
}

function validaSolicitudCredito(idControl) {
	var jqSolicitud  = eval("'#" + idControl + "'");
	var solCred = $(jqSolicitud).val();	
		var SolCredBeanCon = {
			'solicitudCreditoID':solCred, 
		}; 
		if(solCred != '' && !isNaN(solCred) &&solCred!='0'){
		setTimeout("$('#cajaLista').hide();", 200);
		solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon,function(solicitud) {
			if(solicitud!=null){
				if(solicitud.solicitudCreditoID !=0){
					
				}else{
					mensajeSis("La Solicitud de Crédito No Existe.");					
					$('#solicitudCreditoID').focus();
					
				}
			}else{ 
				alert("La Solicitud de Crédito No Existe.");					
				
				$('#solicitudCreditoID').focus();
				
			}					
		});
	}						 				
}


function generaReporte() {
	if ($("#formaGenerica").valid()) {
		var lista_Campos = "";
		var lista_ValoresMostrar = "";
		var arrayCampos=['Solicitud','Estatus','Sucursal'];
		
		for (var i = 0; i < arrayCampos.length; i++) { 
			lista_Campos += "&campos=" + arrayCampos[i];
		}
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFin").val();
		var sucursal = $("#sucursalID").asNumber();
		var nombreSucursal = $("#nombreSucursal").val();
		var estatus = $("#estatus").val();
		var estatusDes = $("#estatus option:selected").text();
		var solicitudCreditoID = $('#solicitudCreditoID').val();
		var solicitudCreditoDes = $('#solicitudCreditoID').val();
		
		if(solicitudCreditoID == ''){
			solicitudCreditoID = '0';
			solicitudCreditoDes = 'TODAS';
		}
		lista_Campos += "&valorCampos=" + solicitudCreditoDes;
		lista_Campos += "&valorCampos=" + estatusDes;
		lista_Campos += "&valorCampos=" + sucursal + " - " + nombreSucursal;
		
		lista_Campos += "&valorParam=" + fechaInicio;
		lista_Campos += "&valorParam=" + fechaFinal;
		lista_Campos += "&valorParam=" + solicitudCreditoID;
		lista_Campos += "&valorParam=" + estatus;
		lista_Campos += "&valorParam=" + sucursal;
		lista_Campos += "&valorParam=" + 1;

		
		lista_Campos += "&tituloReporte=" + "DEL "+fechaInicio+" AL "+fechaFinal;
		
		var usuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaSistema = parametroBean.fechaAplicacion;
		var liga = 'repDinamico.htm?reporteID=' + 2 + '&tipoReporte=' + 1 + '&usuario=' + usuario + '&nombreInstitucion=' + nombreInstitucion + '&fechaSistema=' + fechaSistema + lista_Campos;
		$('#ligaGenerar').attr('href', liga);
	}
}



//VALIDACIONES PARA LAS PANTALLAS DE REPORTE

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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
//FIN VALIDACIONES DE REPORTES



/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			alert("Formato de Fecha no Válido (aaaa-mm-dd)");
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
			alert("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			alert("Fecha introducida errónea.");
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