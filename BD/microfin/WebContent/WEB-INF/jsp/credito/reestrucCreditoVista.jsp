<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/clasifrepregServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>   
      	<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/reestrucCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>   
		<script type="text/javascript" src="js/credito/reestrucCreditoVista.js"></script> 
		  
		
	</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Reestructura de Cr&eacute;dito</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="creditoID">N&uacute;mero: </label>
			</td> 
			<td >
				<form:input  type="text" id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="solicitudCreditoID">Solicitud: </label> 
			</td>
			<td>
				<form:input  type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID"
				 	size="12" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
			</td> 
			<td nowrap="nowrap">
				<form:input  type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="3" />
				<input type="text" id="nombreCliente" name="nombreCliente" readonly="readonly" disabled="disabled" size="45" /> 
			</td>				
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="producCreditoID">Producto de Cr&eacute;dito: </label>
			</td> 
			<td nowrap="nowrap">
				<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="5" readonly="readonly" disabled="disabled"/>
				<input type="text" id="nombreProd" name="nombreProd" readonly="readonly" disabled="disabled" size="50" /> 
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="clasificacion">Clasificaci&oacute;n: </label>
			</td> 
			<td>
				<input type="text" id="clasificacion" name="clasificacion" size="12"  readonly="readonly" disabled="disabled"/>
				<input type="text" id="DescripClasific" name="DescripClasific" size="45"  readonly="readonly" disabled="disabled"/>
			</td>	
			<td class="separador"></td>
			<td class="label">
				<label for="cuentaID">Cuenta: </label>
			</td> 
			<td>
				<form:input type="text" id="cuentaID" name="cuentaID" path="cuentaID" size="12" tabindex="9" disabled="true" />
			</td>			
		</tr>
		<tr>	
			<td class="label">
				<label for="estatus">Estatus:</label> 
			</td>
			<td>
				<form:select id="estatus" name="estatus" path="estatus"  tabindex="10" disabled="true">
					<form:option value="I">INACTIVO</form:option>
				    <form:option value="V">VIGENTE</form:option>
					<form:option value="P">PAGADO</form:option>
					<form:option value="C">CANCELADO</form:option>
					<form:option value="A">AUTORIZADO</form:option>
					<form:option value="B">VENCIDO</form:option>
					<form:option value="K">CASTIGADO</form:option>
				</form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="destinoCreID">Destino: </label> 
			</td>
		    <td>
		 	<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="12" tabIndex="11" />
			 	<input type="text" id="descripDestino" name="descripDestino"  readonly="readonly" disabled="disabled" size="50"  /> 
			</td>	
		</tr>
		<tr>			
			<td class="label">
				<label for="destinCredFRID" >Destino Cr&eacute;dito FR: </label> 
	     	</td> 
	     	<td>
				<input type="text" id="destinCredFRID" 		name="destinCredFRID"  size="12"   readonly="readonly" disabled="disabled" />
				<input type="text" id="descripDestinoFR" 	name="descripcionoDestinFR" size="45" readonly="readonly" disabled="disabled" />    
			</td>	
				<td class="separador"></td>
			<td class="label">
				<label for="destinCredFOMURID">Destino de Cr&eacute;dito FOMUR: </label> 
	     	</td> 
	     
	     	<td>
				<input type="text" id="destinCredFOMURID"	name="destinCredFOMURID"  size="12" readonly="readonly"  disabled="disabled" />
				<input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="50" readonly="readonly" disabled="disabled"/>  
			</td>
		</tr>
		<tr> 						     
			<td class="label"> 
				<label for="clasiDestinCred">Clasificaci&oacute;n: </label> 
			</td>
		    <td>						    	  
		    	<input type="radio" id="clasificacionDestin1" name="clasiDestinCred"  value="C" disabled="disabled" readonly="readonly"  />
					<label for="lblcomercial">Comercial</label>
				<input type="radio" id="clasificacionDestin2" name="clasiDestinCred"  value="O" disabled="disabled" readonly="readonly"  />
					<label for="lblConsumo">Consumo</label>
				<input type="radio" id="clasificacionDestin3" name="clasiDestinCred"  value="H" disabled="disabled" readonly="readonly" />
					<label for="lblHipotecario">Vivienda</label>
				<input type="hidden" id="clasiDestinCred" name="clasiDestinCred"size="60" readonly="readonly" disabled="disabled" />  
			</td> 
		</tr> 				
	</table>
	
	<br>

	<div id="creditoRees" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Cr&eacute;dito a Reestructurar</legend>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap">
					 <label for="relacionado">Cr&eacute;dito a Reestructurar:</label>
				</td> 
			   	<td >
			   		<select id="relacionado" name="relacionado" path="relacionado" iniForma="false" tabindex="20">
			   			<option value="">SELECCIONAR</option>
			   		</select>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="producCreditoIDOrigen">Producto de Cr&eacute;dito: </label>
				</td> 
			   	<td>
				 	<input type="text" id="producCreditoIDOrigen" name="producCreditoIDOrigen" size="15" readonly="readonly" disabled="disabled" iniForma="false"/>
				 	<input type="text" id="nombreProdOrigen" name="producCreditoIDOrigen"  readonly="readonly" disabled="disabled" size="50" iniForma="false"/> 
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="estatusOrigen">Estatus:</label> 
				</td>
			   	<td>
			   		<select id="estatusOrigen" name="estatusOrigen" tabindex="23" disabled="true" iniForma="false">
				    	<option value="I">INACTIVO</option>
				     	<option value="V">VIGENTE</option>
						<option value="P">PAGADO</option>
						<option value="C">CANCELADO</option>
						<option value="A">AUTORIZADO</option>
						<option value="B">VENCIDO</option>
						<option value="K">CASTIGADO</option>
					</select>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="diasAtrasoOrigen">Dias Atraso: </label>
				</td> 
				<td >
					<input type="text" id="diasAtrasoOrigen" name="diasAtrasoOrigen"  size="15" iniForma="false" readonly="readonly" disabled="disabled"/> 
				</td>					
			</tr>
			<tr>
				<td class="label">
					<label for="noDias">Fecha Inicio: </label>
				</td> 
				<td >
					<input type="hidden" id="noDias" name="noDias">
					<input type="text" id="fechaInicioOrigen" name="fechaInicioOrigen"  size="15"  iniForma="false" readonly="readonly" disabled="disabled"/> 
				</td>
			   	<td class="separador"></td>
				<td class="label">
					 <label for="fechaVenOrigen">Fecha Vencimiento:</label>
				</td> 
			   	<td >
			   		<input type="text" id="fechaVenOrigen" name="fechaVenOrigen"  size="15"  iniForma="false" readonly="readonly" disabled="disabled"/>
				</td>	
			</tr>
			<tr>
				<td class="label">
					<label for="totalAdeudoOrigen">Total Adeudo: </label>
				</td> 
				<td >
					<input type="text" id="totalAdeudoOrigen" name="totalAdeudoOrigen"  size="15"  esMoneda="true" iniForma="false" 
						reaOnly="true"  style="text-align: right;"/> 
				</td>				
			   	<td class="separador"></td>
				<td class="label">
					 <label for="totalExigibleOrigen">Exigible al d&iacute;a:</label>
				</td> 
			   	<td >
			   		<input type="text" id="totalExigibleOrigen" name="totalExigibleOrigen"  size="15"  esMoneda="true" 
			   			readonly="readonly" disabled="disabled"  iniForma="false" style="text-align: right;"/>
				</td>	
			</tr>
		</table>
	</fieldset>
	</div>
	
	<br> 
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Condiciones</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="montoCredito">Monto: </label> 
			</td>
		   	<td >
				<form:input type ="text" id="montoCredito" name="montoCredito" path="montoCredito" size="15"
			 		esMoneda="true" tabindex="29" style="text-align: right;"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="monedaID">Moneda: </label> 
			</td>
		   	<td >
				<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="30" disabled="true" >
					<form:option value="-1">SELECCIONAR</form:option>
				</form:select> 
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="fechaInicio">Fecha de Inicio : </label> 
			</td>
		   	<td >
			 	<form:input type ="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15"
				 readonly="readonly" disabled="true"/>
			</td>
			<td class="separador"></td>
			<td class="label"> 
				<label for="plazoID">Plazo: </label> 
			</td>   	
			<td> 
		    	<select  id="plazoID" name="plazoID" path="plazoID" tabindex="32" >
					<option value="0">SELECCIONAR</option>
				</select>	
		  	</td> 
		</tr>
		<tr>
			<td class="label">
				<label for="fechaVencimien">Fecha de Vencimiento: </label> 
			</td>
			<td>
				<form:input type ="text" id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="15" 
					readonly="readonly" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="factorMora">Factor Mora: </label> 
			</td>
		   <td>
			 	<form:input type ="text" id="factorMora" name="factorMora" path="factorMora" size="8" readonly="readonly" disabled="disabled" esTasa="true" />
				<label for="lblveces">veces la tasa de inter&eacute;s ordinaria</label> 
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="tipoDispersion">Tipo de Dispersi&oacute;n </label> 
			</td>
		    <td>
		    	<select  id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="35"  >
					<option value="0">SELECCIONAR</option>
				</select>	
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="montoComision">Comisi&oacute;n por Apertura: </label> 
			</td>
		    <td>
			 	<form:input  type ="text" id="montoComision" name="montoComision" path="montoComision" size="15"
			 		esMoneda="true" readonly="readonly" disabled="disabled" style="text-align: right;"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="IVAComApertura">IVA Comisi&oacute;n: </label> 
			</td>
			<td>
				<form:input type="text" id="IVAComApertura" name="IVAComApertura" path="montoComision" 
				 	esMoneda="true" readonly="readonly" disabled="disabled" size="15"  style="text-align: right;"/> 
				<input type="hidden" id="pagaIVACte" name="pagaIVACte" tabindex="38" disabled="true" size="5" />
				<input type="hidden" id="sucursalCte" name="sucursalCte" tabindex="39" disabled="true" size="5"/>
			</td>
		</tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Inter&eacute;s</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="tipoCalInteres">Tipo Cal. Inter&eacute;s : </label> 
			</td>
		   	<td>
		   		<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres"  tabindex="40" disabled="disabled">
					<form:option value="">SELECCIONAR</form:option>
					<form:option value="1">SALDOS INSOLUTOS</form:option>
					<form:option value="2">MONTO ORIGINAL</form:option>
				</form:select>	 	
			</td>		
			<td class="separador"></td>
			<td class="label">
				<label for="calcInteresID">C&aacute;lculo de Inter&eacute;s  : </label> 
			</td>
		   	<td>
		   	<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID"  tabindex="41" disabled="disabled">
				<form:option value="-1">SELECCIONAR</form:option>		
			</form:select>	 	
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="tasaBase">Tasa Base: </label> 
			</td>
		   	<td>
				<form:input  type ="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8" readonly="readonly" disabled="disabled"/>
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="readonly" disabled="disabled"/>			 	
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="tasaFija" id="lblTasaFija">Tasa Fija Anualizada: </label> 
			</td>
			<td>
			 	<form:input  type ="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8"
			 		esTasa="true" readonly="readonly" disabled="disabled"  style="text-align: right;"/>
			 	<label for="porcentaje">%</label> 
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="sobreTasa">Sobre Tasa: </label> 
			</td>
		   	<td>
			 	<form:input type ="text"  id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8"
				 	esTasa="true"  readonly="readonly" disabled="disabled"  style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="pisoTasa">Piso Tasa: </label> 
			</td>
		   	<td >
				<form:input type ="text"  id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8"
			 		esTasa="true"  readonly="readonly" disabled="disabled"  style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="techoTasa">Techo Tasa: </label> 
			</td>
		   	<td>
				<form:input type ="text"  id="techoTasa" name="techoTasa" path="techoTasa" size="8"
			 		esTasa="true" readonly="readonly" disabled="disabled"  style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
		</tr>
	</table>
	</fieldset>
	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend>Calendario de Pagos</legend>		
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	 	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label"> 
				<label for="fechaInhabil">En Fecha Inh&aacute;bil Tomar: </label> 
			</td>
			<td class="label">  
				<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" tabindex="67"  />
				<label for="fechaInhabil1">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
				<input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" tabindex="68" />
				<label for="fechaInhabil2">D&iacute;a H&aacute;bil Anterior</label>
				<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" tabindex="69" readonly="readonly" disabled="disabled"/>
			</td>
		</tr>

		<tr>
			<td class="label"> 
				<label for="ajusFecExiVen">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label> 
				</td>
			<td class="label">  
				<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" tabindex="70" /><label for="ajusFecExiVen1">Si</label>&nbsp;
				<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" tabindex="71" /><label for="ajusFecExiVen2">No</label>
				<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" tabindex="72" readonly="readonly" disabled="disabled"/>
			</td>
		</tr>
		<tr>
			<td class="label"> 
				<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" tabindex="73" value="S"  />
				<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular"  
					readonly="readonly" disabled="disabled" value="N" tabindex="74"/>
	    		<label for="calendIrregularCheck">Calendario Irregular </label> 
		 	</td> 
 		</tr>		
		<tr>
			<td class="label"> 
				<label for="ajusFecUlVenAmo">Ajustar Fecha de Vencimiento de &Uacute;ltima
				 Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label> 
			</td>
			<td class="label">  
				<input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S" tabindex="75" /><label for="ajusFecUlVenAmo1">Si</label>&nbsp;
				<input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N" tabindex="76" /><label for="ajusFecUlVenAmo2">No</label>
				<form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15" tabindex="77" readonly="readonly" disabled="disabled"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="tipoPagoCapital">Tipo de Pago de Capital: </label> 
			</td>
			<td> 
				<select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="78" >
					<option value="">SELECCIONAR</option>
				</select>
				<input type="hidden" id="perIgual" name="perIgual"  size="5"  />
		   </td> 
		</tr>
		<tr class="ocultarSeguros">
			<td class="label"><label>Cobra Seguro Cuota:</label></td>
			<td>
				<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
					<option value="N">NO</option>
					<option value="S">SI</option>
				</form:select>
			</td>
		</tr>
		<tr class="ocultarSeguros">
			<td class="label"><label>Cobra IVA Seguro Cuota:</label></td>
			<td>
				<form:select name="cobraIVASeguroCuota" id="cobraIVASeguroCuota" disabled="true" path="cobraIVASeguroCuota">
					<option value="N">NO</option>
					<option value="S">SI</option>
				</form:select>
			</td>
		</tr>
		</table>
		</fieldset>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	 
			<table>
				<tr>
					<td class="label">Inter&eacute;s</td> 
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="label">Capital</td> 
					<td class="separador" ></td>
				</tr>
					<tr>
						<td class="label">
							<label for="frecuenciaInt">Frecuencia: </label> 
						</td>
						<td> 
				         <select  id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="79" >
						       <option value="">SELECCIONAR</option>
							</select>	
					 	</td> 
					
						<td class="separador"></td>
						<td class="label"> 
							<label for="frecuenciaCap">Frecuencia: </label> 
						</td>
						<td> 
				         	<select  id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="80" >
						       <option value="">SELECCIONAR</option>
							</select>	
					 	</td> 						
					</tr>
					<tr>	
						<td class="label">
							<label for="periodicidadInt">Periodicidad de Inter&eacute;s:</label> 
						</td>
		  				<td> 
			 				<form:input  type="text" id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8"
			 					tabindex="81" disabled="true" />
						</td> 
						<td class="separador"></td>
						<td class="label">
							<label for="periodicidadCap">Periodicidad de Capital:</label> 
						</td>
		   			<td>
			 				<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8" 
			 				tabindex="82" disabled="true" />
						</td>
						
					</tr>
					<tr>
						<td class="label"> 
							<label for="diaPagoInteres">D&iacute;a Pago: </label> 
						</td>
						<td class="separador"></td>
						<td class="separador"></td>  
						<td class="label">  
							<label for="diaPagoCapital">D&iacute;a Pago: </label> 
					 	</td> 
					 	<td class="separador"></td>
					</tr> 
						
					<tr>
						<td>  
							<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="83"  />
							<label for="diaPagoInteres1">&Uacute;ltimo d&iacute;a del mes</label>  
							<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="84" /> 
							<label for="diaPagoInteres2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
							<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" tabindex="85"  />
						</td>
						<td class="separador"></td>
						<td class="separador"></td> 
						<td nowrap="nowrap">  
							<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="86"  />
							<label for="diaPagoCapital1">&Uacute;ltimo d&iacute;a del mes</label>&nbsp;  
							<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" value="A" tabindex="87" />
							<label for="diaPagoCapital2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
							<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" tabindex="88" />
							<input type="hidden" id="diaPagoProd" name="diaPagoProd" size="8" value="I"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"> 
							<label for="diaMesInteres">D&iacute;a del mes: </label> 
						</td>
			 			<td>
			 				<form:input type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8"
			 					tabindex="89" disabled="true"/>
						</td>
						<td class="separador"></td> 
						<td class="label">  
							<label for="diaMesCapital">D&iacute;a del mes: </label> 
						</td>
			 			<td> 
			 				<form:input type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8"
			 					tabindex="90" disabled="true"/>
						</td>
					</tr>	
					<tr>
						<td class="label">
							<label for="numAmortInteres">N&uacute;mero de Cuotas:</label> 
						</td>
						<td >
							<form:input type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="91" disabled="true"/>
						</td> 
						<td class="separador"></td> 
						<td class="label">
							<label for="numAmortizacion">N&uacute;mero de Cuotas:</label> 
						</td>
						<td >
							<form:input type="text" id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="92" disabled="true"/>
						</td> 
					</tr>
					<tr>
						<td class="label">
							<label for="montoCuota">Monto Cuota:</label> 
						</td>
						<td>
							<form:input type="text" id="montoCuota" name="montoCuota" path="montoCuota" size="18" disabled ="true" esMoneda="true" 
										style="text-align: right"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="cat">CAT:</label> 
						</td>
					   <td>
						 	<form:input type="text" id="cat" name="cat" path="cat" size="8"  disabled ="true" esTasa="true"/>
						 	 <label for="cat"> %</label> 
						</td>
					</tr>
					<tr class="ocultarSeguros">
					<td></td>
					<td></td>
					<td></td>
						<td class="label"><label>Monto Seguro Cuota:</label></td>
						<td><form:input type="text" name="montoSeguroCuota" id="montoSeguroCuota" path="montoSeguroCuota" size="8" disabled ="true"/></td>
					</tr>
					<tr>
						<td colspan="5"> 
			 				<input type="hidden" id="montosCapital" name="montosCapital" size="100" />
						 	<form:input type="hidden" id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5"
						 	 	disabled="disabled" value="0"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="button" id="simular" name="simular" class="submit" value="Simular" tabindex="93"/>
						</td>
					</tr>
			</table>
		</fieldset> 
	</fieldset>
	<div id="contenedorSimulador" style="display: none;"></div>
	<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
	<br>
	<table  style="text-align: right;width: 100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="82"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="83"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		 
				<input type="hidden" id="pantalla"  name="pantalla"/>
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
<div id="mensaje" style="display: none;"></div>		
</body>
<html>