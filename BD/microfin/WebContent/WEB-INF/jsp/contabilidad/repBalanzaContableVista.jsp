<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ejercicioContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
		<script type="text/javascript" src="js/contabilidad/reporteBalanzaContable.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>

	</head>
	<body>
		<br>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Balanza</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="balanza"  target="_blank">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Consulta Balanza a</label></legend>
									<input type="radio" id="tipoConsulta3" name="tipoConsulta3" path="tipoConsulta" value="E" tabindex="1" />
									<label> Cargos-Abonos D&iacute;a </label><br>
									<input type="radio" id="tipoConsulta" name="tipoConsulta" path="tipoConsulta" value="D" tabindex="2"/>
									<label> Fecha o D&iacute;a</label><br>
									<input type="radio" id="tipoConsulta2" name="tipoConsulta2"  path="tipoConsulta" value="P" tabindex="3"/>
									<label> Cierre del Periodo </label>
								</fieldset>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td>
							<br>
								<label>Fecha:</label>
								<input type="text" name="fecha" id="fecha" path="fecha"	disabled ="true"  size="9" esCalendario="true" tabindex="4" />
							</td>
						</tr>
						<tr>
							<td>
								<br>
								<label>Ejercicio:</label>
								<select id="numeroEjercicio" name="numeroEjercicio" path="numeroEjercicio" tabindex="5" >
									<option value="0">Selecciona</option>
								</select>
								<input type="text" name="finEjercicio" id="finEjercicio" path="finEjercicio"  autocomplete="off" size="14" tabindex="6" />
								<input type="hidden" id="inicioEjercicio" name="inicioEjercicio"/>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td>
							<br>
								<label>Periodo:</label>
								<select id="numeroPeriodo" name="numeroPeriodo" path="numeroPeriodo" tabindex="7" >
									<option value="0">Selecciona</option>
								</select>
								<input type="hidden" name="inicioPeriodo" id="inicioPeriodo" path="inicioPeriodo" autocomplete="off" size="14" tabindex="8" />
								<input type="hidden" name="finPeriodo" id="finPeriodo" path="finPeriodo" autocomplete="off" size="14" tabindex="9" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Incluir Cuentas con Saldos cero </label></legend>
									<input type="radio" id="saldoCero" name="saldoCero" path="saldoCero" value="S" tabindex="10"/>
									<label> Si </label><br>
									<input type="radio" id="saldoCero2" name="saldoCero2" path="saldoCero" value="N" tabindex="11"/>
									<label> No </label>
								</fieldset>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
							<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Cifras en </label></legend>
									<input type="radio" id="cifras" name="cifras" path="cifras" value="P" tabindex="12"/>
									<label> Pesos </label><br>
									<input type="radio" id="cifras2" name="cifras2" path="cifras" value="M" tabindex="13"/>
									<label> Miles </label>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td>
								<br>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Tipo </label></legend>
									<input type="radio" id="tipoBalanza1" name="tipoBalanza" path="tipoBalanza" value="C" tabindex="14"/>
									<label> Centro de costo </label><br>
									<input type="radio" id="tipoBalanza2" name="tipoBalanza" path="tipoBalanza" value="G" tabindex="15" checked="checked"/>
									<label> Global </label>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td>
								<table>
									<tr>
										<td class="label">
											<label>C.Costos Inicial:</label>
										</td>
										<td>
											<input type="text" id="ccinicial" name="ccinicial" size="11" tabindex="16" />
											<input type="text" id="descripcionI" name="descripcionI" size="30" readOnly="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>C.Costos Final:</label>
										</td>
										<td>
											<input type="text" id="ccfinal" name="ccfinal" size="11" tabindex="17" />
											<input type="text" id="descripcionF" name="descripcionF" size="30" readOnly="true"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Rango de Cuentas</label></legend>
									<label>Cuenta Contable Inicial:</label>
									<input type="text" id="cuentaIni" name="cuentaIni" size="25" tabindex="18" />
									<textarea type="text" id="descripcionCtaIni" name="descripcionCtaIni" path="descripcionCtaIni" cols="30" rows="2" readOnly="true"></textarea>
									<br>
									<label>Cuenta Contable Final:&nbsp;</label>
									<input type="text" id="cuentaFin" name="cuentaFin" size="25" tabindex="19"/>
									<textarea type="text" id="descripcionCtaFin" name="descripcionCtaFin" path="descripcionCtaFin" cols="30" rows="2" readOnly="true"></textarea>

								</fieldset>
							</td>
						</tr>
						<tr>
							<td>
								<br>
								<label>Nivel de Detalle:</label>
								<input type="text" id="nivelDetalle" name="nivelDetalle" size="30" maxlength="30" tabindex="20" onBlur="ponerMayusculas(this)"/>
									<a href="javaScript:" onClick="ayuda();">
										<img src="images/help-icon.gif" >
									</a>
							</td>
						</tr>
						<tr>
							<td class="label">
								<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pantalla" name="pantalla" tabindex="21"/>
									<label> Pantalla </label><br>
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="22">
									<label> PDF </label><br>
									<input type="radio" id="excel" name="excel" value="excel" tabindex="23">
									<label> Excel </label>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<br>
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<input type="button"  id="generar" name="generar" class="submit" tabindex="7" value="Generar"  tabindex="24"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</form:form>
			</fieldset>
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>