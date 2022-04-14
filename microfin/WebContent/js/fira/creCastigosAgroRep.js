$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();   

	var catTipoLisCastigos  = {
			'castigosExcel'	: 1
	};	

	var catTipoReCastigos = { 
			'PDF'		: 2,
			'Excel'		: 3 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	
	consultaSucursal();
	consultaProductoCredito();
	consultaMotivosCastigo();
	$('#promotorID').val(0);
	$('#nombrePromotorI').val('TODOS');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();
	
	
	$('#pdf').attr("checked",true) ;
	$(':text').focus(function() {	
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
	});	

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				if($('#fechaFin').val() !=''){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
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

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});

	$('#generar').click(function() { 
		if($('#pdf').is(":checked") ){
			generaPDF();
		}
		if($('#excel').is(":checked") ){
			generaExcel();
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true,
			},
			fechaFin :{
				required: true
			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Ingrese la Fecha de Inicio',
			}
			,fechaFin :{
				required: 'Ingrese la Fecha Final'
			}
		}
	});

	// Validacion Promotor  Verificar sonculta 
	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor == 0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}else	
			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotorI').val(promotor.nombrePromotor); 

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}    	 						
				});
			}
	}
	
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});



	function consultaProductoCredito() {		
		var tipoCon = 10;
		dwr.util.removeAllOptions('producCreditoID'); 
		dwr.util.addOptions( 'producCreditoID', {'0':'Todos'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('producCreditoID', productos, 'producCreditoID', 'descripcion');
		});
	}

	
	function consultaMotivosCastigo() {	
  		dwr.util.removeAllOptions('motivoCastigoID'); 
  		dwr.util.addOptions('motivoCastigoID', {'0':'Todos'}); 
  		castigosCarteraAgroServicio.listaCombo(1, function(motivosCastigo){
		dwr.util.addOptions('motivoCastigoID', motivosCastigo, 'motivoCastigoID', 'descricpion');
			});
	}
	
	function generaExcel() {
		$('#pdf').attr("checked",false) ;		
		if($('#excel').is(':checked')){	
			var tr= catTipoReCastigos.Excel; 
			var tl= catTipoLisCastigos .castigosExcel;  
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var sucursal = $("#sucursalID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var motivoCastigoID = $("#motivoCastigoID option:selected").val();
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombrePromotor = $('#nombrePromotorI').val();			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreMotivoCastigo	= $("#motivoCastigoID option:selected").val();
			
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			
			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}
			
			if(nombreMotivoCastigo=='0'){
				nombreMotivoCastigo='';
			}else{
				nombreMotivoCastigo = $("#motivoCastigoID option:selected").html();
			}
			
			$('#ligaGenerar').attr('href','ReporteCredCastigosAgro.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+'&producCreditoID='+producto+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&nombreSucursal='+nombreSucursal+
					'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreInstitucion='+nombreInstitucion+'&motivoCastigoID='+motivoCastigoID+	
					'&desMotivoCastigo='+nombreMotivoCastigo+'&tipoLista='+tl	
			);

		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	 
			$('#excel').attr("checked",false); 
			
			var tr= catTipoReCastigos.PDF; 
			
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var sucursal = $("#sucursalID option:selected").val();
			var producto = $("#producCreditoID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var promotorID = $('#promotorID').val();
			var fechaEmision = parametroBean.fechaSucursal;
			var motivoCastigoID = $("#motivoCastigoID option:selected").val();
			
			/// VALORES TEXTO
			var nombreSucursal = $("#sucursalID option:selected").val();
			var nombreProducto = $("#producCreditoID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombrePromotor = $('#nombrePromotorI').val();			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreMotivoCastigo	= $("#motivoCastigoID option:selected").val();
			
			if(nombreSucursal=='0'){
				nombreSucursal='';
			}else{
				nombreSucursal = $("#sucursalID option:selected").html();
			}

			
			if(nombreProducto=='0'){
				nombreProducto='';
			}else{
				nombreProducto = $("#producCreditoID option:selected").html();
			}
			
			if(nombreMotivoCastigo=='0'){
				nombreMotivoCastigo='';
			}else{
				nombreMotivoCastigo = $("#motivoCastigoID option:selected").html();
			}
			
			$('#ligaGenerar').attr('href','ReporteCredCastigosAgro.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&fechaEmision='+fechaEmision+
					'&sucursalID='+sucursal+'&producCreditoID='+producto+'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&promotorID='+promotorID+'&nombreSucursal='+nombreSucursal+
					'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+
					'&nombrePromotor='+nombrePromotor+'&nombreInstitucion='+nombreInstitucion+'&motivoCastigoID='+motivoCastigoID+	
					'&desMotivoCastigo='+nombreMotivoCastigo	
			);


		}
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
	/***********************************/


});
