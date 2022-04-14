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
							<label>D&iacute;as Atraso</br>Inicial</label>
						</td>
						<td class="label">
							<label>D&iacute;as Atraso</br>Final</label>
						</td>
						<td class="label">
							<label>Num.</br>Etapa</label>
						</td>
						<td class="label">
							<label>Etiqueta</br>Etapa</label>
						</td>
						<td class="label">
							<label>Acci&oacute;n</label>
						</td>
						<td class="label">
							<label>Formato Notificaci&oacute;n</label>
						</td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="esquemaNotiLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="text" id="esquemaID${status.count}" name="lisEsquemaID" size="4" value="${esquemaNotiLis.esquemaID}" readOnly="true" />							
						</td>
						<td>
							<input type="text" id="diasAtrasoIni${status.count}" name="lisDiasAtrasoIni" size="9" value="${esquemaNotiLis.diasAtrasoIni}" tabindex="${status.count}" maxlength = "9" autocomplete="off" onblur="validarRangoDias(this.id)" onkeypress="validaSoloNumero(event,this)"/>							
						</td>	
						<td>
							<input type="text" id="diasAtrasoFin${status.count}" name="lisDiasAtrasoFin" size="9" value="${esquemaNotiLis.diasAtrasoFin}" tabindex="${status.count}" maxlength = "9" autocomplete="off" onblur="validarRangoDias(this.id)" onkeypress="validaSoloNumero(event,this)"/>							
						</td>
						<td>
							<input type="text" id="numEtapa${status.count}" name="lisNumEtapa" size="6" value="${esquemaNotiLis.numEtapa}" tabindex="${status.count}" onblur="ponerMayusculas(this)" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)"/>							
						</td>						 
						<td> 
							<input  type="text" id="etiquetaEtapa${status.count}" name="lisEtiquetaEtapa" size="15" value="${esquemaNotiLis.etiquetaEtapa}" tabindex="${status.count}" onblur=" ponerMayusculas(this)" maxlength = "10" autocomplete="off" /> 							 							
						</td>						 
						<td> 
							<input  type="text" id="accion${status.count}" name="lisAccion" size="50" value="${esquemaNotiLis.accion}" tabindex="${status.count}" onblur=" ponerMayusculas(this)" maxlength = "200" autocomplete="off" /> 						 							
						</td>						
						<td>
							<input type="hidden" id="formatoID${status.count}" name="formatoID" size="10" value="${esquemaNotiLis.formatoNoti}"  />  																	
							<select id="formatoNoti${status.count}" name="lisFormatoNoti" type="select"  tabindex="${status.count}">
								<option value="">SELECCIONAR</option>							
							</select>
						</td>
						<td> 
							<input type="button" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="${status.count}"/>
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