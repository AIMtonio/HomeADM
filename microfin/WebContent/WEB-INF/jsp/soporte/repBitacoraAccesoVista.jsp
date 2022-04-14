<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
	<script type="text/javascript" src="js/soporte/repBitacoraAcceso.js"></script>


</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repBitacoraAccesoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Bit&aacute;cora SAFI</legend>
				<table>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table>
									<tr>	
										<td class="label" nowrap="nowrap">
											<label for="fechaInicio">Fecha de Inicio: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaInicio" name="fechaInicio" size="15" maxlength="10" tabindex="1"  esCalendario="true" />	
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="fechaFin">Fecha de Fin: </label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="fechaFin" name="fechaFin" size="15" maxlength="10" tabindex="2"  esCalendario="true" />	
										</td>
									</tr>	
									<tr>
										<td class="label">
											<label for="usuarioID">Usuario: </label>
										</td>
										<td>
											<input type="text" id="usuarioID" name="usuarioID"  size="12" value="0" tabindex="3" maxlength="11"/> 
											<input type="text" id="desUsuario" name="desUsuario"  size="50" value="TODOS"  />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="sucursalID">Sucursal: </label>
										</td>
										<td>
											<input type="text"  id="sucursalID" name="sucursalID"  size="12" value="0" tabindex="4"  /> 
											<input type="text" id="desSucursal" name="desSucursal"  size="50" value="TODAS"  />
										</td>
									</tr>	
									<tr>
										<td class="label">
											<label for="tipoAcceso">Tipo: </label>
										</td>
										<td>
												<select id="tipoAcceso" name="tipoAcceso"   tabindex="5">
													<option value="0">TODOS</option>
													<option value="1">ACCESOS EXITOSOS</option>
											     	<option value="2">ACCESOS FALLIDOS</option>
											     	<option value="3">CONSUMO DE RECURSOS</option>
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
												<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="4"/>
												<label> PDF </label>
											</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="right">
								<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
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