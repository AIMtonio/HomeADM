<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>		
	<script type="text/javascript" src="js/inversiones/repRetensionISR.js"></script>
</head>
<body>
<br>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repRetensionISR"  target="_blank">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de ISR Retenido de Inversiones</legend>
		
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
								<td>
									<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion"
													  size="12" />
							    	<form:input type="hidden" name="nombreUsuario" id="nombreUsuario" path="nombreUsuario"
													  size="12" />
								 	<form:input type="hidden" name="fechaEmision" id="fechaEmision" path="fechaEmision"
													  size="12" />										 			 	  
								</td>
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
											<br>
											<input type="radio" id="excel" name="tipoReporte"  tabindex="12" />
											<label> Excel </label>																			
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
							<button id="generar" name="generar" tabindex="50" class="submit" >Generar </button>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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