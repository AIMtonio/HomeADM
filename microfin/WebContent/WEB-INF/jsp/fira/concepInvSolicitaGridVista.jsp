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
		<table id="miTablaSol" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '2'}">
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
					<tr id="renglonS${status.count}" name="renglonS">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}"/>
							<input type="text" id="conceptoInvIDRS${status.count}" name="conceptoInvIDRS" size="12" value="${tipoRecursoLis.conceptoInvIDRS}" onkeyup="muestraLista(this.id)" onblur="consultaConceptoSol(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>" />							
						</td>					
						<td>
							<input type="text" size="53" id="descripcionRS${status.count}" name="descripcionRS" value="${tipoRecursoLis.descripcionRS}" readonly="true"/>
						</td>
						<td>
							<input type="text" size="20" id="noUnidadRS${status.count}" name="noUnidadRS" value="${tipoRecursoLis.noUnidadRS}" onChange="validarSiNumeroRS(this.value,'${status.count}');" tabindex="<%=numtab++%>" />
						</td>
						<td nowrap="nowrap">
							<input type="text" id="claveUnidadRS${status.count}" name="claveUnidadRS" size="6" value="${tipoRecursoLis.claveUnidadRS}" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoRSUnidad(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>" />
							<input type="text" size="30" id="unidadRS${status.count}" name="unidadRS" value="${tipoRecursoLis.unidadRS}" readonly="true" />
						</td>
						<td>
							<input type="text" size="20" id="montoInversionRS${status.count}" name="montoInversionRS" value="${tipoRecursoLis.montoInversionRS}" esMoneda="true" maxlength="21" style="text-align:right;" onblur="sumaMontoSolicitante();" tabindex="<%=numtab++%>"/>
						</td>	
						
						<td> 
							<input type="button" name="eliminar" id="eliminaRS${status.count}"  class="btnElimina" onclick="eliminaDetalleSol(this);sumaMontoSolicitante()" tabindex="<%=numtab++%>"/>
						</td> 
						<td>
							<input type="button" name="agregar" id="agregarRS${status.count}" class="btnAgrega" onclick="agregaNuevoDetalleSol()"  tabindex="<%=numtab++%>" />
						</td>
						<td>
							<input type="hidden" id="tipoRecursoRS${status.count}" name="tipoRecursoRS" value="S"/>
						</td>
					</tr>
					<c:set var="cont" value="${status.count}"/>
					<c:set var="montoTotal" value="${tipoRecursoLis.totalSolicitante}" />
					</c:forEach>
				</tbody>
				<tfoot>
						<tr>
							<td class="separador"></td>
							<td class="label" align="right" colspan="3">
								<label for="totalSolicitante">Total:</label>
							</td>
							<td>
								<input type="text" id="totalSolicitante" name="totalSolicitante" esMoneda="true" style="text-align: right;" disabled="disabled" value="${montoTotal}"/>
							</td>
						</tr>
					</tfoot>
			</c:when>
		</c:choose>
	</table>
	 <input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
</body>
</html>	

