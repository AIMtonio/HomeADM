<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasMayorCRWServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/conceptosCRWServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subctaMonedaCRWServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/subctaPlazoCRWServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="js/crowdfunding/guiaContableCRWCatalogo.js"></script>
</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Gu&iacute;a Contable Crowdfunding</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="CRW">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Mayor</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
					   	<td class="label">
					         <label for="lblconceptoCRWID">Concepto:</label>
					     	</td>
					     	<td>
			         		<select id="conceptoCRWID" name="conceptoCRWID" tabindex="1">
									<option value="0">Seleccionar<option>
								</select>
					     	</td>
					   </tr>
						<tr>
					      <td class="label">
					         <label for="lblcuenta">Cuenta:</label>
					     	</td>
					     	<td >
					     		 <input id="cuenta" name="cuenta"  size="13"
					         		tabindex="2" />
					     	</td>
						</tr>
						<tr>
					      <td class="label">
					         <label for="lblnomenclatura">Nomenclatura:</label>
					     	</td>
					     	<td >
					     		<input id="nomenclatura" name="nomenclatura"  size="25"
					         		tabindex="3" />
					         <a href="javaScript:" onClick="ayuda();">
								  	<img src="images/help-icon.gif" >
								</a>
					     	</td>
						</tr>
						<tr>
							<td class="label">
					         <label for="lblClaves"><b>Claves de Nomenclatura Cuentas:
					         <i><br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&CM');return false;">  &CM = Cuentas de Mayor </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TM');return false;">  &TM = SubCuenta por Tipo de Moneda </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclatura','&TD');return false;">  &TD = SubCuenta por Plazo (No. Retiros en el Mes) </b> </b> </b> </a></label>
					         </i>
					     	</td>
						</tr>
						<tr>
					      <td class="label">
					         <label for="lblnomenclaturaCR">Nomenclatura Centro Costo:</label>
					     	</td>
					     	<td >
					     		 <input id="nomenclaturaCR" name="nomenclaturaCR"  size="25"
					         		tabindex="4" />
					         <a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a>
					     	</td>
						</tr>
						<tr>
							<td class="label">
					         <label for="lblClaves"><b>Claves de Nomenclatura  Centro Costo:
					         <i>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SO');return false;">  &SO = Sucursal Origen </a>
					         <br><a href="javascript:" onClick="insertAtCaret('nomenclaturaCR','&SC');return false;">  &SC = Sucursal Cliente </a></b> </label>
					     		</i>
					     	</td>
						</tr>
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaCM" name="grabaCM" class="submit" value="Grabar"  tabindex="5"/>
								<input type="submit" id="modificaCM" name="modificaCM" class="submit" value="Modificar" tabindex="6"/>
								<input type="submit" id="eliminaCM" name="eliminaCM" class="submit" value="Eliminar" tabindex="7"/>
								<input type="hidden" id="tipoTransaccionCM" name="tipoTransaccionCM" value="tipoTransaccionCM"/>
							</td>
						</tr>
					</table>
				</fieldset>
		</form:form>
		<br></br>

	<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="CRW">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Tipo de Moneda</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
					   	<td>
					     		 <input id="conceptoCRWID2" name="conceptoCRWID2"  size="13"
					         		tabindex="25" type="hidden"/>
					     	</td>
					   </tr>
						<tr>
					   	<td class="label">
					         <label for="lblmonedaID">Moneda:</label>
					     	</td>
					     	<td>
					     		 <select id="monedaID" name="monedaID" tabindex="26">
									<option value="-1">Seleccionar</option>
								</select>
					     	</td>
					   </tr>
						<tr>
					      <td class="label">
					         <label for="lblsubCuenta">SubCuenta</label>
					     	</td>
					     	<td >
					     		 <input id="subCuenta" name="subCuenta"  size="5"
					         		tabindex="27" />
					     	</td>
						</tr>
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaMon" name="grabaMon" class="submit" value="Grabar" tabindex="28"/>
								<input type="submit" id="modificaMon" name="modificaMon" class="submit" value="Modificar" tabindex="29" />
								<input type="submit" id="eliminaMon" name="eliminaMon" class="submit" value="Eliminar" tabindex="30"/>
								<input type="hidden" id="tipoTransaccionTM" name="tipoTransaccionTM" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br></br>
	<form:form id="formaGenerica3" name="formaGenerica3" method="POST" commandName="CRW">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Por Plazo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
					   	<td>
					     		 <input id="conceptoCRWID3" name="conceptoCRWID3"  size="10"
					         		tabindex="50" type="hidden"/>
					     	</td>
					   </tr>
						<tr>
					   	<td class="label">
					         <label for="lblnumRetiros">No. Retiros:</label>
					     	</td>
					     	<td>
					     		 <select id="numRetiros" name="numRetiros" tabindex="51">
									<option value="1">UN D&Iacute;A AL MES</option>
									<option value="2">DOS D&Iacute;AS AL MES</option>
									<option value="3">TRES D&Iacute;AS AL MES</option>
									<option value="4">CUATRO D&Iacute;AS AL MES</option>
								</select>
					     	</td>
					   </tr>
						<tr>
					      <td class="label">
					         <label for="lblsubCuenta">SubCuenta</label>
					     	</td>
					     	<td >
					     		 <input id="subCuenta1" name="subCuenta1"  size="5"
					         		tabindex="52" />
					     	</td>
						</tr>
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabaPla" name="grabaPla" class="submit" value="Grabar" tabindex="53"/>
								<input type="submit" id="modificaPla" name="modificaPla" class="submit" value="Modificar" tabindex="54"/>
								<input type="submit" id="eliminaPla" name="eliminaPla" class="submit" value="Eliminar" tabindex="55"/>
								<input type="hidden" id="tipoTransaccionTP" name="tipoTransaccionTP" value="2"/>
							</td>
						</tr>
					</table>
				</fieldset>
	</form:form>
	<br></br>
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