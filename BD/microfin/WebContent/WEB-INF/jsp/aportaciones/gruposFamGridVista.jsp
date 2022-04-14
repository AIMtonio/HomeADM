<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<table border="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Integrantes</legend>
				<table id="tbIntegrantesGpoFam" border="0" width="100%">
					<tbody>
					<tr>
						<td style="width: 10px">
							<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="3" onclick="agregarDetalle(this.id)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label><s:message code="safilocale.cliente"/></label>
						</td>
						<td class="label">
							<label>Nombre</label>
						</td>
						<td class="label">
							<label>Parentesco</label>
						</td>
						<td class="label">
							<label>Descripci&oacute;n</label>
						</td>
						<td class="label">
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
					<tr id="tr${status.count}" name="tr">
						<td>
							<input type="text" id="famClienteID${status.count}" tabindex="<%=counter %>" name="famClienteID" size="12" value="${detalle.famClienteID}" maxlength="60" onblur="validaTitularCte(this.id,'nomFamiliar${status.count}',false)" onkeypress="listaCteGrid(this.id)" />
						</td>
						<td>
							<input type="text" id="nomFamiliar${status.count}" name="nomFamiliar" size="45" value="${detalle.nomFamiliar}" maxlength="100" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="tipoRelacionID${status.count}" tabindex="<%=counter %>" name="tipoRelacionID" size="10" value="${detalle.tipoRelacionID}" maxlength="45" onblur="consultaRelacion(this.id,'descRelacion${status.count}')" onkeypress="listaParentGrid(this.id);" />
						</td>
						<td>
							<input type="text" id="descRelacion${status.count}" name="descRelacion" size="30" value="${detalle.descRelacion}" maxlength="100" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
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
	$('#btnAgregar').focus();
	if(Number(getRenglones()) == 0){
		deshabilitaBoton('grabar');
	} else {
		habilitaBoton('grabar');
	}
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>