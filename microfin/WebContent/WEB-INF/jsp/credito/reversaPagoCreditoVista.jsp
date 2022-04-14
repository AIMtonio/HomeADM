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
	  <script type="text/javascript" src="dwr/interface/respaldoPagoCreditoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/ingresosOperacionesServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>	
	  <script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
	  <script type="text/javascript" src="js/credito/reversaPagoCredito.js"></script>  
				
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reversaPagoCreditoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reversa de Pago de Cr&eacute;dito</legend>
	<table border="0" width="960px">
		<tr>
			<td class="label">
				<label for="creditoID">Cr&eacute;dito: </label>
			</td>
			<td>
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12"  
								iniForma = 'false'  tabindex="1" />
			</td>					
			<td class="separador"></td>				
			<td class="label" nowrap="nowrap">
				<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
			</td>
			<td nowrap="nowrap">
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
				<input id="estatus" name="estatus" size="12" tabindex="5" type="text" readOnly="true" disabled="true"/>
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
		        		tabindex="9" type="text" readOnly="true" disabled="true"/>
		        <input id="monedaDes" name="monedaDes" size="12" 
		         			tabindex="10" type="text" readOnly="true" disabled="true"/>
			</td>
	
    	</tr>
		<tr>	
		<td class="label" nowrap="nowrap">
			<label for="producCreditoID">Producto Cr&eacute;dito: </label>
			</td>
			<td nowrap="nowrap">
				<input id="producCreditoID" name="producCreditoID" size="12" 
		       			tabindex="11" type="text" readOnly="true" disabled="true"/>		
		       	<input id="descripProducto" name="descripProducto" size="35" 
		       			tabindex="12" type="text" readOnly="true" disabled="true"/>								
			</td>
			<td class="separador"></td>
			
			<td class="label"  id = "tdGrupoGrupoCredlabel" style="display: none;"><label for="lblmonedacr">Grupo:
			</label></td>
			<td id = "tdGrupoGrupoCredinput" style="display: none;">
				<form:input id="grupoID" name="grupoID" path="grupoID" size="12"
				 tabindex="13" type="text" readOnly="true"
				disabled="true" /> <input id="grupoDes" name="grupoDes"
				size="30" tabindex="14" type="text" readOnly="true" 
				disabled="true" />
				<form:input id="cicloID" name="cicloID" size="10" tabindex="15" type="hidden" readOnly="true" 
					path="cicloID"/></td>
		</tr>
		<tr>
		<td class="label">
			<label for="cuentaID">Cuenta: </label>
		</td>
		<td >
			<input type="text" id="cuentaID" name="cuentaID" size="12"   readOnly="true" disabled="true"
		       	tabindex="16" type="text" />
		    <input id="nomCuenta" name="nomCuenta"  size="35" 
		       			tabindex="18" type="text" readOnly="true" disabled="true"/>							
		</td>
		<td class="separador"></td>
		<td class="label" nowrap="nowrap">
			<label  for="saldo">Saldo Cuenta: </label>
		</td>
		<td >
			<input id="saldoCta" name="saldoCta" size="12" 
		       	 tabindex="20" type="text" readOnly="true" disabled="true"  style="text-align: right"/> 
		</td>
		</tr>
		
		<tr>
		<td class="label">
			<label for="lblMonto">Monto Cr&eacute;dito:</label>
		</td> 
		<td> 
		    <input id="montoCredito" name="montoCredito" size="12" readOnly="true" disabled="true" tabindex="22" 
		    type="text" style="text-align: right" />
		</td>
		<td class="separador"></td>
		<td class="label" nowrap="nowrap">
			<label id="lbltasaFija" for="tasaFija">Tasa Fija:</label>
		</td> 
		<td> 
		    <input id="tasafija" name="tasafija" size="12" readOnly="true" disabled="true" tabindex="24" 
		    type="text" style="text-align: right" esTasa="true"/>
		    <label for="porcentaje">%</label> 
		</td>		
		</tr>

 		<tr name="tasaBase">
	   		<td class="label" nowrap="nowrap"> 
        		<label for="lblcalInter">C&aacute;lculo de Inter&eacute;s: </label> 
    		</td> 
    		 <td>
    		<form:select id="calcInteres" name="calcInteres" path="" tabindex="24" disabled= "true">
				<form:option value="">SELECCIONAR</form:option>
			</form:select>	
			</td>
			<td class="separador"></td>
			<td class="separador"></td>
			<td class="separador"></td>
		</tr>
		<tr name="tasaBase">
			<td class="label">
				<label for="TasaBase">Tasa Base: </label> 
			</td>
		   	<td>
				<input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="12" 
					readonly="true" disabled="true" tabindex="60"  />
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="35" 
				    readonly="true" disabled="true" tabindex="61"/>			 	
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="SobreTasa">Valor Tasa Base: </label> 
			</td>
		   	<td>
				<input type="text" id="tasaBaseValor" name="tasaBaseValor" path="" size="12"
			 		esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label> 
			</td>
		</tr>
		<tr name="tasaBase">
			<td class="label">
				<label for="SobreTasa">SobreTasa: </label> 
			</td>
		   	<td>
				<input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="12"
			 		esTasa="true" tabindex="63" readOnly="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label> 
			</td>
			<td class="separador"></td>
			<td class="label" name="tasaPisoTecho">
				<label for="PisoTasa">Piso Tasa: </label> 
			</td>
		   	<td name="tasaPisoTecho">
			 	<input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="12"
			 		style="text-align: right;" esTasa="true" readOnly="true" disabled="true" tabindex="64"/>
			 	<label for="porcentaje">%</label> 
			</td>
		</tr>
		<tr name="tasaBase">
			<td class="label" name="tasaPisoTecho">
				<label for="TechoTasa">Techo Tasa: </label> 
			</td>
		   	<td name="tasaPisoTecho">
				<input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="12"
			 		style="text-align: right;" esTasa="true" readOnly="true" disabled="true" tabindex="65" />
			 	<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
			<td class="separador"></td>
			<td class="separador"></td>
		</tr>
	</table>	
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Pago</legend>
			<div>
				<table>
				<tr>
					<td class="label" nowrap="nowrap">
					<label for="lblNoTransaccion">No. Trans. a Reversar:</label>
					</td> 
					<td> 
					    <input id="tranRespaldo" name="tranRespaldo" size="12" readOnly="true" disabled="true" tabindex="28" 
					    type="text" style="text-align: right" />
					</td>
					<td class="separador"></td>
					
					
				</tr>
				<tr>
					
					<td class="label">
						<label for="lblFormaPago">Forma de Pago: </label>
					</td>
					<td>
					    <select id="formaPago" name="formaPago"   tabindex="30" disabled="true">
						    <option value="">--</option>
					     	<option value="E">EFECTIVO</option>
					     	<option value="C">CARGO A CUENTA</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="lblMontoPagado">Monto Pago Cr&eacute;dito:</label></td> 
					<td> 
					    <input id="montoPagado" name="montoPagado" size="12" readOnly="true" disabled="true" tabindex="29" 
					    type="text" style="text-align: right"  esMoneda="true"/>
					</td>							
				</tr>
				<tr>											
					<td class="label" nowrap="nowrap" id="lblGAdicional"><label for="lblGA">Garant&iacute;a Adicional:</label></td> 
					<td id="tdGarantiaAdicional"> 
					    <input id="garantiaAdicional" name="garantiaAdicional" size="12" readOnly="true" disabled="true" tabindex="28" 
					    type="text" style="text-align: right" esMoneda="true"/>
					</td>
					<td class="separador" id="tdSeparadorMontoTotal"></td>
					<td class="label"><label for="lblMontoTotal">Monto Total:</label></td> 
					<td> 
					    <input id="monto" name="monto" size="12" readOnly="true" disabled="true" tabindex="29" 
					    type="text" style="text-align: right" esMoneda="true"/>
					     <input id="ctaGarantiaAdicional" name="ctaGarantiaAdicional" size="12" readOnly="true" disabled="true" tabindex="29" 
					    type="hidden"/>
					</td>					
				</tr>
			</table>
			</div>
		</fieldset>
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
	<fieldset class="ui-widget ui-widget-content ui-corner-all">     
	<legend>Usuario Autoriza</legend>           
		<table border="0" cellpadding="0" cellspacing="0" width="900px">
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="mot">Motivo: </label>
				</td>
				<td >
				<form:textarea id="motivo" name="motivo" rows="2" cols="50" path="motivoReversa" size="18" maxlength ="200"
		         		tabindex="40" type="text"  onblur=" ponerMayusculas(this)"/> 		         	
				</td>					
				<td class="separador"></td>				
				
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="usuarioA">Usuario Autoriza: </label>
				</td>
				<td >
					<form:input id="usuarioAutorizaID" name="usuarioAutorizaID" size="50" path="usuarioAutorizaID" 
		         			tabindex="41" type="password" />
				</td>
				
			</tr>				
			<tr>
			 	<td class="label" nowrap="nowrap"> 
			    	<label for="pass">Password:</label>				      	 
			  	</td> 
			    <td> 
			    <form:input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza" 
			    	path="contraseniaUsuarioAutoriza" value="" size="50"  tabindex="42" autocomplete="new-password" />
			    </td>
			</tr>
			<span id="statusSrvHuella" style="float: right; display: none;"></span>
		</table>
		<input id="fechaSistema" name="fechaSistema"  size="12"  tabindex="43" type="hidden"/>
	</fieldset>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
		<tr>
			<td align="right">
				<input type="button" id="aceptar" name="aceptar" class="submit"
											 tabIndex = "45" value="Reversar" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="listaReversaPagoCredito" name="listaReversaPagoCredito"  />
				
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
