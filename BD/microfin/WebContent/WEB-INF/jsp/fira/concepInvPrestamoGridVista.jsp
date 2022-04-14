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
		<table id="miTablaP" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
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
					<tr id="renglonP${status.count}" name="renglonP">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="text" id="conceptoInvIDRP${status.count}" name="conceptoInvIDRP" size="12" value="${tipoRecursoLis.conceptoInvIDRP}" onkeyup="muestraLista(this.id)" onblur="consultaConcepto(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>"/>							
						</td>					
						<td>
							<input type="text" size="53" id="descripcionRP${status.count}" name="descripcionRP" value="${tipoRecursoLis.descripcionRP}" readonly="true"/>
						</td>
						<td>
							<input type="text" size="20" id="noUnidadRP${status.count}" name="noUnidadRP" value="${tipoRecursoLis.noUnidadRP}" onChange="validarSiNumeroRP(this.value,'${status.count}');" tabindex="<%=numtab++%>" />
						</td>
						<td nowrap="nowrap">
							<input type="text" id="claveUnidadRP${status.count}" name="claveUnidadRP" size="6" value="${tipoRecursoLis.claveUnidadRP}" onkeyup="muestraListaUnidad(this.id)" onblur="consultaConceptoRPUnidad(this.id,'${status.count}');" autocomplete="off" maxlength="20" tabindex="<%=numtab++%>" />
							<input type="text" size="30" id="unidadRP${status.count}" name="unidadRP" value="${tipoRecursoLis.unidadRP}" readonly="true" />
						</td>
						<td>
							<input type="text" size="20" id="montoInversionRP${status.count}" name="montoInversionRP" value="${tipoRecursoLis.montoInversionRP}" esMoneda="true" maxlength="21" style="text-align:right;" onblur="sumaMontoPrestamo();" tabindex="<%=numtab++%>"/>
						</td>	
						
						<td> 
							<input type="button" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminaDetalle(this);sumaMontoPrestamo()" tabindex="<%=numtab++%>"/>
						</td> 
						<td>
						<input type="button" name="agregar" id="agregar${status.count}" class="btnAgrega" onclick="agregaNuevoDetalle()"  tabindex="${status.count}" tabindex="<%=numtab++%>"/>
						</td>
						<td>
							<input type="hidden" id="tipoRecursoPR${status.count}" name="tipoRecursoPR" path="tipoRecursoPR" value="P"/>
						</td>
					</tr>
					<c:set var="cont" value="${status.count}"/>
					<c:set var="montoTotal" value="${tipoRecursoLis.totalPrestamo}" />
					</c:forEach>
				</tbody>
				<tfoot>
						<tr>
							<td class="separador"></td>
							<td class="label" align="right" colspan="3">
								<label for="totalRecursoPrestamo">Total:</label>
							</td>
							<td>
								<input type="text" id="totalRecursoPrestamo" name="totalRecursoPrestamo" esMoneda="true" style="text-align: right;" disabled="disabled" value="${montoTotal}"/>
							</td>
						</tr>
					</tfoot>
			</c:when>
		</c:choose>
	</table>
	 <input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
</body>
</html>	