<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>      
		<script type="text/javascript" src="js/credito/repDesagregadoC0451.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Desagregado de Cartera (C-0451) </legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
						<label for="lblFecha">Fecha: </label>
					</td>
					<td >
						<input id="fecha" name="fecha" path="fecha" size="12" 
		         			tabindex="1" type="text"  esCalendario="true" />	
					</td>						
				</tr>
				<tr>
					<td class="label" colspan="2">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Versi&oacute;n</label></legend>
							<input type="radio" id="version2014" name="version" value="2014" checked="checked">
							<label> Anterior Enero 2015 </label>	
							 <br>
						 	<input type="radio" id="version2015" name="version" value="2015">
							<label> Enero 2015 </label>
					</fieldset>
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
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="2">
								<table align="right" border='0'>
									<tr>
										<td align="right"">
											<a id="ligaGenerar">
												<input type="button" id="generar" name="generar" class="submit"
												 tabindex="3" value="Generar" />
											</a>
										</td>	
									</tr>
								</table>		
							</td>
						</tr>					
					</table>
				</tr>
			</table>
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
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
</html>