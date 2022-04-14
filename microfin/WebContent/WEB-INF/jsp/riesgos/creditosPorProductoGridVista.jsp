<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
	<table id="miTabla" cellpadding="0" border="0" " width="100%">
		<c:choose>
			<c:when test="${tipoLista == '1'}">
				<tr>
					<td class="label" align="center">
					   	<label for="consecutivo"></label> 
					</td>
					<td class="label" align="center">
						<label for="descripcionProd">Nombre Producto</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="monto">Monto Cartera</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="porcentual">Porcentual</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="porcentaje">Porcentaje</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="diferencia">Diferencia</label> 
			  		</td>
			 	</tr>
				<c:forEach items="${listaResultado}" var="listaProducto" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivo${status.count}"  name="consecutivo" size="5" value="${status.count}" readOnly="true" type="hidden" style='text-align:left;'/> 
					  	</td> 
						<td> 
							<input type="text" id="descripcionProd${status.count}"  name="descripcionProd" size="30" value="${listaProducto.descProducto}" readOnly="true" style='text-align:left;' /> 
						</td> 
					  	<td> 
					  		<input type="text" id="monto${status.count}" name="monto" size="15" value="${listaProducto.montoCartera}" readOnly="true"  style='text-align:right;'/>
					  	</td> 
					  	<td> 
					  		<input type="text" id="resultado${status.count}" name="resultado" size="8" value="${listaProducto.resultadoPorcentual}" readOnly="true" style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>
					  	<td> 
					  		<input type="text" id="parametro${status.count}" name="parametro" size="8" value="${listaProducto.parametroPorcentaje}" readOnly="true"  style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>
					  	<td> 
					  		<input type="text" id="diferencia${status.count}" name="diferencia" size="8" value="${listaProducto.difLimiteEstabCredito}" readOnly="true" style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>  
					</tr>
				</c:forEach>
			</c:when>
	
			<c:when test="${tipoLista == '2'}">
				<tr>
					<td class="label" align="center">
					   	<label for="consecutivo"></label> 
					</td>
					<td class="label" align="center">
						<label for="descripcionProd">Nombre Producto</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="monto">Saldo Cartera</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="porcentual">Porcentual</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="porcentaje">Porcentaje</label> 
			  		</td>
			  		<td class="label" align="center">
						<label for="diferencia">Diferencia</label> 
			  		</td>
			 	</tr>
				<c:forEach items="${listaResultado}" var="listaProducto" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td> 
							<input id="consecutivo${status.count}"  name="consecutivo" size="5" value="${status.count}" readOnly="true" type="hidden" style='text-align:left;'/> 
					  	</td> 
						<td> 
							<input type="text" id="descripcionProd${status.count}"  name="descripcionProd" size="30" value="${listaProducto.descProducto}" readOnly="true" style='text-align:left;' /> 
						</td> 
					    <td> 
					  		<input type="text" id="saldo${status.count}" name="saldo" size="15" value="${listaProducto.saldoCartera}" readOnly="true" style='text-align:right;'/>
					  	</td> 
					  	<td> 
					  		<input type="text" id="resultado${status.count}" name="resultado" size="8" value="${listaProducto.resultadoPorcentual}" readOnly="true" style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>
					  	<td> 
					  		<input type="text" id="parametro${status.count}" name="parametro" size="8" value="${listaProducto.parametroPorcentaje}" readOnly="true"  style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>
					  	<td> 
					  		<input type="text" id="diferencia${status.count}" name="diferencia" size="8" value="${listaProducto.difLimiteEstabCredito}" readOnly="true" style='text-align:right;'/>
					  		<label>%</label> 
					  	</td>  
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>

