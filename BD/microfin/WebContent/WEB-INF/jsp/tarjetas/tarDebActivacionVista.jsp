<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/tarjetas/tarDebActivacion.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebActiva">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Activaci&oacute;n de Tarjeta </legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label>Tipo Tarjeta: </label>
							</td>
							<td>
								<input type="hidden" id="tipoTarjeta" name="tipoTarjeta"/>
								<input type="radio" id="tipoTarjetaD" value="D" tabindex="1" />
								<label>Debito</label>
								<input type="radio" id="tipoTarjetaC" value="C" tabindex="2" />
								<label>Cr&eacute;dito</label>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=lblNumero>N&uacute;mero de Tarjeta:</label>
							</td>
							<td class="label">
								<input type="text" id="tarjetaDebID" name="tarjetaDebID" size="20" maxlength="16" tabindex="3" />
							</td>
							<td>
								<input type="hidden" id="fecha" name="fecha"   size="15"  readonly="true"  disabled="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for=lblcliente>Tarjetahabiente:</label>
							</td>
							<td>
								<input type="text" id="clienteID" name="clienteID" size="10" readonly="true"  disabled="true"  tabindex="4" />
								<input type="text" id="nombreCliente" name="nombreCliente" size="40" readonly="true" disabled="true" tabindex="5"/>
							</td>
							<td class="separador"></td>
							<td id="cteCorpTr" class="label">
								<label for=lblcorporativo>Corporativo (Contrato):</label>
							</td>
							<td id="cteCorpTr2">
								<input type="text" id="corpRelacionado" name="corpRelacionado" size="10" readonly="true" disabled="true" tabindex="6"/>
								<input type="text" id="nombre" name="nombre" size="35" readonly="true" disabled="true" tabindex="7"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for=lbldireccion>Direcci&oacute;n:</label>
							</td>
							<td>
								<textarea id="direccion" name="direccion" size="30"  readonly="true"  disabled="true" rows="4" cols="35" tabindex="8" >
								</textarea>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=lblFechaNac>Fecha Nacimiento:</label>
							</td>
							<td>
								<input type="text" id="fechaNac" name="fechaNac"   size="15"  readonly="true"  disabled="true"  tabindex="9" />
							</td>
					 	</tr>
						<tr>
							<td class="label">
								<label for=lblcp>C&oacute;digo&nbsp;Postal:</label>
							</td>
							<td>
								<input type="text" id="codigoPostal" name="codigoPostal"  size="30"  readonly="true"  disabled="true"  tabindex="10" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=lblTelCel>Tel.Celular:</label>
							</td>
							<td>
								<input type="text" id="telefonoCel" name="telefonoCel" size="15"  readonly="true"  disabled="true" tabindex="11"  maxlenght="15"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for=lbltelefono>Tel&eacute;fono Particular:</label>
							</td>
							<td class="label">
								<input type="text" id="telefono" name="telefono" size="15" readonly="true"  disabled="true" tabindex="12"  />
								<label>Ext.:</label>
								<input type="text" id="extTelefonoPart" name="extTelefonoPart" size="10" readonly="true"  disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=lblemail>Email:</label>
							</td>
							<td>
								<input type="text" id="email" name="email" size="30"  readonly="true"  disabled="true" tabindex="13"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for=lblrfc>RFC:</label>
							</td>
							<td>
								<input type="text" id="rfc" name="rfc" size="15" readonly="true"   disabled="true" tabindex="14" maxlenght="13" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for=lblcurp>CURP:</label>
							</td>
							<td>
								<input type="text" id="curp" name="curp" size="30"  readonly="true"  disabled="true" tabindex="15" maxlenght="18" />
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="activar" name="activar" class="submit" value="Activar" tabindex="16"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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