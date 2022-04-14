var clickSalida = false;


$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#cajaID').focus();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	$('#sucursalID').change(function (){
		cargaCajasVentanillaCombo('cajaID',$('#cajaID').val(),$('#sucursalID').val(),$('#tipoCaja').val(),'');
		limpiaGridBalance();
		$('#cajaID').select();
		$('#cajaID').focus();
	});
	
	$('#cajaID').change(function (){		
			$('#fecha').val(parametros.fechaSucursal);
			consultaDisponibleDenominacion($('#sucursalID').val(),$('#cajaID').val());
	});
	$('#cajaID').blur(function (){		
		$('#fecha').val(parametros.fechaSucursal);
		consultaDisponibleDenominacion($('#sucursalID').val(),$('#cajaID').val());
});
	
	$('#fecha').bind('keyup',function(e){
		if(this.value.length >= 0){

			var tipolista=4;
			
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "sucursalID";
			camposLista[1] = "cajaID";
			camposLista[2] = "denominacionID";
			camposLista[3] = "monedaID";
			camposLista[4] = "fecha";
			
			
		 	parametrosLista[0] = $('#sucursalID').val();
		 	parametrosLista[1] = $('#cajaID').val();
		 	parametrosLista[2] = 0;
		 	parametrosLista[3] = parametros.numeroMonedaBase;
		 	parametrosLista[4] = $('#fecha').val();
		 	lista('fecha', '0', tipolista, camposLista, parametrosLista, 'listaHistorialBalance.htm');
		}	       
    });	
	
	$('#fecha').change(function(){
		setTimeout("$('#tablaLista').hide();", 200);
		if($('#fecha').val().length >= 10 )
			{
			if (FechaValida($('#fecha').val())) {
			    $('#fecha').val(parametros.fechaSucursal);
			    $('#fecha').focus();
			    $('#fecha').select();
			    
			    return;
			}
			if($('#fecha').val() != parametros.fechaSucursal){
				consultaBalanzaHistorica($('#sucursalID').val(),$('#cajaID').val(),$('#fecha').val());
			}else{
				consultaDisponibleDenominacion($('#sucursalID').val(),$('#cajaID').val());
			}
			
			}
		else{limpiaGridBalance();}
    });	
	$('#fecha').blur(function(){
		setTimeout("$('#tablaLista').hide();", 200);
		if($('#fecha').val().length >= 10 )
			{
			if (FechaValida($('#fecha').val())) {
			    $('#fecha').val(parametros.fechaSucursal);
			    $('#fecha').focus();
			    $('#fecha').select();
			    
			    return;
			}
			if($('#fecha').val() != parametros.fechaSucursal){
				consultaBalanzaHistorica($('#sucursalID').val(),$('#cajaID').val(),$('#fecha').val());
				}else{
				consultaDisponibleDenominacion($('#sucursalID').val(),$('#cajaID').val());
				}
			
			}
		else{limpiaGridBalance();}
    });	
	
	
	$.validator.setDefaults({
	      submitHandler: function(event) {
	      }
	});
	$('#formaGenerica').validate({	
		rules: {
			cajaID: {
				required: true
			}
		},		
		messages: {
			cajaID: {
				required: ''
			}
			
		}		
	});
	
	
}); // Fin Jquery

	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
		var key = nav4 ? evt.which : evt.keyCode;
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46);
	}
	

	
	
	
	
	function consultaDisponibleDenominacion(sucursal,caja) {
		if(sucursal == undefined ||sucursal == null || Number(sucursal) == 0 || caja == undefined|| caja == null|| Number(caja) == 0){return;}
		var bean = {
				'sucursalID': sucursal,
				'cajaID': caja,
				'denominacionID':0,
				'monedaID':1
			};	
		
		var billetesMonedasSalida = '';
		var extencion = '';
		
		ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
			if(disponDenom == null || disponDenom.length == 0){limpiaGridBalance();}
			else{
				
				var suma = parseFloat(0);
				for (var i = 0; i < 7; i++){
					if(billetesMonedasSalida != ''){billetesMonedasSalida = billetesMonedasSalida +",";}
					if(i<disponDenom.length){
						var diponible = disponDenom[i].cantidadDenominacion;
						var monto = parseFloat(0);;
						var deno=0;
						billetesMonedasSalida = billetesMonedasSalida + Number(i+1)+"-" + diponible+"-";
						switch(parseInt(disponDenom[i].denominacionID))
						{
						case 1:	deno = 1000;
								extencion='Mil';
						break;
						case 2:	deno = 500;
								extencion='Qui';
						break;
						case 3:	deno = 200;
								extencion='Dos';
						break;
						case 4:	deno = 100;
								extencion='Cien';
						break;
						case 5:	deno = 50;
								extencion='Cin';
						break;
						case 6:deno = 20;
						extencion='Vei';
						break;
						case 7:deno = 1;
						extencion='Mon';
						break;
						}
						var jqMonto = eval("'#montoSal" + extencion + "'");
						var jqDisponible = eval("'#disponSal" + extencion + "'");
						monto = parseFloat(Number(diponible)*deno);
						$(jqDisponible).val(diponible);
						$(jqMonto).val(monto);
						suma = suma + monto;
						billetesMonedasSalida = billetesMonedasSalida + monto;
						$(jqMonto).formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});	
					}
					
				}
				$('#cantidad').val(suma);
				$('#cantidad').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});		
				
			}
			
		});
		consultaEstatusOpera(
				Number($('#sucursalID').val()),
				Number($('#cajaID').val()));

	}
	
	 function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }

	 function limpiaGridBalance(){
			var extencion = '';
			for (var i = 1; i < 8; i++){
					var diponible = 0;
					var monto = parseFloat(0);;
					var deno=0;
					switch(i)
					{
					case 1:	deno = 1000;
							extencion='Mil';
					break;
					case 2:	deno = 500;
							extencion='Qui';
					break;
					case 3:	deno = 200;
							extencion='Dos';
					break;
					case 4:	deno = 100;
							extencion='Cien';
					break;
					case 5:	deno = 50;
							extencion='Cin';
					break;
					case 6:deno = 20;
					extencion='Vei';
					break;
					case 7:deno = 1;
					extencion='Mon';
					break;
					}
					var jqMonto = eval("'#montoSal" + extencion + "'");
					var jqDisponible = eval("'#disponSal" + extencion + "'");
					monto = parseFloat(Number(diponible)*deno);
					$(jqDisponible).val(diponible);
					$(jqMonto).val(monto);
						
			}	
			$('#cantidad').val(0);
			$('#cantidad').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});	
			$('#billetesMonedasEntrada').val('');
		}

	 function consultaEstatusOpera(sucursalID,cajaID){
		if(Number(sucursalID)<=0 || sucursalID == null || sucursalID == undefined){return;}
		var consultaPrincipal = 7;//es la consulta estatusopera
		var parametrosBeanVentanilla = {
				'sucursalID':sucursalID,
				'cajaID':cajaID
		};
		cajasVentanillaServicio.consulta(consultaPrincipal, parametrosBeanVentanilla , function(cajaVentanillaPrincipal){
			if(cajaVentanillaPrincipal != null){
				if(cajaVentanillaPrincipal.estatusOpera == 'C')
				{ $('#estatusOpera').val('Caja Cerrada');				}
			else{
				$('#estatusOpera').val('Caja Aperturada');				}
			}
				
		});
	}
	 function inicializaParametros(){
		 $('#monedaID').val(1);
			$('#fecha').val(parametros.fechaSucursal);
			var parHora = hora();
			$('#hora').val(parHora);
			$('#fechaSistemaP').val(parametros.fechaAplicacion + ' ' +parHora);
			var descripcion = "";
			if ($('#tipoCajaSesion').val() == '' || $('#tipoCajaSesion').val() == undefined){
				mensajeSis('El Usuario no tiene una Caja asignada.');
				$('#sucursalID').attr('disabled','true');
				$('#cajaID').attr('disabled','true');
				$('#fecha').attr('disabled','true');
			}
			else if ($('#tipoCajaSesion').val() == 'CA'){
				descripcion = $('#cajaIDSesion').val()+' CAJA DE ATENCION AL PUBLICO';
				$('#sucursalID').attr('disabled','true');
//				$('#cajaID').attr('disabled','true');
				inicializaParametrosCA($('#sucursalIDSesion').val(),parametros.nombreSucursal,$('#cajaIDSesion').val(),descripcion);
			}else if ($('#tipoCajaSesion').val() == 'CP'){
				descripcion = 'CAJA PRINCIPAL DE SUCURSAL';
				$('#sucursalID').attr('disabled','true');
				inicializaParametrosCP($('#sucursalIDSesion').val(),parametros.nombreSucursal,$('#cajaIDSesion').val());
			}else if ($('#tipoCajaSesion').val() == 'BG'){
				descripcion = 'BOVEDA CENTRAL';
				inicializaParametrosBG($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());
			}
			else{
				mensajeSis('La caja no esta definida correctamente');
				$('#sucursalID').attr('disabled','true');
				$('#cajaID').attr('disabled','true');
				$('#fecha').attr('disabled','true');
			}
			$('#tipoCaja').val($('#tipoCajaSesion').val());
			$('#desCaja').val(descripcion);
			//aqui la funcion que manda a llamar al llenado de combos
			$('#cajaID').val(Number($('#cajaIDSesion').val()));
			
			
			
	 }
	 

	 function consultaBalanzaHistorica(sucursal,caja,fecha) {
	
			var bean = {
					'sucursalID': sucursal,
					'cajaID': caja,
					'denominacionID':0,
					'monedaID':1,
					'fecha':fecha
				};	
			var consultahisBalance = 1;
			var billetesMonedasSalida = '';
			var extencion = '';
			
			cajasVentanillaServicio.listaConsulta(consultahisBalance, bean,function(disponDenom){
				if(disponDenom == null || disponDenom.length == 0){
					limpiaGridBalance();
					mensajeSis('La fecha seleccionada no contiene registro historico de Balanza de Efectivo');
					$('#fecha').val(parametros.fechaSucursal);
					$('#fecha').select();
					$('#fecha').focus();
				}
				else{
					
					var suma = parseFloat(0);
					for (var i = 0; i < 7; i++){
						if(billetesMonedasSalida != ''){billetesMonedasSalida = billetesMonedasSalida +",";}
						if(i<disponDenom.length){
							var diponible = disponDenom[i].cantidadDenominacion;
							var monto = parseFloat(0);;
							var deno=0;
							billetesMonedasSalida = billetesMonedasSalida + Number(i+1)+"-" + diponible+"-";
							switch(parseInt(disponDenom[i].denominacionID))
							{
							case 1:	deno = 1000;
									extencion='Mil';
							break;
							case 2:	deno = 500;
									extencion='Qui';
							break;
							case 3:	deno = 200;
									extencion='Dos';
							break;
							case 4:	deno = 100;
									extencion='Cien';
							break;
							case 5:	deno = 50;
									extencion='Cin';
							break;
							case 6:deno = 20;
							extencion='Vei';
							break;
							case 7:deno = 1;
							extencion='Mon';
							break;
							}
							var jqMonto = eval("'#montoSal" + extencion + "'");
							var jqDisponible = eval("'#disponSal" + extencion + "'");
							monto = parseFloat(Number(diponible)*deno);
							$(jqDisponible).val(diponible);
							$(jqMonto).val(monto);
							suma = suma + monto;
							billetesMonedasSalida = billetesMonedasSalida + monto;
							$(jqMonto).formatCurrency({
								positiveFormat: '%n', 
								roundToDecimalPlace: 2	
							});	
						}
						
					}
					$('#cantidad').val(suma);
					$('#cantidad').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});		
					
				}
				
			});
			consultaEstatusOpera(
					Number($('#sucursalID').val()),
					Number($('#cajaID').val()));

		}
	 
	 function FechaValida(fecha){
			
			var fecha2 = parametros.fechaSucursal;
			if(fecha == ""){return false;}
			if (fecha != undefined  ){
				
				var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
				if (!objRegExp.test(fecha)){
					mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
					return true;
				}

				var mes=  fecha.substring(5, 7)*1;
				var dia= fecha.substring(8, 10)*1;
				var anio= fecha.substring(0,4)*1;
				var mes2=  fecha2.substring(5, 7)*1;
				var dia2= fecha2.substring(8, 10)*1;
				var anio2= fecha2.substring(0,4)*1;
				if(anio>anio2 || anio==anio2&&mes>mes2 || anio==anio2&&mes==mes2&&dia>dia2 ){
					mensajeSis("Fecha introducida es mayor a la actual.");
					return true;
				}
				
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
				return true;
				}
				if (dia>numDias || dia==0){
					mensajeSis("Fecha introducida errónea.");
					return true;
				}
				return false;
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

		
	function inicializaParametrosCA(sucursal,nomSucursal,caja,nomCaja){
		//se agrega el combo de sucursales
		dwr.util.removeAllOptions('sucursalID');
		var stringsucursal = ("<option value ='" + sucursal + "'>"+nomSucursal+"</option>");
		$('#sucursalID').append(stringsucursal);
		dwr.util.removeAllOptions('cajaID');
		var stringcaja = ("<option value ='" + caja + "'>"+nomCaja+"</option>");
		$('#cajaID').append(stringcaja);
		$('#cajaID').val(caja).selected = true;
		//consulta el estatusopera
		consultaEstatusOpera(Number(sucursal),Number(caja));
		//consulta la denominacion actual
		consultaDisponibleDenominacion(sucursal,caja);
	}
	function inicializaParametrosCP(sucursal,nomSucursal,caja){
		//se agrega el combo de sucursales
		dwr.util.removeAllOptions('sucursalID');
		var stringsucursal = ("<option value ='" + sucursal + "'>"+nomSucursal+"</option>");
		$('#sucursalID').append(stringsucursal);
		//se agrega el combo a cajas
		cargaCajasVentanillaCombo('cajaID',0,sucursal,'AP','');
		//consulta el estatusopera
		consultaEstatusOpera(Number(sucursal),Number(caja));
		//consulta la denominacion actual
		consultaDisponibleDenominacion(sucursal,caja);
	}
	function inicializaParametrosBG(sucursal,caja){
		//se agrega el combo de sucursales
		consultaSucursales();
		//se agrega el combo a cajas
		cargaCajasVentanillaCombo('cajaID',0,sucursal,'BG','');
		//consulta el estatusopera
		consultaEstatusOpera(Number(sucursal),Number(caja));
		//consulta la denominacion actual
		consultaDisponibleDenominacion(sucursal,caja);
	}
	function consultaSucursales(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
			if(sucursales!=null){
				dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
				if($('#sucursalID').val()==null){
					$('#sucursalID').attr('disabled','true');
					deshabilitaBoton('apert','submit');
				}
				else{
					$('#sucursalID').val($('#sucursalIDSesion').val());
					
				}
				
				
			}
		});
	} 	
	function cargaCajasVentanillaCombo(idCaja,caja,sucursal,tipoCaja,eOpera){
		var jqCaja = eval("'#"+idCaja+"'");
		var tipoConsulta = 3;
		var tipoCajaAux = caja;
		if(tipoCaja!='CA'){tipoCajaAux=0;}
		var bean = {
				'estatusOpera': eOpera,
				'cajaID': tipoCajaAux,
				'tipoCaja':tipoCaja,
				'sucursalID':sucursal
		};
		dwr.util.removeAllOptions(idCaja);
		cajasVentanillaServicio.listaCombo(tipoConsulta, bean , function(cajaVentanilla){
			if(cajaVentanilla!=null){				
				dwr.util.addOptions(idCaja, cajaVentanilla, idCaja, 'descripcionCaja');
				if($(jqCaja).val()==null){
					$(jqCaja).attr('disabled','true');
				}
				else{
					if(tipoCaja != 'CA')
					{$(jqCaja).removeAttr('disabled');}
					$('#cajaID').val(Number($('#cajaIDSesion').val()));	
				}
			}
			else{mensajeSis('error');}
		});
	}