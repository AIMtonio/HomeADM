<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Puestos</legend>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="organoID">Clave del Puesto</label> 
						</td>
						<td class="label"> 
					   	<label for="descripcion">Descripción</label> 
						</td>
						<td class="label"> 
					   	<label for="descripcion">Asignar</label> 
						</td>
					
				  			
					</tr>					
					<c:forEach items="${listaResultado}" var="puestos" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />								
 								<input type="text" id="clavePuestoID${status.count}" name="clavePuestoID" size="20" value="${puestos.clavePuestoID}" readOnly="true" disabled="true" />   								
						  	</td> 
						 
						  	<td> 
								<input  type="text" id="descripcionPuesto${status.count}" name="descripcionPuesto" size="50" 
										value="${puestos.descripcionPuesto}"  readOnly="true" disabled="true" /> 				
								 							 							
						  	</td> 
						  	<td> 
								<input type="hidden" id="asig${status.count}" name="asig" size="30" value="${puestos.asignado}"  />  														
								<input TYPE="checkbox"id="asignado${status.count}" name="asignado" value="${puestos.asignado}" onclick="realiza(this.id)"/>
	    							<label for="Aceptado" > </label>  							 							
						  	</td> 		
						  			
						  					
						</tr>
						
						
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
			</fieldset>																				
			 <input type="hidden" value="0" name="numeroOrgano" id="numeroOrgano" />
	
	

</body>
</html>

<script type="text/javascript">		
$("#numeroOrgano").val(consultaFilas());	




realizaChecked();
function realizaChecked(){	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdAsi = eval("'asig" + numero+ "'");				
		var jqIdAsignado = eval("'asignado" + numero+ "'");
		
		var valorAsig= document.getElementById(jqIdAsi).value;
		
		if(valorAsig=='S'){
			$('#asignado'+numero).attr('checked','true');
			document.getElementById(jqIdAsignado).value = 'S';
				
		}else{
			$('#asignado'+numero).attr('checked',false);
		}	
	});
	
}
</script>



