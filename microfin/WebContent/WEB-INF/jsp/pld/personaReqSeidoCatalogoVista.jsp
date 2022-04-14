<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/pldListaNegrasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/pldListasPersBloqServicio.js"></script>
<script type="text/javascript" src="js/pld/personaReqSeido.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="personaReqSeido">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">B&uacute;squeda de Posible Relacionado con Operaciones Il&iacute;citas</legend>
				<table style="width: 100%">
					<tr>
						<td>
							<table>
								<tr>
									<td class="label"><label for="clienteID">No. <s:message code="safilocale.cliente" />:
									</label></td>
									<td nowrap="nowrap"><form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1" /> <input type="text" id="nombreCompleto" name="nombreCompleto" size="50" tabindex="2" onblur="ponerMayusculas(this)" maxlength="200" disabled="true" /></td>
									<td class="separador"></td>
									<td class="label"></td>
									<td></td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap"><label for="listaID"> Coincidencias en: </label></td>
									<td class="label" colspan="4" nowrap="nowrap"><input TYPE="checkbox" id="bloqueada" name="bloqueada" disabled="disabled" value="B" /> <label for="bloq">Lista de Pers. Bloqueadas</label> <input TYPE="checkbox" id="listaNegra" name="listaNegra" disabled="disabled" value="N" /> <label for="lisNegra">Listas Negras </label></td>
								</tr>
								<tr>
									<td colspan="5" style="text-align: right;"><input type="submit" id="buscarcli" name="buscarcli" class="submit" value="Buscar" tabindex="2" /> <input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									Como
									<s:message code="safilocale.cliente" />
								</legend>
								<div id="gridClientes" style="display: none;"></div>
							</fieldset> <br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldCuenta">
								<legend>Como Relacionado a la Cuenta</legend>
								<div id="gridRelacionadosCuenta" style="display: none;"></div>
							</fieldset> <br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldInversion">
								<legend>Como Relacionado a la Inversi&oacute;n</legend>
								<div id="gridRelacionadosInversion" style="display: none;"></div>
							</fieldset> <br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldAval">
								<legend>Como Aval</legend>
								<div id="gridCreAvales" style="display: none;"></div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table style="width: 100%">
								<tr>
									<td colspan="5" style="text-align: right;">
										<button id="imprimir" name="imprimir" class="submit" tabindex="6" disabled="disabled">Imprimir</button>
									</td>
								</tr>
							</table>
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
	<div id="cajaListaCte" style="display: none; overflow-y: scroll; height: 200px;">
		<div id="elementoListaCte"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>