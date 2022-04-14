var clickSalida = false;
var parametros = consultaParametrosSession();
var catTipoTransCajas= {
	'cierre' : 8
};

$(document).ready(function (){
	esTab = true;
	agregaFormatoControles('formaGenerica');
	
	inicializaParametros();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$('#generarTira').click(function() {
		quitaFormatoControles('formaGenerica');
		var tipoReporte	= 2;
		var nombreInst		= parametros.nombreInstitucion;	
		var sucursalID		= completaCerosIzq($('#sucursalID').val(),3);
		var nomSucursal 	= $('#dessucursal').val();
		var cajaID 			= completaCerosIzq($('#cajaID').val(),3);
		var numUsuario		= completaCerosIzq(parametros.numeroUsuario,3);
		var nomUsuario		= parametros.claveUsuario;
		var fecha 			= $('#fecha').val();
		var hora	 			=  $('#hora').val();
		$('#ligaPDFTira').attr('href','ReporteTiraAuditora.htm?programaID='+nombreInst+'&sucursalID='+sucursalID+'&sucursal='+nomSucursal+'&cajaID='+cajaID+
			'&usuarioID='+numUsuario+'&usuario='+nomUsuario+'&fecha='+fecha+'&fechaActual='+hora+"&tipoReporte="+tipoReporte);	
	});
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  generaBilletes();
	    	  if($('#tipoCaja').val() == 'BG'){
	    		  deshabilitaBoton('cierre','submit');
	    		  $('#generarTira').click();
	    		  return false;
	    	  }
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true', 'consec', 'imprimeItems','donothign');
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

	function inicializaParametros(){
		deshabilitaBoton('cierre','submit');
		$('#monedaID').val(1);
		$('#fecha').val(parametros.fechaSucursal);
		
		$('#cajaID').val($('#cajaIDSesion').val());           
		$('#descripcionCaja').val(parametros.tipoCajaDes);           
		$('#sucursalID').val($('#sucursalIDSesion').val());
		$('#dessucursal').val(parametros.nombreSucursal);
		$('#tipoTransaccion').val(8);
		$('#tipoCaja').val(parametros.tipoCaja);
		var parHora = hora();
		$('#hora').val(parHora);
		$('#fechaSistemaP').val(parametros.fechaAplicacion + ' ' +parHora);
		if (parametros.tipoCaja == '' || parametros.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');
		}else if (parametros.tipoCaja == 'CA'){
			$('#labeltabla').text('Transferencia a Caja Principal');
			estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
			consultaDisponibleDenominacion($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());
		}else if (parametros.tipoCaja == 'CP'){
			$('#labeltabla').text('Balance de Caja Principal');
			estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametros.tipoCaja);
			consultaDisponibleDenominacion($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());
		}else if (parametros.tipoCaja == 'BG'){
			$('#labeltabla').text('Balance de la Bobeda Central');
			consultaDisponibleDenominacion($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());
		}else{
			mensajeSis('La caja no esta definida correctamente');
		}
	 }

	
	
//	flujo de salida de CA
	function imprimeItems(){
	  	  var tipocaja = parametros.tipoCaja;
	  	  deshabilitaBoton('cierre','submit');
	  	  consultaDisponibleDenominacion($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());
	  	  if(tipocaja == 'CA' && Number($('#cantidad').val())>0){
	  		generaReporte($('#consec').val());
	    }
//		actualiza	  	  
	  	var parametroBean = consultaParametrosSession();
	  	$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
		$('#saldoMNSesionLabel').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});	
		$('#generarTira').click();
		
//	  	setTimeout("salidacaja()", 5000);
	  	}
		
		function salidacaja(){
			$('#ligaSalidaVen').attr('href','logout'); 
		  	$('#botonSalida').click();
		}
	
	
//		Funciones usadas por mas de una caja las cajas
		 function consultaSucursaldeCaja(numCajaID){
			
			
		 }

//	Consulta si la caja esta Actual esta abierta y si es CA cual es su el ID de su CP
	 function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
		 var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': cajaID
				};
		 var conPrincipal = 3;
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
				if(cajasVentanillaConCaja != null)
				{
				if(cajasVentanillaConCaja.sucursalID != sucursalID){
					mensajeSis('No puede realizar esta operación ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
					deshabilitaBoton('cierre','submit');
				}else{

					var consultaCajaEO = 7;
					var parametrosBeanVentanilla = {
							'sucursalID':sucursalID,
							'cajaID':cajaID
					};
					//estan es para consultar la propia caja si esta cerrada, no importa si es BG pues nunca esta cerrada
					cajasVentanillaServicio.consulta(consultaCajaEO, parametrosBeanVentanilla , function(cajaVentanilla){
						if(cajaVentanilla != null)
						{
							if(cajaVentanilla.estatusOpera == 'C'){
								mensajeSis('La caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
								deshabilitaBoton('cierre','submit');
							}else{
								if(cajaVentanilla.cajaID <= 0 && tipoCaja != 'BG'){
									
									if(Number(cajaVentanilla.cajaID) == 0){
										mensajeSis('No existe Caja Principal Asignada a esta Sucursal');
										deshabilitaBoton('cierre','submit');
									}else{
										mensajeSis('Existen '+cajaVentanilla.cajaID+'- Cajas Principales Asignadas a esta Sucursal. Busque al Gerente para que tenga solo una Caja principal Activa.');
										deshabilitaBoton('cierre','submit');
									}
									
								}else{
									if(tipoCaja == 'CA'){
										var consultaPrincipal = 3;//es la consulta principal segun el sp
										var parametrosBeanVentanillap = {
												'sucursalID':sucursalID,
												'cajaID':cajaVentanilla.cajaID,
												'tipoCaja':'CP'
										};
										cajasVentanillaServicio.consulta(consultaPrincipal, parametrosBeanVentanillap , function(cajaVentanillaPrincipal){
											if(cajaVentanillaPrincipal != null){
												if(cajaVentanillaPrincipal.estatusOpera == 'C')
												{mensajeSis('La caja Principal esta cerrada');
												deshabilitaBoton('cierre','submit');
												}
											else{
												$('#cajaDestino').val( cajaVentanillaPrincipal.cajaID);
//															valida si la caja de Atencion al publico tiene transferencias pendientes
												var consultanTransfPenCaj = 10;
												var parametrosBeanVentanilla = {
														'sucursalID':sucursalID,
														'cajaID':cajaID
												};
												cajasVentanillaServicio.consulta(consultanTransfPenCaj, parametrosBeanVentanilla , function(cajaVentanillaTransPenCaj){
													if(cajaVentanillaTransPenCaj != null)
													{
														if(cajaVentanillaTransPenCaj.cajaID>0){
															mensajeSis('Existen transferencias pendientes en ésta Caja.  Favor de Terminarlas para poder seguir Operando.');
															deshabilitaBoton('cierre','submit');
														}else{habilitaBoton('cierre','submit');}
													}
												});
												
												}
											}
										});
									}
									if(tipoCaja == 'CP'){
	//									valida si las cajas de Atencion al publico tienen transferencias pendientes
										var consultanTransfPenSuc = 10;
										var parametrosBeanVentanillaSuc = {
												'sucursalID':sucursalID,
												'cajaID':cajaID
												
										};
										cajasVentanillaServicio.consulta(consultanTransfPenSuc, parametrosBeanVentanillaSuc , function(cajaVentanillaTraPenSuc){
											if(cajaVentanillaTraPenSuc != null)
											{	if(cajaVentanillaTraPenSuc.cajaID>0){
													mensajeSis('Existen transferencias pendientes en ésta Caja.  Favor de Terminarlas para poder seguir Operando.');
													deshabilitaBoton('cierre','submit');}
												else{
						//																valida si las cajas de la sucursal estan cerradas
													var consultaCajaCA = 8;
													var parametrosBeanVentanilla = {
															'sucursalID':sucursalID,
													};
													cajasVentanillaServicio.consulta(consultaCajaCA, parametrosBeanVentanilla , function(cajaVentanilla){
														if(cajaVentanilla != null)
														{		
															if(cajaVentanilla.cajaID>0){mensajeSis('Existen '+cajaVentanilla.cajaID+' Cajas de Atención al Público que se encuentran aún Abiertas.');
																	deshabilitaBoton('cierre','submit');
															}
															else{habilitaBoton('cierre','submit');}
														}	
													});
												}
											}
										});
									}
								}
							}	
						}
					});
				
				}
			}
		});
	 }
	 ///generar reportes
	 function generaReporte(numTransaccion){
			var tipoReporte		= 1;
			var consec = numTransaccion;
			if(consec == null || consec == ''){
				consec = '1';
			}
			$('#ligaPDFTicket').attr('href','RepTicketCajasTransfer.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
				'&nombreInstitucion='+parametros.nombreInstitucion+
				'&numeroSucursal='+$('#sucursalID').val()+
				'&nombreSucursal='+$('#dessucursal').val()+
				'&varCaja='+$('#cajaIDSesion').val()+
				'&nomCajero='+parametros.nombreUsuario+
				'&numCopias=2&numTrans='+consec+
				'&monedaID=PESOS'+
				'&numSucDestino='+$('#sucursalID').val()+
				'&nomSucDestino='+$('#dessucursal').val()+
				'&cajaDestino='+$('#cajaDestino').val()+
				'&folioID='+consec+
				'&referencia='+'Cierre de caja '+
				'&tipoCaja='+$('#desCaja').val()+
				'&tipoReporte='+tipoReporte);
			$('#generarTicket').click();
		}
	 // consultas de disponibles y limpia de grid
	 function consultaDisponibleDenominacion(sucursal,caja) {
			var bean = {
					'sucursalID': sucursal,
					'cajaID': caja,
					'denominacionID':0,
					'monedaID':1
				};	
			
			var extencion = '';
			var disponiblePorDenom = 1;
			var ndeno=0; 
			ingresosOperacionesServicio.listaConsulta(disponiblePorDenom, bean,function(disponDenom){
				if(disponDenom == null || disponDenom.length == 0){
					limpiaGridBalance();
					}
				else{
					
					var suma = parseFloat(0);
					for (var i = 0; i < 7; i++){
						if(disponDenom[i] != undefined)
						{	var diponible = parseFloat(disponDenom[i].cantidadDenominacion);
							var monto = parseFloat(0);;
							var deno=0;
							switch(parseInt(disponDenom[i].denominacionID))
							{
							case 1:	deno = 1000;
									extencion='Mil';
									ndeno = 1;
							break;
							case 2:	deno = 500;
									extencion='Qui';
									ndeno = 2;
							break;
							case 3:	deno = 200;
									extencion='Dos';
									ndeno = 3;
							break;
							case 4:	deno = 100;
									extencion='Cien';
									ndeno = 4;
							break;
							case 5:	deno = 50;
									extencion='Cin';
									ndeno = 5;
							break;
							case 6:	deno = 20;
									extencion='Vei';
									ndeno = 6;
							break;
							case 7:	deno = 1;
									extencion='Mon';
									ndeno = 7;
							break;
							}
							var jqMonto = eval("'#montoSal" + extencion + "'");
							var jqDisponible = eval("'#disponSal" + extencion + "'");
							monto = parseFloat(Number(diponible)*deno);
							$(jqDisponible).val(diponible);
							$(jqMonto).val(monto);
							suma = suma + monto;
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
	}
	 function generaBilletes(){
			var extencion = '';
			var billetesMonedasSalida = '';
			var monto = parseFloat(0);;
			
			for (var i = 1; i < 8; i++){
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
					var jqDisponible = eval("'#disponSal" + extencion + "'");
					monto = monto +  Number($(jqDisponible).val()*deno);
					billetesMonedasSalida = billetesMonedasSalida + i +'-'+ $(jqDisponible).val()+'-'+ Number($(jqDisponible).val()*deno);
					if(i<7){billetesMonedasSalida = billetesMonedasSalida +',';}
			}
			$('#cantidad').val(monto);
			$('#billetesMonedasEntrada').val(billetesMonedasSalida);
			$('#cantidad').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});	
		}
	 ///funciones generales
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
	 function completaCerosIzq(obj,longitud) {
			var numtmp= String(obj);
	  		while (numtmp.length<longitud){  		
	    		numtmp = '0'+numtmp;
			}
			return numtmp;
		}
	function donothign(){
	}
	
		
	