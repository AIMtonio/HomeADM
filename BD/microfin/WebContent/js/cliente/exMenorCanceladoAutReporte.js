$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;	
	var parametroBean=consultaParametrosSession();
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);

	agregaFormatoControles('formaGenerica');
	
	$('#pdf').attr("checked",true) ; 
	
	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#sucursalIni').val(parametroBean.sucursal);
	$('#sucursalFin').val(parametroBean.sucursal);
	$('#nombreSucIni').val(parametroBean.nombreSucursal);
	$('#nombreSucFin').val(parametroBean.nombreSucursal);

	$('#sucursalIni').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalIni', '2', '4', 'nombreSucurs', $('#sucursalIni').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalFin').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalFin', '2', '4', 'nombreSucurs', $('#sucursalFin').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalIni').blur(function() {
		var sucFin = $('#sucursalFin').val();
		var sucIni = $('#sucursalIni').val();
		if (sucFin != '' && !isNaN(sucFin) && sucFin	!= 0 ){
			if (parseInt(this.value) > parseInt(sucFin) ){
				alert('La Sucursal Inicial debe Ser Menor o Igual a la Sucursal Final');
				$(this).val('');
				$('#nombreSucIni').val('');
				$(this).focus();
			}
		}
		validaSucursal1();
	});

	$('#sucursalFin').blur(function() {
		var sucIni = $('#sucursalIni').val();
		var sucFin = $('#sucursalFin').val();
		if (sucIni != '' && !isNaN(sucIni)){
			if (parseInt(sucFin) != 0 && parseInt(sucIni) == 0) {
				alert('La Sucursal Inicial debe Ser Diferente de Cero');
				$('#sucursalIni').focus();
			}else if (parseInt(sucIni) > parseInt(this.value)  ){
				alert('La Sucursal Final debe Ser Mayor o Igual a la Sucursal Inicial');
				$(this).val('');
				$('#nombreSucFin').val('');				
				$(this).focus();
			}else {
				validaSucursal2();
			}
		}
		
	});
	
	
	
	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '2','clienteID', $('#clienteID').val(), 'listaExMenores.htm');
	});

	$('#clienteID').blur(function() {
		validaCliente('clienteID');
	});
	
	$('#generar').click(function() {
		if (validaSucursales()==true) {
			if($('#pdf').is(":checked") ){
				generaPDF();
			}
			if($('#excel').is(":checked") ){
				generaExcel();
			}
		}
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
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
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});

		
	$('#sucursalIni').blur(function(){
		if($('#sucursalIni').val() == ''){
			$('#sucursalIni').val(0);
			$('#nombreSucIni').val('TODAS');			
		}
	});
	
	$('#sucursalFin').blur(function(){
		if($('#sucursalFin').val() == ''){
			$('#sucursalFin').val(0);
			$('#nombreSucFin').val('TODAS');			
		}
		
	});
	
	$('#clienteID').blur(function(){
		if($('#clienteID').val() == ''){
			$('#clienteID').val(0);
			$('#nombreExMenor').val('TODOS');			
		}
	});
	
	//funcion para validar cliente
	function validaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		var principal=1;
		setTimeout("$('#cajaLista').hide();", 200);
		var ExMenorBeanCon = {
				'clienteID' : numCliente
			};
		if ($('#clienteID').val()=='0'){
			$('#nombreExMenor').val('TODOS');
			$('#clienteID').val('0');
		}else{
			if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteExMenorServicio.consulta(principal, ExMenorBeanCon, function(cliente) {
				if (cliente != null) {
					if(cliente.estatusRetiro !=null){
					consultaCliente('clienteID');
					}else{
						alert("No Existe Información del Socio Consultado");
						$('#clienteID').focus();					
						$('#nombreExMenor').val('TODOS');
						$('#clienteID').val('0');
					}
				} else {
					alert("No Existe Información del Socio Consultado");
					$('#clienteID').focus();					
					$('#nombreExMenor').val('TODOS');
					$('#clienteID').val('0');
					
					}
				});
			}
		}
	}
	
	function validaSucursales() {
		var sucFin = $('#sucursalFin').val();
		var sucIni = $('#sucursalIni').val();
		if (sucFin != '' && !isNaN(sucFin) && sucFin	!= 0 ){
			if (parseInt(sucIni) > parseInt(sucFin) ){
				alert('La Sucursal Inicial debe Ser Menor o Igual a la Sucursal Final');
				$('#sucursalFin').val('');
				$('#nombreSucIni').val('');
				$('#sucursalFin').focus();
				$('#ligaGenerar').removeAttr('href');
				return false;
			}else{
				return true;
			}
		}
	
		if (sucIni != '' && !isNaN(sucIni)){
			if (parseInt(sucFin) != 0 && parseInt(sucIni) == 0) {
				alert('La Sucursal Inicial debe Ser Diferente de Cero');
				$('#sucursalIni').focus();
				$('#ligaGenerar').removeAttr('href');
				return false;
			}else if (parseInt(sucIni) > parseInt(sucFin)  ){
				alert('La Sucursal Final debe Ser Mayor o Igual a la Sucursal Inicial');
				$('#ligaGenerar').removeAttr('href');
				$('#sucursalFin').val('');
				$('#nombreSucFin').val('');				
				$('#sucursalFin').focus();
				return true;
			}
		}
		if (sucIni == 0 && sucFin == 0 ) {
			return true;	
		}			
	}
	
	//funcion para consultar nombre del cliente
	function consultaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteServicio.consulta(conCliente, numCliente, function(cliente) {
				if (cliente != null) {
					$('#nombreExMenor').val(cliente.nombreCompleto);
					$('#generar').focus();		
				} else {
					alert("No Existe el Cliente");
					$('#clienteID').focus();					
					$('#nombreExMenor').val('TODOS');
					$('#clienteID').val('0');
					
				}
			});
		}
	}
	
	
	//FUNCION PARA GENERAR EL REPORTE EN PDF
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tipoReporte= 2; 
			var clienteID = $('#clienteID').val();
			var fechaInicial = $('#fechaInicio').val();
			var fechaFinal = $('#fechaFin').val();
			var sucursalInicial = $('#sucursalIni').val();
			var sucursalFinal = $('#sucursalFin').val();
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nomCliente=$('#nombreExMenor').val();
			var nomSucursalInicial=$('#nombreSucIni').val();
			var nomSucursalFinal=$('#nombreSucFin').val();
			$('#ligaGenerar').attr('href','repExMenorCancelado.htm?clienteID='+clienteID+
					'&fechaInicial='+fechaInicial+'&fechaFinal='+fechaFinal+
					'&sucursalInicial='+sucursalInicial+'&sucursalFinal='+sucursalFinal+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&nombreCompleto='+nomCliente+'&nomSucursalInicial='+
					nomSucursalInicial+'&nomSucursalFinal='+nomSucursalFinal);
		}
	}
	
	// FUNCION PARA GENERAR EL REPORTE EN EXCEL
	function generaExcel() {
		
		if($('#excel').is(':checked')){	
			$('#pdf').attr("checked",false) ;
			var tipoReporte= 3;
			var clienteID = $('#clienteID').val();
			var fechaInicial = $('#fechaInicio').val();
			var fechaFinal = $('#fechaFin').val();
			var sucursalInicial = $('#sucursalIni').val();
			var sucursalFinal = $('#sucursalFin').val();
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;	
			var nombreInstitucion=parametroBean.nombreInstitucion;
			var nombreExMenor=$('#nombreExMenor').val();
			var nomSucursalInicial=$('#nombreSucIni').val();
			var nomSucursalFinal=$('#nombreSucFin').val();
			var horaEmision=hora();
			
			$('#ligaGenerar').attr('href','repExMenorCancelado.htm?clienteID='+clienteID+
					'&fechaInicial='+fechaInicial+'&fechaFinal='+fechaFinal+
					'&sucursalInicial='+sucursalInicial+'&sucursalFinal='+sucursalFinal+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&nombreCompleto='+nombreExMenor+'&nomSucursalInicial='+
					nomSucursalInicial+'&nomSucursalFinal='+nomSucursalFinal+'&horaEmision='+horaEmision);
			
		}
	}
	//Consulta el Nombre de La Sucursal Inicial
	function validaSucursal1() {
		var principal=1;
		var numSucursal = $('#sucursalIni').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			if(numSucursal==0){
				$('#nombreSucIni').val("TODAS");
			}else{
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucIni').val(sucursal.nombreSucurs);
				}else{
					alert("No Existe la Sucursal");
					$('#sucursalIni').focus();
					$('#sucursalIni').val('0');
					$('#nombreSucIni').val('TODAS');		
					} 
				});
			}
		}	
	}
	//Consulta el Nombre de La Sucursal Final
	function validaSucursal2() {
		var principal=1;
		var numSucursal = $('#sucursalFin').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			if(numSucursal==0){
				$('#nombreSucFin').val("TODAS");
			}else{
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucFin').val(sucursal.nombreSucurs);
				}else{
					alert("No Existe la Sucursal");
					$('#sucursalFin').focus();
					$('#sucursalFin').val('0');
					$('#nombreSucFin').val('TODAS');		
					} 
				});
			}
		}	
	}



//	VALIDACIONES PARA LAS FECHAS INGRESADAS
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
	
	// funcion para obtener la hora del sistema
	function hora(){
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		
		 if (minutes<=9)
			 minutes="0"+minutes;
		 if (seconds<=9)
			 seconds="0"+seconds;
		return  hours+":"+minutes+":"+seconds;
	 }		
		
});