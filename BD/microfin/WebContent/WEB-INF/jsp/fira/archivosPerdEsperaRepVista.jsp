<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
<script type="text/javascript" src="js/fira/archPerdidaEsperada.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="archPerdidaEsperadaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Archivos P&eacute;rdida Esperada</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="archivo">Archivo:</label>
						</td>
						<td>
							<form:select id="archivo" name="archivo" path="archivo">
								<form:option value="0">SELECCIONAR</form:option>
								<form:option value="1">Información para PI comercial FIRA</form:option>
								<form:option value="2">Información para PI comercial NO FIRA</form:option>
								<form:option value="3">Información para SP comercial FIRA</form:option>
								<form:option value="4">Información para SP comercial NO FIRA</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="fecha">Fecha:</label>
						</td>
						<td>
							<form:input type="text" id="fecha" name="fecha" path="fecha" esCalendario="true" size="12" disabled="true" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="subir">Archivo FIRA:</label>
						</td>
						<td nowrap="nowrap" colspan="3">
							<input type="text" name="rutaArchivo" id="rutaArchivo" readonly="readonly" disabled="disabled" size="35" style="height: 20px" />
							<input type="button" id="subir" tabindex="80" name="subir" class="submit" value="Subir" />
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input type="button" id="generar" tabindex="80" name="generar" class="submit" value="Generar" />
							<input type="hidden" name="extarchivo" id="extarchivo" readOnly="readonly" />
							<input type="hidden" id="rutaFinal" name="rutaFinal" />
							<input type="hidden" id="nombreArchivo" name="nombreArchivo" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
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
