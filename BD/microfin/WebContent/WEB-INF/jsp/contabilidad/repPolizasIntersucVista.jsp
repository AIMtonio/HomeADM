<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript"
	src="dwr/interface/tipoInstrumentosServicio.js"></script>

<script type="text/javascript"
	src="js/contabilidad/repPolizasIntersuc.js"></script>
</head>
<body>
	<br>

	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="repPolizasIntersuc" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte
					de Pólizas Intersucursales</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Parámetros</label></legend>
								<table width="100%">
									<tr>
										<td><label>Fecha Inicial:</label></td>
										<td><form:input type="text" name="fechaInicial"
												id="fechaInicial" path="fechaInicial" autocomplete="off"
												esCalendario="true" size="14" tabindex="1" /></td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td><label>Fecha Final:</label></td>
										<td><form:input type="text" name="fechaFinal"
												id="fechaFinal" path="fechaFinal" autocomplete="off"
												esCalendario="true" size="14" tabindex="2" /></td>
										<td colspan="3"></td>
									</tr>
									<tr>
										<td><label>Reporte:</label></td>
										<td><form:select id="tipoReporte" name="tipoReporte"
												path="tipoReporte" tabindex="7">
												<form:option value="0">SELECCIONAR</form:option>
												<form:option value="1">OPERACIONES EN VENTANILLA SOCIO</form:option>
												<form:option value="2">GASTOS POR COMPROBAR, ANTICIPO DE SUELDO</form:option>
												<form:option value="3">TRANSFERENCIAS CUENTAS BANCARIAS</form:option>
												<form:option value="4">FACTURAS DE PROVEEDORES</form:option>
												<form:option value="5">POLIZAS INTERSUCURSALES</form:option>
											</form:select></td>
									</tr>
									<tr>
								<td>
									<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion"
													  size="12" />							    									 			 	  
								</td>
							</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>
				<div>
					<table align="right" width="100%">
						<tr>
							<td align="right"><a id="ligaGenerar"
								 target="_blank"> 
								<input
									type="button" id="generarR" tabindex="50"
									class="submit" value="Generar" />
							</a> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							</td>
						</tr>
					</table>
				</div>
			</fieldset>
		</form:form>
	</div>

	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>

</body>
</html>