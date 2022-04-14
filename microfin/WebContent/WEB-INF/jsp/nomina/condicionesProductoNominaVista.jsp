<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/condicionProductoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosNominaServicio.js"></script>
		<script type="text/javascript" src="js/nomina/condicionesProductoNomina.js"></script> 

	</head>
<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="condicionProductoNominaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Condiciones de Convenios</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend>Condiciones de Convenios</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label>Empresa Nómina:</label>
							</td>
							<td>
								<input type="text" id="institNominaID" name="institNominaID" size="12" maxlength="10"  tabindex="1"  />
						
								<input type="text" id="descripcion" name="descripcion" size="50" disabled="true" />
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label>No. Convenio:</label>
							</td>
							<td>
						
							<form:select id="convenioNominaID" name="convenioNominaID" path="convenioNominaID" tabindex="2">
									<form:option value="0">SELECCIONAR</form:option> 
							</form:select>
							
							</td>	
						</tr>	
							
				</table>
			
				</fieldset>
				
			<div id="contenedorProductosCred" style="display: none;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Esquemas</legend>
				<table border="0" cellpadding="0" cellspacing="5">
					<tr>
						<td>
							<input type="button" id="agregarCondCred" name="agregarCondCred" value="Agregar" class="submit" onclick="agregarDetalleCred('tablaGridCred')" tabindex="3"/>
						</td>
						<td class="separador">
					</tr>
				</table>
				<div id="formaTablaCred" style="display: none;"></div>
				<table border="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="grabaCred" name="grabar" class="submit" value="Grabar" style="display: none;" tabindex="8" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="condicionCredID" name="condicionCredID"/>
							<input type="hidden" id="productoCreditoID" name="productoCreditoID" />
						</td>
					</tr>
				</table>
				
				<div id="contenedorEsqTasa" style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Esquema Tasa</legend>
						<div id="formaTablaEsqTasa" style="display: none;"></div>
						<table border="0" width="100%">
							<tr>
								<td align="right">
									<input type="submit" id="grabaEsqTasa" name="grabar" class="submit" value="Grabar" style="display: none;" tabindex="12"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								</td>
							</tr>
						</table>	
					</fieldset>
				</div>
				
			</fieldset>
		</div>
				
				
				</fieldset>
			</form:form>
		</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
	<div id="elementoLista"/>
</div>	
</html>