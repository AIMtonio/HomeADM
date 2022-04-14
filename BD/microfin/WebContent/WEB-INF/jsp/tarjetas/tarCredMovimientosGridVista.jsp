<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
	
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			
					<tr>
						<td class="label" align="center">
					   		<label for="lblconsecutivo"></label> 
						</td>
						<td class="label" align="center">
					   		<label for="lblFecha">Fecha</label> 
						</td>
						<td class="label" align="center">
							<label for="lblReferencia">Referencia</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblNombreComercio">Nombre Comercio</label> 
				  		</td>
				  		<td class="label" align="center">
							<label for="lblCargos">Cargos</label> 
				  		</td>
						<td class="label" align="center">
							<label for="lblAbonos">Abonos</label>
				  		</td>
				  	</tr>
					<c:forEach items="${listaResultado}" var="movimiento" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"
										value="${status.count}" readOnly="true" disabled="true" type="hidden"/>
						</td>
						<td>
							<input type="text" id="fechaOperacion${status.count}" name="fechaOperacion" size="11"
										 value="${movimiento.fechaOperacion}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="referencia${status.count}"  name="referencia" size="32"
										  value="${movimiento.referencia}"readOnly="true" disabled="true" style='text-align:left;'/>
						</td>
						<td>
						 	<input type="text" id="nombreComerci${status.count}" name="nombreComerci" size="60" 
										value="${movimiento.nombreComercio}" readOnly="true" disabled="true" style='text-align:left;'/>
						</td>
						<td>
							<input type="text" id="cargos${status.count}"  name="cargos" size="10"
									  value="${movimiento.cargos}" readOnly="true" disabled="true" esMoneda="true" class="moneda" style='text-align:right;' />
						</td>
						<td>
							<input type="text" id="abonos${status.count}"  name="abonos" size="10"
									  value="${movimiento.abonos}" readOnly="true" disabled="true" esMoneda="true" class="moneda" style='text-align:right;' />
						</td>
				 	</tr>
					</c:forEach>
		</table>