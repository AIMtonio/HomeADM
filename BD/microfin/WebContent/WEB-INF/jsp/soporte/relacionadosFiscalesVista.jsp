<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/relacionadosFiscalesServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
		
		<script type="text/javascript" src="js/soporte/relacionadosFiscales.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="relacionadosFiscalesBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Relacionados Fiscales</legend>
			<table>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="clienteID">Aportante:</label>
					</td>
					<td nowrap="nowrap">
				    	<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1" maxlength="20" autocomplete="off" 	/>
					</td>
					<td class="separador"/>	
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="ejercicio">Ejercicio:</label>
					</td>
	 				<td nowrap="nowrap">
						<form:select id="ejercicio" name="ejercicio" path="ejercicio" tabindex="2">
							<form:option value="">SELECCIONAR</form:option>
						</form:select>						
					</td>
					<td class="separador"/>
					<td class="label" nowrap="nowrap">
						<label for="tipoPersonaCte">Tipo de Persona:</label>
					</td>
					<td nowrap="nowrap">		
						<input type="radio" id="tipoPersonaFisicaCte" name="tipoPersonaCte" value="F"  disabled="disabled"/>						
						<label>Física</label>
						<input type="radio" id="tipoPersonaFisActEmpCte" name="tipoPersonaCte" value="A" disabled="disabled" />						
						<label>Física Act. Emp.</label>
					</td>	
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="nombreCompletoCte">Nombre:</label>
					</td>
					<td nowrap="nowrap">
						<input type="text" id="nombreCompletoCte" name="nombreCompletoCte" size="60" readonly="readonly" disabled="disabled"/>
					</td>
					<td class="separador"/>
					<td class="label" nowrap="nowrap">
						<label for="tipoPersonaCte">Registro Alta en Hacienda:</label>
					</td>
					<td nowrap="nowrap">		
						<input type="radio" id="registroHaciendaCteSi" name="registroHaciendaCte" value="S" disabled="disabled"/>						
						<label>Si</label>
						<input type="radio" id="registroHaciendaCteNo" name="registroHaciendaCte" value="N" disabled="disabled" />						
						<label>No</label>
					</td>							
				</tr>
				<tr>
					<td class="label">
						<label for="nacionCte">Nacionalidad:</label>
					</td>
					<td>
						<select id="nacionCte" name="nacionCte" disabled="true"	>
							<option value="">SELECCIONAR</option> 
							<option value="N">MEXICANA</option> 
						    <option value="E">EXTRANJERA</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="paisResidenciaCte">Pa&iacute;s de Residencia: </label>
					</td>
					<td>
						<input type="text" id="paisResidenciaCte" name="paisResidenciaCte" size="9"  disabled="true" readOnly="true" />
						<input type="text" id="nombrePaisResidencia" name="nombrePaisResidencia" size="30" disabled="true" readOnly="true" />
					</td>						
				</tr>
				<tr>					
					<td class="label">
						<label for="RFCCte"> RFC:</label>
					</td>
					<td>
						<input type="text" id="RFCCte" name="RFCCte" size="40" disabled="true" readOnly="true"/>
					</td>	
					<td class="separador"></td>
					<td class="label">
						<label for="CURPCte">CURP:</label>
					</td>
					<td>
						<input type="text" id="CURPCte" name="CURPCte" size="40" disabled="true" readOnly="true"/>
					</td>						
				</tr>
				<tr>	
					<td class="label">
						<label for="domicilioFiscal">Domicilio Fiscal:</label>
					</td>					
					<td nowrap="nowrap">
						<textarea id="domicilioFiscal" name="domicilioFiscal" cols="37" rows="3" disabled ="true" readonly="true" ></textarea>
					</td>
					<td class="separador"></td>		
					<td class="label" nowrap="nowrap">
						<label for="participaFiscalCte">Participación Fiscal:</label>
	      			</td>		
	 				<td nowrap="nowrap">
       		 			<form:input type="text" id="participaFiscalCte" name="participaFiscalCte" path="participaFiscalCte" size="15" tabindex="3" autocomplete="off"  maxlength="10" disabled ="true" readonly="true" esMoneda="true" style="text-align:right;"/><label>%</label>       		 			
					</td>
				</tr>
			</table>		
			<div id="divPersonasRelacionadas" style="display: none;">			
		 		<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Personas Relacionadas</legend>
					<table>
						<tr>
							<td align="left">
								<input type="button" id="agregar" name="agregar" class="submit" tabindex = "4" value="Agregar" />
							</td>
						</tr>
						<tr>
							<td>
								<div id="divGridPersonasRelacionadas"></div>
							</td>
						</tr>
					</table>
				</fieldset>	
					
				<table width="100%">
					<tr align="right" >
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" tabindex="501" value="Grabar" />							
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</div>	
		</fieldset>
	</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>