<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>	
		<script type="text/javascript" src="js/aportaciones/plazosAportaciones.js"></script>
	</head>
	<body> 
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Plazos de Aportaciones</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="plazosAportacionesBean" >
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lbltipoAportacionID">Tipo de Aportaci&oacute;n:</label>
							</td>
							<td>
								<form:input id="tipoAportacionID" name="tipoAportacionID" size='5'	path="tipoAportacionID"  autocomplete="off"/>
								<input id="descripcion" name="descripcion"  size='40' readOnly="true"/>									
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="monedaID">Moneda:</label>
							</td>
							<td>
								<input id="monedaID" name="monedaID"  size='5' readOnly="true" />									
								<input id="descripcionMoneda" name="descripcionMoneda"  size='40' readOnly="true" />									
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div id="gridPlazos" style="display: none;"/>							
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
											<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar" />
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
																	
										</td>
									</tr>
								</table>		
							</td>
						</tr>
					</table>
					<input type="hidden" size="70" name="diasInferior" id="diasInferior"/>
					<input type="hidden" size="70" name="diasSuperior" id="diasSuperior"/>					
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
	</body>
</html>