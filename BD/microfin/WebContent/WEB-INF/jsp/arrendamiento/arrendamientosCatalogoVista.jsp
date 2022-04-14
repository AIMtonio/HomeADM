<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productoArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segurosArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segurosVidaArrendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
		<script type="text/javascript" src="js/arrendamiento/arrendamientosCatalogo.js"></script>     
	</head>
	<script language="javascript">	
		$(document).ready(function() {
			// Este codigo evita que al presionar la tecla enter haga el post
			$('form').keypress(function(e){   
	    		if(e == 13){
	      	return false;
	    		}
			});
			
			$('input').keypress(function(e){
		    	if(e.which == 13){
		      	return false;
		    	}
			});
		});
	</script>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="arrendamientosBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Arrendamiento</legend>	
<table border="0">
	<tr>
		<td>
			<table style="border: 0">
				<tr>
					<td class="label"><label for="arrendaID">N&uacute;mero: </label></td> 
					<td>
						<form:input type="text"  id="arrendaID" name="arrendaID" path="arrendaID" size="12" tabindex="1"  autocomplete="off" />
					</td>
					<td class="separador"></td>
					<td class="label"><label for="lineaArrendaID">L&iacute;nea de Arrendamiento: </label></td>
				   	<td nowrap="nowrap">
					 	<form:input type="text" id="lineaArrendaID" name="lineaArrendaID" path="lineaArrendaID" size="12" tabindex="2" autocomplete="off" />
					 	<input type="text" id="descripcionLinea" name="descripcionLinea" tabindex="3" disabled="true"  readonly="readonly" size="35"/> 
					</td>
				</tr>
				<tr>
					<td class="label"><label for="clienteID"><s:message code="safilocale.cliente"/>: </label></td> 
					<td nowrap="nowrap">
						<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="4" autocomplete="off"/>
						<input type="text" id="nombreCliente" name="nombreCliente" tabindex="5" disabled="true" size="40"/> 
					</td>				
					<td class="separador"></td>
					<td class="label" nowrap="nowrap"><label for="productoArrendaID">Producto Arrendamiento: </label></td> 
					<td nowrap="nowrap">
						<form:input type="text" id="productoArrendaID" name="productoArrendaID" path="productoArrendaID" size="12" tabindex="6" autocomplete="off" />
					 	<input type="text" id="descripcionProducto" name="descripcionProducto" tabindex="7" disabled="true"  readonly="readonly" size="35"/>
					</td>	
				</tr>
				<tr>
					<td class="label"><label for="Moneda">Moneda: </label></td>
					<td>
						<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="8" disabled="true" >
							<form:option value="">SELECCIONAR</form:option>
						</form:select> 
					</td>	
					<td class="separador"></td>
					<td class="label"><label for="estatus">Estatus:</label></td>
				   	<td>
				   		<form:select id="estatus" name="estatus" path="estatus"  tabindex="9" disabled="true">
					    	<form:option value=""></form:option>
					    	<form:option value="G">GENERADO</form:option>
							<form:option value="A">AUTORIZADO</form:option>
							<form:option value="C">CANCELADO</form:option>
					     	<form:option value="V">VIGENTE</form:option>
							<form:option value="B">VENCIDO</form:option>
							<form:option value="P">PAGADO</form:option>
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"><label for="tipoArrenda">Tipo Arrendamiento:</label></td>
				   	<td>
				   		<form:select id="tipoArrenda" name="tipoArrenda" path="tipoArrenda"  tabindex="10" >
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="F">FINANCIERO</form:option>
							<form:option value="P">PURO</form:option>
						</form:select>
					</td>
					<td class="separador"></td>
				</tr>
			</table>
			<br>
		</td> 
	</tr>
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Condiciones</legend>						
			<table style="width: 100%;border: 0">
				<tr>
					<td class="label"><label for="montoArrenda">Monto:</label></td>
					<td>
						<form:input type="text" id="montoArrenda" name="montoArrenda" path="montoArrenda" size="18" esMoneda="true" tabindex="11"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="ivaMontoArrenda">IVA:</label></td>
					<td>
						<form:input type="text" id="ivaMontoArrenda" name="ivaMontoArrenda" path="ivaMontoArrenda" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="12"  style="text-align: right"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="porcEnganche">% Enganche: </label> 
					</td>
					<td>
						<form:input type="text" id="porcEnganche" name="porcEnganche" path="porcEnganche" size="18"
						 	esMoneda="true" tabindex="13"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="montoEnganche">Enganche: </label> 
					</td>
					<td>
						<form:input type="text" id="montoEnganche" name="montoEnganche" path="montoEnganche" size="18"
						 	esMoneda="true" tabindex="14"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="ivaEnganche">IVA Enganche: </label></td>
					<td>
						<form:input type="text" id="ivaEnganche" name="ivaEnganche" path="ivaEnganche" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="15"  style="text-align: right"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="montoResidual">Valor Residual: </label></td>
					<td>
						<form:input type="text" id="montoResidual" name="montoResidual" path="montoResidual" size="18" esMoneda="true"  tabindex="16"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="fechaApertura">Fecha de Apertura: </label></td> 
		     		<td> 
		         		<form:input type="text" id="fechaApertura" name="fechaApertura" size="18" path="fechaApertura" tabindex="17" esCalendario="true"/>  
		     		</td>  
				</tr>
				<tr>
					<td class="label"><label for="tasaFijaAnual">Tasa Anualizada: </label></td>
				   	<td>
					 	<form:input type="text" id="tasaFijaAnual" name="tasaFijaAnual" path="tasaFijaAnual" size="8" tabindex="18" esTasa="true" style="text-align: right" onfocus="validaFocoInputTasa(this.id);"/>
					 	<label for="porcentaje">%</label> 
					</td>
				</tr>
				<tr>
					<td class="label"><label for="seguroArrendaID">Aseguradora: </label></td>
					<td>
						<form:input type="text" id="seguroArrendaID" name="seguroArrendaID" path="seguroArrendaID" size="18" tabindex="19" autocomplete="off"  />
					 	<input type="text" id="descripcionSeg" name="descripcionSeg" disabled="true"  readonly="readonly" size="35"/>	
					</td>
					<td class="separador"></td>
					<td class="label"><label for="montoSeguroAnual">Monto Seguro Anual: </label></td>
					<td>
						<form:input type="text" id="montoSeguroAnual" name="montoSeguroAnual" path="montoSeguroAnual" size="18" esMoneda="true" tabindex="20"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="tipoPagoSeguro">Tipo Pago Seguro:</label></td>
				   	<td>
				   		<form:select id="tipoPagoSeguro" name="tipoPagoSeguro" path="tipoPagoSeguro"  tabindex="21" >
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="1">CONTADO</form:option>
							<form:option value="2">FINANCIADO</form:option>
						</form:select>
					</td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td class="label"><label for="seguroVidaArrendaID">Aseguradora Vida: </label></td>
					<td>
						<form:input type="text" id="seguroVidaArrendaID" name="seguroVidaArrendaID" path="seguroVidaArrendaID" size="18" tabindex="22"   autocomplete="off"  />
						<input type="text" id="descripcionSegVida" name="descripcionSegVida" disabled="true"  readonly="readonly" size="35"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="montoSeguroVidaAnual">Monto Seguro Vida Anual: </label></td>
					<td>
						<form:input type="text" id="montoSeguroVidaAnual" name="montoSeguroVidaAnual" path="montoSeguroVidaAnual" size="18" esMoneda="true" tabindex="23"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="tipoPagoSeguroVida">Tipo Pago Seguro Vida :</label></td>
				   	<td>
				   		<form:select id="tipoPagoSeguroVida" name="tipoPagoSeguroVida" path="tipoPagoSeguroVida"  tabindex="24" >
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="1">CONTADO</form:option>
							<form:option value="2">FINANCIADO</form:option>
						</form:select>
					</td>
					<td class="separador"></td>
				</tr>
			</table>
			</fieldset>	
		</td> 
	</tr>
	<tr>
		<td>
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend>Calendario de Pagos</legend>		
				<fieldset class="ui-widget ui-widget-content ui-corner-all">	 	
				<table border="0" width="100%">
					<tr>			     		
			 			<td class="label"><label for="frecuenciaPlazo">Periodicidad: </label></td>   	
					   	<td> 
			         		<form:select  id="frecuenciaPlazo" name="frecuenciaPlazo" path="frecuenciaPlazo" tabindex="25" >
					        	<form:option value="">SELECCIONAR</form:option>
					        	<form:option value="M">MENSUAL</form:option>
						   	</form:select>	
			     		</td>
			     		<td class="separador"></td>  
			     		<td class="label"><label for="plazo">Plazo: </label></td>   	
					   	<td> 
			         		<form:select  id="plazo" name="plazo" path="plazo" tabindex="26" >
					        	<form:option value="">SELECCIONAR</form:option>
					        	<form:option value="24">24</form:option>
					        	<form:option value="36">36</form:option>
					        	<form:option value="48">48</form:option>
					        	<form:option value="60">60</form:option>
					        	<form:option value="72">72</form:option>
						   	</form:select>	
			     		</td>
			     	</tr>
					<tr>
						<td class="label"><label for="diaPagoProd">D&iacute;a Pago: </label></td>
						<td nowrap="nowrap">  
							<select  id="diaPagoProd" name="diaPagoProd" path="diaPagoProd" tabindex="27" >
						       <option value="">SELECCIONAR</option>
						       <option value="F">FIN DE MES</option>
						       <option value="A">ANIVERSARIO</option>
							</select>
						</td>
						<td class="separador"></td>  
						<td class="label"><label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label></td>
						<td class="label">  
							<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" tabindex="28" checked="true"  />
							<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
							<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" tabindex="29" readonly="true" value="S"/>
						</td>
					</tr>
					<tr>
						<td class="label"><label for="fechaPrimerVen">Primer vencimiento: </label></td>
						<td>
			         		<form:input type="text" id="fechaPrimerVen" name="fechaPrimerVen" size="18" readonly="true" disabled="disabled" path="fechaPrimerVen"  />  
						</td>
						<td class="separador"></td>
						<td class="label"><label for="fechaUltimoVen">&Uacute;ltimo vencimiento: </label></td> 
			     		<td> 
			         		<form:input type="text" id="fechaUltimoVen" name="fechaUltimoVen" size="18" readonly="true" disabled="disabled" path="fechaUltimoVen"  />  
			     		</td>  
					</tr>
					<tr>
						<td class="label"><label for="numAmort">N&uacute;mero de Cuotas:</label></td>
						<td >
							<form:input type="text"  id="cantCuota" name="cantCuota" path="cantCuota" size="8" tabindex="30" disabled="true"/>
						</td>
						<td class="separador"></td>  
						<td class="label"><label for="rentasAnticipada">Renta anticipada: </label></td>
						<td class="label">  
							<input id="rentaAnticipadaS" type="radio" name="rentasAnticipada" value="S" tabindex="31"/>
							<label>S&iacute;</label>&nbsp;
							<input id="rentaAnticipadaN" type="radio" name="rentasAnticipada" value="N" tabindex="32"/>
							<label>No</label>&nbsp;
							<form:input type="hidden" id="rentaAnticipada" name="rentaAnticipada" path="rentaAnticipada" size="15" tabindex="29" readonly="true" value="N"/>
						</td>
					</tr>
					<tr>
						<td class="label"><label for="rentasAdelantadas">Rentas adelantadas:</label></td>
						<td >
							<form:input type="text" id="rentasAdelantadas" name="rentasAdelantadas" path="rentasAdelantadas" size="8" tabindex="33"/>
						</td>
						<td class="separador"></td>
						<td class="label"><label for="adelanto">Adelanto: </label></td>
						<td class="label">  
							<input id="adelantoPri" type="radio" name="adelantos" disabled="disabled" value="P" tabindex="34"/>
							<label>Primeras</label>&nbsp;
							<input id="adelantoUlt" type="radio" name="adelantos" disabled="disabled" value="U" tabindex="35"/>
							<label>&Uacute;ltimas</label>&nbsp;
							<form:input type="hidden" id="adelanto" name="adelanto" path="adelanto" size="15" tabindex="29" readonly="true"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="button" id="simular" name="simular" class="submit" value="Simular" tabindex="36"/>
						</td>
					</tr>
				</table>
				</fieldset>
			</fieldset>
		</td> 
	</tr>
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend>Pago Inicial</legend>						
			<table style="width: 100%;border: 0">
				<tr>
					<td class="label"><label for="montoEngancheConsulta">Enganche: </label></td>
					<td>
						<input type="text" id="montoEngancheConsulta" name="montoEngancheConsulta" size="18" esMoneda="true" tabindex="37"  style="text-align: right" disabled="true" readonly="true"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="ivaEngancheConsulta">IVA Enganche: </label></td>
					<td>
						<input type="text" id="ivaEngancheConsulta" name="ivaEngancheConsulta" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="38"  style="text-align: right"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="montoComApe">Monto Comisi&oacute;n de Apertura: </label></td>
					<td>
						<form:input type="text" id="montoComApe" name="montoComApe" path="montoComApe" size="18" esMoneda="true" tabindex="39"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="ivaComApe">IVA Comisi&oacute;n de Apertura:: </label></td>
					<td>
						<form:input type="text" id="ivaComApe" name="ivaComApe" path="ivaComApe" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="40"  style="text-align: right"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="otroGastos">Otros Gastos (Placas y tenencias): </label></td>
					<td>
						<form:input type="text" id="otroGastos" name="otroGastos" path="otroGastos" size="18" esMoneda="true" tabindex="41"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="otroGastos">IVA Otros Gastos: </label></td>
					<td>
						<form:input type="text" id="ivaOtrosGastos" name="ivaOtrosGastos" path="ivaOtrosGastos" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="42"  style="text-align: right"/>
					</td>
				</tr>
				<tr>
					<td class="label"><label for="cantRentaDepo">Rentas en dep&oacute;sito: </label></td>
					<td>
						<form:input type="text" id="cantRentaDepo" name="cantRentaDepo" path="cantRentaDepo" size="18" tabindex="43"  style="text-align: right" />
					</td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td class="label" nowrap="nowrap"><label for="montoDeposito">Monto Rentas en dep&oacute;sito: </label></td>
					<td>
						<form:input type="text" id="montoDeposito" name="montoDeposito" path="montoDeposito" size="18" esMoneda="true" tabindex="44"  disabled="true" style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="ivaDeposito">IVA Rentas en dep&oacute;sito: </label></td>
					<td>
						<form:input type="text" id="ivaDeposito" name="ivaDeposito" path="ivaDeposito" size="18" tabindex="45"  style="text-align: right" disabled="true" readonly="true"  />
					</td>
				</tr>
				<tr>
					<td class="label"><label for="montoSeguro">Monto Seguro: </label></td>
					<td>
						<input type="text" id="montoSeguroConsulta" name="montoSeguroConsulta" size="18" esMoneda="true" disabled="true" readonly="true" style="text-align: right"/>
					</td>
					<td class="separador"></td>
					<td class="label"><label for="montoSeguroVida">Monto Seguro Vida: </label></td>
					<td>
						<input type="text" id="montoSeguroVidaConsulta" name="montoSeguroVidaConsulta" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="46"  style="text-align: right" />
					</td>
				</tr>
				<tr>
					<td class="label"><label for="concRentaAnticipada">Renta anticipada: </label></td>
					<td>
						<form:input type="text" id="concRentaAnticipada" name="concRentaAnticipada" path="concRentaAnticipada" size="18" esMoneda="true" disabled="true" readonly="true" style="text-align: right" />
					</td>
					<td class="separador"></td>
					<td class="label"><label for="concIvaRentaAnticipada">IVA Renta anticipada: </label></td>
					<td>
						<form:input type="text" id="concIvaRentaAnticipada" name="concIvaRentaAnticipada" path="concIvaRentaAnticipada" size="18" disabled="true" readonly="true" esMoneda="true" style="text-align: right" />
					</td>
				</tr>
				<tr>
					<td class="label"><label for="concRentasAdelantadas">Cuotas adelantadas: </label></td>
					<td>
						<form:input type="text" id="concRentasAdelantadas" name="concRentasAdelantadas" path="concRentasAdelantadas" size="18" esMoneda="true" disabled="true" readonly="true" style="text-align: right" />
					</td>
					<td class="separador"></td>
					<td class="label"><label for="concIvaRentasAdelantadas">IVA Cuotas adelantadas: </label></td>
					<td>
						<form:input type="text" id="concIvaRentasAdelantadas" name="concIvaRentasAdelantadas" path="concIvaRentasAdelantadas" size="18" disabled="true" readonly="true" esMoneda="true" style="text-align: right" />
					</td>
				</tr>
				<tr>
					<td class="label"><label for="totalPagoInicial">Total Pago Inicial: </label></td>
					<td>
						<form:input type="text" id="totalPagoInicial" name="totalPagoInicial" path="totalPagoInicial" size="18" esMoneda="true" disabled="true" readonly="true" style="text-align: right" />
					</td>
					<td class="separador"></td>
					<td class="label"><label for="montoFinanciado">Monto Financiado: </label></td>
					<td>
						<form:input type="text" id="montoFinanciado" name="montoFinanciado" path="montoFinanciado" size="18" disabled="true" readonly="true" esMoneda="true" tabindex="47"  style="text-align: right" />
					</td>
				</tr>
			</table>
			</fieldset>
		</td> 
	</tr>
	<tr>
		<td>
			<div id="contenedorSimulador" style="display: none;"></div>
		</td> 
	</tr>
	<tr>
		<td align="right">
			<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="48"/>
			<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="49"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
		</td>
	</tr>
	<tr>
		<td>
			<form:input type="hidden" id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" disabled = "true" value="0"/>
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
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
<div id="mensaje" style="display: none;"></div>		
</body>
<html>