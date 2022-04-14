<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="cobrosPendBean" value="${listaResultado[2]}"/>
<form id="formaGenerica1" name="formaGenerica1">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<table id="tablaLista">
		<c:choose>
			<c:when test="${tipoLista >= '1'}">
				<legend>Cargos Pendientes</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr id="encabezadoLista">
							<td>Fecha de Cargo</td>
							<td>Descripci&oacute;n</td>
							<td align="right">Monto Cargo Pendiente Original</td>
							<td align="right">Adeudo Actual</td>
						</tr>
						<c:forEach items="${cobrosPendBean}" var="registroCargoPend" varStatus="status">
						<tr>
							<td><label  id="fecha${status.count}" name="fecha" size="10"> ${registroCargoPend.fecha}</label></td>
							<td align="left">
								<label for="descripcion" id="descripcion${status.count}" name="descripcion" size="15"> ${registroCargoPend.descripcion}</label></td>
							<td align="right">
								<label  id="cantPenOri${status.count}" name="cantPenOri" size="10"> ${registroCargoPend.cantPenOri}</label> 
							</td>
							<td align="right"> 
								<label  id="cantPenAct${status.count}" name="cantPenAct" size="10"> ${registroCargoPend.cantPenAct}</label> 
							</td>
						</tr>
						
						<c:set var="sumCanPenOri" value="${registroCargoPend.sumCanPenOri}"/>
						<c:set var="sumCanPenAct" value="${registroCargoPend.sumCanPenAct}"/>
						</c:forEach>
						<tr>
							<td></td>
							<td class="label" align="right"><label for="saldoTotal">Total Cargos Pendientes:</label></td>
							<td class="label" align="right">
								<label id="sumCanPenOri" name="sumCanPenOri" size="15">${sumCanPenOri}</label>
							</td>
							<td class="label" align="right">
								<label id="sumCanPenAct" name="sumCanPenAct" size="15">${sumCanPenAct}</label>
							</td>
						</tr>
					</table>
			</c:when>
		</c:choose>
	</table>
	</fieldset>
</form>
	

