 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	    
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
		
		<script type="text/javascript" src="js/originacion/cambioCondicionesCalendarioGrupal.js"></script>
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCredito">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Condiciones Grupales</legend>		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label">
					<label for="lblGrupo">Grupo:</label>
				</td> 
				<td nowrap="nowrap">
					<form:input type="text" id="grupoID" name="grupoID"  path="grupoID" size="12" tabindex="1"  />
					<input type="text" id="nombreGrupo" name="nombreGrupo"  size="40"   disabled="disabled" />
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblProducto">Producto de Crédito: </label>
				</td> 
				<td nowrap="nowrap" >
					<form:input  type="text"  id="productoCreditoID" name="productoCreditoID"  path ="productoCreditoID" size="12" tabindex="2" />
					<input  type="text" id="descripProducto" name="descripProducto"  size="40"   />
				</td>					
			</tr>	
			<tr>
				<td class="label">
					<label for="seguroVid">Seguro de Vida:</label>
				</td>
				<td>
					<input type="radio" id="reqSeguroVidaSi" name="reqSeguroVidaSi" disabled="true" value="S"/>
						<label for="si">Si</label>
					<input type="radio" id="reqSeguroVidaNo" name="reqSeguroVidaNo" disabled="true" value="N" />
						<label for="si">No</label>
						<form:input type="hidden" id="reqSeguroVida" name="reqSeguroVida" path="reqSeguroVida" size="10" />
		    	</td> 		   	
				<td class="separador"></td>
				<td id="lblTipoPagoSeguro"  class="label" nowrap="nowrap">
					<label for="tipoPagoSeguro">Forma de Cobro Seguro:</label> 
				</td>
				<td>
			    	<input type="text" id="tipoPagoSeguro" name="tipoPagoSeguro" disabled="true" />
					<form:input type="hidden" id="forCobroSegVida" name="forCobroSegVida" path="forCobroSegVida"/>
					<form:input type="hidden" id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida"/>
					<form:input type="hidden" id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" seisDecimales="true"  size="11"/>
					<input type="hidden" id="noDias" name="noDias" path="noDias">
					<input type="hidden" id="prodCred" name="prodCred" />
					
				</td>
			</tr>
			
			<tr id="tipoPagoTr">
			<td class="label" id="tipoPagoSelect" >
			<label for="Moneda">Tipo de Pago:</label> 
			</td>
			<td id="tipoPagoSelect2">	
				<select id="tipPago" name="tipPago" tabindex="12" >
					<option value="">SELECCIONAR</option>
					<option value="A">ADELANTADO</option>
					<option value="F">FINANCIAMIENTO</option>
					<option value="D">DEDUCCION</option>
					<option value="O">OTRO</option>
				</select> 
							
				</td>	
			</tr>			
			
			<tr>
				<td class="label">
					<label for="lblTasaPonderadaGrupal">Tasa Ponderada Grupal:</label>
				</td>
				<td>
					<form:select  id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" tabindex="13" disabled="true" >			        	
			        	<form:option value="S">SI</form:option>
			        	<form:option value="N">NO</form:option>
				   	</form:select>	
				   	
		    	</td> 		   	
				<td class="separador"></td>
				<td class="label">
					<label for="lblCicloActual">Ciclo Actual:</label> 
				</td>
				<td>
			    	<input type="text" id="cicloActual" name="cicloActual" size="8" tabindex="14" disabled="true" >					
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<div id="gridIntegrantes" style="display: none;" ></div>
				</td>
			</tr>
			<tr>
				<td class="label"> 
	         		<label for="lblAfechInicio">Fecha de Inicio: </label> 
	     		</td> 
	     		<td> 
	         		<form:input  type="text"  id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio"  tabindex="80" disabled = "true" />  
	     		</td>
	     		<td class="separador"></td> 
	 			<td class="label"> 
			   		<label for="lblPlazo">Plazo: </label> 
			   	</td>   	
			   	<td> 
	         		<form:select  id="plazoID" name="plazoID" path="plazoID" tabindex="81" >
			        	<form:option value="">SELECCIONA</form:option>
				   	</form:select>	
	     		</td>   
	     	</tr>
	     	<tr>
	     		<td class="label"> 
	         		<label for="lblAutorizado">Fecha de Vencimiento: </label> 
	     		</td> 
	     		<td> 
	         		<form:input  type="text"  id="fechaVencimiento" name="fechaVencimien" size="18" path="fechaVencimiento"  tabindex="82" disabled = "true" />
	     		</td>
	     		<td class="separador"></td>
	     		<td class="separador"></td>
	     		<td class="separador"></td>
	     	</tr>
			<tr>
				<td colspan="5">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">	
					<legend>Calendario de Pagos</legend>		
						<table border="0" cellpadding="0" cellspacing="0"   width="100%">
							<tr>
							<td class="label" colspan="3"> 
								<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label> 
								</td>
							<td class="label" colspan="2">  
								<input type="radio" id="fechInhabil1" name="fechInhabil1" value="S" tabindex="83" checked="checked" />
								<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
								<input type="radio" id="fechInhabil2" name="fechInhabil2" value="A" tabindex="84" />
								<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
								<form:input type="hidden" id="fechInhabil" name="fechInhabil" path="fechInhabil" size="15" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="label" colspan="3"> 
								<label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label> 
								</td>
							<td class="label" colspan="2">  
								<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" tabindex="85" checked="checked" />
								<label for="Si">Si</label>&nbsp;
								<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" tabindex="86"  />
								<label for="No">No</label>
								<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" readonly="true"/>
							</td>
						</tr>
						<%-- 
						<tr>
							<td class="label" colspan="5"> 
								<form:input type="checkbox" id="calendIrregular" name="calendIrregular" path="calendIrregular" tabindex="29" value="S"  />
					    		<label for="calendarioIrreg">Calendario Irregular </label> 
						 	</td> 
				 		</tr> --%>
						<tr>
							<td class="label" colspan="3" nowrap="nowrap"> 
								<label for="ajFecUlAmoVen">Ajustar Fecha de Vencimiento de &Uacute;ltima
				 Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label> 
							</td>
							<td class="label" colspan="2">  
								<input type="radio" id="ajFecUlAmoVen1" name="ajFecUlAmoVen1" value="S" tabindex="87" checked="checked"  />
								<label for="ajFecUlAmoVen">Si</label>&nbsp;
								<input type="radio" id="ajFecUlAmoVen2" name="ajFecUlAmoVen2" value="N" tabindex="88"  />
								<label for="no">No</label>
								<form:input type="hidden" id="ajFecUlAmoVen" name="ajFecUlAmoVen" path="ajFecUlAmoVen" size="15" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="label" colspan="3">
								<label for="TipoPagCap">Tipo de Pago de Capital: </label> 
							</td>
							<td> 
						    	<select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="89" >
									<option value="">SELECCIONAR</option>
									<option value="C">CRECIENTES</option>
									<option value="I">IGUALES</option>
								</select>	
								<input type="hidden" id="perIgual" name="perIgual"  size="5"  />
						   	</td> 
						</tr>
						</table>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">	 
							<table border="0"   width="100%">
								<tr>
									<td class="label" colspan="2">Inter&eacute;s</td> 
									<td class="separador"></td>
									<td class="label" colspan="2">Capital</td> 
								</tr>
								<tr>
									<td class="label">
										<label for="FrecuenciaInter">Frecuencia: </label> 
									</td>
									<td> 
							        	<select  id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="90" >
									    	<option value="">SELECCIONAR</option>
									    	<option value="S">SEMANAL</option>
									    	<option value="C">CATORCENAL</option>
									    	<option value="Q">QUINCENAL</option>
									    	<option value="M">MENSUAL</option>
									    	<option value="P">PERIODO</option>
									    	<option value="B">BIMESTRAL</option>
									    	<option value="T">TRIMESTRAL</option>
									    	<option value="R">TETRAMESTRAL</option>
									    	<option value="E">SEMANAL</option>
									    	<option value="A">ANUAL</option>
									    	<option value="U">PAGO UNICO</option>
										</select>	
								 	</td> 
									<td class="separador"></td>
									<td class="label"> 
										<label for="FrecuenciaCap">Frecuencia: </label> 
									</td>
									<td> 
							        	<select  id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="91" >
									    	<option value="">SELECCIONAR</option>
									    	<option value="S">SEMANAL</option>
									    	<option value="C">CATORCENAL</option>
									    	<option value="Q">QUINCENAL</option>
									    	<option value="M">MENSUAL</option>
									    	<option value="P">PERIODO</option>
									    	<option value="B">BIMESTRAL</option>
									    	<option value="T">TRIMESTRAL</option>
									    	<option value="R">TETRAMESTRAL</option>
									    	<option value="E">SEMANAL</option>
									    	<option value="A">ANUAL</option>
									    	<option value="U">PAGO UNICO</option>
										</select>	
								 	</td> 						
								</tr>
								<tr>	
									<td class="label">
										<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label> 
									</td>
					  				<td> 
						 				<form:input  type="text"  id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8"
						 					tabindex="92" disabled="true" readonly="true" />
									</td> 
									<td class="separador"></td>
									<td class="label">
										<label for="PeriodicidadCap">Periodicidad de Capital:</label> 
									</td>
					   				<td>
						 				<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8" 
						 					tabindex="93" readonly="true" />
									</td>
								</tr>
								<tr>
									<td class="label"> 
										<label for="DiaPago">D&iacute;a Pago: </label> 
									</td>
									<td nowrap="nowrap">  
										<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="94"  />
										<label for="ultimo">&Uacute;ltimo día del mes</label>  
										<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="95" /> 
										<label for="diaMes">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" tabindex="96" />
									</td>
									<td class="separador"></td>  
									<td class="label">  
										<label for="DiaPago">D&iacute;a Pago: </label> 
								 	</td> 
								 	<td nowrap="nowrap">  
										<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="97"  />
										<label for="ultimoDPC">&Uacute;ltimo día del mes</label>&nbsp;  
										<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" tabindex="98" />
										<label for="diaMesDPC">D&iacute;a del mes</label>
										<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" tabindex="99" />
									</td>
								</tr>
								<tr>
									<td class="label"> 
										<label for="DiaMes">D&iacute;a del mes: </label> 
									</td>
						 			<td>
						 				<form:input  type="text"  id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8" tabindex="100" readonly="true"/>
									</td>
									<td class="separador"></td> 
									<td class="label">  
										<label for="DiaMes">D&iacute;a del mes: </label> 
									</td>
						 			<td> 
						 				<form:input  type="text"  id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8" tabindex="101" readonly="true"/>
									</td>
								</tr>	
								<tr>
									<td class="label">
										<label for="numAmort">N&uacute;mero de Cuotas:</label> 
									</td>
									<td >
										<form:input  type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="102" readonly="true"/>
									</td> 
									<td class="separador"></td> 
									<td class="label">
										<label for="numAmort">N&uacute;mero de Cuotas:</label> 
									</td>
									<td >
										<form:input  type="text"  id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="103"/>
									</td> 
								</tr>
							</table>
						</fieldset> 
					</fieldset>
				</td>
			</tr>
			<tr>
				<td align="right" colspan="5">
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="104"  />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />	
					<input type="hidden" id="forCoSegu" name="forCoSegu" />	
					<input type="hidden" id="modalid" name="modalid" />	
					<input type="hidden" id="proCre" name="proCre" />		
					<input type="hidden" id="conProd" name="conProd" />
					<input type="hidden" id="conProduc" name="conProduc" />				
									
							
								
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
