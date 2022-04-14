<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
			<script type="text/javascript" src="dwr/interface/reportesPATMIRServicio.js"></script>						      
	    	<script type="text/javascript" src="js/cliente/reportesPATMIR.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="PATMIRRep">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reportes PATMIR</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="400px">
			<tr> <td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Parámetros</label></legend>    
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
				<td class="label">
						<label for="lbtipoRep">Tipo:		</label>
				</td>
				<td>
						<form:select id="tipoRep" name="tipoRep" path="tipoRep" tabindex="1">
						<form:option value="1">SOCIO</form:option>						
					    <form:option value="2">MENORES</form:option>
					   
						</form:select>
					</td>
			</tr>
		
			<tr id="filaSocio">
				<td class="label">
						<label for="lbtipoReporte">Reporte:		</label>
				</td>
				<td>
						<form:select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="1">
						<form:option value="">SELECCIONAR</form:option>
						<form:option value="1">GENERAL</form:option> 
					    <form:option value="2">PARTE SOCIAL</form:option>
					    <form:option value="3">CREDITOS</form:option>
					    <form:option value="4">AHORROS</form:option>
					    <form:option value="5">BAJAS</form:option>
						</form:select>
					</td>
			</tr>
			<tr id="filaMenores">
				<td class="label">
						<label for="lbtipoReporte2">Reporte:		</label>
				</td>
				<td>
						<form:select id="tipoRepMenores" name="tipoRepMenores" path="tipoRepMenores" tabindex="1">
						<form:option value="">SELECCIONAR</form:option>
						<form:option value="6">GENERAL</form:option> 
					    <form:option value="7">ALTAS</form:option>					   
					    <form:option value="8">AHORROS</form:option>
					    <form:option value="9">BAJAS</form:option>
						</form:select>
					</td>
			</tr>
			<tr>
					<td class="label">
						<label for="lbfechaReporte">Fecha de Corte:		</label>
				</td>
				<td>
						<form:input id="fechaReporte" name="fechaReporte" path="fechaReporte" size="20" tabindex="2" esCalendario="true"/>
				</td>	
			</tr>
		</table>
		</fieldset>
		</td></tr></table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">					
				<tr>
					<td colspan="4">
						<table align="right" border='0'>
							<tr>
								<td align="right">
									<a id="ligaGenerar" target="_blank">
									<input type="button" id="genera" name="genera" class="submit" value="Generar"  tabindex="3"/>
									</a>
									<imput type="hiden" id="socio_cli">									
								</td>
							</tr>							
						</table>		
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