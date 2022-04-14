<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="esquemaQuinquenios"  value="${listaResultado}"/>
			<table id="tablaGridEsquema" border="0" cellpadding="5" cellspacing="5" width="100%">
					<tr>
						<td align="center"><label>N&uacute;mero</label></td>
						<td align="center"><label>Sucursal</label></td>
						<td align="center"><label>Quinquenio</label></td>
						<td align="center"><label>Plazo</label></td>
					</tr>
				<c:forEach items="${esquemaQuinquenios}" var="esquema" varStatus="estatus">
						<tr id="renglon${estatus.count}" name="renglon">
							<td> 
						  		<input type="text" id="consecutivoID${estatus.count}" name="consecutivoID" size="12" value="${estatus.count}" readonly/>	
						  	</td> 
						  	<td> 
						  		<select multiple id="sucursalID${estatus.count}" name="sucursalID" size="9" onchange="seleccionarSucursales(this.id, ${estatus.count});">
									<option value="0">TODOS</option>
								</select>	
						  		<input type="hidden" id="lisSucursalID${estatus.count}" name="lisSucursalID" value="${esquema.sucursalID}"/>	
						  	</td>
						  	<td> 
								<select multiple id="quinquenioID${estatus.count}" name="quinquenioID" size="9" onchange="seleccionarQuinquenios(this.id, ${estatus.count});">
									<option value="0">TODOS</option>
								</select>
								<input  type="hidden" id="lisQuinquenioID${estatus.count}" name="lisQuinquenioID" value="${esquema.quinquenioID}" /> 							 							
						  	</td> 
						  	<td> 
								<select multiple id="plazoID${estatus.count}" name="plazoID" size="9"  onchange="selecPlazos(this.id, ${estatus.count});">
									<option value="0">TODOS</option>
								</select>
								<input  type="hidden" id="lisPlazoID${estatus.count}" name="lisPlazoID"  value="${esquema.plazoID}" /> 							 							
						  	</td> 
						        
						    <td>
						    
							<input type="button"  id="eliminar${estatus.count}" tabindex="9"  value="" class="btnElimina"  onclick="eliminarRegistro('renglon${estatus.count}')"  />
							<input type="button" tabindex="10" name="agrega" id="agrega${
							estatus.count}"  value="" class="btnAgrega" onclick="agregarNuevoRegistro()"/>
							
							</td>
						</tr>								
					</c:forEach>			
			</table>
