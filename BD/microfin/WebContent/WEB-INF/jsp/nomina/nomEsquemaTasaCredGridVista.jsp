<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<script type="text/javascript" src="dwr/interface/tipoEmpleadosConvenioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/condicionProductoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
<script type="text/javascript" src="js/nomina/nomEsquemaTasaCredGrid.js"></script>  

          

<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<c:set var="indiceTab" value="11"/>

<br>
<input type="hidden" id="numeroRegistrosEsqTasa" name="numeroRegistrosEsqTasa" value="${listaPaginada.nrOfElements}"/>
<c:if test="${listaPaginada.nrOfElements > 0}">
	<input type="button" id="agregarEsqTasaCred" name="agregarEsqTasaCred" value="Agregar" class="submit" onclick="agregarDetalleEsqTasa('tablaGridEsqTasa')" tabindex="11"/>
	<table id="tablaGridEsqTasa" border="0" cellpadding="5" cellspacing="5" width="100%">
		<tr> 
			<td align="center"><label>ID</label></td>
			<td align="center"><label>Sucursal</label></td>
			<td align="center"><label>Tipo Empleado</label></td>
			<td align="center"><label>Plazo</label></td>
			<td align="center"><label>Min. Cr&eacute;dito</label></td>
			<td align="center"><label>Max. Cr&eacute;dito</label></td>
			<td align="center"><label>Monto M&iacute;nimo</label></td>
			<td align="center"><label>Monto M&aacute;ximo</label></td>
			<td align="center"><label>Tasa</label></td>
		</tr>

		<c:forEach items="${listaResultado}" var="registro" varStatus="status">
			<c:set var="indiceTab" value="${indiceTab + 1}"/>
			<tr id="renglonEsqTasa${status.count}" name="renglonEsqTasa">
				<td>
					<input id="consecutivoID${status.count}" size="11" name="consecutivoID" maxlength="9" type="text" value="${status.count}" tabindex="${indiceTab}" readonly/>
				</td>
				<td>
				<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<select multiple id="sucursalID${status.count}" name="sucursalID"  tabindex="${indiceTab}" onchange="seleccionarSucursales(this.id, ${status.count});" >
						<option value="0">TODOS</option>
					</select>
					<input type="hidden" id="lisSucursalID${status.count}"  name="lisSucursalID" value="${registro.sucursalID}" />
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					
					<select multiple id="tipoEmpleadoIDEsqTasa${status.count}" name="tipoEmpleadoIDEsqTasa"  tabindex="${indiceTab}" onchange="selecTipoEmpledados(this.id, ${status.count});">
						<option value="0">TODOS</option>
					</select>
					<input type="hidden" id="lisTipoEmpleadoIDEsqTasa${status.count}"  name="lisTipoEmpleadoIDEsqTasa" value="${registro.tipoEmpleadoID}"/>
				</td>
			
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
						
					<select multiple id="plazoID${status.count}" name="plazoID"  tabindex="${indiceTab}" onchange="selecPlazos(this.id, ${status.count});"  >
						<option value="0">TODOS</option>
					</select>
					<input type="hidden" id="lisPlazoIDEsqTasa${status.count}"  name="lisPlazoIDEsqTasa" value="${registro.plazoID}"/>
				</td>
				
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisMinCredEsqTasa${status.count}" size="12" maxlength="6" name="lisMinCredEsqTasa" type="text" value="${registro.minCred}" tabindex="${indiceTab}"  style="text-align: right;" 
					onkeypress="return validaSoloNumero(event,this); "/>
				</td>
				
					<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisMaxCredEsqTasa${status.count}" size="12" maxlength="6" name="lisMaxCredEsqTasa" type="text" value="${registro.maxCred}" tabindex="${indiceTab}"  style="text-align: right;"
					onkeypress="return validaSoloNumero(event,this); " />
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisMontoMinEsqTasa${status.count}" size="12" maxlength="12" name="lisMontoMinEsqTasa" type="text" value="${registro.montoMin}" tabindex="${indiceTab}" esMoneda="true"  style="text-align: right;" onblur="validarMontoMin(this.id,${status.count});" />
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisMontoMaxEsqTasa${status.count}" size="12" maxlength="12" name="lisMontoMaxEsqTasa" type="text" value="${registro.montoMax}" tabindex="${indiceTab}" esMoneda="true"  style="text-align: right;" onblur="validarMontoMax(this.id,${status.count});" />
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisTasaEsqTasa${status.count}" size="12" maxlength="10" name="lisTasaEsqTasa" type="text" value="${registro.tasa}" tabindex="${indiceTab}" onblur="validaValorTasa(this.id); "/>
				</td>
				<td nowrap="nowrap">
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input type="button" id="agregarEsqTasa${status.count}" name="agregarEsqTasa${status.count}" value="" class="btnAgrega" onclick="agregarDetalleEsqTasa('tablaGridEsqTasa')" tabindex="${indiceTab}"/>
				</td>
				<td nowrap="nowrap">
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input type="button" id="eliminarEsqTasa${status.count}" name="eliminarEsqTasa${status.count}" value="" class="btnElimina" onclick="eliminarDetalleEsqTasa('renglonEsqTasa${status.count}')" tabindex="${indiceTab}"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		<c:set var="indiceTab" value="${indiceTab + 1}"/>
		<input type="button" id="btnAnteriorEsqTasa" onclick="cambioPaginaGridEsqTasa('previous')" value="" tabindex="${indiceTab}" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<c:set var="indiceTab" value="${indiceTab + 1}"/>
		<input type="button" id="btnSiguienteEsqTasa" onclick="cambioPaginaGridEsqTasa('next')" value="" tabindex="${indiceTab}" class="btnSiguiente" />
	</c:if>
	<input type="hidden" id="numTabEsqTasa" value="${indiceTab}"/>
	<input type="hidden" id="numeroFilaEsqTasa" value="${listaPaginada.nrOfElements}"/>
</c:if>
<c:if test="${listaPaginada.nrOfElements <= 0}">
	<input type="button" id="agregarEsqTasaCred" name="agregarEsqTasaCred" value="Agregar" class="submit" onclick="agregarDetalleEsqTasa('tablaGridEsqTasa')" tabindex="4"/>
	<table id="tablaGridEsqTasa" border="0" cellpadding="0" cellspacing="5" width="100%">
		<tr> 
			<td align="center"><label>ID</label></td>
			<td align="center"><label>Sucursal</label></td>
			<td align="center"><label>Tipo Empleado</label></td>
			<td align="center"><label>Plazo</label></td>
			<td align="center"><label>Min. Cr&eacute;dito</label></td>
			<td align="center"><label>Max. Cr&eacute;dito</label></td>
			<td align="center"><label>Monto M&iacute;nimo</label></td>
			<td align="center"><label>Monto M&aacute;ximo</label></td>
			<td align="center"><label>Tasa</label></td>
		</tr>
	</table>
	<input type="hidden" id="numTabEsqTasa" value="${indiceTab}"/>
	<input type="hidden" id="numeroFilaEsqTasa" value="0"/>
</c:if>
