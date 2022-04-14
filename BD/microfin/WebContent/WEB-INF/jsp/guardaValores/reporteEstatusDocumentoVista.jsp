<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catalogoAlmacenesServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/reporteEstatusDocumentoVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form id="formaGenerica" name="formaGenerica" method="POST" commandName="documentosGuardaValoresBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Documentos por Estatus</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="600px">
						<tr>
							<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>P&aacute;rametros</label>
								</legend>
								<table border="0" width="560px">
									<tr>
										<td class="label">
											<label for="sucursalID">Sucursal:</label>
										</td>
										<td colspan="4">
											<input id="sucursalID" name="sucursalID" size="12" path="sucursalID"  maxlength="25" tabindex="1" type="text" iniforma="false" autocomplete="off">
											<input id="nombreSucursal" name="nombreSucursal" size="50" type="text" disabled="disabled">
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="almacenID">Almac&eacute;n:</label>
										</td>
										<td colspan="4">
											<input id="almacenID" name="almacenID" size="12" path="almacenID"  maxlength="25" tabindex="2" type="text" iniforma="false" autocomplete="off">
											<input id="nombreAlmacen" name="nombreAlmacen" size="50" type="text" disabled="disabled">
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="estatus">Estatus: </label>
										</td>
										<td colspan="4">
											<select id="estatus" name="estatus" path="estatus" tabindex="3">
												<option value="">TODOS</option>
												<option value="R">REGISTRADO</option>
												<option value="C">CUSTODIA</option>
												<option value="P">PR&Eacute;STAMO</option>
												<option value="B">BAJA</option>
											</select>
										</td>
									</tr>
								</table>
							</fieldset>
							</td>
							<td>
								<table width="100px">
									<tr>
										<td class="label" style="position: absolute; top: 12%;">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="pdf" name="pdf" value="1" tabindex="4">
												<label> PDF </label>
												<br>
												<input type="radio" id="excel" name="excel" value="2" tabindex="5">
												<label> Excel </label>
											</fieldset>
										</td>
									</tr>
									<br>
								</table>
							</td>
						</tr>
					</table>
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
					<table border="0" cellpadding="0" cellspacing="0" width="700px">
						<tr>
							<td colspan="4">
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<a id="ligaGenerar" href="reporteDocumentosGrdValExcel.htm" target="_blank" >
												<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
											</a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</form>
		</div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>