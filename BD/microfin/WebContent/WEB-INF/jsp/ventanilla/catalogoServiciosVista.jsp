<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>

<script type="text/javascript"
	src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript"
	src="dwr/interface/conceptoContableServicio.js"></script>
<script type="text/javascript"
	src="dwr/interface/cuentasContablesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catalogoServicios.js"></script>
<script type="text/javascript" src="js/ventanilla/catalogoServicios.js"></script>
</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="catalogoServBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Catálogo
					de Servicios</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"><label for="lblNúmero">Número: </label></td>
						<td><form:input id="catalogoServID" name="catalogoServID"
								path="catalogoServID" size="6" tabindex="1" /></td>
						<td class="separador"></td>
					</tr>

					<tr>
						<td class="label"><label for=lblTercero>Proporcionado
								por un Tercero:</label></td>
						<td><form:radiobutton id="origen1" name="origen"
								path="origen" value="T" tabindex="2" checked="checked" /> <label
							for="origen1">Si</label> <form:radiobutton id="origen2"
								name="origen" path="origen" value="I" tabindex="3" /> <label
							for="origen2">No</label></td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"><label for="lblNombre">Nombre
								Servicio: </label></td>
						<td><form:input id="nombreServicio" name="nombreServicio"
								path="nombreServicio" size="50" tabindex="4"
								onblur="ponerMayusculas(this)" /></td>
						<td class="separador"></td>
					</tr>


					<!-- 	<table>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend> </legend>
		<table> -->
					<tr>
						<td class="label"><label for="lblRazónSocial">Razón
								Social: </label></td>
						<td><input id="razonSocial" name="razonSocial"
							path="razonSocial" size="50" tabindex="5" type="text"
							onblur="ponerMayusculas(this)" /></td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"><label for="lblDireccion">Dirección:
						</label></td>
						<td><form:textarea id="direccion" name="direccion"
								path="direccion" tabindex="6" cols="50" rows="2" maxlength="500"
								onblur="ponerMayusculas(this)" /></td>
						<td class="separador"></td>
					</tr>
					<tr id="trCuentaPagarProveedor">
						<td class="label"><label for="lblCtaPagarProvedor">Cta.
								Contable por Pagar Proveedor: </label></td>
						<td><form:input id="ctaPagarProv" name="ctaPagarProv"
								path="ctaPagarProv" size="35" tabindex="7" maxlength="25" /> <input
							id="desCtaPagarProv" name="desCtaPagarProv" size="50" type="text"
							readonly="true" disabled="true" /></td>
						<td class="separador"></td>
					</tr>
					<tr id="trPagoAutomatico">
						<td class="label"><label for=lblPagoAutomatico>Pago
								Automático:</label></td>
						<td><form:radiobutton id="pagoAutomatico1"
								name="pagoAutomatico" path="pagoAutomatico" value="S"
								tabindex="8" /> <label for="pagoAutomatico1">Si</label> <form:radiobutton
								id="pagoAutomatico2" name="pagoAutomatico" path="pagoAutomatico"
								value="N" tabindex="9" checked="checked" /> <label
							for="pagoAutomatico2">No</label></td>
						<td class="separador"></td>
					</tr>
					<tr id="trCuentaClabe">
						<td class="label"><label for="lblcuentaClabe">Cuenta
								Clabe: </label></td>
						<td><form:input id="cuentaClabe" name="cuentaClabe"
								path="cuentaClabe" size="50" tabindex="10" maxlength="18" /></td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"><label for=lblRequiereCliente>Requiere
								Cliente:</label></td>
						<td><form:radiobutton id="requiereCliente1"
								name="requiereCliente" path="requiereCliente" value="S"
								tabindex="11" /> <label for="requiereCliente1">Si</label> <form:radiobutton
								id="requiereCliente2" name="requiereCliente"
								path="requiereCliente" value="N" tabindex="12" checked="checked" />
							<label for="requiereCliente2">No</label></td>
						<td class="separador"></td>
					</tr>
					<tr id="trRequiereCredito">
						<td class="label"><label for=lblRequiereCredito>Requiere
								Crédito: </label></td>
						<td><form:radiobutton id="requiereCredito1"
								name="requiereCredito" path="requiereCredito" value="S"
								tabindex="13" /> <label for="requiereCredito1">Si</label> <form:radiobutton
								id="requiereCredito2" name="requiereCredito"
								path="requiereCredito" value="N" tabindex="14" checked="checked" />
							<label for="requiereCredito2">No</label></td>
						<td class="separador"></td>
					</tr>
					<tr id="trVentanilla">
						<td class="label"><label for=lblVentanilla>Ventanilla:
						</label></td>
						<td><form:radiobutton id="ventanilla1" name="ventanilla1"
								path="ventanilla" value="S" tabindex="15" /> <label
							for="ventanilla1">Si</label> <form:radiobutton id="ventanilla2"
								name="ventanilla2" path="ventanilla" value="N" tabindex="16"
								checked="checked" /> <label for="ventanilla2">No</label></td>
					</tr>
					<tr id="trBancaElec">
						<td class="label"><label for=lblBancaElec>Banca
								Electrónica: </label></td>
						<td><form:radiobutton id="bancaElect1" name="bancaElect"
								path="bancaElect" value="S" tabindex="17" /> <label
							for="bancaElect1">Si</label> <form:radiobutton id="bancaElect2"
								name="bancaElect" path="bancaElect" value="N" tabindex="18"
								checked="checked" /> <label for="bancaElect2">No</label></td>
					</tr>
					<tr id="trBancaMovil">
						<td class="label"><label for=lblBancaMovil>Banca
								Móvil: </label></td>
						<td><form:radiobutton id="bancaMovil1" name="bancaMovil1"
								path="bancaMovil" value="S" tabindex="19"
								 /> <label for="bancaMovil1">Si</label>
							<form:radiobutton id="bancaMovil2" name="bancaMovil1"
								path="bancaMovil" value="N" tabindex="20" checked="checked" /> <label
							for="bancaMovil2">No</label></td>
					</tr>
					<tr id="trEstatus">
						<td class="label" nowrap="nowrap">
							<label for="estatus">Estatus</label>
						</td>	
						<td nowrap="nowrap">
							<form:select id="estatus" name="estatus" path="estatus" tabindex="21">
								<form:option value="A">ACTIVO</form:option>
							   	<form:option value="I">INACTIVO</form:option>
							</form:select>
						</td>	
					</tr>
					<tr id="trServTercerosID">
						<td><label for="numServProve">Número de Servicio del Proveedor:</label></td>
						<td><form:input type="text" id="numServProve" name="numServProve" path="numServProve" size="35" maxlength="10" />
						</td>
					</tr>
					<tr id="trcentroCostos">
						<td class="label"><label>Nomenclatura Centro de
								Costos:</label></td>
						<td><form:input id="centroCostos" name="centroCostos"
								path="centroCostos" size="25" tabindex="21" maxlength="30"
								onblur="ponerMayusculas(this)" /> <a href="javaScript:"
							onClick="ayuda();"><img src="images/help-icon.gif"></a></td>
					</tr>
				</table>
				<!-- </fieldset> -->
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all"
					id="fielsetComision">
					<legend> Comisiones</legend>
					<table>
						<tr>
							<td class="label"><label for="lblComision">Cobra
									Comisión: </label></td>

							<td><form:radiobutton id="cobraComision1"
									name="cobraComision" path="cobraComision" value="S"
									tabindex="22" checked="checked" /> <label
								for="lblcobraComision1">Si</label> <form:radiobutton
									id="cobraComision2" name="cobraComision" path="cobraComision"
									value="N" tabindex="23" /> <label for="lblcobraComision2">No</label>
							</td>
							<td class="separador"></td>
						</tr>
						<tr id="trMontoComision">
							<td class="label"><label for="lblMontoComision">Monto
									Comisión: </label></td>
							<td><form:input id="montoComision" name="montoComision"
									path="montoComision" size="15" tabindex="24" esMoneda="true" />
							</td>
							<td class="separador"></td>
						</tr>
						<tr id="trCuentaComision">
							<td class="label"><label for="lblCuentaContable">Cta.
									Contable Ingreso por Comisión: </label></td>
							<td><form:input id="ctaContaCom" name="ctaContaCom"
									path="ctaContaCom" size="35" tabindex="25" maxlength="25" />
								<input id="desCtaContaCom" name="desCtaContaCom" size="60"
								type="text" readonly="true" disabled="true" /></td>
							<td class="separador"></td>
						</tr>
						<tr id="trCuentaIVAComision">
							<td class="label"><label for="lblCuentaContableIVACOM">Cta.
									Contable IVA Comisión: </label></td>
							<td><form:input id="ctaContaIVACom" name="ctaContaIVACom"
									path="ctaContaIVACom" size="35" tabindex="26" maxlength="25" />
								<input id="desCtaContaIVACom" name="desCtaContaIVACom" size="60"
								type="text" readonly="true" disabled="true" /></td>
							<td class="separador"></td>
						</tr>


					</table>
				</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all"
					id="fielsetSevInterno" style="display: none;">
					<legend>Características </legend>
					<table>
						<tr>
							<td class="label"><label for="lblmontoServicio">Monto
									del Servicio: </label></td>
							<td><form:input id="montoServicio" name="montoServicio"
									path="montoServicio" size="15" tabindex="27" esMoneda="true" />
							<td></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label"><label for="lblIngresoServicio">Cta.
									Contable Ingreso por Servicio: </label></td>
							<td><form:input id="ctaContaServ" name="ctaContaServ"
									path="ctaContaServ" size="35" tabindex="28" maxlength="25" />
								<input id="desCtaContaServ" name="desCtaContaServ" size="60"
								type="text" readonly="true" disabled="true" /></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label"><label for="lblctaContaIVAServ">Cta.
									Contable IVA Servicio: </label></td>
							<td><form:input id="ctaContaIVAServ" name="ctaContaIVAServ"
									path="ctaContaIVAServ" size="19" tabindex="32" maxlength="25" />
								<input id="desCtaContaIVAServ" name="desCtaContaCom" size="60"
								type="text" readonly="true" disabled="true" /></td>
							<td class="separador"></td>
						</tr>

					</table>
				</fieldset>

				<br>
			</fieldset>

			<table align="right">
				<tr>
					<td align="right"><input type="submit" id="agregar"
						name="agregar" class="submit" value="Agregar" tabindex="30" /> <input
						type="submit" id="modificar" name="modificar" class="submit"
						value="Modificar" tabindex="31" /> <input type="hidden"
						id="tipoTransaccion" name="tipoTransaccion" /></td>
				</tr>
			</table>

		</form:form>
	</div>

	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>

</body>
<div id="mensaje" style="display: none;"></div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento" />
</div>
</html>