<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="js/pld/persInvListasRep.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="PersInvListas" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">
					<s:message code="safilocale.cliente" />s en Listas
				</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Par&aacute;metros</label>
								</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label"><label>Sucursal:</label></td>
										<td nowrap="nowrap"><form:input type="text" name="sucursal" id="sucursal" path="sucursal" autocomplete="off" size="12" tabindex="1" /> <input type="text" name="nombreSucursal" id="nombreSucursal" autocomplete="off" size="40" readonly="readonly" disabled="disabled" /></td>
									</tr>
									<tr>
										<td><label>Tipo Lista:</label></td>
										<td><select id="tipoLista" name="tipoLista" tabindex="2">
											<option value="">SELECCIONAR</option>
											<option value="1">LISTAS NEGRAS</option>
											<option value="2">LISTAS PERSONAS BLOQ.</option>
										</select>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<table width="200px">
								<tr>
									<td class="label">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 50%">
												<tr>
													<td><input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="3" checked="checked" /></td>
													<td><label for="pdf"> PDF </label></td>
												</tr>
												<tr>
													<td><input type="radio" id="excel" name="tipoReporte" value="2" tabindex="3" /></td>
													<td><label for="excel"> Excel </label></td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right"><input type="button" id="generar" name="generar" class="submit" tabindex="4" value="Generar" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>

	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
</html>