<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>


<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
<script type="text/javascript" src="js/nomina/condicionesProdNomCredGrid.js"></script>
<script type="text/javascript" src="dwr/interface/condicionProductoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 

<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<c:set var="indiceTab" value="3"/>

<br>
<input type="hidden" id="numeroRegistrosCred" name="numeroRegistrosCred" value="${listaPaginada.nrOfElements}"/>
<c:if test="${listaPaginada.nrOfElements > 0}">
	<table id="tablaGridCred" cellpadding="5" cellspacing="5" width="100%" style="border-collapse : collapse;">
		<tr> 
			<td align="center"><label>Seleccionar</label></td>
			<td align="center"><label>Producto Cr&eacute;dito</label></td>
			<td align="center"><label>Tipo Tasa</label></td>
			<td align="center"><label>Valor Tasa</label></td>
		  	<td align="center"><label>Tipo Cob Mora</label></td>
			<td align="center"><label>Valor Mora</label></td>  
		</tr>

		<c:forEach items="${listaResultado}" var="registro" varStatus="status">
			<c:set var="indiceTab" value="${indiceTab + 1}"/>
			<tr id="renglonCred${status.count}" name="renglonCred">
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input type="checkbox" id="lisVerEsqTasa${status.count}" name="lisVerEsqTasa" tabindex="${indiceTab}"  onclick="verEsquemaTasa(this.id,${status.count}); desselecTodos(this.id,${status.count});"/>
					<input type="hidden" id="lisCondicionCredID${status.count}" name="lisCondicionCredID" value="${registro.condicionCredID}"/>					
					<input type="hidden" id="cantidadEsqTasa${status.count}" name="cantidadEsqTasa" value="0"/>		
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<select id="lisProducCreditoID${status.count}" name="lisProducCreditoID" value="${registro.producCreditoID}" tabindex="${indiceTab}" onchange="cambiarProductoCredito(this.id,${status.count});" >		
							<option value="">SELECCIONAR</option>
					</select>
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<select id="lisTipoTasaCred${status.count}" name="lisTipoTasaCred"  tabindex="${indiceTab}" onchange="cambiaTipoTasaCred(this.id,${status.count});  ">
							<c:if test="${registro.tipoTasa == 'F'}">
									<option value="F" selected >FIJA</option>
									<option value="E" >POR ESQUEMA</option>
							</c:if>
							<c:if test="${registro.tipoTasa == 'E'}">
									<option value="F" >FIJA</option>
									<option value="E" selected  >POR ESQUEMA</option>
							</c:if>
					</select>
					<input type="hidden" id="tipoTasaCredAnt${status.count}" name="tipoTasaCredAnt" value="${registro.tipoTasa}"/>
				</td>
				<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisValorTasaCred${status.count}" size="12" name="lisValorTasaCred" maxlength="10" type="text" value="${registro.valorTasa}" tabindex="${indiceTab}" onblur="validaValorTasa(this.id); " />
				</td>
				<td> 
				<c:set var="indiceTab" value="${indiceTab + 1}"/>
        	 	<select id="lisTipoCobMora${status.count}" name="lisTipoCobMora" tabindex="${indiceTab}" value="${registro.tipoCobMora}">
					<c:if test="${registro.tipoCobMora == 'N' || registro.tipoCobMora == 'D' }">
						<option value="N" selected>N veces Tasa Ordinaria</option>
			     		<option value="T">Tasa Fija Anualizada</option>
					</c:if>
					<c:if test="${registro.tipoCobMora == 'T'}">
						<option value="N">N veces Tasa Ordinaria</option>
			     		<option value="T" selected>Tasa Fija Anualizada</option>
					</c:if>
				</select>     			
    			</td>
    			<td>
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input id="lisValorMora${status.count}" size="12" name="lisValorMora" maxlength="15" type="text" value="${registro.valorMora}" tabindex="${indiceTab}"/>
				</td>
				<td nowrap="nowrap">
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input type="button" id="agregarCred${status.count}" name="agregarCred${status.count}" value="" class="btnAgrega" onclick="agregarDetalleCred('tablaGridCred')" tabindex="${indiceTab}"/>
				</td>
				<td nowrap="nowrap">
					<c:set var="indiceTab" value="${indiceTab + 1}"/>
					<input type="button" id="cancelarCred${status.count}" name="cancelarCred${status.count}" value="" class="btnElimina" onclick="eliminarProductoCredito(this.id,${status.count}); " tabindex="${indiceTab}"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		<c:set var="indiceTab" value="${indiceTab + 1}"/>
		<input type="button" id="btnAnteriorCred" onclick="cambioPaginaGridCred('previous')" value="" tabindex="${indiceTab}" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<c:set var="indiceTab" value="${indiceTab + 1}"/>
		<input type="button" id="btnSiguienteCred" onclick="cambioPaginaGridCred('next')" value="" tabindex="${indiceTab}" class="btnSiguiente" />
	</c:if>
	<input type="hidden" id="numTabCred" value="${indiceTab}"/>
	<input type="hidden" id="numeroFilaCred" value="${listaPaginada.nrOfElements}"/>
</c:if>
<c:if test="${listaPaginada.nrOfElements <= 0}">
	<table id="tablaGridCred" cellpadding="0" cellspacing="5" width="100%" style="border-collapse : collapse;">
		<tr> 
			<td align="center"><label>Seleccionar</label></td>
			<td align="center"><label>Producto Cr&eacute;dito</label></td>
			<td align="center"><label>Tipo Tasa</label></td>
			<td align="center"><label>Valor Tasa</label></td>
		  	<td align="center"><label>Tipo Cob Mora</label></td>
			<td align="center"><label>Valor Mora</label></td>  
		</tr>
	</table>
	<input type="hidden" id="numTabCred" value="${indiceTab}"/>
	<input type="hidden" id="numeroFilaCred" value="0"/>
</c:if>
