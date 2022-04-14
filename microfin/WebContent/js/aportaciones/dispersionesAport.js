	var esTab = true;

$(document).ready(function() {

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#formaGenerica').validate({
		rules: {
		},
		messages: {
		}
	});

	$('#importar').focus();

	$('#clienteID').bind('keyup',function(e) {
		lista('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaAportaciones.htm');
	});

	$('#clienteID').blur(function(e) {
		consultaNombreCte(this.id,'nombreCompleto', true);
	});

	$('#importar').click(function(event){
		consultaAportPend(false);
		$('#clienteID').val('');
		$('#nombreCompleto').val('');
	});
	$('#filtrar').click(function(event){
		consultaAportPend(true);
	});



});// FIN DOCUMENT READY
/**
 * Consulta la lista de las Aportaciones pendientes por Dispersar.
 * @author avelasco
 */
function consultaAportPend(filtrar){
	var numCliente = (filtrar ? $('#clienteID').asNumber() : 0);
	var aportBean = {
			'tipoLista'		: 1,
			'clienteID'		: numCliente,
	};
	$('#gridDispersiones').html("");
	$('#gridDispersiones').hide();
	$('#fieldDispersion').hide();
	bloquearPantalla();
	$.post("apDispGridVista.htm", aportBean, function(data) {
		if (data.length > 0 ) {
			$('#gridDispersiones').html(data);
		} else {
			mensajeSis('No hay Aportaciones por Dispersar.');
			mostrarDispersiones(false);
		}
	});
}
/**
 * Consulta la lista de las Aportaciones pendientes por Dispersar.
 * @author avelasco
 */
function consultaBeneficiarios(idDivBenef,trAP,numCliente,aportID,amortID){
	var existe = existeBenP(('trBen'+aportID+''+amortID),(aportID+''+amortID));
	var aportBean = {
			'tipoLista'		: 3,
			'clienteID'		: numCliente,
			'aportacionID'	: aportID,
			'amortizacionID': amortID,
	};
	var divID = idDivBenef.substring(9);
	var trBen = 'trBen'+aportID+''+amortID;
	var nameID = aportID+""+amortID+""+divID;
	var existenVacios = verificarCamposVacios();

	if(!existenVacios){

		var numeroFila = consultaFilas(trBen);
		trBen = "'"+trBen+"'";

		var nuevaFila = parseInt(numeroFila) + 1;

		var cuentaAhoID = eval("'#cuentaAhoID"+aportID+amortID+divID+"'");
		cuentaAhoID = $(cuentaAhoID).val();

		var montoDisp = eval("'#total"+aportID+amortID+divID+"'");
		montoDisp = $(montoDisp).val();

		var nombreCompleto = eval("'#nombreCompleto"+aportID+amortID+divID+"'");
		nombreCompleto = $(nombreCompleto).val();

		var clabeBeneficiario = eval("'clabe"+aportID+amortID+divID+"'");
		clabeBeneficiario = "'"+clabeBeneficiario+"'";

		var nameClabe = "clabe"+aportID+amortID+divID+nuevaFila;
		nameClabe = "'"+nameClabe+"'";

		var trAport = "'"+trAP+"'";

		var numClienteID = "'clienteID"+aportID+amortID+divID+nuevaFila+"'";
		var numCtaID = "'cuentaAhoID"+aportID+amortID+divID+nuevaFila+"'";
		var numMontoID = "'monto"+aportID+amortID+divID+nuevaFila+"'";
	    var idDivBen = "'"+idDivBenef+"'";
		var tds = '<tr id="trBen'+aportID+amortID+divID+nuevaFila+'" name="trBen'+aportID+amortID+'" >';

			tds += '<td nowrap="nowrap" >';
			tds += '<input id="cuentaAhoID'+aportID+amortID+divID+nuevaFila+'" readOnly="true" name="cuentaAhoID" size="13" value="'+cuentaAhoID+'" autocomplete="off" />';
			tds += '<input type="hidden" id="aportacionID'+aportID+amortID+divID+nuevaFila+'" name="aportacionID" size="15" value="'+aportID+'" disabled="disabled"/>';
			tds += '<input type="hidden" id="amortizacionID'+aportID+amortID+divID+nuevaFila+'" name="amortizacionID" size="15" value="'+amortID+'" disabled="disabled"/>';
			tds += '<input type="hidden" id="esPrincipal'+aportID+amortID+divID+nuevaFila+'" name="esPrincipal" size="2" value="" disabled="disabled"/>';
			tds += '<input type="hidden" id="cuentaTranID'+aportID+amortID+divID+nuevaFila+'" name="cuentaTranID" size="15" value="" disabled="disabled"/></td>  ';

			tds += '<td nowrap="nowrap" ><input type="text" id="nombre'+aportID+amortID+divID+nuevaFila+'" name="nombre" size="30" value="'+nombreCompleto+'" disabled="disabled"/></td> ';
			tds += '<td nowrap="nowrap" ><input type="text" id="clabe'+aportID+amortID+divID+nuevaFila+'" name="clabe" size="31" value=""  maxlength="30"  onKeyUp="obtenerCuentaExt('+aportID+amortID+divID+nuevaFila+');" onblur="validaCampoRep('+nameClabe+','+numCtaID+');consultaClabe('+nameClabe+','+trAport+');"  /></td> ';
			tds += '<td nowrap="nowrap" ><input type="text" id="beneficiario'+aportID+amortID+divID+nuevaFila+'" name="beneficiario" size="38" value="" disabled="disabled"/></td> ';
			tds += '<td nowrap="nowrap" ><input type="hidden" id="institucionID'+aportID+amortID+divID+nuevaFila+'" name="institucionID" size="25" value="" disabled="disabled"/><input type="text" id="nombreInstitucion'+aportID+amortID+divID+nuevaFila+'" tabindex="-1" name="nombreInstitucion" size="25" value="" disabled="disabled"/></td> ';
			tds += '<td nowrap="nowrap" ><input type="text" id="capital'+aportID+amortID+divID+nuevaFila+'" name="capital" size="18" value=""  disabled="disabled" style="text-align: right;" esMoneda="true"/></td> '+
				   '<td nowrap="nowrap" ><input type="text" id="interes'+aportID+amortID+divID+nuevaFila+'" name="interes" size="15" value=""  disabled="disabled" style="text-align: right;" esMoneda="true"/></td> '+
				   '<td nowrap="nowrap" ><input type="text" id="interesRetener'+aportID+amortID+divID+nuevaFila+'" name="interesRetener" size="15" value=""  disabled="disabled" style="text-align: right;" esMoneda="true"/></td> '+
				   '<td nowrap="nowrap" ><input type="text" id="total'+aportID+amortID+divID+nuevaFila+'" name="total" size="20" value=""  disabled="disabled" style="text-align: right;" esMoneda="true"/></td> '+
				   '<td nowrap="nowrap" ><input type="text" id="montoPendiente'+aportID+amortID+divID+nuevaFila+'" name="pendiente" size="20" value=""  disabled="disabled" style="text-align: right;" esMoneda="true"/></td> '+
				   '<td nowrap="nowrap" ><input type="text" id="monto'+aportID+amortID+divID+nuevaFila+'" name="monto" size="20" value="0" style="text-align: right;" esMoneda="true" maxlength="18" onblur="validaMonto('+numClienteID+','+numCtaID+','+numMontoID+');" />'+
				   '</td>  ';
			tds += ' <td style="text-align: center;" nowrap="nowrap">&nbsp;<input type="checkbox" id="autoriza'+aportID+amortID+divID+nuevaFila+'" name="autoriza" onclick="habilitaBoton('+"'grabar'"+');" />&nbsp;</td> ';
			tds += '<td nowrap="nowrap" ><input type="button" id="agregar'+aportID+amortID+divID+nuevaFila+'" name="agregar" value="" class="btnAgrega" onclick="consultaBeneficiarios('+idDivBen+','+trAport+','+numCliente+','+aportID+','+amortID+');" /></td> ';
			tds += '<input type="hidden" id="clienteID'+aportID+amortID+divID+nuevaFila+'" name="clienteID" value="'+numCliente+'"/>';
			tds += '<input type="hidden" id="tipoCuentaID'+aportID+amortID+divID+nuevaFila+'" name="tipoCuentaID" value=""/>';
			tds += '<td ></td>  </tr>';
		$('#'+idDivBenef).append(tds);
	};

}

function consultaFilas(trBen){
	var totales=0;
	$('[name='+trBen+']').each(function() {
		totales++;
	});
	return totales;
}


/**
 * Inicializa la forma.
 * @author avelasco
 */
function inicializar(iniCte){
	if(iniCte){
		$('#clienteID').val('0');
	}
	$('#clienteIDDes').val('TODOS');
	$('#gridDispersiones').html("");
	$('#gridDispersiones').hide();
	$('#fieldDispersion').hide();
	deshabilitaBoton('grabar');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito(){
	var tipoTransaccion = $('#tipoTransaccion').asNumber();
	agregaFormatoControles('formaGenerica');
	switch(tipoTransaccion){
		// Beneficiarios
		case 1:
			habilitaBoton('grabar');
			habilitaBoton('procesar');
			deshabilitaBoton('exportar');
		break;
		// Guardar dispersiones a procesar.
		case 2:
			habilitaBoton('grabar');
			habilitaBoton('procesar');
			habilitaBoton('exportar');
		break;
		// Procesar dispersiones.
		case 3:
			deshabilitaBoton('grabar');
			deshabilitaBoton('procesar');
			deshabilitaBoton('exportar');
		break;
		// Generar Reporte.
		case 4:
			deshabilitaBoton('grabar');
			deshabilitaBoton('procesar');
			deshabilitaBoton('exportar');
			var url ='exportaDispersionAportaTxt.htm?consecutivo='+$('#consecutivo').val();
			window.open(url);
		break;
	}
	consultaAportPend(false);
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco
 */
function funcionError(){
	agregaFormatoControles('formaGenerica');
}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @author avelasco
 */
function agregarDetalle(idControl){
}
/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco
 */
function eliminarParam(id){
	$('#'+id).remove();
}
/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}
/**
 * Regresa el número de renglones de un grid.
 * @returns Número de renglones de la tabla.
 * @author avelasco
 */
function getRenglones(name){
	var numRenglones = $('tr[name^="'+name+'"]').length;
	return numRenglones;
}
/**
 * Consulta el nombre completo del cliente.
 * @param idControl ID del input que origina la consulta.
 * @param idControlDesc ID del input en el que se va a mostrar la descripción.
 * @param consulta indica si debe o no consultar los integrantes del grupo familiar del cliente.
 * @author avelasco
 */
function consultaNombreCte(idControl,idControlDesc,consulta){
	var jqCte = eval("'#" + idControl + "'");
	var jqNomb = eval("'#" + idControlDesc + "'");
	var numCliente = $(jqCte).val().trim();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && Number(numCliente)>0 && esTab) {
		clienteServicio.consulta(Number(1), numCliente,"",function(cliente) {
			if (cliente != null) {
				$(jqNomb).val(cliente.nombreCompleto);
			} else {
				mensajeSis('El Aportante No Existe.')
				$(jqCte).val('');
				$(jqNomb).val('');
				if(consulta){
					$(jqCte).focus();
					inicializar(true);
				}
			}
		});
	} else {
		$(jqCte).val('');
		$(jqNomb).val('');
	}
}
function cancelarDispersion(){
	mensajeSisRetro({
		mensajeAlert : 'Se Cancelará la Dispersion, ¿Está seguro de continuar?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		funcionAceptar : function(){
			grabarDisper(event,5);
		},
		funcionCancelar : function(){// si no se pulsa en aceptar
			return false;
		}
	});

}



function grabarDisper(event,tipoTransaccion){
	var existenVacios = verificarCamposVacios();
	if(!existenVacios){


		$('#detalleBenef').val("");
		$('#detalleAport').val("");
		$('#tipoTransaccion').val(1);
		var beneficiarios = '';
		var TotalDispersar = 0;
		var MontoBenef = 0;

		// campos del grid de beneficiarios.
		var aportacionID = '';
		var amortizacionID = '';
		var cuentaTranID = '';
		var institucionID = '';
		var tipoCuentaID = 0;
		var clabe = '';
		var beneficiario = '';
		var monto = '';
		var esPrincipal = '';
		var total = '';
		var interesRetener = '';
		var interes = '';

		//ActualizarAportantes
		var dispersiones = '';
		var contadorDisp = 0;
		var contadorDiv	= 0;
		var montoTotales = 0;
		var autoriza = '';
		var cuentaAhoID = '';

		quitaFormatoControles('formaGenerica');

		$('tr[name=trAp]').each(function(index) {
			contadorDiv = contadorDiv + 1;
			autoriza = "#"+$(this).find("input[name^='autoriza']").attr("id");
			var selecAut = ($(autoriza).is(":checked") ? 'S' : 'P');


			aportacionID 	= "#"+$(this).find("input[name^='aportacionID']").attr("id");
			amortizacionID 	= "#"+$(this).find("input[name^='amortizacionID']").attr("id");
			cuentaTranID 	= "#"+$(this).find("input[name^='cuentaTranID']").attr("id");
			institucionID 	= "#"+$(this).find("input[name^='institucionID']").attr("id");
			tipoCuentaID 	= "#"+$(this).find("input[name^='tipoCuentaID']").attr("id");
			clabe 			= "#"+$(this).find("input[name^='clabe']").attr("id");
			beneficiario	= "#"+$(this).find("input[name^='beneficiario']").attr("id");
			monto 			= "#"+$(this).find("input[name^='monto']").attr("id");
			esPrincipal 	= "#"+$(this).find("input[name^='esPrincipal']").attr("id");
			total 			= "#"+$(this).find("input[name^='total']").attr("id");
			interesRetener 	= "#"+$(this).find("input[name^='interesRetener']").attr("id");
			interes 		= "#"+$(this).find("input[name^='interes']").attr("id");
			numCliente 		= "#"+$(this).find("input[name^='clienteID']").attr("id");
			numCliente 		= $(numCliente).val();
			cuentaAhoID 	= "#"+$(this).find("input[name^='cuentaAhoID']").attr("id");
			cuentaAhoID		= $(cuentaAhoID).val();
			Aportante = 'A';  // mandarlo como A implica que sólo se actualize.
			Beneficiario = 'B'; // mandarlo como B implica que lo de alta como beneficiario.

			montoTotales = $(total).asNumber() + $(interesRetener).asNumber() + $(interes).asNumber();

			if(montoTotales > 0){
				tipoPersona = Aportante;
				total = $(total).val().trim();
			}else{
				tipoPersona = Beneficiario;
				total = 0 ;
				$('input[name=total]').each(function() {

						numID = this.id.substring(5,this.id.length);  //23911
						clientejQ = eval("'#cuentaAhoID"+numID+"'");
						clienteID = $(clientejQ).val();


					if(cuentaAhoID == clienteID){
						if( $('#'+this.id).asNumber() > 0 ){
							total = total + $('#'+this.id).asNumber() ;
						};
					}
				});
			}
			switch(tipoTransaccion){
				// ACTUALIZACION DE ESTATUS.
				case 2:
					if(selecAut == 'S'){
					contadorDisp ++;
						dispersiones = dispersiones + '[' +
							$(aportacionID).val().trim()+']'+
							$(amortizacionID).val().trim()+']'+
							$(cuentaTranID).val().trim()+']'+
							$(institucionID).val().trim()+']'+
							$(tipoCuentaID).val().trim()+']'+
							$(clabe).val().trim()+']'+
							$(beneficiario).val().trim()+']'+
							$(monto).val().trim()+']'+
							$(esPrincipal).val().trim()+']'+
							total+']'+
							selecAut+']'+
							tipoPersona+']'+
							tipoTransaccion+']';
					}

				break;
				// PROCESO DE DISPERSION DE SOLO LAS ELEGIDAS.
				case 3:
					if(selecAut == 'S'){
						contadorDisp ++;
							dispersiones = dispersiones + '[' +
								$(aportacionID).val().trim()+']'+
								$(amortizacionID).val().trim()+']'+
								$(cuentaTranID).val().trim()+']'+
								$(institucionID).val().trim()+']'+
							$(tipoCuentaID).val().trim()+']'+
								$(clabe).val().trim()+']'+
								$(beneficiario).val().trim()+']'+
								$(monto).val().trim()+']'+
							$(esPrincipal).val().trim()+']'+
								total+']'+
								selecAut+']'+
								tipoPersona+']'+
								tipoTransaccion+']';
					}
				break;
				// EXPORTA LAYOUT DE DISPERSION DE SOLO LAS ELEGIDAS.
				case 4:
					if(selecAut == 'S'){
						contadorDisp ++;
							dispersiones = dispersiones + '[' +
								$(aportacionID).val().trim()+']'+
								$(amortizacionID).val().trim()+']'+
								$(cuentaTranID).val().trim()+']'+
								$(institucionID).val().trim()+']'+
							$(tipoCuentaID).val().trim()+']'+
								$(clabe).val().trim()+']'+
								$(beneficiario).val().trim()+']'+
								$(monto).val().trim()+']'+
							$(esPrincipal).val().trim()+']'+
								total+']'+
								selecAut+']'+
								tipoPersona+']'+
								tipoTransaccion+']';
					}
				break;
				case 5:
					if(selecAut == 'S'){
						$('#tipoTransaccion').val(5);

						contadorDisp ++;
							dispersiones = dispersiones + '[' +
								$(aportacionID).val().trim()+']'+
								$(amortizacionID).val().trim()+']'+
								$(cuentaTranID).val().trim()+']'+
								$(institucionID).val().trim()+']'+
							$(tipoCuentaID).val().trim()+']'+
								$(clabe).val().trim()+']'+
								$(beneficiario).val().trim()+']'+
								$(monto).val().trim()+']'+
							$(esPrincipal).val().trim()+']'+
								total+']'+
								selecAut+']'+
								tipoPersona+']'+
								tipoTransaccion+']';
					}
				break;

			}

			var trBen = 'trBen'+''+$(aportacionID).val()+''+$(amortizacionID).val();
			var numeroFila = consultaFilas(trBen);
			var idCampos = $(aportacionID).val()+""+$(amortizacionID).val()+ ""+contadorDiv;
			var conBen = 0;
			if(numeroFila>0){

					$('[name='+trBen+']').each(function(index) {

						autoriza = "#"+$(this).find("input[name^='autoriza']").attr("id");

						var selecAut = ($(autoriza).is(":checked") ? 'S' : 'P');
						conBen = conBen +1;
						numero = this.id.substr(5,this.id.length);
						aportacionID = "#"+$(this).find("input[name^='aportacionID']").attr("id");
						amortizacionID = "#"+$(this).find("input[name^='amortizacionID']").attr("id");
						cuentaTranID = "#"+$(this).find("input[name^='cuentaTranID']").attr("id");
						institucionID = "#"+$(this).find("input[name^='institucionID']").attr("id");
						clabe = "#"+$(this).find("input[name^='clabe']").attr("id");
						beneficiario = "#"+$(this).find("input[name^='beneficiario']").attr("id");
						monto = "#"+$(this).find("input[name^='monto']").attr("id");


						esPrincipal = "#"+$(this).find("input[name^='esPrincipal']").attr("id");
						tipoCuentaID = "#"+$(this).find("input[name^='tipoCuentaID']").attr("id");

						switch(tipoTransaccion){
							// ACTUALIZACION DE ESTATUS.
							case 2:
								if(selecAut == 'S'){

									contadorDisp ++;
									beneficiarios = beneficiarios + '[' +
										$(aportacionID).val().trim()+']'+
										$(amortizacionID).val().trim()+']'+
										$(cuentaTranID).val().trim()+']'+
										$(institucionID).val().trim()+']'+
										$(tipoCuentaID).val().trim()+']'+
										$(clabe).val().trim()+']'+
										$(beneficiario).val().trim()+']'+
										$(monto).val().trim()+']'+
										$(esPrincipal).val().trim()+']'+
										total+']'+
										selecAut+']'+
										Beneficiario+']'+
										tipoTransaccion+']';
									}

							break;
							// PROCESO DE DISPERSION DE SOLO LAS ELEGIDAS.
							case 3:
									if(selecAut == 'S'){
										contadorDisp ++;

										beneficiarios = beneficiarios + '[' +
											$(aportacionID).val().trim()+']'+
											$(amortizacionID).val().trim()+']'+
											$(cuentaTranID).val().trim()+']'+
											$(institucionID).val().trim()+']'+
											$(tipoCuentaID).val().trim()+']'+
											$(clabe).val().trim()+']'+
											$(beneficiario).val().trim()+']'+
											$(monto).val().trim()+']'+
											$(esPrincipal).val().trim()+']'+
											total+']'+
											selecAut+']'+
											Beneficiario+']'+
											tipoTransaccion+']';
									}
							break;
							// EXPORTA LAYOUT DE DISPERSION DE SOLO LAS ELEGIDAS.
							case 4:
									if(selecAut == 'S'){
										contadorDisp ++;

										beneficiarios = beneficiarios + '[' +
											$(aportacionID).val().trim()+']'+
											$(amortizacionID).val().trim()+']'+
											$(cuentaTranID).val().trim()+']'+
											$(institucionID).val().trim()+']'+
											$(tipoCuentaID).val().trim()+']'+
											$(clabe).val().trim()+']'+
											$(beneficiario).val().trim()+']'+
											$(monto).val().trim()+']'+
											$(esPrincipal).val().trim()+']'+
											total+']'+
											selecAut+']'+
											Beneficiario+']'+
											tipoTransaccion+']';
									}
							break;
							case 5:
								if(selecAut == 'S'){
									contadorDisp ++;

									beneficiarios = beneficiarios + '[' +
										$(aportacionID).val().trim()+']'+
										$(amortizacionID).val().trim()+']'+
										$(cuentaTranID).val().trim()+']'+
										$(institucionID).val().trim()+']'+
										$(tipoCuentaID).val().trim()+']'+
										$(clabe).val().trim()+']'+
										$(beneficiario).val().trim()+']'+
										$(monto).val().trim()+']'+
										$(esPrincipal).val().trim()+']'+
										total+']'+
										selecAut+']'+
										Beneficiario+']'+
										tipoTransaccion+']';
								}
							break;
						}


					});

					$('#detalleBenef').val(beneficiarios);


			}
					$('#detalleAport').val(dispersiones);

		});
		agregaFormatoControles('formaGenerica');
		if(contadorDisp > 0){

			$('#detalleBenef').val($('#detalleAport').val()+$('#detalleBenef').val());
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','funcionExito','funcionError');

		} else {
			mensajeSis('No hay Aportaciones Seleccionadas para Dispersar.');
			deshabilitaBoton('grabar');
			deshabilitaBoton('procesar');
			deshabilitaBoton('exportar');
		}
	}
}
function grabarBeneficiarios(event,tipoTransaccion){
	$('#tipoTransaccion').val(tipoTransaccion);
	var dispersiones = '';
	var aportacionID = '';
	var amortizacionID = '';
	var contadorDisp = 0;

	quitaFormatoControles('formaGenerica');
	$('tr[name=trAp]').each(function(index) {
		var autoriza = "#"+$(this).find("input[name^='autoriza']").attr("id");
		var selecAut = ($(autoriza).is(":checked") ? 'S' : 'P');
		aportacionID = "#"+$(this).find("input[name^='aportacionID']").attr("id");
		amortizacionID = "#"+$(this).find("input[name^='amortizacionID']").attr("id");


		switch(tipoTransaccion){
			// ACTUALIZACION DE ESTATUS.
			case 2:
				contadorDisp ++;
				dispersiones = dispersiones + '[' +
					$(aportacionID).val().trim()+']'+
					$(amortizacionID).val().trim()+']'+
					selecAut+']';
			break;
			// PROCESO DE DISPERSION DE SOLO LAS ELEGIDAS.
			case 3:
				if(selecAut == 'S'){
					contadorDisp ++;
					dispersiones = dispersiones + '[' +
						$(aportacionID).val().trim()+']'+
						$(amortizacionID).val().trim()+']'+
						selecAut+']';
				}
			break;
			// EXPORTA LAYOUT DE DISPERSION DE SOLO LAS ELEGIDAS.
			case 4:
				if(selecAut == 'S'){
					contadorDisp ++;
					dispersiones = dispersiones + '[' +
						$(aportacionID).val().trim()+']'+
						$(amortizacionID).val().trim()+']'+
						selecAut+']';
				}
			break;
		}
	});
	agregaFormatoControles('formaGenerica');
	$('#detalleAport').val(dispersiones);
	if(contadorDisp > 0){
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numTransaccion','funcionExito','funcionError');
	} else {
		mensajeSis('No hay Aportaciones Seleccionadas para Dispersar.');
		deshabilitaBoton('grabar');
		deshabilitaBoton('procesar');
		deshabilitaBoton('exportar');
	}
}

function generaReporte(){
	var numTransaccion = $("#numTransaccion").asNumber();
	var aportacion = $("#aportacionID").asNumber();
	var usuario = parametroBean.claveUsuario;
	var nombreInstitucion = parametroBean.nombreInstitucion;
	var fechaSistema = parametroBean.fechaAplicacion;

	var liga = 'repBeneficiariosAport.htm?'+
		'aportacionID=' + aportacion +
		'&numTransaccion=' + numTransaccion +
		'&tipoReporte=' + 1 +
		'&usuario=' + usuario +
		'&nombreInstitucion=' + nombreInstitucion +
		'&fechaSistema=' + fechaSistema;

	window.open(liga, '_blank');
}
function mostrarDispersiones(mostrar){
	mostrarElementoPorClase('trDispersiones',mostrar);
	if(mostrar){
		$('#gridDispersiones').show();
		$('#fieldDispersion').show();
	} else {
		$('#gridDispersiones').html("");
		$('#gridDispersiones').hide();
		$('#fieldDispersion').hide();
	}
}

function getTotalBen(name){
	var numRenglones = $('tr[name^="'+name+'"]').length;
	return numRenglones;
}

function existeBenP(idTrBenef,aportamortID){
	var totalBeneficiarios = false;
	var totales = 0;
	var totalBenP = '';
	var longitudID = '';
	var numero = '';

	$('tr[name='+idTrBenef+']').each(function(index) {
		longitudID = 5+aportamortID.length;
		numero = this.id.substr(longitudID,this.id.length);
		totalBenP = "#totalBenP"+aportamortID+''+numero;
		if($(totalBenP).asNumber() > 0){
			totales = $(totalBenP).asNumber();
		}
	});
	if(totales>0){
		totalBeneficiarios = true;
	} else {
		totalBeneficiarios = false;
	}
	return totalBeneficiarios;
}

function marcarTodasCheck(nameInput,idCheck){
	var consecutivo=0;
	var tamanio=nameInput.length;
	var nombre="";
	$("input:not(:disabled)[name="+nameInput+"]").attr('checked', $("#"+idCheck).attr("checked"));
	$('input[name=autorizaCheck]').each(function() {
		consecutivo = this.id.substring(tamanio);
		verificaAutorizar(consecutivo, "N");

	});
}

function obtenerCuentaExt(consecutivo){


	var clabeID = eval("'clabe"+consecutivo+"'");
	var clabe = eval("'#"+clabeID+"'");
	var clienteID = eval("'#clienteID"+consecutivo+"'");
	    clienteID = $(clienteID).val();

	var camposLista = new Array();
	var parametrosLista = new Array();

	camposLista[0] = "clienteID";
	camposLista[1] = "tipoCuenta";
	camposLista[2] = "clabe";

	parametrosLista[0] = clienteID;
	parametrosLista[1] = "E";
	parametrosLista[2] = $(clabe).val();


	lista(clabeID, '2', '7',camposLista,parametrosLista,'cuentasDestinoLista.htm');


}


function consultaCta(trCampo,clabeID,numclabe){
	var nuevaFrecuencia=$('#'+clabeID).val();
	var valorClabe = $('#'+numclabe).val();

	$('tr[name='+trCampo+']').each(function() {

		var numero= this.id.substr(5,this.id.length);

		var jqIdFrecuencias = eval("'clabe" + numero+ "'");
		var valorFrecuencias=$('#'+jqIdFrecuencias).val();

		if(nuevaFrecuencia == valorClabe){
					mensajeSis("El Beneficiario ya se encuentra agregado a la misma cuenta.");
					$('#'+clabeID).val("");
		}else{

			if((jqIdFrecuencias) != clabeID){
				if(valorFrecuencias == nuevaFrecuencia){
					mensajeSis("El Beneficiario ya se encuentra agregado a la misma cuenta.");
					$('#'+clabeID).val("");

				}
			}
		}

	});

}

function validaCampoRep(clabeID,numclienteID){

	var campoClabe = "";
	var campoClabeVal = 0;
	var campoCiclo = "";
	var campoCicloVal = 0
	var numCliente = eval("'#"+numclienteID+"'");
		numCliente = $(numCliente).val();
	var clientejQ = "";
	var clienteID = 0;

	$('input[name=clabe]').each(function(index) {
		if($('#'+this.id).val() != "" ){

			id  = this.id.substr(5,this.id.length);

			 campoClabe = eval("'#"+clabeID+"'");
			 campoClabeVal = $(campoClabe).val();
			 campoCiclo = eval("'#"+this.id+"'");
			 campoCicloVal = 0;

			 clientejQ = eval("'#cuentaAhoID"+id+"'");
			 clienteID = $(clientejQ).val();

			if(numCliente == clienteID){
				if(campoCiclo != campoClabe){

					campoCicloVal = $(campoCiclo).val();

					if(campoCicloVal == campoClabeVal){
						mensajeSis("El Beneficiario ya se encuentra agregado a la misma cuenta.");
						$('#'+clabeID).val("");
					}
				}
			}

		};

	});

}


//FUNCION QUE VERIFICA QUE LOS CAMPOS NO ESTEN VACIOS
function verificarCamposVacios(){
	var exito = false;
	var contador = 0;
	var vacioID ="";
	var id = 0;
	var autoriza = "";
	$('input[name=clabe]').each(function(index) {
		if($('#'+this.id).val() == "" ){
			id  = this.id.substr(5,this.id.length);
			autoriza = ("#autoriza"+id);

			if($(autoriza).is(":checked")){
				contador ++;
			}
		};

	});
	$('input[name=beneficiario]').each(function(index) {
		if($('#'+this.id).val() == "" ){
				id  = this.id.substr(12,this.id.length);
			autoriza = ("#autoriza"+id);

			if($(autoriza).is(":checked")){
				contador ++;
			}
		};

	});

	$('input[name=institucionID]').each(function(index) {
		if($('#'+this.id).val() == "" ){
				id  = this.id.substr(13,this.id.length);
			autoriza = ("#autoriza"+id);

			if($(autoriza).is(":checked")){
				contador ++;
			}
		};

	});

	if(contador > 0){
		mensajeSis("Existen Campos Vacíos");
		exito = true;
	}

	return exito;
}

function consultaClabe(clabeID,nameTr){

		var idControl = nameTr.substr(4,nameTr.length);
		var idClabe	= clabeID.substr(5,clabeID.length);

		var jqCte = eval("'#clienteID" + idControl + "'");
		var jqCta = eval("'#cuentaTranID" + idControl + "'");
		var jqCheck = eval("'#autoriza" + idClabe + "'");
		var jqClabe = eval("'#clabe" + idClabe + "'");

		var nomBen = eval("'#beneficiario" + idClabe + "'");
		var numInst = eval("'#institucionID" + idClabe + "'");
		var nombreInts = eval("'#nombreInstitucion" + idClabe + "'");
		var esPrincipal = eval("'#esPrincipal" + idClabe + "'");
		var cuentaTranID = eval("'#cuentaTranID" + idClabe + "'");
		var tipoCuentaID = eval("'#tipoCuentaID" + idClabe + "'");


		var Baja="B";
		var Autorizado="A";
		var cuentas = {
			'clienteID' : $(jqCte).val(),
			'cuentaTranID' : $(jqCta).val(),
			'clabe' : $(jqClabe).val()
		};
		if($(jqClabe).val() != "" && $(jqClabe).asNumber() != 0 ){
			cuentasTransferServicio.consulta(3,cuentas,function(cuenta) {
				if (cuenta != null) {
					if (cuenta.estatus == Baja) {
						$('#estatus').val('BAJA');
						mensajeSis("La Cuenta Destino fue Cancelada.");
						$('#'+clabeID).val("");
						$('#'+clabeID).focus();
					}else{
						$(nomBen).val(cuenta.beneficiario);
						$(numInst).val(cuenta.institucionID);
						$(nombreInts).val(cuenta.nombre);
						$(esPrincipal).val(cuenta.esPrincipal);
						$(cuentaTranID).val(cuenta.cuentaTranID);
						$(tipoCuentaID).val(cuenta.tipoCuentaSpei);
					}

				} else {
					mensajeSis("No Existe la cuenta Destino para el Cliente ");
					$('#'+clabeID).val("");
					if($(jqCheck).is(":checked")){
						$('#'+clabeID).focus();
					}else{
						$(jqCheck).focus();
					}
				}
			});
		}

}

function consultaTotales(){

	var exito = false;
	var contador = 0;
	var vacioID ="";
	var id = 0;
	var autoriza = "";

	var totalesCapital = 0;
	var totalesInteres = 0;
	var totalesISR = 0;
	var totalesGral = 0;
	var totalesPendiente = 0;
	var montosTotales = 0;
	var totalesCapital = 0;

	quitaFormatoControles('formaGenerica');



	$('input[name=capital]').each(function() {

		if( $('#'+this.id).asNumber() > 0 ){
			totalesCapital = totalesCapital + $('#'+this.id).asNumber();
		};

	});

	$('input[name=interes]').each(function() {
		if( $('#'+this.id).asNumber() > 0 ){
			totalesInteres = totalesInteres + $('#'+this.id).asNumber() ;

		};
	});

	$('input[name=interesRetener]').each(function() {
		if( $('#'+this.id).asNumber() > 0 ){
			totalesISR =  totalesISR + $('#'+this.id).asNumber() ;
		};
	});

	$('input[name=total]').each(function() {
		if( $('#'+this.id).asNumber() > 0 ){
			totalesGral = totalesGral + $('#'+this.id).asNumber() ;
		};
	});

	$('input[name=pendiente]').each(function() {
		if( $('#'+this.id).asNumber() > 0 ){
			totalesPendiente = totalesPendiente + $('#'+this.id).asNumber() ;
		};
	});

	var numID=0;
	var totaljQ = 0;
	var totalID = 0;

	$('input[name=monto]').each(function() {
			numID = this.id.substring(5,this.id.length);
			totaljQ = eval("'#total"+numID+"'");
			totalID = $(totaljQ).val();

		if( $('#'+this.id).asNumber() > 0 && totalID > 0 ){
			montosTotales = montosTotales + $('#'+this.id).asNumber() ;
		};
	});

	$('#totalCapital').val(totalesCapital);
	$('#totalInteres').val(totalesInteres);
	$('#totalesISR').val(totalesISR);
	$('#totalesGeneral').val(totalesGral);
	$('#pendienteGral').val(totalesPendiente);
	$('#montoGeneral').val(montosTotales);

	agregaFormatoControles('formaGenerica');
}

function validaMonto(numclienteID, idControlCta,numMontoID){

	var montosTotales = 0;
	var numID = 0;
	var clientejQ = 0;
	var clienteID = 0;
	var totalesGral = 0;
	var totalApor	= 0;
	var numCliente = eval("'#"+numclienteID+"'");
		numCliente = $(numCliente).val();

	var jqnumCta  = eval("'#" + idControlCta + "'");
	var numCta = $(jqnumCta).val();
    var conCta = 5;
    var montoenCta = 0;
    var idTotal = "";
    var idPendiente = "";
    var CuentaAhoBeanCon = {
    		'cuentaAhoID':numCta,
    		'clienteID':numCliente
    };
    var iniTotalPendiente = 0;
    if(numCta != '' && !isNaN(numCta)){
   		cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
            	if(cuenta!=null){
            		 montoenCta = cuenta.saldoDispon;
            		
            		 var montoenCta1 = montoenCta.replace(/,/g, '');
            		 	 montoenCta1 = Number(montoenCta1);

             		 quitaFormatoControles('formaGenerica');
             		totalApor = 0;
             		
             		 $('input[name=total]').each(function() {
             			 numID = this.id.substring(5,this.id.length);
             			 clientejQ = eval("'#cuentaAhoID"+numID+"'");
             			 clienteID = $(clientejQ).val();
             			 if(numCta == clienteID){
             				 if( $('#'+this.id).asNumber() > 0 ){
             					 console.log("xcta: numCta"+numCta+" Total: "+totalApor+" cte:"+clienteID);
             					 totalApor = totalApor + $('#'+this.id).asNumber() ;
             				 };
             			 }
             		 });
             		 
					$('input[name=monto]').each(function() {
						numID = this.id.substring(5,this.id.length);
						clientejQ = eval("'#cuentaAhoID"+numID+"'");
						clienteID = $(clientejQ).val();

						if(numCta == clienteID){
							if( $('#'+this.id).asNumber() > 0 ){
								montosTotales = montosTotales + $('#'+this.id).asNumber() ;
							};
						}
					});

					$('input[name=pendiente]').each(function() {
						numID = this.id.substring(14,this.id.length);
						clientejQ = eval("'#cuentaAhoID"+numID+"'");
						clienteID = $(clientejQ).val();

						if(numCta == clienteID){
							if( $('#'+this.id).asNumber() > 0 ){
							};
						}
					});

					$('input[name=total]').each(function() {
						numID = this.id.substring(5,this.id.length);
						clientejQ = eval("'#cuentaAhoID"+numID+"'");
						clienteID = $(clientejQ).val();

						if(numCta == clienteID){
							if( $('#'+this.id).asNumber() > 0 ){
								idTotal = eval("'#"+this.id+"'");
								iniTotalPendiente = eval("'#totalMontoPendiente"+numID+"'");
								idPendiente = eval("'#montoPendiente"+numID+"'");

							};
						}
					});

					var valIDTotal = $(idTotal).asNumber();
						iniTotalPendiente = $(iniTotalPendiente).asNumber();

					var montoPendiente = Number(iniTotalPendiente-montosTotales).toFixed(2);
					var totalApor = Number(totalApor).toFixed(2);
					var montosTotales1 = Number(montosTotales).toFixed(2);


					if (montosTotales1 > iniTotalPendiente && montosTotales1 != totalApor){
						mensajeSis("El Monto a dispersar es mayor al total a dispersar");
						$('#'+numMontoID).val(0.00);

					}else if (montosTotales1 > montoenCta1 && montosTotales1 != totalApor) {
						mensajeSis("El Monto a Dispersar es mayor al disponible en la Cuenta");
						$('#'+numMontoID).val(0.00);
					} else {
						$(idPendiente).val(montoPendiente);
					}
					
					agregaFormatoControles('formaGenerica');


            	}else{
            		mensajeSis("No Existe la Cuenta de Ahorro.");
            	}
            });
    }

}