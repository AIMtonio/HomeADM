<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramCreditPaymentServicio.js"></script>
		<script type="text/javascript" src="js/soporte/paramCreditPaymentVista.js"></script>
	</head>

	<body>
		<br>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros  de Web Service/CreditPayment</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramCreditPaymentBean"  target="_blank">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<br>
						<tr>
							<td>
								<label>Tipo de Producto de Credito:</label>
							</td>
							<td>
								<select id="producCreditoID" name="producCreditoID" tabindex="1">
								</select>
							</td>
							<td class="separador"></td>
						</tr>
					</table>
					<br>

					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Par&aacute;metros</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label>Aplica en autom&aacute;tico el pago de crédito: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="pagoCredAutomSI" name="pagoCredAutomSI" path="pagoCredAutom" value="S" tabindex="2" />
									<label for="pagoCredAutomSI">Si</label>
									<form:radiobutton id="pagoCredAutomNO" name="pagoCredAutomNO" path="pagoCredAutom" value="N"  tabindex="3" />
									<label for="pagoCredAutomNO">No</label>
								</td>
							</tr>
							<tr></tr>
							<tr>
								<td class="label">
									<label>En caso de no tener exigible: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="abonoCta" name="abonoCta" path="exigible" value="A" tabindex="4"/>
									<label for="abonoCta">Abono a Cuenta</label>
									<form:radiobutton id="prepagoCred" name="prepagoCred" path="exigible" value="P"  tabindex="5" />
									<label for="prepagoCred">Prepago de Cr&eacute;dito</label>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>En caso de sobrante: </label>
								</td>
								<td class="separador"></td>
								<td class="label">
									<form:radiobutton id="sobranteprepagoCred" name="sobranteprepagoCred" path="sobrante" value="P" tabindex="6"/>
									<label for="sobranteprepagoCred">Prepago de Cr&eacute;dito</label>
									<form:radiobutton id="ahorro" name="ahorro" path="sobrante" value="A"  tabindex="7" />
									<label for="ahorro">Ahorro</label>
								</td>
							</tr>
						</table>
					</fieldset>

					<div id="aplicCobranRef" >
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Cobranza Referenciada</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label">
										<label>Aplica Cobranza Referenciada: </label>
									</td>
									<td>
										<input type="hidden" id="aplicaCobranzaRef" name="aplicaCobranzaRef"/>
										<input type="radio" id="cobranzaRefSI" name="cobranzaRefSI" value="S" tabindex="8"/>
										<label for="lbCobranzaRefSI">Si</label>
										<input type="radio" id="cobranzaRefNO" name="cobranzaRefNO" value="N" tabindex="9"/>
										<label for="lbCobranzaRefNO">No</label>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>

					<br>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Guardar" tabindex="10" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value=""/>
								<input type="hidden" id="paramCreditPaymentID" name="paramCreditPaymentID" value=""/>
							</td>
						</tr>
					</table>
			</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		</body>
		<div id="mensaje" style="display: none;"></div>
</body>
</html>