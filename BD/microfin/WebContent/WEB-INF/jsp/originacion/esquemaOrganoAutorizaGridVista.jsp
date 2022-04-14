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

<c:set var="listaResultadoOrgano"  value="${listaResultado}"/>
												
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >                
		<legend>Firmas</legend>
		<input type="button" id="agregaOrgano" value="Agregar" class="botonGral" tabindex="51" onClick="agregaNuevoOrgano()"/>	
			<table id="tablaOrgano" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblNoEsquema">No.Esquema</label> 
						</td>
						<td class="label"> 
					   	<label for="lblCicloActual">No. Firma</label> 
						</td>
						<td class="label"> 
							<label for="lblCicloFinal">Facultado</label> 
				  		</td>						  					  		
				  		
					</tr>					
					<c:forEach items="${listaResultadoOrgano}" var="organoAutoriza" varStatus="status">
						<tr id="filas${status.count}" name="filas">
							<td>
								<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="6" value="${status.count}" />
								<input type="hidden" id="nuevo${status.count}" name="nuevo" size="6" value="" />		
								<input type="hidden" id="esquemas${status.count}" name="esquemas1" size="6" value="" />									
								<input type="hidden" id="desEsquema${status.count}" name="desEsquema" size="30" value="${organoAutoriza.esquemaID}" onclick="cargaListaEsquemas()"  />
								<select id="esquema${status.count}" name="esquema"  type="select"  >
											<option value=" ">Seleccione</option>
																			
								</select> 								
							</td>
							<td> 	
								<input type="hidden" id="numFirma${status.count}" name="numFirma" size="30" value="${organoAutoriza.numeroFirma}" />
								<input type="hidden" id="numeroFirmas${status.count}" name="numeroFirmas1" size="6" value="" />									
								<select id="numeroFirma${status.count}" name="numeroFirma"  type="select"  >
									<option value="1">Firma A</option>
									<option value="2">Firma B</option>
									<option value="3">Firma C</option>
									<option value="4">Firma D</option>
									<option value="5">Firma E</option>
									
								</select> 
 							</td> 
 							<td>
 								<input type="hidden" id="valorOrganoID${status.count}" name="valorOrganoID" size="30" value="${organoAutoriza.organoID}"  />
 								<input type="hidden" id="organosID${status.count}" name="organosID1" size="6" value="" />		
								<select id="organoID${status.count}" name="organoID"  type="select"   >
										<option value=" ">Seleccione</option>										
								</select> 
							</td> 						  	
						  	<td> 
								<input type="button" name="eliminar" id="eliminar${status.count}"  value="" class="btnElimina" onclick="eliminarOrgano(this.id)" />			
								<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoOrgano()" />
								 						
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
			 <input type="hidden" value="0" name="numeroOrganoAutoriza" id="numeroOrganoAutoriza" /><!-- Numero de filas -->
			 <input type="hidden" value="0" name="productoCredID" id="productoCredID" />			 <!-- Producto -->
			 
			 <input type="hidden" id="datosGridOrganoAutoriza" name="datosGridOrganoAutoriza" size="100" /><!-- datos alta -->
			<input type="hidden" id="datosGridBajaOrgano" name="datosGridBajaOrgano"  value="" size="100" />		<!-- datos baja -->
			<input type="hidden" id="datosGridModificaOrgano" name="datosGridModificaOrgano"  value="" size="100" /><!-- datos Modifica -->
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>					
					<td align="right">
						<input type="submit" id="grabarOrgano" name="grabarOrgano" class="submit" value="Grabar" tabindex="100"/>	
						<input type="hidden" id="tipoTransaccionOrgano" name="tipoTransaccionOrgano" value="0"/>		
					</td>			
				</tr>						
		 	</table>	
			
			
	 </fieldset>	
</body>
</html>





