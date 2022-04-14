<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaClavePresupConv" value="${listaResultado[1]}" />

<c:choose>
	<c:when test="${tipoLista != '0'}">
		<table id="miTabla">
			<tbody>
				<tr>
					<td class="label" align="left" style="font-weight: bold;">
						<label for="lblClave" style="color: black;">CLAVE </label>
					</td>
					<td class="label" align="left" style="font-weight: bold;">
						<label for="lblDescripcion" style="color: black;">DESCRIPCI&Oacute;N</label>
					</td>
					<td class="label" align="left" style="font-weight: bold;">
						<label for="lblInporte" style="color: black;">&nbsp;&nbsp;IMPORTE</label>
					</td>
				</tr>
				<c:forEach items="${listaClavePresupConv}" var="clavePresupConv" varStatus="statusClave">
					<tr id="renglonClave${statusClave.count}" name="renglonClave">
						<td>
							<input type="hidden" id="${clavePresupConv.nomClasifClavPresupID}clasifClavPresupID${statusClave.count}" name=clasifClavPresupID size="8"  value="${clavePresupConv.nomClasifClavPresupID}" readOnly="true" />
							<input type="hidden" id="${clavePresupConv.nomClasifClavPresupID}desclasifClavPresup${statusClave.count}" name=desclasifClavPresup size="8"  value="${clavePresupConv.descClasifClavPresup}" readOnly="true" />
							<input type="hidden" id="${clavePresupConv.nomClasifClavPresupID}nomClavePresupID${statusClave.count}" name="nomClavePresupID" size="8"  value="${clavePresupConv.nomClavePresupID}" readOnly="true" />
							<input type="text"  id="clave${statusClave.count}" name="clave" size="10" value="${clavePresupConv.clave}" style="text-align: left; border: 0;" onBlur="ponerMayusculas(this)" readOnly="true"/>
						</td>

						<td>
							<input type="text" id="${clavePresupConv.nomClasifClavPresupID}descripcion${statusClave.count}" name="descripcion" style="text-align: left; border: 0;" size="35" value="${clavePresupConv.descripcion}"readOnly="true"/>
						</td>
						<td>
							<input type="text" id="${clavePresupConv.nomClasifClavPresupID}importe${statusClave.count}" name="importe" size="12" style="text-align: right" onblur="sumaTotalImporte(this.id,${clavePresupConv.nomClasifClavPresupID});" esMoneda="true"/>
						</td>
					</tr>
					<c:set var="numClaveConv" value="${statusClave.count}" />
					<c:set var="nomClasifClavPresupID" value="${clavePresupConv.nomClasifClavPresupID}" />
				</c:forEach>

				<tr>
					<td>
					</td>
					<td align="right" style="font-weight: bold;">
						<label style="color: black;" for="lbltotalImporte">TOTAL: $</label>
					</td>
					<td >
						<input type="text" id="totalImporte${nomClasifClavPresupID}" name="totalImporte" size="12" readonly="true" esMoneda="true" value="0.00" style="text-align: right"/>
					</td>
				</tr>
				<input type="hidden" value="${numClaveConv}" name="numClaveConv${nomClasifClavPresupID}" id="numClaveConv${nomClasifClavPresupID}" />
			</tbody>
		</table>
	</c:when>
</c:choose>
