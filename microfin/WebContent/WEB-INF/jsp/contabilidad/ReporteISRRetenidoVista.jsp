<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/reporteISRRetenidoServicio.js"></script>
		<script type="text/javascript" src="js/contabilidad/reporteISRRetenido.js"></script>
		 													 
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repRegCatalogoMinimoBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">ISR Retenido</legend> 
<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
	<tr>
		<td>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Parámetros</legend>	      
			<table>		   	
				<td class="label" >
				  
			        <label for="anio">Año: </label> 
			    </td>
				<td class="separador"> </td> 
				<td class="separador"> </td>   
			    <td class="separador"> </td> 	
			    <td>
					<select id="anio" name="anio" tabindex="1">
					</select>
				</td>	
				
				<td class="separador"> </td> 
				<td class="separador"> </td> 
				<td class="separador"> </td>     
			</table>
		</fieldset>
		</td>
		<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
				<input type="radio" id="excel" name="excel" value="1" checked="checked" disable="true"><label>Excel</label>
			</fieldset>			
		</td>
	</tr>
	<tr>
		<td colspan="9" align="right">	
			<input type="button" class="submit" id="generar" value="Generar">		
		</td>
	</tr> 
</table>
</fieldset>      
</form:form>
</div>
 
</html>