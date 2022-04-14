
var ingresoMensual = 0;
var gastoMensual  = 0;
var montoSolicitado = 0;
var abonoPropuesto  = 0;	
var abonoEstimado = 0;
var cobertura = 0;
var cobConPrestamo = 0;
var coberturaMin = 0;
var coberturaMin = 0;
var porcentajeCob = 0;


$(document).ready(function() {
	
	//consulta los parametros del usuario y sesion
	var parametrosBean = consultaParametrosSession();
	
	$("#usuarioID").val(parametrosBean.numeroUsuario);
	$("#sucursalID").val(parametrosBean.sucursal);
	
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	
	var tipoTransaccionCapacidadPago= {
			'alta' : '1',
		};
	
	$("#divResultadoEstimacion").hide();
	$("#divUltimaEstimacion").hide();
	
	/*esta funcion esta en forma.js */
	deshabilitaBoton('calcular', 'submit');
	deshabilitaBoton('grabar', 'submit');
	
	listaProductosCredito();
	listaPlazos();
	
	cargaDatosDefault();	
	
	
	
	
	/* lista de ayudas para clientes */
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '8', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
	$('#clienteID').blur(function() {	
  		if(!isNaN($('#clienteID').val())){
  			var clienteLon=$('#clienteID').val().length;
  			if(clienteLon>11){  				
  				var cliente=$('#clienteID').val();
  	  			var Cortado = cliente.substring(0,11);
  	  			$('#clienteID').val(Cortado);
  			}
  		  		consultaCliente(this.id);
  		  		$('#montoSolicitado').focus();
  						
  			
  		}
	});
	
	$('#abonoPropuesto').blur(function() {		
  		if($('#abonoPropuesto').asNumber() > $('#montoSolicitado').asNumber()){
  			mensajeSis("El Abono Propuesto no debe ser mayor al Monto Solicitado");
  			$('#abonoPropuesto').val('1.00');
  		}
	});
	
	$('#productoCredito1').blur(function () {
		validaProductoCredito(this.id);
	});
	$('#productoCredito2').blur(function () {
		validaProductoCredito(this.id);
	});
	$('#productoCredito3').blur(function () {
		validaProductoCredito(this.id);
	});
	
	
	
	$('#calcular').click(function () {
		if(parseInt(validaProductosCredito()) == 0){
			calcularCapacidadPago();
		}
	});
	$('#grabar').click(function () {
		$("#tipoTransaccion").val(tipoTransaccionCapacidadPago.alta);
	});
	
	
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) {     	
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID',
		    			'funcionExitoTransaccion','funcionFalloTransaccion'); 
	    	
	    }
	 });
	
	
	
	

	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {
				clienteID :{
					required:true
				},
				montoSolicitado :{
					required:true,
					number : true,
					maxlength: 13
				},
				abonoPropuesto :{
					required:true,
					number : true,
					maxlength: 13
				}
			},		
			messages: {
				clienteID :{
					required:'Especificar cliente'
				},
				montoSolicitado :{
					required:'Especificar monto solicitado',
					number : "Solo dígitos numéricos",
					maxlength : "Máximo 12 caracteres"
				},
				abonoPropuesto :{
					required:'Especificar abono propuesto',
					number : "Solo dígitos numéricos",
					maxlength : "Máximo 12 caracteres"
				}
			}		
		});
		
		
		
		
		
		
		/* =================== FUNCIONES ========================= */
			

				/* Consulta el cliente */
				function consultaCliente(idControl) {
					var jqCliente = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					setTimeout("$('#cajaLista').hide();", 200);
					
					var bean = {
							'clienteID'	: numCliente
					};
					
					if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {					
						clienteServicio.consulta(16, numCliente, function(cliente) {
							$("#pagaIVA").val('');
							if (cliente != null) {
									if(cliente.esMenorEdad !="S"){
											$("#clienteID").val(cliente.numero);
											$("#pagaIVA").val(cliente.pagaIVA);
											$("#divResultadoEstimacion").hide();
											$("#divUltimaEstimacion").hide();
											$("#plazo").val('');
											$("#montoSolicitado").val('');
											$("#abonoPropuesto").val('');
											listaProductosCredito();
											
											if(cliente.calificaCredito == null || cliente.calificaCredito == ''){
												$("#clasificacion").val('N');
											}else{									
												$("#clasificacion").val(cliente.calificaCredito);
											}
											
											if(cliente.calificacion == null || cliente.calificacion == ''){
												$("#calificacion").val('0.00');
											}else {	
												$("#calificacion").val(cliente.calificacion);
											}
											
											
											clidatsocioeServicio.consulta(2,bean, function(resultado) {
												if (resultado != null) {
													if(resultado.ingresos == null || resultado.ingresos == ''){
														mensajeSis("Datos Socio-Económicos del cliente NO capturados");
														deshabilitaBoton('calcular', 'submit');
														inicializaForma('formaGenerica', 'clienteID');
														$("#plazo").val('');
														$("#clienteID").val('');
														$("#clienteID").focus();
													}else{												
																habilitaBoton('calcular', 'submit');
																$("#ingresoMensual").val(resultado.ingresos);
																$('#ingresoMensual').formatCurrency({
																	positiveFormat: '%n', 
																	roundToDecimalPlace: 2	
																});
																
																if(parseFloat(resultado.egresos)>0){
																	$("#gastoMensual").val(resultado.egresos);
																}
																else{
																	$("#gastoMensual").val('0.00');
																}
																
																$('#gastoMensual').formatCurrency({
																	positiveFormat: '%n', 
																	roundToDecimalPlace: 2	
																});
																
														
													}
													
													
													
													consultaUltimaEstimacion();
												}
											});
									}
									else{
										mensajeSis("El Cliente es Menor de Edad.");
										inicializaForma('formaGenerica','');
										$("#plazo").val('');
										listaProductosCredito();
										$("#divResultadoEstimacion").hide();
										$("#divUltimaEstimacion").hide();
										deshabilitaBoton('calcular', 'submit');
										$("#plazo").val('');
										$("#clienteID").focus();
									}		
											
							}
							else{
								mensajeSis("El Cliente No Existe o No está Activo");
								inicializaForma('formaGenerica','');
								$("#plazo").val('');
								listaProductosCredito();
								$("#divResultadoEstimacion").hide();
								$("#divUltimaEstimacion").hide();
								deshabilitaBoton('calcular', 'submit');
								$("#plazo").val('');
								$("#clienteID").focus();
							}
						});
					}
				}		
				
				
				function calcularCapacidadPago (){
					var productoCredito1 = 0;
					var productoCredito2 =  0;
					var productoCredito3 = 0;
					var productoCre1 = 0;
					var productoCre2 =  0;
					var productoCre3 =  0;
					var plazosID = new Array(); 
					var plazosMes = new Array(); 
					
					 ingresoMensual = $("#ingresoMensual").asNumber();
					 gastoMensual  = $("#gastoMensual").asNumber();
					 montoSolicitado = $("#montoSolicitado").asNumber();
					 abonoPropuesto  = $("#abonoPropuesto").asNumber();	
					 productoCredito1 = $("#productoCredito1 option:selected").text();
					 productoCredito2 =  $("#productoCredito2 option:selected").text();
					 productoCredito3 =  $("#productoCredito3 option:selected").text();
					 productoCre1 =  $("#productoCredito1").val();
					 productoCre2 =  $("#productoCredito2").val();
					 productoCre3 =  $("#productoCredito3").val();
					 
					 $("#producCredito1").val(productoCre1);
					 $("#producCredito2").val(productoCre2);
					 $("#producCredito3").val(productoCre3);
					
                      $('#plazo option:selected').each(function(){
                    	  plazosID.push($(this).val()); 
                    	  plazosMes.push($(this).text());                     	  
                      }); 
					
					if(montoSolicitado != '' && parseFloat(montoSolicitado) > 0){
						if(abonoPropuesto != '' && parseFloat(abonoPropuesto) > 0){
							if(plazosID.length > 0 && $("#clienteID").asNumber()>0){		
								
								var tipoCon = 2;
								var arrayPlazos = arrayListSelectMultiple("plazo");
								var bean = {
										'clienteID'	: $("#clienteID").val(),
										'sucursal' : parametrosBean.sucursal,
										'ingresoMensual' : ingresoMensual,
										'gastoMensual' : gastoMensual,
										'montoSolicitado' : montoSolicitado,
										'producCredito1' : productoCre1,
										'producCredito2' : productoCre2,
										'producCredito3' : productoCre3,
										'plazo'			 : arrayPlazos.toString()
								};
								
								capacidadPagoServicio.consulta(tipoCon, bean, function(datos) {
									if(datos != null){
										habilitaBoton('grabar', 'submit');
										$("#etiqueta").text("Gastos / Ingresos Óptimo <= " + datos.coberturaMin + "%");
										$("#ingresosGastos").val(datos.ingresosGastos);	
										
								
										if(parseFloat(datos.cobSinPrestamo)>=0){
											$("#cobSinPrestamo").val(datos.cobSinPrestamo);	
										}
										else{
											$("#cobSinPrestamo").val('0.00');	
										}
										
										$('#ingresosGastos').formatCurrency({
											positiveFormat: '%n', 
											roundToDecimalPlace: 2	
										});
										$('#cobSinPrestamo').formatCurrency({
											positiveFormat: '%n', 
											roundToDecimalPlace: 2	
										});
										
										var tasaInteres1 = parseFloat(datos.tasaInteres1);
										var tasaInteres2 = parseFloat(datos.tasaInteres2);
										var tasaInteres3 = parseFloat(datos.tasaInteres3);	
										var ivaSucursal = parseFloat(0.00);
										if($('#pagaIVA').val()=='S'){
											ivaSucursal = parseFloat(parametrosBean.ivaSucursal);	
										}
										var periocidad = parseInt(30) ;
										
										
										 var tasaPeriodica1 = ((tasaInteres1/100) * ((1 + ivaSucursal) * periocidad )) /360;
										var tasaPeriodica2 = (((tasaInteres2/100) * (1 + ivaSucursal)) * periocidad ) /360;
										var tasaPeriodica3 = (((tasaInteres3/100) * (1 + ivaSucursal)) * periocidad ) /360;
										var pagoCalculado = 0.00;
																			
																					
										$("#tasaInteres1").val(tasaInteres1);
										$("#tasaInteres2").val(tasaInteres2);
										$("#tasaInteres3").val(tasaInteres3);
										
										$("#tasaInteres1").val($("#tasaInteres1").asNumber());
										$("#tasaInteres2").val($("#tasaInteres2").asNumber());
										$("#tasaInteres3").val($("#tasaInteres3").asNumber());
																				
										
										/* Dibuja la tabla de Pagos Iguales */
										$("#tablaCuotas").html("");	
										var tabla = '';
										var encabezado = '';
										var tds='';
										var pie = '';
										
										tabla += '<fieldset class="ui-widget ui-widget-content ui-corner-all">';
											tabla += '<table border="0" cellpadding="0" cellspacing="0" width="100%" id="miTabla">';
											tabla += '</fieldset></table>';
										$("#tablaCuotas").append(tabla);
										
										encabezado += '<tr name="renglon">';	 
											encabezado += '<td align="center" class="label"><label>  PLAZO </label> </td>';	
											encabezado += '<td align="center" class="label"><label>' +productoCredito1+ '</label> </td>';	
											encabezado += '<td align="center" class="label"><label>' +productoCredito2+ '</label> </td>';	
											encabezado += '<td align="center" class="label"><label>' +productoCredito3+ '</label> </td>';	
											encabezado += '</tr>';	   							 
										$("#miTabla").append(encabezado);
										
										for (var i=0; i<plazosMes.length; i++)
										{										
											
											pagoCalculado = montoSolicitado * tasaPeriodica1 * Math.pow(1 + tasaPeriodica1 , parseInt(plazosMes[i])) / (Math.pow((1 + tasaPeriodica1), parseInt(plazosMes[i])) - 1);
											if(isNaN(pagoCalculado)){pagoCalculado = 0.00;	} else {pagoCalculado = Math.round(pagoCalculado * 100) /100; }
											tds += '<tr name="renglon">';
											tds += '<td align="center"><input type="button" id="pazo'+ i + '" size="20"  value="'+plazosMes[i]+'" readonly="true" style="width:95%; text-align:left;" />  </td>';
											tds += '<td align="center"><input type="button" id="cuota1' +i + '" size="10"  value="'+ pagoCalculado  +'" readonly="true"  onclick="calcularDatos(this.id)" esMoneda="true" style="text-align:right; width:95%;"/>  </td>';
											pagoCalculado = montoSolicitado * tasaPeriodica2 * Math.pow(1 + tasaPeriodica2 , parseInt(plazosMes[i])) / (Math.pow((1 + tasaPeriodica2), parseInt(plazosMes[i])) - 1);
											if(isNaN(pagoCalculado)){pagoCalculado = 0.00;	} else {pagoCalculado = Math.round(pagoCalculado * 100) /100; }
											tds += '<td align="center"><input type="button" id="cuota2' +i + '" size="10"  value="'+ pagoCalculado +'" readonly="true"  onclick="calcularDatos(this.id)" esMoneda="true" style="text-align:right; width:95%;"/>  </td>';
											pagoCalculado = montoSolicitado * tasaPeriodica3 * Math.pow(1 + tasaPeriodica3 , parseInt(plazosMes[i])) / (Math.pow((1 + tasaPeriodica3), parseInt(plazosMes[i])) - 1);
											if(isNaN(pagoCalculado)){pagoCalculado = 0.00;	} else {pagoCalculado = Math.round(pagoCalculado * 100) /100; }
											tds += '<td align="center"><input type="button" id="cuota3' +i + '" size="10"  value="'+ pagoCalculado +'" readonly="true"  onclick="calcularDatos(this.id)" esMoneda="true" style="text-align:right; width:95%;"/>  </td>';
											tds += '</tr>';	
										}										
										$("#miTabla").append(tds);
										
										pie += '<tr name="renglon">';	 
											pie += '<td align="center" class="separador"> </td>';	
											pie += '<td align="center" class="label"><label>' + Math.round((tasaInteres1/12) * 100) /100 + '%</label> </td>';	
											pie += '<td align="center" class="label"><label>' + Math.round((tasaInteres2/12) * 100) /100 + '%</label> </td>';	
											pie += '<td align="center" class="label"><label>' + Math.round((tasaInteres3/12) * 100) /100 + '%</label> </td>';	
											pie += '</tr>';	   							 
									$("#miTabla").append(pie);		
									
									//agregaFormatoMoneda('formaGenerica');
									
									var contador = 0;
									var jqMayor =  eval("'#cuota1" + 0 + "'");
								
									
									/* busca la cuota mayor del simulador */
								$('tr[name=renglon]').each(function() {		
										var jqCuota1 = eval("'#cuota1"+contador+"'");
										var jqCuota2 = eval("'#cuota2"+contador+"'");
										var jqCuota3 = eval("'#cuota3"+contador+"'");										
											
											if($(jqMayor).asNumber() < $(jqCuota1).asNumber()){
													jqMayor = jqCuota1;
												}  
																					
											if($(jqMayor).asNumber() < $(jqCuota2).asNumber()){
												jqMayor = jqCuota2;
											}
											
											if($(jqMayor).asNumber() < $(jqCuota3).asNumber()){
												jqMayor = jqCuota3;
											}
											contador = parseInt(contador + 1);										
								});   
							
											
											$(jqMayor).css({'color':'white','background':'#8A0808'});
											
											
											coberturaMin = datos.coberturaMin;
											porcentajeCob = datos.porcentajeCob;
											
											abonoEstimado = Math.round((   abonoPropuesto - $(jqMayor).asNumber()       )*100)/100;
											$("#abonoEstimado").val(abonoEstimado);
											
											if($(jqMayor).asNumber() > 0){
												cobertura = (ingresoMensual - (gastoMensual + (gastoMensual *(porcentajeCob/100))) )/ $(jqMayor).asNumber();
											}
											else {
												cobertura = ingresoMensual - (gastoMensual + (gastoMensual *(porcentajeCob/100))) ;
											}
											cobertura = cobertura * 100;	
											
											$("#cobertura").val(cobertura);
											$('#cobertura').formatCurrency({
												positiveFormat: '%n', 
												roundToDecimalPlace: 2	
											});
											
											if(parseFloat(cobertura) > parseFloat(coberturaMin)){
												$("#lblCobertura").text('POSITIVO');
												$("#lblCobertura").css({'color':'green','font-size': '10pt'});
											}
											else{
												$("#lblCobertura").text('NEGATIVO');
												$("#lblCobertura").css({'color':'#8A0808','font-size': '10pt'});
											}
											
											
											if(parseFloat(ingresoMensual) > 0){
												cobConPrestamo =   (gastoMensual + ((gastoMensual * porcentajeCob) / 100) + $(jqMayor).asNumber()) / ingresoMensual;
												
											}else{
												cobConPrestamo =  0.00;
											}
											cobConPrestamo = cobConPrestamo * 100;
											$("#cobConPrestamo").val(cobConPrestamo);
											$('#cobConPrestamo').formatCurrency({
												positiveFormat: '%n', 
												roundToDecimalPlace: 2	
											});
											
											
												
									
								
									agregaFormatoMoneda('formaGenerica');
									agregaFormatoControles('formaGenerica');
									
									
									}
									else{
										deshabilitaBoton('grabar', 'submit');
										mensajeSis("Ocurrió un error al calcular la Estimación de Capacidad de Pago");
									}
								});
								
								
								$("#divResultadoEstimacion").show(400);
							}
							else{
								mensajeSis('Seleccione Al Menos 1 Plazo.');
								$("#plazo").focus();
							}
						}
						else{
							mensajeSis('El Abono Propuesto es Incorrecto.');
							$("#abonoPropuesto").focus();
						}
					}
					else{
						mensajeSis('El Monto Solicitado es Incorrecto.');
						$("#montoSolicitado").focus();
					}					
					
				}

				
				
				/* Llena los combos de Plazos mensuales */
				function listaPlazos(){
					dwr.util.removeAllOptions('plazo'); 
					
					plazosCredServicio.listaCombo(4, function(productosCredito){
						dwr.util.addOptions('plazo', productosCredito, 'plazoID', 'descripcion');
					});
				}	
				
				
				
				function consultaUltimaEstimacion(){
					
					if($("#clienteID").asNumber()>0){
						var tipoCon = 1;
						var bean = {
								'clienteID'	: $("#clienteID").val()
						};
						
						
						capacidadPagoServicio.consulta(tipoCon, bean, function(estimacion) {
							if(estimacion != null){
								$("#divUltimaEstimacion").show();
								$("#fecha").val(estimacion.fecha);
								$("#ultimaCobertura").val(estimacion.cobertura);
								
							}
						});
					}
				}
			
				
		/* carga los datos del cliente actual cuando esta pantalla se visualice en el flujo ( "tren") */
			function cargaDatosDefault(){	
				if($('#clientIDGrupal').val() != undefined){
					if(!isNaN($('#clientIDGrupal').val())){					
						
						var numCliFlu = Number($('#clientIDGrupal').val());
						$('#clienteID').val($('#clientIDGrupal').val());
						
						if(numCliFlu > 0){
							consultaCliente('clienteID');
						}
					}
				}
			}

});


/* Llena los combos de Productos de Crédito */
function listaProductosCredito(){
	dwr.util.removeAllOptions('productoCredito1'); 
	dwr.util.removeAllOptions('productoCredito2'); 
	dwr.util.removeAllOptions('productoCredito3'); 
	
	productosCreditoServicio.listaCombo(7, function(productosCredito){
		dwr.util.addOptions('productoCredito1', productosCredito, 'producCreditoID', 'descripcion');
		dwr.util.addOptions('productoCredito2', productosCredito, 'producCreditoID', 'descripcion');
		dwr.util.addOptions('productoCredito3', productosCredito, 'producCreditoID', 'descripcion');
		
		
		/* selecciona los productos de credito por default (SAFI.properties) */
		capacidadPagoServicio.lista(1, function(productosCre) {
			$('#productoCredito1').val(productosCre[0]).selected = true;
			$('#productoCredito2').val(productosCre[1]).selected = true;
			$('#productoCredito3').val(productosCre[2]).selected = true;
						
		});
						
	});
	
}



/* calcula datos de estimacion al seleccionar una cuota en la tabla del simulador */
function calcularDatos(control){	
	var jqConotrol = eval("'#" + control + "'");
	abonoPropuesto  = $("#abonoPropuesto").asNumber();

	abonoEstimado = Math.round((abonoPropuesto - $(jqConotrol).asNumber())*100)/100;
	$("#abonoEstimado").val(abonoEstimado);
	
	
	if($(jqConotrol).asNumber() > 0){
		cobertura = (ingresoMensual - (gastoMensual + (gastoMensual *(porcentajeCob/100))) )/ $(jqConotrol).asNumber();
	}
	else {
		cobertura = ingresoMensual - (gastoMensual + (gastoMensual *(porcentajeCob/100))) ;
	}
	cobertura = cobertura * 100;
	
	$("#cobertura").val(cobertura);
	$('#cobertura').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});

	if(parseFloat(cobertura) > parseFloat(coberturaMin)){
		$("#lblCobertura").text('POSITIVO');
		$("#lblCobertura").css({'color':'green','font-size': '10pt'});
	}
	else{
		$("#lblCobertura").text('NEGATIVO');
		$("#lblCobertura").css({'color':'#8A0808','font-size': '10pt'});
	}
	
	
	
	
	if(ingresoMensual > 0){
		cobConPrestamo = (gastoMensual + ((gastoMensual * porcentajeCob) / 100) + $(jqConotrol).asNumber()) / ingresoMensual;
	}else{
		cobConPrestamo = 0.00;
	}
	cobConPrestamo = cobConPrestamo * 100;
	$("#cobConPrestamo").val(cobConPrestamo);
	$('#cobConPrestamo').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});

	/* Realiza la coloracion del TD */
	$('#miTabla tr').each(function () {
        $(this).find('input').each(function () {
            $(this).css({'color':'rgb(34, 31, 30)','background':'rgb(214, 210, 208)'});
        });
    });
	


	$(jqConotrol).css({'color':'white','background':'#8A0808'});
	
}

function validaProductoCredito(idControl){
	var jqControl = eval("'#" + idControl + "'");
	var pc1 = $("#productoCredito1").val();
	var pc2 = $("#productoCredito2").val();
	var pc3 = $("#productoCredito3").val();
	
	if($(jqControl).val() == pc1 &&  idControl != 'productoCredito1'){
		$(jqControl).focus();
		mensajeSis("Producto de Crédito se repite");
	}
	if($(jqControl).val() == pc2 &&  idControl != 'productoCredito2'){
		$(jqControl).focus();
		mensajeSis("Producto de Crédito se repite");
	}

	if($(jqControl).val() == pc3 &&  idControl != 'productoCredito3'){
		$(jqControl).focus();
		mensajeSis("Producto de Crédito se repite");
	}
}

function validaProductosCredito(){
	var pc1 = $("#productoCredito1").val();
	var pc2 = $("#productoCredito2").val();
	var pc3 = $("#productoCredito3").val();
	var error = 0;
	
	if(pc1 == pc2){
		$("#productoCredito1").focus();
		mensajeSis("Producto de Crédito se repite");
		$("#divResultadoEstimacion").hide();
		error = 1;
	}
	if(pc1 == pc3){
		$("#productoCredito1").focus();
		mensajeSis("Producto de Crédito se repite");
		$("#divResultadoEstimacion").hide();
		error = 1;
	}

	if(pc2 == pc3){
		$("#productoCredito2").focus();
		mensajeSis("Producto de Crédito se repite");
		$("#divResultadoEstimacion").hide();
		error = 1;
	}
	return error;
}



function funcionExitoTransaccion (){
	inicializaForma('formaGenerica', 'clienteID');
	listaProductosCredito();
	$("#plazo").val('');
	$("#divResultadoEstimacion").hide();
	$("#divUltimaEstimacion").hide();
	deshabilitaBoton('calcular', 'submit');
	deshabilitaBoton('grabar', 'submit');
}


function funcionFalloTransaccion (){
	
}

function arrayListSelectMultiple(idSelect){
	var options = new Array();
	$('#'+idSelect+' > option:selected').each(
	     function(i){
	         options[i] = $(this).val();
	     });
	return options;
}