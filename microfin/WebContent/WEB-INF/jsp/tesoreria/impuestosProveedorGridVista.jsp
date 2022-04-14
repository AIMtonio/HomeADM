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
		<c:set var="impuesto" value="${listaResultado}"/>
			<input type="button" id="agregarImpuesto" name="agregarImpuesto" value="Agregar" class="submit" onclick="agregarImpuestos()" tabindex="1" />
			 <table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" align="center">
					   		<label for="lblTipoProveedorID">Tipo <br> Proveedor</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblImpuestoID">Impuesto</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblDescripCorta">Descripci&oacute;n</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblTasa">Tasa</label><label>%</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblOrden">Orden</label> 
						</td>						
					</tr>
				<c:forEach items="${impuesto}" var="impuestoProv" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td align="center"> 
							<input type="text" id="tipoProveedorID${status.count}" name="ltipoProveedorID" size="10" value="${impuestoProv.tipoProveedorID}" />   
					  	</td> 
					  	<td align="center"> 
							<input  type="text" id="impuestoID${status.count}" name="limpuestoID" size="10" value="${impuestoProv.impuestoID}" onkeypress="listaImpuesto(this.id)" onblur="validaImpuesto(this.id,'tipoProveedorID${status.count}')"/> 							 							
					  	</td> 	
					  	<td align="center" > 
							<input  type="text" id="descripCorta${status.count}" name="ldescripCorta" size="30" value="${impuestoProv.descripCorta}" disabled="true"/> 							 							
					  	</td>
					  	<td align="center"> 
							<input  type="text" id="tasa${status.count}" name="ltasa" size="10" value="${impuestoProv.tasa}" esTasa="true" disabled="true" style='text-align:right;' /> 							 							
					  	</td>
					  	<td align="center"> 
							<input  type="text" id="orden${status.count}" name="lorden" size="10" value="${impuestoProv.orden}" onblur="verificaOrden(this.id);" onkeyPress="return validador(event);"/> 							 							
   						</td>
					  	
					  	<td>
					  		 <input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarImpuestos(this.id)" /> 
					  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarImpuestos()"/>
					  	</td>
					  		<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />	
				
					</tr>	
				</c:forEach>			
			</table>
	</body>
</html>

