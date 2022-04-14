$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoRepOpVentanilla = { 
			'PDF'		: 1 
	};
	var catTipoConsultaCatalogoAntGastos={
			'principal'  :1
	}
//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	consultaSucursal();
	
	$('#pdf').attr("checked",true) ; 
	
	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#fechaIni').change(function() {
		var Xfecha= $('#fechaIni').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaIni').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaIni').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaIni').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaIni').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});
	$('#cajaID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "cajaID";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#cajaID').val();
		parametrosLista[1] = $('#sucursal').val();
		
		if($('#sucursal').val()>0){
			if(this.value.length >= 2){
				
				lista('cajaID', '2', '6', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
			}
			
		}else{
			   lista('cajaID', '2', '2', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
		
	});
	$('#cajaID').blur(function() {
		consultaCaja(this.id);
		
	});
	$('#sucursal').change(function(){
		if(this.value == 0){
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');
		}else{
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');	
		}
	});
	$('#naturaleza').change(function(){
		if(this.value == 0){
			$('#tipoAntGastoID').val(0);
			$('#descripcion').val('TODOS');
		}else{
			$('#tipoAntGastoID').val(0);
			$('#descripcion').val('TODOS');	
		}
	});
	
	
	$('#tipoAntGastoID').blur(function(){
		if($('#tipoAntGastoID').val()==''){
			$('#tipoAntGastoID').val('0');
			$('#descripcion').val("TODOS");
		}
		CatalogoAntGastos('tipoAntGastoID');
	});
	
	
	$('#tipoAntGastoID').bind('keyup',function(e){		
		if ($('#naturaleza').val()=='E' || $('#naturaleza').val()=='S'){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tipoAntGastoID";
			camposLista[1] = "naturaleza";
			parametrosLista[0] = $('#tipoAntGastoID').val();
			parametrosLista[1] = $('#naturaleza').val();
			
				lista('tipoAntGastoID', '2', '5', camposLista, parametrosLista, 'listaTiposGastos.htm');
			
		}else{
			
				lista('tipoAntGastoID', '2', '1', 'tipoAntGastoID', $('#tipoAntGastoID').val(), 'listaTiposGastos.htm');
				
		}
	});
	
	
	$('#generar').click(function() { 
			generaPDF();

	});


	$('#fechaIni').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	

	function generaPDF() {	

			var tr= 1; 
			var fechaIni = $('#fechaIni').val();	 
			var fechaFin = $('#fechaFin').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var naturaleza= $('#naturaleza').val();
			var nomCaja= $('#nombreCaja').val();
			var nomSucursal= $('#sucursal option:selected').text();
			var operacionCat=$('#tipoAntGastoID').val();
			var descTipoOpera=$('#descripcion').val();
			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var sucursal =$('#sucursal').val();
			var caja =$('#cajaID').val();

			$('#ligaGenerar').attr('href','repGastosAnticipos.htm?fechaIni='+fechaIni+'&fechaFin='+
					fechaFin+'&usuario='+usuario+'&tipoReporte='+tr+'&fecha='+fechaEmision+
					'&nombreInstitucion='+nombreInstitucion+'&sucursalID='+sucursal+'&cajaID='+caja+'&naturaleza='+naturaleza+
					'&descripcionCaja='+nomCaja+'&nombreSucursal='+nomSucursal+'&tipoAntGastoID='+operacionCat+'&descripcion='+descTipoOpera);
			
		
	}

	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}
	
	function consultaCaja(idControl){
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;		// es una consulta Con_CajasTransfer 
		var numSucID =$('#sucursal').val();
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID == ''|| numCajaID == 0){
			$('#cajaID').val(0);
			$('#nombreCaja').val('TODAS');
		}else{
		if(numCajaID != '' && !isNaN(numCajaID)){
			
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					 if(numSucID!=0){
						  if(cajasVentanilla.sucursalID==$('#sucursal option:selected').val()){
						     $("#nombreCaja").val(cajasVentanilla.descripcionCaja);
						  }else{
								alert("La Caja no Corresponde con la Sucursal");
								$('#cajaID').val(0);
								$('#nombreCaja').val('TODAS');
								$('#cajaID').focus();
						  	}
					 }else{
						 $("#nombreCaja").val(cajasVentanilla.descripcionCaja);
					 }
				}else{
						alert('La caja no existe');
						$('#cajaID').focus();
					}
				
			});	
		   }
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
	
	function CatalogoAntGastos(control) {
		var jqCatalogoAntGastos  = eval("'#" +control + "'");
		var catalogoAntGast = $(jqCatalogoAntGastos).val();	
	
		if(catalogoAntGast != '' && !isNaN(catalogoAntGast)){				
			if(catalogoAntGast == '0'){								
				 $('#descripcion').val("TODOS");
				
			}else{			
				
				var catalogoAntGastosBean = { 
						'tipoAntGastoID':catalogoAntGast	  				
				};				
				
				catalogoGastosAntServicios.consulta(catTipoConsultaCatalogoAntGastos.principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
					if(tipoAntGastosBean != null){
						 if($('#naturaleza').val()!=''){
							  if(tipoAntGastosBean.naturaleza==$('#naturaleza option:selected').val()){
								  $('#descripcion').val(tipoAntGastosBean.descripcion);
							  }else{
									alert("El Número de Movimiento no Corresponde con el Tipo de Operación");
									$('#tipoAntGastoID').val(0);
									$('#descripcion').val('TODOS');
									$('#tipoAntGastoID').focus();
							  	}
						 }else{
							 $("#descripcion").val(tipoAntGastosBean.descripcion);
						 }
					}else{								
						alert("No existe el Tipo de Anticipo/Gasto");
						$('#tipoAntGastoID').focus();	
					}
				});
						
			}											
		}
	}
	
});

	