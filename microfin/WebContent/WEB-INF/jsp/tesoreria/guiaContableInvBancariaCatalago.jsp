<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/conceptosInverBanServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasMayorInvBanServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subCtaMonedaInvBanServicio.js"></script><!-- Moneda     -->
	<script type="text/javascript" src="dwr/interface/subCtaInstInvBanServicio.js"></script>  <!-- institucion -->
	<script type="text/javascript" src="dwr/interface/subCtaTituInvBanServicio.js"></script>  <!-- Titulo      -->
	<script type="text/javascript" src="dwr/interface/subCtaRestInvBanServicio.js"></script>  <!-- Restricción -->
	<script type="text/javascript" src="dwr/interface/subCtaDeudaInvBanServicio.js"></script> <!-- TipoDeuda   -->
	<script type="text/javascript" src="dwr/interface/subCtaPlazoInvBanServicio.js"></script> <!-- Plazo       -->
	<script type="text/javascript" src="js/tesoreria/guiaContaInverBancCatalogo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Inversiones Bancarias</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="guiaContableInvBancaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label"><label for="lblconceptoInvID">Concepto:</label></td>
							<td>
								<select id="ConceptoInvBanID" name="ConceptoInvBanID" tabindex="1" style="text-transform: uppercase">
									<option value="-1">SELECCIONAR</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label"><label for="lblcuenta">Cuenta:</label></td>
							<td><input id="Cuenta" name="Cuenta" type="text" size="13" tabindex="2"/></td>
						</tr>
						<tr>
							<td class="label"><label for="lblnomenclatura">Nomenclatura Cuentas Inversi&oacute;n Bancaria:</label></td>
							<td>
								<input id="Nomenclatura" name="Nomenclatura" type="text" size="25" tabindex="3" maxlength="60"/>
								<a href="javaScript:" onClick="ayuda();">
								  	<img src="images/help-icon.gif" >
								</a> 
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label for="lblClaves">
									<b>Claves de Nomenclatura Cuentas Inversi&oacute;n Bancaria: 
										<i>
											<br>
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&CM');return false;"> &CM = Cuentas de Mayor </a>
											<br>
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&TM');return false;"> &TM = SubCuenta por Tipo de Moneda </a>
											<br> 
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&TI');return false;"> &TI = SubCuenta por Insituci&oacute;n</a>
											<br>
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&TT');return false;"> &TT = SubCuenta por Tipo de T&iacute;tulo</a>
											<br>
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&TR');return false;"> &TR = SubCuenta por Restricci&oacute;n</a>
											<br>
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&TD');return false;"> &TD = SubCuenta por Tipo de Deuda</a>   
											<br> 
											<a href="javascript:" onClick="insertAtCaret('Nomenclatura','&PB');return false;"> &PB = SubCuenta por Plazo Bancario (n&uacute;mero de dias)</a> 
											<br>
										</i>
									</b>
								</label>
							</td>
						</tr>
					</table>
					<br>
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar" tabindex="4" />
								<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="5" />
								<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="6" />
								<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value="tipoTransaccionCM" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br></br>
			<form:form id="formaGenerica1" name="formaGenerica" method="POST" commandName="guiaContableInvBancaria"> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>
					<table border="0" width="100%">
						<tr>
							<td>
								<input id="ConceptoInvBanID1" name="ConceptoInvBanID" type="hidden" size="13" /> 
							</td> 
						</tr> 
							<tr>
							<td class="label"> <label for="lblmonedaID">Moneda:</label> </td>
							<td> 
								<select id="MonedaID" name="MonedaID" tabindex="7" style="text-transform:uppercase">
										<option value="-1">SELECCIONAR</option>
								</select> 
							</td>
						</tr> 
						<tr>  
							<td class="label"><label for="lblsubCuenta2">SubCuenta:</label></td>
							<td ><input id="SubCuenta" name="SubCuenta" type="text" size="5" maxlength="2" tabindex="8" /> </td>
						</tr> 
					</table>
					<br><br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right">
								<input type="submit" id="grabaTM" name="grabaTM" class="submit" value="Grabar" tabindex="9"/>
								<input type="submit" id="modificaTM" name="modificaTM" class="submit" value="Modificar" tabindex="10" />
								<input type="submit" id="eliminaTM" name="eliminaTM" class="submit" value="Eliminar" tabindex="11"/>
								<input type="hidden" id="tipoTransaccionTM" name="tipoTransaccionTM" value="0"/>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br><br>	
			<!-- ::::::::::::::::::::::::::::::::: INSTITUCIONES :::::::::::::::::::::::::::::::::::::::::: -->
			<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="guiaContableInvBancaria"> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
					<legend class="ui-widget ui-widget-header ui-corner-all">Por Instituci&oacute;n</legend>
						<table border="0"  border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td>
									<input id="ConceptoInvBanID2" name="ConceptoInvBanID"  size="10" type="hidden"/> 
								</td> 
							</tr> 
							<tr>
								<td class="label"><label for="lblfisica">Instituci&oacute;n:</label></td>
								<td nowrap="nowrap">
									<input type="text" id="InstitucionID" name="InstitucionID" size="12" maxlength="11" tabindex="12" />
									<input type="text"  id="nombreInstitucion" name="nombreInstitucion" size="50" disabled="true" readonly="true">
								</td>
							</tr>
							<tr>
							<td class="label"><label for="lblfisica">Subcuenta:</label></td>
							<td>
								<input type="text" id="SubCuentaInst" name="SubCuenta" size="5" maxlength="4" tabindex="12" />
							</td>
							</tr>
						</table>
						<br><br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
							<tr>
								<td align="right">
									<input type="submit" id="grabaTP" name="grabaTP" class="submit" value="Grabar" tabindex="13"/>
									<input type="submit" id="modificaTP" name="modificaTP" class="submit" value="Modificar" tabindex="14" style=" width : 85px;"/>
									<input type="submit" id="eliminaTP" name="eliminaTP" class="submit" value="Eliminar" tabindex="15"/>
									<input type=hidden id="tipoTransaccionTP" name="tipoTransaccionTP" value="0"/>
								</td>
							</tr>
						</table>
					</fieldset>
			</form:form>
			<br><br>
			<!-- ::::::::::::::::::::::::::::::::: TITULOS ::::::::::::::::::::::::::::::::::::::::::.-->
			<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="guiaContableInvBancaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de T&iacute;tulo:</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr >
							<td >
								<input id="ConceptoInvBanID3" name="ConceptoInvBanID" size="13" tabindex="13" type="hidden" />
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap" class="label">
								<label for="lbltipoProductoID">T&iacute;tulo Para Negociar:&nbsp;&nbsp;&nbsp;</label>
							</td>
							<td>
								<input id="TituNegocio" name="TituNegocio"  type="text" size="7" maxlength="6" tabindex="16" />
							</td>
							<td colspan='3'>&nbsp;</td>
						</tr>
						<tr>
							<td nowrap="nowrap" class="label">
								<label for="lblsubCuenta">Título Disponible para Venta:&nbsp;&nbsp;&nbsp;</label>
							</td>
							<td>
								<input id="TituDispVenta" name="TituDispVenta"  type="text" size="7" maxlength="6" tabindex="17" />
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap" class="label"><label for="lblsubCuenta">T&iacute;tulo Conservados al Vencimiento:&nbsp;&nbsp;&nbsp;</label></td>
							<td>
								<input id="TituConsVenc" name="TituConsVenc"  type="text" size="7" maxlength="6" tabindex="18" />
							</td>
						</tr>
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaTT" name="grabaTT" class="submit" value="Grabar" tabindex="19" />
								<input type="submit" id="modificaTT" name="modificaTT" class="submit" value="Modificar" tabindex="20" />
								<input type="submit" id="eliminaTT" name="eliminaTT" class="submit" value="Eliminar" tabindex="21" />
								<input type="hidden" id="tipoTransaccionTT" name="tipoTransaccionTT" value="0" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br><br>
			<!-- ::::::::::::::::::::::::::::::::: RESTRICCIONES ::::::::::::::::::::::::::::::::::::::::::.-->
			<form:form id="formaGenerica4" name="formaGenerica4" method="POST" commandName="guiaContableInvBancaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Restricción:</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr><td><input id="ConceptoInvBanID4" name="ConceptoInvBanID" size="13" tabindex="13" type="hidden" /></td></tr>
						<tr>
							<td class="label"><label for="lbltipoProductoID">Con Restricci&oacute;n:</label></td>
							<td><input id="RestricionCon" name="RestricionCon"  type="text" size="6" maxlength="6" tabindex="22" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblsubCuenta">Sin Restricci&oacute;n:</label></td>
							<td><input id="RestricionSin" name="RestricionSin"  type="text" size="6" maxlength="6" tabindex="23" /></td>
						</tr>
					</table>
					<br><br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaR" name="grabaR" class="submit" value="Grabar" tabindex="24" />
								<input type="submit" id="modificaR" name="modificaR" class="submit" value="Modificar" tabindex="25" />
								<input type="submit" id="eliminaR" name="eliminaR" class="submit" value="Eliminar" tabindex="26" />
								<input type="hidden" id="tipoTransaccionR" name="tipoTransaccionR" value="0" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br><br>
			<!-- :::::::::::::::::::::::::::::::::: TIPO DE DEUDA ::::::::::::::::::::::::::::::::::::::::::::: -->
			<form:form id="formaGenerica5" name="formaGenerica5" method="POST" commandName="guiaContableInvBancaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Deuda:</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><input id="ConceptoInvBanID5" name="ConceptoInvBanID" size="13" tabindex="13" type="hidden" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lbltipoProductoID">Gubernamental</label></td>
							<td><input id="TipoDeuGuber" name="TipoDeuGuber"  type="text" size="7" maxlength="6" tabindex="27" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblsubCuenta">Bancaria:</label></td>
							<td><input id="TipoDeuBanca" name="TipoDeuBanca"  type="text" size="7" maxlength="6" tabindex="28" /></td>
						</tr>
						<tr>
							<td class="label"><label for="lblsubCuenta">Otros T&iacute;tulos:</label></td>
							<td><input id="TipoDeuOtros" name="TipoDeuOtros"  type="text" size="7" maxlength="6" tabindex="29" /></td>
						</tr>
					</table>
					<br><br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaTD" name="grabaTD" class="submit" value="Grabar" tabindex="30" />
								<input type="submit" id="modificaTD" name="modificaTD" class="submit" value="Modificar" tabindex="31" />
								<input type="submit" id="eliminaTD" name="eliminaTD" class="submit" value="Eliminar" tabindex="32" />
								<input type="hidden" id="tipoTransaccionTD" name="tipoTransaccionTD" value="0" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br><br>
			<!--:::::::::::::::::::::::::::::::::: PLAZO BANCARIO ::::::::::::::::::::::::::::::::::::::::::::::::::: -->
			<form:form id="formaGenerica6" name="formaGenerica6" method="POST" commandName="guiaContableInvBancaria">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Plazo Bancario</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr><td><input id="ConceptoInvBanID6" name="ConceptoInvBanID" size="13" tabindex="13" type="hidden" /></td></tr>
						<tr>
							<td class="label"><label for="Plazo">Plazo:</label></td>
							<td class="label"><input id="Plazo" name="Plazo"  type="text" size="7" maxlength="5" tabindex="33" /><label> Días</label></td>
						</tr>
						<tr>
							<td class="label"><label>Subcuenta para un Plazo Mayor:</label></td>
							<td><input id="SubPlazoMayor" name="SubPlazoMayor"  type="text" size="7" maxlength="6" tabindex="34" /></td>
						</tr>
						<tr>
							<td class="label"><label>Subcuenta para un Plazo Menor:</label></td>
							<td><input id="SubPlazoMenor" name="SubPlazoMenor"  type="text" size="7" maxlength="6" tabindex="35" /></td>
						</tr>
					</table>
					<br><br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
							<input type="submit" id="grabaPB" name="grabaPB" class="submit" value="Grabar" tabindex="36" />
								<input type="submit" id="modificaPB" name="modificaPB" class="submit" value="Modificar" tabindex="37" />
								<input type="submit" id="eliminaPB" name="eliminaPB" class="submit" value="Eliminar" tabindex="38" />
								<input type="hidden" id="tipoTransaccionPB" name="tipoTransaccionPB" value="0" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
			<br><br>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista" ></div>
	</div>
</body>
</html>
