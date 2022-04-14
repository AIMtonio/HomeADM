<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">                	
  <table border="0"  width="100%">			
		<tr>
		    <td class="label" nowrap="nowrap">
		        <label for="lblTipoEmpleadoID">No. Empleado</label> 
		    </td>
		    <td class="separador"></td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblDescripcion">Tipo de Empleado</label> 
		    </td>
		    <td class="separador"></td>
		     <td class="label" nowrap="nowrap">
		        <label for="lblSeleccionar">Seleccionar <br>Todos<br></label> 
		        <input type="checkbox" id="seleccionaTodos" name="seleccionaTodos"  onclick="seleccionarTodos()"/>	
			</td>	
		   <td class="separador"></td>
		    <td nowrap="nowrap" class="label" align="center" >
		    	<label for="lblPorcentaje" >Porcentaje <br>Capacidad<br></label>
		        <label for="lblSinTratamiento">Sin Tratamiento</label> 
		        <label for="lblConTratamiento">Con Tratamiento</label> 
		         
		    </td>
		    
		  
		</tr>	
		<c:forEach items="${listaResultado}" var="tipoEmpleadosConv"   varStatus="estatus">
		<tr id="renglon${estatus.count}" name="renglon">
		    <td  nowrap="nowrap">
		        <input type="text" id="tipoEmpleadoID${estatus.count}"	name="listaTipoEmpleadoID" 
		        	tabindex="2" size="12" value="${tipoEmpleadosConv.tipoEmpleadoID}" readonly="readonly"/> 
		    </td>
		    <td class="separador"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="descripcion${estatus.count}" name="listaDescripcion" 
		        	tabindex="3" size="40" value="${tipoEmpleadosConv.descripcion}" disabled="disabled"/> 
		    </td>  
		    <td class="separador"></td>
		     <td nowrap="nowrap"> 
				<input type="checkbox" id="seleccionaCheck${estatus.count}" name="seleccionaCheck"  onclick="verificaCheck(this.id)"/>
				<input type="hidden" id="seleccionado${estatus.count}" name="listaSeleccionado"  value="${tipoEmpleadosConv.seleccionado}" size="5"/> 		
			</td>
		    <td class="separador"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="sinTratamiento${estatus.count}" name="listaSinTratamiento" 
		        	tabindex="3" maxlength="6" size="12" value="${tipoEmpleadosConv.sinTratamiento}" readonly="readonly" onblur="validaSinTratamiento(this.id)" onkeypress='return ingresaSoloNumeros(event,1,this.id);' style="text-align: right"  /> 
		       
		        <input type="text" id="conTratamiento${estatus.count}" name="listaConTratamiento" 
		        	tabindex="3" maxlength="6" size="12" value="${tipoEmpleadosConv.conTratamiento}" readonly="readonly" onblur="validaConTratamiento(this.id)" onkeypress='return ingresaSoloNumeros(event,1,this.id);' style="text-align: right"  /> 
		    </td> 
		</tr>
		</c:forEach>
	</table>
</fieldset>