<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/pslConfigServicioServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/pslConfigProductoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/pslReportePagoServicio.js"></script>
	<script type="text/javascript" src="js/psl/pslReportePago.js"></script> 
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pslReportePagoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reporte de Pago de Servicios en Línea</legend>
			<table>
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr> 
								<td> 
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Parámetros</label></legend>
											<table border="0" cellpadding="0" cellspacing="0" width="100%">
												<tr>
													<td class="label">
														<label for="fechaInicio">Fecha  inicial:</label>
													</td>
													<td colspan="4">
														<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
															tabindex="1" type="text" esCalendario="true" />	
													</td>
												</tr>
												<tr>	
													<td class="label">
														<label for="fechaFin">Fecha final:</label> 
													</td>
													<td>
														<input  id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
															tabindex="2" type="text" esCalendario="true"/>
													</td>
												</tr>
												<tr>
													<td class="label">
														<label for="sucursal">Sucursal: </label> 
													</td>
													<td>
														<select name="sucursalID" id="sucursalID" path="sucursalID" tabindex="3">
														</select>
														<input type="hidden" id="sucursal" name="sucursal" path="sucursal" value="TODAS">
													</td>
												</tr>
												<tr>
													<td class="label">
														<label for="tipoServicio">Tipo de servicio:</label> 
													</td>
													<td>
														<select name="tipoServicioID" id="tipoServicioID" path="tipoServicioID" tabindex="4">
														</select>
														<input type="hidden" id="tipoServicio" name="tipoServicio" path="tipoServicio" value="TODOS">
													</td>
												</tr>
												<tr>
													<td class="label">
														<label for="servicio">Servicio:</label>
													</td>
													<td>
														<select name="servicioID" id="servicioID" path="servicioID" tabindex="5">
														</select>
														<input type="hidden" id="servicio" name="servicio" path="servicio" value="TODOS">
													</td>
												</tr>
												<tr>
													<td class="label">
														<label for="producto">Producto:</label>
													</td>
													<td>
														<select name="productoID" id="productoID" path="productoID" tabindex="6">
														</select>
														<input type="hidden" id="producto" name="producto" path="producto" value="TODOS">
													</td>
												</tr>
												<tr>
													<td class="label">
														<label for="canal">Canal:</label>
													</td>
													<td>
														<input type="checkbox" id="chkVentanilla" name="chkCanal" value="V" tabindex="7">
														<label>Ventanilla</label>
														<input type="checkbox" id="chkLinea" name="chkCanal" value="L" tabindex="8">
														<label>Banca en línea</label>
														<input type="checkbox" id="chkMovil" name="chkCanal" value="M" tabindex="9">
														<label>Banca móvil</label>
														<input type="hidden" id="canal" name="canal" path="canal" value="">
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top">
							<table width="100px">
								<tr>
									<td class="label" >
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend><label>Presentaci&oacute;n</label></legend>
											<table border="0" cellpadding="0" cellspacing="0" width="100%">
												<tr>
													<td>
														<input type="radio" id="pdf" name="opcionesReporte" value="pdf" tabindex="10"  checked="checked" >
														<label> PDF </label><br>
														<input type="radio" id="excel" name="opcionesReporte" value="excel" tabindex="11">
														<label> Excel </label>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table align="right" border='0'>
					<tr>
						<td align="right">
							<input type="button" id="generar" name="generar" class="submit" tabindex="12" value="Generar"  />
						</td>
					</tr>
				</table>
	</form:form>
</div>	
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>