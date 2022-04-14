<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<body>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="gridUsuarioAut" name="gridUsuarioAut">
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
	
		<c:choose>
				<c:when test="${tipoLista == '1'}">
			 		<tr>
						<td class="label" >
							<label for="lblUsuario">Usuario</label>	  	
						</td>
						<td class="label" >
							<label for="lblNombreCompleto">Nombre Completo</label>	  	
						</td>
						<td class="label" >
							<label for="lblRol">Rol</label>	  	
						</td>
	
					</tr>
									
				 <c:forEach items="${listaResultado}" var="usuario" varStatus="status">
							<tr id="renglonn${status.count}" name="renglonn">
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" value="${status.count}"/>	
							  	<td >
									<input type="text" id="usuarioID${status.count}" name="lusuarioID" size="6" value="${usuario.usuarioID}"onkeypress="listaUsuario(this.id)" onblur="consultaUsuario(this.id)" />
								</td>
								<td>
									<input type="text" id="nombreCompleto${status.count}" name="lnombreCompleto" size="40" value="${usuario.nombreCompleto}" readOnly="true" />
								</td>
								<td>
									<input type="text" id="nombreRol${status.count}" name="lnombreRol" size="40" value="${usuario.nombreRol}" readOnly="true"/>
								</td>
								<td>
									<input type="hidden" id="rolID${status.count}" name="lrolID"value="${usuario.rolID}" />
								</td>
						  		<td>
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarPersonalAut(this.id)" />
						  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarPersonalAut()"/>
						  	</td>
							</tr>
				
						</c:forEach>
				</c:when>
			</c:choose>			 		
	</table> 
</form>
</body>
</html>


