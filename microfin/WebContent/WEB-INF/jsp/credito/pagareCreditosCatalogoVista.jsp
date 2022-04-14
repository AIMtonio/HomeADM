<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/contratoCreditoIndivServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/pagareCreditoIndivServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/referenciasPagosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
		
		<script type="text/javascript" src="js/contratos/contratoIndividualConsol.js"></script>    <!-- Este js corresponde al contrato individual de Consol -->
		<script type="text/javascript" src="js/contratos/contratoIndividualMilagro.js"></script>    <!-- Este js corresponde al contrato individual de Confiadora -->
		<script type="text/javascript" src="js/contratos/pagareIndividualMilagro.js"></script>    <!-- Este js corresponde al pagare individual de Confiadora -->
		<script type="text/javascript" src="js/contratos/pagareIndividualConsol.js"></script>    <!-- Este js corresponde al pagare individual de Consol -->
	    <script type="text/javascript" src="js/credito/pagareCreditos.js"></script>

	</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Pagar&eacute; de Cr&eacute;dito</legend>
	<table border="0" width="1100px">
		<tr>
			<td class="label">
				<label for="credito">N&uacute;mero: </label>
			</td>
			<td >
				<form:input id="creditoID" name="creditoID" path="creditoID" size="12"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td>
			<td >
				<form:input id="clienteID" name="clienteID" path="clienteID" size="12"  readonly="true" disabled="true" />
				<input type="text" id="nombreCliente" name="nombreCliente"  readonly="true" disabled="true" size="40"/>
				<input type="hidden" id="tipoPersonaCli" name="tipoPersonaCli"/>
			</td>
		</tr>
		<tr id="datosNomina">
			<td id="lblnomina" class="label" >
				<label for="lblCalif">Empresa N&oacute;mina: </label>
			</td>
			<td id="institNominaID">
				<input type="text" id="institucionNominaID" name="institucionNominaID"  size="11" disabled="disabled"/>
				<input type="text" id="nombreInstit" name="nombreInstit"  disabled="disabled" size="40" />
			</td>
			<td class="separador"></td>
			<td id="lblnomina" class="label">
				<label for="lblCalif">Convenio: </label>
			</td>
			<td>
				<input type="text" id="convenioNominaID" name="convenioNominaID" size="11" disabled="disabled"/>
				<input type="text" id="desConvenio" name="desConvenio"   disabled="disabled" size="40" />
			</td>
 		</tr>
 		<tr>
			<td>
				<label class="folioSolici">Folio:</label>
			</td>
			<td >
				<input id="folioSolici" name="folioSolici" size="20" disabled="disabled" class="folioSolici"/>
			</td>
			<td class="separador"></td>
			<td class="quinquenios">
				<label for="quinquenioID">Quinquenio:</label>
			</td>
			<td >
				<select id="quinquenioID" name="quinquenioID" disabled="disabled" class="quinquenios">
					<option value="">SELECCIONAR</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="lineaCred">L&iacute;nea de Cr&eacute;dito: </label>
			</td>
			<td >
			 	<form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="10"
			 	readonly="true" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
			 	<label for="lineaCred">Producto de Cr&eacute;dito: </label>
			</td>
		   <td>
			 	<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5"
			 	disabled="true" />
			 	<input type="text" id="nombreProd" name="nombreProd" disabled="true" size="45" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="Cuenta">Cuenta: </label>
			</td>
		   <td>
		    	<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="10"  readonly="true"
		   	 disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="fechaDesembolso">Fecha de Desembolso: </label>
			</td>
			<td >
				<form:input type="text" id="fechaMinistrado" name="fechaMinistrado" path="fechaMinistrado" size="15" esCalendario="true"/>
				<input type="hidden" id="fechaMinistradoOriginal" name="fechaMinistradoOriginal"  size="15"   />
			</td>
		</tr>
		<tr id="pregagos">
			<td class="label">
					<label for="lblTipoPrepago">Tipo Prepago Capital: </label>
			</td>
			<td>
		     		<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" >
		     			<form:option value="">SELECCIONAR</form:option>
		     			<form:option value="U">&Uacute;LTIMAS CUOTAS</form:option>
				      	<form:option value="I">CUOTAS SIGUIENTES INMEDIATAS</form:option>
						<form:option value="V">PRORRATEO CUOTAS VIVAS</form:option>
						<form:option value="P">CUOTAS COMPLETAS PROYECTADAS</form:option>
				     </form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="Estatus">Estatus:</label>
			</td>
		   <td>
		   <form:select id="estatus" name="estatus" path="estatus"  readonly="true" disabled="true" >
			     	<form:option value="I">INACTIVO</form:option>
			     	<form:option value="V">VIGENTE</form:option>
					<form:option value="P">PAGADO</form:option>
					<form:option value="C">CANCELADO</form:option>
					<form:option value="A">AUTORIZADO</form:option>
					<form:option value="B">VENCIDO</form:option>
					<form:option value="K">CASTIGADO</form:option>
					<form:option value="M">PROCESADO</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
		<td class="label">
			<label>Tipo Cr&eacute;dito: </label>
		</td>
		<td>
			<input type="text" id="tipoCreditoDes" size="20" readonly="true"/>
		</td>
		<td class="separador"></td>
	</tr>
	</table>
	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Saldos de la L&iacute;nea de Cr&eacute;dito</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="950px">
			<tr>
				<td class="label">
					<label for="SaldoDisponible">Saldo disponible: </label>
				</td>
			   <td>
				 	<input type="text" id="saldoDisponible" name="saldoDisponible" size="15"
				 	readonly="true" disabled="true"  esMoneda="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="Moneda">Saldo Deudor: </label>
				</td>
			   <td >
				 	<input type="text" id="saldoDeudor" name="saldoDeudor" size="15"
				 	readonly="true" disabled="true" esMoneda="true" style="text-align: right;"/>
				</td>
			</tr>
		</table>
		</fieldset>

		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Condiciones</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="950px">
			<tr>
				<td class="label">
					<label for="Monto">Monto: </label>
				</td>
			   <td>
				 	<form:input id="montoCredito" name="montoCredito" path="montoCredito" size="15" style="text-align: right;"
				 		readonly="true" disabled="true" esMoneda="true"  />
				</td>
				<td class="separador"></td>
				<td class="label">
				<label for="lblPlazo">Plazo: </label>
				</td>
				<td>
			     	<select  id="plazoID" name="plazoID" path="plazoID" readonly="true" disabled="true">
					    <option value="">SELECCIONAR</option>
					</select>
			  	</td>
			</tr>
			<tr>
				<td class="label">
					<label for="FechaInic">Fecha de Inicio : </label>
				</td>
			   <td >
				 	<form:input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="15"
				 	readonly="true" disabled="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="fechaInicio">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
				</td>
			   <td>
				 	<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="15" readOnly="true" path="fechaInicioAmor" />
				</td>
			</tr>
			<tr>
	     		<td class="label">
	         		<label for="FechaVencimiento">Fecha de Vencimiento: </label>
	     		</td>
	     		<td>
	         		<form:input type="text" id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="15" readonly="true" disabled="true"/>
	     		</td>
	     		<td class="separador"></td>
	     		<td class="label">
	         		<label for="comision">Monto Seguro Vida: </label>
	     		</td>
	     		<td>
	         		<form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" size="15" style="text-align: right" esmoneda="true" disabled="true" />
	     		</td>
			</tr>
			<tr>
				<td class="label">
				<label for="comision">Comisi&oacute;n por apertura: </label>
				</td>
			    <td>
				 	<form:input type="text"  id="montoComision" name="montoComision" path="montoComision" size="15"
				 	esMoneda="true"  disabled="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="Moneda">IVA Comisi&oacute;n: </label>
				</td>
				<td>
					<form:input type="text" id="IVAComApertura" name="IVAComApertura" path="montoComision"
					 esMoneda="true" disabled="true" size="15" style="text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="fechaCobroComision">Fecha Cobro Comisión: </label>
				</td>
				<td>
					<form:input type="text" id="fechaCobroComision" name="fechaCobroComision" size="18" readOnly="true" disabled="true" path="fechaCobroComision"/>
				</td>
				<td class="separador"></td>

				<td class="label">
					<label for="Moneda">Moneda: </label>
				</td>
			   <td >
				 	<form:input type="text" id="monedaID" name="monedaID" path="monedaID" size="3" readonly="true"
				 	 disabled="true" />
				 	<input type="text" id="monedaDes" name="monedaDes" size="30" readonly="true" disabled="true" />
				</td>
			</tr>
			<tr>
				<td>
					<label class="fechaLimiteEnvio" class="fechaLimiteEnvio">Fecha limite de envio de instalaci&oacute;n:  </label>
				</td>
					<td >
						<input type="text" id="fechaLimEnvIns" name="fechaLimEnvIns" size="10" disabled="true" class="fechaLimiteEnvio"/>
				</td>
			</tr>

			</table>
		</fieldset>
		<div id="fieldOtrasComisiones">
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend >Otras Comisiones</legend>
					<table align="right">
						<tr>
							<div id="divAccesoriosCred"></div>
						</tr>
					</table>

			</fieldset>
		</div>
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

		   	<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" disabled="true"  >

				<form:option value="-1">SELECCIONAR</form:option>
			</form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="TasaBase">Tasa Base: </label>
			</td>
		   <td>
			 	<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8"  readonly="true" disabled="true"/>
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="25"
				       readonly="true" disabled="true"  />
			</td>
		</tr>
		<tr>
			<td class="label">
			<label for="tasaFija">Tasa Fija Anualizada: </label>
			</td>
		   <td >
			 	<form:input type="text" id="tasaFija" disabled="true" name="tasaFija" path="tasaFija" size="8"
			 		 esTasa="true"  readonly="true" style="text-align: right;" />
			 		<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="SobreTasa">SobreTasa: </label>
			</td>
		   <td>
			 	<form:input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8"
			 	esTasa="true"  readonly="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
		</tr>

		<tr>
			<td class="label">
			<label for="PisoTasa">Piso Tasa: </label>
			</td>
		   <td >
			 	<form:input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8"
			 					esTasa="true"  readonly="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="TechoTasa">Techo Tasa: </label>
			</td>
		   <td>
			 	<form:input  type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8"
			 					esTasa="true"  readonly="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
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
				<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label>
				</td>
			<td class="label">
				<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" disabled="disabled" readonly="readonly"   />
				<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
				<input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" disabled="disabled" readonly="readonly"  />
				<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
				<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" readonly="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label>
				</td>
			<td class="label">
				<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" disabled="disabled" readonly="readonly" /><label for="Si">Si</label>&nbsp;
				<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" disabled="disabled" readonly="readonly" /><label for="No">No</label>
				<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" readonly="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" disabled="disabled" readonly="readonly" value="S"  />
				<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular"
					readonly="true" value="N" />
	    		<label for="calendarioIrreg">Calendario Irregular </label>
		 	</td>
 		</tr>
		<tr>
			<td class="label">
				<label for="ajusFecUlVenAmo">Ajustar Fecha de Vencimiento de &Uacute;ltima
				 Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label>
			</td>
			<td class="label">
				<input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S" disabled="disabled" readonly="readonly"  /><label for="lblajFecUlAmoVen">Si</label>&nbsp;
				<input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N" disabled="disabled" readonly="readonly"  /><label for="no">No</label>
				<form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15"  readonly="true"/>
			</td>
		</tr>

		<tr>
			<td class="label">
				<label for="TipoPagCap">Tipo de Pago de Capital: </label>
			</td>
			<td class="label">
				<select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" disabled="disabled" readonly="readonly" >
					<option value="">SELECCIONAR</option>
					<option value="C">CRECIENTES</option>
					<option value="I">IGUALES</option>
					<option value="L">LIBRES</option>
				</select>
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
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table border="0" cellpadding="0" cellspacing="0" >
					<tr>
						<td class="label">
							<label for="interes">Inter&eacute;s </label>
						</td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="label">
							<label for="capital">Capital </label>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="FrecuenciaInter">Frecuencia: </label>
						</td>
		   			<td>
		   				<form:select id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt"
		   				readonly="true" disabled="true">
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="S">SEMANAL</form:option>
					    	<form:option value="D">DECENAL</form:option>
					    	<form:option value="C">CATORCENAL</form:option>
					    	<form:option value="Q">QUINCENAL</form:option>
					    	<form:option value="M">MENSUAL</form:option>
					    	<form:option value="P">PERIODO</form:option>
					    	<form:option value="B">BIMESTRAL</form:option>
					    	<form:option value="T">TRIMESTRAL</form:option>
					    	<form:option value="R">TETRAMESTRAL</form:option>
					    	<form:option value="E">SEMESTRAL</form:option>
					    	<form:option value="A">ANUAL</form:option>
					    	<form:option value="U">PAGO &Uacute;NICO</form:option>
					    	<form:option value="L">LIBRE</form:option>
							</form:select>
					</td>
						<td class="separador"></td>
						<td class="label">
							<label for="FrecuenciaCap">Frecuencia: </label>
						</td>
		  				<td>
 							<form:select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap"
 							readonly="true" disabled="true">
					    	<form:option value="">SELECCIONAR</form:option>
					    	<form:option value="S">SEMANAL</form:option>
					    	<form:option value="D">DECENAL</form:option>
					    	<form:option value="C">CATORCENAL</form:option>
					    	<form:option value="Q">QUINCENAL</form:option>
					    	<form:option value="M">MENSUAL</form:option>
					    	<form:option value="P">PERIODO</form:option>
					    	<form:option value="B">BIMESTRAL</form:option>
					    	<form:option value="T">TRIMESTRAL</form:option>
					    	<form:option value="R">TETRAMESTRAL</form:option>
					    	<form:option value="E">SEMESTRAL</form:option>
					    	<form:option value="A">ANUAL</form:option>
					    	<form:option value="U">PAGO &Uacute;NICO</form:option>
					    	<form:option value="L">LIBRE</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label>
						</td>
		  				<td>
			 				<form:input id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="5"
			 					 readonly="true" disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="PeriodicidadCap">Periodicidad de Capital:</label>
						</td>
		   			<td>
			 				<form:input id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="5"
			 				readonly="true" disabled="true"/>
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
							<div id="divDiaPagoIntMes">
								<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F"  disabled="disabled" readonly="readonly" />
								<label for="ultimo">&Uacute;ltimo d&iacute;a del mes</label>
								<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A" disabled="disabled" readonly="readonly" />
								<label for="diaMes">D&iacute;a del mes</label>
							</div>
							<div id="divDiaPagoIntQuinc" style="display: none;" >
								<input type="radio" id="diaPagoInteresD" name="diaPagoInteres3" value="D"  disabled="disabled" readonly="readonly" />
								<label for="diaPagoInteresD">D&iacute;a Quincena</label>
								<input type="radio" id="diaPagoInteresQ" name="diaPagoInteres3" value="Q"  disabled="disabled" readonly="readonly" />
								<label for="diaPagoInteresQ">Quincena</label>
							</div>
							<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8"
								value ="F" />
						</td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td >
							<div id="divDiaPagoCapMes">
								<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F"  disabled="disabled" readonly="readonly" />
								<label for="ultimoDPC">&Uacute;ltimo d&iacute;a del mes</label>&nbsp;
								<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" value="A"  disabled="disabled" readonly="readonly"/>
								<label for="diaMesDPC">D&iacute;a del mes</label>
							</div>
							<div id="divDiaPagoCapQuinc" style="display: none;" >
								<input type="radio" id="diaPagoCapitalD" name="diaPagoCapital3" value="D"  disabled="disabled" readonly="readonly" />
								<label for="diaPagoCapitalD">D&iacute;a Quincena</label>
								<input type="radio" id="diaPagoCapitalQ" name="diaPagoCapital3" value="Q"  disabled="disabled" readonly="readonly" />
								<label for="diaPagoCapitalQ">Quincena</label>
							</div>
							<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8"  />
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label id="labelDiaInteres">D&iacute;a del mes: </label>
						</td>
			 			<td>
			 				<form:input id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="6"  readonly="true" disabled="true"/>
				 			<input type="text" id="diaDosQuincInt" name="diaDosQuincInt" size="8"  disabled="true" readonly="true" style="display: ;" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label id="labelDiaCapital">D&iacute;a del mes: </label>
						</td>
			 			<td>
			 				<form:input id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="6"  readonly="true" disabled="true"/>
				 			<input type="text" id="diaDosQuincCap" name="diaDosQuincCap" size="8"  disabled="true" readonly="true" style="display: ;" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="numAmort">N&uacute;mero de Cuotas:</label>
						</td>
						<td >
							<form:input id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="numAmort">N&uacute;mero de Cuotas:</label>
						</td>
						<td >
							<form:input id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8"  disabled="true"/>
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
						<td>
			 				<input type="hidden" id="montosCapital" name="montosCapital" size="100"readonly="true" disabled="true"/>
						</td>
					</tr>
			   </table>
			   </fieldset>
			<table>
			   	<tr>
						<td>
						 	<form:input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5"  disabled ="true" type="hidden" value="0"/>
						</td>
						<td class="label">
							<label for="lblMontoCuota">Monto Cuota:</label>
						</td>
						<td>
							<form:input id="montoCuota" name="montoCuota" path="montoCuota" size="18"  disabled ="true"
								esMoneda="true" style="text-align: right;"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CAT">CAT:</label>
						</td>
					   <td>
						 	<form:input id="cat" name="cat" path="cat" size="8"  disabled ="true" style="text-align: right;"/>
						 	 <label for="lblPorc"> %</label>
						</td>
				</tr>
			</table>
		</fieldset>

	<div id="gridAmortizacion" style="display: none;">  </div>
	<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
		<br>

	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td colspan="4" style="text-align: right;" border='0'>
				<input type="submit" id="generarCuentaClabe" name="generarCuentaClabe" class="submit" value="Generar Cuenta Clabe" style="float:right;" />
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
				<button type="button" class="submit" id="simular" style="display: none;"> Simular </button>

					<button type="button" class="submit" id="exportarPDF" style="">Imprimir Pagar&eacute; </button>


	            	<button type="button" class="submit" id="ExptablaAmorti" style="">Tabla de Amortizaci&oacute;n</button>


	            	<button type="button" class="submit" id="caratula" style="">Car&aacute;tula</button>


	            	<button type="button" class="submit" id="ExportExcel" style="">Exportar</button>

				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="reca" name="reca"/>
				<input type="hidden" id="simuladoNuevamente" name="simuladoNuevamente" value="N"/>
				<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" />
				<input type="hidden" id="numClienteEspec" name="numClienteEspec" />
				<input type="hidden" id="participaSPEI" name="participaSPEI" />
				<input type="hidden" id="institucionBanorte" name="institucionBanorte" />
				<input type="hidden" id="referenciaBanorte" name="referenciaBanorte" />
				<input type="hidden" id="institucionTelecom" name="institucionTelecom" />
				<input type="hidden" id="referenciaTelecom" name="referenciaTelecom" />
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
<html>
