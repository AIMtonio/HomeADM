<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
 
	<head>	
 	   <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>               
		<script type="text/javascript" src="js/credito/condicionesLineaCredito.js"></script>        
	</head>
    
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineasCreditoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Condiciones de Línea de Cr&eacute;dito</legend>
					
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
					<td class="label"> 
		         	<label for="lbllineaCreditoID">Línea Crédito: </label> 
				   </td>
				   <td> 
				      <form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" 
				      tabindex="1" numMax ="12" />  
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="2" 
		         	numMax ="10" readOnly= "true" disabled = "true" />
		         	<input type="text" id="nombreCte" name="nombreCte"size="50"  tabindex="3" 
		         		readOnly= "true" disabled = "true" />
		     		</td> 
				</tr>
				<tr>  
		     		<td class="label"> 
		         	<label for="lblCuentaAhoID">Cuenta: </label> 
				   </td>
				   <td>
				      <form:input id="cuentaID" name="cuentaID" path="cuentaID" size="13" tabindex="4" numMax ="10"  readOnly="true" disabled = "true"/>  
				   	<input id="desCuenta" name="desCuenta" size="25"  type="text" readOnly="true"
		         			tabindex="5" disabled = "true"/>   
				   </td>
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblMonedaID">Moneda: </label> 
		     		</td>  
		     		<td> 
						<form:input id="monedaID" name="monedaID" path="monedaID" size="3" 
		         			readOnly="true" disabled="true" tabindex="6"/>
		         	<input id="moneda" name="moneda"size="25"  type="text" readOnly="true"
		         			tabindex="9" disabled = "true"/> 
		     		</td> 
		 		</tr>
		 		<tr> 
		     		<td class="label">  
				   	<label for="lblSucursalID">Sucursal: </label> 
				   </td> 
				   <td> 
				      <form:input id="sucursalID" name="sucursalID" path="sucursalID" size="7" tabindex="7"
				      	disabled = "true" readOnly="true" numMax ="10" />
				      <input id="sucursal" name="sucursal"size="29"  type="text" tabindex="4" 
				      		 readOnly="true" disabled = "true" /> 
				   </td>  
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblfolioContrato">Folio Contrato: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="folioContrato" name="folioContrato" path="folioContrato" size="20" tabindex="8" readOnly= "true" disabled = "true" />  
		     		</td>
		 		</tr>  
		 		<tr>  
		     		<td class="label"> 
		         	<label for="lblproductoCreditoID">Tipo Cr&eacute;dito:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="5" 
		         	 		tabindex="11" readOnly="true" disabled = "true"/> 
		         	 <input type="text" id="desProductoCred" name="desProductoCred" path="desProductoCred" size="45" 
		         	 		tabindex="11" readOnly="true" disabled = "true"/>  
		     		</td> 	 
		     		<td class="separador"></td> 
					<td class="label"> 
		         	<label for="lblsolicitado">Monto Solicitado:</label> 
					</td> 		     		
		     		<td> 
		         	 <form:input id="solicitado" name="solicitado" path="solicitado" size="20" 
		         	 		tabindex="11" esMoneda="true" style="text-align: right" readOnly= "true" disabled = "true" />  
		     		</td> 	
		     		<td class="separador"></td>
		 	 </tr> 	   
		 		<tr id= "valores1">
		     		<td class="label"> 
		         	<label for="lblautorizado">Monto Autorizado: </label> 
		     		</td>  
		     		<td> 
		         	 <form:input id="autorizado" name="autorizado" path="autorizado" size="20" tabindex="13"
		         	 		readOnly="true" disabled = "true" esMoneda="true" style="text-align: right"/>  
		     		</td>
		 			<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lbldispuesto">Monto Dispuesto:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="dispuesto" name="dispuesto" path="dispuesto" size="20" tabindex="14"
		         	 		readOnly="true" disabled = "true" esMoneda="true" style="text-align: right"/>  
		     		</td> 	
		     	</tr>
		     	<tr id= "valores2">
		     		<td class="label"> 
		         	<label for="lblpagado">Monto Pagado: </label> 
		     		</td>  
		     		<td> 
		         	 <form:input id="pagado" name="pagado" path="pagado" size="20" tabindex="15"
		         	 		readOnly="true" disabled = "true" esMoneda="true" style="text-align: right"/>  
		     		</td>
		 			<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblsaldo">Saldo Disponible:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="saldoDisponible" name="saldoDisponible" path="saldoDisponible" size="20" tabindex="16" esMoneda="true"
		         	 		readOnly="true" disabled = "true" style="text-align: right"/>  
		     		</td> 
		     	</tr>
		     	<tr id= "valores3">			 			
		 			
		     		<td class="label"> 
		         	<label for="lblsaldo">Saldo Deudor:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="saldoDeudor" name="saldoDeudor" path="saldoDeudor" size="20" tabindex="17" esMoneda="true"
		         	 		readOnly="true" disabled = "true" style="text-align: right"/>  
		     		</td> 
		     		
		     	   <td class="separador"></td> 
		     		
		     		<td class="label"> 
		         	<label for="lblestatus">Estatus: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="estatus" name="estatus" path="estatus" size="12" tabindex="18"
		         	 		readOnly="true" disabled = "true" style="text-align: right" />  
		     		</td>
		     	</tr>   
	
		 		<tr>   
		 			
		     		<td class="label"> 
		         	<label for="lblnumeroCreditos">Número Créditos:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="numeroCreditos" name="numeroCreditos" path="numeroCreditos" size="12" 
		         	 		tabindex="19" readOnly="true" disabled = "true" style="text-align: right" />  
		     		</td> 	
		  		    <td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblMontoAumentar">Monto Aumentar:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="excedente" name="excedente" path="excedente" size="20" esMoneda="true"
		         	 		tabindex="20" style="text-align: right" />  
		         	 <label for="lblExcedente">(Excedente)</label> 
		         	 		
		     		</td> 	
		     	</tr> 
		     	<tr> 
		     		<td class="label"> 
		         	<label for="lblfechaInicio">Fecha Inicio:</label> 
					</td> 		     		
		     		<td>
		         	 <form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
		         	 	 readOnly="true" disabled = "true" />  
		     		</td> 	
		     		<td class="separador"></td>  
		     		<td class="label"> 
		         	<label for="lblfechaVencimiento">Fecha Vencimiento: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="12" 
		         	 		tabindex="21" esCalendario="true"/>  
		     		</td>
		 		</tr>    
		     	</table>  

		     	<table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
				<tr>
					<td colspan="5">
						<table align="right"> 
							<tr>
								<td align="right">
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="19"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="aumentado" name="aumentado"/>	
									<input type="hidden" id="montoMinimo" name="montoMinimo" />				
									<input type="hidden" id="montoMaximo" name="montoMaximo"/>				
		
								</td>
							</tr>
						</table>		
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