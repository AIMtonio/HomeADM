<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<div id="creditosConsolidadosGrid" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<c:choose>
			<c:when test="${tipoLista == '2' || tipoLista == '3' }">
				<legend>Cr&eacute;ditos.</legend>
				<table id="miTabla" border="0" width="100%">
					<tr id="encabezadoLista">
						<td style="text-align: center;" id="lblCredito">Cr&eacute;dito</td>
						<td style="text-align: center;" id="lblProductoCreditoID">Producto de Cr&eacute;dito</td>
						<td style="text-align: center;" id="lblMontoOriginal">Monto Original</td>
						<td style="text-align: center;" id="lblFondeo">Fondeo</td>
						<td style="text-align: center;" id="lblEstatus">Estatus</td>
						<td style="text-align: center;" id="lblGarantia">Garant&iacute;a FEGA / FONAGA</td>
						<td style="text-align: center;" id="lblGarantiaLiquida">Garant&iacute;a Liquida</td>
						<td style="text-align: center;" id="lblSaldoActual">SaldoActual</td>
					</tr>
					<c:forEach items="${listaResultado}" var="consolidacion" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}"  			  name="consecutivoID" value="${status.count}" readOnly="true" disabled="true"/>
								<input type="hidden" id="listaSolicitudCreditoID${status.count}"  	  name="listaSolicitudCreditoID" 		value="${consolidacion.solicitudCreditoID}" readOnly="true" disabled="true"/>
								<input type="hidden" id="listaFolioConsolidaID${status.count}"  	  name="listaFolioConsolidaID" 			value="${consolidacion.folioConsolidaID}" readOnly="true" disabled="true"/>
								<input type="hidden" id="listaDetalleFolioConsolidaID${status.count}" name="listaDetalleFolioConsolidaID" 	value="${consolidacion.detalleFolioConsolidaID}" readOnly="true" disabled="true"/>
								<input id="listaCreditoID${status.count}" name="listaCreditoID"  	 value="${consolidacion.creditoID}"  disabled="true"  style="text-align: center;"/>
							</td>
							<td>
								<input type="text" id="productoCreditoID${status.count}" name="listaProductoCreditoID" value="${consolidacion.productoCreditoID}" size="50" maxlength="100" disabled="true"  />
							</td>
							<td>
								<input type="text" id="montoCredito${status.count}" name="listaMontoCredito" value="${consolidacion.montoCredito}" size="18" esMoneda="true" style="text-align: right;" disabled="true" />
							</td>
							<td>
								<input type="text" id="fuenteFondeo${status.count}" name="listaFuenteFondeo" value="${consolidacion.fuenteFondeo}" size="40" maxlength="100" disabled="true" />
							</td>
							<td>
								<input type="text" id="estatus${status.count}" name="listaEstatus" value="${consolidacion.estatus}" size="20" maxlength="10" disabled="true" />
							</td>
							<td align="center">
								<c:choose>
									<c:when test="${consolidacion.garantiaFira == 'S'}">
										<input type="checkbox" id="garantiaFira${status.count}" name="listaGarantiaFira" disabled="true" checked="checked" />
									</c:when>
									<c:otherwise>
										<input type="checkbox" id="garantiaFira${status.count}" name="listaGarantiaFira" disabled="true" />
									</c:otherwise>
								</c:choose>
							</td>
							<td align="center">
								<c:choose>
									<c:when test="${consolidacion.garantiaLiquida == 'S'}">
										<input type="checkbox" id="garantiaLiquida${status.count}" name="listaGarantiaLiquida" disabled="true" checked="checked" />
									</c:when>
									<c:otherwise>
										<input type="checkbox" id="garantiaLiquida${status.count}" name="listaGarantiaLiquida" disabled="true" />
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<input type="text" id="montoExigible${status.count}" name="listaMontoExigible" value="${consolidacion.montoExigible}" size="18" esMoneda="true" style="text-align: right;" disabled="true" />
							</td>
							<td>
								<c:choose>
									<c:when test="${tipoLista == '2' }">
										<c:choose>
											<c:when test="${consolidacion.estatusSolicitud == 'I' }">
												<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminarConsolidacion(this.id)"/>
											</c:when>
										</c:choose>
									</c:when>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</table>
			</c:when>
		</c:choose>
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

</script>