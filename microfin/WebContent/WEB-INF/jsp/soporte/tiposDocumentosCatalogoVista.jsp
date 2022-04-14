<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
	<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	<%@page contentType="text/html"%> 
	<%@page pageEncoding="UTF-8"%>
	<html>
		<head>
		
			<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
	     	<script type="text/javascript" src="js/soporte/tiposDocumentosCatalogoVista.js"></script> 
	     	
		</head>
	<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo de Documentos</legend>	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposDocumentosBean">		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td class="label">
					<label for="tipoDoc">Tipo Documento: </label>
				</td>
				<td >
					<input id="tipoDocumentoID" name="tipoDocumentoID"  size="15" tabindex="1" size="8" iniForma="false"/> 
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="nombre">Descripci&oacute;n:</label>
				</td>
				<td >
					<form:textarea  type="text"  name="descripcion" id="descripcion" path="descripcion" COLS="40" ROWS="2" maxlength="60"
						tabindex="2" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);"/> 
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="requerio">Requerido en:</label>
				</td>
				<td>
				<select multiple   id="requeridoEn" name="requeridoEn" path="requeridoEn" tabindex="3"  size="4">
						    <option value="C">CLIENTES</option>
						      <option value="Q">CUENTAS</option>
						      	<option value="P">PLD</option>
						          <option value="G">GARANTIAS</option>
						            <option value="S">SOLICITUD CRED</option>
						              <option value="O">POLIZA CONTABLE</option>
						                <option value="A">PROGRAMA DE PROTECCION AL AHORRO Y CREDITO</option>
						                  <option value="F">PROTECCION FUNERARIA (PROFUN)</option>
						                   <option value="K">CREDITOS</option>			
						                    <option value="Y">DOCUMENTOS DE APOYO ESCOLAR</option>
						                     <option value="B">SERVICIOS FUNERARIOS (SERVIFUN)</option>		
						                      <option value="M">SEGUIMIENTO</option>			                                
				</select>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="estatuslb">Estatus:</label>
				</td>
				<td>
					<select  id="estatus" name="estatus" path="estatus" tabindex="4" >
						      <option value="A">ACTIVO</option>
						      <option value="I">INACTIVO</option>		                                
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar" tabindex="5" />
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="6" />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
