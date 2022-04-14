<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		 <script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
		 <script type="text/javascript" src="dwr/interface/activoArrendaServicio.js"></script>
		 <script type="text/javascript" src="js/arrendamiento/vinculacionActivos.js"></script>	
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="activoArrendaBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Activos por Arrendamiento</legend>
				<table border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="1">
								<tr>
									<td class="label">
										<label for="lblArrendaID">N&uacute;mero: </label>
									</td> 
									<td>
										<input type="text" id="arrendaID" name="arrendaID" size="12" tabindex="1" maxlength="11" autocomplete="off"/>
									</td>
									<td class="separador">&nbsp;</td>
									<td class="label">
										<label for="lblCliente" id="lblCliente"><s:message code="safilocale.cliente"/>: </label>
									</td> 
									<td>
										<input id="clienteID" name="clienteID" type="text" size="12" readOnly="true" disabled="true"/>
										<input id="nombreCliente" name="nombreCliente" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
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
										<label for="lblEstatus" id="lblEstatus">Estatus: </label>
									</td>
									<td>
										<input id="estatus" name="estatus" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
									</td>	
								</tr>
														
								<tr>
									<td class="label">
										<label for="lblProductoArrenda" id="lblProductoArrenda">Producto: </label>
									</td>
									<td>
										<input id="productoArrendaID" name="productoArrendaID" type="text" size="12" readOnly="true" disabled="true"/>
										<input id="productoArrenda" name="productoArrenda" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
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
										<label for="lblMonto">Monto:</label>
									</td> 
									<td>
										<input id="monto" name="monto" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right" />
									</td>
									<td class="separador">&nbsp;</td>
									<td class="label">
										<label for="lblValorResidual">Valor Residual: </label>
									</td> 
									<td >
										<input id="valorResidual" name="valorResidual" type="text" readOnly="true" disabled="true" size="15" esMoneda="true" style="text-align: right"/>
									</td>
								</tr>
								
								<tr>
									<td class="label">
										<label for="lblTasaFijaAnual">Tasa: </label>
									</td> 
									<td >
										<input id="tasaFijaAnual" name="tasaFijaAnual" type="text" readOnly="true" disabled="true" size="15" esTasa="true" style="text-align: right"/>
									</td>
								</tr>
							</table>
							<br>
						</td>
					</tr>
					
					<tr>
						<td style="display: inline-block;">
							<!-- Activos -->
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="condiciones" style="display: inline-block;">
								<legend>Activos</legend>
								<table border="0" cellpadding="0" cellspacing="1">
									<tr>
										<td class="label">
											<label for="lblTipoActivo">Tipo de Activo: </label>
										</td> 
										<td>
											<select id="tipoActivo" name="tipoActivo" readOnly="true" tabindex="2">
												<option value="0">SELECCIONAR</option>
												<option value="1">AUTOS</option>
												<option value="2">MUEBLES</option>
											</select>
											<input type="hidden" id="tipo" name="tipo"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblActivoID">N&uacute;mero: </label>
										</td> 
										<td>
											<input type="text" id="activoID" name="activoID" size="12" tabindex="3" maxlength="11" autocomplete="off"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblDescripcion">Activo:</label>
										</td>
										<td>
											<input id="descripcion" name="descripcion" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										
										<td class="separador">&nbsp;</td>
										
										<td class="label">
											<label for="lblClasificacion">Clasificación:</label>
										</td>
										<td>
											<input id="subtipoActivo" name="subtipoActivo" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMarca">Marca: </label>
										</td> 
										<td>
											<input id="marca" name="marca" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										
										<td class="separador">&nbsp;</td>
										
										<td class="label">
											<label for="lblModelo">Modelo: </label>
										</td> 
										<td>
											<input id="modelo" name="modelo" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblNumSerie">Num. de Serie: </label>
										</td> 
										<td>
											<input id="numSerie" name="numSerie" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										
										<td class="separador">&nbsp;</td>
										
										<td class="label">
											<label for="lblNumFactura">Num. factura: </label>
										</td> 
										<td>
											<input id="numFactura" name="numFactura" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblValorFactura">Valor Factura: </label>
										</td> 
										<td>
											<input id="valorFactura" name="valorFactura" size="30" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
										</td>
										
										<td class="separador">&nbsp;</td>
										
										<td class="label">
											<label for="lblCostosAdicionales">Costos Adicionales: </label>
										</td> 
										<td>
											<input id="costosAdicionales" name="costosAdicionales" size="30" type="text" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblFechaAdquisicion">Fecha Adquisici&oacute;n: </label>
										</td> 
										<td>
											<input id="fechaAdquisicion" name="fechaAdquisicion" size="30" type="text" readOnly="true" disabled="true"/>
											<input type="hidden" id="plazoMaximo" name="plazoMaximo"/>
											<input type="hidden" id="porcentResidMax" name="porcentResidMax"/>
										</td>
									</tr>
									
									<tr>
										<td colspan="5" align="right">
											<input type="button" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="4"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					
					<tr>
						<!-- Activos ligados -->
						<td>
							<br><div id="contenedorActivosLigados" style="display: none;"></div>
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