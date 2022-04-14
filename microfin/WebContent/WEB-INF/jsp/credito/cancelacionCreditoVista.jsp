<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%!int	consecutivoID	= 01;%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script> 
<script type="text/javascript" src="js/credito/cancelacionCredito.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n de Cr&eacute;dito</legend>
				<table style="width: 100%">
					<tr>
						<td class="label">
							<label for="creditoID">Cr&eacute;dito:</label>
						</td>
						<td>
							<input type="text" value="" size="12" name="creditoID" id="creditoID" tabindex="<%=consecutivoID++%>">
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="clienteID"><s:message code="safilocale.cliente" />:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" value="" size="12" name="clienteID" id="clienteID" disabled="disabled" readonly="readonly" /> <input type="text" value="" size="50" name="nombreCliente" id="nombreCliente" disabled="disabled" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="fechaMinistrado">Fecha Desembolso:</label>
						</td>
						<td>
							<input type="text" value="" size="12" name="fechaMinistrado" id="fechaMinistrado" disabled="disabled" readonly="readonly" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="estatus">Estatus:</label>
						</td>
						<td>
							<input type="text" value="" size="12" name="estatus" id="estatus" disabled="disabled" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="fechaInicio">Fecha Inicio:</label>
						</td>
						<td>
							<input type="text" value="" size="12" name="fechaInicio" id="fechaInicio" disabled="disabled" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="producCreditoID">Producto Cr&eacute;dito: </label>
						</td>
						<td nowrap="nowrap">
							<input type="text" value="" size="12" name="producCreditoID" id="producCreditoID" disabled="disabled" readonly="readonly" /> <input type="text" value="" size="50" name="nombreProducto" id="nombreProducto" disabled="disabled" readonly="readonly" />
						</td>
						<td class="separador"></td>
						<td class="label grupo">
							<label for="grupoID">Grupo: </label>
						</td>
						<td class="grupo">
							<input type="text" value="" size="12" name="grupoID" id="grupoID" disabled="disabled" readonly="readonly" /> <input type="text" value="" size="50" name="nombreGrupo" id="nombreGrupo" disabled="disabled" readonly="readonly" />
						</td>
					</tr>
					<tr class="grupo">
						<td class="label">
							<label for="esGrupal">Es grupal:</label>
						</td>
						<td>
							<select id="esGrupal" name="esGrupal" disabled="disabled">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</select>
							<input type="hidden" value="" name="cicloGrupo" id="cicloGrupo" />
						</td>
					</tr>
					<tr class="credIndv" style="display: none;">
						<td class="label"><label for="montoCredito">Capital:</label></td>
						<td><input type="text" value="" size="18" style="text-align: right;" esMoneda="true" id="montoCredito" name="montoCredito" readonly="readonly" disabled="disabled"/></td>
					</tr>
					<tr  class="credIndv" style="display: none;">
						<td class="label"><label for="totalInteres">Inter&eacute;s</label></td>
						<td><input type="text" value="" size="18" style="text-align: right;" esMoneda="true" id="totalInteres" name="totalInteres" readonly="readonly" disabled="disabled"/></td>
					</tr>
					<tr  class="credIndv" style="display: none;">
						<td class="label"><label for="montoGLAho">Monto Garant&iacute;a</label></td>
						<td><input type="text" value="" size="18" style="text-align: right;" esMoneda="true" id="montoGLAho" name="montoGLAho" readonly="readonly" disabled="disabled"/></td>
					</tr>
					<tr  class="credIndv" style="display: none;">
						<td class="label"><label for="montoComApertura">Comisi&oacute;n por Apertura:</label></td>
						<td><input type="text" value="" size="18" style="text-align: right;" esMoneda="true" id="montoComApertura" name="montoComApertura" readonly="readonly" disabled="disabled"/></td>
					</tr>
					<tr style="display: none;">
						<td class="label"><label for="montoGLAho">IVA Comisi&oacute;n por Apertura:</label></td>
						<td><input type="text" value="" size="18" style="text-align: right;" esMoneda="true" id="IVAComApertura" name="IVAComApertura" readonly="readonly" disabled="disabled"/></td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="gridIntegrantes" style="display: none;"></div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<table>
									<tr>
										<td class="label">
											<label for="motivoCancel">Motivo:</label>
										</td>
										<td>
											<textarea id="motivoCancel" name="motivoCancel" rows="3" cols="55" tabindex="<%=consecutivoID++%>" onblur=" ponerMayusculas(this)" maxlength="200"></textarea>
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="usuarioAutoriza">Usuario:</label>
										</td>
										<td>
											<input id="usuarioAutoriza" name="usuarioAutoriza" autocomplete="off" readonly onfocus="evitaAutocompletado(this);" size="25" iniForma="false" type="text" maxlength="45" onblur="validaUsuarioAutorizacion(); validaAutorizacion();" tabindex="<%=consecutivoID++%>"/>
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="contraseniaAutoriza">Contraseña:</label>
										</td>
										<td>
											<input id="contraseniaAutoriza" name="contraseniaAutoriza" readonly onfocus="evitaAutocompletado(this);" size="25" type="password" maxlength="45" iniForma="false" onblur="validaAutorizacion();" tabindex="<%=consecutivoID++%>"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: right;">
							<input id="cancelar" type="submit" class="submit" value="Cancelar" tabindex="<%=consecutivoID++%>" />
							<input id="tipoTransaccion" name="tipoTransaccion" type="hidden" value=""/>
							<input id="tipoActualizacion" name="tipoActualizacion" type="hidden" value=""/>
							<input id="detalleCancelaCred" name="detalleCancelaCred" type="hidden" value=""/>
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
</body>
</html>