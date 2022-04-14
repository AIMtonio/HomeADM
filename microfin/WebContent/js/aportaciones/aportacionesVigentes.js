$(document).ready(function(){
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();	
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
		
	iniciaPantalla();
	consultaTiposAportaciones();
	consultaSucursal();
	agregaFormatoControles('formaGenerica');
 
	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#reporte').val(2);
	$('#tipoReporte').focus();
	$('#trFechaFin').hide();
	
	$('#formaGenerica').validate({
		rules:{
			tipoReporte:{
				required: true
			},
			fechaReporte:{
				required: true
			},
			fechaIncio:{
				required: true
			},
			fechaFin:{
				required: true
			},
			fechaReporte:{
				required : true
			},
			tiposAportaciones:{
				required: true
			},
			promotorID:{
				required: true
			},
			sucursalID:{
				required: true
			},
			clienteID:{
				required: true
			}
		},
		messages:{
			tipoReporte:{
				required: 'Especifique Tipo Reporte'
			},
			fechaReporte:{
				required: 'Especifique Fecha de Reporte'
			},
			fechaFin:{
				required: 'Especifique Fecha Fin'
			},
			estatus:{
				required: 'Especifique Estatus'
			},
			tiposAportaciones:{	
				required: 'Especifique un Tipo de Aportación'
			},
			promotorID:{
				required: 'Especifique un Promotor'
			},
			sucursalID:{
				required:'Especifique una Sucursal'
			},
			clienteID:{
				required:'Especifique un Cliente'
			}
		}
		
	});
	
	$('#clienteID').bind('keyup',function(e){
		var promotorID =  $('#promotorID').val();
		var sucursalID =  $('#sucursalID').val();
		
		var camposLista = new Array();		
		var parametrosLista = new Array();		
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		
		if(!isNaN(promotorID) && promotorID!=''){
			if(parseFloat(promotorID)>0){
				camposLista[1] = "sucursalID";
				parametrosLista[1] = $('#promotorID').val();
				lista('clienteID', '2', '36', camposLista, parametrosLista, 'listaCliente.htm');
			}else{
				if(parseFloat(sucursalID)>0){					
					camposLista[1] = "sucursalID";
					parametrosLista[1] = sucursalID;
					camposLista[0] = "clienteID";
					lista('clienteID', '2', '16', camposLista, parametrosLista, 'listaCliente.htm');
				}else{
					camposLista[0] = "nombreCompleto";
					lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
				}
			}
			
		}
		
	});

	$('#clienteID').blur(function() {
		if(esTab){
			consultaCliente(this.id);
		}
	});	
	
	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor',$('#promotorID').val(), 'listaPromotores.htm');
	});
	
	$('#promotorID').blur(function(){	
		if(esTab){
			consultaPromotor(this.id);
		}	
		
	});


	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#excel').attr("checked",false);
		$('#reporte').val(2);
	});
	
	$('#excel').click(function() {
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#reporte').val(3);
		$('#lista').val(9);
	});


	$('#generar').click(function() {	
          if($('#pdf').is(':checked')){
				reportePDF();
			}else if($('#excel').is(':checked')){
				reporteEXCEL();
			}			
		

	});
	
	/* Mostrar ocultar campos para tipo reporte */
	$('#tipoReporte').change(function() {
		var fechaReporte = $('#fechaReporte').val();
		var value = $('#tipoReporte').val();
		
		if(value == '1') {
			$('#lblFechaReporte').text('Fecha');
			$('#trFechaFin').hide();
			$('#fechaFin').val(fechaReporte);
		} else {
			$('#trFechaFin').show();
			$('#lblFechaReporte').text('Fecha Inicio');
		}
		
	});

	 /*REPORTE PDF pasar 3 parámetros nuevos*/
    function reportePDF(){ 
    	var tipoReporte  		= $('#reporte').val();
    	var tipoReport			= $('#tipoReporte').val();
    	var fechaReporte 		= $('#fechaReporte').val();
    	var fechaFin			= $('#fechaFin').val();
    	var estatus				= $('#estatus').val();
		var tipoAportaciones 	= $('#tiposAportaciones').val();		
		var promotor  	 		= $('#promotorID').val();		
		var sucursal  	 		= $('#sucursalID').val();		
		var cliente	  	 		= $('#clienteID').val();	
		var usuario 	 		= parametroBean.claveUsuario;
		
		$('#ligaGenerar').attr('href','reporteAportacionesVigentes.htm?tipoReporte='+tipoReporte+'&numReporte='+tipoReport+'&fechaApertura='+fechaReporte+
								'&finalDate='+fechaFin+'&estatus='+estatus+
								'&tipoAportacionID='+tipoAportaciones+'&promotorID='+promotor+'&sucursalID='+sucursal+'&clienteID='+cliente+
								'&nombreUsuario='+usuario.toUpperCase()+'&nombreInstitucion='+parametroBean.nombreInstitucion+
								'&fechaEmision='+parametroBean.fechaSucursal);	
    }

/*REPORTE EXCEL*/
     function reporteEXCEL(){
     	var tipoLista      		= $('#lista').val();
     	var tipoReporte    		= $('#reporte').val();
     	var tipoReport			= $('#tipoReporte').val();
    	var fechaReporte   		= $('#fechaReporte').val();
    	var fechaFin			= $('#fechaFin').val();
    	var estatus				= $('#estatus').val();
		var tipoAportaciones	= $('#tiposAportaciones').val();		
		var promotor  	   		= $('#promotorID').val();		
		var sucursal  	   		= $('#sucursalID').val();		
		var cliente	  	   		= $('#clienteID').val();
		var nombreSucursal 		= $("#sucursalID option:selected").text();
		var nombreAportacion    = $("#tiposAportaciones option:selected").text(); 
		var nombreCliente  		= $('#nombreCliente').val();
        var nombrePromotor 		= $('#nombrePromotor').val();
        
//        para poder lograr el match debe tener el mismo nombre que en el bean
		
		$('#ligaGenerar').attr('href','reporteAportacionesVigentes.htm?tipoReporte='+tipoReporte+'&numReporte='+tipoReport+'&fechaApertura='+fechaReporte+
								'&finalDate='+fechaFin+'&estatus='+estatus+
								'&tipoAportacionID='+tipoAportaciones+'&promotorID='+promotor+'&sucursalID='+sucursal+'&clienteID='+cliente+
								'&nombreUsuario='+parametroBean.claveUsuario+'&nombreInstitucion='+parametroBean.nombreInstitucion+
								'&fechaEmision='+parametroBean.fechaSucursal+'&tipoLista='+tipoLista+'&nombreSucursal='+nombreSucursal+
								'&descripcion='+nombreAportacion+'&nombreCompleto='+nombreCliente+'&nombrePromotor='+nombrePromotor);	
     }
	
	function consultaTiposAportaciones(){
		var tipoCon=2;
		dwr.util.removeAllOptions('tiposAportaciones');
		dwr.util.addOptions( 'tiposAportaciones', {'0':'TODOS'});
		tiposAportacionesServicio.listaCombo(tipoCon, function(tiposAportaciones){
			dwr.util.addOptions('tiposAportaciones', tiposAportaciones, 'tipoAportacionID', 'descripcion');			
		});
	}
	
	function consultaTiposAportaciones(){
		var tipoCon=2;
		dwr.util.removeAllOptions('tiposAportaciones');
		dwr.util.addOptions( 'tiposAportaciones', {'0':'TODOS'});
		tiposAportacionesServicio.listaCombo(tipoCon, function(tiposAportaciones){
			dwr.util.addOptions('tiposAportaciones', tiposAportaciones, 'tipoAportacionID', 'descripcion');			
		});
	}
	
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	

	$('#fechaReporte').change(function(){
		var Xfecha		= $('#fechaReporte').val();
		var fechaMin	= '1900-01-01';
		var tipoReporte = $('#tipoReporte').val();
		
		/* validación fecha */
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaReporte').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			/* verifica si fecha es mayor a la fecha de aplicación */
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha Inicial es Mayor a la Fecha del Sistema");
				$('#fechaReporte').val(parametroBean.fechaSucursal);				
				regresarFoco('fechaReporte');
			}else{
				if(!esTab){
					regresarFoco('fechaReporte');
				}				
			}
			/* verifica que no sea menor a 1900-01-01 */
			if(mayor(fechaMin, Xfecha)) {
				mensajeSis("La Fecha Inicial debe ser mayor a 1900-01-01");
				$('#fechaReporte').val(parametroBean.fechaSucursal);				
				regresarFoco('fechaReporte');
			}
		}else{
			$('#fechaReporte').val(parametroBean.fechaSucursal);
			regresarFoco('fechaReporte');
		}
			
		// asignar fechaFin
		if (tipoReporte == '1') {
			$('#fechaFin').val(Xfecha);
			console.log('fechaFin: ', $('#fechaFin').val());
		}
		
	});
	
	
	$('#fechaFin').change(function() {
		var inicio  = $('#fechaReporte').val();
		var fin     = $('#fechaFin').val();
		
		if(mayor(inicio, fin)) {
			mensajeSis("La fecha Inicio es mayor a la Fecha Fin");
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
		regresarFoco('fechaFin');
	});
	

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) ){
			if(numCliente == 0){
				$('#clienteID').val('0')	;	
				$('#nombreCliente').val('TODOS');
			}else{
				clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);																								
				}else{
						mensajeSis("No Existe el Cliente");
						$('#clienteID').val('0')	;	
						$('#nombreCliente').val('TODOS');
						$('#clienteID').focus();
					}    	 						
				});
			}	
		}else{
			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
		}
	}
	
	function fechaHoy() {
		var fecha = new Date();
		function pad(mes) { return mes < 10 ? ('0'+mes) : mes}
		
		return (fecha.getFullYear() + '-' + pad(fecha.getMonth() + 1) + '-' +fecha.getDate());
	}
	
	function iniciaPantalla(){
		$('#fechaReporte').val(parametroBean.fechaSucursal);
		$('#fechaFin').val(parametroBean.fechaSucursal);
		$('#clienteID').val('0');
		$('#nombreCliente').val('TODOS');
		$('#promotorID').val('0');
		$('#nombrePromotor').val('TODOS');
	}
	
	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotor').val('TODOS');			
			$('#sucursalID').val(0);
			habilitaControl('sucursalID');
		}else if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotor').val(promotor.nombrePromotor); 
						$('#sucursalID').val(promotor.sucursalID);
						deshabilitaControl('sucursalID');
						$('#clienteID').focus();
					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('TODOS');
						$('#promotorID').focus();
						$('#sucursalID').val(0);
						habilitaControl('sucursalID');
					}    	 						
				});
			}else{
				$('#promotorID').val('0');
				$('#nombrePromotor').val('TODOS');
				$('#sucursalID').val(0);
				habilitaControl('sucursalID');
			}
	}
	
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
	
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
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