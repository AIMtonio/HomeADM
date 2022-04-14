<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposPlanAhorroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/foliosPlanAhorroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parmetrosSisServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/planAhorro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="foliosPlanAhorroBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget-header ui-corner-all">Plan de Ahorro</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="clienteID">Cliente ID: </label>
							</td>
							<td>
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="10" tabindex="1" />
								<form:input type="text" id="nombreCliente" name="nombreCliente" path="nombreCliente" size="35" tabindex="2" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="cuentaID">Cuenta: </label>
							</td>
							<td>
								<form:input type="text" id="cuentaID" name="cuentaID" path="cuentaID" size="10" tabindex="3" />
								<form:input type="text" id="descCuenta" name="descCuenta" path="descCuenta" size="30" tabindex="4" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="planID">Plan Ahorro: </label>
							</td>
							<td>
								<form:select id="planID" name="planID" path="planID" tabindex="5">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="monto">Monto Base: </label>
							</td>
							<td>
								<form:input type="text" id="monto" name="monto" path="monto" size="10" tabindex="6" esmoneda="true" style="text-align: right"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaMeta">Fecha Meta: </label>
							</td>
							<td>
								<form:input type="text" id="fechaMeta" name="fechaMeta" path="fechaMeta" size="10" tabindex="7" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="saldoActual">Saldo Actual: </label>
							</td>
							<td>
								<form:input type="text" id="saldoActual" name="saldoActual" path="saldoActual" size="10" tabindex="8" style="text-align: right"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="serie">No. Folios: </label>
							</td>
							<td>
								<form:input type="text" id="serie" name="serie" path="serie" size="10" tabindex="9" />
								<label for="montoDep">Monto: </label>
								<form:input type="text" id="montoDep" name="montoDep" path="montoDep" size="10" tabindex="10" esmoneda="true" style="text-align: right" />
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="11" />
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
											<input id="numeroTransaccion" name="numeroTransaccion" size="12" type="hidden" readOnly="true" disabled="true" />	
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