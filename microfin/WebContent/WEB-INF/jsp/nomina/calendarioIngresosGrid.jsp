<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
     	
  <table id="miTabla" border="0"  width="100%">			
		<tr>
	
		    <td class="label" nowrap="nowrap">
		        <label for="lblConsecutivoID">N&uacute;mero</label> 
		    </td>
		  
		    <td nowrap="nowrap" class="label">
		        <label for="lblFechaLimite">Fecha L&iacute;mite Env&iacute;o</label> 
		    </td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblFechaDescuento">Fecha Descuento</label> 
		    </td>
		    <td nowrap="nowrap" class="label fechaLimiteRecep">
		        <label for="lblFechaDescuento">Fecha Recepci&oacute;n Incidencias</label> 
		    </td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblNCuotas">No. Cuotas</label> 
		    </td>
		    <td class="label">
				<label for="lbl"></label>
			</td>
		    
		</tr>	
		<c:forEach items="${listaResultado}" var="calendarioIngresos"   varStatus="estatus">
		<tr id="renglon${estatus.count}" name="renglon">
	  		
		    <td  nowrap="nowrap">
		        <input id="consecutivoID${estatus.count}" name="consecutivoID" size="12" value="${estatus.count}"  readonly="true" />
		    </td>
		    <td  >
		    
		        <input type="text" id="fechaLimiteEnvio${estatus.count}" name="lisFechaLimiteEnvio" 
		        	tabindex="6" size="12" value="${calendarioIngresos.fechaLimiteEnvio}" maxlength="10" esCalendario="true"
		        	onchange ="validaAnioFechaL(this.id); validarLogicaFechaRecepcion(this.id); validaFechaIgual(this.id); validaAscendenciaFL(this.id); "/> 
		    </td>  
		    <td>
		        <input type="text" id="fechaPrimerDesc${estatus.count}"	name="lisFechaPrimerDesc" 
		        	tabindex="7" size="12" value="${calendarioIngresos.fechaPrimerDesc}" maxlength="10"  esCalendario="true"
		        	onchange ="validaFecha(this.id);  validaAscendenciaFD(this.id);"  /> 
		    </td>
			<td class="fechaLimiteRecep">
		        <input type="text" id="fechaLimiteRecep${estatus.count}"	name="lisFechaLimiteRecep" 
		        	tabindex="8" size="12" value="${calendarioIngresos.fechaLimiteRecep}" maxlength="10"  esCalendario="true"
		        	onchange ="validaFechaRecepcion(this.id);"  /> 
		    </td>
		    <td  nowrap="nowrap">
		        <input type="text" id="numCuotas${estatus.count}" name="lisNumCuotas" 
		        	tabindex="9" size="12" value="${calendarioIngresos.numCuotas}" maxlength="4" onkeypress="return validaSoloNumero(event,this); "/> 
		    </td>  
		    <td>
			<input type="button" name="eliminar" id="${estatus.count}" tabindex="10"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
			<input type="button" tabindex="11" name="agrega" id="agrega${
			estatus.count}"  value="" class="btnAgrega" onclick="agregarNuevoRegistro()"/>
			
			</td>
		   
		</tr>
		
		</c:forEach>

	</table>

