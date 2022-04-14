<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
		
		<script type="text/javascript" src="dwr/interface/escalamientoPrevioServicioScript.js"></script>
		<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/escalaSolServicio.js"></script> 
		<script type="text/javascript" src="js/pld/escalamientoPrevio.js"></script> 
	    
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="escalamientoPrevio"> 
	<fieldset class="ui-widget ui-widget-content ui-corner-all">            
		<legend class="ui-widget ui-widget-header ui-corner-all">Escalamiento de Operaciones Previo a la Formalizaci&oacute;n</legend>            
		   <table border="0" cellpadding="0" cellspacing="0" width="100%">
				
				<tr>
			     <td class="label"> 
			         <label for="leyend">Se requiere Escalamiento cuando:</label> 
			         <br>
			         <br>
				</td> 
			     </tr>
			     
			     <tr>
						<td class="label"><label for="lbFolio">Folio:</label></td>
						<td><form:input id="folioID" name="folioID" path="folioID" size="4" tabindex="1" />
						</td>
				</tr>
					
				<tr>
			    	 <td class="label"> 
			         <label for="1"></label> 
			         <br>
					</td> 
			     </tr>
			     		<tr>
						<td class="label"><label for="fechaVigencia">Fecha
								Inicio Vigencia: </label></td>
						<td><input id="fechaVigencia" name="fechaVigencia" path="fechaVigencia"
							tabindex="2" disabled="disabled" type="text" value="" size="12"/>
						</td>
					</tr>
					
					<tr>
			    	 <td class="label"> 
			         <label for="1"></label> 
			         <br>
					</td> 
			     </tr>
			     
				<tr>
			     <td class="label"> 
			         <label for="nivelRiesgoID">Nivel de Riesgo:</label> 
			     </td> 
			     <td> 
			         <form:select id="nivelRiesgoID" name="nivelRiesgoID" path="nivelRiesgoID" tabindex="3">
							<form:option value="0">SELECCIONAR</form:option>
							<form:option value="1">ALTO</form:option>
							<form:option value="2">BAJO</form:option>
						</form:select>  
			     </td> 
			 	</tr>
			 	<tr>
			     <td class="label"> 
			         <label for="1"></label> 
			         <br>
				</td> 
			     </tr>
			 	
			
					<tr>
			     <td class="label"> 
			         <label for="rolTitular">Puesto Titular:</label> 
			     </td>
			     <td>
			         <form:input id="rolTitular" name="rolTitular" path="rolTitular" size="4"
			         				tabindex="4"/>  
			          <input type="text" id="descripcion" name="descripcion" size="20" tabindex="5" disabled="true"/>  
			         </td> 
			   
		   </tr>
		   <tr>
			     <td class="label"> 
			         <label for="5"></label> 
			         <br>
				</td> 
			     </tr>
		   
		   	<tr>
			     <td class="label"> 
			         <label for="rolSuplente">Puesto Suplente:</label> 
			     </td>
			     <td>
			         <form:input id="rolSuplente" name="rolSuplente" path="rolSuplente" size="4"
			         				tabindex="6"/>  
			         <input type="text" id="descripcionSuplente" name="descripcion" size="20" tabindex="7" disabled="true"/> 
			         </td> 
		   </tr>
		   		
					<tr>										
										<td class="label">
											<label for="estatus">Estatus:</label>
										</td>
										<td>
						         			<form:select id="estatus" name="estatus" tabindex="8" path ="estatus" disabled="true">
						         				<form:option value="">SELECCIONAR</form:option>
												<form:option value="V">VIGENTE</form:option>
												<form:option value="B">BAJA</form:option>		
											</form:select>  
			    			 			</td> 
					</tr>
		   
	     </table> 
	</fieldset>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right"><input type="submit" id="grabar"
									name="grabar" class="submit" value="Grabar" tabindex="9" /> 
									<input type="submit" id="modifica" name="modifica" class="submit"
									value="Modificar" tabindex="10" /> 
									<input type="submit" id="baja" name="baja" class="submit"
									value="Baja" tabindex="11" /> 
									<input type="hidden" id="historico" name="historico" class="submit"
									value="Hist&oacute;rico" tabindex="12" />
									<input type="hidden"
									id="tipoTransaccion" name="tipoTransaccion" /></td>
							</tr>
						</table>		
					</td>
				</tr>	
	     </table> 
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