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

		<table id="miTabla" >
			<c:choose>
				<c:when test="${tipoLista == '2'}">
				<tbody>						
					<c:forEach items="${listaResultado}" var="promesasLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<label id="fecha${promesasLis.numPromesa}">Fecha ${promesasLis.numPromesa}:</label>
						</td>						 
						<td style="width:100px"> 
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="hidden" id="numPromesa${status.count}" name="lisNumPromesa" size="4" value="${promesasLis.numPromesa}" disabled="true" readOnly="true"/>
							<input type="text" id="fechaPromPago${status.count}" name="lisFechaPromPago" size="11" value="${promesasLis.fechaPromPago}" 
									 maxlength = "10" autocomplete="off" esCalendario="false" onChange="validaFecha(this.id)"  disabled="true" readOnly="true"/> 				
						</td>	
						<td class="separador"></td>					 
						<td> 
							<label id="monto${promesasLis.numPromesa}">Monto ${promesasLis.numPromesa}:</label>
						</td>						 
						<td> 
			       		 	<input type="text" id="montoPromPago${status.count}" name="lisMontoPromPago"  size="15" maxlength = "18" autocomplete="off" esMoneda="true" 
			       		 			value="${promesasLis.montoPromPago}" style="text-align: right" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>	
						<td>
							<label id="comentario${promesasLis.numPromesa}">Comentario ${promesasLis.numPromesa}:</label>							
						</td>					
						<td>
							<input type="hidden" id="desComenProm${status.count}" name="desComenProm" value="${promesasLis.comentarioProm}" />
							<textarea id="comentarioProm${status.count}" name="lisComentarioProm" COLS="50" ROWS="2" onBlur=" ponerMayusculas(this)" 
										maxlength = "300" disabled="true" readOnly="true"/> 
						</td>
						<td style="width:18px"> 	
							<input type="hidden" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminarParametro(this.id)" disabled="true"  />
						</td> 
						<td>
							<input type="button" name="agregar" id="agregar${status.count}" class="btnAgrega" onclick="agregaNuevoParametro()" />
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</c:when>
		</c:choose>
	</table>
	
</body>
</html>	