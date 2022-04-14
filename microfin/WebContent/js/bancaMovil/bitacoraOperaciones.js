$(document).ready(function() {
	// Definicion de constantes, variables y enums
	var esTab = true;

	var maximoValorDecimal = 999999999999.99;

	var Enum_Tipo_Reporte = {
		'pdf' : 1,
		'excel' : 2
	};

	var Enum_Num_Reporte = {
		'principal' : 1
	};

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$('input ,select').blur(function() {
		
		if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout(function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});
	
	$('#clienteID').bind('keyup',function(e){
		
		if ($('#clienteID').val().length < 3) {
			$('#cajaLista').hide();
		} else {
			lista('clienteID', '3', '1','clienteID',$('#clienteID').val(),'listaBAMUsuarios.htm');
		}
		
	});
	
	$('#nombreCliente').val("TODOS");
	
	
	$('#clienteID').blur(function() {
		consultaUsuario(this.id);
	});
	
	$('input').attr({
		'autocomplete' : 'off'
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();
	$('#excel').attr("checked",true);
	$('#clienteID').val(0);
	$('#tipoOperacion').val('TODOS');

	// Metodos y Manejo de Eventos
	agregaFormatoControles('formaGenerica');
	
	consultaTiposOperacion();
	
	$.validator.setDefaults({
		submitHandler: function(event) {
		}
	});
	
	
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			fechaInicio: {
				required: true,
			},
			fechaFin: {
				required: true,
			}
		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente'
			},
			fechaInicio: {
				required: 'Especificar Fecha Inicio',
			},
			fechaFin: {
				required: 'Especificar Fecha Final',
			}
		}		
	});

	// Se valida que la fecha inicio no sea maypr a la del sistema y que no sea mayor a la fecha final
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			var Yfecha= $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha Final.");
				$('#fechaInicio').val($('#fechaFin').val());
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha Actual.");
					$('#fechaInicio').val($('#fechaFin').val());
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		$('#fechaInicio').focus();
	});

	// Se valida que la fecha final del reporte no sea mayor a la del sistema y tampoco mayor a la fecha de inicio
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Xfecha,Yfecha) ){
				mensajeSis("La Fecha Final es Menor a la Fecha de Inicio.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			else{
				if($('#fechaFin').val() > parametroBean.fechaAplicacion) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha Actual.");
					$('#fechaFin').val(parametroBean.fechaAplicacion);
				}
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		$('#fechaFin').focus();
	});


	$('#generar').click(function() {
		
		if(!isNaN($("#clienteID").val())){
			
			if($("#fechaInicio").val() != "" && $("#fechaFin").val() != ""){
				generaExcel();
			}else{
				$("#fechaInicio").valid();
				$("#fechaFin").valid();
			}
			
		}else{
			$("#clienteID").valid();
		}
		
	});
	
	function consultaUsuario(idControl) {
		var usuarioID = $('#clienteID').val();
		if (usuarioID == '0') {
			limpiarDatos();
			$('#nombreCliente').val("TODOS");
		} else {					

			if (usuarioID != '' && !isNaN(usuarioID)) {
				usuariosServicio.consultaUsuarios(1,usuarioID,function(usuarios) {
					if (usuarios != null) {
						$('#nombreCliente').val(usuarios.nombreCompleto);							
					} else {
						mensajeSis("No Existe el usuario");
						limpiarDatos();
						$("#clienteID").focus();
					}
				});
			}else{
				$("#clienteID").val("");
				limpiarDatos();
			}
		}

	}

	
	
	function consultaTiposOperacion() {	
		
		var beanBitacora = {}
		
		var tipoCon = 2;
		dwr.util.removeAllOptions('tipoOperacion'); 
		dwr.util.addOptions( 'tipoOperacion', {'0':'TODOS'});
		bamBitacoraOperServicio.lista(beanBitacora, tipoCon, function(tipos){
			dwr.util.addOptions('tipoOperacion', tipos, 'tipoOperacionID', 'descripcion');
		});
		
	}

	//Funcion para genera Reporte
	function generaExcel(){
		var tipoRep = Enum_Tipo_Reporte.excel;
		var numReporte = Enum_Num_Reporte.principal;
		var usuario = parametroBean.claveUsuario;
		var fecha = parametroBean.fechaSucursal;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var clienteID = $('#clienteID').asNumber();
		var nombreCliente = $('#nombreCliente').val();
		var tipoOperacion = $('#tipoOperacion').asNumber();
		var nomOperacion = $('#tipoOperacion option:selected').text();
		
		var paginaReporte ='reporteBitacoraOperRep.htm?'+
			'tipoRep='+tipoRep+
			'&numReporte='+numReporte+
			'&usuario='+usuario+
			'&nombreInstitucion='+nombreInstitucion+
			'&clienteID='+clienteID+
			'&nombreCliente='+nombreCliente+
			'&tipoOperacion='+tipoOperacion+
			'&descripcionOperaciones='+nomOperacion+
			'&fecha='+fecha+
			'&fechaInicio='+fechaInicio+
			'&fechaFin='+fechaFin;

		$('#ligaGenerar').attr({
			'href':paginaReporte,
			'target':'_blank'
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
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
});

function validadorNumeros(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else
  		return false;
	}
}

function limpiarDatos() {	
	$('#tipoOperacion').val('TODAS');
}



