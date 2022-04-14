<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>

<body>
		<fieldset class="ui-widget ui-widget-content">
		<c:set var="tipoLista"  value="${listaResultado[0]}"/>
		<c:set var="listaPaginada" value="${listaResultado[1]}" />
		<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

		<c:choose>
			<c:when test="${tipoLista == '1'}">
			<table  id="gvMain" border="0" width="50%">
					<thead>
						<tr class="GridViewScrollHeader">
							<td nowrap="nowrap">
								N&uacute;mero
							</td>
							<td nowrap="nowrap">
								No. Cr&eacute;dito
							</td>
							<td nowrap="nowrap">
								No. Empleado
							</td>
							<td nowrap="nowrap">
								Fecha Pago
							</td>
							<td nowrap="nowrap">
								Monto Aplicado
							</td>
							<td nowrap="nowrap">
								Producto de Cr&eacute;dito
							</td>

						</tr>

					</thead>
						<%! int counter = 0; %>

					<c:forEach items="${listaResultado}" var="reversaNominaLis" varStatus="status">
						<% counter++; %>
						<tr id="renglons${status.count}" name="renglons" class="GridViewScrollItem">
							<td nowrap="nowrap">
								<input type="text" id="consecutivo${status.count}" name="lisConsecutivo" width="150px" size="8" value="${status.count}" readOnly="true"  />
							</td>
							<td nowrap="nowrap">
								<input type="text" id="creditoID${status.count}" name="lisCreditoID" size="22" value="${reversaNominaLis.creditoID}"  readOnly="true" />

							</td>
							<td nowrap="nowrap">
								<input type="text" id="noEmpleadoID${status.count}" name="lisNoEmpleadoID" size="20" value="${reversaNominaLis.noEmpleadoID}" readOnly="true"/>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="fechaPago${status.count}" name="lisFechaPago" size="26" align="center" value="${reversaNominaLis.fechaPago}" readOnly="true" />
							</td>
							<td nowrap="nowrap">
								<input type="text" id="montoAplicado${status.count}" name="lisMontoAplicado" size="20" value="${reversaNominaLis.montoAplicado}"  readOnly="true"  esMoneda="true" style="text-align: right;"/>

							</td>
							<td nowrap="nowrap">
								<input id="productoCredito${status.count}" name="lisProductoCredito" size="28" type="text"   value="${reversaNominaLis.productoCredito}" readOnly="true"  />
							</td>

						</tr>
					</c:forEach>

			</table>
			</c:when>
		</c:choose>

		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="generaSeccion('previous')" type="button" id="anterior" name="anterior" value="" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="generaSeccion('next')" type="button" id="siguient" class="btnSiguiente" />
		</c:if>

		<input type="hidden" id="numTab" name="numTab" value="<%=counter%>"/>
	</fieldset>
</body>
</html>

<script type="text/javascript">
	var gridViewScroll = null;
</script>