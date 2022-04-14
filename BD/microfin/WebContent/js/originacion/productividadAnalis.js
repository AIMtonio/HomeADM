$(document).ready(function() {
	esTab = true;

	var parametroBean = consultaParametrosSession();  

	var catTipoConsulta ={
			'principal':1
	};

	var catTipoReporte ={
			'PDF':1,
			'Excel':2
	};
	
	/* == Métodos y manejo de eventos ====  */
	agregaFormatoControles('formaGenerica');
    var fechaSis = (parametroBean.fechaSucursal);

	$('#pdf').attr("checked",true) ; 

	$(':text').focus(function() {	
		esTab = false;
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);

	$('#fechaInicio').focus();

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '17', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioID').blur(function() {
  		validaUsuario(this);
	});
	
	$('#productoCreditoID').bind('keyup',function(e){
		lista('productoCreditoID', '2', '1', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});
	
	$('#productoCreditoID').blur(function() {
		consultaProducCredito();
	});

	$('#fechaInicio').change(function() {
		var fechaIni=1;
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha, fechaIni)){
			
			if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
			if(Xfecha==''){
				$('#fechaInicio').val(parametros.fechaAplicacion);
			}

		}else{
			$('#fechaInicio').val(parametros.fechaAplicacion);
		}
	});

	$('#fechaFin').change(function() {
		var fechaIni=2;
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha, fechaIni)){
			
			if($('#fechaFin').val() > parametroBean.fechaSucursal) {
				mensajeSis("La Fecha es Mayor a la Fecha del Sistema.");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
			if(Yfecha==''){
				$('#fechaFin').val(parametros.fechaAplicacion);
			}

		}else{
			$('#fechaFin').val(parametros.fechaAplicacion);
		}

	});
 	
	$('#generar').click(function() { 
		imprimir();
	});

	function imprimir(){
		var fechaIni=$('#fechaInicio').val();
		var fechaFin=$('#fechaFin').val();
		var productoCreditoID=$('#productoCreditoID').asNumber();
		var nombreProducto=$('#descripProducto').val();
		var nombreSucursal=$('#nombreSucursal').val();
		var fechaSis = parametroBean.fechaSucursal;
		var nombreUsuario = parametroBean.claveUsuario; 
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var usuarioI = $('#usuarioID').val();
		var nombreCompleto = $('#nombreCompletoC').val();
		var seguir=true;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
		if(fechaFin < fechaIni){
			mensajeSis("La Fecha Final no debe ser menor que la Fecha Inicial.");
			$('#fechaFin').focus();
			seguir=false;
		}
		if(seguir){
			var pagina ='productividadAnalisReporte.htm?fechaInicio='+fechaIni+
			'&fechaFin='+fechaFin+
			'&fechaSistema='+fechaSis+
			'&usuario='+nombreUsuario+
			'&usuarioID='+usuarioI+
			'&nombreCompleto='+nombreCompleto+
			'&nombreInstitucion='+nombreInstitucion+
			'&tipoReporte='+tipoReporte;
			window.open(pagina,'_blank');
		}
	}

	function validaUsuario(control) {
	var numUsuario = $('#usuarioID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numUsuario != '' && !isNaN(numUsuario) && numUsuario!= 0){
			var usuarioBeanCon = {
					'usuarioID':numUsuario
			};
			usuarioServicio.consulta(20,usuarioBeanCon,{ async: false, callback:function(usuario) {
				if(usuario!=null){
					 datosAnalistas = usuario;
                     $('#nombreCompletoC').val(usuario.nombreCompleto);
				}else{
                   mensajeSis("El usuario no es un analista de credito");    
                     $('#usuarioID').focus();
                      $('#nombreCompletoC').val("");
				}

			}});
		
		}
	}

	/**
	 * Consulta del producto de crédito
	 */
	function consultaProducCredito() {
		var producto = $('#productoCreditoID').asNumber();
		var ProdCredBeanCon = {
			'producCreditoID' : producto
		};

		if(producto > 0){
			productosCreditoServicio.consulta(catTipoConsulta.principal, ProdCredBeanCon, function(prodCred) {
				if (prodCred != null) {
					$('#descripProducto').val(prodCred.descripcion);

				} else {
					mensajeSis("No Existe el Producto de Credito.");
					$('#productoCreditoID').val('');
					$('#productoCreditoID').select();
					$('#descripProducto').val('');
				}
			});
		} else if(producto == 0){
			$('#productoCreditoID').val('0');
			$('#descripProducto').val('TODOS');
		}
	}


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){	
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicio').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaInicio').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}
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
				if(fechaIni ==1){				
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicio').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaInicio').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}

			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					mensajeSis("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicio').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaInicio').focus();

				}else{
					mensajeSis("Formato de Fecha Final Incorrecto");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}
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

