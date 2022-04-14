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
			<table id="tbParametrizacion" border="0" width="450px">
				<thead>
				<tr>
					<td style="width: 10px">
						<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="1" onclick="agregarDetalle(this.id)"/>
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap">
						<label>ID </label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Descripci&oacute;n </label>
					</td>
					<td></td>
					<td nowrap="nowrap">
							<label>Abrev. </label>
					</td>
					<td></td>
					<td></td>
					<td nowrap="nowrap">
							<label>Prelaci&oacute;n </label>
					</td>
					<td nowrap="nowrap" id="tdCAT">
						<label>Aplicar Cálculo CAT</label>
					</td>
				</tr>
				
				</thead>
				<tbody>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
						
					
					<tr id="tr${status.count}" name="trAccesorios">
						<td nowrap="nowrap">
							<input type="text" id="accesorioID${status.count}" tabindex="<%=counter %>" name="accesorioID" size="5" value="${detalle.accesorioID}" maxlength="10" disabled="disabled" onkeypress="return validaNumero(event)" />
						</td>
						<td></td>
						<td>
							<input type="text" id="descripcion${status.count}" tabindex="<%=counter %>" name="descripcion" size="50" value="${detalle.descripcion}" onblur="ponerMayusculas(this)" maxlength="100" />
						</td>
						<td></td>
						<td>
							<input type="text" id="abreviatura${status.count}" tabindex="<%=counter %>" name="abreviatura" size="10" value="${detalle.abreviatura}" onblur="ponerMayusculas(this)" maxlength="10" />
						</td>
						<td></td>
						<td>
							<input type="text" id="prelacion${status.count}" tabindex="<%=counter %>" name="prelacion" size="5" value="${detalle.prelacion}"  maxlength="5" onkeypress="return validaNumero(event)" />
						</td>
						<td nowrap="nowrap">
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
						</td>
						<td id="valCAT">
							<input type="checkbox" id="calculoCAT${status.count}" tabindex="<%=counter %>" name="calculoCAT" value="${detalle.aplicaCalCAT}"/>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript" >
	habilitaGrabar();
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>