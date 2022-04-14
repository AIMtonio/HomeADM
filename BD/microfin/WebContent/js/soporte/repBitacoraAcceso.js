$(document).ready(function() {
	esTab = false;

	var parametroBean = consultaParametrosSession();
	
	inicializaParametros();
	$('#fechaInicio').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});		

	$.validator.setDefaults({submitHandler: function(event) {
	   
	}});	
	
	$('#generar').click(function() {
		generaReporte();
	});	
	
	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
		
	$('#usuarioID').blur(function() {
		if(esTab){
			validaUsuario();
		}  		
	});
	
	$('#sucursalID').bind('keyup',function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');	
	});
	

	$('#sucursalID').blur(function() {
		if(esTab){
			validaSucursal();
		}  		
	});
	
	$('#fechaInicio').change(function(){
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaInicio').val(fechaSis);
				$('#fechaFin').val(fechaSis);
				$('#fechaInicio').focus();
			}else{
				if( mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha de Inicio no Puede ser Mayor a la Fecha Final")	;
					$('#fechaInicio').val(Yfecha);
					$('#fechaInicio').focus();
				}else{
					$('#fechaInicio').focus();						
				}
			}
		}else{
			$('#fechaInicio').val(Yfecha);
			$('#fechaInicio').focus();
		}
	});	

	$('#fechaFin').change(function(){
		var Xfecha= $('#fechaFin').val();
		var Yfecha= $('#fechaInicio').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaFin').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				mensajeSis("La Fecha Final no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaFin').val(fechaSis);
				$('#fechaFin').focus();
			}else{
				if( mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha Final no Puede ser Menor a la Fecha de Inicio")	;
					$('#fechaFin').val(Yfecha);
					$('#fechaFin').focus();
				}else{
					$('#fechaFin').focus();						
				}
			}
		}else{
			$('#fechaFin').val(fechaSis);
			$('#fechaFin').focus();
		}
	});		

	// Funcion para generar el reporte en PDF de la bitacora de seguimiento
	function generaReporte(){
		
		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaSucursal;

		var pagina='reporteBitacoraAcceso.htm?fechaInicio=' + $('#fechaInicio').val()+ 
							'&fechaFin=' + $('#fechaFin').val()+ 
							'&usuarioID=' + $('#usuarioID').val()+ 
							'&sucursalID=' + $('#sucursalID').val()+ 							
							'&tipoAcceso=' + $('#tipoAcceso').val()+ 								
							'&fechaSistema='+ varFechaSistema+ 
							'&claveUsuario='+varClaveUsuario.toUpperCase()+
							'&nombreInstitucion='+varNombreInstitucion+
							'&nombreUsuario='+$('#desUsuario').val()+
							'&nombreSucursal='+$('#desSucursal').val();
		window.open(pagina);	   
	}
	
	
	// Funcion para consultar el usuario
	function validaUsuario() {
		var numUsuario = $('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario > 0){
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};	
				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
						$('#usuarioID').val(usuario.usuarioID);
						$('#desUsuario').val(usuario.nombreCompleto.toUpperCase());						
					}else{
						mensajeSis("No Existe el Usuario");
						$('#usuarioID').val('0');
						$('#desUsuario').val('TODOS');
						$('#usuarioID').focus();
						$('#usuarioID').select();																
					}
				});			
										
		}else{
			if(isNaN(numUsuario)){
				mensajeSis("No Existe el Usuario");
				$('#usuarioID').val('0');
				$('#desUsuario').val('TODOS');
				$('#usuarioID').focus();
				$('#usuarioID').select();				
			}else{
				if(numUsuario =='' || numUsuario == 0){
					$('#usuarioID').val('0');
					$('#desUsuario').val('TODOS');
				}
			}
		}
	}

	//Función consulta los datos de la sucursal
	function validaSucursal() {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && numSucursal > 0){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#desSucursal').val(sucursal.nombreSucurs);				
				}else{
					$('#sucursalID').val('0');
					$('#desSucursal').val('TODAS');
					$('#sucursalID').focus();
					mensajeSis('No existe la Sucursal');
				}
			});
		}else{
			if(isNaN(numSucursal)){
				$('#sucursalID').val('0');
				$('#desSucursal').val('TODAS');
				$('#sucursalID').focus();
				mensajeSis('No existe la Sucursal');						
			}else{
				if(numSucursal =='' || numSucursal == 0){
					$('#sucursalID').val('0');
					$('#desSucursal').val('TODAS');					
				}
			}
		}
	}
	
	// Funcion valida fecha formato (yyyy-MM-dd)
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
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

	// Valida si fecha > fecha2: true else false
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
	

	// Funcion para comprobar el año bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	// Funcion que inicializa todos los campos de la pantalla
	function inicializaParametros(){
		inicializaForma('formaGenerica','');
		agregaFormatoControles('formaGenerica');
		
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#fechaFin').val(parametroBean.fechaSucursal);

		$('#usuarioID').val('0');
		$('#desUsuario').val('TODOS');
		$('#sucursalID').val('0');
		$('#desSucursal').val('TODAS');

		$('#pdf').attr("checked",true);
		
	}	
	
}); // fin document ready

