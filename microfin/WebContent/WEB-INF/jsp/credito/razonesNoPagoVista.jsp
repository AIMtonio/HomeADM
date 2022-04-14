<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<!--<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="js/pld/reporteOpFraccionadas.js"></script>-->
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
	 <script type="text/javascript" src="js/credito/razonesNoPago.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="razonesNoPagoBean" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Razones de No Pago</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="fechaInicio">Fecha Inicio: </label>
						</td>
						<td>
							<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" autocomplete="off" size="12" tabindex="1" esCalendario="true"/>
						</td>
					
					</tr>
					<tr>
						<td class="label">
							<label for="fechaFin">Fecha Fin: </label>
						</td>
						<td>
							<form:input type="text" name="fechaFin" id="fechaFin" path="fechaFin" autocomplete="off" size="12" tabindex="2" esCalendario="true"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="razonNoPago">Razon de No Pago: </label>
						</td>
						<td>
							<!-- <form:input type="text" name="fechaFin" id="fechaFin" path="fechaFin" autocomplete="off" size="12" tabindex="2" esCalendario="true"/>-->
							<form:select id="razonID" name="razonID" path="razonID" tabindex="3">
								<form:option value="0">TODAS</form:option>
							</form:select>
						</td>
						
					</tr>
					<tr>
						<td class="label">
							<label for="creditoID">Credito: </label>
						</td>
						<td>
							<form:input type="text" name="creditoID" id="creditoID" path="creditoID" autocomplete="off" size="28" tabindex="4"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="clienteID">Cliente: </label>
						</td>
						<td>
							<form:input type="text" name="clienteID" id="clienteID" path="clienteID" autocomplete="off" size="8" tabindex="5"/>
							<input type="text" id="nombreCliente" name="nombreCliente" size="20" tabindex="6" disabled= "disabled" readOnly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="sucursalID">Sucursal: </label>
						</td>
						<td>
							<form:input type="text" name="sucursalID" id="sucursalID" path="sucursalID" autocomplete="off" size="8" tabindex="7"/>
							<input type="text" id="nombreSucursal" name="nombreSucursal" size="20" tabindex="8" disabled= "disabled" readOnly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="promotorID">Promotor: </label>
						</td>
						<td>
							<form:input type="text" name="promotorID" id="promotorID" path="promotorID" autocomplete="off" size="8" tabindex="9"/>
							<input type="text" id="nombrePromotor" name="nombrePromotor" size="20" tabindex="10" disabled= "disabled" readOnly="readonly" />
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<a id="ligaGenerar" href="ReporteRazonNoPago.htm" target="_blank" > 
											<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="8"/>
										</a>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>

	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
</html>