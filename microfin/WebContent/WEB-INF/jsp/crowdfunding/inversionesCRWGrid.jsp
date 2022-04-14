<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="listaResultado"  value="${listaResultado[0]}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Inversionistas</legend>
		<form id="gridDetalle" name="gridDetalle" commandName="fondeoSolicitudBean">

			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr>

			     		<td class="label">
			         	<label for="lblNumInv">No.Inversi&oacute;n</label>
			     		</td>
						<td class="label">
							<label for="lblClienteID">No. <s:message code="safilocale.cliente"/></label>
				  		</td>
				  		<td class="label">
			         	<label for="lblNombreCte">Nombre</label>
			     		</td>
						<td class="label">
			         	<label for="lblNombreCte">Consecutivo</label>
			     		</td>
			     		<td class="label">
			         	<label for="lblPorcen">% Fondeo</label>
			     		</td>
						<td class="label">
			         	<label for="lblMonto">Monto</label>
			     		</td>
						<td class="label">
			         	<label for="lblTasa">Tasa</label>
			     		</td>
			     		<td class="label">
			         	<label for="lblTasa">GAT</label>
			     		</td>
			     		<td class="label">
			         	<label for="lblDetalle">Detalle</label>
			     		</td>
					</tr>

					<c:forEach items="${listaResultado}" var="fondeo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">

							<c:if test="${fondeo.fondeoKuboID == 0}">
							<td>
								<input id="fondeoKuboID${status.count}"  name="fondeoKuboID" size="6"
									value="N/A" readOnly="true" disabled="true"/>
						  	</td>
						  	</c:if>
						  	<c:if test="${fondeo.fondeoKuboID != 0}">
							<td>
								<input id="fondeoKuboID${status.count}"  name="fondeoKuboID" size="6"
									value="${fondeo.fondeoKuboID}" readOnly="true" disabled="true"/>
						  	</td>
						  	</c:if>
						  	<td>
								<input id="clienteID${status.count}" name="clienteID" size="12"
										value="${fondeo.clienteID}" readOnly="true" disabled="true"/>
						  	</td>
						  	<td>
								<input id="nombreCte${status.count}" name="nombreCte" size="50"
										value="${fondeo.nombreCompleto}" readOnly="true" disabled="true"/>
						  	</td>
							<td>
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"
										value="${status.count}" disabled="true"/>
						  	</td>
							<td>
				         	<input style="text-align:right" id="porcentajeFondeo${status.count}" name="porcentajeFondeo" size="10" align="right"
				         			value="${fondeo.porcentajeFondeo}" readOnly="true" disabled="true" />
				     		</td>
					  		<td>
				         	<input style="text-align:right" id="montoFondeo${status.count}" name="montoFondeo" size="10"
				         			value="${fondeo.montoFondeo}" readOnly="true" disabled="true" esMoneda="true"/>
				     		</td>
							<td>
				         	<input style="text-align:right" id="tasaPasiva${status.count}" name="tasaPasiva" size="10"
				         			value="${fondeo.tasaPasiva}" readOnly="true" disabled="true" />
				     		</td>
				     		<td>
				         	<input style="text-align:right" id="gat${status.count}" name="gat" size="10"
				         			value="${fondeo.gat}" readOnly="true" disabled="true" />
				     		</td>
				     		<td>
								<input type="radio" id="status${status.count}" name="estatus" size="12"
										value="${fondeo.fondeoKuboID}"  />
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="8">
							<table align="right" border='0'>
								<tr>
								<td align="right">
								<input type="button" id="planAmortizacion" name="planAmortizacion" class="submit"
								value="Plan Amortizaci&oacute;n" tabindex="12" />
								<input type="button" id="saldosYpagos" name="saldosYpagos" class="submit"
								value="Saldos y Pagos" tabindex="13" />
								<input type="button" id="detMovimientos" name="detMovimientos" class="submit"
								value="Det.Movimientos " tabindex="14" />
								</td>

							</table>
						</td>
					</tr>
				</tbody>
			</table>
</form>

</fieldset>