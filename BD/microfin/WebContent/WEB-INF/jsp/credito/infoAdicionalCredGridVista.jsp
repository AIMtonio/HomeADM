<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>
		<script type="text/javascript" src="js/credito/infoAdicionalCredGrid.js"></script> 
	</head>
	<body>
		</br>
		<c:set var="relacionCred"  value="${relacionCred}"/>
		<form id="gridInfoAdicionalCred" name="gridInfoAdicionalCred">
			<input type="submit" id="agregaRelacion" class="submit" value="Agregar"/>
			&nbsp;&nbsp;&nbsp;
			
			<div id="arbol" style="display: none;"></div>
			<table id="miTabla" border="0">
				<tbody>
					<tr>
						<td class="label" >
							<label for="lblPlaca">Placa del Veh&iacute;culo</label>
						</td>
						<td class="label">
							<label for="lblVin">VINs del Veh&iacute;culo</label>
						</td>
						<td class="label">
							<label for="lblConsumo">Consumo GNV (Litros)</label>	
						</td>
						<td class="label">
							<label for="lblEstatus">Estatus Envio</label>	
						</td>			
					</tr>
				<c:forEach items="${relacionCred}" var="relacionCred" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input type="text" size="19" name="idPlaca" id="placa${status.count}" value="${relacionCred.placa}" onBlur=" ponerMayusculas(this)" tabindex="${status.count}" minlength ="5" maxlength="7"/>
						</td>
						<td>
							<input type="text" size="19" name="idVin" id="vin${status.count}" value="${relacionCred.vin}" onBlur=" ponerMayusculas(this)" tabindex="${status.count}" minlength ="16" maxlength="18""/>
						</td>
						<td>
							<input type="number" size="20" name="idGnv" id="gnv${status.count}" value="${relacionCred.gnv}" tabindex="${status.count}" min="1" oninput="validity.valid;"/>
						</td>
						<td>
							<select name="idEstatus" id="estatus${status.count}" path="idEstatus" value="${relacionCred.estatusWS}" disabled="true">
								<option value="A" ${relacionCred.estatusWS == 'A' ? "selected='selected'" : ''}>ACEPTADO</option>
								<option value="E" ${relacionCred.estatusWS == 'E' ? "selected='selected'" : ''}>ERROR</option>
								<option value="P" ${relacionCred.estatusWS == 'P' ? "selected='selected'" : ''}>PENDIENTE</option>
							</select>
						</td>
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaRelacion(this)" />
						</td><td>
							<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />							
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroRelaciones" id="numeroRelaciones" />
		</form>
	</body>
</html>