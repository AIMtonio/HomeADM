<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>	
	<head>
		<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script> 
	   <script type="text/javascript" src="js/cuentas/regulatorio0815.js"></script>	      
	</head>
	   
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteRegulatorioBean"> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Regulatorio R08 (A 0815)</legend> 
				<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
					<tr>	   	
						<td class="label" > 
					        <label for="lblNombreCliente">Año: </label> 
					    </td> 
					    <td>
							<select id="anio" name="anio">
							</select>
						</td>	
						<td class="separador"> </td> 			
					    <td class="label" > 
					        <label for="lblNombreCliente">Mes: </label> 
					    </td> 					    
					   <td>
							<select id="mes" name="mes">
								<option value="1">ENERO</option>
								<option value="2">FEBRERO</option>
								<option value="3">MARZO</option>
								<option value="4">ABRIL</option>
								<option value="5">MAYO</option>
								<option value="6">JUNIO</option>
								<option value="7">JULIO</option>
								<option value="8">AGOSTO</option>
								<option value="9">SEPTIEMBRE</option>
								<option value="10">OCTUBRE</option>
								<option value="11">NOVIEMBRE</option>
								<option value="12">DICIEMBRE</option>
							</select>
						</td>			
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
						<td colspan="5" align="right">	
							<input type="button" class="submit" id="generar" value="Generar" /> 		
						</td>
					</tr> 
				</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" class="submit" />
				</fieldset>      
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
