<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/arrendaAmortiServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/movimientosCargoAbonoArrendaServicio.js"></script>
		<script type="text/javascript" src="js/arrendamiento/cargosArrendamiento.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargoAbonoArrendaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Cargos y Abonos Manuales de Arrendamiento</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="1" width="100%">
								<tr>
									<td class="label">
										<label for="lblArrendaID">N&uacute;mero de Arrendamiento: </label>
									</td> 
									<td>
										<input type="text" id="arrendaID" name="arrendaID" size="12" tabindex="1" maxlength="12"/>
										<input type="hidden" id="tipoListaAmorti" name="tipoListaAmorti"/>
									</td>
								</tr>
											
								<tr>
									<td class="label">
										<label for="lblTipoArrenda" id="lblTipoArrenda">Tipo de Arrendamiento: </label>
									</td>
									<td>
										<input id="tipoArrenda" name="tipoArrenda" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
									<td class="separador">&nbsp;</td>									
									<td class="label">
										<label for="lblCliente" id="lblCliente"><s:message code="safilocale.cliente"/>: </label>
									</td> 
									<td>
										<input id="nombreCliente" name="nombreCliente" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
								</tr>
														
								<tr>
									<td class="label">
										<label for="lblProductoArrenda" id="lblProductoArrenda">Producto: </label>
									</td>
									<td>
										<input id="productoArrendaDescri" name="productoArrendaDescri" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="label">
										<label for="lblEstatus" id="lblEstatus">Estatus: </label>
									</td>
									<td>
										<input id="estatus" name="estatus" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>	
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblMonto">Monto:</label>
									</td> 
									<td>
										<input id="montoArrenda" name="montoArrenda" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
									</td>
									<td class="separador">&nbsp;</td>
									<td class="label">
										<label for="lblFechaApertura">Fecha de Apertura: </label>
									</td> 
									<td >
										<input id="fechaApertura" name="fechaApertura" type="text" readOnly="true" disabled="true" size="15"/>
									</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblTasaFijaAnual">Tasa: </label>
									</td> 
									<td >
										<input id="tasaFijaAnual" name="tasaFijaAnual" type="text" readOnly="true" disabled="true" size="15" esTasa="true" style="text-align: right"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="label">
										<label for="lblValorResidual">Valor Residual: </label>
									</td> 
									<td >
										<input id="montoResidual" name="montoResidual" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
									</td>
								</tr>
							</table>
							<br>
						</td>
					</tr>					
					
					<tr>
						<td>
							<!-- CARGOS -->
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="condiciones">                
								<legend>Conceptos cargo/abono</legend>
								<table border="0" cellpadding="0" cellspacing="1" width="100%">
									<tr>
										<td class="label">
											<label for="lblTipoConcepto">Tipo de Concepto:</label>
										</td> 
										<td>
											<select id="tipoConcepto" name="tipoConcepto" tabindex="2">
												<option value="0">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblDescripcion">Descripci&oacute;n: </label>
										</td> 
										<td>
											<input id="descriConcepto" name="descriConcepto" size="30" type="text" tabindex="3" onBlur="ponerMayusculas(this)" maxlength="100"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblCuota">Cuota:</label>
										</td>
										<td>
											<select id="cuota" name="cuota" tabindex="4">
												<option value="0">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblNaturaleza">Naturaleza: </label>
										</td> 
										<td>
											<select id="naturaleza" name="naturaleza" tabindex="5">
												<option value="0">SELECCIONAR</option>
												<option value="C">Cargo</option>
												<option value="A">Abono</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMontoCargoAbono">Monto:</label>
										</td> 
										<td>
											<input id="montoConcepto" name="montoConcepto" type="text" size="15" tabindex="6" esMoneda="true" style="text-align: right" maxlength="20"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="separador">&nbsp;</td>
										<td class="separador">&nbsp;</td>
									</tr>
									
									<tr>
										<td class="separador">&nbsp;</td>
										<td class="separador">&nbsp;</td>
										<td class="separador">&nbsp;</td>
										<td class="separador">&nbsp;</td>
										<td align="right">
											<div id="contenedorBotoAgregar" style="text-align: right;">
												<input type="button" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="7"/>
												<input type="hidden" id="numTab"/>
												<input type="hidden" id="numeroFila"/>
											</div>
										</td> 
									</tr>
								</table>
								
								<div id="contenedorCargosAbonos" style="display: none;">
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<table id="tablaConceptosCA" border="0" cellpadding="0" cellspacing="1" width="100%" style="display:block; overflow:auto;">
												<tr>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblFechaMovimiento" style="color: #ffffff">Fecha Registro</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblUsuarioMovimiento" style="color: #ffffff">Usuario</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblArrendaAmortiID" style="color: #ffffff">Cuota</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblTipoConcepto" style="color: #ffffff">Tipo de Concepto</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblDescriConcepto" style="color: #ffffff">Descripci&oacute;n</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblMontoConcepto" style="color: #ffffff">Monto</label></td>
									                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblNaturaleza" style="color: #ffffff">Naturaleza</label></td>
									            </tr>
									         </table>
									         
									  </fieldset>							
								</div>
								<div id="contenedorBotonGrabar" style="display: none;text-align: right;">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="8"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								</div>
							</fieldset>
						</td>
					</tr>
					
					<tr>
						<td>
							<br>
							<div id="contenedorMovimientos" style="display: none;"></div>
						</td>
					</tr>
					
					<tr>
						<td>
							<br>
							<div id="contenedorAmortizaciones" style="display: none;"></div>
						</td>
					</tr>
					
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;">
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>