<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tiposActivosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/guiaContableActivosServicio.js"></script>
		<script type="text/javascript" src="js/activos/guiaContableActivos.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Guía Contable Activos</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentaMayorActivosBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>
						<table>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="conceptoActivoID">Concepto:</label>
								</td>
								<td nowrap="nowrap">
									<form:select id="conceptoActivoID" name="conceptoActivoID" path="conceptoActivoID" tabindex="1">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="cuenta">Cuenta:</label>
								</td>
								<td nowrap="nowrap">
									 <form:input type="text" id="cuenta" name="cuenta" path="cuenta" size="30" tabindex="2" autocomplete="off"/>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblnomenclatura">Nomenclatura:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="nomenclatura" name="nomenclatura" path="nomenclatura" size="30" tabindex="3" autocomplete="off" />
									<a href="javaScript:" onClick="ayuda('nomenclatura');">
										<img src="images/help-icon.gif" >
									</a>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblClaves"><b>Claves de Nomenclatura Activos:
									<i>
										<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor</a>
										<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TA');return false;">  &TA = SubCuenta por Tipo de Activo</a>
										<br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TS');return false;">  &TS = SubCuenta por Clasificación de Activo</a>
									</i>
									</label>
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="nomenclaturaCC">Nomenclatura Centro Costo:</label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="nomenclaturaCC" name="nomenclaturaCC" path="nomenclaturaCC"  size="30" tabindex="4" autocomplete="off" />
									<a href="javaScript:" onClick="ayuda('nomenclaturaCC');">
										<img src="images/help-icon.gif" >
									</a>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo:
									<i>
										<br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCC','&SO');return false;">  &SO = Sucursal Origen </a>
										<br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCC','&SA');return false;">  &SA = Sucursal Activo </a></b>
									</i>
									</label>
								</td>
							</tr>
						</table>
						<br></br>
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar"  tabindex="5"/>
									<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="6"/>
									<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="7"/>
									<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value=""/>
								</td>
							</tr>
						</table>
					</fieldset>
				</form:form>
				<br>
				<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="cuentaMayorActivosBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Activo</legend>
						<table>
							<tr>
								<td class="label">
									<label for="tipoActivoID">Tipo Activo:</label>
								</td>
								<td>
									<input type="text" id="tipoActivoID" name="tipoActivoID" path="tipoActivoID" size="20" tabindex="8" autocomplete="off" />
									<input type="text" id="descripcionActivo" name="descripcionActivo"  size="60" disabled="true" readonly="true">
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="subCuenta">SubCuenta:</label>
								</td>
								<td>
									<input type="text" id="subCuenta" name="subCuenta" path="subCuenta" size="20" tabindex="9" maxlength="15" autocomplete="off"/>
								</td>
							</tr>
						</table>
						<br></br>
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabaSC" name="grabaSC" class="submit" value="Grabar"  tabindex="10"/>
									<input type="submit" id="modificaSC" name="modificaSC" class="submit" value="Modificar" tabindex="11"/>
									<input type="submit" id="eliminaSC" name="eliminaSC" class="submit" value="Eliminar" tabindex="12"/>
									<input type="hidden" id="tipoTransaccionSC" name="tipoTransaccionSC" value=""/>
									<input type="hidden" id="conceptoActivoID2" name="conceptoActivoID2" value=""/> 
								</td>
							</tr>
						</table>
					</fieldset>
				</form:form>
				<br>
				<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="cuentaMayorActivosBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Por Subclasificación de Activo</legend>
						<table>
							<tr>
								<td class="label">
									<label for="tipoActivoID">Tipo Activo:</label>
								</td>
								<td>
									<input type="text" id="tipoActivoID3" name="tipoActivoID3" size="20" tabindex="13" autocomplete="off" />
									<input type="text" id="descripcionActivo3" name="descripcionActivo3"  size="60" disabled="true" readonly="true">
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="subCuenta">SubCuenta:</label>
								</td>
								<td>
									<input type="text" id="subCuenta3" name="subCuenta3" size="20" tabindex="14" maxlength="15" autocomplete="off"/>
								</td>
							</tr>
						</table>
						<br></br>
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabaCA" name="grabaCA" class="submit" value="Grabar"  tabindex="15"/>
									<input type="submit" id="modificaCA" name="modificaCA" class="submit" value="Modificar" tabindex="16"/>
									<input type="submit" id="eliminaCA" name="eliminaCA" class="submit" value="Eliminar" tabindex="17"/>
									<input type="hidden" id="tipoTransaccionCA" name="tipoTransaccionCA" value=""/>
									<input type="hidden" id="conceptoActivoID3" name="conceptoActivoID3" value=""/> 
								</td>
							</tr>
						</table>
					</fieldset>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>