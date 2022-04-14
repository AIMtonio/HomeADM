<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/operacionesCapitalNetoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
<script type="text/javascript" src="js/cliente/operacionesCapitalNetoVista.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operacionesCapitalNetoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n Operaci&oacute;n Capital Neto</legend>
				<table border="0" width="960px">
					<tr>
						<td class="label"><label for="lblpantallaOrigen">Proceso: </label></td>
						<td><select id="pantallaOrigen" name="pantallaOrigen" tabIndex="1">
								<option value="">SELECCIONAR</option>
								<option value="AS">SOLICITUD DE CREDITO</option>
								<option value="AI">INVERSIÓN</option>
								<option value="AC">CEDES</option>
						</select></td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"><label for="operacionID">Operaci&oacute;n:</label></td>
						<td nowrap="nowrap">
							<input type="text" id="operacionID" name="operacionID" size="16" tabIndex="2"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="fechaOperacion">Fecha Operaci&oacute;n: </label></td>

						<td nowrap="nowrap">
							<input id="fechaOperacion" name="fechaOperacion" size="12" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>

					<tr>
						<td class="label"><label for="clienteID"><s:message code="safilocale.cliente" />: </label></td>
						<td nowrap="nowrap">
							<input id="clienteID" name="clienteID" size="12" type="text" readOnly="true" disabled="true" />
							<input id="nombreCompleto" name="nombreCompleto" size="40" type="text" readOnly="true" disabled="true" />
						</td>
						<td class="separador"></td>
						<td class="label"><label for="productoID">Producto: </label></td>
						<td nowrap="nowrap">
							<input id="productoID" name="productoID" size="12" type="text" readOnly="true" disabled="true" />
							<input id="desProducto" name="desProducto" size="40" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>

					<tr>
						<td class="label"><label for="sucursalID">Sucursal: </label></td>
						<td nowrap="nowrap">
							<input id="sucursalID" name="sucursalID" size="12" type="text" readOnly="true" disabled="true" />
							<input id="nombreSucursal" name="nombreSucursal" size="40" type="text" readOnly="true" disabled="true" />
						</td>
						<td class="separador"></td>
						<td class="label"><label for="instrumentoID">Instrumento: </label></td>
						<td nowrap="nowrap">
							<input id="instrumentoID" name="instrumentoID" size="20" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>

					<tr>
						<td class="label"><label for="capitalNeto">Capital Neto: </label></td>
						<td nowrap="nowrap">
							<input id="capitalNeto" name="capitalNeto" size="20" type="text" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="porcentaje">Porcentaje: </label></td>
						<td nowrap="nowrap">
							<input id="porcentaje" name="porcentaje" size="20" type="text" readOnly="true" disabled="true" style="text-align: right"/>
						</td>
					</tr>

					<tr>
						<td class="label"><label for="montoOper">Monto Operaci&oacute;n: </label></td>
						<td nowrap="nowrap">
							<input id="montoOper" name="montoOper" size="20" type="text" readOnly="true" disabled="true" esmoneda="true" style="text-align: right"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="estatusOper">Estatus: </label></td>
						<td nowrap="nowrap">
							<input id="estatusOper" name="estatusOper" size="20" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>

					<tr>
						<td class="label"><label for="comentario">Comentarios Autorizaci&oacute;n: </label></td>
						<td nowrap="nowrap">
							<textarea id="comentario" name="comentario" cols="52" rows="2" tabindex="3" maxlength="1000"></textarea>
						</td>

					</tr>

				</table>

				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
					<tr>
						<td align="right">
							<input type="submit" id="autoriza" name="autoriza" class="submit" value="Autorizar"  tabindex="4"/>
							<input type="submit" id="rechaza" name="rechaza" class="submit" value="Rechazar"  tabindex="5"/>
						</a></td>

					</tr>
				</table>
				<input id="tipoTransaccion" name="tipoTransaccion" size="12" type="hidden" readOnly="true" disabled="true" /> <input id="exigibleDiaPago" name="exigibleDiaPago" size="12" type="hidden" readOnly="true" disabled="true" />
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