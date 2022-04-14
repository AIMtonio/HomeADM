<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/activoArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/subtipoActivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/marcaActivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/aseguradoraActivoServicio.js"></script>
		<script type="text/javascript" src="js/arrendamiento/catalogoActivos.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="activoBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo de Activos</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<!-- Datos generales -->
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">               
								<legend>Datos Generales</legend>
								<table border="0" cellpadding="0" cellspacing="1" width="100%">
									<tr>
									<td class="label">
											<label for="lblTipoActivo">Tipo de Activo: </label>
										</td> 
										<td>
											<select id="tipoActivo" name="tipoActivo" tabindex="1">
												<option value="0">SELECCIONAR</option>
												<option value="1">AUTOM&Oacute;VILES</option>
												<option value="2">MUEBLES</option>
											</select>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblActivoID">Activo: </label>
										</td> 
										<td>
											<input type="text" id="activoID" name="activoID" size="12" tabindex="2" maxlength="12" autoComplete="off"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblDescripcion">Descripci&oacute;n:</label>
										</td>
										<td>
											<input id="descripcion" name="descripcion" size="30" type="text" tabindex="3" onBlur="ponerMayusculas(this)" maxlength="150"/>
										</td>										
										<td class="separador">&nbsp;</td>	
										<td class="label">
											<label for="lblsubtipoActivoID">Subtipo: </label>
										</td> 
										<td>
											<input id="subtipoActivoID" name="subtipoActivoID" type="text" size="12" tabindex="4" maxlength="12" autoComplete="off"/>
											<input id="subtipoActivo" name="subtipoActivo" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblMarca">Marca: </label>
										</td> 
										<td>
											<input id="marcaID" name="marcaID" type="text" size="12" tabindex="5" maxlength="12" autoComplete="off"/>
											<input id="marca" name="marca" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblModelo">Modelo: </label>
										</td> 
										<td>
											<input id="modelo" name="modelo" size="30" type="text" tabindex="6" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lbNumeroSerie">Num. de Serie: </label>
										</td> 
										<td>
											<input id="numeroSerie" name="numeroSerie" size="30" type="text" tabindex="7" onBlur="ponerMayusculas(this)" maxlength="45"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblNumeroFactura">Num. factura: </label>
										</td> 
										<td>
											<input id="numeroFactura" name="numeroFactura" size="30" type="text" tabindex="8" onBlur="ponerMayusculas(this)" maxlength="10"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblValorFactura">Valor Factura: </label>
										</td> 
										<td>
											<input id="valorFactura" name="valorFactura" size="30" type="text" tabindex="9" esMoneda="true" style="text-align: right" maxlength="20" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblCostosAdicionales">Costos Adicionales: </label>
										</td> 
										<td>
											<input id="costosAdicionales" name="costosAdicionales" size="30" type="text" tabindex="10" esMoneda="true" style="text-align: right" maxlength="20" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
										</td>
									</tr>
									<tr>									
										<td class="label">
											<label for="lblFechaAdquisicion">Fecha Adquisici&oacute;n: </label>
										</td> 
										<td>
											<input id="fechaAdquisicion" name="fechaAdquisicion" size="30" type="text" tabindex="11" esCalendario="true"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblVidaUtil">Vida &Uacute;til(Meses): </label>
										</td> 
										<td>
											<input id="vidaUtil" name="vidaUtil" size="30" type="text" tabindex="12" onkeypress="return ingresaSoloNumeros(event,1,this.id);" maxlength="10"/>
										</td>
									</tr>
									
									<tr>									
										<td class="label">
											<label for="lblPorcentDepreFis">Depreciaci&oacute;n Fiscal(%): </label>
										</td> 
										<td>
											<input id="porcentDepreFis" name="porcentDepreFis" size="30" type="text" tabindex="13" esMoneda="true" style="text-align: right" maxlength="6" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblPorcentDepreAjus">Depreciaci&oacute;n Ajustada(%): </label>
										</td> 
										<td>
											<input id="porcentDepreAjus" name="porcentDepreAjus" size="30" type="text" tabindex="14" esMoneda="true" style="text-align: right" maxlength="6" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
										</td>
									</tr>

									<tr>									
										<td class="label">
											<label for="lblPlazoMaximo">Plazo M&aacute;ximo(Meses): </label>
										</td> 
										<td>
											<input id="plazoMaximo" name="plazoMaximo" size="30" type="text" tabindex="15" onkeypress="return ingresaSoloNumeros(event,1,this.id);" maxlength="10"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblPorcentResidMax">Residual M&aacute;ximo(%): </label>
										</td> 
										<td>
											<input id="porcentResidMax" name="porcentResidMax" size="30" type="text" tabindex="16" esMoneda="true" style="text-align: right" maxlength="6" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
										</td>
									</tr>
									
									
									<tr>									
										<td class="label">
											<label for="lblEstatus">Estatus de Activo: </label>
										</td> 
										<td>
											<select id="estatus" name="estatus" tabindex="17">
												<option value="0">SELECCIONAR</option>
												<option value="A">ACTIVO</option>
												<option value="B">BAJA</option>
												<option value="I">INACTIVO</option>
												<option value="L">LIGADO/ASOCIADO</option>
											</select>
										</td>
									</tr>
									
								</table>
							</fieldset>
							<br>
						</td>
					</tr>					
					
					<!-- Direccion -->
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">               
								<legend>Direcci&oacute;n</legend>
								<table border="0" cellpadding="0" cellspacing="1" width="100%">
									<tr>
										<td class="label">
											<label for="lblEstadoID">Entidad: </label>
										</td> 
										<td>
											<input id="estadoID" name="estadoID" type="text" size="12" tabindex="18" maxlength="12" autoComplete="off"/>
											<input id="estado" name="estado" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblMunicipio">Municipio: </label>
										</td> 
										<td>
											<input id="municipioID" name="municipioID" type="text" size="12" tabindex="19" maxlength="12" autoComplete="off"/>
											<input id="municipio" name="municipio" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblLocalidad">Localidad: </label>
										</td> 
										<td>
											<input id="localidadID" name="localidadID" type="text" size="12" tabindex="20" maxlength="12" autoComplete="off"/>
											<input id="localidad" name="localidad" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblColonia">Colonia: </label>
										</td> 
										<td>
											<input id="coloniaID" name="coloniaID" type="text" size="12" tabindex="21" maxlength="12" autoComplete="off"/>
											<input id="colonia" name="colonia" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblCalle">Calle: </label>
										</td> 
										<td>
											<input id="calle" name="calle" type="text" size="30" tabindex="22" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblNumeroCasa">N&uacute;mero: </label>
										</td> 
										<td>
											<input id="numeroCasa" name="numeroCasa" type="text" size="12" tabindex="23" onBlur="ponerMayusculas(this)" maxlength="10"/>
											
											<label for="lblNumeroInterior">Interior: </label>
											<input id="numeroInterior" name="numeroInterior" type="text" size="12" tabindex="24" onBlur="ponerMayusculas(this)" maxlength="10"/>
											
											<label for="lblPiso">Piso: </label>
											<input id="piso" name="piso" type="text" size="12" tabindex="25" onBlur="ponerMayusculas(this)" maxlength="50"/>
											
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblPrimerEntrecalle">Primer Entre Calle: </label>
										</td> 
										<td>
											<input id="primerEntrecalle" name="primerEntrecalle" size="30" type="text" tabindex="26" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
										<td class="separador">&nbsp;</td>
										<td class="label">
											<label for="lblSegundaEntreCalle">Segunda Entre Calle: </label>
										</td> 
										<td>
											<input id="segundaEntreCalle" name="segundaEntreCalle" size="30" type="text" tabindex="27" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblCodigoPostal">C&oacute;digo Postal: </label>
										</td> 
										<td>
											<input id="cp" name="cp" size="30" type="text" tabindex="28" readOnly="true" disabled="true" maxlength="5"/>
										</td>
										<td class="separador">&nbsp;</td>										
										<td class="label">
											<label for="lblLatitud">Latitud: </label>
										</td> 
										<td>
											<input id="latitud" name="latitud" size="30" type="text" tabindex="29" onBlur="ponerMayusculas(this)" maxlength="45"/>
										</td>
									</tr>
									
									<tr>
										<td class="label">
											<label for="lblLongitud">Longitud: </label>
										</td> 
										<td>
											<input id="longitud" name="longitud" size="30" type="text" tabindex="30" onBlur="ponerMayusculas(this)" maxlength="45"/>
										</td>
										<td class="separador">&nbsp;</td>										
										<td class="label">
											<label for="lblLote">Lote: </label>
										</td> 
										<td>
											<input id="lote" name="lote" size="30" type="text" tabindex="31" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
									</tr>
									
									<tr>									
										<td class="label">
											<label for="lblManzana">Manzana: </label>
										</td> 
										<td>
											<input id="manzana" name="manzana" size="30" type="text" tabindex="32" onBlur="ponerMayusculas(this)" maxlength="50"/>
										</td>
										<td class="separador">&nbsp;</td>	
										<td class="label">
											<label for="lblDescripcionDom">Descripci&oacute;n: </label>
										</td> 
										<td>
											<textarea id="descripcionDom" name="descripcionDom" rows="4" cols="30" tabindex="33" maxlength="200" onBlur="ponerMayusculas(this)" style="resize: none;" >
											</textarea>
										</td>
									</tr>
								</table>
							</fieldset>
							<br>
						</td>
					</tr>
					
					<!-- Aseguradora -->
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">               
								<legend>Aseguradora</legend>
								<table border="0" cellpadding="0" cellspacing="1" width="28%">
									<tr>
										<td class="label">
											<label for="lblEstaAsegurado">Asegurado: </label>
										</td> 
										<td >
											<input type="radio" id="estaAseguradoSi" name="estaAseguradoSi" value="S" tabindex="34"/>
											<label for="si">Si</label>&nbsp;
											
											<input type="radio" id="estaAseguradoNo" name="estaAseguradoNo" value="N" tabindex="35"/>
											<label for="no">No</label>
											<input type="hidden" id="estaAsegurado" name="estaAsegurado"/>
										</td>
									</tr>
								</table>
								<div id="secAseguradora" style="display: none;"  >
									<table border="0" cellpadding="0" cellspacing="1" width="100%">
										<tr>
											<td class="label">
												<label for="lblAseguradora">Aseguradora: </label>
											</td> 
											<td>
												<input id="aseguradoraID" name="aseguradoraID" type="text" size="12" tabindex="36" maxlength="12" autoComplete="off"/>
												<input id="aseguradora" name="aseguradora" size="30" type="text" readOnly="true" disabled="true" onBlur="ponerMayusculas(this)"/>
											</td>
											<td class="separador">&nbsp;</td>
											<td class="label">
												<label for="lblFechaAdquiSeguro">Fecha Adquisici&oacute;n: </label>
											</td> 
											<td>
												<input id="fechaAdquiSeguro" name="fechaAdquiSeguro" size="30" type="text" tabindex="37" esCalendario="true"/>
											</td>
										</tr>
										
										<tr>
											<td class="label">
												<label for="lblInicioCoberSeguro">Inicio Cobertura: </label>
											</td> 
											<td>
												<input id="inicioCoberSeguro" name="inicioCoberSeguro" size="30" type="text" tabindex="38" esCalendario="true"/>
											</td>
											<td class="separador">&nbsp;</td>
											<td class="label">
												<label for="lblFinCoberSeguro">Fin de Cobertura: </label>
											</td> 
											<td>
												<input id="finCoberSeguro" name="finCoberSeguro" size="30" type="text" tabindex="39" esCalendario="true"/>
											</td>
										</tr>
										
										<tr>									
											<td class="label">
												<label for="lblNumPolizaSeguro">Num. P&oacute;liza: </label>
											</td> 
											<td>
												<input id="numPolizaSeguro" name="numPolizaSeguro" size="30" type="text" tabindex="40" onBlur="ponerMayusculas(this)" maxlength="20"/>
											</td>
											<td class="separador">&nbsp;</td>
											<td class="label">
												<label for="lblSumaAseguradora">Suma Asegurada: </label>
											</td> 
											<td>
												<input id="sumaAseguradora" name="sumaAseguradora" size="30" type="text" tabindex="41" esMoneda="true" style="text-align: right" maxlength="20" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
											</td>
										</tr>
										
										<tr>
											<td class="label">
												<label for="lblValorDeduciSeguro">Valor Deducible: </label>
											</td> 
											<td>
												<input id="valorDeduciSeguro" name="valorDeduciSeguro" size="30" type="text" tabindex="42" esMoneda="true" style="text-align: right" maxlength="20" onkeypress="return ingresaSoloNumeros(event,3,this.id);"/>
											</td>
											<td class="separador">&nbsp;</td>										
											<td class="label">
												<label for="lblObservaciones">Descripci&oacute;n: </label>
											</td> 
											<td>
												<textarea id="observaciones" name="observaciones" rows="4" cols="30" tabindex="43" maxlength="200" onBlur="ponerMayusculas(this)" style="resize: none;" >
												</textarea>
											</td>
										</tr>
									</table>
								</div>
							</fieldset>
						</td>
					</tr>
					
					<!-- Botones -->
					<tr>
						<td align="right">
							<div id="contenedorBotones">
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="44"/>
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="44"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</div>
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