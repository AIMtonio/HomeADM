<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cartaLiquidacionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="js/credito/cartaLiquidacionControlador.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cartaLiquidacionBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cartas de liquidación</legend>
					<table border="0" width="400">
						
						<!-- CREDITO ID -->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblCrédito">Crédito: </label>
							</td>
						   	<td nowrap="nowrap">
						   		<form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="10" tabindex="1" autoComplete="off"/>
						   	</td>
						</tr>
						
						<!-- CLIENTE ID Y CLIENTE-->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblCliente:">Cliente: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="10" maxlength="10" readonly="true"/>
								<form:input type="text" id="cliente" name="cliente" path="cliente" size="40" readonly="true"/>
							</td>
						</tr>
						
						<!-- MONTO ORIGINAL -->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblMonto Original">Monto Original: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="montoOriginal" name="montoOriginal" path="montoOriginal" esMoneda="true" size="10" autoComplete="off" readonly="true"/>
							</td>
						</tr>
						
						<!-- FECHA VENCIMIENTO -->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblFecha Vencimiento">Fecha Vencimiento: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="10" tabindex="2" esCalendario="true"/>
							</td>
						</tr>
						
						<!-- INSTITUCIÓN ID E INSTITUCIÓN -->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblInstitución">Institución: </label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="10" tabindex="3" maxlength="10" autoComplete="off"/>
								<form:input type="text" id="institucion" name="institucion" path="institucion" size="40" readonly="true"/>
							</td>
						</tr>
						
						<!-- CONVENIO -->
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lblConvenio">Convenio: </label>
							</td>
							<td>
								<form:input type="text" id="convenio" name="convenio" path="convenio" size="10" tabindex="4" maxlength="10"/>
							</td>
						</tr>
					</table>
					<!-- Botones -->
					<br>
					<table align="right" border='0'>
						<tr>
							<td align="right">
								<div id="contenedorBotones">
									<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="5"/>
									<input type="button" id="reimprimir" class="submit" name="reimprimir" value="Reimprimir" tabindex="6"/>
									<a id="ligaGenerar" target="_blank"> 
										<input style="display:none;" type="button" id="imprimir" name="imprimir" value="imprimir"/>
									</a>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									<input type="hidden" id="cartaLiquidaID" name="cartaLiquidaID" />
									<input type="hidden" id="recurso" name="recurso" />
								</div>
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
</body>
<div id="mensaje" style="display: none;"></div>	
</html>