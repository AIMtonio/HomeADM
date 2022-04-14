<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tarDebParamServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarDebArchAclaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/aclaracionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/tipoAclaracionServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/operacionAclaracionServicio.js"></script>
      <script type="text/javascript" src="js/tarjetas/tardebRegistroAclaracion.js"></script>
	</head>
	<body>
		<div id="contenedorForma"> 
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="registro">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Registro de Aclaración</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">			
							<label>Tipo Tarjeta: </label>
							<input type="radio" id="tipoTarjetaD" name="tipoTarjeta" value="D" tabIndex="1"/><label>Debito</label>
							<input type="radio" id="tipoTarjetaC" name="tipoTarjeta" value="C" tabIndex="2" /><label>Credito</label>
							</td>
				<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lnumerorep">No. de Reporte: </label>
							</td>
							<td>
								<input type="text" id="reporteID" name="reporteID" path="reporteID" size="10" tabindex="1" />
							</td>							
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lestatus">Estatus Reporte: </label>
								<input type="text" id="estatus" name="estatus" path="estatus" size="35" readOnly="true" disabled = "true"/>
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="lblReporte">Tipo de Reporte:</label>
							</td>
							<td>
								<form:select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="2">
									<form:option value=""></form:option>
								</form:select>
							</td>		
						</tr>
						
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="lnumerotar">No. de Tarjeta:</label>
								<input type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" maxlength="16" size="20" tabindex="3"/>
							</td>
							
						</tr>
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Datos Tarjeta</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lnombre">Tarjetahabiente:</label>
								</td>
								<td>
				    				<input type="text" id="clienteID" name="clienteID" size="20" readOnly="true" disabled = "true" />
									<input type="text" id="nombre" name="nombre" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>		
							</tr>
							<tr id="cteCorpTr">
								<td class="label" nowrap="nowrap">
									<label for="lcorporativo">Corporativo (Contrato):</label>
								</td>
								<td>
				    				<input type="text" id="corporativoID" name="corporativoID" size="20" readOnly="true" disabled = "true" />
									<input type="text" id="nombreCorp" name="nombreCorp" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>
							</tr>
							<tr id="cuentaAho" style="display: none;">
								<td class="label" nowrap="nowrap">
									<label for="lnumCuenta">Cuenta Asociada:</label>
								</td>
								<td>
				    				<input type="text" id="numCuenta" name="numCuenta" size="20" readOnly="true" disabled="true" />
									<input type="text" id="descCuenta" name="descCuenta" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>
							</tr>
							<tr id="producto" style="display: none;">
								<td class="label" nowrap="nowrap">
									<label for="lnumCuenta">Producto Crédito:</label>
								</td>
								<td>
				    				<input type="text" id="productoID" name="productoID" size="20" readOnly="true" disabled="true" />
									<input type="text" id="nombreProducto" name="nombreProducto" size="70" onBlur=" ponerMayusculas(this)" readOnly="true" disabled = "true" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lnumCuenta">Tipo Tarjeta:</label>
								</td>
								<td>
									<input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" readOnly="true" size="20" disabled="true" />
									<input type="text" id="nombreTarjeta" name="nombreTarjeta"  readOnly="true" size="50"  disabled="true" />
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Datos del Reporte</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblinstitucionID">Banco de Terminal o Cajero:</label>
									</td>
									<td>
				    					<input type="text" id="institucionID" name="institucionID" path="institucionID" tabindex="6" size="20"/>
										<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="69" tabindex="3" readOnly="true" disabled = "true" />
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="operacion">Operaci&oacute;n:</label>
									</td>
									<td>
										<form:select id="operacionID" name="operacionID" path="operacionID" tabindex="7">
											<form:option value="">Selecciona</form:option> 
										</form:select>
									</td>		
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblTienda">Tienda o Comercio:</label>
									</td>
									<td>
				    					<input type="text" id="tienda" name="tienda" path="tienda" tabindex="8" size="95" onblur="ponerMayusculas(this)" />
									</td>		
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lcajero">No. de Cajero:</label>
									</td>
									<td>
				    					<input type="text" id="cajeroID" name="cajeroID" path="cajeroID" tabindex="9" size="20" onBlur=" ponerMayusculas(this)" />
									</td>		
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblNumAutoriza">No. de Autorización:</label>
									</td>
									<td>
										<input type="text" id="noAutorizacion" name="noAutorizacion" path="noAutorizacion7" tabindex="10" size="20" onkeypress="validaSoloNumeros()"/>
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lmonto">Monto de Operaci&oacute;n:</label>
									</td>
									<td>
				    					<input type="text" id="montoOperacion" name="montoOperacion" path="montoOperacion" esMoneda="true" tabindex="11" size="20" onkeypress="validaSoloNumeros()"/>
									</td>
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="fechaOperacion">Fecha de Operaci&oacute;n:</label>
									</td>
									<td>
		           					<form:input id="fechaOperacion" name="fechaOperacion" path="fechaOperacion" esCalendario="true" onblur="validaFecha()" size="20" tabindex="12" /> 
	     		  					</td>	
								</tr>
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="ltransaccion">Transacci&oacute;n:</label>
									</td>
									<td>
										<form:select id="transaccionID" name="transaccionID" path="transaccionID" tabindex="13">
											<form:option value=""></form:option> 
										</form:select>
									</td>		
								</tr>
								<tr>
									<td>
										<label for="ldetalle">Detalle de Reporte: </label>
									</td>
									<td>
										<textarea id="detalleReporte" name="detalleReporte" path="detalleReporte" rows="7" cols="68" class="contador" tabindex="14" maxlength="2000" onblur="ponerMayusculas(this);"></textarea>
										<div align="right">
											<label for="longitud_textarea" id="longitud_textarea" name="longitud_textarea"></label>
										</div>
									</td>
								</tr>
							</table>
						</fieldset>
						</br>
						<div id="gridAdjuntos">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Adjuntos</legend>
								<div id="detalleArchivos" style="display: none;"></div> 
							</fieldset>						
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td class="label" align="right">
										<input type="button"id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="15" /> 
										<input type="hidden" id="tipoTransaccion"name="tipoTransaccion" /> 
										<input type="hidden" id="resultadoArchivoTran" name="resultadoArchivoTran" class="submit" size="15" disabled="true" readonly="true" >
										<a id="enlaceAclaracion" target="_blank"> 
											<input type="button" class="submit" id="pdf"name="pdf" value="Expediente" />
							   		</a>
									</td>
								</tr>
							</table>
						</div>
				</fieldset>
				<table width="100%">
					<tr>
						<td align="right">		
							<input type="submit" id="agrega" name="agrega" class="submit" value="Grabar"  tabindex="14"/>
							<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="14"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
				<input type="hidden" size="500" name="lisFolio" id="lisFolio"/>
				<input type="hidden" size="500" name="lisTipoArchivo" id="lisTipoArchivo"/>
				<input type="hidden" size="500" name="lisRuta" id="lisRuta"/>
				<input type="hidden" size="500" name="lisNombreArchivo" id="lisNombreArchivo"/>		
			</form:form>
			<input type="hidden" id="diasAclaracion" name="diasAclaracion" disabled="true" readonly="true" iniForma="false" />
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>