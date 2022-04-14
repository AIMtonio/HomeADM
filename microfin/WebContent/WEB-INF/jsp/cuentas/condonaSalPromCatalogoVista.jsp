<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/comicionesPendientesCob.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	<script type="text/javascript" src="js/cuentas/condonaSalPromCatalogoVista.js"></script>
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="comisionesSaldoPromedioBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Comisiones Pendientes de Cobro</legend>
		<table>
			<tr>
				<td class="label">
					<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
				</td>
				<td>
					<input type="text" id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="1" autocomplete="off"/>
					<input type="text" id="nombreCte" name="nombreCte"size="40" type="text" tabindex="2" readOnly="true" disabled="true">
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
			</tr><br>
			<tr>
				<table border="0" >
					<tr>
						<div id="gridCuentasCliente" style="display: none; width: 595px;" ></div>
					</tr>
				</table>
			</tr>
		</table><br>
		<div id="gridCondona" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Detalle Comisiones </legend>
					<table border="0" >
						<tr>
							<div id="gridComisionesSaldoPromedio" style="display: none; width: 100%;" ></div>
						</tr><br>
					</table>

				<!-------------------------------------------- USUARIO Y CONTRASEÑA AUTORIZACION---------------------------- -->
				<fieldset class="ui-widget ui-widget-content ui-corner-all" style="width: 30%;" id="usuarioContrasenia">
					<legend>Usuario Autoriza</legend>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="usuarioA">Usuario: </label>
								</td>
								<td >
									<input type="text" id="usuarioAutorizaID" name="usuarioAutorizaID" size="30" tabindex="3" autocomplete="off"/>
									<input type="hidden" id="usuarioID" name="usuarioID" disabled="true" autocomplete="off"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="pass">Contraseña:</label>
								</td>
								<td>
									<input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza" value="" size="30"  tabindex="4" />
								</td>
							</tr>
							<span id="statusSrvHuella" style="float: right; display: none;"></span>
						</table>
				</fieldset>
				<tr>
			</fieldset>
		</div>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar" tabindex="15"/>
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
				</td>
			</tr>
		</table>
	</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
