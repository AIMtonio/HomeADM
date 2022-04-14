<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clasifClavePresupServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clavePresupServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoClavePresupServicio.js"></script>
		<script type="text/javascript" src="js/nomina/clavePresupuestal.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="nomTipoClavePresupBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">ALTA DE CLAVES PRESUPUESTALES, OTROS INGRESOS Y OTROS EGRESOS</legend>
					<table border="0" >
						<tr >
							<td colspan="2">
								<div id="gridAltaClavePresup" style="display: none;" ></div>
							</td>
						</tr>
					</table>
					<br>
					<br>
					<div id="divClasifica" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Clasificaci&oacute;n de Claves Presupuestales</legend>
							<table border="0" >
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lbNomClasifClavPresupID">Tipo Clasifica:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="nomClasifClavPresup" name="nomClasifClavPresup" size="20"  tabindex="7" autocomplete="off" />
									</td>

									<td class="separador"></td>
									<td class="label" nowrap="nowrap">
										<label for="ldDescripClasifClave">Descripci&oacute;n:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="descripClasifClave" name="descripClasifClave" size="60" maxlength="70" tabindex="8" autocomplete="off" onBlur="ponerMayusculas(this)"/>
									</td>
								</tr>

								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lbEstatus">Estatus:</label>
									</td>

									<td nowrap="nowrap">
										<select type="text" id="estatus" name="estatus" tabindex="9" readOnly="true">
											<option value="">SELECCIONAR</option> 
											<option value="A">ACTIVO</option> 
											<option value="I">INACTIVO</option>
										</select>
									</td>

									<td class="separador"></td>
									<td class="label" rowspan="4">
										<label for="lblClavePresupuestal">Seleccionar Claves <br>Presupuestales: </label>
									</td>
									<td rowspan="4">
										<select MULTIPLE id="nomClavesPresupID" name="nomClavesPresupID" tabindex="10" size="15" cols="58" rows="8" style="width:350px"></select>
									</td>
								</tr>

								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lbPrioridad">Prioridad:</label>
									</td>
									<td nowrap="nowrap">
										<input type="text" id="prioridad" name="prioridad" size="20"  tabindex="11" onkeyPress="return validador(event)" autocomplete="off" />
									</td>
								</tr>
							</table>
							<br>
							<br>

							<table border="0" >
								<tr >
									<div id="gridClasifClavePresup" style="display: none;" ></div>
								</tr>
							</table>
							<br>
							<br>

							<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
								<tr>
									<td align="right">
										<input type="hidden" id="clavesPresupMod" name="clavesPresupMod" value=""/>
										<input type="hidden" id="clavesPresupBaj" name="clavesPresupBaj" value=""/>
										
										<input type="submit" id="grabaClsif" name="graba" class="submit" value="Grabar"  tabindex="12"/>
										<input type="submit" id="modificaClasif" name="modifica" class="submit" value="Modificar"  tabindex="13"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>

				</fieldset>
			</form:form>
		</div>


		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>
