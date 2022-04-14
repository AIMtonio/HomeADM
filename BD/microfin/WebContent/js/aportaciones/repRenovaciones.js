var parametroBean = consultaParametrosSession();
$(document).ready(function() { // INICIO DOCUMENT READY

	esTab = false;
	
	inicializaPantalla();
	$("#fechaInicial").focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#fechaInicial').change(function(){
		validaFechaInicio();
	});	

	$('#fechaFinal').change(function(){
		validaFechaFin();
	});

	//VALIDACIONES DE LA FORMA
	$.validator.setDefaults({submitHandler: function(event) {
		   
	}});
	
	$('#formaGenerica').validate({
		rules: {
			
		},		
		messages: {
			
		}
	});
	
	$('#generar').click(function() { 
		if($('#excel').is(":checked") ){
			generaReporte(1);
		}else if($('#pdf').is(":checked") ){
			generaReporte(2);
		}
	});
	
	$('#clienteID').bind('keyup',function(e){		
		var camposLista = new Array();		
		var parametrosLista = new Array();					
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});
	
	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	
	// FUNCION QUE GENERA EL REPORTE EN EXCEL o PDF
	function generaReporte(tipoReporte){
		var tipoLista   	= 1;  
		
		var pagina ='reporteRenovacionApor.htm?'+
							'fechaInicial='+$('#fechaInicial').val()+
							'&fechaFinal='+$('#fechaFinal').val()+
							'&estatus='+$('#estatus').val()+
							'&clienteID='+$('#clienteID').val()+
							'&descEstatus='+$("#estatus option:selected").html()+
							'&nombreCliente='+$("#nombreCliente").val()+
							'&tipoReporte='+tipoReporte+
							'&tipoLista='+tipoLista+
							'&nombreInstitucion='+parametroBean.nombreInstitucion+
							'&claveUsuario='+parametroBean.claveUsuario.toUpperCase()+
							'&fechaSistema='+parametroBean.fechaSucursal;
		window.open(pagina);
	
	}
	
	// CONSULTA CLIENTE
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente > 0 && numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);																								
				}else{
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').val('0')	;	
					$('#nombreCliente').val('TODOS');
					$('#clienteID').focus();
				}    	 						
			});
		} else {
			$('#clienteID').val('0')	;	
			$('#nombreCliente').val('TODOS');
		}
	}

	$('#pdf').change(function(){
		if($('#pdf').is(":checked") ){
			document.getElementById("excel").checked = false;
		}
	});

	$('#excel').change(function(){
		if($('#excel').is(":checked") ){
			document.getElementById("pdf").checked = false;
		}
	});
}); //FIN DOCUMENT READY

function inicializaPantalla(){
	inicializaForma('formaGenerica','fechaInicial');
	agregaFormatoControles('formaGenerica');
	$('#fechaInicial').val(parametroBean.fechaAplicacion);
	$('#fechaFinal').val(parametroBean.fechaAplicacion);	
	$('#estatus').val('');		
	$('#clienteID').val('0');	
	$('#nombreCliente').val('TODOS');	
	document.getElementById("excel").checked = false;
	document.getElementById("pdf").checked = true;
}

function validaFechaInicio(){
	var fechaInicio= $('#fechaInicial').val();
	var fechaFin= $('#fechaFinal').val();
	var fechaSis= parametroBean.fechaSucursal;
	
	if(esFechaValida(fechaInicio)){
		if( mayor(fechaInicio, fechaSis)){
			mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha del Sistema");
			$('#fechaInicial').val(fechaSis);
			$('#fechaFinal').val(fechaSis);
			$('#fechaInicial').focus();
		}else{
			if( mayor(fechaInicio, fechaFin)){
				mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha Final")	;
				$('#fechaInicial').val(fechaFin);
				$('#fechaInicial').focus();
			}else{
				$('#fechaInicial').focus();
			}
		}
	}else{
		$('#fechaInicial').val(fechaFin);
		$('#fechaInicial').focus();
	}
}

function validaFechaFin(){
	var fechaInicio= $('#fechaInicial').val();
	var fechaFin= $('#fechaFinal').val();
	var fechaSis= parametroBean.fechaSucursal;
	
	if(esFechaValida(fechaFin)){
		if( mayor(fechaFin, fechaSis)){
			mensajeSis("La Fecha de Fin no Puede ser Mayor a la Fecha del Sistema");
			$('#fechaFinal').val(fechaSis);
			$('#fechaFinal').focus();
		}else{
			if( mayor(fechaInicio, fechaFin)){
				mensajeSis("La Fecha de Fin no Puede ser Menor a la Fecha de Inicio")	;
				$('#fechaFinal').val(fechaInicio);
				$('#fechaFinal').focus();
			}else{
				$('#fechaFinal').focus();						
			}
		}
	}else{
		$('#fechaFinal').val(fechaSis);
		$('#fechaFinal').focus();
	}
}



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


function mayor(fecha, fecha2){ 
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var fecInicioMes=fecha.substring(5, 7);
	var fecInicioDia=fecha.substring(8, 10);
	var fecInicioAnio=fecha.substring(0,4);

	var fecFinMes=fecha2.substring(5, 7);
	var fecFinDia=fecha2.substring(8, 10);
	var fecFinAnio=fecha2.substring(0,4);



	if (fecInicioAnio > fecFinAnio){
		return true;
	}else{
		if (fecInicioAnio == fecFinAnio){
			if (fecInicioMes > fecFinMes){
				return true;
			}
			if (fecInicioMes == fecFinMes){
				if (fecInicioDia > fecFinDia){
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


//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
} 