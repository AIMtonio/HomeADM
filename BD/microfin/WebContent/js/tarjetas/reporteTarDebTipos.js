var catListaTipoTar = {
	'activos' : 5
};


// funcion para llenar el combo de Tipos de Tarjeta

function llenaComboTiposTarjetasDeb(Tarjeta) {
	var tarDebBean = {
			'tipoTarjeta' :'D',
			'tipoTarjetaDebID' : '',
			'tipoTarjeta': Tarjeta
	};
	dwr.util.removeAllOptions('tipoTarjetaDebID');
	dwr.util.addOptions('tipoTarjetaDebID', {'':'TODOS'});
	tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tiposTarjetas){
		dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
	});
}



$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var catTipoRepBloqDesBloqTarDeb = {
			'PDF'		: 1	
	};

	$('#tipoTarjetaDeb').focus();
    $('#tipoTarjetaDeb').attr("checked",false);
    $('#tipoTarjetaCred').attr("checked",false);
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	llenaComboTiposTarjetasDeb();
	agregaFormatoControles('formaGenerica');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
	deshabilitaBoton('generar', 'submit');
	
	$('#pdf').attr("checked",true); 

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
	   	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoTarjetaDebID');	   	 
		}
	});

	$('#fechaRegistro').change(function() {
		$('#fechaVencimiento').focus();
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegistro').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaRegistro').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});


	
	$('#fechaVencimiento').change(function() {
		$('#tipoTarjetaDebID').focus();
		var Xfecha= $('#fechaRegistro').val();
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

	$('#tipoTarjetaDebID').change(function() {
		$('#generar').focus();
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaRegistro :{
				required: true
			},
			fechaVencimiento:{
				required: true
			}			
		},
		
		messages: {
			fechaRegistro :{
				required: 'Especifica la Fecha de Inicio.'
			}
			,fechaVencimiento :{
				required: 'Especifica la Fecha Fin.'
			}
		}
	});


	
	$('#generar').click(function() {
		var fechaRegistro = $("#fechaRegistro").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
		if( fechaRegistro ==''){
			mensajeSis("La fecha Inicio está Vacia");
			$('#fechaRegistro').focus();
			 event.preventDefault();
		}else 
		
			if( fechaVencimiento ==''){
				mensajeSis("La fecha Fin está Vacia");
				$('#fechaVencimiento').focus();

				 event.preventDefault();
		}
		else{
			var tr= catTipoRepBloqDesBloqTarDeb.PDF;
			var tipoTarjetaDebID = $("#tipoTarjetaDebID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var nombreTarjeta=$("#nombreTarjeta ").val();
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			

			if(tipoTarjetaDebID==''){
				tipoTarjetaDebID='0';
			}
		
			if(nombreTarjeta=='0'){
				nombreTarjeta='';
			}
			else{
				nombreTarjeta = $("#tipoTarjetaDebID option:selected").html();
			}


			if($("#tipoTarjetaDeb").is(':checked')) {  
	           $('#ligaGenerar').attr('href','ReporteTarDebTipos.htm?'+'&fechaRegistro='+fechaRegistro+
					'&fechaVencimiento='+fechaVencimiento+'&tipoTarjetaDebID='+tipoTarjetaDebID
					+'&fechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nombreTarjeta='+nombreTarjeta+	
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
	        } 
	        else if($("#tipoTarjetaCred").is(':checked')){
	        	$('#ligaGenerar').attr('href','ReporteTarCredTipos.htm?'+'&fechaRegistro='+fechaRegistro+
					'&fechaVencimiento='+fechaVencimiento+'&tipoTarjetaCredID='+tipoTarjetaDebID
					+'&fechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nombreTarjeta='+nombreTarjeta+	
					'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
	        	
	        }
	        else{  
	           mensajeSis("Selecciona el tipo de tarjeta");
	           limpiaCampos();
	        } 
						
			
		}

		
	});
	
	var parametroBean = consultaParametrosSession(); 
	function validaFecha(){
		if (esFechaValida($('#fechaRegistro').val())) {
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#fechaRegistro').focus();
				$('#fechaRegistro').select();
		}
	}

function limpiaCampos() {
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
	$('#tipoTarjetaDebID').val('');
	deshabilitaBoton('generar', 'submit');


}
$('#tipoTarjetaDeb').click(function() {	
	limpiaCampos();
	$('#tipoTarjetaCred').attr("checked",false);
	$('#fechaRegistro').focus();
	habilitaBoton('generar', 'submit');
	llenaComboTiposTarjetasDeb('D');
	
});
$('#tipoTarjetaCred').click(function() {
	limpiaCampos();	
	$('#tipoTarjetaDeb').attr("checked",false);
	$('#fechaRegistro').focus();
	habilitaBoton('generar', 'submit');
	llenaComboTiposTarjetasDeb('C');

	
});

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

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
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
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