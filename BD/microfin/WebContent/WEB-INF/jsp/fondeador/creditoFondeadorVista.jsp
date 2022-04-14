<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
      	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>  
      	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
    	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
    	<script type="text/javascript" src="dwr/interface/creditoFondeoServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
 		<script type="text/javascript" src="js/fondeador/creditoFondeoVista.js"></script>
 		
	</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />  
<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="creditoFondeoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Cr&eacute;dito Pasivo - Pr&eacute;stamo</legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">						
		<table  width="100%">
			<tr>
				<td class="label">
					<label for="lblcreditoFondeoID">N&uacute;mero: </label>
				</td> 
				<td >
					<form:input type = "text" id="creditoFondeoID" name="creditoFondeoID" path="creditoFondeoID" size="12" tabindex="1"  />
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="institucionFondeo">Instituci&oacute;n Fondeo: </label>
				</td> 
			   	<td nowrap="nowrap">
					<form:input type="text" id="institutFondID" name="institutFondID" path="institutFondID" size="12" tabindex="2" />
				 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo" size="50" readonly="true"/> 	 	
				</td>	
			</tr>	

			<tr id="tipo">
				<td class="label" >
					<label for="lbltipoInstitID">Tipo Instituci&oacute;n: </label>
				</td>

				<td  >
					<form:input type = "text" id="tipoInstitID" name="tipoInstitID" path="tipoInstitID" size="12" readonly="true"
								 />
					<input type = "text" id="tipoInstitDes" name="tipoInstitDes"  size="35" readonly="true"
						  />
					
				</td>
				
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="institucionFondeo">Nacionalidad Instituci&oacute;n: </label>
				</td> 
			   	<td nowrap="nowrap">
					<form:input type="hidden" id="nacionalidadIns" name="nacionalidadIns" path="nacionalidadIns" size="12" readonly="true"
							    />
				 	<input type="text" id="nacionalidadInsDes" name="nacionalidadInsDes" size="30" readonly="true"/> 	 	
				</td>	
	
			</tr>

			<tr>
				<td class="label">
					 <label for="lineaCred">L&iacute;nea de Fondeo: </label>
				</td> 
			   <td nowrap="nowrap">
				 	<form:input type = "text" id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="12" tabindex="3"/>
				 	<textarea id="descripLinea" name="descripLinea" rows="2" cols="25"  onblur="ponerMayusculas(this)" readonly="readonly"
				 		 ></textarea>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="tipo">Tipo L&iacute;nea: </label> 
				</td>
	   			<td nowrap="nowrap">
		 			<input type="text" id="tipoLinFondeaID" name="tipoLinFondeaID" size="12" readOnly="true"/>
					<textarea id="desTipoLinFondea" name="desTipoLinFondea" rows="2" cols="25" onblur="ponerMayusculas(this)" 
						readonly="readonly"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="tipo">Saldo L&iacute;nea: </label> 
				</td>
	   			<td>
		 			<input type="text" id="saldoLinea" name="saldoLinea" size="22" esMoneda="true" 
		 				readOnly="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="institucionFondeo">Folio: </label>
				</td> 
			   	<td nowrap="nowrap">
					<form:input type="text" id="folio" name="folio" path="folio" size="30" maxlength="150"  tabindex="4" />	
				</td>	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblBanco">Banco:</label> 
				</td>
				<td nowrap="nowrap" >
			 		<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="12" />
			 		<input type="text" id="descripcionInstitucion" name="descripcionInstitucion"  size="35" readonly="true" />
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblBanco">N&uacute;mero de Cuenta Bancaria:</label> 
				</td>
				<td nowrap="nowrap" >
			 		<form:input type="text" id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="22" maxlength="20" />
				</td>				
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblCtaClabe">Cuenta Clabe: </label> 
				</td>
		   		<td nowrap="nowrap">
		   			<form:input type="text" id="cuentaClabe" name="cuentaClabe" path="cuentaClabe" onkeypress="return IsNumber(event)" size="24" 
		   						readonly="true" maxlength="18" />	
				</td>
				<td class="separador"></td>	
				<td class="label">
					<label for="lbltipo">Tipo: </label>
				</td> 
				<td >  
					<form:select id="tipoFondeador" name="tipoFondeador" path="tipoFondeador" tabindex="5" >
						<form:option value="F">Fondeador</form:option>
						<form:option value="I">Inversionista</form:option>
					</form:select> 
				</td>
				<td class="separador"></td>	
				<td class="separador"></td>	
			</tr>
			<tr>
				<td class="label"><label for="refinancia">Refinancia:</label></td>
				<td>
					<form:select id="refinancia" name="refinancia" path="refinancia" disabled="true">
						<form:option value="I">No</form:option>
						<form:option value="S">Si</form:option>
					</form:select>
				</td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
		<legend >Ventana de Disposición</legend>
		<table  >
			<tr>
				<td class="label">
					<label for="FechaInc">Fecha de Inicio: </label>
				</td> 
				<td>
					<input type="text" id="fechInicLinea" name="fechInicLinea" size="15" readonly="true"
						 />
				</td>		
				<td class="separador"></td>		
				<td class="label" nowrap="nowrap">
					<label for="FechaFin">Fecha de Fin: </label> 
				</td>
				<td nowrap="nowrap">
					<input type="text" id="fechaFinLinea" name="fechaFinLinea" size="15"  readonly="true"
						/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="FechaMax">Fecha Max. Vencimiento: </label>
				</td> 
				<td>
					<input type="text" id="fechaMaxVenci" name="fechaMaxVenci" size="15" readonly="true" />
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
			</tr>
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend>Condiciones</legend>						
		<table  width="100%">
			<tr>
				<td class="label">
					<label for="Monto">Monto: </label> 
				</td>
			   	<td>
				 	<form:input type = "text" id="monto" name="monto" path="monto" size="16" esMoneda="true" tabindex="6"  
				 		style="text-align: right" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="Moneda">Moneda: </label> 
				</td>
			   	<td >
				 	<form:select id="monedaID" name="monedaID" path="monedaID"  disabled="true" >
						<form:option value="">Seleccionar</form:option>
					</form:select> 
				</td>
			</tr>
			<tr>
				<td class="label">
				<label for="FechaInic">Fecha de Inicio : </label> 
				</td>
			   	<td>
				 	<form:input type = "text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="16" esCalendario="true"  tabindex="7"/>
				</td>
				<td class="separador"></td>
				<td class="label"> 
					<label for="lblPlazo">Plazo: </label> 
				</td>   	
				<td> 
		     		<form:select  id="plazoID" name="plazoID" path="plazoID" tabindex="8" >
				    	<form:option value="">Seleccionar</form:option>
					</form:select>	
		  		</td>
			</tr>
			<tr>
				<td class="label">
				<label for="FechaInic">Fecha de Vencimiento:</label> 
				</td>
			   	<td>
				 	<form:input type = "text" id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="16" 
				 			    readonly="true"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="FactorMora">Factor Mora: </label> 
				</td>
			    <td >
				 	<form:input type="text"  id="factorMora" name="factorMora" path="factorMora" size="8" esTasa="true" tabindex="9"/>
	 				<label for="lblveces">veces la tasa de inter&eacute;s ordinaria</label> 
				</td>
			</tr>			
			<tr>
				<td class="label">
				<label for="plazoContable">Plazo Contable : </label>
				</td>
			   	<td>
			   		<input type="radio" id="cortoPlazo" name="cortoPlazo" value="C" tabindex="10" checked="checked" />
					<label for="siguiente">Corto Plazo </label>&nbsp;
					<input type="radio" id="largoPlazo" name="largoPlazo" value="L" tabindex="11" />
					<label for="anterior">Largo Plazo</label>
					<form:input type="hidden" id="plazoContable" name="plazoContable" path="plazoContable" size="15" readonly="true" />
				 	<form:input type = "hidden" id="fechaContable" name="fechaContable" path="fechaContable" size="16"  
				 				readonly="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					 <label for="lblComDis">Comisi&oacute;n por Disposici&oacute;n: </label> 
				</td>
				<td>
					<form:input type = "text" id="comDispos" name="comDispos" path="comDispos" size="16" tabindex="12"
				 		esMoneda = "true" style="text-align: right"/>				 	
				</td>				
			</tr>
			<tr>
				<td class="label">
					<label for="lblivaCom">IVA Comisi&oacute;n por Disposici&oacute;n:</label> 
				</td>
			   	<td>
			   		<form:input type = "text" id="ivaComDispos" name="ivaComDispos" path="ivaComDispos" size="16" tabindex="13"
				 		esMoneda = "true" style="text-align: right"/>				 	
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="lblcobraISR">Realiza Retenci&oacute;n: </label>
				</td>
				<td>
				 	<form:select id="cobraISR" name="cobraISR" path="cobraISR"  disabled="true"  >
						<form:option value="">NO DEFINIDO</form:option>
						<form:option value="S">SI</form:option>
						<form:option value="N">NO</form:option>
					</form:select>
				</td>				
			</tr>
			<tr>
				<td class="label">
					<label for="lblivaCom">Tasa ISR :</label> 
				</td> 
				<td >  
					 <form:input type = "text" id="tasaISR" name="tasaISR" path="tasaISR" size="16" tabindex="14"
				 		esMoneda = "true" style="text-align: right"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="lblpagosParciales">Pagos Parciales: </label>
				</td>				
				<td >  
					<form:select id="pagosParciales" name="pagosParciales" path="pagosParciales" tabindex="15" >
					<form:option value="S">SI</form:option>
					<form:option value="N">NO</form:option>
					</form:select> 				 	
				</td>			
			</tr>
			
		</table>
	</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Inter&eacute;s</legend>						
		<table  width="100%">
			<tr>
				<td class="label">
					<label for="calcInter">Tipo Cal. Interés : </label> 
				</td>
			   	<td>
			   		<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres"  tabindex="16" >
			   			<form:option value="">SELECCIONAR</form:option>
						<form:option value="1">SALDOS INSOLUTOS</form:option>
					</form:select>	 	
				</td>		
				<td class="separador"></td>
				<td class="label">
				<label for="calcInter">C&aacute;lculo de Inter&eacute;s  : </label> 
				</td>
			   <td>
				   	<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID"  tabindex="38" >
						<form:option value="">SELECCIONAR</form:option>						
					</form:select>	 	
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="TasaBase">Tasa Base: </label> 
				</td>
			   	<td>
				 	<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8" tabindex="39"  style="text-align: right;"  />
				 	<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true"  />			 	
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="tasaFija">Tasa Fija Anualizada: </label> 
				</td>
			   	<td>
				 	<form:input type="text"  id="tasaFija" name="tasaFija" path="tasaFija" size="8" tabindex="40" esTasa="true"
				 		 style="text-align: right;"  />
				 	<label for="porcentaje">%</label> 
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="SobreTasa">Sobre Tasa: </label> 
				</td>
			   <td>
				 	<form:input  type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" esTasa="true" tabindex="41" readonly="true"
				 		 style="text-align: right;"  />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="PisoTasa">Piso Tasa: </label> 
				</td>
			   	<td >
					<form:input type="text"  id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8" esTasa="true" tabindex="42" readonly="true" 
						 style="text-align: right;"  />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="TechoTasa">Techo Tasa: </label> 
				</td>
			   	<td>
					<form:input  type="text"  id="techoTasa" name="techoTasa" path="techoTasa" size="8" esTasa="true" tabindex="43" readonly="true"
						 style="text-align: right;" />
				</td>
				<td class="separador"></td>
			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend>Calendario de Pagos</legend>		
		<table   width="100%">
			<tr>
			<td class="label" colspan="3"> 
				<label for="fechInhabil">En Fecha Inhábil Tomar: </label> 
				</td>
			<td class="label" colspan="2">  
				<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" tabindex="44" checked="checked" />
				<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
				<input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" tabindex="45" />
				<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
				<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" readonly="true"/>
			</td>
		</tr>
		<tr id="trFechaExigible">
			<td class="label" colspan="3"> 
				<label for="fechInhabil">Ajustar Fecha Exigíble a la de Vencimiento: </label> 
				</td>
			<td class="label" colspan="2">  
				<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" tabindex="46" checked="checked" />
				<label for="Si">Si</label>&nbsp;
				<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" tabindex="47"  />
				<label for="No">No</label>
				<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" tabindex="48" readonly="true" value="N"/>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="5"> 
				<form:input type="checkbox" id="calendIrregular" name="calendIrregular" path="calendIrregular" tabindex="49" value="S"  />
	    		<label for="calendarioIrreg">Calendario Irregular </label> 
		 	</td> 
 		</tr>		
		<tr id="trFechaVencimiento">
			<td class="label" colspan="3" nowrap="nowrap"> 
				<label for="ajusFecUlVenAmo">Ajustar Fecha de Vencimiento de &Uacute;ltima
				 Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label> 
			</td>
			<td class="label" colspan="2">  
				<input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S" tabindex="50" checked="checked"  />
				<label for="ajusFecUlVenAmo">Si</label>&nbsp;
				<input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N" tabindex="51"  />
				<label for="no">No</label>
				<form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15" tabindex="52" readonly="true" value="N"/>
			</td>
		</tr>
		<tr>
			<td class="label"> 
				<label for="lblPagaIva">Paga IVA:</label> 
			</td>
			<td class="label">  
				<input type="radio" id="siPagaIVA" name="siPagaIVA" value="S" tabindex="53" checked="checked"  />
				<label for="lblsiPagaIVA">Si</label>&nbsp;
				<input type="radio" id="noPagaIVA" name="noPagaIVA" value="N" tabindex="54"  />
				<label for="lblnoPagaIVA">No</label>
				<form:input type="hidden" id="pagaIva" name="pagaIva" path="pagaIva" size="15" tabindex="55" readonly="true"/>
			</td>
			<td class="separador"></td>
			<td class="label"> 
				<label for="lblIVA">Porcentaje IVA:</label> 
			</td>
			<td class="label" colspan="2"> 
				<form:input type="text" id="iva" name="iva" path="iva"  readonly="true" esMoneda="true" style="text-align: right;" size="10"/>
				<label for="lblPorc"> %</label> 
		 	</td> 
		</tr>
		<tr>
			<td class="label">
				<label for="capitalizaInt">Capitaliza Interés: </label> 
			</td>
			<td> 
		   		<form:select id="capitalizaInteres" name="capitalizaInteres" path="capitalizaInteres" tabindex="57">
					<form:option value="N">NO</form:option>
				    <form:option value="S">SI</form:option>
				</form:select>
		   	</td> 
		
			<td class="separador"></td>
			<td class="label">
				<label for="TipoPagCap">Tipo de Pago de Capital: </label> 
			</td>
			<td> 
		    	<form:select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="58" >
					<form:option value="">SELECCIONAR</form:option>
					<form:option value="C">CRECIENTES</form:option>
					<form:option value="I">IGUALES</form:option>
					<form:option value="L">LIBRES</form:option>
				</form:select>	
		   	</td>
		</tr>
		<tr>
			<td class="label"> 
				<label for="lblMargenPagos">Margen Pagos Iguales:</label> 
			</td>
			<td class="label" colspan="2"> 
				<form:input type="text" id="margenPagIguales" name="margenPagIguales" path="margenPagIguales" tabindex="59" esMoneda="true"
					style="text-align: right;" size="10"/>
		 	</td> 
			
		</tr>
		</table>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	 
			<table  width="100%">
				<tr>
					<td class="label" colspan="2">Interés</td> 
					<td class="separador"></td>
					<td class="label" colspan="2">Capital</td> 
				</tr>
				<tr>
					<td class="label">
						<label for="FrecuenciaInter">Frecuencia: </label> 
					</td>
					<td> 
			        	<form:select  id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="60" >
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="S">SEMANAL</form:option>
					    	<form:option value="C">CATORCENAL</form:option>
					    	<form:option value="Q">QUINCENAL</form:option>
					    	<form:option value="M">MENSUAL</form:option>
					    	<form:option value="P">PERIODO</form:option>
					    	<form:option value="B">BIMESTRAL</form:option>
					    	<form:option value="T">TRIMESTRAL</form:option>
					    	<form:option value="R">TETRAMESTRAL</form:option>
					    	<form:option value="E">SEMESTRAL</form:option>
					    	<form:option value="A">ANUAL</form:option>
					    	<form:option value="U">PAGO UNICO</form:option>
						</form:select>	
				 	</td> 
					<td class="separador"></td>
					<td class="label"> 
						<label for="FrecuenciaCap">Frecuencia: </label> 
					</td>
					<td> 
			        	<form:select  id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="61" >
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="S">SEMANAL</form:option>
					    	<form:option value="C">CATORCENAL</form:option>
					    	<form:option value="Q">QUINCENAL</form:option>
					    	<form:option value="M">MENSUAL</form:option>
					    	<form:option value="P">PERIODO</form:option>
					    	<form:option value="B">BIMESTRAL</form:option>
					    	<form:option value="T">TRIMESTRAL</form:option>
					    	<form:option value="R">TETRAMESTRAL</form:option>
					    	<form:option value="E">SEMESTRAL</form:option>
					    	<form:option value="A">ANUAL</form:option>
					    	<form:option value="U">PAGO UNICO</form:option>
						</form:select>	
				 	</td> 						
				</tr>
				<tr>	
					<td class="label">
						<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label> 
					</td>
	  				<td> 
		 				<form:input  type="text" id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8"
		 					 readonly="true"  tabindex="62"/>
					</td> 
					<td class="separador"></td>
					<td class="label">
						<label for="PeriodicidadCap">Periodicidad de Capital:</label> 
					</td>
	   				<td>
		 				<form:input  type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8" 
		 					 readonly="true" tabindex="63" />
					</td>
				</tr>
				<tr>
					<td class="label"> 
						<label for="DiaPago">D&iacute;a Pago: </label> 
					</td>
					<td nowrap="nowrap">  
						<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="64"  />
						<label for="ultimo">&Uacute;ltimo día del mes</label>  
						<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="65" /> 
						<label for="diaMes">D&iacute;a del mes</label>
						<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" tabindex="66" />
					</td>
					<td class="separador"></td>  
					<td class="label">  
						<label for="DiaPago">D&iacute;a Pago: </label> 
				 	</td> 
				 	<td nowrap="nowrap">  
						<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="67"  />
						<label for="ultimoDPC">&Uacute;ltimo día del mes</label>&nbsp;  
						<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" tabindex="68" />
						<label for="diaMesDPC">D&iacute;a del mes</label>
						<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" tabindex="69" />
					</td>
				</tr>
				<tr>
					<td class="label"> 
						<label for="DiaMes">D&iacute;a del mes: </label> 
					</td>
		 			<td>
		 				<form:input type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8" tabindex="70" readonly="true"/>
					</td>
					<td class="separador"></td> 
					<td class="label">  
						<label for="DiaMes">D&iacute;a del mes: </label> 
					</td>
		 			<td> 
		 				<form:input type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8" tabindex="71" readonly="true"/>
					</td>
				</tr>	
				<tr>
					<td class="label">
						<label for="numAmort">N&uacute;mero de Cuotas:</label> 
					</td>
					<td >
						<form:input  type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="72" readonly="true"/>
					</td> 
					<td class="separador"></td> 
					<td class="label">
						<label for="numAmort">N&uacute;mero de Cuotas:</label> 
					</td>
					<td >
						<form:input type="text"  id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="73" readonly="true"/>
					</td> 
				</tr>
				<tr>
					<td colspan="5"> 
		 				<input id="montosCapital" name="montosCapital" size="100" type="hidden" tabindex="74"/>
		 				<input id="noDias" name="noDias" size="10" type="hidden" tabindex="75"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblMontoCuota">Monto Cuota:</label> 
					</td>
					<td>
						<form:input  type="text"  id="montoCuota" name="montoCuota" path="montoCuota" size="15" readonly ="true" esMoneda="true" 
							 style="text-align: right"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblMontoCuota">Margen Primer Cuota:</label> 
					</td>
					<td >
						<form:input  type="text" id="margenPriCuota" name="margenPriCuota" path="margenPriCuota" size="8" tabindex="77" 
					 	 	 value="0"/>
					 	<form:input  id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" 
					 	 			 readonly="true" type="hidden" value="0"/>
					</td>
				</tr>
				<tr>
					<td colspan="5" align="right"> 
		 				<button type="button" class="submit" id="simular" name="simular" tabindex="78">Simular</button> 
					</td>
				</tr>
			</table>
		</fieldset> 
	</fieldset>
	<div id="contenedorSimulador" style="display: none;"></div>
	<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
	<br>
	<br>
	<table style="text-align: right;width: 100%">
		<tr>
			<td align="right">
				
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega" tabindex="80"/>
				<button type="button" class="submit" id="contrato" style="" tabindex="79">Contrato </button>
				<!--  <input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="76"/> -->
				<a id="enlace" href="poliza.htm" target="_blank">
                	<button type="button" class="submit" id="impPoliza" style="display:none" tabindex="81"> Ver P&oacute;liza</button>
                </a>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		 
				<a id="ligaImp" href="contratoInv.htm" target="_blank" >
	             		<button type="button" class="submit" id="imprimir" style="" tabindex="17">
	              		Pagar&eacute;
	             		</button> 
	            </a>
	            <input type="hidden" id="tipoFon" name="tipoFon" /> 
	            <input type="hidden" id="tiposFons" name="tiposFons" /> 
	            <input type="hidden" id="tipoFondeadorCred" name="tiposFons" /> 
	             <input type="hidden" id="institutFondIDCon" name="tiposFons" /> 
	            
			</td>
		</tr>
	</table>
	<input type="hidden" id="numClienteEspec" name="numClienteEspec" />	
</fieldset>
</form:form> 
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>		
</body>
<html>