<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasBalanzaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conceptoBalanzaServicio.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
		<script type="text/javascript" src="js/contabilidad/cuentasContablesCatalogo.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Contables</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasContablesBean">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblcuentaCompleta">Cuenta:</label>
							</td>
							<td>
								<form:input id="cuentaCompleta" name="cuentaCompleta" path="cuentaCompleta" size="14" maxlength="25" tabindex="1" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblcuentaMayor">Cuenta Mayor:</label>
							</td>
							<td>
								<form:input id="cuentaMayor" name="cuentaMayor" path="cuentaMayor" size="5" readOnly="true" disabled="true" tabindex="2" iniForma = 'false' />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lbldescripcion">Descripci&oacute;n:</label>
							</td>
							<td>
								<form:input id="descripcion" name="descripcion" path="descripcion" size="35" maxlength="250" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" tabindex="3" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lbldescriCorta">Descripci&oacute;n Corta:</label>
							</td>
							<td>
								<form:input id="descriCorta" name="descriCorta" path="descriCorta" size="20" maxlength="250" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" tabindex="4" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblnaturaleza">Naturaleza:</label>
							</td>
							<td>
								<label for="lblnaturalezaA">Acreedora</label>
								<form:radiobutton id="naturalezaA" name="naturalezaA" path="naturaleza" value="A" tabindex="5" checked="checked" />
								<label for="lblnaturalezaD">&nbsp;&nbsp; Deudora</label>
								<form:radiobutton id="naturalezaD" name="naturalezaD" path="naturaleza" value="D" tabindex="6"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblgrupo">Grupo:</label>
							</td>
							<td>
								<label for="lblGrupo">Encabezado</label>
								<form:radiobutton id="grupoE" name="grupoE" path="grupo" value="E" tabindex="7" checked="checked" />
								<label for="lblGrupo">&nbsp;&nbsp; Detalle</label>
								<form:radiobutton id="grupoD" name="grupoD" path="grupo" value="D" tabindex="8"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lbltipoCuenta">Tipo Cuenta:</label>
							</td>
							<td>
								<form:select id="tipoCuenta" name="tipoCuenta" path="tipoCuenta" tabindex="9">
									<form:option value="1">Activo</form:option>
									<form:option value="2">Pasivo</form:option>
									<form:option value="3">Complementaria de Activo</form:option>
									<form:option value="4">Capital y Reserva</form:option>
									<form:option value="5">Resultados Ingresos</form:option>
									<form:option value="6">Resultados Egresos</form:option>
									<form:option value="7">Orden Deudora</form:option>
									<form:option value="8">Orden Acreedora</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblMonedaId">Moneda:</label>
							</td>
							<td>
								<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="10">
									<form:option value="">Seleccionar</form:option>
								</form:select>
						 	</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblrestringida">Restringida:</label>
							</td>
							<td>
								<label for="lblrestringidaS">Si</label>
								<form:radiobutton id="restringidaS" name="restringidaS" path="restringida" value="S" tabindex="11" checked="checked" />
								<label for="lblrestringidaN">&nbsp;&nbsp; No</label>
								<form:radiobutton id="restringidaN" name="restringidaN" path="restringida" value="N" tabindex="12"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblcogAgrup">C&oacute;digo Agrupador:</label>
							</td>
							<td>
								<form:input id="codigoAgrupador" name="codigoAgrupador" path="codigoAgrupador" size="5" tabindex="13" onkeyPress="return validadorConPunto(event);"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblnivel">Nivel:</label>
							</td>
							<td>
								<form:input id="nivel" name="nivel" path="nivel" size="14" tabindex="14"  onkeyPress="return validador(event);"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblfechaCreacionCta">Fecha Creaci&oacute;n:</label>
							</td>
							<td>
								<form:input id="fechaCreacionCta" name="fechaCreacionCta" path="fechaCreacionCta" size="20" tabindex="15" esCalendario="true" />
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega"  tabindex="16" />
											<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"  tabindex="17"/>
											<input type="submit" id="eliminar" name="eliminar" class="submit"  value="Eliminar"  tabindex="18"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
		 			</table>
				</form:form>
			</fieldset>
		</div>

		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
	<script language="javascript">
	</script>
</html>