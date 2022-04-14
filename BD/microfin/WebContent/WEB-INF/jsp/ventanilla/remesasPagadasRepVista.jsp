<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/catalogoServicios.js"></script>	
	<script type="text/javascript" src="dwr/interface/catalogoRemesasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/ventanilla/remesasPagadasRep.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="remesasPagadasRepBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Remesas Pagadas</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>
									<label>Parámetros: </label>
								</legend>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label"><label for="lblFechaCarga">Fecha Inicial:</label></td>
										<td><form:input type="text" id="fechaInicial"
												name="fechaInicial" size="14" tabindex="3"
												path="fechaInicial" esCalendario="true" /></td>
									</tr>
									<tr>
										<td class="label"><label for="lblFechaCarga">Fecha Final:</label></td>
										<td><form:input type="text" id="fechaFinal"
												name="fechaFinal" size="14" tabindex="4"
												path="fechaFinal" esCalendario="true" /></td>
									</tr>
									<tr>
										<td class="label"><label for="lblnum">Remesadora: </label>
										</td>
										<td>
										<form:input type="text" id="remesadoraID"
												name="remesadoraID" size="4" tabindex="3"
												path="remesadoraID"  autocomplete="off" />
										<form:input type="text" id="remesadora"
												name="remesadora" size="30" tabindex="3"
												path="remesadora" readonly="true"/>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="lblnum">Sucursal: </label>
										</td>
										<td>
										<form:input type="text" id="sucursalID"
												name="sucursalID" size="4" tabindex="3"
												path="sucursalID"  autocomplete="off"/>
										<form:input type="text" id="sucursal"
												name="sucursal" size="30" tabindex="3"
												path="sucursal" readonly="true"/>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="lbltserv">Usuario:
										</label></td>
										<td>
										<form:input type="text" id="usuarioID"
												name="usuarioID" size="4" tabindex="3"
												path="usuarioID"  autocomplete="off"/>
										<form:input type="text" id="nombreUsuario"
												name="nombreUsuario" size="30" tabindex="3"
												path="nombreUsuario" readonly="true"/>
										</td>
									</tr>
									
								</table>
							</fieldset>
						</td>
						<td>
							<table width="200px">
								<tr>
									<td/>
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentación: </label>
											</legend>
											<input type="radio" id="excel" name="excel" tabindex="8"
												checked /> <label> Excel </label>
										</fieldset></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br>
				<table align="right">
					<tr>
						<td align="right">
							<button type="button" class="submit" id="generar" style=""
								tabindex="10">Generar</button>
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
<div id="mensaje" style="display: none;" />
</body>
</html>