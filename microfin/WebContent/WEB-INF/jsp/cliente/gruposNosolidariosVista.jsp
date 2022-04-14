<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/integraGrupoNosolServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/gruposNosolidarios.js"></script> 
	<script type="text/javascript" src="js/cliente/gruposNosolidarios.js"></script>  
	    
	
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="gruposNosolidariosBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Grupos No Solidarios</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="70%">
			<tr>
				<td class="label">
					<label>No. Grupo:</label>
				</td>
				<td>
					<form:input type="text" id="grupoID" name="grupoID" path="grupoID" tabindex="1" size="10" />
					<form:input type="text" id="nombreGrupo" name="nombreGrupo" path="nombreGrupo" onblur=" ponerMayusculas(this)" tabindex="2"  size="50"  maxlength="200"/>
					<form:input type="hidden" id="sucursalID" name="sucursalID" path="sucursalID"/>
				</td>
				<td class="separador"></td>	
				<td class="label">	
					<label>No. Integrantes:</label>
				</td>
				<td>
					<form:input type="text" id="numIntegrantes" name="numIntegrantes" path="numIntegrantes" readOnly="true" size="5" />
				</td>
			</tr>
		</table>
		<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Generalidades</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					<label>Promotor:</label>
				</td>
				<td>
					<form:input type="text" id="promotorID" name="promotorID" path="promotorID" tabindex="3" size="10" />
					<input type="text" id="nombrePromotor" name="nombrePromotor" path="nombrePromotor" readOnly="true" size="50" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Estado:</label>
				</td>
				<td>
					<form:input type="text" id="estadoID" name="estadoID" path="estadoID" tabindex="4" size="10" />
					<input type="text" id="nombreEstado" name="nombreEstado" path="nombreEstado" readOnly="true" size="50" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Municipio:</label>
				</td>
				<td>
					<form:input type="text" id="municipioID" name="municipioID" path="municipioID" tabindex="5" size="10" />
					<input type="text" id="nombreMunicipio" name="nombreMunicipio" path="nombreMunicipio" readOnly="true" size="50" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Ubicaci&oacute;n:</label>
				</td>
				<td>
					<form:textarea type="text" id="ubicacion" name="ubicacion" path="ubicacion" cols="47" rows="5"  
							  onblur=" ponerMayusculas(this)" tabindex="6" maxlength = "800"></form:textarea>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label>Lugar de<br>Reuni&oacute;n:</label>
				</td>
				<td>
					<form:textarea type="text" id="lugarReunion" name="lugarReunion" path="lugarReunion" cols="47" rows="4"  
							  onblur=" ponerMayusculas(this)" tabindex="7" maxlength = "200"></form:textarea>
				</td>
			</tr>
		</table>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Detalle Grupo</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="70%">
				<tr>
					<td class="label">
						<label>D&iacute;a de Reuni&oacute;n:</label>
					</td>
					<td align="right">
						<form:input type="text" id="diaReunion" name="diaReunion" path="diaReunion" onblur=" ponerMayusculas(this)" tabindex="8" size="20" maxlength = "30" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Hora de Reuni&oacute;n:</label>
					</td>
					<td align="right">
						<form:input type="text" id="horaReunion" name="horaReunion" path="horaReunion"  onblur=" ponerMayusculas(this)" tabindex="9"  size="20" maxlength = "8" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Ahorro Obligatorio:</label>
					</td>
					<td align="right">
						<form:input type="text" id="ahoObligatorio" name="ahoObligatorio" path="ahoObligatorio" esMoneda="true" style="text-align:right;" tabindex="10" size="20" maxlength = "15" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>Plazo Cr&eacute;dito:</label>
					</td>
					<td align="right">
						<form:input type="text" id="plazoCredito" name="plazoCredito" path="plazoCredito" onblur=" ponerMayusculas(this)"  tabindex="11"  size="20"  maxlength = "15"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Costo Ausencia:</label>
					</td>
					<td align="right">
						<form:input type="text" id="costoAusencia" name="costoAusencia" path="costoAusencia" esMoneda="true" style="text-align:right;"  tabindex="12" size="20" maxlength = "15" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label>% Ahorro Comprometido:</label>
					</td>
					<td align="right">
						<form:input type="text" id="ahorroCompro" name="ahorroCompro" path="ahorroCompro"  esMoneda="true" style="text-align:right;" tabindex="13"  size="20" maxlength = "15"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label>Costo Mora:</label>
					</td>
					<td align="right">
						<form:input type="text" id="moraCredito" name="moraCredito" path="moraCredito" esMoneda="true" style="text-align:right;" tabindex="14" size="20" maxlength = "15"/>
					</td>
				</tr>
			</table>
		</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="15"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="16"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>	
		</fieldset>
		<br>
	<div id="gridIntegrantes" style="display: none;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Integrantes</legend>
				 <table   id="tablaCliente" border="0" cellpadding="2" cellspacing="0" width="100%">
				 <tr>
				 	<td>
				 		<input type="button" id="agregaI" name="agregaI" path="agregaI" tabindex="17" value="Agregar" class="submit"/>
				 	</td>
				 </tr>
			 	<tr>
			 		<td><label>No. <s:message code="safilocale.cliente"/></label> </td>
			 		<td><label>Nombre Completo</label></td>
			 		<td><label>Menor</label></td>
			 		<td><label>Estatus</label></td>
			 		<td><label>Tipo Integrante</label></td>
			 		<td><label>Ahorros</label></td>
			 		<td><label>Exigible al D&iacute;a</label></td>
			 		<td><label>Total al D&iacute;a</label></td>
			 		<td></td>
			 	</tr>
				
			 </table>
			 
			 <table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="18"/>
				<input type="hidden" id="tipoTransaccionGrid" name="tipoTransaccionGrid"/>
				<input type="hidden" id="lblCliente" value=<s:message code="safilocale.cliente"/> name="tipoTransaccionGrid"/>
			</td>
		</tr>
	</table>	
</fieldset>
	</div>
</fieldset>
</form:form>
</div>	
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>