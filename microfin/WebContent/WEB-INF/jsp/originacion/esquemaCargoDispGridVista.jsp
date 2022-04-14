<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<table border="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Esquema de Cargo por Dispersi&oacute;n por Producto de Cr&eacute;dito</legend>
				<table id="tbEsquemaCargo" border="0" width="25%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label>Instituci&oacute;n</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label></label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Tipo Dispersi&oacute;n</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Tipo Cargo</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Nivel</label>
						</td>
						<td class="label" nowrap="nowrap">
							<label>Valor Cargo</label>
						</td>
						<td class="label">
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
					<tr id="tr${status.count}" name="tr">
						<td>
							<input type="text" id="institucionID${status.count}" name="institucionID" size="9" value="${detalle.institucionID}" maxlength="10" readonly="readonly" disabled="true" style="text-align: right;"/>
						</td>
						<td>
							<input type="text" id="nombInstitucion${status.count}" name="nombInstitucion" size="22" value="${detalle.nombInstitucion}" maxlength="100" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="tipoDispersion${status.count}" name="tipoDispersion" size="20" value="${detalle.tipoDispersion}" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="tipoCargo${status.count}" name="tipoCargo" size="15" value="${detalle.tipoCargo}" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="nivel${status.count}" name="nivel" size="25" value="${detalle.nivel}" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="montoCargo${status.count}" name="montoCargo" size="15" value="${detalle.montoCargo}" readonly="readonly" disabled="true" style="text-align: right;" />
						</td>
					</tr>
					</c:forEach>
					</tbody>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<script type="text/javascript" >
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>