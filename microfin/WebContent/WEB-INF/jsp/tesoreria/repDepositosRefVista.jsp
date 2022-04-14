<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoInstrumentosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	
	<script type="text/javascript" src="js/tesoreria/repDepositosref.js"></script>
</head>
<body>
<br>

<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repDepositosRef"  target="_blank">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Depósitos Referenciados</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">  
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
									<label>Institución:</label>
								</td>
								<td><form:input type="text" name="institucionID" id="institucionID" path="institucionID" autocomplete="off"
													  size="12" tabindex="3" />
									<form:input type="text" name="desnombreInstitucion" id="desnombreInstitucion" path="desnombreInstitucion" size="40" disabled="true" tabindex="3" />
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Cuenta Bancaria:</label>
								</td>
								<td><form:input type="text" name="cuentaBancaria" id="cuentaBancaria" path="cuentaBancaria" autocomplete="off" size="40" tabindex="4" />					
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Cliente:</label>
								</td>
								<td><form:input type="text" name="clienteID" id="clienteID" path="clienteID" autocomplete="off" size="12" tabindex="5" />
									<form:input type="text" name="nombreCliente" id="nombreCliente" path="nombreCliente" autocomplete="off" size="40" tabindex="5" disabled="true" readonly="true"/>
													  
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td>
									<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="6">
										<form:option value="0">TODAS</form:option>
									</form:select>											
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Estado:</label>
								</td>
								<td>
									<form:select id="estado" name="estado" path="estado" tabindex="7">
										<form:option value="0">TODOS</form:option>
										<form:option value="1">APLICADOS</form:option>
										<form:option value="2">NO APLICADOS</form:option>
									</form:select>
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
					<td>
						<br>
						<table width="110px" >
								<tr>
									<td class="label" style="position: absolute; top:12%;">								
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