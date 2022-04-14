<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	
	<script type="text/javascript" src="dwr/interface/repExcepcionesInverServicio.js"></script>		
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/repExcepcioenesInver.js"></script>
</head>
<body>
<br>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repExcepciones">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Excepciones de Inversión</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all" >
						<legend><label>Parámetros</label></legend>				
						<table width="100%">
							<tr>
								<td>
									<label>Fecha Inicial:</label>
								</td>
								<td><form:input type="text" name="fechaInicial" id="fechaInicial" path="fechaInicial"
													 autocomplete="off" esCalendario="true" size="14" tabindex="1" />						
								</td>
								<td colspan="3"></td>
							</tr>				
							<tr>
								<td>
									<label>Fecha Final:</label>
								</td>
								<td><form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal"
													 autocomplete="off" esCalendario="true" size="14" tabindex="2"/>
								</td>
								<td colspan="3"></td>
							</tr>												
							<tr>
								
							</tr>				
						</table>
						</fieldset>
					</td>
					<tr>
					<td>
						<br>
						<br>
						<table width="110px" >
								<tr>
									<td class="label" style="position: absolute; top:62%;">								
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><label>Presentación: </label></legend>
											<input type="radio" id="pdf" name="tipoReporte" value="pdf" tabindex="13" checked/>
											<label>	PDF </label>																	
										</fieldset>
									</td>
								</tr>
						</table>
					</td>					
				</tr>						
			</table>
			<div>
			<table align="right" width="100%">
					<tr>
						<td align="right">
							<a id="ligaGenerar" href="repExcepcionesInversion.htm" target="_blank" > 
							<button id="generar" name="generar" tabindex="50" class="submit" >Generar </button>
							</a>	
						</td>
					</tr>
			</table>
		</div>		
		</fieldset>			
	</form:form>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>