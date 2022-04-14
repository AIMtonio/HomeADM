<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
	<script type="text/javascript" src="js/originacion/cambioTasa.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Tasa</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCreditoBean" target="_blank">
			<table border="0" width="100%">							
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblSolicitudCreditoID">Solicitud de Crédito: </label></td>
				   <td nowrap="nowrap">
				   		<input type="text" id="solicitudCreditoID" name="solicitudCreditoID" size="12" iniForma="false" tabindex="1"/>
				   		<input type="text" id="cliNombreCompleto" name="cliNombreCompleto" size="50"  readonly="true" disabled="disabled" tabindex="2"/>
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblProductoCreditoID">Producto de Crédito: </label></td>
				   <td nowrap="nowrap">
				   		<input type="text" id="productoCreditoID" name="productoCreditoID" size="12" readonly="true" disabled="disabled" tabindex="3"/>
				   		<input type="text" id="descripcion" name="descripcion" size="30" readonly="true" disabled="disabled" tabindex="4"/>
				   </td>
				</tr>		
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblFechaInicio">Fecha Inicio: </label></td>
				   <td>
				   		<input type="text" id="fechaInicio" name="fechaInicio" size="15" readonly="true" disabled="disabled" tabindex="5"/>				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblCicloActual">Ciclo Actual: </label></td>
				   <td>
				   		<input type="text" id="cicloActual" name="cicloActual" size="10" readonly="true" disabled="disabled" tabindex="6"/>				   		
				   </td>
				</tr>	
				<tr>  
				  <td class="label" nowrap="nowrap"><label for="lblFechaVencimiento">Fecha Vencimiento: </label></td>
				   <td>
				   		<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="15" readonly="true" disabled="disabled" tabindex="7"/>				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblPlazoID">Plazo: </label></td>
				   <td>
				   		<input type="text" id="plazoID" name="plazoID" size="10" readonly="true" disabled="disabled" tabindex="8"/>				   		
				   </td>
				</tr>	
				<tr>  
				   <td class="label" nowrap="nowrap"><label id="lblTasaFija">Tasa Fija Anualizada: </label></td>
				   <td>
				   		<input type="text" id="tasaFijaAna" name="tasaFijaAna" size="10" readonly="true" disabled="disabled" estasa="true" tabindex="9"  style="text-align: right;"/>
				   		<label for="lblPorcinto"> % </label>				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblFactorMoraAna">Moratorio: </label></td>
				   <td>
				   		<input type="text" id="factorMoraAna" name="factorMoraAna" size="10" readonly="true" disabled="disabled" estasa="true" tabindex="10" style="text-align: right;"/>				   		
				   </td>
				</tr>
				<tr>  
				   <td class="label" nowrap="nowrap"><label for="lblTipoComxAperturaAna">Tipo Com. x Apertura: </label></td>
				   <td>
				   		<input type="text" id="tipoComxAperturaAna" name="tipoComxAperturaAna" size="3" readonly="true" disabled="disabled" tabindex="11"/>				   				   		
				   </td>
				   <td class="separador"></td>
				   <td class="label" nowrap="nowrap"><label for="lblValorComxAperturaAna">Valor Com. x Apertura: </label></td>
				   <td>
				   		<input type="text" id="valorComxAperturaAna" name="valorComxAperturaAna" size="10" readonly="true" disabled="disabled" esMoneda="true" tabindex="12" style="text-align: right;"/>				   		
				   </td>
				</tr>
				
		 		<tr name="tasaBase">
			   		<td class="label"> 
		        		<label for="lblcalInter">C&aacute;lculo de Inter&eacute;s </label> 
		    		</td> 
		    		 <td>
		    		<form:select id="calcInteres" name="calcInteres" path="" tabindex="24" disabled= "true">
						<form:option value="">SELECCIONAR</form:option>
					</form:select>	
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="tasaBaseAna">Tasa Base: </label> 
					</td>
				   	<td>
						<input type="text" id="tasaBaseAna" name="tasaBaseAna" size="10" tabindex="60"
							readonly="true" disabled="disabled"/>
					 	<input type="text" id="desTasaBase" name="desTasaBase" size="25" 
						       readonly="true" disabled="true" tabindex="61"/>			 	
					</td>
				</tr>
		 		<tr name="tasaBase">
					<td class="label">
						<label for="tasaBaseValor">Valor Tasa Base: </label> 
					</td>
					<td >
						<input type="text" id="tasaBaseValor" name="tasaBaseValor" size="10"
					 		tabindex="62" esTasa="true" readonly="true" disabled="disabled" style="text-align: right;"/>
					 	<label for="porcentaje">%</label> 
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="sobreTasaAna">Sobre Tasa: </label> 
					</td>
				   	<td>
						<input type="text" id="sobreTasaAna" name="sobreTasaAna" size="10"
					 		esTasa="true" tabindex="63" readonly="true" disabled="disabled" style="text-align: right;"/>
					 	<label for="porcentaje">%</label> 
					</td>
				</tr>
		 		<tr name="tasaPisoTecho">
					<td class="label">
						<label for="pisoTasaAna">Piso Tasa: </label> 
					</td>
				   	<td >
					 	<input type="text" id="pisoTasaAna" name="pisoTasaAna" size="10" readonly="true" disabled="disabled"
					 		style="text-align: right;" esTasa="true" tabindex="64"/>
					 	<label for="porcentaje">%</label> 
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="techoTasaAna">Techo Tasa: </label> 
					</td>
				   	<td>
						<input type="text" id="techoTasaAna" name="techoTasaAna" size="10" readonly="true" disabled="disabled"
					 		style="text-align: right;" esTasa="true" tabindex="65" />
					 	<label for="porcentaje">%</label> 
					</td>
				</tr>
			</table>
			</br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend>Tasa de Inter&eacute;s</legend>
				<table border="0" width="100%">							
					<tr colspan="5">  
						<td class="label" nowrap="nowrap" width="22%">
							<label for="lblCondiModificar">Condición a Modificar: </label>
						</td>
						<td width="24%">
					   		<select id="condiModificar" name="condiModificar" path="" disabled="disabled" tabindex="13">
					   			<option value="1" selected>SELECCIONAR</option>
								<option value="2">Todos</option>
					     		<option value="3">Tasa Ordinaria</option>
					     		<option value="4">Tasa Moratoria</option>
					     		<option value="5">Comisión por Apertura</option>
							</select>			   		
					   	</td>
					   	<td class="separador" name="tasaFija"></td>
					   	<td class="label" nowrap="nowrap" name="tasaFija">
					   		<label for="lblTipCobComMorato">Tipo Cob. Mora: </label>
					   	</td>
					   	<td name="tasaFija">
					   		<select id="tipCobComMorato" name="tipCobComMorato" disabled="disabled" tabindex="14">
								<option value="N">N veces Tasa Ordinaria</option>
					     		<option value="T">Tasa Fija Anualizada</option>
							</select>			   		
					   	</td>												
					</tr>
					<tr>
						<td class="label" name="tasaBase">
							<label for="SobreTasa">Sobre Tasa: </label> 
						</td>
					   	<td name="tasaBase">
							<input type="text" id="sobreTasa" name="sobreTasa" size="8" disabled="disabled"
						 		esTasa="true" tabindex="63" style="text-align: right;"/>
						 	<label for="porcentaje">%</label> 
						</td>
					  	<td class="separador" name="tasaBase"></td>
						<td class="label" nowrap="nowrap">
							<label for="tasaFija" id="lblTasaOrdinaria">Tasa Ordinaria: </label>
						</td>
					   	<td>
					   		<input type="text" id="tasaFija" name="tasaFija" size="10" readonly="true" disabled="disabled" 
					   			estasa="true" tabindex="15" style="text-align: right;"/>
					   		<label for="lblPorcinto"> % </label>				   		
					  	</td>
					  	<td class="separador" name="tasaFija"></td>
					  	<td class="label" nowrap="nowrap" name="tasaFija">
					  		<label for="lblFactorMora">Moratorio: </label>
					  	</td>
						<td name="tasaFija">
					   		<input type="text" id="factorMora" name="factorMora" size="10" readonly="true" disabled="disabled"  estasa="true" tabindex="16"
					   		style="text-align: right;"/>					   					   		
					  	</td>
					   	
					</tr>
					<tr name="tasaFija">
						<td class="label" nowrap="nowrap"><label for="lblTipoComxApertura">Tipo Com. x Apertura: </label></td>
						<td>
							<input type="text" id="tipoComxApertura" name="tipoComxApertura" size="3" readonly="true" disabled="disabled" tabindex="17"/>				   				   		
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label for="lblmontoPorComAper">Valor Com. x Apertura: </label></td>
						<td>
							<input type="text" id="montoPorComAper" name="montoPorComAper" size="10" readonly="true" disabled="disabled" esMoneda="true" tabindex="18"
							style="text-align: right;"/>				   		
						</td>
					</tr>
				</table>
			</fieldset>
			<table align="right">		
			<tr>		
				<td align="right">
					<table align="right" border='0'>
						<tr align="right">					
							<td align="right">
							  <a target="_blank" >									  				
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="19"/>	
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
								<input type="hidden" id="cobraMora" name="cobraMora"/>			             		 
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