<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="listaResultado"	value="${listaResultado[0]}"/>

<br></br>
<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td nowrap="nowrap" valign="top">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Movimientos Internos</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="lblMovConcilia">Mov. Concilia</label> 
					</td>
					<td class="label"> 
						<label for="lblFecha">Fecha Ope.</label> 
					</td> 
					<td class="label"> 
						<label for="lblFecha">Operaci&oacute;n</label> 
					</td>
					<td class="label"> 
						<label for="lblDescripcion">N&uacute;m. Tarjeta</label> 
					</td>
					<td class="label"> 
						<label for="lblDescripcion">Referencia</label> 
					</td>
					<td class="label" align="center"> 
						<label for="lblNaturaleza">Monto</label> 
					</td>	
					<td class="label"> 
						<label for="lblestatus"></label> 
					</td>
				</tr>
				<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
				<tr id="renglon${status.count}" name="renglon" style="height: 40px;">
					<td>
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input id="numeroMov${status.count}" name="numeroMov" size="8" value="" readOnly="true" style="border: none;background-color: transparent;"/>
								<input type="hidden" id="tarDebMovID${status.count}" name="tarDebMovID" size="10"  value="${movsInter.tarDebMovID}" />
							</c:when>
							<c:otherwise>
								<input id="numeroMov${status.count}" name="numeroMov" size="8" value="${movsInter.tarDebMovID}" readOnly="true" disabled="true"/>
								<input type="hidden" id="tarDebMovID${status.count}" name="tarDebMovID" size="10"  value="${movsInter.tarDebMovID}" />
							</c:otherwise>
						</c:choose>
            	</td>
					<td>
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input id="fecha${status.count}"  name="fechaMov" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="fecha${status.count}"  name="fechaMov" size="11"  value="${movsInter.fechaOperacion}" readOnly="true" disabled="true"/>
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input type="text" id="descOperacion${status.count}" name="descOperacion" size="15" value="" readOnly="true" style="border: none;background-color: transparent;" />
								<input type="hidden" id="tipoOpe${status.count}"  name="tipoOpe" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="descOperacion${status.count}" name="descOperacion" size="15" value="${movsInter.descOperacion}" readOnly="true" disabled="true" />
								<input type="hidden" id="tipoOpe${status.count}"  name="tipoOpe" size="11"  value="${movsInter.tipoOperacionID}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>
					</td> 
					<td> 
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input id="numTarjeta${status.count}"  name="numTarjeta" size="20"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="numTarjeta${status.count}"  name="numTarjeta" size="20"  value="${movsInter.tarjetaDebID}" readOnly="true" disabled="true"/>
							</c:otherwise>
						</c:choose>
					</td> 
					<td align="center"> 
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input id="referencia${status.count}"  name="referencia" size="6" value="${movsInter.numReferencia}" readOnly="true" style="border: none;background-color: transparent;" />
							</c:when>
							<c:otherwise>
								<input id="referencia${status.count}"  name="referencia" size="6" value="${movsInter.numReferencia}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>
					</td>   
					<td>
						<c:choose>
							<c:when test="${movsInter.tarDebMovID == '0'}">
								<input id="montoMov${status.count}" name="montoMov" size="12" value="" readOnly="true"  esMoneda="true" style="text-align: right;border: none;background-color: transparent;" type="hidden"/>
							</c:when>
							<c:otherwise>
								<input id="montoMov${status.count}" name="montoMov" size="12" value="${movsInter.montoOperacion}" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/>
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${movsInter.estatusConci == 'C'}">
								<input type="checkbox" id="chkConciliaMov${status.count}" name="chkConciliaMov"	
									value="${movsInter.tarDebMovID},${movsInter.tipoOperacionID},${movsInter.tarjetaDebID},${movsInter.numReferencia}" 
									CHECKED onclick="controlCheckMov(this.id)"/>
							</c:when>
							<c:when test="${movsInter.estatusConci == 'N'}">
								<input type="checkbox" id="chkConciliaMov${status.count}" name="chkConciliaMov"	
									value="${movsInter.tarDebMovID},${movsInter.tipoOperacionID},${movsInter.tarjetaDebID},${movsInter.numReferencia}"/>
							</c:when>
						</c:choose>
					</td>
					<td>
						<c:set var="montoOpeInt" value="${movsInter.montoOperacion}"/>
						<fmt:parseNumber var="montoOperacionInt" type="number" value="${montoOpeInt}" />
						<c:set var="montoOpeExt" value="${movsInter.importeOrigenTrans}"/>
						<fmt:parseNumber var="montoOperacionExt" type="number" value="${montoOpeExt}" />
						<c:choose>
							<c:when test="${movsInter.estatusConci == 'C'}">
								<input type="hidden" id="transaccion${status.count}" name="listMovConcilia"
								value="${movsInter.tarDebMovID},${movsInter.tipoOperacionID},${movsInter.tarjetaDebID},${movsInter.numReferencia}, ${montoOperacionInt},${movsInter.conciliaID},${movsInter.detalleID},${movsInter.tipoTransaccion},${movsInter.numCuenta},${movsInter.numAutorizacion},${montoOperacionExt}"/>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${movsInter.tarDebMovID != '0'}">
										<input type="hidden" id="transaccion${status.count}" name="listMovConcilia" />
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<c:set var="cont" value="${status.count}"/>
				</c:forEach>
			</table>
			<input id="vacio"  name="vacio" value="${cont}" type="hidden" readOnly="true" disabled="true"/>
			</fieldset>
		</td>
		<td nowrap="nowrap" valign="top">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Movimientos Externos</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="lblFecha">Fecha Ope.</label> 
					</td>
					<td class="label"> 
						<label for="lblTipoOpe">Operaci&oacute;n</label> 
					</td>
					<td class="label"> 
						<label for="lblNumTarjeta">N&uacute;m Tarjeta</label> 
					</td>
					<td class="label"> 
						<label for="lblReferencia">Referencia</label> 
					</td>	
					<td class="label" align="center"> 
						<label for="lblMonto">Monto</label> 
					</td>
					<td class="label"> 
				    	<label for="lblMovConcilia">Mov. Concilia</label> 
				   	</td> 
				</tr>
				<c:forEach items="${listaResultado}" var="movsExter" varStatus="status">
				<tr id="renglon${status.count}" name="renglon" style="height: 40px;">
					<td>
						<c:choose>
							<c:when test="${movsExter.conciliaID == '0'}">
								<input id="fechaOperacionArch${status.count}" name="fechaOperacionArch" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/> 
								<input type="hidden" id="folioCarga${status.count}" name="folioCarga" size="12"  value="0" />
								<!--input type="hidden" id="folioDetalle${status.count}" name="folioDetalle" size="12"  value="0" /-->
							</c:when>
							<c:otherwise>
								<input id="fechaOperacionArch${status.count}"  name="fechaOperacionArch" size="11"  value="${movsExter.fechaProceso}" readOnly="true" disabled="true"/> 
								<input type="hidden"  id="folioCarga${status.count}"  name="folioCarga" size="12"  value="${movsExter.conciliaID}" /> 
								<input type="hidden"  id="folioDetalle${status.count}"  name="folioDetalle" size="12"  value="${movsExter.detalleID}" />
							</c:otherwise>
						</c:choose>
					</td> 
					<td> 
						<c:choose>
							<c:when test="${movsExter.conciliaID == '0'}">
								<input type="text" id="descOpeArch${status.count}"  name="descOpeArch" size="15"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
								<input type="hidden" id="tipoOpeArch${status.count}"  name="tipoOpeArch" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="descOpeArch${status.count}"  name="descOpeArch" size="15"  value="${movsExter.descTipoTransaccion}" readOnly="true" disabled="true" />
								<input type="hidden" id="tipoOpeArch${status.count}"  name="tipoOpeArch" size="11"  value="${movsExter.tipoTransaccion}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>								 
					</td> 
					<td>
						<c:choose>
							<c:when test="${movsExter.conciliaID == '0'}">
								<input id="numTarjetaArch${status.count}"  name="numTarjetaArch" size="20"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="numTarjetaArch${status.count}"  name="numTarjetaArch" size="20"  value="${movsExter.numCuenta}" readOnly="true" disabled="true"/>
							</c:otherwise>
						</c:choose>
					</td>
					<td align="center">
						<c:choose>
							<c:when test="${movsExter.conciliaID == '0'}">
								<input id="referenciaArch${status.count}"  name="referenciaArch" size="6" value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="referenciaArch${status.count}"  name="referenciaArch" size="6" value="${movsExter.numAutorizacion}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${movsExter.conciliaID == '0'}">
								<input id="montoMovArch${status.count}" name="montoMovArch" size="12" value="" readOnly="true"  esMoneda="true" style="text-align: right;border: none;background-color: transparent;" type="hidden"/>
							</c:when>
							<c:otherwise>
								<input id="montoMovArch${status.count}" name="montoMovArch" size="12" value="${movsExter.importeOrigenTrans}" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />							
							</c:otherwise>
						</c:choose>  
					</td>
					<td>
						<c:choose>
							<c:when test="${movsExter.estatusConci == 'C'}">
								<input type="text" id="numConcilia${status.count}" name="numConcilia" size="5" value="${movsExter.tarDebMovID}" onblur="cambiaEstatus(this.id);"/>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${movsExter.conciliaID != '0'}">
										<input type="text" id="numConcilia${status.count}" name="numConcilia" size="5" value="" onblur="cambiaEstatus(this.id);"/>
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				</c:forEach>
			</table>
			</fieldset>
		</td>
	</tr>
</table>