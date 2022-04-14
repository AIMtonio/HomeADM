$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums 
	
	agregaFormatoControles('formaGenerica');
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#sucursalID').val(parametroBean.sucursal);
	validaSucursal1();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#usuario').bind('keyup',function(e){
		lista('usuario', '2', '1', 'nombreCompleto', $('#usuario').val(), 'listaUsuarios.htm');
	});
	
	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '2', '1', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});
	

	$('#sucursalID').blur(function() { 
		if($('#sucursalID').asNumber()>"0"){
			validaSucursal1();
		}else{
			$('#sucursalID').val(parametroBean.sucursal);
			validaSucursal1();
		}
		
	});

	$('#usuario').blur(function() {
		if($('#usuario').asNumber()>"0"){
			validaUsuario(this);
		}else{
			$('#nombreUsuario').val("TODOS");
			$('#usuario').val('0');
		}
	});	
	
	$('#producCreditoID').blur(function() { 
		if($('#producCreditoID').asNumber()>"0"){
			validaProductoCredito(this.id); 
		}else{
			$('#nombreProducto').val("TODOS");
			$('#producCreditoID').val('0');
		}
  		

	});
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaSucursal;
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha Indicada es Mayor a la Fecha Actual.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#generar').click(function() {	
		var usuario = $('#usuario').val();
		var sucursalID=$('#sucursalID').val();
		var producCreditoID=$('#producCreditoID').val();
		var nombreUsuario=$('#nombreUsuario').val();
		var nombreSucursal1=$('#nombreSucursal1').val();
		var nombreProducto	=$('#nombreProducto').val();
		var nombreInstitucion=parametroBean.nombreInstitucion;
		var tipoCredito=$('#tipoCredito').val();
		var fecha=$('#fechaInicio').val();
			$('#ligaGenerar').attr('href','reporteCredOtorgados.htm?usuario='+usuario+ '&sucursalID='+sucursalID+
														'&producCreditoID='+producCreditoID+'&fechaInicio='+fecha+'&nombreInstitucion='+nombreInstitucion+ 
														'&nomUsuario='+parametroBean.claveUsuario+'&fechaEmision='+parametroBean.fechaSucursal+
														'&nombreProducto='+nombreProducto+'&nombreUsuario='+nombreUsuario+'&nombreSucursal1='+nombreSucursal1+
														'&tipoCredito='+tipoCredito);

	});


	//------------ Validaciones de la Forma -------------------------------------	

	$('#formaGenerica').validate({

		rules: {
		
		},
		messages: {
			
		}		
	});


	//------------ Validaciones de Controles -------------------------------------
	//Consulta el Nombre de La Sucursal Inicial
	function validaSucursal1() {
		var principal=1;
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
						$('#nombreSucursal1').val(sucursal.nombreSucurs);
				}else{
					alert("No Existe la Sucursal");
					$('#sucursalID').focus();
					$('#sucursalID').val(parametroBean.sucursal);
					validaSucursal1();
				} 
				});
			}
		}	

	function validaUsuario(control) {
		var numUsuario = $('#usuario').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};	
				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
						$('#nombreUsuario').val(usuario.nombreCompleto);				
					}else{
						alert("No Existe el Usuario");
						$('#usuario').val("0"),
						$('#nombreUsuario').val("TODOS");														
					}
				});						
		}
	}
	
	
	
	function validaProductoCredito(control) {
		var numProdCredito = $('#producCreditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCredito != '' && !isNaN(numProdCredito) && esTab){
				var prodCreditoBeanCon = { 
  				'producCreditoID':$('#producCreditoID').val()
				};
				productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
					}else{ 
						alert("El Producto de Crédito no Existe");
						$('#producCreditoID').val("0"),
						$('#nombreProducto').val("TODOS");				
					}
				}); 
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
				alert("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha Introducida Errónea");
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
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

});