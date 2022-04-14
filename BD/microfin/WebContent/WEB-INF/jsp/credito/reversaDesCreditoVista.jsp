<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      
      <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>     
      <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script> 								
	  <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	  <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>	
	  <script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
      <script type="text/javascript" src="js/credito/reversaDesCredito.js"></script>  
				
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reversaDesCreditoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reversa de Desembolso</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="960px">
		<tr>
			<td class="label">
				<label for="creditoID">Cr&eacute;dito: </label>
			</td>
			<td >
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12"  
								iniForma = 'false'  tabindex="1" />
			</td>					
			<td class="separador"></td>				
			<td class="label">
				<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
			</td>
			<td >
				<input id="clienteID" name="clienteID" size="12" 
		        		tabindex="2" type="text" readOnly="true" disabled="true"/>
		        <input id="nombreCliente" name="nombreCliente" size="50" 
		         			tabindex="3" type="text" readOnly="true" disabled="true"/>							
			</td>	
		</tr>
		<tr>
			<td class="label">
				<label for="lblPagaIVA">Paga IVA: </label>
			</td>
			<td>
			    <select id="pagaIVA" name="pagaIVA"   tabindex="4" disabled="true">
				    <option value="">--</option>
			     	<option value="S">SI</option>
			     	<option value="N">NO</option>
				</select>
			</td>
			<td class="separador"></td>				
			<td class="label"> 
				<label for="lblestatus">Estatus:</label>				      	 
			</td> 
			<td> 
				<input id="estatus" name="estatus" size="15" tabindex="5" type="text" readOnly="true" disabled="true"/>
			</td>
		</tr>
		<tr>
		<td class="label">
			<label  for="fechaIn">Fecha Inicio: </label>
			</td>
			<td >
				<input id="fechaInicio" name="fechaInicio" size="12" 
		        		tabindex="8" type="text" readOnly="true" disabled="true"/>
			</td>
						<td class="separador"></td>
			
		    <td class="label">
				<label  for="moneda">Moneda: </label>
			</td>
			<td >
				<input id="monedaID" name="monedaID"  size="12" 
		        		tabindex="6" type="text" readOnly="true" disabled="true"/>
		        <input id="monedaDes" name="monedaDes" size="12" 
		         			tabindex="7" type="text" readOnly="true" disabled="true"/>
			</td>
	
    	</tr>
		<tr>	
		<td class="label">
			<label for="producCreditoID">Producto Cr&eacute;dito: </label>
			</td>
			<td >
				<input id="producCreditoID" name="producCreditoID" size="12" 
		       			tabindex="10" type="text" readOnly="true" disabled="true"/>		
		       	<input id="descripProducto" name="descripProducto" size="40" 
		       			tabindex="11" type="text" readOnly="true" disabled="true"/>								
			</td>
			<td class="separador"></td>
			
			<td class="label"  id = "tdGrupoGrupoCredlabel" style="display: none;"><label for="lblmonedacr">Grupo:
			</label></td>
			<td id = "tdGrupoGrupoCredinput" style="display: none;">
				<form:input id="grupoID" name="grupoID" path="grupoID" size="12"
				 tabindex="12" type="text" readOnly="true"
				disabled="true" /> <input id="grupoDes" name="grupoDes"
				size="30" tabindex="13" type="text" readOnly="true" 
				disabled="true" />
				<form:input id="cicloID" name="cicloID" size="10" tabindex="13" type="hidden" readOnly="true" 
					path="cicloID"/></td>
		</tr>
		<tr>
		<td class="label">
			<label for="cuentaID">Cuenta: </label>
		</td>
		<td >
			<input type="text" id="cuentaID" name="cuentaID" size="12"   readOnly="true" disabled="true"
		       	tabindex="14" type="text" />
		    <input id="nomCuenta" name="nomCuenta"  size="30" 
		       			tabindex="15" type="text" readOnly="true" disabled="true"/>							
		</td>
		<td class="separador"></td>
		<td class="label">
			<label  for="saldo">Saldo Cuenta: </label>
		</td>
		<td >
			<input id="saldoCta" name="saldoCta" size="12" 
		       	 tabindex="16" type="text" readOnly="true" disabled="true"  style="text-align: right"/> 
		</td>
		</tr>
		
		<tr>
		<td class="label">
			<label for="lblMonto">Monto Cr&eacute;dito:</label>
		</td> 
		<td> 
		    <input id="montoCredito" name="montoCredito" size="12" readOnly="true" disabled="true" tabindex="17" 
		    type="text" style="text-align: right" />
		</td>
		</tr>
	</table>
		<br>
		<br>
	<table>
	        <input type="hidden" id="integrantes" name="integrantes" size="100" />	
		<tr>
		    <td colspan="11">
				<div id="gridIntegrantes" style="display: none;"/>							
			</td>								
		</tr>
	</table>
		<br>
		<br>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<table border="0" cellpadding="0" cellspacing="0" width="900px">
			<tr>
				<td class="label">
					<label for="mot">Motivo: </label>
				</td>
				<td >
					<form:textarea id="motivo" name="motivo" rows="5" cols="20" path="motivoReversa" size="18" maxlength ="400"
		         		tabindex="18" type="text" />
				</td>					
				<td class="separador"></td>				
				
			</tr>
			<tr>
				<td class="label">
					<label for="usuarioA">Usuario Autorizado: </label>
				</td>
				<td >
					<form:input id="usuarioAutorizaID" name="usuarioAutorizaID" size="12" path="usuarioAutorizaID" 
		         			tabindex="19" type="password" />
				</td>
				
			</tr>				
			<tr>
			 	<td class="label"> 
			    	<label for="pass">Password:</label>				      	 
			  	</td> 
			    <td> 
			    <form:input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza" path="contraseniaUsuarioAutoriza" value="" tabindex="20" autocomplete="new-password" />
			    </td>
			</tr>
			<span id="statusSrvHuella" style="float: right; display: none;"></span>
		</table>
		<input id="fechaSistema" name="fechaSistema"  size="12"  tabindex="40" type="hidden"/>
	</fieldset>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
		<tr>
			<td align="right">
				<input type="button" id="aceptar" name="aceptar" class="submit"
											 tabIndex = "22" value="Aceptar" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="listaReversaDes" name="listaReversaDes"  />
				
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
