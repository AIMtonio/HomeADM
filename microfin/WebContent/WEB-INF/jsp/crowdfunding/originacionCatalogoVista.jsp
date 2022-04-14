<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="js/crowdfunding/consultaOriginacion.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCreditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Detalle Inversiones</legend>
	<table border="0" width="950px">
		<tr>
			<td class="label">
				<label for="credito">Cr&eacute;dito: </label>
			</td>
			<td >
				<form:input id="creditoID" name="creditoID" path="creditoID" size="16" tabindex="1"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblSolicitud">Solicitud: </label>
			</td>
			<td >
				<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="16" readOnly="true" disabled="true" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="Cliente">Acreditado: </label>
			</td>
			<td >
				<form:input id="clienteID" name="clienteID" path="clienteID" size="16" tabindex="3"  readOnly="true"
				 disabled="true"/>
				<input type="text" id="nombreCliente" name="nombreCliente" tabindex="4" readOnly="true"
				 disabled="true" size="50"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Monto">Monto: </label>
			</td>
			<td>
				<form:input id="montoAutorizado" name="montoAutorizado" path="montoAutorizado" size="16" esMoneda="true" tabindex="6" disabled="true" style="text-align: right;"/>
			</td>
		</tr>
		<tr>
			<td class="label">
			<label for="lblEstatus">Estatus: </label>
			</td>
			<td >
				<form:select id="estatus" name="estatus" path="estatus"  tabindex="5" disabled="true">
				<!-- ESTATUS DE LA SOLICITUD
					<form:option value="I">EN INVESTIGACI&Oacute;N</form:option>
					<form:option value="V">EVALUADA</form:option>
					<form:option value="F">EN PROCESO DE FONDEO</form:option>
					<form:option value="A">AUTORIZADA</form:option>
					<form:option value="D">DESEMBOLSADA</form:option>
				-->
					<form:option value="I">INACTIVO</form:option>
					<form:option value="A">AUTORIZADO</form:option>
					<form:option value="V">VIGENTE</form:option>
					<form:option value="P">PAGADO</form:option>
					<form:option value="C">CANCELADO</form:option>
					<form:option value="B">VENCIDO</form:option>
					<form:option value="K">CASTIGADO</form:option>
					<form:option value="S">SUSPENDIDO</form:option>
				</form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="FechaInic">Fecha de Inicio : </label>
			</td>
			<td >
				<form:input id="fechaIniCre" name="fechaIniCre" path="fechaIniCre" size="16"
			  tabindex="7" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="produc">Producto: </label>
			</td>
			<td >
				<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="16"
				 tabindex="9" readOnly="true"
				disabled="true" />
				<input type="text" id="descripProducto" name="descripProducto" tabindex="10" readOnly="true"
				 disabled="true" size="40"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="FechaVencimiento">Fecha de Vencimiento: </label>
			</td>
			<td>
				<form:input id="fechaVenCre" name="fechaVenCre" path="fechaVenCre" size="16" tabindex="8"  disabled="true"/>
			</td>
		</tr>
	</table>
		<br>
		<input id="numFondKubo" name="numFondKubo" size="20" tabindex="5" type="hidden"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td colspan="4">
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
				</td>
			</tr>
			<tr>
				<td align="right" colspan="4">
					<a id="opcionM" href="javascript: " onclick="$('#Contenedor').load('consultaCreditos.htm');consultaSesion();">
						<input type="button" id="enviar" name="enviar" class="submit" tabindex="11" value="Ir a Información Créditos"   />
					</a>
					<input type="button" id="reportePdf" name="reportePdf" class="submit" tabindex="11" value="Genera PDF"   />
				</td>
			</tr>
		</table>
		<div id="gridInversionistas" style="display: none;">
		</div>
		<div id="gridCalendarioInv" style="display: none;">
		</div>
		<div id="gridDetalleMovFondeo" style="display: none;">
		</div>
		<div id="gridSaldosYpagos" style="display: none;">
		</div>
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>