<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
	   <script type="text/javascript" src="js/cuentas/repRegulatorioCaptacion811.js"></script>
	      
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Regulatorio de Captaci&oacute;n Tradicional (A 0811)</legend> 
<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
	<tr>	   	
		<td class="label" > 
	        <label for="lblNombreCliente">Fecha: </label> 
	    </td> 
	    <td> 
	       <input  type="text" id="fechaReporte" name="fechaReporte" size="20" iniForma = 'false'
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
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="excel" name="excel" value="excel" checked="checked" tabindex="2">
					<label> Excel </label>	
					<br>
				 	<input type="radio" id="csv" name="csv" value="csv">
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
<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
</fieldset>      
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
