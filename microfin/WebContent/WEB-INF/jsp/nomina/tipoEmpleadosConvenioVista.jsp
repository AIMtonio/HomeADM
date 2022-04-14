<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoEmpleadosConvenioServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script> 
		<script type="text/javascript" src="js/nomina/tiposEmpleadosConvenio.js"></script> 
	</head>
<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoEmpleadosConvenioBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Tipos Empleados Convenio N&oacute;mina</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend>Empresa de N&oacute;mina</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label>Empresa Nómina:</label>
							</td>
							<td>
								<input type="text" id="institNominaID" name="institNominaID" size="12" maxlength="10"  tabindex="1"  />
						
								<input type="text" id="descripcion" name="descripcion" size="50" disabled="true"/>
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
				<div id="gridTipoEmpleadosConvenio"  style="display:none" ></div>
		  	
			  	<table border="0" width="100%">
					<tr >
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="3" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />	
							<input type="hidden" id="numSeleccion" name="numSeleccion" size="5" />					
						</td>
					</tr>
			  	</table>
				
				</fieldset>
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	
</html>