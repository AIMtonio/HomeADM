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
		<c:set var="convencionSec" value="${listaResultado}"/>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">   
				<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" align="center">
					   		<label for="lblSucursal">Sucursal</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblNombreSucur">Nombre Sucursal</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblFecha">Fecha</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblCantSocios">Cantidad <br> de socios</label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblEsGral">General</label> 
						</td>						
					</tr>
				<c:forEach items="${convencionSec}" var="convenciones" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input type="text" id="sucursalID${status.count}" name="lsucursalID" size="5" value="${convenciones.sucursalID}" onkeypress="listaSucursales(this.id)" onblur="validaSurcursales(this.id)" />   
					  	</td> 
					  	<td> 
							<input  type="text" id="nombreSucurs${status.count}" name="lnombreSucurs" size="40" value="${convenciones.nombreSucurs}" readOnly="true" /> 							 							
					  	</td> 	
					  	<td> 
							<input  type="text" id="fecha${status.count}" name="lfecha" size="18" value="${convenciones.fecha}"  onblur="onblurfecha(this.id,'sucursalID${status.count}')"/> 							 							
					  	</td>
					  	<td> 
							<input  type="text" id="cantSocio${status.count}" name="lcantSocio" size="6" value="${convenciones.cantSocio}" " onblur="onblurCantSocio(this.id)" onkeyPress="return validador(event)"/> 							 							
					  	</td>
					  	<td> 
					  		<c:if test="${convenciones.esGral == 'S'}" >								 														
							<input type="checkbox"id="esGral${status.count}" checked="true" name="lesGral" value="${convenciones.esGral}"  onclick="realiza(this.id)"/>
    						</c:if>
    						<c:if test="${convenciones.esGral != 'S'}" >								 														
							<input type="checkbox"id="esGral${status.count}" name="lesGral" value="${convenciones.esGral}"  onclick="realiza(this.id)"/>
    						</c:if>
   						</td>
					  	
					  	<td>
					  		<!-- <input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarConvencionSeccional(this.id)" /> -->
					  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarConvencionSeccional()"/>
					  	</td>
					  		<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />	
				
					</tr>	
				</c:forEach>			
			</table>
		</fieldset>
	</body>
</html>

