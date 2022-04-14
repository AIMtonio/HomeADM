<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/paramPLDOpeEfecServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="js/pld/paramOperEfectivo.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramPLDOpeEfecBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros en Operaciones en Efectivo</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<div>
								<table border="0" width="100%">
									<tr>
										<td class="label"><label for="lbFolio">Folio:</label></td>
										<td><input id="folioID" type="text" name="folioID" size="4" tabindex="1" />
										</td>
									</tr>
									<tr>
										<td class="label"><label for="fechaVigencia">Fecha Inicio Vigencia: </label></td>
										<td><input id="fechaVigencia" name="fechaVigencia"
											tabindex="2" disabled="disabled" type="text" value="" size="12">
										</td>
									</tr>
									<tr>										
										<td class="label">
											<label for="estatus">Estatus:</label>
										</td>
										<td>
						         			<select id="estatus" name="estatus" tabindex="14" disabled="true">
						         				<option value="">SELECCIONAR</option>
												<option value="V">VIGENTE</option>
												<option value="B">BAJA</option>		
											<select>  
			    			 			</td> 
									</tr>
								</table>
								<br>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div id="remesas">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend >Transferencias Internacionales de Fondos</legend>
									<table border="0" width="100%">
										<tr>
											<td class="label"><label for="remesaMonedaID">Moneda: </label></td>
											<td><form:select id="remesaMonedaID" name="remesaMonedaID"
													path="remesaMonedaID" tabindex="6" type="select">
													<form:option value="">SELECCIONAR</form:option>
												</form:select></td>
										</tr>
										<tr>
											<td class="label"><label for="montoRemesaUno">L&iacute;mite Primer Nivel: </label></td>
											<td><form:input id="montoRemesaUno" name="montoRemesaUno"
													path="" size="20" tabindex="7" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
										<tr>
											<td class="label"><label for="montoRemesaDos">L&iacute;mite Segundo Nivel: </label></td>
											<td><form:input id="montoRemesaDos" name="montoRemesaDos"
													path="" size="20" tabindex="8" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
										<tr>
											<td class="label"><label for="montoRemesaTres">L&iacute;mite Tercer Nivel: </label></td>
											<td><form:input id="montoRemesaTres" name="montoRemesaTres"
													path="" size="20" tabindex="9" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
								   </table>
						<br>
								</fieldset>
		<br>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div id="operEfectivo">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend>L&iacute;mites de Operaciones en Efectivo Mensual por <s:message code="safilocale.cliente"/></legend>
									<table border="0" width="100%">
										<tr>
											<td class="label"><label for="montoLimMonedaID">Moneda: </label></td>
											<td><form:select id="montoLimMonedaID" name="montoLimMonedaID"
													path="" tabindex="10" type="select">
													<form:option value="">SELECCIONAR</form:option>
												</form:select></td>
										</tr>
										<tr>
											<td class="label"><label for="montoLimEfecF">L&iacute;mite Personas F&iacute;sicas: </label></td>
											<td><form:input id="montoLimEfecF" name="montoLimEfecF"
													path="" size="20" tabindex="11" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
										<tr>
											<td class="label"><label for="montoLimEfecM">L&iacute;mite Personas Morales: </label></td>
											<td><form:input id="montoLimEfecM" name="montoLimEfecM"
													path="" size="20" tabindex="12" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
										<tr>
											<td class="label"><label for="montoLimEfecMes">L&iacute;mite Personas F&iacute;sicas - Morales: </label></td>
											<td><form:input id="montoLimEfecMes" name="montoLimEfecMes"
													path="" size="20" tabindex="13" esMoneda="true"
													style="text-align:right;" maxlength="13" /></td>
										</tr>
								   </table>
		<br>
								</fieldset>
		<br>
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
									name="grabar" class="submit" value="Grabar" tabindex="15" /> 
									<input type="submit" id="modifica" name="modifica" class="submit"
									value="Modificar" tabindex="16" /> 
									<input type="submit" id="baja" name="baja" class="submit"
									value="Baja" tabindex="17" /> 
									<input type="submit" id="historico" name="historico" class="submit"
									value="Historico" tabindex="18" />
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>
