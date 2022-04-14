<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosNominaServicio.js"></script>
		<script type="text/javascript" src="js/nomina/calendarioIngresos.js"></script> 

	</head>
<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="calendarioIngresosBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Alta de Calendarios Instituci&oacute;n</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend>Calendario de Ingresos</legend>
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
						<tr>
							<td class="label">
								<label>Año:</label>
							</td>
							<td>
								<form:select id="anio" name="anio" path="anio" tabindex="3">
									<form:option value="0">SELECCIONAR</form:option> 
								</form:select>
							</td>	
						</tr>		
						
						<tr>
							<td class="label">
								<label>Estatus:</label>
							</td>
							<td>
							<form:select id="estatus" name="estatus" path="estatus" tabindex="4" disabled = "true">
									<form:option value="R">REGISTRADO</form:option> 
									<form:option value="A">AUTORIZADO</form:option>
									<form:option value="D">DESAUTORIZADO</form:option>  
							</form:select>
							</td>	
						</tr>	
				</table>
				
					<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
					<table >  
					<legend >Detalle</legend>       
					<input type="button" id="agregarInf" name="agregarInf" value="Agregar" class="botonGral" tabindex="5"  onClick="agregarNuevoRegistro()"/> 
					<div id="gridCalendarioIngresos"  style="display:none" >
					</div>
					<table align="right" > 
						<tr >	
							<td >
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="11"  />
						<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="12" />
						<input type="submit" id="desautorizar" name="desautorizar" class="submit" value="Desautorizar" tabindex="13" />
							</td>
						</tr>
					</table > 
					</table>
					</fieldset> 
				
			    
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
				<input type="hidden" id="usuarioID" name="usuarioID" size="12"/>
				<input type="hidden" id="reportaIncidencia"/>
			
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
	<div id="elementoLista"/>
</div>	
</html>