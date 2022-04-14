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

<br></br>

<c:set var="listaResultado"  value="${listaResultado}"/>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Esquema</legend>
		<input type="button" id="agregaEsquema" value="Agregar" class="botonGral" tabIndex="2" onClick="agregaNuevoEsquema()"/>			
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   		<label for="lblNoEsquema">Esquema &nbsp;&nbsp;</label> 
						</td>
						<td class="label"> 
					   		<label for="lblCicloActual">Ciclo Ini. &nbsp;&nbsp;</label> 
						</td>
						<td class="label"> 
							<label for="lblCicloFinal">Ciclo Fin. &nbsp;&nbsp;</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMontoInicial">Monto Inicial</label> 
				  		</td>	
				  		<td class="label"> 
							<label for="lblMontoFinal">Monto Final</label> 
				  		</td>
				  		<td class="label"> 
							<label for="lblMontoMaximo">Monto Máximo</label> 
				  		</td>
				  		
					</tr>					
					<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
										value="${status.count}" />
								<input type="text" id="esquemaID${status.count}" name="esquemaID" size="6" 
										value="${esquema.esquemaID}" readOnly="true"   />
							</td>
							<td> 								
								<input  type="text" id="cicloInicial${status.count}" name="cicloInicial" size="6" 
										value="${esquema.cicloInicial}" readOnly="true"  /> 
 							</td> 
 							<td>
								<input  type="text" id="cicloFinal${status.count}" name="cicloFinal" size="6" 
										value="${esquema.cicloFinal}"  readOnly="true" /> 
							</td> 
						  	<td> 
							
								<input type="text" id="montoInicial${status.count}" name="montoInicial" size="15" 
										value="${esquema.montoInicial}"  readOnly="true"  esMoneda="true" style='text-align:right;'/>  
						  	</td> 
						  	<td> 
						  		<input type="text" id="montoFinal${status.count}" name="montoFinal" size="15" 
										value="${esquema.montoFinal}"  readOnly="true"  esMoneda="true" style='text-align:right;' />  
							</td> 
							<td> 	
								<input type="text" id="montoMaximo${status.count}" name="montoMaximo" size="15" 
										value="${esquema.montoMaximo}"  readOnly="true"  esMoneda="true" style='text-align:right;'/> 
										&nbsp;&nbsp;
						  	</td> 
						  	<td> 
								<input type="button" name="elimina"   id="${status.count}"  value="" class="btnElimina" onclick="eliminarEsquema(this.id)" />			
								<input type="button" name="agregaE" id="agregaE${status.count}" value="" class="btnAgrega" onclick="agregaNuevoEsquema()" />				 							
						  	</td> 					
						</tr>

					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br></br>
			     	</td>
				</tr>
			</table>
			 <input type="hidden" value="0" name="numeroEsquema" id="numeroEsquema" />
			 <input type="hidden" value="0" name="producID" id="producID" />			 
			 
			 <input type="hidden" id="datosGridEsquema" name="datosGridEsquema" size="100" />
			<input type="hidden" id="datosGridBajaEsquema" name="datosGridBajaEsquema"  value="" size="100" />
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>					
					<td align="right">
						<input type="submit" id="grabarEsquema" name="grabarEsquema" class="submit" value="Grabar" tabindex="50"/>	
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>		
					</td>			
				</tr>						
		 	</table>	
			
			
		 </fieldset>	
	


</body>
</html>