$(document).ready(function() {
	var parametros = consultaParametrosSession();

	agregaFormatoControles('formaGenerica');				
	$('#fechaInicio').val(parametros.fechaSucursal);
	$('#fechaFin').val(parametros.fechaSucursal);
	$('#pdf').attr('checked',true);
	$('#tipoReporte').val('1');
	$('#sucursalID').val('0');
	$('#nombreSucursal').val('TODAS');
	$('#productoCreditoID').val('0');	
	$('#nombreProductoCredito').val('TODOS');	
	$('#fechaInicio').focus();

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#productoCreditoID').bind('keyup',function(e) {
		lista('productoCreditoID', '2', '1','descripcion', $('#productoCreditoID').val(),'listaProductosCredito.htm');
	});

	$('#productoCreditoID').blur(function() {

			consultaProducCredito(this.id);

		
	});

	$('#sucursalID').blur(function() {
			validaSucursal();
	});
	
	$('#generar').click(function(event){		
		generaPdf();
	});
	
	$('#excel').click(function(event){		
		$('#tipoReporte').val('2');
		$('#pdf').attr('checked',false);

	});
	
	$('#pdf').click(function(event){		
		$('#tipoReporte').val('1');
		$('#excel').attr('checked',false);
	});

	function consultaProducCredito(idControl) {				
	var jqProdCred  = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();			
	var ProdCredBeanCon = {
			'producCreditoID':ProdCred 
	}; 
	setTimeout("$('#cajaLista').hide();", 200);
	if(ProdCred != '' && !isNaN(ProdCred) && ProdCred != '0'){		
		productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
			if(prodCred!=null && prodCred.producCreditoID != '0'){
				$('#nombreProductoCredito').val(prodCred.descripcion);							
			}else{
				mensajeSis("El Producto de Crédito no Existe.");
				$('#productoCreditoID').val('0');	
				$('#nombreProductoCredito').val('TODOS');	
				$(jqProdCred).focus();	
			}
		});
	}	
	else{
		$('#productoCreditoID').val('0');	
		$('#nombreProductoCredito').val('TODOS');	
	}			 					
	} 

	function validaSucursal() {
	var principal=1;
	numSucursal=$('#sucursalID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numSucursal != '' && !isNaN(numSucursal) && numSucursal != '0'){
		sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
			if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);

			}else{
				mensajeSis("No Existe la Sucursal.");
				$('#sucursalID').focus();
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			} 
			});
		}
		else{
			$('#sucursalID').val('0');
			$('#nombreSucursal').val('TODAS');
		}
	}	

	function generaPdf() {	
		var fechaSis = parametros.fechaSucursal;
		var nombreUsuario = parametros.claveUsuario; 
		var nombreInstitucion = parametros.nombreInstitucion;	
		var sucursalID=($('#sucursalID').val()!='0')?$('#sucursalID').val():'';
		var productoCreID=($('#productoCreditoID').val()!='0')?$('#productoCreditoID').val():'';
		
		$('#ligaGenerar').attr('href','RenovacionesCreRepFira.htm?FechaInicial='+$('#fechaInicio').val()
				+'&FechaFinal='+$('#fechaFin').val()+'&SucursalID='+sucursalID
				+'&ProductoCredito='+productoCreID+'&FechaSistema='+fechaSis
				+'&NombreInstitucion='+nombreInstitucion+'&ClaveUsuario='+nombreUsuario
				+'&tipoReporte='+$('#tipoReporte').val()
				+'&NombreSucursal='+$('#nombreSucursal').val()
				+'&NombreProductoCredito='+$('#nombreProductoCredito').val());	
	}


	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha= parametros.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicio').focus();
				$('#fechaInicio').val(parametros.fechaSucursal);
			}
			else{
				if (mayor(Xfecha, Zfecha) ){
					mensajeSis("La Fecha Inicial es Mayor a la Fecha Actual.");
					$('#fechaInicio').focus();
					$('#fechaInicio').val(parametros.fechaSucursal);
			}
				else{
					$('#fechaFin').focus();
				}
			}
		}else{
			$('#fechaInicio').focus();
			$('#fechaInicio').val(parametros.fechaSucursal);			
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaFin').change(function() {
		var Xfecha= parametros.fechaSucursal;
		var Yfecha= $('#fechaFin').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametros.fechaSucursal);
			}
			else{
				if ( mayor(Yfecha,Xfecha) ){
					mensajeSis("La Fecha Final es mayor a la Fecha Actual.")	;
					$('#fechaFin').val(parametros.fechaSucursal);
					$('#fechaFin').focus();
				}
				else{
					if ( mayor(Zfecha,Yfecha) ){
						mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
						$('#fechaFin').val(parametros.fechaSucursal);
					}
					else{
						$('#sucursalID').focus();
					}
				}
			}

		}else{
			$('#fechaFin').focus();
			$('#fechaFin').val(parametros.fechaSucursal);
		}
	});

	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd).");
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



});