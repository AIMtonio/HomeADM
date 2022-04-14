<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/conceptoContableServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/polizaServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>     
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	    <script type="text/javascript" src="js/contabilidad/polizaPlantillaCatalogo.js"></script>
	</head>
   
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Plantillas Pólizas Contables</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="polizaBean">  	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td class="label"> 
				         <label for="lblpolizaID">Plantilla:</label> 
				     	</td> 
				     	<td> 
				      	<input id="plantillaID" type="text" name="plantillaID" path="plantillaID" size="11" 
				         	tabindex="1" /> 
				    
				     	</td> 
				     	<td class="separador"></td> 	
				     	<td class="label"> 
				      	<label for="lblfecha">Fecha:</label> 
				     	</td> 
				     	<td> 
				      	<form:input id="fecha" name="fecha" path="fecha" size="20"
				         	type="text" esCalendario="true" tabindex="2" iniForma = "false" /> 
				     	</td> 
					</tr>	
					<tr> 
						<td class="label"> 
				         <label for="lblconcepto">Concepto:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="conceptoID" name="conceptoID" path="conceptoID" size="4"
				         	tabindex="3" /> 
				     	</td> 
				     	<td class="separador"></td> 	
				     	<td class="label"> 
				      	<label for="lblDescripcion">Descripción:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="concepto" name="concepto" path="concepto" onblur=" ponerMayusculas(this)"  size="60"
				         	tabindex="4"  maxlength="150"/> 
				     	</td> 
				   </tr>		
					<tr>
						<td class="label"> 
				         <label for="lbltipo">Tipo:</label> 
				     	</td> 
				     	<td> 
				      	<form:input type="text" id="tipo" name="tipo" path="tipo" size="7"
				         	tabindex="5" value ="MANUAL" readOnly="true" disabled="true" /> 
				     	</td> 
				     	<td class="separador"></td> 	
				     <td class="label"> 
				         <label for="lblmonedaID">Moneda:</label> 
				     	</td>
				     	<td> 
				     		<select id="monedaID" name="monedaID" tabindex="6">
								<option value="">Seleccionar</option>
							</select> 
				     	</td> 
				 	</tr> 	
				 	<tr>
				 		<td class="label"> 
				         <label for="lbldesplant" id="lbldes">Descripción Plantilla:</label> 
				     	</td>
				     	<td> 
				     		<form:input type="text" id="desPlantilla" name="desPlantilla" onblur=" ponerMayusculas(this)"  size="60"
				         	tabindex="7" path="desPlantilla" /> 
				     	</td> 	
				     	<td class="separador"></td>
				     	<td class="label">
				     	<label>P&oacute;liza Generada:</label>
				     	</td>			
				     	<td>
				     	 <form:input type="text" id="polizaID"  name="polizaID" path="polizaID" size="11" readonly="true"/>
				     	</td>
				 	</tr>
				 	<input type="text" id="detallePoliza" name="detallePoliza" onblur=" ponerMayusculas(this)"  size="100"  style="display: none;" />	
				 	<tr>
						<td colspan="7">
							<div id="gridDetalle" style="display: none;"/>							
						</td>						
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">			
										<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar Póliza" tabindex="8"  />	
									</td>
									<td align="right">			
										<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar Plantilla" tabindex="9" />
									</td>
									<td align="right">			
										<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar Plantilla"  tabindex="10"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
									</td>
									<td align="right">
									
		                     		<button type="button" class="submit" id="imprimir" style="display: none;"  tabindex="11">
		                              Imprimir
		                      		</button>
		                      	</a>
									</td>
								</tr>
							</table>		
						</td>
					</tr>	
		     </table> 
	</fieldset> 
	</form:form>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>