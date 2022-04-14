<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>
<body>
<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaResultado" value="${listaResultado[1]}" />
<%! int numtab = 300; %>
<%!double montoTotal = 0;%>
<table id="miTablaOF" width="100%">
	<c:choose>
		<c:when test="${tipoLista == '3'}">
			<thead>
				<tr>
					<td class="label" nowrap="nowrap" style="text-align: center;">
						<label for="lblConceptos">Concepto </label>
					</td>
					<td class="label" style="text-align: center;">
						<label for="lblConceptos">Descripci&oacute;n</label>
					</td>
					<td class="label" nowrap="nowrap" style="text-align: center;">
						<label for="lblConceptos">No. Unidades</label>
					</td>
					<td class="label" style="text-align: left;">
						<label for="lblConceptos">Unidades</label>
					</td>
					<td class="label" style="text-align: center;">
						<label for="lblConceptos">Monto</label>
					</td>
					<td></td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listaResultado}" var="tipoRecursoLis" varStatus="status">
					<tr id="renglonOF${status.count}" name="renglonOF">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="text" id="conceptoInvIDROF${status.count}" name="conceptoInvIDROF" size="12" value="${tipoRecursoLis.conceptoInvIDROF}" onkeyup="muestraLista(this.id)" onblur="consultaConceptoOF(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>" />
						</td>
						<td>
							<input type="text" size="53" id="descripcionOF${status.count}" name="descripcionOF" value="${tipoRecursoLis.descripcionOF}" readonly="true" />
						</td>
						<td>
							<input type="text" size="20" id="noUnidadOF${status.count}" name="noUnidadOF" value="${tipoRecursoLis.noUnidadOF}" onChange="validarSiNumeroOF(this.value,'${status.count}');" tabindex="<%=numtab++%>" />
						</td>
						<td nowrap="nowrap">
							<input type="text" id="claveUnidadOF${status.count}" name="claveUnidadOF" size="6" value="${tipoRecursoLis.claveUnidadOF}" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoOFUnidad(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>" />
							<input type="text" size="30" id="unidadOF${status.count}" name="unidadOF" value="${tipoRecursoLis.unidadOF}" readonly="true" />
						</td>
						<td>
							<input type="text" size="20" id="montoInversionROF${status.count}" name="montoInversionROF" value="${tipoRecursoLis.montoInversionROF}" esMoneda="true" maxlength="21" style="text-align: right;" onblur="sumaMontoOtrasFuentes();" tabindex="<%=numtab++%>" />
						</td>
						<td>
							<input type="button" name="eliminar" id="eliminaOF${status.count}" class="btnElimina" onclick="eliminaDetalleOF(this);sumaMontoOtrasFuentes()" tabindex="<%=numtab++%>" />
						</td>
						<td>
							<input type="button" name="agregar" id="agregarOF${status.count}" class="btnAgrega" onclick="agregaNuevoDetalleOF()" tabindex="${status.count}" tabindex="<%=numtab++%>" />
						</td>
						<td>
							<input type="hidden" id="tipoRecursoOF${status.count}" name="tipoRecursoOF" path="tipoRecursoOF" value="OF" />
						</td>
					</tr>
					<c:set var="cont" value="${status.count}" />
					<c:set var="montoTotal" value="${tipoRecursoLis.totalotrasFuentes}" />
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td class="separador"></td>
					<td class="label" align="right" colspan="3">
						<label for="totalotrasFuentes">Total:</label>
					</td>
					<td>
						<input type="text" id="totalotrasFuentes" name="totalotrasFuentes" esMoneda="true" style="text-align: right;" disabled="disabled" value="${montoTotal}" />
					</td>
				</tr>
			</tfoot>
		</c:when>
	</c:choose>
</table>
<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
</body>
</html>	