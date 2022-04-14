<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/parametrosPLDServicio.js"></script>
	<script type="text/javascript" src="js/pld/parametrosPLD.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosPLDBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros &Oacute;rganos Supervisores</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<div>
								<table border="0" width="100%">
									<tr>
										<td class="label"><label for="lbFolio">Folio:</label></td>
										<td><form:input id="folioID" type="text" name="folioID" size="4" tabindex="1" path="folioID"/>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="fechaVigencia">Fecha Inicio Vigencia: </label></td>
										<td><form:input id="fechaVigencia" name="fechaVigencia"
											tabindex="2" disabled="true" type="text" value="" size="12" path="fechaVigencia"/>
										</td>
									</tr>
									<tr>										
										<td class="label">
											<label for="estatus">Estatus:</label>
										</td>
										<td>
						         			<form:select id="estatus" name="estatus" tabindex="3" disabled="true" path="estatus">
						         				<option value="">SELECCIONAR</option>
												<option value="V">VIGENTE</option>
												<option value="B">BAJA</option>		
											</form:select>  
			    			 			</td>
									</tr>
									<tr>
										<td class="label"><label for="claveEntCasfim">Clave de la Entidad Financiera: </label></td>
										<td><form:input id="claveEntCasfim" name="claveEntCasfim"
											tabindex="4"  type="text" value="" size="12" path="claveEntCasfim"/>
											<a href="javaScript:" onClick="ayudaClaveEntidad();">
												<img src="images/help-icon.gif">
											</a>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="claveOrgSupervisor">Clave
												del &Oacute;rgano Supervisor: </label></td>
										<td><form:input id="claveOrgSupervisor" name="claveOrgSupervisor" tabindex="5" type="text" value=""
												size="12" path="claveOrgSupervisor"/>
											<a href="javaScript:" onClick="ayuda();">
												<img src="images/help-icon.gif">
											</a>
										</td>
									</tr>
									<tr>
										<td class="label"><label for="claveOrgSupervisorExt">Clave de la Extensi&oacute;n del &Oacute;rgano Supervisor: </label></td>
										<td><form:input id="claveOrgSupervisorExt" name="claveOrgSupervisorExt" path="claveOrgSupervisorExt"
											tabindex="6" disabled="true" type="text" value="" size="12"/>
										</td>
									</tr> 
								</table>
							</div>
						</td>
					</tr>
				</table>
			</fieldset>
			<table border="0" width="100%">
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right"><input type="submit" id="grabar"
									name="grabar" class="submit" value="Grabar" tabindex="7" /> 
									<input type="submit" id="modifica" name="modifica" class="submit"
									value="Modificar" tabindex="8" /> 
									<input type="submit" id="baja" name="baja" class="submit"
									value="Baja" tabindex="9" /> 
									<input type="submit" id="historico" name="historico" class="submit"
									value="Historico" tabindex="10" />
									<input type="hidden"
									id="tipoTransaccion" name="tipoTransaccion" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="ContenedorAyuda" style="display: none;"></div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
