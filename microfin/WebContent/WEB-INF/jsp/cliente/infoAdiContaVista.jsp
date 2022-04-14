<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/infoAdiContaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/conocimientoCteServicio.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="dwr/interface/conocimientoCteServicio.js"></script>

<script type="text/javascript" src="js/cliente/infoAdiConta.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="infoAdiConta">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Informaci&oacute;n General</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="idAcreditado">Acreditado:</label>
						</td>
						<td>
							<form:input type="text" id="idAcreditado" name="acreditado" path="acreditado" size="11" maxlength="11" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="nombreAcreditado">Nombre:</label>
						</td>
						<td>
							<form:input type="text" id="idNombreAcreditado" name="nombreAcreditado" path="nombreAcreditado" size="50" disabled="true" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="idTipoSociedad">Tipo de Sociedad:</label>
						</td>
						<td>
							<form:input type="text" id="idTipoSociedad" name="tipoSociedad" path="tipoSociedad" size="50" disabled="true" />
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="idTipoEntidad">Tipo de Entidad:</label>
						</td>
						<td>
							<form:select id="idTipoEntidad" name="tipoEntidad" path="tipoEntidad">
								<form:option value="0">SELECCIONAR</form:option>
								<form:option value="1">Bancaria o no bancaria regulada perteneciente a subsidiaria bancaria</form:option>
								<form:option value="2">No bancaria regulada </form:option>
								<form:option value="3">No bancaria no regulada</form:option>
								<form:option value="4">Entidad financiera otorgante de crédito </form:option>
							</form:select>
						</td>
					</tr>
					<tr class="tdInformacionAdicional">
						<td colspan="5">
							<div id="subform"></div>
						</td>
					</tr>
					<tr>
					<td align="right" colspan="5">
						<input type="button" id="agrega" tabindex="80" name="agrega" class="submit" value="Agregar" />
						<input type="button" id="modifica" tabindex="81" name="modifica" class="submit" value="Modificar" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
						<input type="hidden" id="capitalContable" name="capitalContable"  value="" />
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
