<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	   <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/abonoChequeSBCServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/cancelaChequeSBCServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>   
       <script type="text/javascript" src="dwr/interface/cuentasPersonaServicio.js"></script>           

      <script type="text/javascript" src="js/cuentas/cancelaChequeSBC.js"></script>     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelaCheques">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cancelación de Cheques SBC</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label"> 
		    	<label for="lblCuentaAhoID">Cuenta: </label> 
			</td>
			<td>
				<form:input type="text" id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="12" tabindex="3"/>  
				<form:input id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID" style="display: none;"  type="text"    size="7" readOnly="true" 
		        			iniForma="false" tabindex="7" />	
		       
			</td>
			
		 <td class="separador"></td> 
		 <td class="label">
			<label for="lbltipoCuenta">Tipo de Cuenta: </label> 
			</td>
			<td>
				<form:input id="tipoCuenta" name="tipoCuenta"  path="tipoCuenta" type="text"  size="25" readOnly="true" 
		        			iniForma="false" tabindex="4"/>  
			</td>
			
			
	   </tr>
	   <tr>
	   	<td class="label"> 
		    <label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
	    </td> 
		<td> 
		     	<form:input id="clienteID" name="clienteID" path="clienteID" size="12" 
		        	readOnly="true" tabindex="5"/>
		        <input id="nombreCte" name="nombreCte"size="50" type="text" readOnly="true" 
		        			iniForma="false"/>
		  	</td>
		  	
				 <td class="separador"></td> 
				 <td class="label">
		    	<label for="lblsaldoDispon">Saldo Disponible: </label> 
			</td>
			<td>
				<form:input id="saldoDispon" name="saldoDispon" path="saldDispo" size="20" esMoneda="true" readOnly="true" 
		        		iniForma="false" tabindex="6"/>  
			</td>
		  	
		</tr>
		
		<tr> 
			<td class="label"> 
		    	<label for="lblsaldoSBC">Saldo SBC:</label> 
			</td> 		     		
		    <td>
		    	<form:input id="saldoSBC" name="saldoSBC" path="saldoSBC" size="20" readOnly="true" 
		        			iniForma="false" tabindex="6"/>  

 			
		   	</td> 
		   			
		   		 <td class="separador"></td> 
				 <td class="label">
		    	<label for="lblmonto">Comisi&oacute;n por Falso Cobro: </label> 
			</td> 
		    <td> 
		    	<form:input id="comFalsoCobro" name="comFalsoCobro" path="comFalsoCobro"  esMoneda="true" readOnly="true"  size="7" 
		        		iniForma="false" tabindex="7"/>
			</td>
		</tr> 	
		
		<tr>
	
		<td class="label">
		    	<label for="lblmontoIva">IVA Comisi&oacute;n: </label> 
			</td> 
		    <td> 
		    	<form:input id="montoIva" name="montoIva" path="montoIva"  esMoneda="true" size="7" readOnly="true" 
		        			iniForma="false" tabindex="8"/>
			</td>

		</tr>

		
			<tr> 	
			<td class="label"> 
		    	<label for="lblchequeSBCID">Cheque:</label> 
			</td> 		     		
		    <td>
		    <form:select id="chequeSBCID" name="chequeSBCID" path="chequeSBCID"  tabindex="9" >
					</form:select>
		     
		   	</td> 
		   	<td class="separador"></td> 
		   	<td class="label"> 
		    	<label for="lblfechaRec">Fecha Recepción:</label> 
			</td> 		     		
		    <td>
		    	<form:input id="fechaRec" name="fechaRec" path="fechaRec" size="15" readOnly="true" 
		        	iniForma="false" tabindex="6"/>  
		   	</td> 	
			</tr> 
				
		<tr> 
			 <td class="label">
		     <label for="lblbancEmi">Banco Emisor: </label> 
			</td> 
		    <td> 
		    	<form:input id="bancoEmisor" name="bancoEmisor" path="bancoEmisor" size="7" readOnly="true" 
		        			iniForma="false" tabindex="7"/>
		        <form:input id="descbancoEmisor" name="descbancoEmisor" path="descbancoEmisor" size="55" readOnly="true" 
		        			iniForma="false" tabindex="7"/>
			</td>
			<td class="separador"></td> 
			<td class="label"> 
		    	<label for="lblcuentaE">No. Cuenta Emisor:</label> 
			</td> 		     		
		    <td>
		    	<form:input id="cuentaEmisor" name="cuentaEmisor" path="cuentaEmisor" size="15" readOnly="true" 
		        			iniForma="false" tabindex="6"/>  
		   	</td> 
			
		</tr> 
			<tr> 
				<td class="label">
		    	<label for="lblnombEmisor">Nombre Emisor: </label> 
			</td> 
		    <td> 
		    	<form:input id="nombreEmisor" name="nombreEmisor" path="nombreEmisor" size="68" readOnly="true" 
		        			iniForma="false" tabindex="7"/>
			</td>
			<td class="separador"></td> 
			<td class="label"> 
		    	<label for="lblmontoCheque">Monto:</label> 
			</td> 		     		
		    <td>
		    	<form:input id="montoCheque" name="montoCheque" path="montoCheque" size="20"  esMoneda="true" readOnly="true" 
		        			iniForma="false" tabindex="6"/>  
		   	</td> 	
		</tr> 
		
		
	</table>
	
		<table align="right">
			<tr>
				<td align="right">
				
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="8"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
	
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