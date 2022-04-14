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
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

		<table id="miTabla" border="0" >
			<c:choose>
				<c:when test="${tipoLista == '1'}">
				<tbody>	
					<tr align="center">
						<td class="label">
							<label>ID</label>
						</td>
						<td class="label">
							<label>Descripci&oacute;n</label>
						</td>
						<td class="label">
							<label>Estatus</label>
						</td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="tipoAccionLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="text" id="accionID${status.count}" name="lisAccionID" size="4" value="${tipoAccionLis.accionID}" readOnly="true" style="height:100%"/>							
						</td>					
						<td>
							<input type="hidden" id="descriAccion${status.count}" name="descriAccion" value="${tipoAccionLis.descripcion}" />
							<textarea id="descripcion${status.count}" name="lisDescripcion" COLS="100" ROWS="2" onBlur=" ponerMayusculas(this)" 
										maxlength = "200" readOnly="true" autocomplete="off"/> 
						</td>							
						<td>
							<input type="hidden" id="estatusSelec${status.count}" name="estatusSelec" size="3" value="${tipoAccionLis.estatus	}"  />  																	
							<select type="select"  id="estatus${status.count}" name="lisEstatus" tabindex="${status.count}">
								<option value="">SELECCIONAR</option>
								<option value="A">ACTIVO</option>
								<option value="I">INACTIVO</option>							
							</select>
						</td>
						<td style="width:18px"> 
							<input type="hidden" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="${status.count}"  disabled="true" />
						</td> 
						<td>
							<input type="button" name="agregar" id="agregar${status.count}" class="btnAgrega" onclick="agregaNuevoParametro()"  tabindex="${status.count}"/>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</c:when>
		</c:choose>
	</table>
	
</body>
</html>	