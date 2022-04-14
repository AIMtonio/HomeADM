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
						<label>Solicitud Cred. </label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Num. Cr&eacute;dito </label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Referencia</label>
					</td>
					<td></td>
					<td>
						<label>Estatus</label>
					</td>
					<td></td>
					<td>
						<label>Nombre del Cliente</label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Monto </label>
					</td>
					<td></td>
					<td nowrap="nowrap" >
					</td>
				</tr>
				
				</thead>
				<tbody>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
						
					
					<tr id="tr${status.count}" name="trAccesorios">
						<td nowrap="nowrap">
							<input type="text" id="solicitudCreditoID${status.count}" tabindex="<%=counter %>" name="solicitudCreditoID" size="5" value="${detalle.solicitudCreditoID}" maxlength="10" disabled="disabled" onkeypress="return validaNumero(event)" />
						</td>
						<td></td>
						<td>
							<input type="text" id="creditoID${status.count}" tabindex="<%=counter %>" name="creditoID" size="50" value="${detalle.creditoID}" onblur="ponerMayusculas(this)" maxlength="100" />
						</td>
						<td></td>
						<td>
							<input type="text" id="referencia${status.count}" tabindex="<%=counter %>" name="referencia" size="10" value="${detalle.referencia}" onblur="ponerMayusculas(this)" maxlength="10" />
						</td>
						<td></td>
						<td>
							<input type="text" id="estatus${status.count}" tabindex="<%=counter %>" name="estatus" size="5" value="${detalle.estatus}"  maxlength="5" onkeypress="return validaNumero(event)" />
						</td>
						<td></td>
						<td>
							<input type="text" id="nombreCliente${status.count}" tabindex="<%=counter %>" name="nombreCliente" size="5" value="${detalle.nombreCliente}"  maxlength="5" onkeypress="return validaNumero(event)" />
						</td>
						<td></td>
						<td>
							<input type="text" id="monto${status.count}" tabindex="<%=counter %>" name="monto" size="5" value="${detalle.monto}"  maxlength="5" onkeypress="return validaNumero(event)" />
						</td>
						<td></td>
						<td nowrap="nowrap">
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
						</td>
						<td>
							<input type="hidden" id="folioDispersion${status.count}" tabindex="<%=counter %>" name="folioDispersion" size="5" value="${detalle.monto}"  maxlength="5" />
							<input type="hidden" id="claveDisMov${status.count}" tabindex="<%=counter %>" name="claveDisMov" size="5" value="${detalle.monto}"  maxlength="5" />
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