<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
	<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	<%@page contentType="text/html"%> 
	<%@page pageEncoding="UTF-8"%>
	<html>
		<head>
		
			<script type="text/javascript" src="dwr/interface/grupoDocumentosServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
	     	<script type="text/javascript" src="js/soporte/clasificaDoctosGrpVista.js"></script> 
	     	
		</head>
	<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Clasificaci&oacute;n de Documentos</legend>	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clasificaGrpDocto">		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="label">
					<label for="tipoDoc">Grupo de Doc.: </label>
				</td>
				<td >
					<input id="grupoDocumentoID" name="grupoDocumentoID"  size="15" tabindex="1" size="8" iniForma="false"/> 
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="nombre">Descripci&oacute;n:</label>
				</td>
				<td >
					<form:textarea  type="text"  name="descripcion" id="descripcion" path="descripcion" COLS="40" ROWS="2" maxlength="100"
						tabindex="2" onBlur=" ponerMayusculas(this)"/> 
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="requerio">Requerido en:</label>
				</td>
				<td>
				<select multiple   id="requeridoEn" name="requeridoEn" path="requeridoEn" tabindex="3"  size="4">
						      <option value="C">INGRESO DEL CLIENTE</option>			                                
				</select>
				</td>
				<td class="separador"></td>
				
				<td class="label">
					<label for="requerio">Tipo Persona:</label>
				</td>
				<td>
				<select multiple   id="tipoPersona" name="tipoPersona" path="tipoPersona" tabindex="4"  size="4">
						      <option value="F">F&Iacute;SICA</option>
						        <option value="A">F&Iacute;SICA CON ACT. EMP.</option>
						          <option value="M">MORAL</option>		                                
				</select>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" value="Guardar" tabindex="5" />
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="6" />
					<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar" tabindex="7" />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="enUso" name="enUso"/>
				</td>
			</tr>	
		 	</table>
			<br>
			<br>				
			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetDocEnt" style="display: none;">                
				<legend>Grupos Existentes</legend>	
				<table align="right">
					<tr>
						<div id="gruposExistentes" style="display: none;" ></div>		
					</tr>
				</table>
			 </fieldset>
			 <br>
			 <br>				
			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetDoc" style="display: none;">                
				<legend>Documentos por Grupo</legend>	
				
							<input type="button" id="agregarDetalle" name="agregarDetalle" class="submit" value="Agregar" tabindex="30" onclick="agregaNuevoDetalle()"/>
						
				<table align="right">
					<tr>
						<div id="documentosPorGrupo" style="display: none;" ></div>		
					</tr>
				</table>
			 </fieldset>
			 <br>
			<table align="right">		 	
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="agregaDoc" name="agregaDoc" class="submit" value="Guardar" tabindex="50" style="display: none;"/>
					<input type="hidden" id="datosTipoDoc" name="datosTipoDoc"/>
					<input type="hidden" id="datosGridBaja" name="datosGridBaja"/>
					<input type="hidden" id="numeroGrupo" name="numeroGrupo"/>
					
				</td>
			</tr>	
		</table>
		</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
	</html>
