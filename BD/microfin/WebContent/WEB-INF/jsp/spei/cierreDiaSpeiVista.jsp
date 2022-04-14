<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/consultaSpeiServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="js/spei/cierreDiaSpei.js"></script> 
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Cierre D&iacute;a SPEI</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cierreDiaSpeiBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">	
			
				<tr>
					<td class="label"> 
					  <label for="tipoOperacion">Tipo Operaci&oacute;n: </label> 
					</td>
					<td class="label"> 
						<form:radiobutton id="cierre1" name="cierre1" path="cierre"
					 		value="D" tabindex="1" checked="checked" />
						<label for="fisica">Cierre D&iacute;a</label>
						<form:radiobutton id="cierre2" name="cierre2" path="cierre" 
							value="P" tabindex="2"/>
						<label for="fisica">Cierre Parcial</label>	
					</td>
				</tr>
			
				
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblInstitucion">Instituci&oacute;n: </label></td>
				   <td> <input type="text" id="institucionID" name="institucionID" size="5" tabindex="8"/>
				  <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="3" disabled="true" readonly="true">
				  </td>
				</tr>
				
				<tr>
	  			    <td class="label" nowrap="nowrap"><label for="lblCtaBancaria">Cuenta Bancaria: </label></td>
					<td><input type="text" id="cuentaBancos" name="cuentaBancos" size="25" tabindex="4"/>
				</tr>	
				
					
				<tr>
	  				<td class="label" nowrap="nowrap"><label for="lblMonto">Monto a Transferir: </label></td>
					<td><input id="monto" name="monto" size="12" tabindex="5" type="text" 
					 disabled="true" readonly="true" iniForma="false"  esMoneda="true" style='text-align: right;'/></td>	
				</tr>
				
				<tr>
	  				<td class="label" nowrap="nowrap"><label for="lblSaldo">Saldo Actual: </label></td>
					<td><input id="saldo" name="saldo" size="12" type="text"
					 esMoneda="true" disabled="true" readonly="true" style='text-align: right;' tabindex="6"/></td>	
				</tr>
						
				<tr>		
					<td colspan="5">
						<table align="right" border='0'>
							<tr align="right">					
								<td align="right">
								  <a target="_blank" >				
									<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="7"  />	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>					             		 
				                  </a>
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>	
</div>
<div id="cargando" style="display: none;">	
</div>				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>