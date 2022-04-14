<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaClasifClavePresup" value="${listaResultado[1]}" />

<c:choose>
	<c:when test="${tipoLista == '1'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>DETALLE </legend>
			<table id="miTabla">
				<tbody>
					<tr>
						<td class="label"> 
							<label for="lblDescripcion">Convenio </label>
						</td>
						<td class="label">
							<label for="lblNomClavePresupID">Claves </label>
						</td>
					</tr>
					<c:forEach items="${listaClasifClavePresup}" var="clasifClavePresup" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">

							<td>
								<input type="hidden" id="clavePresupConvenioID${status.count}" name="clavePresupConvenioID" size="6"  value="${clasifClavePresup.nomClaveConvenioID}" readOnly="true"/>
								<input type="text"  id="descripcion${status.count}" name="descripcion" size="50" value="${clasifClavePresup.descripcion}"  onBlur="ponerMayusculas(this)" readOnly="true"/>
							</td>

							<td>
								<select MULTIPLE id="clavePresupID${status.count}" name="clavePresupID"  size="3" cols="2" rows="3" disabled="true" style="width:400px"></select>
							</td>
						</tr>

						<c:set var="numeroClaveConv" value="${status.count}" />
					</c:forEach>
					<input type="hidden" value="${numeroClaveConv}" name="numeroClavConv" id="numeroClavConv" />
				</tbody>
			</table>
		</fieldset>
	</c:when>
</c:choose>

<script type="text/javascript">
	consulClavePresupCombo();
</script>