<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>  
 	   	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>  
		<script type="text/javascript" src="js/cuentas/cuentaFirmaCatalogo.js"></script>
	</head>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasFirmaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Firmas Autorizadas</legend> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Datos del <s:message code="safilocale.cliente"/></legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%">    	 	
				<tr>
					<td class="label"> 
			         <label for="lblCuentaAhoID">Cuenta: </label> 
			     	</td>
			     	<td>
						<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" 
			         		iniForma = 'false' tabindex="1"/> 
				  	</td> 
				    <td class="separador"></td> 	
				    <td class="label"> 
				    	<label for="lblCuentaAhoID">Tipo Cuenta: </label> 
				   	</td>
				    <td>
				    	<input id="tipoCuenta" name="tipoCuenta" size="25" iniForma = 'false'  
				     		type="text" readOnly="true" disabled="true"  />
				  	</td>       
				</tr> 
				<tr>	   	
					<td class="label" > 
				    	<label for="lblNombreCliente"><s:message code="safilocale.cliente"/>: </label> 
				 	</td> 
				    <td> 
				    	<input id="numCliente" name="numCliente" size="11" iniForma = 'false' type="text" 
				        	readOnly="true" disabled="true" tabindex="2" />
				        <input id="nombreCliente" name="nombreCliente" size="60" iniForma = 'false' 
				         	type="text" readOnly="true" disabled="true" />
				  	</td> 		
				</tr> 
				<tr>
					<td class="label"> 
				     	<label for="lblSaldo">Saldo: </label> 
				   	</td>
				    <td>
				    	<input id="saldoDispon" name="saldoDispon" size="25" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" />
				   	</td> 
				    <td class="separador"></td> 
					<td class="label"> 
				    	<label for="lblMoneda">Moneda: </label> 
				   	</td> 
				    <td> 
				    	<input id="moneda" name="moneda" size="25" iniForma = 'false'
				        		type="text" readOnly="true" disabled="true"/>
				    </td> 
				</tr> 
				<tr>
					<td align="right" colspan="5">
						<button type="button" class="submit" id="consultar">Consultar</button> 
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion""/>				
					</td>
				</tr>
			</table>
			<input type="hidden" id="firmantes" name="firmantes" size="80" />
		</fieldset>   
	   
		<div id="gridFirmantes" style="display: none;"></div>
		
		<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
			<tr>
				<td colspan="4" align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" 
						style="display: none;"/>
					<a id="enlace" href="ImpresionFirmas.htm" target="_blank">
                    	<button type="button" class="submit" id="imprimir" style="display: none;">Imprime</button>
                    </a>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion""/>				
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