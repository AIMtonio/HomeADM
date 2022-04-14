<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
		<script type="text/javascript" src="js/credito/desembolsoCredito.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Desembolso de Crédito</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="950px">
		<tr>
			<td class="label">
				<label for="credito">Número: </label>
			</td>
			<td >
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
				<input type="hidden" id="tipoDispersion" name="tipoDispersion" size="12" />

			</td>

			<td class="separador"></td>
			<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td>
			<td >
				<form:input id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="2" readOnly="true"
				disabled="true" />
				<input type="text" id="nombreCliente" name="nombreCliente" tabindex="4" readOnly="true"
				 disabled="true" size="40"/>
			</td>

		</tr>

		<tr>
			<td class="label">
			 <label for="lineaCred">Línea de Crédito: </label>
			</td>
		   <td >
				<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="10" tabindex="3"
				readOnly="true" disabled="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lineaCred">Producto de Crédito: </label>
			</td>
		   <td>
				<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" tabindex="4"
				readOnly="true" disabled="true"/>
				<input type="text" id="nombreProd" name="nombreProd" tabindex="4" readOnly="true" disabled="true"
				 size="45"/>
			</td>

		</tr>
		<tr>
			<td class="label">
			 <label for="Cuenta">Cuenta: </label>
			</td>
		   <td>
			<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="10" tabindex="5" readOnly="true"
			 disabled="true"/>

			</td>
		</tr>

	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Saldos de la Línea de Crédito</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
			<tr>
				<td class="label">
				<label for="SaldoDisponible">Saldo disponible: </label>
				</td>
			   <td>
					<input type="text" id="saldoDisponible" name="saldoDisponible" size="15" tabindex="9"
					readOnly="true" disabled="true" tabindex="11" />
				</td>
				<td class="separador"></td>
				<td class="label">
				<label for="Moneda">Saldo Deudor: </label>
				</td>
			   <td >
					<input type="text" id="saldoDeudor" name="saldoDeudor" size="15" tabindex="10"
					readOnly="true" disabled="true" tabindex="11"/>
				</td>
			</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Condiciones</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
			<tr>
				<td class="label">
				<label for="Monto">Monto: </label>
				</td>
			   <td>
					<form:input id="montoCredito" name="montoCredito" path="montoCredito" size="12"
						readOnly="true" disabled="true" esMoneda="true" tabindex="9" />
				</td>
				<td class="separador"></td>
				<td class="label">
				<label for="Moneda">Moneda: </label>
				</td>
			   <td >
					<form:input id="monedaID" name="monedaID" path="monedaID" size="3" tabindex="10" readOnly="true"
					 disabled="true"/>
					<input type="text" id="monedaDes" name="monedaDes" size="30" readOnly="true" disabled="true"
					 tabindex="11"/>

				</td>
			</tr>
			<tr>
				<td class="label">
				<label for="FechaInic">Fecha de Inicio : </label>
				</td>
			   <td >
					<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15"
					readOnly="true" disabled="true" tabindex="12"/>
				</td>
				<td class="separador"></td>
				<td class="label">
				<label for="FechaVencimiento">Fecha de Vencimiento: </label>
				</td>
			   <td>
					<form:input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="15"
					tabindex="13"  readOnly="true" disabled="true"/>
				</td>
			</tr>
			<tr>
				<td class="label">
				<label for="FactorMora">Factor Mora: </label>
				</td>
			   <td >
					<form:input id="factorMora" name="factorMora" path="factorMora" size="8" esTasa="true"
					readOnly="true" disabled="true" tabindex="14"/>
					<label for="lblveces" id="lblveces"></label>
				</td>
				<td class="separador"></td>
			</tr>
		</table>
	</fieldset>
	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Estatus</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
			<tr>
				<td class="label">
				<label for="Estatus">Estatus:</label>
				</td>
			   <td>
			   <form:select id="estatus" name="estatus" path="estatus"  tabindex="33" readOnly="true" disabled="true">
						<form:option value="I">INACTIVO</form:option>
						<form:option value="V">VIGENTE</form:option>
						<form:option value="P">PAGADO</form:option>
						<form:option value="C">CANCELADO</form:option>
						<form:option value="A">AUTORIZADO</form:option>
						<form:option value="B">VENCIDO</form:option>
						<form:option value="K">CASTIGADO</form:option>
						<form:option value="M">PROCESADO</form:option>
					</form:select>
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
			</tr>
		</table>
	</fieldset>
		<br>
	<div id="divComentarios" style="display: none;">
		 <fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend>Comentarios</legend>
			<table >
				<tr>
					<td class="label" >
						<label for="lblComentario">Comentarios: </label>
					</td>
					<td>
						<form:textarea  id="comentarioCred" name="comentarioCred" path="comentarioCred" tabindex="18" COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="false" maxlength="500"/>
					</td>
				</tr>
			</table>
		</fieldset>
	</div><br>
	<td colspan="5">
	</td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="separador">
				<span id="statusSrvHuella"></span>
			</td>
			<td colspan="4">
				<table align="right" boder='0'>
					<tr>
						<td align="right">
							<input type="submit" id="desembolsar" name="desembolsar" class="submit" value="Desembolsar" tabindex="36"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" value="solicitudCreditoID"/>
							<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="5" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
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
<html>