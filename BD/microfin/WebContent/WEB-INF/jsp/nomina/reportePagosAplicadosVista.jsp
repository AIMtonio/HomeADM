<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/actualizaEstatusEmpServicio.js"></script>

	<script type="text/javascript" src="js/nomina/reportePagosAplicados.js"></script> 
</head>
<body>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagoNominaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Pagos Aplicados</legend>
		
<table border="0" cellpadding="2" cellspacing="0" width="60%">
	<tr>
		<td>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend><label>Par&aacute;metros</label></legend>
	<table  border="0"  width="560px">
		<tr>
			<td class="label"><label for="lblfechaInicio">Fecha de Inicio: </label></td>
			<td>    			
				<input id="fechaInicio" name="fechaInicio"  size="12" tabindex="1" type="text"  esCalendario="true" />	
			</td>	
		</tr>
		<tr>
			<td nowrap="nowrap"  class="label"> 
				<label for="lblFechaFin">Fecha de Fin:</label> 
			</td>
			<td>
				<input type="text" id="fechaFin" name="fechaFin" size="12" esCalendario="true" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap"><label for="lblInstitucion">Empresa N&oacute;mina:</label></td>
			<td nowrap="nowrap" colspan="4"> 
				<input type="text" id="institNominaID"  name="institNominaID" size="12" tabindex="3" />
				<input type="text" id="nombreEmpresa" name="nombreEmpresa" size="77" disabled= "true" readonly="true" iniforma="false"/>
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" class="label"><label for="lblCliente"><s:message code="safilocale.cliente"/></label> </td>
			<td nowrap="nowrap" colspan="4">
				<input type="text" id="clienteID" name="clienteID" size="12" tabindex="4"/>  
				<input type="text" id="nombreEmpleado" name="nombreEmpleado" size="50" disabled= "true" /> 
			</td>
		</tr>
	</table>
</fieldset>
</td>  
	<td>
		<table width="150px"> 
		<tr>
			<td class="label" style="position:absolute;top:11%;">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="5" />
					<label> PDF </label>
				<br>
					<input type="radio" id="excel" name="excel" value="excel" tabindex="6" />
					<label> Excel </label>
				<br>		 	
			</fieldset>
			</td>      
		</tr>
	</table>
	</td>
   	</tr>
	</table>
		<input type="hidden" name="reporte" id="reporte" />
		<input type="hidden" id="tipoLista" name="tipoLista" />
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>
			<td align="right">
			<a id="ligaGenerar" href="reportePagosAplicados.htm" target="_blank" >  
				<input type="button" id="imprimir" name="imprimir" class="submit" value="Generar" tabindex="7"/>
			</a>
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
	<div id="Contenedor" style="display: none;"></div>
	<div id="mensaje" style="display: none;"></div>
</html>