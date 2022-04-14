<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/perfilTransaccionalServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>

<script type="text/javascript" src="js/pld/perfilTransaccional.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="perfilTransaccional">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Perfil Transaccional</legend>
				<table style="width: 100%">
					<tr id="trTipoPerfil" style="display: none;">
						<td class="label">
							<label for="">Tipo Perfil: </label>
						</td>
						<td id="tdTipoPerfil">
							<input type="radio" name="tipoPerfil" id="radioCliente" value="C" style="cursor: pointer;">
							<label for="radioCliente" style="cursor: pointer;"><s:message code="safilocale.cliente" /></label>
							&ensp;
							<input type="radio" name="tipoPerfil" id="radioUsuario" value="U" style="cursor: pointer;">
							<label for="radioUsuario" style="cursor: pointer;">Usuario de servicios</label>
						</td>
					</tr>
					<tr id="trCliente">
						<td class="label">
							<label for="clienteID"><s:message code="safilocale.cliente" />:</label>
						</td>
						<td nowrap="nowrap" colspan="4">
							<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="1" autocomplete="off" value="" />
							<input type="text" id="nombreCliente" name="nombreCliente" tabindex="5" disabled="true" size="50" />
						</td>
					</tr>
					<tr id="trUsuarioServicios" style="display: none;">
						<td class="label">
							<label for="usuarioID">Usuario de Servicio:</label>
						</td>
						<td nowrap="nowrap" colspan="4">
							<form:input type="text" id="usuarioID" name="usuarioID" path="" size="11" tabindex="1" autocomplete="off" value="" />
							<input type="text" id="nombreUsuario" name="nombreUsuario" tabindex="5" disabled="true" size="50" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="depositosMax">Monto M&aacute;ximo Dep&oacute;sitos:&nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="depositosMax" name="depositosMax" path="depositosMax" size="20" esMoneda="true" tabindex="2" style="text-align:right;" maxlength="18" value="" />
							<a href="javaScript:" onclick="ayuda('ayuda1')"> <img src="images/help-icon.gif">
							</a>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="retirosMax">Monto M&aacute;ximo Retiros:&nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="retirosMax" name="retirosMax" path="retirosMax" size="20" esMoneda="true" tabindex="3" style="text-align:right;" maxlength="18" value="" />
							<a href="javaScript:" onclick="ayuda('ayuda2')"> <img src="images/help-icon.gif">
							</a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="numDepositos">N&uacute;mero de Dep&oacute;sitos:&nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="numDepositos" name="numDepositos" path="numDepositos" size="20" esMoneda="true" tabindex="4" maxlength="18" value="" />
							<a href="javaScript:" onclick="ayuda('ayuda3')"> <img src="images/help-icon.gif">
							</a>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="numRetiros">N&uacute;mero de Retiros:&nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input type="text" id="numRetiros" name="numRetiros" path="numRetiros" size="20" esMoneda="true" tabindex="5" maxlength="18" value="" />
							<a href="javaScript:" onclick="ayuda('ayuda4')"> <img src="images/help-icon.gif">
							</a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="origenRecursos">Origen Recursos:&nbsp;</label>
						</td>
						<td>
							<form:select id="origenRecursos" name="origenRecursos" path="origenRecursos" tabindex="6">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Comentarios:</label>
						</td>
						<td>
							<form:textarea id="comentarioOrigenRec" name="comentarioOrigenRec" path="comentarioOrigenRec" rows="4" cols="20" tabindex="7"></form:textarea>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="destinoRecursos">Destino Recursos:&nbsp;</label>
						</td>
						<td>
							<form:select id="destinoRecursos" name="destinoRecursos" path="destinoRecursos" tabindex="8">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label>Comentarios:</label>
						</td>
						<td>
							<form:textarea id="comentarioDestRec" name="comentarioDestRec" path="comentarioDestRec" rows="4" cols="20" tabindex="9"></form:textarea>
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="10" />
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="11" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="ctrlUsuarioID" name="ctrlUsuarioID">
							<input type="hidden" id="ctrlClienteID" name="ctrlClienteID">
						</td>
					</tr>
					<tr>
					<td colspan="5">
					<div id="historico" style="width: 100%"></div>
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
	<div id="mensaje" style="display: none;"></div>
	<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
	<div id="ContenedorAyuda" style="display: none;">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Perfil Transaccional</legend>
			<div id="ayuda1">
				<p>Acumulado M&aacute;ximo Mensual de Dep&oacute;sitos.</p>
			</div>
			<div id="ayuda2">
				<p>Acumulado M&aacute;ximo Mensual de Retiros.</p>
			</div>
			<div id="ayuda3">
				<p>N&uacute;mero de Dep&oacute;sitos Mensual.</p>
			</div>
			<div id="ayuda4">
				<p>N&uacute;mero de Retiros Mensual.</p>
			</div>
		</fieldset>
	</div>
</body>
</html>