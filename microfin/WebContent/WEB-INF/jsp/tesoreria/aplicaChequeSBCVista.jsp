<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>			
	    <script type="text/javascript" src="dwr/interface/abonoChequeSBCServicio.js"></script>	 
	    <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>      	
		
		<script type="text/javascript" src="js/tesoreria/aplicaChequeSBC.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="SBC">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Aplicación de Cheque SBC</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label"><label for="lblcuentaAhoID">Cuenta:</label></td>
			<td><input id="cuentaAhoID" name="cuentaAhoID" iniForma="false" size="14" tabindex="1" type="text" maxlength="12" />																	
			</td>
			<td class="separador"></td>
			<td class="label"><label for="lblTipoCuentaAplic">Tipo Cuenta:</label></td>
			<td><input id="tipoCuentaSBCAplic" name="tipoCuentaSBCAplic" iniForma="false" size="50"	tabindex="2" type="text" readOnly="true" />						
			</td>											
		</tr>		
		<tr>
			<td class="label"><label for="lblclienteID">Cliente:</label></td>
			<td><input id="clienteID" name="clienteID" iniForma="false" size="14" type="text" tabindex="3" readOnly="true"/>
				<input id="nombreReceptor" name="nombreReceptor" iniForma="false" size="60" type="text" tabindex="4" readOnly="true"/>
			</td>	
			<td class="separador"></td>	
			<td class="label" nowrap="nowrap"><label for="lblSaldoDisponible">Saldo Disponible:</label></td>
			<td><input id="saldoDisponible" name="saldoDisponible" iniForma="false" size="20" type="text" tabindex="5" readOnly="true" />	
			</td>																																						
		</tr>	
		<tr>		
			<td class="label"><label for="lblSaldoSBC">Saldo SBC:</label></td>
			<td><input id="saldoSBC" name="saldoSBC" iniForma="false" size="20" type="text" tabindex="6" readOnly="true"/>
			</td>
			<td class="separador"></td>	
			
		</tr>											
	</table>								
	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Cheque SBC</legend>
			<table> 
			<tr>																						
				<td class="label"><label for="lblchequeSBCID">Cheque:</label></td>
				<td><select id="chequeSBCID" name="chequeSBCID"  tabindex="7"></select>
				</td>					
			</tr>
			<tr>
				<td class="label"><label for="lblfechaCobro">Fecha Recepción:</label></td>
				<td><input id="fechaCobro" name="fechaCobro" iniForma="false" size="20" type="text" tabindex="8" readOnly="true"/>
				<td class="separador"></td>																																	
				<td class="label"><label class="label" for="lblbancoEmisor">Banco Emisor:</label></td>
				<td><input id="bancoEmisor" name="bancoEmisor" size="6" tabindex="9" type="text" iniForma="false" readOnly="true"/>
					 <input id="nombreBancoEmisor" name="nombreBancoEmisor" size="35" tabindex="10" type="text" iniForma="false"  readOnly="true" />
				</td>																																																																																																																					
			</tr>	
			<tr>			
				<td class="label"><label for="lblcuentaEmisor">Número Cuenta Emisor:</label></td>
				<td><input id="cuentaEmisor" name="cuentaEmisor" size="20" tabindex="11" type="text" iniForma="false" maxlength="12" readOnly="true" />
				</td>
				<td class="separador"></td>																																
				<td class="label" nowrap="nowrap"><label for="lblNombreEmisor">Nombre Emisor:</label></td>
				<td><input id="nombreEmisorSBC" name="nombreEmisorSBC" size="50" type="text" iniForma="false" tabindex="12"	 readOnly="true"/></td>																																																												
			</tr>
			<tr>	
				<td class="label"><label for="lblnumCheque">Número Cheque:</label></td>
				<td><input id="numCheque" name="numCheque" size="20" type="text" iniForma="false" tabindex="13"  readOnly="true" /></td>
				<td class="separador"></td>			 		
				<td class="label"><label for="lblMontoSBC">Monto:</label></td>
				<td><input id="monto" name="monto" size="17" tabindex="14" type="text" iniForma="false" esMoneda="true" readOnly="true"/>
				</td>																																
			</tr>			
 								
		</table>
	</fieldset>
		<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Cheque Depositado en</legend>
			<table> 			
			<tr>	
				<td class="label"><label for="lblgetBancoAplica">Institución:</label></td>
				<td><input id="bancoAplica" name="bancoAplica" size="15" type="text" iniForma="false" tabindex="15"  maxlength="10"  />
					<input id="descripcionBanco" name="descripcionBanco" size="40" type="text" 
					iniForma="false" tabindex="16"  readOnly="true" />
				</td>
				<td class="separador"></td>			 		
				<td class="label"><label for="lblcuentaBancoAplica">Número de Cuenta Bancaria:</label></td>
				<td><input id="cuentaBancoAplica" name="cuentaBancoAplica" size="20" tabindex="17" type="text" iniForma="false" maxlength="12"/>
				</td>																																
			</tr> 							
		</table>
	</fieldset>
	<table align="right">
		<tr>
			<td align="right">				
				<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="80"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
				<input id="monedaID" name="monedaID" size="17" tabindex="13" type="hidden" />				
			</td>
		</tr>
	</table>
</fieldset>


</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>