<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado"  value="${listaResultado[1]}"/>

<table  border="0" width="100%">	
	<c:choose>

	<c:when test="${tipoLista == '2'}">			
	<c:forEach items="${listaResultado}" var="detalle" varStatus="status">


	<c:if test="${detalle.formaCobro == 'A' || detalle.formaCobro  =='D' }" >

	<tr name="renglonAccesorio">
		<td class="label" nowrap="nowrap">
			<input type="hidden" name="numAccesorio" value="${status.count}"/>
			<label for="formaCobro">Forma Cobro ${detalle.nombreCorto}:</label>
		</td>
		<td>
			<input id="formaCobro${status.count}" name="formaCobro" type="text" maxlength="20" size="20" readonly="true" disabled="disabled" value="${detalle.formaCobro}"/>
		</td>

		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="separador"></td> 
		<td class="label" nowrap="nowrap">
			<label for="cobraIVA${status.count}">Cobra IVA ${detalle.nombreCorto}:</label>
		</td>
		<c:if test="${detalle.cobraIVA == 'S'}" >
		<td> 
			<select id="cobraIVA${status.count}" name="cobraIVA" value="S" readonly="true" disabled="disabled">
				<option value="S">S&iacute; Cobra IVA</option>	
			</select>
		</td>
	</c:if> 
	<c:if test="${detalle.cobraIVA == 'N'}" >
	<td> 
		<select id="cobraIVA${status.count}" name="cobraIVA" value="N" readonly="true" disabled="disabled">
			<option value="N">No Cobra IVA</option>	
		</select>
	</td>						  	
</c:if> 

</tr>
<tr name="renglonAccesorio">  
	<td class="label" nowrap="nowrap">
		<label for="montoAccesorio${status.count}">Monto Accesorio: </label>
	</td>
	<td >
		<input id="montoAccesorio${status.count}" name="montoAccesorio" maxlength="20" size="20" readonly="true" esMoneda="true" style="text-align: right;" disabled="disabled" type="text" value="${detalle.montoAccesorio}"/>
	</td>
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="label" nowrap="nowrap">
		<label for="montoIVAAccesorio${status.count}">IVA Accesorio:</label>
	</td>
	<td>
		<input id="montoIVAAccesorio${status.count}" name="montoIVAAccesorio" maxlength="20" size="20" esMoneda="true" style="text-align: right;" readonly="true" disabled="disabled" value="${detalle.montoIVAAccesorio}" type="text"/>
	</td>	

</tr>
</c:if> 
<c:if test="${detalle.formaCobro == 'F' }" >

<tr name="renglonAccesorio">
	<td class="label" nowrap="nowrap">
		<input type="hidden" name="numAccesorio" value="${status.count}"/>
		<label for="formaCobro">Forma Cobro ${detalle.nombreCorto}:</label>
	</td>
	<td>
		<input id="formaCobro${status.count}" name="formaCobro" type="text" maxlength="20" size="20" readonly="true" disabled="disabled" value="${detalle.formaCobro}"/>
	</td>
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 

	<td class="label" nowrap="nowrap">
		<label for="cobraIVA${status.count}">Cobra IVA ${detalle.nombreCorto}:</label>
	</td>
	<c:if test="${detalle.cobraIVA == 'S'}" >
	<td> 
		<select id="cobraIVA${status.count}" name="cobraIVA" value="S" readonly="true" disabled="disabled">
			<option value="S">S&iacute; Cobra IVA</option>	
		</select>
	</td>
</c:if> 
<c:if test="${detalle.cobraIVA == 'N'}" >
<td> 
	<select id="cobraIVA${status.count}" name="cobraIVA" value="N" readonly="true" disabled="disabled">
		<option value="N">No Cobra IVA</option>	
	</select>
</td>						  	
</c:if> 
</tr>

</c:if>					

</c:forEach>

</c:when>
<c:when test="${tipoLista == '3'}">			
<c:forEach items="${listaResultado}" var="detalle" varStatus="status">


<c:if test="${detalle.formaCobro == 'A' || detalle.formaCobro  =='D' }" >

<tr name="renglonAccesorio">
	<td class="label" nowrap="nowrap">
		<input type="hidden" name="numAccesorio" value="${status.count}"/>
		<label for="formaCobro">Forma Cobro ${detalle.nombreCorto}:</label>
	</td>
	<td>
		<input id="formaCobro${status.count}" name="formaCobro" type="text" maxlength="20" size="20" readonly="true" disabled="disabled" value="${detalle.formaCobro}"/>
	</td>

	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="label" nowrap="nowrap">
		<label for="cobraIVA${status.count}">Cobra IVA ${detalle.nombreCorto}:</label>
	</td>
	<c:if test="${detalle.cobraIVA == 'S'}" >
	<td> 
		<select id="cobraIVA${status.count}" name="cobraIVA" value="S" readonly="true" disabled="disabled">
			<option value="S">S&iacute; Cobra IVA</option>	
		</select>
	</td>
</c:if> 
<c:if test="${detalle.cobraIVA == 'N'}" >
<td> 
	<select id="cobraIVA${status.count}" name="cobraIVA" value="N" readonly="true" disabled="disabled">
		<option value="N">No Cobra IVA</option>	
	</select>
</td>						  	
</c:if> 

</tr>
<tr name="renglonAccesorio">  
	<td class="label" nowrap="nowrap">
		<label for="montoAccesorio${status.count}">Monto Accesorio: </label>
	</td>
	<td >
		<input id="montoAccesorio${status.count}" name="montoAccesorio" maxlength="20" size="20" readonly="true" esMoneda="true" style="text-align: right;" disabled="disabled" type="text" value="${detalle.montoAccesorio}"/>
	</td>
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="label" nowrap="nowrap">
		<label for="montoIVAAccesorio${status.count}">IVA Accesorio:</label>
	</td>
	<td>
		<input id="montoIVAAccesorio${status.count}" name="montoIVAAccesorio" maxlength="20" size="20" esMoneda="true" style="text-align: right;" readonly="true" disabled="disabled" value="${detalle.montoIVAAccesorio}" type="text"/>
	</td>

</tr>
</c:if> 
<c:if test="${detalle.formaCobro == 'F' }" >

<tr name="renglonAccesorio">
	<td class="label" nowrap="nowrap">
		<input type="hidden" name="numAccesorio" value="${status.count}"/>
		<label for="formaCobro">Forma Cobro ${detalle.nombreCorto}:</label>
	</td>
	<td>
		<input id="formaCobro${status.count}" name="formaCobro" type="text" maxlength="20" size="20" readonly="true" disabled="disabled" value="${detalle.formaCobro}"/>
	</td>
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 
	<td class="separador"></td> 

	<td class="label" nowrap="nowrap">
		<label for="cobraIVA${status.count}">Cobra IVA ${detalle.nombreCorto}:</label>
	</td>
	<c:if test="${detalle.cobraIVA == 'S'}" >
	<td> 
		<select id="cobraIVA${status.count}" name="cobraIVA" value="S" readonly="true" disabled="disabled">
			<option value="S">S&iacute; Cobra IVA</option>	
		</select>
	</td>
</c:if> 
<c:if test="${detalle.cobraIVA == 'N'}" >
<td> 
	<select id="cobraIVA${status.count}" name="cobraIVA" value="N" readonly="true" disabled="disabled">
		<option value="N">No Cobra IVA</option>	
	</select>
</td>						  	
</c:if> 
</tr>

</c:if>					

</c:forEach>

</c:when>
</c:choose>
</table>
