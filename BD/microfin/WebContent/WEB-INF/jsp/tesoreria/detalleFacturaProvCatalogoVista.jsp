<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="detalleFacturaList" value="${listaResultado[0]}"/>
<c:set var="listaImpuesto"  value="${listaResultado[1]}"/>
<c:set var="listaImportes"  value="${listaResultado[2]}"/>


<div id="gridDetalle" name="gridDetalle" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Detalle de Factura</legend>
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0">
		<tbody>

					<tr>
						<td class="label">
					   	<label for="lblNumero">Número</label>
						</td>
						<td class="label">
					   	<label for="lblCentroCosto">C.Costos</label>
						</td>
						<td class="label">
					   	<label for="lblTipoGasto">Tipo de Gasto</label>
						</td>
						<td class="label">
							<label for="Cantidad">Cantidad</label>
				  		</td>
						<td class="label">
							<label for="Descripcion">Concepto</label>
				  		</td>
				  		<td class="label">
							<label for="grava">Grava</label>
				  		</td>
				  		<td class="label">
							<label for="gravaCero">Grava al 0%</label>
				  		</td>
				  		<td class="label" align="center">
			         		<label for="lblPrecioUnit">Precio Unitario</label>
			     		</td>
			     		<td class="label" align="center">
			         		<label for="lblImport">Importe</label>
			     		</td>
						<c:forEach items="${listaImpuesto}" var="impuesto" varStatus="status">
						 <td  class="label" align="center"><label for="lblmpuesto${impuesto.impuestoID}">${impuesto.descripCorta}</label></td>
						</c:forEach>
					</tr>
						<c:forEach items="${detalleFacturaList}" var="detalleFactura" varStatus="status">
						<tr>
						</tr>
							<tr id="renglon${status.count}" name="renglon">
								<td>
									<input type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="6"
											value="${status.count}" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
									<input type="text" id="centroCostoID${status.count}" readonly="readonly" name="centroCostoID" size="10" value="${detalleFactura.centroCostoID}"  onkeypress="listaCentroCostos(this.id);"/>
							  	</td>
							  	<td nowrap="nowrap">
									<input type="text" id="tipoGastoID${status.count}" name="tipoGastoID" size="10" value="${detalleFactura.tipoGastoID}" onkeypress="listaCentroCostos(this.id);" onblur="consultaTipoGasto('${status.count}');"/>
									<input type="text" id="descripTGasto${status.count}" name="descripTGasto" size="35" disabled="true" />
							  	</td>
							  	<td>
									<input type="text" id="cantidad${status.count}"  style="text-align:right;"  name="cantidad" size="15" value="${detalleFactura.cantidad}" onchange="calcularTotales('${status.count}');" onblur="validaCantidad(this.id);"/>
							  	</td>
							  	<td>
									<input type="text" id="descripcion${status.count}" name="descripcion" size="40" value="${detalleFactura.descripcion}" maxlength="50"/>
							  	</td>

							  	<c:if test="${detalleFactura.gravable == 'S'}" >
								  	<td>
								  		<select id="gravable${status.count}" name="gravable" value="S" onchange="calcularTotales('${status.count}');desactivaGravaCero(this);">
								  			<option value="S">SI</option>
								  			<option value="N">NO</option>
								  		</select>
								  	</td>
								</c:if>
								<c:if test="${detalleFactura.gravable == 'N'}" >
								  	<td>
								  		<select id="gravable${status.count}" name="gravable" value="N" onchange="calcularTotales('${status.count}');desactivaGravaCero(this);">
								  			<option value="N">NO</option>
								  			<option value="S">SI</option>
								  		</select>
								  	</td>
								</c:if>
								<c:if test="${detalleFactura.gravaCero == 'S'}" >
								  	<td>
								  		<select id="gravaCero${status.count}" name="gravaCero" value="S" style="width:70px" onchange="calcularTotales('${status.count}');">
								  			<option value="S">SI</option>
								  			<option value="N">NO</option>
								  		</select>
								  	</td>
								</c:if>
								<c:if test="${detalleFactura.gravaCero == 'N'}" >
								  	<td>
								  		<select id="gravaCero${status.count}" name="gravaCero" value="N" style="width:70px" onchange="calcularTotales('${status.count}');">
								  			<option value="N">NO</option>
								  			<option value="S">SI</option>
								  		</select>
								  	</td>
								</c:if>
					     		<td>
					         		<input type="text" id="precioUnitario${status.count}"  style="text-align:right;"  name="precioUnitario" size="15" value="${detalleFactura.precioUnitario}"
					         			esMoneda="true" />
					     		</td>
								<td>
					         		<input type="text" id="importe${status.count}" name="importe" size="15" align="right"
					         			value="${detalleFactura.importe}"  style="text-align:right;"  esMoneda="true" disabled="true" />

					     		</td>
								<c:forEach items="${listaImportes}" var="impuesto" varStatus="status">
									<c:if test="${detalleFactura.noPartidaID==impuesto.noPartidaID}" >
											<td>
												<input type="text" id="importeImpuesto-1-${status.count}" name="importeImpuesto" size="15" align="right"
												value="${impuesto.importeImpuesto}"  style="text-align:right;"  esMoneda="true" disabled="true"  />
												<input type="hidden" id="impuestoID-1-${status.count}" name="impuestoID" size="5" value="${impuesto.impuestoID}" />
												<input type="hidden" id="noPartidaID${status.count}" name="noPartidaID" size="5" value="${impuesto.noPartidaID}" />
											</td>
											<c:if test="${detalleFactura.estatus == 'I' }" >
												<c:if test="${impuesto.noTotalImpuesto == impuesto.consecutivo }" >
													<td nowrap="nowrap">
														<input type="button" name="elimina" id="1" value="" class="btnElimina" onclick="eliminaDetalle(this)">
														<input type="button" name="agrega" id="agrega1" value="" class="btnAgrega" onclick="agregaNuevoDetalle()">
													</td>
												</c:if>
											</c:if>

									</c:if>
								</c:forEach>

							</tr>
						</c:forEach>
				</tbody>

				<table align="right">
				<tr>
					<td>
						<input type="button" id="aplicaPro" name="aplicaPro" value="Aplicar Prorrateo" class="submit" style="display: none;"/>

					</td>
				</tr>
				</table>


				</table>
				<!-- INICIO Seccion de Prorrrateo Contable y GRID -->
					<div id="prorrateoContable" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Aplicar Métodos Prorrateo</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td>
										<table>
											<tr>
												<td>
													<label for="prorrateoID">Método Prorrateo: </label>
												</td>
												<td colspan="7">
													<input type="text" id="prorrateoID" name="prorrateoID" size="8" maxlength="50"/>
													<input type="text" id="nombreProrrateo" name="nombreProrrateo" readOnly="readOnly" size="40" maxlength="50"/>
												</td>
											</tr>
											<tr>
												<td>
													<label for="descripcionProrrateo">Descripción: </label>
												</td>
												<td>
													<textarea cols="35" rows="3" value="" id="descripcionProrrateo" name="descripcionProrrateo" readOnly="readOnly" maxlength="100"></textarea>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<br/>
										<div id="gridProrrateoContable" name="gridProrrateoContable" style="display: none;"></div>
									</td>
								</tr>
								<tr>
									<td colspan="7" align="right">
										<input type="button" id="aplicaProrrateo" name="aplicaProrrateo" value="Aplicar" class="submit" disabled="disabled"/>
										<input type="button" id="cancelaProrrateo" name="cancelaProrrateo" value="Cancelar Prorrateo" class="submit"/>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
			<!-- FIN Seccion de Prorrrateo Contable y GRID -->
			<input type="hidden" name="numeroDetalle" id="numeroDetalle" value="0"/>

		</fieldset>
</div>
<script type="text/javascript">
esTab=true;
$(':text').focus(function() {
	esTab = false;
});

$(':text').bind('keydown',function(e){
	if (e.which == 9 && !e.shiftKey){
		esTab= true;
	}
});

//INICIO SECCION DE JAVASCRIPT PARA EL GRID Y VALIDACION DE PRORRATEO CONTABLE
$('#aplicaPro').click(function(){
	if(verificarvacios()==1){
		deshabilitaBoton('aplicaProrrateo');
		if(!$('#agrega').is(':disabled')){
			$('#prorrateoContable').show(500);
			$('#aplicaPro').hide(500);
			$('#prorrateoID').focus();
		}
	}
	if($("#estatus").val()=="I"){
		$('#prorrateoContable').show(500);
		$('#aplicaPro').hide(500);
		$('#prorrateoID').focus();
	}
});

$('#cancelaProrrateo').click(function(){
	$('#prorrateoContable').hide(500);
	$('#aplicaPro').show(500);
	limpiarCamposGrid();
	$('#adjuntarImagen').focus();
});

$('#prorrateoID').bind('keyup',function(){
	lista('prorrateoID','2','1','nombreProrrateo',$('#prorrateoID').val(),'prorrateoContableLista.htm');
});

$('#prorrateoID').blur(function(){
	if($('#prorrateoID').val()!=''){
		if(esTab){
			if(!isNaN($('#prorrateoID').val()) ){
				consultaMetodoProrrateo(this);
			}else{
				alert('Solo se Aceptan Números');
				$('#prorrateoID').val('');
				$('#nombreProrrateo').val('');
				$('#descripcion').val('');
				$('#gridProrrateoContable').hide();
				$('#prorrateoID').focus();
			}
		}
	}
});

function consultaMetodoProrrateo(jqcontrol){
	deshabilitaBoton('aplicaProrrateo');
	var evalControl=eval("'#"+jqcontrol.id+"'");
	var valorControl=$(evalControl).val();
	var tipoLista=1;
	var estatusActiva='A', estatusInactiva='I';
	prorrateoBean={
			'prorrateoID' : valorControl
	};
	prorrateoContableServicio.consulta(tipoLista,prorrateoBean,function(prorrateo){
			if(prorrateo!=null){
				$('#nombreProrrateo').val(prorrateo.nombreProrrateo);
				$('#descripcionProrrateo').val(prorrateo.descripcion);
				if(prorrateo.estatus==estatusActiva){
					var params={};
					params['tipoConsulta']=3;
					params['prorrateoID']=valorControl;
					consultaGridProrrateo(params);
				}else if(prorrateo.estatus==estatusInactiva){
					alert('El Método se Encuentra Inactivo');
					$('#prorrateoID').focus();
					limpiarCamposGrid();
					$('#descripcionProrrateo').val('');
				}
			}else{
				alert("El Método de Prorrateo no Existe");
				$('#prorrateoID').focus();
				limpiarCamposGrid();
			}
	});
}

function consultaGridProrrateo(params){
	$('#gridProrrateoContable').hide();
	$.post("prorrateoConsultaGrid.htm", params,function(data){
		if (data.length > 0){
			$('#gridProrrateoContable').html(data);
			$('#gridProrrateoContable').show(500);
			habilitaBoton('aplicaProrrateo');
		}
	});
}

function limpiarCamposGrid(){
	$('#prorrateoID').val('');
	$('#nombreProrrateo').val('');
	$('#descripcionProrrateo').val('');
	deshabilitaBoton('aplicaProrrateo');
	$('#gridProrrateoContable').hide(500);
}


//INICIO SECCION DE JAVASCRIPT PARA EL GRID Y VALIDACION DE PRORRATEO CONTABLE  ************************
//Funcion para aplicar el prorrateo

$('#aplicaProrrateo').click(function(){
	if($('#consecutivoID1').val()!='' && $('#centroCostoID1').length){
		var confirmar=confirm('Confirmar Aplicación de Prorrateo');


		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
				message: $('#mensaje'),
			 	css: {border:		'none',
			 			background:	'none'}
		});
		if(confirmar){
			var ID=0, contadorImpArr = 0;
			var nuevaFila=0;
			var factProrrateada='';
			var valImporteTotal=0.00;
			var importeIndividual		= 0.00;
			var importeIndTotal			=	0.00;
			var arregloDiferencias 	= [],	arregloFilas	= [],	arregloSigno	= [],	arregloMontosImp=[], arregloIdsImp=[],arregloDiferenciasImp	= [];

			// ARREGLO PARA GUARDAR LOS VALORES DE LOS IMPUESTOS ANTES DE  DIVIDIR
			// ciclo para recorrer las columnas de impuestos
			$('input[name=importeImpuesto]').each(function(){
				var jqCheck = eval("'#"+this.id+"'");
				var tamanioIDImp = this.id.length;
				var posicionGuion = this.id.lastIndexOf("-");
				arregloIdsImp	[contadorImpArr] = this.id.substring(posicionGuion+1, tamanioIDImp);
				arregloMontosImp[contadorImpArr] = $(jqCheck).asNumber();
				contadorImpArr = contadorImpArr+1;
			});

			// SE INICIA CICLO PARA CREAR LAS FILAS DEL PRORRATEO
			$('input[name=consecutivoID]').each(function(){
				ID =this.id.substring(13);
				var jqConse=eval("'#"+this.id+"'");
				var jqCentro=eval("'#centroCostoID"+ID+"'");
				var jqTipoGasto=eval("'#tipoGastoID"+ID+"'");
				var jqDesGasto=eval("'#descripTGasto"+ID+"'");
				var jqCantidad=eval("'#cantidad"+ID+"'");
				var jqDescripcion=eval("'#descripcion"+ID+"'");
				var jqGravable	=eval("'#gravable"+ID+"'");
				var jqGravaCero=eval("'#gravaCero"+ID+"'");
				var jqPrecioUn=eval("'#precioUnitario"+ID+"'");
				var jqImporte=eval("'#importe"+ID+"'");

				valConse = $(jqConse).val();
				valCentro = $(jqCentro).val();
				valTipoGasto = $(jqTipoGasto).val();
				valDesGasto = $(jqDesGasto).val();
				valCantidad = $(jqCantidad).val();
				valDescripcion = $(jqDescripcion).val();
				valGravable		=$(jqGravable).val();
				valPrecioUn = $(jqPrecioUn).asNumber();
				valImporte = $(jqImporte).asNumber();
				valGravaCero = $(jqGravaCero).val();

				$('input[name=cenCostoID]').each(function(){
					nuevaFila++;
					var IDP = this.id.substring(10);
					factProrrateada+='<tr id="renglon'+nuevaFila+'" name="renglon"> ';
					var jqCentroCosto	= eval("'#"+this.id+"'");
					var jqPorcentaje	= eval("'#porcentajePro"+IDP+"'");

					valCentroCosto		= $(jqCentroCosto).asNumber();
					valPorcentaje		= $(jqPorcentaje).asNumber();

						var precUnitario = ((parseFloat(valPrecioUn.toFixed(2))*parseFloat(valPorcentaje))/100);
						importeIndTotal+=parseFloat(precUnitario.toFixed(2));
						importeIndividual=(parseFloat(precUnitario.toFixed(2))*valCantidad);
						valImporteTotal+=parseFloat(importeIndividual.toFixed(2));

					factProrrateada += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+nuevaFila+'" autocomplete="off" disabled="true"  /></td>';
					factProrrateada	+= '<td><input type="text" id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="10" value="'+valCentroCosto+'" readOnly="readOnly" autocomplete="off"  onkeypress="listaCentroCostos(\'centroCostoID'+nuevaFila+'\');" /></td>';
					factProrrateada	+= '<td nowrap="nowrap"><input type="text" id="tipoGastoID'+nuevaFila+'" name="tipoGastoID" size="10" value="'+valTipoGasto+'" autocomplete="off" onKeyUp="listaTipoGasto(\'tipoGastoID'+nuevaFila+'\');" onblur="consultaTipoGasto('+nuevaFila+');" readOnly="readOnly" />';
					factProrrateada += '<input type="text" id="descripTGasto'+nuevaFila+'" name="descripTGasto" size="35" disabled="true" value="'+valDesGasto+'"/> </td>';
					factProrrateada += '<td><input type="text" id="cantidad'+nuevaFila+'" name="cantidad"  style="text-align:right;" size="10" onchange="calcularTotales('+nuevaFila+');" onBlur="validaCantidad(\'cantidad'+nuevaFila+'\');" value="'+valCantidad+'" readOnly="readOnly"/></td>';
					factProrrateada += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="40" autocomplete="off" onBlur=" ponerMayusculas(this);" value="'+valDescripcion+'" /></td>';
					factProrrateada += '<td><select id="gravable'+nuevaFila+'" name="gravable" desactivaGravaCero(this);" disabled="disabled" >';
					factProrrateada += '<option value="S"'+(valGravable=="S"?"selected":"")+'>SI</option>';
					factProrrateada += '<option value="N"'+(valGravable=="N"?"selected":"")+'>NO</option>';
					factProrrateada += '</select></td>';
					factProrrateada += '<td><select id="gravaCero'+nuevaFila+'" name="gravaCero" style="width:70px" disabled="disabled" >';
					factProrrateada += '<option value="S"'+(valGravaCero=="S"?"selected":"")+'>SI</option>';
					factProrrateada += '<option value="N"'+(valGravaCero=="N"?"selected":"")+'>NO</option> </td>';
					factProrrateada += '<td><input type="text" id="precioUnitario'+nuevaFila+'" name="precioUnitario"  style="text-align:right;" size="15" autocomplete="off" esMoneda="true"  "validaPrecio(\'precioUnitario'+nuevaFila+'\');" value="'+precUnitario+'" readOnly="readOnly"/></td>';
					factProrrateada += '<td nowrap="nowrap"><input type="text" id="importe'+nuevaFila+'" name="importe"  style="text-align:right;" size="15" autocomplete="off"  esMoneda="true" disabled="true" value="'+importeIndividual+'"/>';
					for (var i = 0; i < impuestosProv.length; i++){
						var impuestoID= impuestosProv[i].impuestoID;
						factProrrateada += '<td nowrap="nowrap"><input type="text" id="importeImpuesto-'+nuevaFila+'-'+impuestoID+'" name="importeImpuesto"  style="text-align:right;" size="15" value="" autocomplete="off"  esMoneda="true" disabled="true" align="right" /><input type="hidden" id="impuestoID-'+nuevaFila+'-'+impuestoID+'" name="impuestoID"   size="5" value="" /><input type="hidden" id="noPartidaID'+nuevaFila+'" name="noPartidaID" size="5" value="" /></td>';
					};

					factProrrateada += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/>';
					factProrrateada += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
					factProrrateada += '</tr>';

				});



				if(parseFloat(importeIndTotal.toFixed(2))<parseFloat(valPrecioUn.toFixed(2))){
					var diferenciaTotal =parseFloat(valPrecioUn.toFixed(2))-parseFloat(importeIndTotal.toFixed(2));

					arregloFilas.push(nuevaFila);
					arregloDiferencias.push(diferenciaTotal);
					arregloSigno.push('+');

				}else if(parseFloat(importeIndTotal.toFixed(2))>parseFloat(valPrecioUn.toFixed(2))){
	 				var diferenciaTotal =parseFloat(importeIndTotal.toFixed(2))-parseFloat(valPrecioUn.toFixed(2));

	 				arregloFilas.push(nuevaFila);
					arregloDiferencias.push(diferenciaTotal);
					arregloSigno.push('-');
				}
				importeIndTotal=0.00;

				var jqRenglon= eval("'#renglon"+ID+"'");
				$(jqRenglon).remove();

			});

			$('#numeroDetalle').val(nuevaFila);
			$("#miTabla").append(factProrrateada);
			$('#prorrateoContable').hide();
			$('#prorrateoHecho').val('S');


			for(var i=0;i<arregloFilas.length;i++){

				var filaDetalle = arregloFilas[i];
				var diferencia  = arregloDiferencias[i];
				var signo		= arregloSigno[i];

				var jqPrecioUni = eval("'#precioUnitario"+filaDetalle+"'");
				var jqImporte	= eval("'#importe"+filaDetalle+"'");
				var jqCantidad	= eval("'#cantidad"+filaDetalle+"'");


				if(signo=='+'){

					$(jqPrecioUni).val(parseFloat($(jqPrecioUni).asNumber().toFixed(2))+parseFloat(diferencia.toFixed(2)));
		 			$(jqImporte).val(parseFloat($(jqPrecioUni).asNumber().toFixed(2)*$(jqCantidad).val()).toFixed(2));

				}else if(signo=='-'){

					$(jqPrecioUni).val($(jqPrecioUni).asNumber().toFixed(2)-parseFloat(diferencia.toFixed(2)));
		 			$(jqImporte).val(parseFloat($(jqPrecioUni).asNumber().toFixed(2)*$(jqCantidad).val()).toFixed(2));
				}


			}

			$('input[name=consecutivoID]').each(function(){
				ID = this.id.substring(13);
				calcularTotales(ID);
			});


			for (var i = 0; i < impuestosProv.length; i++){
				var impuestoID = impuestosProv[i];
				var valImpuestoTot = 0.00;
				var valImpuestoUn = 0.00;


				$('input[name=consecutivoID]').each(function(){
					ID =this.id.substring(13);


					var jqImpuesto = eval("'#importeImpuesto"+'-'+ID+'-'+impuestoID.impuestoID+"'");


					valImpuestoUn = $(jqImpuesto).asNumber();


					valImpuestoTot += parseFloat(valImpuestoUn.toFixed(2));

				});

				var impArray  = arregloMontosImp[i];

				if(parseFloat(valImpuestoTot.toFixed(2))<parseFloat(impArray.toFixed(2))){
					var diferenciaTotalImp =parseFloat(impArray.toFixed(2))-parseFloat(valImpuestoTot.toFixed(2));

					arregloFilas.push(nuevaFila);
					arregloDiferenciasImp.push(diferenciaTotalImp);
					arregloSigno.push('+');

				}else if(parseFloat(valImpuestoTot.toFixed(2))>parseFloat(impArray.toFixed(2))){
	 				var diferenciaTotalImp =parseFloat(valImpuestoTot.toFixed(2))-parseFloat(impArray.toFixed(2));

	 				arregloFilas.push(nuevaFila);
	 				arregloDiferenciasImp.push(diferenciaTotalImp);
					arregloSigno.push('-');

				}else if(parseFloat(valImpuestoTot.toFixed(2)) == parseFloat(impArray.toFixed(2))){
	 				var diferenciaTotalImp = 0.00;

	 				arregloFilas.push(nuevaFila);
	 				arregloDiferenciasImp.push(diferenciaTotalImp);
				}



				var filaDetalle = arregloFilas[i];
				var diferenciaTotalImp  = arregloDiferenciasImp[i];
				var signo		= arregloSigno[i];

				var jqImpuestoFin = eval("'#importeImpuesto"+'-'+filaDetalle+'-'+impuestoID.impuestoID+"'");

				if(diferenciaTotalImp != 0.00){
					if(signo=='+'){

						$(jqImpuestoFin).val((parseFloat($(jqImpuestoFin).asNumber().toFixed(2))+parseFloat(diferenciaTotalImp)).toFixed(2));

					}else if(signo=='-'){

						$(jqImpuestoFin).val((parseFloat($(jqImpuestoFin).asNumber().toFixed(2))-parseFloat(diferenciaTotalImp)).toFixed(2));
					}

				}
			}

			calculoSumas();
			$('#contenedorForma').unblock();

		}
	}else{
		alert('No Existen Centros de Costo para Realizar Prorrateo o no hay Detalles de la Factura');
	}
	$('#adjuntarImagen').focus();

});
//FIN SECCION DE JAVASCRIPT PARA EL GRID Y VALIDACION DE PRORRATEO CONTABLE

</script>