<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposPlanAhorroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/tiposPlanAhorro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposPlanAhorroBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget-header ui-corner-all">Tipos de Plan de Ahorro</legend>
					<table border="0" width="100%">
						<tr><br/></tr>
						<tr>
							<td class="label">
								<label for="planID">Plan ID: </label>
							</td>
							<td>
								<form:input type="text" id="planID" name="planID" path="planID" size="10" tabindex="1" />
								<form:input type="text" id="nombre" name="nombre" path="nombre" size="30" tabindex="2" onBlur="ponerMayusculas(this)"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label form="fechaInicio">Fecha Inicio: </label>
							</td>
							<td>
								<form:input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15" tabindex="3" esCalendario="true" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaVencimiento">Fecha Vencimiento: </label>
							</td>
							<td>
								<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="15" tabindex="4" esCalendario="true" autocomplete="off"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label fon="fechaLiberacion">Días Desbloqueo: </label>
							</td>
							<td>
								<form:input type="text" id="diasDesbloqueo" name="diasDesbloqueo" path="diasDesbloqueo" size="15" tabindex="5" maxlength="" />
								<form:input type="hidden" id="fechaLiberacion" name="fechaLiberacion" path="fechaLiberacion" size="15"  autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label>Dep&oacute;sito Base: </label>
							</td>
							<td>
								<form:input type="text" id="depositoBase" name="depositoBase" path="depositoBase" size="8" tabindex="6" esmoneda="true" style="text-align: right"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="maxDep">No. M&aacute;x. Dep: </label>
							</td>
							<td>
								<form:input type="text" id="maxDep" name="maxDep" path="maxDep" size="8" tabindex="7" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="prefijo">Prefijo: </label>
							</td>
							<td>
								<form:input type="prefijo" id="prefijo" name="prefijo" path="prefijo" size="8" tabindex="8" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="serie">Serie Actual: </label>
							</td>
							<td>
								<form:input type="serie" id="serie" name="serie" path="serie" size="8" tabindex="9" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tiposCuentas">Tipos de Cuentas: </label>
							</td>
							<td>
								<select MULTIPLE id="tiposCuentas" name="tiposCuentas" path="tiposCuentas" tabindex="10"></select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="leyendaBloqueo">Leyenda Bloqueos: </label>
							</td>
							<td>
								<textarea type="text" id="leyendaBloqueo" name="leyendaBloqueo" path="leyendaBloqueo" tabindex="11" maxlength="250" autocomplete="off" ></textarea>
							</td>
						</tr>
						<tr>
							<td class="label"></td>
							<td></td>
							<td class="separador"></td>
							<td class="label">
								<label for="leyendaTicket">Leyenda Tickets: </label>
							</td>
							<td>
								<textarea type="text" id="leyendaTicket" name="leyendaTicket" path="leyendaTicket" tabindex="12" maxlength="250" autocomplete="off"></textarea>
							</td>
						</tr>
					</table>
					<br>
					<table align="right">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="13" />
											<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="14" />
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
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
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>