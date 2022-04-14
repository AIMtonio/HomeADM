<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/mensaje.css" media="all"  >
	<!-- dwr def -->
	<script type="text/javascript" src="dwr/interface/pslConfigServicioServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/pslConfigProductoServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/pslParamBrokerServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>  

	<script type="text/javascript" src="js/psl/pslConfigServicio.js"></script>
	<script type="text/javascript" src="js/general.js"></script>
	
	
<title>Servicios En Linea</title>
</head>
<body>
 <div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Servicios En Línea</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pslConfigServicioBean" >
			<table>
			<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all" style="height: 280px;">
						<legend >Servicios disponibles por el proveedor</legend>
						<table>
							<tr>
								<td class="label"><label>Fecha última actualización:</label><label id="fechaUltimaActualizacion"></label></td>
							</tr>
						</table>
						<div id="divConfigServicios" style="height: 200px;">					
						</div>	<br>
						<input type="submit" class="submit" id="btnActualizarServicios" tabindex="1" value="Actualizar Lista"/>
					</fieldset>	
				</td>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all" style="overflow: auto; height: 280px;">
						<legend >Configuración del Servicio</legend>
						<table>
							<tr>
								<td class="label"><label for="txtServicioID">Servicio:</label></td>
								<td>
									<input type="hidden" id="servicioID" name="servicioID"/>
									<input type="text" id="txtServicioID" size="5" disabled="disabled">
									<input type="text" id="servicio" size="50" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="nomClasificacion">Tipo de Servicio:</label></td>
								<td>
									<input type="hidden" id="clasificacionServ" name="clasificacionServ"/>
									<input type="text" id="nomClasificacion" size="56"disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="cContaServicio">Cta. Contable Servicio:</label></td>
								<td>
									<input type="text" id="cContaServicio" name="cContaServicio" size="56" maxlength="25" autocomplete="off" tabindex="2" /><br>
								</td>
							</tr>
							<tr>
								<td class="label"></td>
								<td>
									<input type="text" id="descCContaServicio" size="56" maxlength="25" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="cContaComision">Cta. Contable Comisión:</label></td>
								<td>
									<input type="text" id="cContaComision" name="cContaComision" size="56" maxlength="25" autocomplete="off" tabindex="3"/><br>
								</td>
							</tr>
							<tr>
								<td class="label"></td>
								<td>
									<input type="text" id="descCContaComision" size="56" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="cContaIVAComisi">Cta. Contable IVA Comisión:</label></td>
								<td>
									<input type="text" id="cContaIVAComisi" name="cContaIVAComisi" size="56" maxlength="25" autocomplete="off" tabindex="4"/><br>
								</td>
							</tr>
							<tr>
								<td class="label"></td>
								<td>
									<input type="text" id="descCContaIVAComisi" size="56" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="nomenclaturaCC">Nomenclatura Centro de Costo:</label></td>
								<td>
									<input type="text" id="nomenclaturaCC" name="nomenclaturaCC" size="5" maxlength="3" autocomplete="off" tabindex="5"/>
									<input type="text" id="nombreCentroCosto" name="nombreCentroCosto" size="50" readOnly="true" />
									<a href="javaScript:" onClick="ayudaCentroCostos();"><img src="images/help-icon.gif" ></a>
								</td>
							</tr>
							<tr>
								<td class="label"></td>
								<td>
									<i>
										<label>
											<b>
												<br><a href="javascript:" id="sucOrigen" tabindex="7">&SO = Sucursal Origen </a>
												<br><a href="javascript:" id="sucCliente" tabindex="8">&SC = Sucursal Cliente</a>
											</b>
										</label>
									</i>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>				
			</tr>
			<tr>
				<td colspan="2">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Canal y Comisiones</legend>
						<table>
							<tr>
								<td class="label"></label></td>
								<td class="label">
									<label>Canal Ventanilla de sucursal</label>
								</td>
								<td class="label">
									<label>Canal Banca en Línea</label>
								</td>
								<td class="label">
									<label>Canal Banca Móvil</label>
								</td>
							</tr>	
							<tr>
								<td class="label"><label>Canal Activo:</label></td>
								<td class="label">
									<input type="checkbox" id="ventanillaAct" name="ventanillaAct" tabindex="9"></input>
								</td>
								<td class="label">
									<input type="checkbox" id="bancaLineaAct" name="bancaLineaAct" tabindex="10"></input>
								</td>
								<td class="label">
									<input type="checkbox" id="bancaMovilAct" name="bancaMovilAct" tabindex="11"></input>
								</td>
							</tr>	
							<tr>
								<td class="label"><label>Cobra Comisión:</label></td>
								<td class="label">
									<input type="checkbox" id="cobComVentanilla" name="cobComVentanilla" tabindex="12" disabled="disabled"></input>
									<input type="hidden" id="cobComVentanillaOculto" name="cobComVentanillaOculto" disabled="disabled"></input>
								</td>
								<td class="label">
									<input type="checkbox" id="cobComBancaLinea" name="cobComBancaLinea" tabindex="13" disabled="disabled"></input>
									<input type="hidden" id="cobComBancaLineaOculto" name="cobComBancaLineaOculto" disabled="disabled"></input>
								</td>
								<td class="label">
									<input type="checkbox" id="cobComBancaMovil" name="cobComBancaMovil" tabindex="14" disabled="disabled"></input>
									<input type="hidden" id="cobComBancaMovilOculto" name="cobComBancaMovilOculto" disabled="disabled"></input>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="mtoCteVentanilla">Monto Comisión Cliente:</label></td>
								<td class="label">
									<input type="text" id="mtoCteVentanilla" name="mtoCteVentanilla" size="10" tabindex="15" maxlength="7" class="moneda" disabled="disabled"></input>
								</td>
								<td class="label">
									<input type="text" id="mtoCteBancaLinea" name="mtoCteBancaLinea" size="10" tabindex="16" maxlength="7" class="moneda" disabled="disabled"></input>
								</td>
								<td class="label">
									<input type="text" id="mtoCteBancaMovil" name="mtoCteBancaMovil" size="10" tabindex="17" maxlength="7" class="moneda" disabled="disabled"></input>
								</td>
							</tr>
							<tr>
								<td class="label"><label for="mtoUsuVentanilla">Monto Comisión Usuario:</label></td>
								<td class="label">
									<input type="text" id="mtoUsuVentanilla" name="mtoUsuVentanilla" size="10" tabindex="18" maxlength="7" class="moneda" disabled="disabled"></input>
								</td>
							</tr>									
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend >Detalle del Servicio Seleccionado</legend>
						<div id="divConfigProductos" style="overflow: auto; height: 220px;">					
						</div>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false"/>
						<input type="submit" class="botonDeshabilitado" id="btnGuardar" name="btnGuardar" value="Guardar" disabled="disable" />
					</fieldset>
				</td>
			<tr>
			</table>
		</form:form>
</fieldset>

</div>


<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/></div>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento"/>
</div>
<div id="mensaje" style="display: none;"/></div>

</body>
</html>