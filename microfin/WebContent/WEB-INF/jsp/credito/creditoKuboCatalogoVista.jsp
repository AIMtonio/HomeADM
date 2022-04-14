<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
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
      <script type="text/javascript" src="js/credito/creditoKubo.js"></script>     
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>   
              
	   
	</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />  

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Cr&eacute;dito Kubo</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="950px">
	<tr>
			<td class="label">
				<label for="credito">N&uacute;mero: </label>
			</td> 
			<td >
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
				<!-- <form:input id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1" 
				numMax ="10" /> -->
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="tipo">Solicitud: </label> 
			</td>
		   <td>
			 	<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID"
			 	size="10" tabindex="2" />
			</td>
			</tr>
			
			<tr>
			<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td> 
			<td >
				<form:input id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="3" />
				<input type="text" id="nombreCliente" name="nombreCliente" tabindex="4" disabled="true" size="50"/> 
			</td>				
		   <td class="separador"></td>
			<td class="label">
				 <label for="lineaCred">Linea de Cr&eacute;dito: </label>
			</td> 
		   <td >
			 	<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="10" tabindex="5" />
			</td>	
		</tr>
						
		<tr>
			<td class="label">
			 	<label for="lineaCred">Producto de Cr&eacute;dito: </label>
			</td> 
		   <td>
			 	<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" tabindex="6" 
			 	disabled="true"/>
			 	<input type="text" id="nombreProd" name="nombreProd" tabindex="7" disabled="true" size="45" /> 
			</td>
			<td class="separador"></td>
			<td class="label">
			 <label for="lineaCred">Clasificaci&oacute;n: </label>
			</td> 
		   <td>
			 	<input type="text" id="clasificacion" name="clasificacion" size="7" tabindex="8" disabled="true"/>
				<input type="text" id="DescripClasific" name="DescripClasific" size="35" tabindex="9" disabled="true"/>
			</td>	
				
		</tr>
		<tr>
			<td class="label">
			 <label for="Cuenta">Cuenta: </label>
			</td> 
		   <td>
		   	<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="15" tabindex="10" disabled="true" />
			</td>		
			<td class="separador"></td>
			<td class="label">
				<label for="saldo">Saldo de linea: </label> 
			</td>
		   <td>
			 	<input type= "text" id="saldoLineaCred" name="saldoLineaCred" size="15" tabindex="11"
			 	 disabled="true"/>
			</td>	
		</tr>
		<tr>
			<td class="label">
			<label for="Relacionado">Relacionado: </label> 
			</td>
		   <td >
			 	<form:input id="relacionado" name="relacionado" path="relacionado" size="15" tabindex="12"/>
			</td>	
			<td class="separador"></td>
			<td class="label">
			<label for="Estatus">Estatus:</label> 
			</td>
		   <td>
		   <form:select id="estatus" name="estatus" path="estatus"  tabindex="13" disabled="true">
			     	<form:option value="I">INACTIVO</form:option>
			     	<form:option value="V">VIGENTE</form:option>
					<form:option value="P">PAGADO</form:option>
					<form:option value="C">CANCELADO</form:option>
					<form:option value="A">AUTORIZADO</form:option>
					<form:option value="B">VENCIDO</form:option>
					<form:option value="K">CASTIGADO</form:option>
				</form:select>
			</td>		
		
		</tr>
		
		</table>
		<br>
		
	 <div id="contenedorFondeo" style="display: none;"></div>
	 
	  
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Condiciones</legend>						
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
		<tr>
			<td class="label">
			<label for="Monto">Monto: </label> 
			</td>
		   <td>
			 	<form:input id="montoCredito" name="montoCredito" path="montoCredito" size="12"
			 	esMoneda="true" tabindex="14"  />
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="Moneda">Moneda: </label> 
			</td>
		   <td >
			 	<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="15" disabled="true" >
						<form:option value="-1">Seleccionar</form:option>
						</form:select> 

			</td>
		</tr>
		<tr>
			<td class="label">
			<label for="FechaInic">Fecha de Inicio : </label> 
			</td>
		   <td >
			 	<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="16"
			 	tabindex="17"/>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="FechaVencimiento">Fecha de Vencimiento: </label> 
			</td>
		   <td>
			 	<form:input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="18"
			 	tabindex="19"  />
			</td>
		</tr>
		<tr>
		
			<td class="label">
			<label for="FactorMora">Factor Mora: </label> 
			</td>
		   <td >
			 	<form:input id="factorMora" name="factorMora" path="factorMora" size="8"
			 	 disabled="true"	esTasa="true" tabindex="20"/>
 			<label for="lblveces">veces la tasa de inter&eacute;s ordinaria</label> 
			</td>
			<td class="separador"></td>
		<td class="label">
			<label for="FactorMora">Tipo de Fondeo: </label> 
			</td>
		   <td >
			 	<form:select id="tipoFondeo" name="tipoFondeo" path="tipoFondeo"  tabindex="21" disabled = "true">
				<form:option value="-1">Seleccionar</form:option>
				<form:option value="P">Propios</form:option>
				<form:option value="F">Inst.de Fondeo</form:option>
				</form:select>	 	
			</td>
		</tr>
		<tr>
			<td class="label">
			<label for="comision">Comisi&oacute;n por apertura: </label> 
			</td>
		    <td>
			 	<form:input id="montoComision" name="montoComision" path="montoComision" size="12"
			 	esMoneda="true" tabindex="22" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Moneda">IVA Comisi&oacute;n: </label> 
			</td>
			<td>
				<form:input type="text" id="IVAComApertura" name="IVAComApertura" path="montoComision" tabindex="23"
				 esMoneda="true" disabled="true" size="12"/> 
				<input type="hidden" id="pagaIVACte" name="pagaIVACte" tabindex="23" disabled="true" size="5" />
				<input type="hidden" id="sucursalCte" name="sucursalCte" tabindex="23" disabled="true" size="5"/>
			</td>
		</tr>
		</table>
		</fieldset>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Inter&eacute;s</legend>						
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
		<tr>
			<td class="label">
			<label for="calcInter">C&aacute;lculo de Inter&eacute;s  : </label> 
			</td>
		   <td>
		   	<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID"  tabindex="22">
				<form:option value="-1">Seleccionar</form:option>
				<form:option value="1">TasaFija</form:option>
				<form:option value="2">TasaBase de inicio de cupon+Puntos</form:option>
				<form:option value="3">Tasa Base de inicio de cupon+Puntos, con Piso y Techo</form:option>
				</form:select>	 	
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="TasaBase">Tasa Base: </label> 
			</td>
		   <td>
			 	<form:input id="tasaBase" name="tasaBase" path="tasaBase" size="5" tabindex="23"  />
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="25" 
				       readOnly="true" disabled="true" tabindex="24"/>			 	
			</td>
		</tr>
		<tr>
			<td class="label">
			<label for="tasaFija">Tasa Fija Anualizada: </label> 
			</td>
		   <td >
			 	<form:input id="tasaFija" name="tasaFija" path="tasaFija" size="8"
			 		tabindex="25" esTasa="true"/>
			 		<label for="porcentaje">%</label> 
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="SobreTasa">SobreTasa: </label> 
			</td>
		   <td>
			 	<form:input id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8"
			 	esTasa="true" tabindex="26" />
			</td>
		</tr>
	
		<tr>
			<td class="label">
			<label for="PisoTasa">Piso Tasa: </label> 
			</td>
		   <td >
			 	<form:input id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8"
			 					esTasa="true" tabindex="27"/>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="TechoTasa">Techo Tasa: </label> 
			</td>
		   <td>
			 	<form:input id="techoTasa" name="techoTasa" path="techoTasa" size="15"
			 					esTasa="true" tabindex="28" />
			</td>
		</tr>
		</table>
		</fieldset>
		<br>

		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend>Calendario de Pagos</legend>		
							
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
		<tr>
			<td class="label"> 
				<label for="fechInhabil">En Fecha Inhabil Tomar: </label> 
				</td>
			<td class="label">  
				<form:radiobutton id="fechaInhabil" name="fechaInhabil" path="fechaInhabil"
				 value="S" tabindex="29" checked="checked" />
				<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
				<form:radiobutton id="fechaInhabil2" name="fechaInhabil2" path="fechaInhabil" 
				value="A" tabindex="30"/>
				<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
			</td>
		</tr>

		<tr>
			<td class="label"> 
				<label for="fechInhabil">Ajustar Fecha Exigible a la de Vencimiento: </label> 
				</td>
			<td class="label">  
				<form:radiobutton id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen"
				 value="S" tabindex="31" checked="checked" />
				<label for="Si">Si</label>&nbsp;
				<form:radiobutton id="ajusFecExiVen2" name="ajusFecExiVen2" path="ajusFecExiVen" 
				value="N" tabindex="32"/>
				<label for="No">No</label>
			</td>
		</tr>
		<tr>
			<td class="label"> 
				<form:input TYPE="checkbox"id="calendIrregular" name="calendIrregular" path="calendIrregular" 
				 tabindex="33" value="S"/>
	    		<label for="calendarioIrreg">Calendario Irregular </label> 
		 	</td> 
 		</tr>		
		<tr>
			<td class="label"> 
				<label for="ajusFecUlVenAmo">Ajustar fecha de ultima amortizaci&oacute;n a fecha de 
				vencimiento del credito: </label> 
			</td>
			<td class="label">  
				<form:radiobutton id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo"
			 	value="S" tabindex="34" checked="checked" />
				<label for="ajusFecUlVenAmo">Si</label>&nbsp&nbsp;
				<form:radiobutton id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" path="ajusFecUlVenAmo" 
				value="N" tabindex="35"/>
				<label for="no">No</label>
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="TipoPagCap">Tipo de Pago de Capital: </label> 
			</td>
			<td class="label" id="miTdPrueba">  
				<form:radiobutton id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital"
				 value="C" tabindex="36"/>
				<label for="crecientes">CRECIENTES</label>&nbsp;
				<form:radiobutton id="tipoPagoCapital2" name="tipoPagoCapital2" path="tipoPagoCapital" 
				value="I" tabindex="37"/>
				<label for="iguales">IGUALES</label>
				<form:radiobutton id="tipoPagoCapital3" name="tipoPagoCapital3" path="tipoPagoCapital" 
				value="L" tabindex="38"/>
				<label for="libres">LIBRES</label>
				<!-- <form:radiobutton id="tipoPagoCapital4" name="tipoPagoCapital4" path="tipoPagoCapital" 
				value="L" tabindex="27"/>
				<label for="libres">LIBRES2</label> -->
			</td>
		</tr>
		</table>
	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	 
				<table>
					<tr>
						 <td class="label">
						 	Interes 
							<!-- <label for="interes">Interes </label> --> 
						 </td> 
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label">
							Capital
							<!-- <label for="capital">Capital </label> --> 
						</td> 
						<td class="separador" ></td>
					</tr>
					<tr>
						<td class="label">
							<label for="FrecuenciaInter">Frecuencia: </label> 
						</td>
		   			<td> 
		   				<form:select id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt"  tabindex="39" disabled="true">
							<form:option value="1">SELECCIONAR</form:option>			     			
			     			<form:option value="S">SEMANAL</form:option>
			     			<form:option value="C">CATORCENAL</form:option>
							<form:option value="Q">QUINCENAL</form:option> 
							<form:option value="M">MENSUAL</form:option>
							<form:option value="B">BIMESTRAL</form:option>
							<form:option value="T">TRIMESTRAL</form:option>
							<form:option value="R">TETRAMESTRAL</form:option>
							<form:option value="E">SEMESTRAL</form:option>
							<form:option value="A">ANUAL</form:option>
							<form:option value="P">PERIODO</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label"> 
							<label for="FrecuenciaCap">Frecuencia: </label> 
						</td> 
		  				<td>
 							<form:select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap"  tabindex="40">
 							<form:option value="1">SELECCIONAR</form:option>	
			     			<form:option value="S">SEMANAL</form:option>
			     			<form:option value="C">CATORCENAL</form:option>
							<form:option value="Q">QUINCENAL</form:option>
							<form:option value="M">MENSUAL</form:option> 
							<form:option value="B">BIMESTRAL</form:option>
							<form:option value="T">TRIMESTRAL</form:option>
							<form:option value="R">TETRAMESTRAL</form:option>
							<form:option value="E">SEMESTRAL</form:option>
							<form:option value="A">ANUAL</form:option>
							<form:option value="P">PERIODO</form:option>
							</form:select>
						</td>
					</tr>
					<tr>	
						<td class="label">
							<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label> 
						</td>
		  				<td> 
			 				<form:input id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="5"
			 					tabindex="41" disabled="true"/>
						</td> 
						<td class="separador"></td>
						<td class="label">
							<label for="PeriodicidadCap">Periodicidad de Capital:</label> 
						</td>
		   			<td>
			 				<form:input id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="5" 
			 				tabindex="42" disabled="true"/>
						</td>
						
					</tr>
					<tr>
						<td class="label"> 
							<label for="DiaPago">D&iacute;a Pago: </label> 
						</td>
						<td class="separador"></td>
						<td class="separador"></td>  
						<td class="label">  
							<label for="DiaPago">D&iacute;a Pago: </label> 
					 	</td> 
					 	<td class="separador"></td>
					</tr> 
						
					<tr>
						<td >  
							<form:radiobutton id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres"
			 				value="F" tabindex="43" checked="checked" disabled="true" />
							<label for="ultimo">&Uacute;ltimo dia del mes</label>  
							<form:radiobutton  id="diaPagoInteres2" name="diaPagoInteres2" path="diaPagoInteres" 
							value="A" tabindex="44" disabled="true" /> 
							<label for="diaMes">D&iacute;a del mes</label>
						</td>
						<td class="separador"></td>
						<td class="separador"></td> 
						<td >  
							<form:radiobutton id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital"
			 				value="F" tabindex="45" checked="checked" disabled="true"/>
							<label for="ultimoDPC">&Uacute;ltimo dia del mes</label>&nbsp;  
							<form:radiobutton id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" 
							value="A" tabindex="46" disabled="true"/>
							<label for="diaMesDPC">D&iacute;a del mes</label>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label"> 
							<label for="DiaMes">D&iacute;a del mes: </label> 
						</td>
			 			<td>
			 				<form:input id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="6"
			 					tabindex="47" disabled="true"/>
						</td>
						<td class="separador"></td> 
						<td class="label">  
							<label for="DiaMes">D&iacute;a del mes: </label> 
						</td>
			 			<td> 
			 				<form:input id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="6"
			 					tabindex="48" disabled="true"/>
						</td>
					</tr>		

					<tr><td> 
			 				<input id="montosCapital" name="montosCapital" size="100" type="hidden"/>
					</td></tr>

					</table>
			   </fieldset> 
			 
						<table colspan="5" align="right">
							<tr>
								<td align="right">
									<input type="button" id="simular" name="simular" class="submit" 
				 					value="Simular" />
								</td>
							</tr>
						</table> 
		</fieldset>
		<div id="contenedorSimulador" style="display: none;">	
		</div>
		<br>
	<table>
		<tr>
			<td class="label">
				<label for="numAmort">N&uacute;mero de Cuotas:</label> 
			</td>
		   <td >
			 	<form:input id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="5"
			 	tabindex="49" disabled ="true"/>
			</td> 
			<td >
			 	<form:input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5"
			 	tabindex="50" disabled ="true" type="hidden" value="0"/>

			</td>
			<td class="separador"></td>
			<td class="separador"></td>
			<td class="label">
				<label for="CAT">CAT:</label> 
			</td>
		   <td>
			 	<form:input id="cat" name="cat" path="cat" size="5" tabindex="51" disabled ="true" esTasa="true"/>
			 	 <label for="lblPorc"> %</label> 
			</td>
		</tr>
		</table>
</table>

		
				<table align= "right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agrega" tabindex="51"/>
							<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modifica" tabindex="52"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		 
						</td>
					</tr>
				</table>
		  </fieldset>			
</form:form> 







<form:form id="formaGenerica2" name="formaGenerica2" method="POST" commandName="creditos"> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Fondeo Recursos Propios</legend>                
					<table border="0" cellpadding="0" cellspacing="0" width="100%">   
					 
						<tr>
					     	<td> 
					     		<input id="solCredID" name="solCredID" size="10" type="hidden"/>
							</td>
							<td>
					     		<input id="moneda" name="moneda" size="10" type="hidden"/>
							</td> 
					     	<td>
								<input id="fechaIni" name="fechaIni" size="10" type="hidden"/>
					     	</td> 
					    	<td>
								<input id="cuenta" name="cuenta" size="10" type="hidden"/>
					     	</td> 
					   </tr> 
						<tr>
					   	<td class="label"> 
					         <label for="lblPorcentaje">Porcentaje:</label> 
					     	</td>
					     	<td> 
					     		 <input id="porcentaje" name="porcentaje"  size="13" tabindex="50" disabled="true" 
					     		 readOnly="true" />  <label for="lblPorc"> %</label> 
					     	</td>
							 <td class="label"> 
					         <label for="lblTasaFija">Tasa Fija</label> 
					     	</td>
					     	<td>
					     		 <input id="tasa" name="tasa"  size="13" tabindex="51" disabled="true" readOnly="true" 
					     		 esTasa="true"/>
					     		  <label for="lblPorc"> %</label>  
					     	</td>
					   </tr> 
					
						<tr>  
					      <td class="label"> 
					         <label for="lblMonto">Monto</label> 
					     	</td>
					     	<td >
					     		 <input id="monto" name="monto"  size="13" tabindex="52" disabled="true" 
					     		 readOnly="true" esMoneda="true"/> 
					     	</td>  
					    </tr>
					</table>
					<br></br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
						<tr>
							<td align="right"> 
								 <input type="submit" id="grabaSF" name="grabaSF" class="submit" value="Grabar Sol. de Fondeo" tabindex="53" />
								<input type="hidden" id="tipoTransaccionSF" name="tipoTransaccionSF"/> 
								<input type="hidden" id="tipoTransaccionSF" name="tipoTransaccionSF"/>
								<input id="clienteInstitucion" name="clienteInstitucion" type="hidden"/>
								<input id="cuentaInstitucion" name="cuentaInstitucion" type="hidden"/>     
								<input id="tipoFondeador" name="tipoFondeador" type="hidden" value= "3"/> 
							</td>
						</tr>
					</table>
				</fieldset>
		

		
	</form:form>
</fieldset>
	
  

</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

<div id="mensaje" style="display: none;"/>		


</body>
<html>
	