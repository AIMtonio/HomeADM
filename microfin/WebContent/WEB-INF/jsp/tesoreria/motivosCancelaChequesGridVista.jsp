<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
	</head>
	<body>
		<c:set var="motivo" value="${listaResultado}"/>
		 <table id="miTabla" border="0" width="100%">
				<tr>
					<td class="label" align="center">
				   		<label for="lblMotivoID">N&uacute;mero</label> 
					</td>
					<td class="label" align="center">
				   		<label for="lblDescripcion">Descripci&oacute;n</label> 
					</td>
					<td class="label" align="center">
				   		<label for="lblEStatus">Estatus</label> 
					</td>					
				</tr>
			<c:forEach items="${motivo}" var="motivoCancela" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td  align="center"> 
						<input type="text" id="motivoID${status.count}" name="lmotivoID" size="10" value="${motivoCancela.motivoID}" readOnly="true"/>   
				  	</td> 
				  	<td align="center">
				  		<textarea id="descripcion${status.count}" name="ldescripcion" autocomplete="off" maxlength="200" cols =45 rows=2  style="overflow:auto;resize:none" readOnly="true">${motivoCancela.descripcion}</textarea> 							 							
				  	</td> 	
					<c:if test="${motivoCancela.estatus == 'A'}" >
					  	<td><select 	id="estatus${status.count}" name="lestatus"  value="A" style="width:110px">
					  		<option value="">SELECCIONAR</option>
							<option selected value="A">ACTIVO</option>
							<option value="I">INACTIVO</option>
					  		</select>
					  	</td>
					</c:if> 
					<c:if test="${motivoCancela.estatus == 'I'}" >
					  	<td><select 	id="estatus${status.count}" name="lestatus"  value="I" style="width:110px">
					  		<option value="">SELECCIONAR</option>
					  		<option value="A">ACTIVO</option>
					  		<option selected value="I">INACTIVO</option>	
					  		</select>
					  	</td>
					</c:if> 
					 					 											  	
				  	<td><input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarMotivos(this.id)"/> 
				  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarMotivos()"/>
				  	</td>
				  		<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}"/>	
			
				</tr>	
			</c:forEach>			
		</table>
	</body>
</html>
