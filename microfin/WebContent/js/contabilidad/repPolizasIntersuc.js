$(document)
		.ready(
				function() {
					// Definicion de Constantes y Enums
					esTab = true;
		
					
					var parametroBean = consultaParametrosSession();
					$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
					var catTipoPolizasIntersucRep = {
						'Excel' : 1
					};
					var catRepGenerar = {
						'opeVentanillaSoc' : 1,
						'gastosComprobar' : 2,
						'transferCtasBan' : 3,
						'facturaProv' : 4,
						'polizasIntersuc' : 5
					};
					
					var fechaSistema = parametroBean.fechaSucursal;
					var hora = '';
					var horaEmision = new Date();
					hora = horaEmision.getHours();
					if(horaEmision.getMinutes()<10){
					hora = hora + ':'+ '0'+ horaEmision.getMinutes();
					}else{
					hora = hora + ':' + horaEmision.getMinutes();
					}					

					// ------------ Metodos y Manejo de Eventos
					// -----------------------------------------
					agregaFormatoControles('formaGenerica');

					
					$('#fechaInicial').val(parametroBean.fechaSucursal);
					$('#fechaFinal').val(parametroBean.fechaSucursal);
					deshabilitaBoton('generarR', 'submit');
					$(':text').focus(function() {
						esTab = false;
					});

					$('#fechaInicial')
							.change(
									function() {
										var Xfecha = $('#fechaInicial').val();
										if (esFechaValida(Xfecha)) {
											if (Xfecha == '')
												$('#fechaInicial')
														.val(
																parametroBean.fechaSucursal);
											var Yfecha = $('#fechaFinal').val();
											fechamayor();
											if (mayor(Xfecha, Yfecha)) {
												if ($('#fechaFinal').val() != '') {
													alert("La Fecha de Inicio es Mayor a la Fecha de Fin.");
													$('#fechaInicial')
															.val(
																	parametroBean.fechaSucursal);
												}

											}
										} else {
											$('#fechaInicial')
													.val(
															parametroBean.fechaSucursal);
										}
									});

					$('#fechaFinal')
							.change(
									function() {
										var Xfecha = $('#fechaInicial').val();
										var Yfecha = $('#fechaFinal').val();
										fechamayor();
										if (esFechaValida(Yfecha)) {
											if (Yfecha == '')
												$('#fechaFinal')
														.val(
																parametroBean.fechaSucursal);

											if (mayor(Xfecha, Yfecha)) {
												alert("La Fecha de Inicio es Mayor a la Fecha de Fin.");
												$('#fechaFinal')
														.val(
																parametroBean.fechaSucursal);
											}
										} else {
											$('#fechaFinal')
													.val(
															parametroBean.fechaSucursal);
										}

									});
					
					$('#fechaInicial').change(function(){				
						if($('#fechaInicial').val() > $('#fechaFinal').val()){
							$('#fechaInicial').val(fechaSistema);
						}
					});
					
														
					$('#ligaGenerar').click(function() {
						validaDosmeses();
						 if($('#tipoReporte').val() == 0){							
						}else{							
							generaExcel();
							
						}
						
					});
					
					$('#fechaInicial').change(function(){
						validaDosmeses();				        
					});

					$('#formaGenerica').validate({
						rules : {
							fechaInicio : {
								required : true,
							},
							fechaFin : {
								required : true
							}
						},

						messages : {
							fechaInicio : {
								required : 'Ingrese la Fecha de Inicio',
							},
							fechaFin : {
								required : 'Ingrese la Fecha Final'
							}
						}
					});

				


					$(':text').bind('keydown', function(e) {
						if (e.which == 9 && !e.shiftKey) {
							esTab = true;
						}
					});

					$('#tipoReporte').change(function() {
						if ($('#tipoReporte').val() == '0') {							
							$('#tipoReporte').focus();
							$('#ligaGenerar').removeAttr(
									'href');
							deshabilitaBoton('generarR', 'button');
						} else {
							habilitaBoton('generarR', 'submit');
						}
					});

					function generaExcel() {
						var tr = catTipoPolizasIntersucRep.Excel;
						var fechaInicio = $('#fechaInicial').val();
						var fechaFin = $('#fechaFinal').val();
						var usuario = parametroBean.claveUsuario;
						var fechaEmision = parametroBean.fechaSucursal;
						var nombreInstitucion = $('#nombreInstitucion').val();
						var tl = parseInt($("#tipoReporte option:selected")
								.val());// tipo de reporte

						switch (tl) {

						case catRepGenerar.transferCtasBan:
							$('#ligaGenerar').attr(
									'href',
									'reportePolizasIntersuc.htm?fechaInicial='
											+ fechaInicio + '&fechaFinal='
											+ fechaFin + '&fechaEmision='
											+ fechaEmision + '&claveUsuario='
											+ usuario + '&tipoReporte=' + tr
											+ '&tipoLista=' + tl
											+ '&horaEmision=' + hora
											+ '&nombreInstitucion=' +nombreInstitucion);
							break;
						case catRepGenerar.polizasIntersuc:
							$('#ligaGenerar').attr(
									'href',
									'reportePolizasIntersucursales.htm?fechaInicial='
											+ fechaInicio + '&fechaFinal='
											+ fechaFin + '&fechaEmision='
											+ fechaEmision + '&claveUsuario='
											+ usuario + '&tipoReporte=' + tr
											+ '&tipoLista=' + tl
											+ '&horaEmision=' + hora
											+ '&nombreInstitucion=' +nombreInstitucion);
							break;
						case catRepGenerar.facturaProv:
							$('#ligaGenerar').attr(
									'href',
									'reporteFacturasProv.htm?fechaInicial='
											+ fechaInicio + '&fechaFinal='
											+ fechaFin + '&fechaEmision='
											+ fechaEmision + '&claveUsuario='
											+ usuario + '&tipoReporte=' + tr
											+ '&tipoLista=' + tl
											+ '&horaEmision=' + hora
											+ '&nombreInstitucion=' +nombreInstitucion);
							break;
						case catRepGenerar.gastosComprobar:
							$('#ligaGenerar').attr(
									'href',
									'reporteGastosAnticipos.htm?fechaInicial='
											+ fechaInicio + '&fechaFinal='
											+ fechaFin + '&fechaEmision='
											+ fechaEmision + '&claveUsuario='
											+ usuario + '&tipoReporte=' + tr
											+ '&tipoLista=' + tl
											+ '&horaEmision=' + hora
											+ '&nombreInstitucion=' +nombreInstitucion);
							break;
						case catRepGenerar.opeVentanillaSoc:
							$('#ligaGenerar').attr(
									'href',
									'reporteOperacionesVen.htm?fechaInicial='
											+ fechaInicio + '&fechaFinal='
											+ fechaFin + '&fechaEmision='
											+ fechaEmision + '&claveUsuario='
											+ usuario + '&tipoReporte=' + tr
											+ '&tipoLista=' + tl
											+ '&horaEmision=' + hora
											+ '&nombreInstitucion=' +nombreInstitucion);
							break;
						default:
							alert('listo');// 
						}

					}

					// VALIDACIONES PARA LAS PANTALLAS DE REPORTE

					function mayor(fecha, fecha2) {
						// 0|1|2|3|4|5|6|7|8|9|
						// 2 0 1 2 / 1 1 / 2 0
						var xMes = fecha.substring(5, 7);
						var xDia = fecha.substring(8, 10);
						var xAnio = fecha.substring(0, 4);

						var yMes = fecha2.substring(5, 7);
						var yDia = fecha2.substring(8, 10);
						var yAnio = fecha2.substring(0, 4);

						if (xAnio > yAnio) {
							return true;
						} else {
							if (xAnio == yAnio) {
								if (xMes > yMes) {
									return true;
								}
								if (xMes == yMes) {
									if (xDia > yDia) {
										return true;
									} else {
										return false;
									}
								} else {
									return false;
								}
							} else {
								return false;
							}
						}
					}
					// FIN VALIDACIONES DE REPORTES

					/* funcion valida fecha formato (yyyy-MM-dd) */
					function esFechaValida(fecha) {

						if (fecha != undefined && fecha.value != "") {
							var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
							if (!objRegExp.test(fecha)) {
								alert("formato de fecha no válido (aaaa-mm-dd)");
								return false;
							}

							var mes = fecha.substring(5, 7) * 1;
							var dia = fecha.substring(8, 10) * 1;
							var anio = fecha.substring(0, 4) * 1;

							switch (mes) {
							case 1:
							case 3:
							case 5:
							case 7:
							case 8:
							case 10:
							case 12:
								numDias = 31;
								break;
							case 4:
							case 6:
							case 9:
							case 11:
								numDias = 30;
								break;
							case 2:
								if (comprobarSiBisisesto(anio)) {
									numDias = 29;
								} else {
									numDias = 28;
								}
								;
								break;
							default:
								alert("Fecha introducida errónea");
								return false;
							}
							if (dia > numDias || dia == 0) {
								alert("Fecha introducida errónea");
								return false;
							}
							return true;
						}
					}

					function comprobarSiBisisesto(anio) {
						if ((anio % 100 != 0)
								&& ((anio % 4 == 0) || (anio % 400 == 0))) {
							return true;
						} else {
							return false;
						}
					}
					
					function fechamayor(){
						if($('#fechaInicial').val() > fechaSistema){						
							$('#fechaInicial').val(fechaSistema);						
						}
						else if($('#fechaFinal').val()>fechaSistema){
							alert('La Fecha no Puede ser Mayor a la del Sistema');
							$('#fechaFinal').val(fechaSistema);	
							}
						}								
					
					function validaDosmeses(){
						var fecha = $('#fechaInicial').val();
						var fecha2 = $('#fechaFinal').val();					
					  
						var f1 = Date.parse(fecha);
						var f2 = Date.parse(fecha2);
					  
						var dosmeses = 5270400000;
						var resultado = f2-f1;				
						if(resultado > dosmeses){
						  alert('El Rango Máximo de Fechas es de Dos Meses');
						  $('#fechaInicial').val(fechaSistema);
						}else{							
						}
					}
				        
					
					
					/** ******************************** */

				});
