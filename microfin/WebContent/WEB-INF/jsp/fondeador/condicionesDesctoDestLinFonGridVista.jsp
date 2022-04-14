<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>


<table border="0" cellpadding="0" cellspacing="0" id="tablaDestinos">			
	<tr>
		<td class="label">
			<label for="lblDestino">Destino Cr&eacute;dito</label>
		</td> 
		<td></td>
		<td></td>
	</tr>
	<c:forEach items="${listaResultado}" var="destinoBean"   varStatus="status">
	<tr id="renglonDest${status.count}" name= "renglonDest">
		<td nowrap="nowrap">
			<input type="text" id="destinoCreID${status.count}" name="listaDestinoCreID" size="15" value="${destinoBean.destinoCreID}"
				onkeypress="listaDestinosCreditoGrid(this.id);" onblur="validaDescripcion(this.id);consultaDestinoDescripcionGrid(this.id);" />
			<input type="text" id="descripcionDestino${status.count}" name="descripcionDestino" size="65" disabled="disabled" readonly="readonly"/>
		</td> 
		<td>
			<input type="button" name="eliminaDest" id="eliminaDest${status.count}" value="" class="btnElimina" onclick="eliminaFilaDestino(this.id)"/>
		</td>  
		<td>
			<input type="button" name="agregaDest" id="agregaDest${status.count}" value="" class="btnAgrega" onclick="agregaNuevaFilaDestino()"/>
		</td>
		<c:set var="numeroDetalleDestino"  value="${status.count}"/>
	</tr>
	</c:forEach>
	<tr>
		<td>
			<input type="hidden" id="numeroDetalleDestino" name="numeroDetalleDestino" value = "${numeroDetalleDestino}" size="10"/>
		</td>
	</tr>
</table>
<br></br>