<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/regulatorios/repRegulatorioCapPorLocalidad821.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Regulatorio de Captaci&oacute;n Por Localidad (B 0821)</legend> 
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>	   	
		<td class="label" > 
	        <label for="lblNombreCliente">Fecha: </label> 
	    </td> 
	    <td> 
	       <input  type="text" id="fechaReporte" name="fechaReporte" size="12" iniForma = 'false'
	       			tabindex="1"  esCalendario = "true"/>
	    </td> 	
	    <td class="separador"></td> 		
	    <td class="separador"></td> 		
	    <td class="separador"></td> 
	    <td class="separador"></td> 		
	    <td class="separador"></td> 
	</tr>
		<tr>
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Versi&oacute;n</label></legend>
					<input type="radio" id="año13" name="año13" value="año13" checked="checked">
					<label> 2013 </label>	
					 <br>
				 	<input type="radio" id="año14" name="año14" value="año14">
					<label> 2014 </label>
			</fieldset>
			</td>
		</tr>
	<tr id="div2013">
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="excel" name="excel" value="excel" checked="checked" tabindex="2">
					<label> Excel </label>	
					<br>
				 	<input type="radio" id="csv" name="csv" value="csv">
					<label> Csv </label>	
			</fieldset>
			</td>
	</tr>
	<tr id="div2014">
		<td class="label" colspan="2">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Presentaci&oacute;n</label></legend>
				<input type="radio" id="excel2" name="excel2" value="excel2" checked="checked" tabindex="2">
				<label> Excel </label>	
				<br>
				<input type="radio" id="csv2" name="csv2" value="csv2">
				<label> Csv </label>	
		</fieldset>
		</td>
		</tr>
	<tr>
		<td class="separador"></td>
		<td colspan="5" align="right">	
			<input type="button" class="submit" id="generar" value="Generar" />	
		</td>
	</tr> 
</table>
</fieldset>      
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
