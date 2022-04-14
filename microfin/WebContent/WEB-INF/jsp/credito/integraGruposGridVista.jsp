<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="controlIntegrante" value="${listaResultado[1]}"/>
<c:set var="listaResultado" value="${listaResultado[2]}"/>

	<c:choose>
		<c:when test="${controlIntegrante == '1' && tipoLista == '7'}">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Integrantes</legend>
				<table id="miTabla" border="0" align="left" width="60%">
					<tbody>
						<tr>
							<td class="label">
								<label for="lblClienteID"><s:message code="safilocale.cliente"/></label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Nombre</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Cuenta</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Cargo</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Exigible</label>
					  		</td>
					  		<td class="label">
								<label for="lblCantidad">Garant&iacute;a Adicional</label>
					  		</td>
					  	</tr>
						<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
							  	<td>
									<input  type ="text" id="clienteIDIntegrante${status.count}"  name="clienteIDIntegrante" size="10"
											  value="${Integrantes.clienteID}" readonly="true" disabled="true" />
									<input  type ="hidden" id="creditoIDIntegrante${status.count}"  name="creditoIDIntegrante" size="10"
											  value="${Integrantes.creditoID}" readonly="true" disabled="true" />
								</td>
							  	<td>
							  		<input  type ="text" id="nombreIntegrante${status.count}" name="nombreIntegrante" size="50"
											value="${Integrantes.nombreCompleto}" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  		<input type ="text"  id="cuentaGLID${status.count}" name="cuentaGLID" size="15"
											value="" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  		<c:choose>
										<c:when test="${Integrantes.cargo==1}">
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="PRESIDENTE" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==2}">
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="TESORERO" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==3}">
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="SECRETARIO" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==4}">
											<input  type ="text" id="cargo${status.count}" name="cargo" size="14" value="INTEGRANTE" readonly="true" disabled="true"/>
										</c:when>
										<c:otherwise>
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="${Integrantes.cargo}" readonly="true" disabled="true"/>
										</c:otherwise>
									</c:choose>
							  	</td>
							  	<td>
							  		<input  type ="text" id="saldoExigible${status.count}" name="saldoExigible" size="15" style="text-align: right;"
											value="${Integrantes.saldoExigible}" readonly="true" disabled="true"/>
							  	</td>
								<td>
									<input type ="text"  id="garantiaAdicional${status.count}"  name="garantiaAdicional" size="15"
											  value="0.00" esMoneda="true" style="text-align: right;"  autocomplete="off"
											  onfocus="validaFocoInputMonedaGrid(this.id);"
											  onBlur="validaSumaGarantiaAdicionalGrupal(${status.count});" />
								</td>
					     	</tr>
					     	<c:set var="varExigibleInt" value="${varExigibleInt+Integrantes.saldoExigible}"/>
						</c:forEach>
						<tr id="renglon${status.count}" name="renglon">
							<td colspan="2" nowrap="nowrap" class="label" align="right">
								<label for="lblNombre" id="labelPendienteAsignar"><b>Pendiente Asignar:</b></label>
							</td>
							<td>
								<input  type ="text" id="sumaPendienteGarAdiInt"  name="sumaPendienteGarAdiInt" size="15"
									 value="0.00" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
						  	<td nowrap="nowrap" class="label" align="right">
								<label for="lblNombre">Totales:</label>
							</td>
							<td>
								<input type ="text"  id="sumaExigibleInt"  name="sumaExigibleInt" size="15"
										  value="${varExigibleInt}" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
							<td>
								<input type ="text"  id="sumaGarantiaAdicionalInt"  name="sumaGarantiaAdicionalInt" size="15"
										  value="0.00" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
				     	</tr>
					</tbody>
				</table>
			</fieldset>
		</c:when>

		<c:when test="${controlIntegrante == '1' && tipoLista == '8'}">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Integrantes</legend>
				<table id="miTabla" border="0" align="left" width="60%">
					<tbody>
						<tr>
							<td class="label">
								<label for="lblClienteID"><s:message code="safilocale.cliente"/></label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Nombre</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Cuenta</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Cargo</label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Adeudo Total</label>
					  		</td>
					  		<td class="label">
								<label for="lblCantidad">Garant&iacute;a Adicional</label>
					  		</td>
					  	</tr>
						<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
							  	<td>
									<input type ="text" id="clienteIDIntegrante${status.count}"  name="clienteIDIntegrante" size="10"
											  value="${Integrantes.clienteID}" readonly="true" disabled="true" />
								</td>
							  	<td>
							  	<input  type ="text" id="nombreIntegrante${status.count}" name="nombreIntegrante" size="50"
											value="${Integrantes.nombreCompleto}" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  		<input type ="text"  id="cuentaGLID${status.count}" name="cuentaGLID" size="15"
											value="" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  		<c:choose>
										<c:when test="${Integrantes.cargo==1}">
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="PRESIDENTE" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==2}">
											<input  type ="text" id="cargo${status.count}" name="cargo" size="14" value="TESORERO" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==3}">
											<input  type ="text" id="cargo${status.count}" name="cargo" size="14" value="SECRETARIO" readonly="true" disabled="true"/>
										</c:when>
										<c:when test="${Integrantes.cargo==4}">
											<input  type ="text" id="cargo${status.count}" name="cargo" size="14" value="INTEGRANTE" readonly="true" disabled="true"/>
										</c:when>
										<c:otherwise>
											<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="${Integrantes.cargo}" readonly="true" disabled="true"/>
										</c:otherwise>
									</c:choose>
							  	</td>
							  	<td>
							  		<input  type ="text" id="adeudoTotal${status.count}" name="adeudoTotal" size="15" style="text-align: right;" esMoneda="true"
											value="${Integrantes.adeudoTotal}" readonly="true" disabled="true"/>
							  	</td>
								<td>
									<input type ="text" id="garantiaAdicional${status.count}"  name="garantiaAdicional" size="15"
											  value="0.00" esMoneda="true" style="text-align: right;"
											  onfocus="validaFocoInputMonedaGrid(this.id);"   autocomplete="off"
											   onBlur="validaSumaGarantiaAdicionalGrupal(${status.count});" />
								</td>
					     	</tr>
					     	<c:set var="varAdeudoTotalInt" value="${varAdeudoTotalInt+Integrantes.adeudoTotal}"/>
						</c:forEach>
						<tr id="renglon${status.count}" name="renglon">
							<td colspan="2" nowrap="nowrap" class="label" align="right">
								<label for="lblNombre"><b> Pendiente Asignar:</b></label>
							</td>
							<td>
								<input type ="text"  id="sumaPendienteGarAdiInt"  name="sumaPendienteGarAdiInt" size="15"
										  value="0.00" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
						  	<td nowrap="nowrap" class="label" align="right">
								<label for="lblNombre">Totales:</label>
							</td>
							<td>
								<input  type ="text" id="sumaExigibleInt"  name="sumaExigibleInt" size="15"
										  value="${varAdeudoTotalInt}" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
							<td>
								<input type ="text"  id="sumaGarantiaAdicionalInt"  name="sumaGarantiaAdicionalInt" size="15"
										  value="0.00" readonly="true" disabled="true" style="text-align: right;"/>
							</td>
				     	</tr>
					</tbody>
				</table>
			</fieldset>
		</c:when>
		<c:when test="${controlIntegrante == '1' && tipoLista == '10'}">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Integrantes</legend>
				<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tbody>
						<tr>
							<td class="label"><label for="lblSolicitudCre">Sol. Crédito</label></td>
							<td class="label"><label for="lblClienteID"><s:message code="safilocale.cliente"/></label></td>
					  		<td class="label"><label for="lblProspectoID">Prospecto</label></td>
					  		<td class="label"><label for="lblNombre">Nombre</label></td>
					  		<td class="label"><label for="lblCargo">Cargo</label></td>
					  		<td class="label"><label for="lblCargo">Estatus Sol.</label></td>
					  		<td class="label"><label for="lblMontoSolicitado">Monto Sol.</label></td>
					  		<td class="label" id="tdFormaCobSeguro"><label for="lblFormaCObSeg">Forma Cob. Seg</label></td>
					  		<td class="label"  id="tdMontoSeguro"> <label for="lblMontoSeguroVida">Monto Seg.</label></td>
					  		<td class="label" > <label for="lblCiclo">Ciclo</label></td>
					  		<td></td>
					  	</tr>
						<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
							<input type="hidden" id="calificaCredito${status.count}" value="${Integrantes.calificaCredito}" />
							<input type="hidden" id="pagaIVA${status.count}" value="${Integrantes.pagaIVA}" />

							<input type="hidden" id="estatus${status.count}"  name="lEstatusSolici" value="${Integrantes.estatus}"/>
							<input type="hidden" id="montoOriginal${status.count}"  name="lMontoOriginal" value="${Integrantes.montoOriginal}" esMoneda="true"/>
							<input type="hidden" id="forCobroComAper${status.count}"  name="forCobroComAper" value="${Integrantes.forCobroComAper}" esMoneda="true"/>
							<input type="hidden" id="montoComIva${status.count}"  name="montoComIva" value="${Integrantes.montoComIva}" esMoneda="true"/>
							<input type="hidden" id="descuentoSeguro${status.count}"  name="lDescuentoSeguro" value="${Integrantes.descuentoSeguro}" esMoneda="true"/>
							<input type="hidden" id="montoSegOriginal${status.count}"  name="lMontoSegOriginal" value="${Integrantes.montoSegOriginal}" esMoneda="true"/>

									<td>
											<input type="text" id="solicitudCre${status.count}" name="lSolicitudCre" size="7" value="${Integrantes.solicitudCreditoID}" readonly="true"  tabindex="3" onblur="setFoco();"/>
									</td>
									<td>
											<input type="text" id="clienteID${status.count}"  name="clienteID" size="10"  value="${Integrantes.clienteID}"readonly="true"/>
									</td>
									<td>
											<input type="text" id="prospectoID${status.count}"  name="prospectoID" size="10"  value="${Integrantes.prospectoID}" readonly="true"/>
									</td>
									<td>
									  		<input type="text" id="nombre${status.count}" name="nombre" size="50" value="${Integrantes.nombre}" readonly="true"/>
									</td>
									<td>
								  		<c:choose>
											<c:when test="${Integrantes.cargo==1}">
												<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="PRESIDENTE" readonly="true" />
											</c:when>
											<c:when test="${Integrantes.cargo==2}">
												<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="TESORERO" readonly="true" />
											</c:when>
											<c:when test="${Integrantes.cargo==3}">
												<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="SECRETARIO" readonly="true" />
											</c:when>
											<c:when test="${Integrantes.cargo==4}">
												<input  type ="text" id="cargo${status.count}" name="cargo" size="14" value="INTEGRANTE" readonly="true" />
											</c:when>
											<c:otherwise>
												<input type ="text"  id="cargo${status.count}" name="cargo" size="14" value="${Integrantes.cargo}" readonly="true" />
											</c:otherwise>
										</c:choose>
								  	</td>
									  <td>
												<c:if test="${Integrantes.estatus == 'I'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="INACTIVA" readOnly="true" />
												</c:if>
												<c:if test="${Integrantes.estatus == 'L'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="LIBERADA" readOnly="true" />
												</c:if>
												<c:if test="${Integrantes.estatus == 'A'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="AUTORIZADA" readOnly="true" />
												</c:if>
												<c:if test="${Integrantes.estatus == 'C'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="CANCELADA" readOnly="true" />
												</c:if>
												<c:if test="${Integrantes.estatus == 'R'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="RECHAZADA" readOnly="true" />
												</c:if>
												<c:if test="${Integrantes.estatus == 'D'}">
													<input type="text" id="estatusSolici${status.count}"  name="estatusSolici" size="18"  value="DESEMBOLSADA" readOnly="true" />
												</c:if>
									 </td>
								  	<td>
											<input type="text" id="montoSol${status.count}"  name="lMontoSol" size="15" style="text-align: right;" onblur="validaNuevoMontoSolicitud(this.id);"
													  value="${Integrantes.montoSol}" readonly="true" esMoneda="true" tabindex="${status.count +14}" onFocus="verificarEntrada(this.id)"/>
									</td>
									<td id="tdFormaCobSeguro${status.count}">
									  		<c:choose>
												<c:when test="${Integrantes.forCobroSegVida=='A'}">
													<input type ="text"  id="forCobroSegVida${status.count}" name="forCobroSegVida" size="18" value="ANTICIPADO" readonly="true" />
												</c:when>
												<c:when test="${Integrantes.forCobroSegVida=='D'}">
													<input  type ="text" id="forCobroSegVida${status.count}" name="forCobroSegVida" size="18" value="DEDUCCION" readonly="true" />
												</c:when>
												<c:when test="${Integrantes.forCobroSegVida=='F'}">
													<input type ="text" id="forCobroSegVida${status.count}" name="forCobroSegVida" size="18" value="FINANCIAMIENTO" readonly="true" />
												</c:when>
												<c:when test="${Integrantes.forCobroSegVida=='O'}">
													<input type ="text" id="forCobroSegVida${status.count}" name="forCobroSegVida" size="18" value="OTRO" readonly="true" />
												</c:when>
												<c:otherwise>
													<input type ="text"  id="forCobroSegVida${status.count}" name="forCobroSegVida" size="18" value="${Integrantes.forCobroSegVida}" readonly="true" />
												</c:otherwise>
											</c:choose>
								  	</td>
								  	<td id="tdMontoSeguro${status.count}">
											<input type="text" id="montoSeguroVida${status.count}"  name="montoSeguroVida" size="15"
												style="text-align: right;" value="${Integrantes.montoSeguroVida}" readonly="true" esMoneda="true"/>
									</td>

									<td>
											<input type="text" id="ciclo${status.count}"  name="ciclo" size="4" value="${Integrantes.ciclo}"
											 readonly="true" />
									</td>
									<td align="center">
				                     		<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminarFila(this.id)" />
								  	</td>
					     	</tr>
						</c:forEach>
					</tbody>
				</table>

				<div id="textGrid" class="label">
						<br/>
  						<label class="label">Al Modificar las Condiciones Todas las Solicitudes Cambiaran a un Estatus Inactivo</label>
						<br/>
  				</div>
			</fieldset>
		</c:when>

		<c:when test="${tipoLista == '7'}">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Integrantes</legend>
				<table id="miTabla" border="0" align="left" width="60%">
					<tbody>
						<tr>
							<td class="label">
								<label for="lblCreditoID">Credito</label>
					  		</td>
							<td class="label">
								<label for="lblCuentaID">Cuenta</label>
					  		</td>
					  		<td class="label">
								<label for="lblClienteID"><s:message code="safilocale.cliente"/></label>
					  		</td>
							<td class="label">
								<label for="lblNombre">Nombre</label>
					  		</td>
					  	</tr>
						<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
							  	<td>
									<input id="creditoIDIntegrante${status.count}"  name="creditoIDIntegrante" size="10"
											  value="${Integrantes.creditoID}"readonly="true" disabled="true" />
								</td>
							  	<td>
							  	<input id="cuentaGLID${status.count}" name="cuentaGLID" size="12"
											value="${Integrantes.cuentaAhoID}" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  	<input id="clienteID${status.count}" name="clienteID" size="12"
											value="${Integrantes.clienteID}" readonly="true" disabled="true"/>
							  	</td>
							  	<td>
							  	<input id="nombreIntegrante${status.count}" name="nombreIntegrante" size="50"
											value="${Integrantes.nombreCompleto}" readonly="true" disabled="true"/>
							  	</td>
					     	</tr>
						</c:forEach>
					</tbody>
				</table>
			</fieldset>
		</c:when>
	<c:when test="${tipoLista == '14'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Integrantes</legend>
			<table id="miTabla" border="0" align="left" width="60%">
					<tr>
						<td class="label" style="text-align: center;">
							<label>Cr&eacute;dito</label>
						</td>
						<td class="label" style="text-align: center;">
							<label><s:message code="safilocale.cliente" /></label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Nombre</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Estatus</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Capital</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Inter&eacute;s</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Monto Garant&iacute;a</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Comisi&oacute;n por Apertura</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>IVA Comisi&oacute;n por Apertura</label>
						</td>
						<td class="label" style="text-align: center;">
							<label>Cancelar</label>
						</td>
					</tr>
					<tbody id="tbodyIntegrantes">
					<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="text" id="creditoID${status.count}" name="creditoIDInt" size="10" value="${Integrantes.creditoID}" readonly="true" disabled="true" />
							</td>
							<td>
								<input type="text" id="clienteID${status.count}" name="clienteIDInt" size="10" value="${Integrantes.clienteID}" readonly="true" disabled="true" />
							</td>
							<td>
								<input type="text" id="nombreIntegrante${status.count}" name="nombreIntegrante" size="50" value="${Integrantes.nombre}" readonly="true" disabled="true" />
							</td>
							<td>
								<c:choose>
									<c:when test="${Integrantes.estatus == 'V'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="VIGENTE" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'C'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="CANCELADO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'I'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="INACTIVO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'P'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="PAGADO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'B'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="VENCIDO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'K'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="CASTIGADO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'D'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="DESEMBOLSADO" readonly="true" disabled="true" />
									</c:when>
									<c:when test="${Integrantes.estatus == 'A'}">
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="DESEMBOLSADO" readonly="true" disabled="true" />
									</c:when>
									<c:otherwise>
										<input type="text" id="estatusDes${status.count}" name="estatusDes" size="12" value="${Integrantes.estatus}" readonly="true" disabled="true" />
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<input type="text" id="capital${status.count}" name="capital" size="15" value="${Integrantes.montoAu}" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" />
							</td>
							<td>
								<input type="text" id="interes${status.count}" name="interes" size="15" value="${Integrantes.interes}" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" />
							</td>
							<td>
								<input type="text" id="montoGarantia${status.count}" name="montoGarantia" size="15" value="${Integrantes.montoGarantia}" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" />
							</td>
							<td>
								<input type="text" id="montoComApertura${status.count}" name="montoComApertura" size="15" value="${Integrantes.montoComApertura}" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" />
							</td>
							<td>
								<input type="text" id="IVAComisionApert${status.count}" name="IVAComisionApert" size="15" value="${Integrantes.IVAComisionApert}" esMoneda="true" readonly="true" disabled="true" style="text-align: right;" />
							</td>
							<td>
								<c:choose>
									<c:when test="${Integrantes.estatus == 'V'}">
										<input type="checkbox" id="creditoIDCheck${status.count}" name="creditoIDCheck" value="${Integrantes.creditoID}" />
									</c:when>
									<c:otherwise>
										<input type="checkbox" id="creditoIDCheck${status.count}" name="creditoIDCheck" value="${Integrantes.creditoID}" disabled="disabled" />
									</c:otherwise>
								</c:choose>
								<input type="hidden" id="estatusCredInt${status.count}" name="estatusCredInt" value="${Integrantes.estatus}" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</fieldset>
	</c:when>

	<c:when test="${controlIntegrante == '1' && tipoLista == '15'}">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Integrantes</legend>
				<table id="miTabla" border="0" width="100%">
					<tbody>
						<tr>
							<td class="label"><label for="lblSolicitudCre">Sol. de Cr&eacute;dito</label></td>
							<td class="label"><label for="lblClienteID"><s:message code="safilocale.cliente"/></label></td>
					  		<td class="label"><label for="lblProspectoID">Prospecto</label></td>
					  		<td class="label"><label for="lblNombre">Nombre</label></td>
					  		<td class="label"><label for="lblMontoSolicitado">Monto Cr&eacute;dito</label></td>
					  		<td class="label"><label for="lblCiclo">Ciclo</label></td>
					  		<td class="label"><label for="lblProducto">Producto de Cr&eacute;dito</label></td>
					  		<td></td>
					  	</tr>
						<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<input type="hidden" id="calificaCredito${status.count}" value="${Integrantes.calificaCredito}" />
								<input type="hidden" id="pagaIVA${status.count}" value="${Integrantes.pagaIVA}" />
								<input type="hidden" id="estatus${status.count}"  name="lEstatusSolici" value="${Integrantes.estatus}"/>
								<input type="hidden" id="montoOriginal${status.count}"  name="lMontoOriginal" value="${Integrantes.montoOriginal}" esMoneda="true"/>
								<input type="hidden" id="forCobroComAper${status.count}"  name="forCobroComAper" value="${Integrantes.forCobroComAper}" esMoneda="true"/>
								<input type="hidden" id="montoComIva${status.count}"  name="montoComIva" value="${Integrantes.montoComIva}" esMoneda="true"/>
								<input type="hidden" id="descuentoSeguro${status.count}"  name="lDescuentoSeguro" value="${Integrantes.descuentoSeguro}" esMoneda="true"/>
								<input type="hidden" id="montoSegOriginal${status.count}"  name="lMontoSegOriginal" value="${Integrantes.montoSegOriginal}" esMoneda="true"/>
								<td>
									<input type="text" id="solicitudCre${status.count}" name="lSolicitudCre" size="13" value="${Integrantes.solicitudCreditoID}" readonly="true"  tabindex="3" />
								</td>
								<td>
									<input type="text" id="clienteID${status.count}"  name="clienteID" size="10"  value="${Integrantes.clienteID}"readonly="true"/>
								</td>
								<td>
									<input type="text" id="prospectoID${status.count}"  name="prospectoID" size="10"  value="${Integrantes.prospectoID}" readonly="true"/>
								</td>
								<td>
								  	<input type="text" id="nombre${status.count}" name="nombre" size="50" value="${Integrantes.nombre}" readonly="true"/>
								</td>
							  	<td>
									<input type="text" id="montoSol${status.count}" name="lMontoSol" size="15" style="text-align: right;" value="${Integrantes.montoSol}" readonly="true" esMoneda="true" tabindex="${status.count +14}" />
								</td>
								<td>
									<input type="text" id="ciclo${status.count}" name="ciclo" size="6" value="${Integrantes.ciclo}" onkeypress="return validaSoloNumero(event,this);" maxlength="5"/>
								</td>
							  	<td>
									<input type="text" id="productCre${status.count}" name="productCre" size="20" value="${Integrantes.productoCreditoID}" readonly="readonly" />
								</td>
								<td align="center">
									<input type="button" name="cambiarCiclo" id="${status.count}" class="submit" value="Cambiar Ciclo" onclick="calculaCicloCliente('solicitudCre'+this.id)" />
								 </td>
					     	</tr>
						</c:forEach>
					</tbody>
				</table>
			</fieldset>
	</c:when>
	<c:otherwise>
			<form id="gridIntegrantes" name="gridIntegrantes">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Integrantes</legend>
					<input type="button" id="agregaIntegrante" value="Agregar" class="botonGral" tabindex="7"/>
						<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
							<tbody>
								<tr>
								<td class="label">
								   	<label for="lblconsecutivo"></label>
									</td>
									<td class="label">
								   	<label for="lblSolicitudCre">Sol. de Crédito</label>
									</td>
									<td class="label">
										<label for="lblNombre">Nombre</label>
							  		</td>
									<td class="label">
										<label for="lblClienteID"><s:message code="safilocale.cliente"/></label>
							  		</td>
							  		<td class="label">
										<label for="lblProspectoID">Prospecto</label>
							  		</td>
							  		<td class="label">
										<label for="lblMontoSol">Mto.Solicitado</label>
							  		</td>
							  		<td class="label">
										<label for="lblMontoAu">Mto.Autorizado</label>
							  		</td>
									<td class="label">
										<label for="lblProductoCre">Producto de Crédito</label>
							  		</td>
							  		<td class="label">
										<label for="lblCargo">Cargo</label>
							  		</td>
							  		</tr>

								<c:forEach items="${listaResultado}" var="Integrantes" varStatus="status">
									<tr id="renglon${status.count}" name="renglon">
										<td>
											<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"
													value="${status.count}" readonly="true" disabled="true" type="hidden"/>
									  	</td>
									  	<td>
											<input type="text" id="solicitudCre${status.count}" name="solicitudCre" size="15"
													 value="${Integrantes.solicitudCreditoID}" readonly="true"/>
									  	</td>
									  	<td>
									  	<input type="text" id="nombre${status.count}" name="nombre" size="50"
													value="${Integrantes.nombre}" readonly="true" disabled="true"/>

									  	</td>
									  	<td>
											<input type="text" id="clienteID${status.count}"  name="clienteID" size="10"
													  value="${Integrantes.clienteID}"readonly="true" disabled="true" />
										</td>
										<td>
											<input type="text" id="prospectoID${status.count}"  name="prospectoID" size="10"
													  value="${Integrantes.prospectoID}" readonly="true" disabled="true" />
										</td>



											<td>
											<input type="text" id="montoSol${status.count}"  name="montoSol" size="15"
													  value="${Integrantes.montoSol}" readonly="true" disabled="true"  />
										</td>
										<td>
											<input type="text" id="montoAu${status.count}"  name="montoAu" size="15"
													  value="${Integrantes.montoAu}" readonly="true" disabled="true" />
										</td>
										<td>
											<input type="text" id="productCre${status.count}"   name="productCre" size="20"
													 value="${Integrantes.productoCreditoID}"  disabled  />
										</td>

										<td nowrap = "nowrap">
										<c:if test="${Integrantes.cargo==-1}">
									         		<select id="cargo${status.count}" name="cargo"   readonly="true" disabled="true"   tabindex="7">
													<option value="" selected="true">Selecciona </option>
													<option value="1">Presidente </option>
													<option value="2" >Tesorero </option>
													<option value="3">Secretario </option>
													<option value="4">Integrante </option>


													</select>
													</c:if>

										<c:if test="${Integrantes.cargo==1}">
									         		<select id="cargo${status.count}" name="cargo"   readonly="true" disabled="true"  tabindex="7">
													<option value="" >Selecciona </option>
													<option value="1" selected="true">Presidente </option>
													<option value="2" >Tesorero </option>
													<option value="3">Secretario </option>
													<option value="4">Integrante </option>


													</select>
													</c:if>

															<c:if test="${Integrantes.cargo==2}">
									         		<select id="cargo${status.count}" name="cargo"  readonly="true" disabled="true"  tabindex="7">
													<option value="" >Selecciona </option>
													<option value="1" >Presidente </option>
													<option value="2" selected="true">Tesorero </option>
													<option value="3">Secretario </option>
													<option value="4">Integrante </option>


													</select>
													</c:if>

													<c:if test="${Integrantes.cargo==3}">
									         		<select id="cargo${status.count}" name="cargo"   readonly="true" disabled="true"  tabindex="7">
													<option value="" >Selecciona </option>
													<option value="1" >Presidente </option>
													<option value="2" >Tesorero </option>
													<option value="3" selected="true">Secretario </option>
													<option value="4">Integrante </option>


													</select>
													</c:if>

													<c:if test="${Integrantes.cargo==4}">
									         		<select id="cargo${status.count}" name="cargo"   readonly="true" disabled="true"  tabindex="7">
													<option value="" >Selecciona </option>
													<option value="1" >Presidente </option>
													<option value="2" >Tesorero </option>
													<option value="3" >Secretario </option>
													<option value="4"selected="true">Integrante </option>


													</select>
													</c:if>

									  		<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this.id);"/>
											<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle();"/>
									  	</td>
									  	<td>
											<input id="sexo${status.count}"  name="sexo" value="${Integrantes.sexo}" size="0"  type='hidden'/>
										</td><td>
											<input id="estadoCivil${status.count}"  name="estadoCivil" value="${Integrantes.estadoCivil}"   size="0" type='hidden' />
										</td>

							     	</tr>
								</c:forEach>
							</tbody>
						</table>
						<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
					</fieldset>

			</form>

		</c:otherwise>
	</c:choose>


<script type="text/javascript">
agregaFormatoControles('gridIntegrantes');
$("#numeroDetalle").val($('input[name=consecutivoID]').length);

function eliminaDetalle(numeroID){
	var jqTr = eval("'#renglon" + numeroID + "'");

	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var solicitudCre = eval("'#solicitudCre" + numeroID + "'");
	var nombre = eval("'#nombre" + numeroID + "'");
	var clienteID = eval("'#clienteID" + numeroID + "'");
	var prospectoID = eval("'#prospectoID" + numeroID + "'");
	var montoSol = eval("'#montoSol" + numeroID + "'");
	var montoAu = eval("'#montoAu" + numeroID + "'");
	var sexo = eval("'#sexo" + numeroID + "'");
	var estadoCivil = eval("'#estadoCivil" + numeroID + "'");
	var productCre = eval("'#productCre" + numeroID + "'");
	var cargo = eval("'#cargo" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");

	var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");


	//limpiando variables golbales de ultimos y ultimo estadocivil


	//Si es el primer Elemento
	if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
		$(jqConsecutivoIDSig).val("1");
	} if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
		//Valida Antes de actualizar, que si exista un sig elemento
		var i=0;
		for (i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
			jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");

			$(jqConsecutivoIDSig).val(numeroID);
			numeroID++;
		}
	}

	$(jqConsecutivoID).remove();
	$(solicitudCre).remove();
	$(nombre).remove();
	$(clienteID).remove();
	$(prospectoID).remove();
	$(montoSol).remove();
	$(montoAu).remove();
	$(sexo).remove();
	$(estadoCivil).remove();
	$(productCre).remove();
	$(cargo).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqTr).remove();
	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=consecutivoID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("id", "consecutivoID" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=solicitudCre]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("id", "solicitudCre" + contador);
		contador = contador + 1;
	});


		//Reordenamiento de Controles
		 contador = 1;
	   $('input[name=nombre]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "nombre" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de Controles
		contador = 1;
		$('input[name=clienteID]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "clienteID" + contador);
			contador = contador + 1;
		});

		//Reordenamiento de Controles
		contador = 1;
		$('input[name=prospectoID]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "prospectoID" + contador);
			contador = contador + 1;
		});

		//Reordenamiento de Controles
		contador = 1;
		$('input[name=montoSol]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "montoSol" + contador);
			contador = contador + 1;
		});

		//Reordenamiento de Controles
		contador = 1;
		$('input[name=montoAu]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "montoAu" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de sexo
		contador = 1;
		$('input[name=sexo]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "sexo" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de estadocivil
		contador = 1;
		$('input[name=estadoCivil]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
				$(jqCicInf).attr("id", "estadoCivil" + contador);
			contador = contador + 1;
		});

		//Reordenamiento de Controles
		contador = 1;
		$('input[name=productCre]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "productCre" + contador);
			contador = contador + 1;
		});

		//Reordenamiento de Controles
		contador = 1;
		$('select[name=cargo]').each(function() {
			var jqCicInf = eval("'#" + this.id + "'");
			$(jqCicInf).attr("id", "cargo" + contador);
			contador = contador + 1;
		});

		contador = 1;
		$('input[name=elimina]').each(function() {
			var jqCicElim = eval("'#" + this.id + "'");
			$(jqCicElim).attr("id", contador);
		   	contador = contador + 1;
		});

		contador = 1;
		$('input[name=agrega]').each(function() {
			var jqCicElim = eval("'#" + this.id + "'");
				$(jqCicElim).attr("id", "agrega"+ contador);
		   	contador = contador + 1;
		});

		contador = 1;
		//Reordenamiento de Controles
		$('tr[name=renglon]').each(function() {
			var jqCicTr = eval("'#" + this.id + "'");
			$(jqCicTr).attr("id", "renglon" + contador);
			contador = contador + 1;
		});

	$('#numeroDetalle').val($('#numeroDetalle').val()-1);
	inicializaGlobalesGrupalesGrid();
}

function agregaNuevoDetalle(){
	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

  if(numeroFila == 0){
		tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" disabled="true" type="hidden" value="1" autocomplete="off" /></td>';
	}else{
		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3"  type="hidden" disabled="true" value="'+nuevaFila+'" autocomplete="off"/></td> ';
	}



	tds += '<td><input type="text"	id="solicitudCre'+	nuevaFila+'" name="solicitudCre"	size="15" 								value=""  autocomplete="off" onkeypress="listaSolicitud(this.id)" onblur="consultaSolicitudGrid(this.id)"/></td>';
		tds += '<td><input type="text" id="nombre'+nuevaFila+'" name="nombre" size="50"  disabled="true" value="" autocomplete="off"/></td>';
		tds += '<td><input type="text" id="clienteID'+nuevaFila+'" name="clienteID" size="10"  disabled="true"value="" autocomplete="off"/></td>';
		tds += '<td><input type="text" id="prospectoID'+nuevaFila+'" name="prospectoID" size="10"  disabled="true" value="" autocomplete="off"/></td>';
	tds += '<td><input type="text"	id="montoSol'+		nuevaFila+'" name="montoSol"		size="15" disabled="true" 				value=""  autocomplete="off" esTasa="true" /></td>';
	tds += '<td><input type="text"	id="montoAu'+		nuevaFila+'" name="montoAu" 		size="15" disabled="true" 				value=""  autocomplete="off" esTasa="true" /></td>';
	tds += '<td><input type="text"	id="productCre'+	nuevaFila+'" name="productCre"		size="20" disabled="true"				value=""  autocomplete="off"/></td>';
	tds += '<td nowrap = "nowrap">';
	tds += '<select id="cargo'+	nuevaFila+'" name="cargo">';
	tds += '<option value="-1">Selecciona</option>';
	tds += '<option value="1">Presidente</option>';
	tds += '<option value="2">Tesorero</option>';
	tds += '<option value="3">Secretario</option>';
		tds += '<option value="4">Integrante</option></select>';
	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this.id)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	tds += '<td><input id="sexo'+nuevaFila+'" name="sexo" type="hidden" /></td>';
	tds += '<td><input id="estadoCivil'+nuevaFila+'" name="estadoCivil" type="hidden" /></td>';
   tds += '</tr>';
   if(validamaxmin()){ return;}
	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);


	return false;
}





function validamaxmin(){
	var total = 0;

	$('input[name=elimina]').each(function() {

		total = total +1;
	});
	if(total 	>= 	getMax() && total>0 && getMax()>0 ){alert('Se ha alcanzado el Número Máximo de Filas para Ingresar Solicitudes al Grupo.');  return true;}

	return false;
}

$("#agregaIntegrante").click(function() {
	agregaNuevoDetalle();
	});

function agregaFormato(idControl){
	var jControl = eval("'#" + idControl + "'");

 	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
					colorize: true,
					positiveFormat: '%n',
					roundToDecimalPlace: -1
					});
	});
	$(jControl).blur(function() {
			$(jControl).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
			});
	});

}

</script>

