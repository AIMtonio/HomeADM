<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	

	  <script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/generaDomiciliacionPagosServicio.js"></script> 
		      	
      <script type="text/javascript" src="js/nomina/generaDomiciliacionPagos.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="generaDomiciliacionPagosBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Genera Layout Domiciliaci&oacute;n Pagos</legend>
		
			<table border="0" width="100%">
			  <tr>
			  	<td class="label" nowrap="nowrap">
					<label for="lblEsNomina">Es N&oacute;mina:</label>
				</td>
				<td>
					<form:radiobutton id="esNominaSI" name="esNomina" path="esNomina" value="S" tabindex="1" />
						<label>Si</label>
						<form:radiobutton id="esNominaNO" name="esNomina" path="esNomina" value="N" tabindex="2"/>
						<label>No</label>
				</td>
			  </tr>
			  <tr>
				<td class="label" nowrap="nowrap" id = "nomina">
					<label for="lblInstitNominaID">Empresa N&oacute;mina:</label>
				</td>
				<td>
					<form:input id="institNominaID" name="institNominaID" path="institNominaID" type="text" size="12" tabindex="3" maxlength="13" autocomplete="off"/>
					<input id="nombreEmpresa" name="nombreEmpresa" size="50" readonly="true">
				</td>	
			  </tr>
			  <tr>
				<td class="label" nowrap="nowrap" id="convenio">
					<label for="lblConvenioID">No. Convenio:</label>
				</td>
				<td>
					<form:select id="convenioNominaID" name="convenioNominaID" path="convenioNominaID" tabindex="4">
						<form:option value="0">SELECCIONAR</form:option> 
					</form:select>
				</td>		
		  	  </tr>
		  	  <tr>
				<td class="label" nowrap="nowrap">
					<label for="lblClienteID">Cliente:</label>
				</td>
				<td>
					<form:input id="clienteID" name="clienteID" path="clienteID" type="text" size="12" tabindex="5" maxlength="13" autocomplete="off"/>
					<input id="nombreCliente" name="nombreCliente" size="50" readonly="true">
				</td>	
			  </tr>
			  <tr>
				<td class="label" nowrap="nowrap">
					<label for="lblFrecuencia">Frecuencia:</label>
				</td>
				<td>
					<form:select id="frecuencia" name="frecuencia" path="frecuencia" tabindex="6">
						<form:option value="">TODAS</form:option>  
						<form:option value="S">SEMANAL</form:option> 
				     	<form:option value="D">DECENAL</form:option> 
			     		<form:option value="C">CATORCENAL</form:option> 
						<form:option value="Q">QUINCENAL</form:option> 
						<form:option value="M">MENSUAL</form:option> 
						<form:option value="B">BIMESTRAL</form:option> 
						<form:option value="T">TRIMESTRAL</form:option> 
						<form:option value="R">TETRAMESTRAL</form:option> 
						<form:option value="E">SEMESTRAL</form:option> 
						<form:option value="A">ANUAL</form:option> 
						<form:option value="P">PERIODO</form:option> 
						<form:option value="U">PAGO &Uacute;NICO</form:option> 
						<form:option value="L">LIBRE</form:option> 
					</form:select>
				</td>		
		  	  </tr>
		  	  <tr>
				<td class="label" nowrap="nowrap">
					<label for="lblFolioID">Folio:</label>
				</td>
				<td>
					<form:input id="folioID" name="folioID" path="folioID" type="text" size="12" tabindex="7" maxlength="13" autocomplete="off"/>
					<input type="hidden" id="fechaSistema" name="fechaSistema" />						
				</td>	
			  </tr>
			</table>
			<table border="0" width="20%">
			  <tr>
			  	<td align="left">
			  	<input type="button" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="8" />
			  	</td>
			  </tr> 
			</table> 
			<table border="0" width="90%">
			  <tr id ="trBuscar">
			  	<td class="label" nowrap="nowrap">
					<label>Buscar:</label>
				</td>
				<td>
					<form:input id="busqueda" name="busqueda" path="busqueda" type="text" size="30" tabindex="9" maxlength="50" autocomplete="off"/>
					<input type="button" id="buscar" name="buscar" class="submit" value="Buscar" tabindex="10" />
				</td>	
			  </tr> 
			</table>  
			<div id="gridGeneraDomicialiacionPagos"  style="display:none" ></div>
		  	
		  	<table border="0" width="100%">
				<tr id = "trGenerar">
					<td align="right">
						<input type="button" id="generarExcel" name="generarExcel" class="submit" value="Generar Excel" tabindex="100" />
						<input type="submit" id="generarLayout" name="generarLayout" class="submit" value="Generar Layout" tabindex="101" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="numTransaccion" name="numTransaccion" />
						<input type="hidden" id="tipoReporte" name="tipoReporte" />
						<input type="hidden" id="tipoLista" name="tipoLista" />						
					</td>
				</tr>
		  	</table> 
		  	
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