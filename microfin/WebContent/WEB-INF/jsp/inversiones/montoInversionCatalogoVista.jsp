<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>	
	<script type="text/javascript" src="js/inversiones/montosInversion.js"></script>
</head>

<body>
	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Montos de Inversión</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="montoInversionBean" >
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="tipoInversionID">Tipo Inversión:</label>
						</td>
						<td>
							<form:input id="tipoInversionID" name="tipoInversionID" size='10'
									path="tipoInversionID"  autocomplete="off"/>
							<input id="descripcion" name="descripcion"  size='50' readOnly="true" disabled="true" />									
						</td>
					</tr>
					
					<tr>
						<td class="label">
							<label for="monedaID">Moneda:</label>
						</td>
						<td>
							<input id="monedaID" name="monedaID"  size='10' readOnly="true" disabled="true" />									
							<input id="descripcionMoneda" name="descripcionMoneda"  size='50' readOnly="true" disabled="true" />									
						</td>
					</tr>
					
					<tr>
						<td colspan="2">
							<div id="gridMontos" style="display: none;"/>							
						</td>
					</tr>										
					<tr>		
						<td colspan="2">
							<table align="left" border='0'>
								<tr>
									<td width="350px">
										&nbsp;					
									</td>								
									<td align="right">
										<input type="submit" id="agregaInv" name="agregaInv" class="submit" value="Grabar" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
																
									</td>
								</tr>
							</table>		
						</td>
					</tr>
				</table>
			<input type="hidden" size="70" name="montosInferior" id="montosInferior"/>
			<input type="hidden" size="70" name="montosSuperior" id="montosSuperior"/>
			<input type="hidden" size = "5" id="estatusTipoInver" name="estatusTipoInver"/>
							
		</form:form>
		</fieldset>
	</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;">
</div>
</body>
</html>