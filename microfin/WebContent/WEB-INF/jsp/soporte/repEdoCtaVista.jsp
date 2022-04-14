<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="js/soporte/repEdoCta.js"></script>


</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repBitacoraAccesoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Estados de Cuenta</legend>
				<table>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table>
									<tr>	
										<td class="label">
											<label for="anioMes">Periodo de Generaci&oacute;n: </label>
										</td>
										<td>
											<input type="text" id="anioMes" name="anioMes" size="12" tabindex="1" maxlength="6" autocomplete="off"/>	
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="clienteID">N&uacute;mero de Cliente: </label>
										</td>
										<td>
											<input type="text" id="clienteID" name="clienteID"  size="12" value="0" tabindex="2" maxlength="10"/> 
											<input type="text" id="nombreCliente" name="nombreCliente"  size="50" readonly="true" value="TODOS"  />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="tipoEdoCta">Estatus: </label>
										</td>
										<td>
											<select id="tipoEdoCta" name="tipoEdoCta"   tabindex="3">
												<option value="0">TODOS</option>
												<option value="1">GENERADOS</option>
											   	<option value="2">TIMBRADOS</option>
											   	<option value="3">NO TIMBRADOS</option>
											   	<option value="4">ENVIADOS</option>
											   	<option value="5">NO ENVIADOS</option>
											</select>	
										</td>
									</tr>				
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<table width="120px">
								<tr>
									<td  valign="top">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="4"/>
												<label> Excel </label>
											</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="right">
								<input type="button" id="generar" name="generar" class="submit" tabIndex="5" value="Generar" />
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<input type="hidden" id="tipoLista" name="tipoLista" />
						</td>
					</tr>
				</table>
				<table>
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