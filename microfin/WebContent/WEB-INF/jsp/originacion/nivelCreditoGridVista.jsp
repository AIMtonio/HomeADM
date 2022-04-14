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
						<td class="label" style="width:40px;">
							<label>ID</label>
						</td>
						<td class="label" style="width:200px;">
							<label>Descripci&oacute;n</label>
						</td>
						<td colspan="2" style="width:40px;" ></td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="bean" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<c:choose>
						    	<c:when test="${bean.numVecesAsignado == 0}">
						        	<input type="text" id="nivelID${status.count}" name="lisNivelID" maxlength="6" size="6" value="${bean.nivelID}" tabindex="${status.count}" onBlur="validaNivelID(this.id)" onkeyPress="return validador(event)" readOnly="true"/>
						       	</c:when>
						 		<c:otherwise>
						    		<input type="text" id="nivelID${status.count}" name="lisNivelID" maxlength="6" size="6" value="${bean.nivelID}" readOnly="true"/>
						    	</c:otherwise>
						  	</c:choose>														
						</td>					
						<td>
							<c:choose>
						    	<c:when test="${bean.numVecesAsignado == 0}">
						        	<input type="text" id="descripcion${status.count}" name="lisDescripcion" maxlength="20" size="30" value="${bean.descripcion}" tabindex="${status.count}"/>
						       	</c:when>
						 		<c:otherwise>
						    		<input type="text" id="descripcion${status.count}" name="lisDescripcion" maxlength="20" size="30" value="${bean.descripcion}"  readOnly="true"/>
						    	</c:otherwise>
						  	</c:choose>							
						</td>	
						<td> 
							<c:if test="${bean.numVecesAsignado == 0 }" >								 														
								<input type="button" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="${status.count}"/>
    						</c:if>
						</td> 
						<td>
							<input type="button" name="agregar" id="agregar${status.count}" class="btnAgrega" onclick="agregaNuevoParametro()"  tabindex="${status.count}"/>
							<input type="hidden" id="numVecesAsignado${status.count}" name="lisNumVecesAsignado"/>						
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</c:when>
		</c:choose>
	</table>
	
</body>
</html>	