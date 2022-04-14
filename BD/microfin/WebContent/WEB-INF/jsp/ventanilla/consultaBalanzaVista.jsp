<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
	<script type="text/javascript" src="js/ventanilla/consultaBalanza.js"></script> 
</head>
<body>


<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasVentanillaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Balanza de Efectivo</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">		

			<tr>
	 			<td><label>Sucursal:</label></td>
				<td>
				<form:select id="sucursalID" name="sucursalID" path="sucursalID"  tabindex="1">
			    	<form:option value="0">Selecciona:</form:option>
				</form:select>
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="label"><label>Caja:</label></td>
				<td>
				<form:select id="cajaID" name="cajaID" path="cajaID" tabindex="2">
 					<form:option value="0">Selecciona:</form:option>
				</form:select>
				</td>
			</tr>
			<tr>
				<td class="label"><label for="lbleopera">Estado de Operación:</label></td>
				<td><input type="text" id="estatusOpera" name="estatusOpera" tabindex="" path="estatusOpera" size="15" disabled="true" tabindex="3"/></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="label"><label for="lblFecha">Fecha:</label></td>
				<td><input type="text" id="fecha" name="fecha" path="fecha" size="10" esCalendario="true" tabindex="4"/></td>
			</tr>
	 		<tr >
			<td colspan="3" >
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" >
						<tr>
							<td class="label"><label for="lblDenominacion">Denominación</label>
							</td>
							<td class="separador"></td>
							<td><label for="lblCantidad">Cantidad</label></td>
							<td class="separador"></td>
							<td class="label"><label for="lblMonto">Monto</label>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input id="denoSalMilID" iniForma="false" name="denomiSalidaID" size="8"  readOnly="true" disabled="true"
								style="text-align: right" value="1" type="hidden"></input> 
								<input id="denoSalMil" iniForma="false" name="denomiSalida"	size="8" type="text" readOnly="true" disabled="true"
								esMoneda="true" style="text-align: right" value="1000"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMil"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMil" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalQuiID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="2"></input> <input
								id="denoSalQui" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="500"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalQui"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalQui" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalDosID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="3"></input> <input
								id="denoSalDos" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="200"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalDos"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalDos" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCienID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="4"></input> <input
								id="denoSalCien" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="100"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCien"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCien" name="montoSalida" size="15"
								type="text" readOnly="true" disabled="true"
								iniForma="false" esMoneda="true"
								style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalCinID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="5"></input> <input
								id="denoSalCin" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="50"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalCin"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalCin" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalVeiID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="6"></input> <input
								id="denoSalVei" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="20"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalVei"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalVei" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr>
							<td align="right"><input id="denoSalMonID"
								iniForma="false" name="denomiSalidaID" size="8"
								 readOnly="true" disabled="true" type="hidden"
								style="text-align: right" value="7"></input> <input
								id="denoSalMon" iniForma="false" name="denomiSalida"
								size="8" type="text" readOnly="true" disabled="true"
								style="text-align: right" value="Monedas"></input></td>
							<td class="separador"></td>
							<td align="right"><input id="disponSalMon"
								name="disponSalida" size="5" type="text" value="0"
								iniForma="false" readOnly="true" disabled="true"
								style="text-align: right"></input></td>
							<td class="separador"></td>
							<td class="label" align="right"><input
								id="montoSalMon" name="montoSalida" size="15" type="text"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right" value="0"></input></td>
						</tr>
						<tr align="right">
							<td class="separador"></td>
							<td class="separador"></td>
							<td align="right"><label for="lblTotal">Total</label>
							</td>
							<td class="separador"></td>
							<td align="right">
								<input type="text" id="cantidad" name="cantidad" path="cantidad" size="15" value="0"
								readOnly="true" disabled="true" esMoneda="true"
								iniForma="false" style="text-align: right"/>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="7">
								<!-- input type="button" id="agregarSalEfec" name="agregarSalEfec" class="submit" value="Agregar" / -->
								<input type="hidden" id="billetesMonedasEntrada" name="billetesMonedasEntrada" /> 
								<input type="hidden" id="billetesMonedasSalida"	name="billetesMonedasSalida" />
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		</table>		
			<table align="right">
				<tr>
				<td >
				    
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="cajaDestino" name="cajaDestino"/>
					<input type="hidden" id="tipoConsulta" name="tipoConsulta"/>
				 	<input type="hidden" id="nombreInstitucion" name="nombreInstitucion"/>					
					<input type="hidden" id="numUsuario" name="numUsuario"/>
					<input type="hidden" id="nomUsuario" name="nomUsuario"/>
					<input type="hidden" id="fechaSistemaP" name="fechaSistemaP"/>
					<input type="hidden" id="hora" name="hora"/>
					<input type="hidden" id="desCaja" name="desCaja"/>
					<input type="hidden" id=monedaID name="monedaID"/>
					<input type="hidden" id="consec" name="consec"/>
					<input type="hidden" id="tipoCaja" name="tipoCaja" />
					<input type="hidden" id="descripCajaDestino" name="descripCajaDestino"/>
				</td>
				</tr>
				
			</table>
	</fieldset>
	</form:form>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>