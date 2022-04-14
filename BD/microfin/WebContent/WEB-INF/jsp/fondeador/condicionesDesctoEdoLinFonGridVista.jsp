<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<table border="0" cellpadding="0" cellspacing="0" id="tablaEstadosMun">			
	<tr>
		<td class="label" colspan="2">
			<label for="lblHabitantes">N&uacute;mero de Habitantes en la Localidad</label>
		</td>
		<td class="separador"></td>
	</tr>
	<tr>
		<td class="separador"></td>
		<td class="separador"></td>
	</tr>
	<tr>
		<td class="label" colspan="2" nowrap="nowrap">
			<label for="lblHabitantes">L&iacute;mite Inferior</label>
		</td>
		<td nowrap="nowrap">
			<label for="lblHabitantes">L&uacute;mite Superior</label>
		</td>	
	</tr>
	<tr>
		<td class="label" colspan="2" nowrap="nowrap">
			<input type = "text" id="numHabitantesInf" name="numHabitantesInf" size="10" onkeypress="return IsNumber(event)" onblur="validaLimiteInferior();"/>
		</td>
		<td nowrap="nowrap">
			<input type = "text" id="numHabitantesSup" name="numHabitantesSup" size="10" onkeypress="return IsNumber(event)" onblur="validaLimiteSuperior();"/>
			<label for="lblHab"> (0 = Sin L&iacute;mite)</label>
		</td>	
	</tr>
	<tr><td nowrap="nowrap"></td></tr>
	<tr><td nowrap="nowrap"></td></tr>
	<tr><td nowrap="nowrap"></td></tr>
	<tr>
	    <td class="label" colspan="2">
			<label for="lblEstado">Estado</label>
		</td> 
		<td class="label"colspan="2">
			<label for="lblMunicio">Municipio</label>
		</td> 
		<td class="label">
			<label for="lblLocalidad">Localidad</label>
		</td>
		<td></td>
		<td></td>
	</tr>			
	<c:forEach items="${listaResultado}" var="estadoMunBean"   varStatus="status">
	<tr id="renglonEdo${status.count}" name= "renglonEdo">
		<td nowrap="nowrap">
			<input type = "text" id="estadoID${status.count}" name="listaEstadoID" size="10" value="${estadoMunBean.estadoID}"
				onkeypress="listaEstadosGrid(this.id);" onblur="validaEstado(this.id);consultaEstadoDescripcionGrid(this.id);" />
			<input type = "text" id="estadoDescripcion${status.count}" name="estadoDescripcion" size="35"  disabled="disabled" 
				readonly="readonly"/>
		</td> 
		<td class="separador"></td>
		<td nowrap="nowrap">
			<input type = "text" id="municipioID${status.count}" name="listaMunicipioID"  size="10"  value="${estadoMunBean.municipioID}"
				onkeypress="listaMunicipiosGrid(this.id);" onblur="validaMunicipio(this.id);consultaMunicipioDescripcionGrid(this.id);"/>
			<input type = "text" id="municipioDescripcion${status.count}" name="municipioDescripcion" size="35"  disabled="disabled" 
				readonly="readonly"/>
		</td> 
		<td class="separador"></td>
		<td nowrap="nowrap">
			<input type = "text" id="localidadID${status.count}" name="listaLocalidadID" size="10"  value="${estadoMunBean.localidadID}"
				onkeypress="listaLocalidadesGrid(this.id);" onblur="validaLocalidad(this.id);consultaLocalidadDescripcionGrid(this.id);"/>
			<input type = "text" id="localidadDescripcion${status.count}" name="localidadDescripcion" size="40"  disabled="disabled" 
				readonly="readonly"/>
		</td> 
		<td>
			<input type="button" name="eliminaEdo" id="eliminaEdo${status.count}" value="" class="btnElimina" onclick="eliminaFilaEdo(this.id)"/>
		</td>  
		<td>
			<input type="button" name="agregaEdo" id="agregaEdo${status.count}" value="" class="btnAgrega" onclick="agregarNuevaFilaEdoMun()"/>
		</td>
		<td>
			<input type="hidden" id="auxHabitantes${status.count}" name="auxHabitantes" size="7" value="${estadoMunBean.numHabitantesInf}"/>	
			<input type="hidden" id="auxHabitantes1${status.count}" name="auxHabitantes1" size="7" value="${estadoMunBean.numHabitantesSup}"/>	
		</td>
		<c:set var="numeroDetalleEdo"  value="${status.count}"/>
	</tr>
	</c:forEach>
	<tr>
		<td>
			<input type = "hidden" id="numeroDetalleEdo" name="numeroDetalleEdo" value = "${numeroDetalleEdo}" size="10"  />
		</td>
	</tr>
</table>
<br></br>   