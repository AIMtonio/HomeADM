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
		<legend>Operaciones Inusuales</legend>		
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   		<label for="lblnumero">N&uacute;mero</label> 
						</td>
						<td class="label"> 
					   		<label for="lblnumero">Fecha de<br> Detecci&oacute;n</label> 
						</td>
						<td class="label"> 
					   		<label for="lblFechaDeteccion">D&iacute;as para<br>Enviar</label> 
						</td>
						<td class="label"> 
							<label for="lblClaveRegistra">Fecha de <br>Reporte</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblClaveRegistra">Registr&oacute;</label> 
				  		</td>			  		
				  		<td class="label"> 
							<label for="lblDesMovIn"> Des. Motivo</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblDesOper"> Desc. Operaci&oacute;n</label> 
				  		</td>
				  		
				  		<td class="label"> 
							<label for="lblComentarios"> Comentario OC</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lbl"> Enviar</label> 
				  		</td>				  							  			
					</tr>					
					<c:forEach items="${listaResultado}" var="operInusual" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="6" value="${estado.count}" />								
 								<input type="text" id="opeInusualID${status.count}" name="opeInusualID" size="6" value="${operInusual.opeInusualID}" readOnly="true" disabled="true"  />
						  	</td>
						  	<td>
 								<input type="text" id="fechaDeteccion${status.count}" name="fechaDeteccion" size="11" value="${operInusual.fechaDeteccion}" readOnly="true" disabled="true" />
 							</td>
						  	<td> 
								<input  type="text" id="diasTranscurridos${status.count}" name="diasTranscurridos" size="6" value="${operInusual.diasRestantes}" readOnly="true" disabled="true" /> 							 							
						  	</td> 
						  		
						  	<td> 
								<input type="text" id="fechaReporte${status.count}" name="fechaReporte" size="11" value="${operInusual.fechaCierre}" readOnly="true" disabled="true" />  														
								 							 							
						  	</td> 
						  	<td> 
								<input type="text" id="claveRegistraDescri${status.count}" name="claveRegistraDescri" size="25" value="${operInusual.claveRegistraDescri}" readOnly="true" disabled="true" />  														
								 							 							
						  	</td> 
						  	<td> 
								<input type="text" id="desCorta${status.count}" name=desCorta size="40" value="${operInusual.desCorta}" readOnly="true" disabled="true" />  														
								 							 							
						  	</td> 		
						  	
						  	<td> 
								<input type="text" id="desOperacion${status.count}" name="desOperacion" size="50" value="${operInusual.desOperacion}" readOnly="true" disabled="true" />  														
								 							 							
						  	</td> 	
						  	<td> 
								<input type="text" id="comentarioOC${status.count}" name="comentarioOC" size="40" value="${operInusual.comentarioOC}" readOnly="true" disabled="true" />  														
								 							 							
						  	</td> 	
						  	<td> 
						  	<input type="hidden" id="folioInterno${status.count}" name="folioInterno" size="2" value="${operInusual.folioInterno}" readOnly="true" disabled="true" />
								<input TYPE="checkbox" id="reportar${status.count}" name="reportar" onclick="verificaSiHaySeleccionados()"/>
	    							<label for="Reportar" > </label>   														
								 							 		
								 					
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
			<table align="right">
			<tr>				
				<td>
					<input type="button" id="seleccionarT" name="seleccionarT" class="submit" tabindex="5"value="Seleccionar Todo" onClick="seleccionarTodo()"/>
					<input type="button" id="quitarT" name="quitarT" class="submit" tabindex="6" value="Quitar todo" onClick="quitarTodo()"/>
					
				</td>
			</tr>										  										
	  	</table>
		<input type="hidden" value="0" name="numeroFilas" id="numeroFilas" />
	</fieldset>
</body>
</html>