<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/seguimientoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/catTiposGestionServicio.js"></script>
		<script type="text/javascript" src="js/seguimiento/seguimientoVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="seguimientoBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Definici&oacute;n de Seguimiento</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Datos Generales</legend>
						<table border="0"  width="100%">
						 	<tr>
	 							<td class="label">
									<label for="seguimiendoID">No. Seguimiento: </label>
								</td>
								<td>
									<form:input id="seguimientoID" name="seguimientoID" tabindex="1" path="seguimientoID" size="5" autocomplete="off" maxlength="11"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblDescripcion">Descripci&oacute;n: </label>
								</td>
								<td>
									<form:input id="descripcion" name="descripcion" path="descripcion" onBlur="ponerMayusculas(this)" tabindex="2" size="55" maxlength="150" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblCategoria">Categor&iacute;a:</label>
								</td>
								<td>
									<form:input id="categoriaID" name="categoriaID" path="categoriaID" tabindex="3" size="5"/> 
									<input type="text" id="descCategoria" name="descCategoria" path="descCategoria" size="70" disabled="true"  maxlength="11"/>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblCicloIni">Ciclo Cliente Inicio:</label>
								</td>
								<td>
									<form:input id="cicloCteInicio" name="cicloCteInicio" path="cicloCteInicio" tabindex="4" size="5" onkeypress="validaSoloNumeros();" maxlength="11"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Estatus:</label>
								</td>
								<td>
									<select id="estatus" name="estatus" path="estatus" tabindex="5" >
									    <option value="">SELECCIONAR</option>
										<option value="V">VIGENTE</option>
										<option value="C">CANCELADO</option>
									</select>
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblCicloFin">Ciclo Cliente Fin:</label>
								</td>
								<td>
									<form:input id="cicloCteFinal" name="cicloCteFinal" path="cicloCteFinal" tabindex="6" size="5" onkeypress="validaSoloNumeros();" maxlength="11"/> 
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Tipo Gesti&oacute;n:</label>
								</td>
								<td>
									<form:input id="ejecutorID" name="ejecutorID" path="ejecutorID" size="5" tabindex="7"  maxlength="11"/>  
									<input type="text" id="descejecutorID" name="descejecutorID" size="70" disabled="true" readOnly="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Producto de Cr&eacute;dito:</label>
								</td>
								<td>
									<select MULTIPLE id="productosID" name="productosID" path="productosID" tabindex="8" size="11">
					      			</select>
								</td>
							</tr>
							<tr>
								<td class="label" colspan="6">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend>Aplicaci&oacute;n</legend>
										<table border="0"  width="100%">
											<tr>
												<td class="label">
													<label>Base:</label>
												</td>
												<td class="label">
													<table>
													<tr>
														<td>
															<input type="radio" id="porcentaje" name="base" path="base" value="P" tabindex="9"/><label>Porcentaje</label>
															<input type="text" id="basePorcentaje" name="basePorcentaje" path="basePorcentaje" size="5" tabindex="10" onkeypress="validaSoloNumeros()" maxlength="11"/><label>%</label>
														</td>
													</tr>
													<tr>
														<td>
															<input type="radio" id="numero" name="base" path="base" value="N" tabindex="11"/><label>Número</label>
															<input type="text" id="baseNumero" name="baseNumero" path="baseNumero" size="5" tabindex="12" onkeypress="validaSoloNumeros()" maxlength="11"/>
														</td>
													</tr>
												</table>
												</td>
													<td class="label">
														<label>Estado de Cartera:</label>
													</td>
														<td class="label">
														<table>
															<tr>
																<td>
																	<input type="checkbox" id="aplicaCarteraVig" name="aplicaCarteraVig" path="aplicaCarteraVig" tabindex="13" value="S"/><label>Vigente</label>
																</td>
																<td>
																	<input type="checkbox" id="aplicaCarteraAtra" name="aplicaCarteraAtra" path="aplicaCarteraAtra" tabindex="14" value="S"/><label>Atrasada</label>
																</td>
															</tr>
															<tr>
																<td>
																	<input type="checkbox" id="aplicaCarteraVen" name="aplicaCarteraVen" path="aplicaCarteraVen" tabindex="15" value="S"/><label>Vencida</label>
																</td>
																<td>
																	<input type="checkbox" id="carteraNoAplica" name="carteraNoAplica" path="carteraNoAplica" tabindex="16" value="N"/><label>No Aplica</label>
																</td>
															</tr>
														</table>
													</td>
												<tr>
												<td class="label">
													<label>Nivel de Aplicaci&oacute;n:</label>
												</td>
												<td class="label">
													<table>
														<tr>
															<td>
																<input type="radio" id="nivelGlobal" name="nivelAplicacion" path="nivelAplicacion" tabindex="17" value="G"/><label>Global</label>
															</td>
															<td>
																<input type="radio" id="nivelRegion" name="nivelAplicacion" path="nivelAplicacion" tabindex="18" value="R"/><label>Plazas</label>
															</td>
														</tr>
														<tr>
															<td>
																<input type="radio" id="nivelSucursal" name="nivelAplicacion" path="nivelAplicacion" tabindex="19" value="S"/><label>Sucursal</label>
															</td>
															<td>
																<input type="radio" id="nivelOficial" name="nivelAplicacion" path="nivelAplicacion" tabindex="20" value="O"/><label>Ejecutivo</label>
															</td>
														</tr>
													</table>
												</td>
												<td class="label">
													<label>Permite Generaci&oacute;n Manual:</label>
												</td>
												<td class="label">
													<input type="radio" id="generaManualSI" name="permiteManual" path="permiteManual" value="S" tabindex="21"/><label>Si</label>
													<input type="radio" id="generaManualNO" name="permiteManual" path="permiteManual" value="N" tabindex="22"/><label>No</label>
												</td>
											</tr>											
										</table>
									</fieldset>
								</td>
							</tr>
						</table>
					</fieldset>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Alcance</legend>
						<table border="0"  width="100%">
							<tr>
								<td>
									<input type="radio" id="alcGlobal" name="alcance" path="alcance" value="G" tabindex="23" /><label>Global</label>
									<input type="radio" id="alcPlazas" name="alcance" path="alcance" value="P" tabindex="24" /><label>Plazas</label>
									<input type="radio" id="alcSucursal" name="alcance" path="alcance" value="S" tabindex="25" /><label>Sucursal</label>
									<input type="radio" id="alcEjecutivo" name="alcance" path="alcance" value="E" tabindex="26" /><label>Ejecutivo</label>
								</td>
							</tr>
						</table>
						<div id="contenedorPlazas" style="overflow: scroll; width: 100%; height: 200px;display: none;"></div>
						<div id="contenedorSucursal" style="overflow: scroll; width: 100%; height: 200px;display: none;"></div>
						<div id="contenedorEjecutivo" style="overflow: scroll; width: 100%; height: 200px;display: none;"></div>
					</fieldset>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Fondeadores</legend>
							<div id="contenedorFondeador" style="overflow: scroll; width: 100%; height: 150px;"></div>
					</fieldset>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Selecci&oacute;n</legend>	
						<table border="0"  width="100%">
							<tr>
								<td><input type="button" id="agregaSelect" value="Agrega" class="botonGral" onclick="agregaElementoSeleccion()" tabindex="27"/></td>
							</tr>
						</table>
					 <table border="0" width="85%">
							<tr>
								<td>
									<label>Compuerta</label>									
								</td>
								<td>
									<label>Condici&oacute;n</label>
								</td>
								<td>
									<label>Operador</label>
								</td>
								<td>
									<label>Condici&oacute;n</label>									
								</td>
							</tr>
						</table>  
						<table id="tableSelec" border="0"  width="100%"> 
							<input type="hidden" id="numSelect" name="numSelect" />
							
						</table>
					</fieldset>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Programaci&oacute;n</legend>
						<table>
							<tr>
								<td><input type="button" id="agregaProgra" value="Agrega" class="botonGral" onclick="agregaElementoPrograma()" tabindex="28"/></td>
							</tr>
						</table>
						<table id="tablePrograma" name="tablePrograma">
							<input type="hidden" id="numProgram" name="numProgram" />							
						</table>
					</fieldset>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="label">Clasificaci&oacute;n</legend>
						<table border="0"  width="100%">
							<tr>
								<td><input type="button" id="agregaClasifica" value="Agrega" class="botonGral" onclick="agregaElementoClasifica()" tabindex="29"/></td>
							</tr>
						</table>
						<table border="0"  width="100%">
							<tr>
								<td><label>Nivel</label></td>
								<td><label>Condici&oacute;n</label>&nbsp;&nbsp;</td>
								<td><label>Operador</label></td>
							</tr>
						</table>
						<table id="tableClasifica" border="0"  width="100%">
							<input type="hidden" id="numClasifica" name="numClasifica" />
						</table>
					</fieldset>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="30"/>
								<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="31"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="lisPlazas" name="lisPlazas" path="lisPlazas"/>
								<input type="hidden" id="lisSucursal" name="lisSucursal" path="lisSucursal"/>
								<input type="hidden" id="lisEjecutivo" name="lisEjecutivo" path="lisEjecutivo"/>
								<input type="hidden" id="lisFondeo" name="lisFondeo" path="lisFondeo"/>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>