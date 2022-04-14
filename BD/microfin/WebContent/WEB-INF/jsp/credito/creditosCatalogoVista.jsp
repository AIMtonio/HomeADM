<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
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
		<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/seguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/serviciosAdicionalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/serviciosSolCredServicio.js"></script>
		<script type="text/javascript" src="js/credito/credito.js"></script>
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
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Cr&eacute;dito</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
				<label for="credito">N&uacute;mero: </label>
			</td>
			<td>
				<form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="12" tabindex="1"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="tipo">Solicitud: </label>
			</td>
		   	<td>
			 	<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID"
			 		size="10" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
			</td>
			<td nowrap="nowrap">
				<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="3"/>
				<input type="text" id="nombreCliente" name="nombreCliente" tabindex="4" disabled="true" size="40"/>
			</td>
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				 <label for="lineaCred">L&iacute;nea de Cr&eacute;dito: </label>
			</td>
			<td>
			 	<form:input type="text" id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="5" />
			 	<form:input type="hidden" id="comAnualLin" name="comAnualLin" path="comAnualLin" />
			</td>
		</tr>
		<tr id="datosNomina">
			<td id="lblnomina" class="label" nowrap="nowrap">
				<label for="lblCalif">Empresa N&oacute;mina: </label>
			</td>
			<td id="institNominaID" nowrap="nowrap">
				<input type="text" id="institucionNominaID" name="institucionNominaID"  size="11" disabled="disabled"/>
				<input type="text" id="nombreInstit" name="nombreInstit"  disabled="disabled" size="40" />
			</td>
			<td class="separador"></td>
			<td id="lblnomina" class="label" nowrap="nowrap">
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
			<td class="label" nowrap="nowrap">
			 	<label for="lineaCred">Producto de Cr&eacute;dito: </label>
			</td>
			<td>
				<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="5" disabled="true"/>
			 	<input type="text" id="nombreProd" name="nombreProd" disabled="true" size="45" />
			</td>
			<td class="separador"></td>
			<td class="label" style="display: none;">
			 	<label for="lineaCred" type="">Clasificaci&oacute;n: </label>
			</td>
		   	<td style="display: none;">
			 	<input type="hidden" id="clasificacion" name="clasificacion" size="7" disabled="true"/>
				<input type="hidden" id="DescripClasific" name="DescripClasific" size="35" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
			 	<label for="Cuenta">Cuenta: </label>
			</td>
			<td>
		   		<form:input type="text" id="cuentaID" name="cuentaID" path="cuentaID" size="15" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="saldo">Saldo de L&iacute;nea: </label>
			</td>
		   	<td>
			 	<input type= "text" id="saldoLineaCred" name="saldoLineaCred" size="15" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="Relacionado">Relacionado: </label>
			</td>
		  	<td>
			 	<form:input type="text" id="relacionado" name="relacionado" path="relacionado" size="15" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Estatus">Estatus:</label>
			</td>
		   	<td>
		   		<form:select id="estatus" name="estatus" path="estatus"   disabled="true">
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
		<tr>
			<td class="label">
				<label for="lblDestino">Destino: </label>
			</td>
		    <td nowrap="nowrap">
			 	<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="10" />
			 	<input type="text" id="descripDestino" name="descripDestino"  disabled="true" size="40"  />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblDestinCredFR" >Destino Cr&eacute;dito FR: </label>
	     	</td>
	     	<td nowrap="nowrap">
				<input type="text" id="destinCredFRID" name="destinCredFRID"  size="10"   disabled= "true"  />
				<input type="text" id="descripDestinoFR" name="descripcionoDestinFR"size="40"
	         		readonly="true" disabled = "true" />
			</td>
		</tr>
		<tr>
	     	<td class="label">
				<label for="lblDestinCredFOMURID">Destino de Cr&eacute;dito FOMUR: </label>
	     	</td>
	     	<td>
				<input type="text" id="destinCredFOMURID" name="destinCredFOMURID"  size="10"  readonly="true" disabled = "true"  />
				<input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="40"
	         		readonly="true" disabled = "true" />
			</td>
			<td class="separador"></td>
			<td class="label">
		         <label for="lblClasificacion">Clasificaci&oacute;n: </label>
		     </td>

		    <td>
		    	<input type="radio" id="clasificacionDestin1" name="clasiDestinCred"  value="C" disabled = "true" readonly="true" />
					<label for="lblcomercial">Comercial</label>
				<input type="radio" id="clasificacionDestin2" name="clasiDestinCred"  value="O" disabled = "true" readonly="true" />
					<label for="lblConsumo">Consumo</label>
				<input type="radio" id="clasificacionDestin3" name="clasiDestinCred"  value="H" disabled = "true" readonly="true" />
					<label for="lblHipotecario">Vivienda</label>
				<input type="hidden" id="clasiDestinCred" name="clasiDestinCred" size="60" readonly="true" />

		    </td>
		</tr>
		<tr>
			<td class="label">
				<label for="calificaCredito">Calificaci&oacute;n: </label>
			</td>
			<td>
				<input type="text" id="calificaCredito" name="calificaCredito"   size="20" disabled="true" />
			</td>
			<td class="separador"></td>
			<td id= "prepagoslbl"class="label">
				<label for="tipoPrepago">Tipo Prepago Capital: </label>
			</td>

			<td id="prepagos">
		     		<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" >
		    	 		<form:option value="">SELECCIONAR</form:option>
		     			<form:option value="U">&Uacute;ltimas Cuotas</form:option>
			      		<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
						<form:option value="V">Prorrateo Cuotas Vigentes</form:option>
						<form:option value="P">Pago Cuotas Completas Proyectadas</form:option>
			      </form:select>
			 </td>
		</tr>
		<tr>
			<td class="label">
				<label for="calificaCredito">Tipo Cr&eacute;dito: </label>
			</td>
			<td>
				<input type="text" id="tipoCreditoDes" size="20" value="NUEVO" disabled="true"/>
				<input type="hidden" id="tipoCredito"  name="tipoCredito"/>
			</td>
			<td class="separador"></td>
			<td class="label">
         		<label for="lblTipoConsultaSIC">Tipo Consulta SIC: </label>
     		</td>
    	 	<td>
		    	<input type="radio" id="tipoConsultaSICBuro" name="tipoConSIC"  value="B" />
					<label for="lblcomercial">Buró Crédito</label>
				<input type="radio" id="tipoConsultaSICCirculo" name="tipoConSIC"  value="C" />
					<label for="lblConsumo">Círculo Crédito</label>
		   		<input type="hidden" id="tipoConsultaSIC" name="tipoConsultaSIC" size="20"/>
    		</td>
		</tr>
		<tr id="consultaBuro">
			<td >
				<label for="lbconsultaSICB">Folio Consulta Buró:</label>
			</td>
			<td>
				<input type="text" id="folioConsultaBC" name="folioConsultaBC" path="folioConsultaBC" size="15" maxlength="30" />
			</td>
		</tr>
		<tr id="consultaCirculo">
			<td >
				<label for="lbconsultaSICC">Folio Consulta Círculo:</label>
			</td>
			<td>
				<input type="text" id="folioConsultaCC" name="folioConsultaCC" path="folioConsultaCC" size="15"  maxlength="30" />
			</td>
			<td class="separador"></td>
		</tr>
		<tr>
			<td class="label">
				<label for="referenciaPago">Referencia: </label>
			</td>
			<td>
				<input type="text" id="referenciaPago" name="referenciaPago" path="referenciaPago" maxlength="20" onblur="ponerMayusculas(this);" onkeypress="return validaLetraNum(event)" size="25">
			</td>
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Condiciones</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
				<label for="montoCredito">Monto: </label>
			</td>
			<td>
				<form:input type="text" id="montoCredito" name="montoCredito" path="montoCredito" size="18"
				 	esMoneda="true" tabindex="29"  style="text-align: right" onfocus="validaFocoInputMoneda(this.id);"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Moneda">Moneda: </label>
			</td>
			<td>
				<form:select id="monedaID" name="monedaID" path="monedaID" disabled="true" >
					<form:option value="">SELECCIONAR</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
     		<td class="label">
         		<label for="fechaInicioCredito">Fecha de Inicio: </label>
     		</td>
     		<td>
         		<form:input type="text" id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio" readOnly="true"  />
     		</td>
     		<td class="separador"></td>
     		<td class="label">
         		<label for="fechaInicio">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
     		</td>
     		<td>
         		<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="18" readOnly="true" disabled="disabled" path="fechaInicioAmor" />
     		</td>
     	</tr>
     	<tr>
 			<td class="label">
		   		<label for="lblPlazo">Plazo: </label>
		   	</td>
		   	<td>
         		<form:select  id="plazoID" name="plazoID" path="plazoID"  >
		        	<form:option value="0">SELECCIONAR</form:option>
			   	</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
         		<label for="lblAutorizado">Fecha de Vencimiento: </label>
     		</td>
     		<td>
         		<form:input type="text" id="fechaVencimien" name="fechaVencimien" size="18" path="fechaVencimien"
         			readOnly = "true"  disabled="disabled"  />
     		</td>
     	</tr>
     	<tr>

     		<td class="label">
				<label for="FactorMora">Factor Mora: </label>
			</td>
   			<td >
	 			<input type="text" id="factorMora" name="factorMora" path="factorMora" size="15" readOnly="true"  disabled="disabled"  esTasa="true" />
					<label id="lblveces" for="lblveces">veces la tasa de inter&eacute;s ordinaria</label>
	 				<label id="lblTasaFija" for="lblTasaFija">Tasa Fija Anualizada</label>
			</td>
     	</tr>
		<tr>
			<td class="label">
			<label for="comision">Tipo de Dispersi&oacute;n </label>
			</td>
		    <td>
		    	<select  id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" >
					<option value="">SELECCIONAR</option>
				</select>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="cuentaCLABE">Cuenta CLABE: </label>
			</td>
		    <td>
		    	<form:input  id="cuentaCLABE" name="cuentaCLABE" path="cuentaCLABE"  nummax="18" type="text" disabled="disabled" value=""
		    		 size="24"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="comision">Forma de Cobro x Apertura: </label>
			</td>
		    <td>
		    	<form:input  id="formaComApertura" name="formaComApertura" path="formaComApertura"  disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="comision">Comisi&oacute;n por Apertura: </label>
			</td>
		    <td>
			 	<form:input type="text" id="montoComision" name="montoComision" path="montoComision" size="15"
			 		esMoneda="true" tabindex="37" disabled="true" style="text-align: right"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="Moneda">IVA Comisi&oacute;n: </label>
			</td>
			<td>
				<form:input type="text" id="IVAComApertura" name="IVAComApertura" path="IVAComApertura"
					 esMoneda="true" disabled="true" size="12" style="text-align: right"/>
				<input type="hidden" id="pagaIVACte" name="pagaIVACte"  disabled="true" size="5" />
				<input type="hidden" id="sucursalCte" name="sucursalCte"  disabled="true" size="5"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="fechaCobroComision">Fecha Cobro Comisión: </label>
			</td>
			<td>
				<form:input type="text" id="fechaCobroComision" name="fechaCobroComision" size="18" readOnly="true" disabled="true" path="fechaCobroComision" />
			</td>
		</tr>

		<tr>
			<td class="label">
				<label for="comision">Garant&iacute;a Liquida: </label>
			</td>
		    <td>
			 	<form:input type="text" id="porcGarLiq" name="porcGarLiq" path="porcGarLiq" size="6"
			 	 disabled="true" style="text-align: right" />
			 	<label for="lblAporte">% &nbsp;</label>
				<form:input type="text" id="aporteCliente" name="aporteCliente" path="aporteCliente"
					 esMoneda="true" disabled="true" size="12" style="text-align: right"/>
			</td>
		</tr>
		<tr id = "garantiaFinanciada" style="display: none;">
			<td>
				<label for="lblModalidadFOGAFI">Modalidad Garant&iacute;a Financiada:  </label>
	    	</td>
	     	<td>
	     			<form:select id="modalidadFOGAFI" name="modalidadFOGAFI"   path="modalidadFOGAFI"   readonly="true" disabled="true">
						<form:option value="" >SELECCIONAR</form:option>
						<form:option value="A">ANTICIPADO </form:option>
						<form:option value="P">PERI&Oacute;DICO</form:option>
					</form:select>
			</td>
			<td class="separador"></td>
			<td>
				<label for="lblporcentajeFOGAFI">Garant&iacute;a Financiada:  </label>
	    	</td>
	     	<td>
	     		<form:input type="text" id="porcentajeFOGAFI" name="porcentajeFOGAFI" path="porcentajeFOGAFI" size="6" style="text-align: right;"
	 			 readOnly="true"  disabled="true"  />
	 			<label for="lblMontoFOGAFI">% &nbsp;</label>
	     		<form:input type="text" id="montoFOGAFI" name="montoFOGAFI" path="montoFOGAFI" esMoneda="true"
	     			size="15"  readOnly="true" disabled="true"  style="text-align: right;"/>
			</td>
		</tr>

		<tr>
			<td>
				<label class="fechaLimiteEnvio" class="fechaLimiteEnvio">Fecha limite de envio de instalaci&oacute;n:  </label>
			</td>
				<td >
					<input type="text" id="fechaLimEnvIns" name="fechaLimEnvIns" size="10" disabled="true" class="fechaLimiteEnvio"/>
			</td>
			<td class="separador"></td>
			<td class="label ClabeDomiciliacion">
				<label>Cta. Clabe Domiciliaci&oacute;n:</label>
			</td>
			<td class="ClabeDomiciliacion">
				<input type="text" id="clabeDomiciliacion" name="clabeDomiciliacion" size="24" maxlength="18" autocomplete="off" disabled="true"/>
			</td>

		</tr>

		</table>

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

		<!-- Inicio Servicios Adicionales -->
		<div id="fieldServicioAdic">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Servicios Adicionales</legend>
				<table table border="0" width="100%">
					<tr id="divServiciosAdic">

					</tr>
				</table>
				<input type="hidden" id="serviciosAdicionales" name="serviciosAdicionales" value="">
				<input type="hidden" id="aplicaDescServicio" name="aplicaDescServicio" value="N">
			</fieldset>
		</div>
		<!-- Fin Servicios Adicionales -->

			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Seguro de Vida</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
			<td class="label">
				<label for="seguroVid">Seguro de Vida</label>
			</td>
			<td>
				<form:radiobutton id="reqSeguroVidaSi" name="reqSeguroVidaSi" path="reqSeguroVida" disabled="true" value="S" />
				<label for="si">Si</label>
				<form:radiobutton id="reqSeguroVidaNo" name="reqSeguroVidaNo" path="reqSeguroVida" disabled="true" value="N"/>
				<label for="si">No</label>
				<form:input type="hidden" id="reqSeguroVida" name="reqSeguroVida" path="reqSeguroVida" size="10" />
				<input type="hidden" id="seguroVidaID" name="seguroVidaID"  size="10" />
		    </td>
		</tr>
		<tr id="trMontoSeguroVida">

			<td class="label">
			<label for="montoSeguroVida">Monto Seguro Vida</label>
			</td>
			<td>
				<form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" esMoneda="true" disabled="true" size="12" style="text-align: right"
					 />
				<form:input type="hidden" id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" seisDecimales="true"
							size="12"  tabindex="49" />
			</td>


		<td class="separador"></td>

			<td class="label">
			<label id="ltipoPago" for="Moneda">Tipo de Pago:</label>
			</td>
			<td>
		    	<input type="text" id="tipoPagoSeguro" name="tipoPagoSeguro"  disabled="true" >
				<form:input type="hidden" id="forCobroSegVida" name="forCobroSegVida" path="forCobroSegVida" />
				<form:input type="hidden" id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida" />
				<form:input type="hidden" id="descuentoSeguro" name="descuentoSeguro" path="descuentoSeguro" />
				<input type="hidden" id="noDias" name="noDias" path="noDias" />
				<input type="hidden" id="montoSegOriginal" name="montoSegOriginal" path="montoSegOriginal" esMoneda="true" />
				<input type="hidden" id="esquemaSeguroID" name="esquemaSeguroID" />
			</td>

		</tr>


		<tr id="tipoPagoSelect">

			<td></td>
			<td></td>

			<td class="separador"></td>

			<td class="label">
					<label for="Moneda">Tipo de Pago:</label>
				</td>

				<td>
					<select id="tipPago" name="tipPago"  >
						<option value="">SELECCIONAR</option>
					</select>

				</td>
		</tr>


		<tr id="trBeneficiario">
			<td class="label">
			<label for="beneficiar">Beneficiario:</label>
			</td>
			<td>
			<form:input type="text" id="beneficiario" name="beneficiario" path="beneficiario"  size="42"  onblur=" ponerMayusculas(this)"/>
			</td>
			<td class="separador"></td>
			<td>
			<label for="beneficiar">Parentesco:</label>
			</td>
			<td>
			<form:input type="text" id="parentescoID" name="parentescoID" path="parentescoID"  size="5" />
			<input id="parentesco" name="parentesco" size="30" type="text" readonly="true" disabled="true" />
			</td>
		</tr>
		<tr id="trParentesco">
			<td class="label">
			<label for="direccBen">Direcci&oacute;n:</label>
			</td>
			<td>
		    <textarea id="direccionBen" name="direccionBen" size="45" COLS="38" ROWS="2"  onblur=" ponerMayusculas(this)"></textarea>
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
			<label for="calcInter"> Ciclo <s:message code="safilocale.cliente"/>: </label>
		</td>
		<td>
			<input type="text" id="cicloCliente" name="cicloCliente" disabled="true" size="6"  >
		</td>
		<td class="separador"></td>
			<td class="label" style="display: none;" id="lbciclos" >
			<label for="calcInter" > Ciclo Grupal</label>
		</td>
		<td style="display: none;" id="lbcicloscaja" >
			<input type="text" id="cicloClienteGrupal" name="cicloClienteGrupal" disabled="true" size="6"  >
			<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal" size="6"  />
			<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" size="6"  />
		</td>
		</tr>
		<tr>
			<td class="label">
			<label for="calcInter">Tipo Cal. Inter&eacute;s : </label>
			</td>
		   <td>
		   	<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres"  disabled = "true">
				<form:option value="">SELECCIONAR</form:option>
				<form:option value="1">SALDOS INSOLUTOS</form:option>
				<form:option value="2">MONTO ORIGINAL</form:option>
				</form:select>
			</td>
			<td class="separador"></td>

			<td class="label">
			<label for="calcInter">C&aacute;lculo de Inter&eacute;s  : </label>
			</td>
		   <td>
		   	<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID"  disabled = "true">
				<form:option value="">SELECCIONAR</form:option>
			</form:select>
			</td>

		</tr>

		<tr>
			<td class="label">
			<label for="TasaBase">Tasa Base: </label>
			</td>
		   <td>
			 	<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="5" disabled="true"  />
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="25"
				       readonly="true" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="tasaFija">Tasa Fija Anualizada: </label>
			</td>
		   <td >
			 	<form:input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8"
			 		esTasa="true" disabled="true" style="text-align: right"/>
			 	<label for="porcentaje">%</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="SobreTasa">Sobre Tasa: </label>
			</td>
		   <td>
			 	<form:input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8"
			 	esTasa="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="PisoTasa">Piso Tasa: </label>
			</td>
		   <td >
			 	<form:input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8"
			 	style="text-align: right;" esTasa="true"  disabled="true" />
			 	<label for="porcentaje">%</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="TechoTasa">Techo Tasa: </label>
			</td>
		   	<td>
				<form:input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8"
			 	style="text-align: right;" esTasa="true"  disabled="true"/>
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
				<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label>
			</td>
			<td class="label">
				<input type="radio" id="fechaInhabil1" name="fechaInhabil1" value="S" />
				<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
				<input type="radio" id="fechaInhabil2" name="fechaInhabil2" value="A" />
				<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
				<form:input type="hidden" id="fechaInhabil" name="fechaInhabil" path="fechaInhabil" size="15" readonly="true"/>
			</td>
		</tr>

		<tr>
			<td class="label">
				<label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label>
				</td>
			<td class="label">
				<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" /><label for="Si">Si</label>&nbsp;
				<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N"  /><label for="No">No</label>
				<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15"  readonly="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck"  value="S"  />
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
				<input type="radio" id="ajusFecUlVenAmo1" name="ajusFecUlVenAmo1" value="S"  /><label for="lblajFecUlAmoVen">Si</label>&nbsp;
				<input type="radio" id="ajusFecUlVenAmo2" name="ajusFecUlVenAmo2" value="N"  /><label for="no">No</label>
				<form:input type="hidden" id="ajusFecUlVenAmo" name="ajusFecUlVenAmo" path="ajusFecUlVenAmo" size="15" readonly="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="TipoPagCap">Tipo de Pago de Capital: </label>
			</td>
			<td>
				<select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" >
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
							<label for="FrecuenciaInter">Frecuencia: </label>
						</td>
						<td>
				         <select  id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" >
						       <option value="">SELECCIONAR</option>
							</select>
					 	</td>

						<td class="separador"></td>
						<td class="label">
							<label for="FrecuenciaCap">Frecuencia: </label>
						</td>
						<td>
				         	<select  id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" >
						       <option value="">SELECCIONAR</option>
							</select>
					 	</td>
					</tr>
					<tr>
						<td class="label">
							<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label>
						</td>
		  				<td>
			 				<form:input  type="text" id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8"
			 					disabled = "true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="PeriodicidadCap">Periodicidad de Capital:</label>
						</td>
		   			<td>
			 				<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8"
			 				disabled="true" />
						</td>

					</tr>
					<tr>
							<td class="label">
								<label for="DiaPago">D&iacute;a Pago: </label>
							</td>
							<td nowrap="nowrap">
								<div id="divDiaPagoIntMes">
									<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F"  />
									<label for="diaPagoInteres1">&Uacute;ltimo d&iacute;a del mes</label>
									<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A"  />
									<label for="diaPagoInteres2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
								</div>
								<div id="divDiaPagoIntQuinc" style="display: none;" >
									<input type="radio" id="diaPagoInteresD" name="diaPagoInteres3" value="D" />
									<label for="diaPagoInteresD">D&iacute;a Quincena</label>
									<input type="radio" id="diaPagoInteresQ" name="diaPagoInteres3" value="Q" />
									<label for="diaPagoInteresQ">Quincena</label>
								</div>
								<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8"
									value ="F" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="DiaPago">D&iacute;a Pago: </label>
						 	</td>
						 	<td nowrap="nowrap">
								<div id="divDiaPagoCapMes">
									<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" />
									<label for="diaPagoCapital1">&Uacute;ltimo d&iacute;a del mes</label>&nbsp;
									<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" />
									<label for="diaPagoCapital2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
								</div>
								<div id="divDiaPagoCapQuinc" style="display: none;" >
									<input type="radio" id="diaPagoCapitalD" name="diaPagoCapital3" value="D" />
									<label for="diaPagoCapitalD">D&iacute;a Quincena</label>
									<input type="radio" id="diaPagoCapitalQ" name="diaPagoCapital3" value="Q" />
									<label for="diaPagoCapitalQ">Quincena</label>
								</div>
								<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" />
								<input type="hidden" id="diaPagoProd" name="diaPagoProd" size="8" />
							</td>

					</tr>

					<tr>
						<td class="label">
							<label id="labelDiaInteres">D&iacute;a del mes: </label>
						</td>
			 			<td>
			 				<form:input type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8" disabled="true"/>
				 			<input type="text" id="diaDosQuincInt" name="diaDosQuincInt" size="8" disabled="true" readonly="true" style="display: ;" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label id="labelDiaCapital">D&iacute;a del mes: </label>
						</td>
			 			<td>
			 				<form:input type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8" disabled="true"/>
				 			<input type="text" id="diaDosQuincCap" name="diaDosQuincCap" size="8" disabled="true" readonly="true" style="display: ;" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="numAmort">N&uacute;mero de Cuotas:</label>
						</td>
						<td >
							<form:input type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="numAmort">N&uacute;mero de Cuotas:</label>
						</td>
						<td >
							<form:input type="text" id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8"  disabled="true"/>
						</td>

					</tr>
					<tr>
						<td class="label">
							<label for="lblMontoCuota">Monto Cuota:</label>
						</td>
						<td>
							<form:input id="montoCuota" name="montoCuota" path="montoCuota" size="18" disabled ="true" esMoneda="true"
										style="text-align: right"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="CAT">CAT:</label>
						</td>
					   <td>
						 	<form:input id="cat" name="cat" path="cat" size="8"  disabled ="true"/>
						 	 <label for="lblPorc"> %</label>
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
						 	 	disabled = "true" value="0"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="button" id="simular" name="simular" class="submit"
		 					value="Simular" />
						</td>
					</tr>

			</table>
		</fieldset>
	</fieldset>
	<div id="contenedorSimulador" style="display: none;"></div>
	<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Origen Recursos</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="FactorMora">Tipo de Fondeo: </label>
			</td>
			<td>
				<input type="radio" id="tipoFondeo" name="tipoFondeo" path="tipoFondeo" value="P"  checked="checked"  />
				<label for="recProp">Recursos Propios</label>
				<input type="radio"  id="tipoFondeo2" name="tipoFondeo" path="tipoFondeo" value="F" />
				<label for="insFondeo">Inst. Fondeo</label>
			</td>
			<td class="separador"></td>
			<td class="label">
		    	<label for="lblInstitucion">Inst. Fondeo: </label>
			</td>
			<td>
				<form:input id="institFondeoID" name="institFondeoID" path="institFondeoID" size="12"  disabled="true"/>
		     	<input type="text" id="descripFondeo" name="descripFondeo" size="45"  disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
		     	<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
		     </td>
		     <td>
				<form:input id="lineaFondeo" name="lineaFondeo" path="lineaFondeo" size="12" disabled="true" />
		     	<input type="text" id="descripLineaFon" name="descripLineaFon" size="45" disabled="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
		    	<label for="lblSaldoLinea">Saldo de la L&iacute;nea: </label>
			</td>
			<td>
				<input type="text" id="saldoLineaFon" name="saldoLineaFon" size="12" disabled="true" esMoneda="true"
					style="text-align: right"/>
			</td>
		</tr>
		<tr>
			<td class="label">
	         	<label for="lblTasaPasiva">Tasa Pasiva: </label>
	     	</td>
     		<td>
				<input type="text" id="tasaPasiva" name="tasaPasiva" size="12"  disabled="true" esTasa="true" style="text-align: right"/>
			</td>
			<td class="separador"></td>
			<td class="label">
     			<label for="lblTasaPasiva">Folio Fondeo: </label>
 			</td>
 			<td>
				<input type="text" id="folioFondeo" name="folioFondeo" size="30"  readOnly="true" disabled="disabled"/>
			</td>
		</tr>
	</table>
	</fieldset>
<br>
<br>
 <div id="divComentarios" style="display: none;">
			 <fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend>Comentarios</legend>
				<table >
					<tr>
		     			<td class="label" >
							<label for="lblComentario">Comentarios: </label>
						</td>
		     			<td>
		      				<form:textarea  id="comentarioAlt" name="comentarioAlt" path="comentarioAlt"  COLS="50" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="false" maxlength="500" />
		     			</td>

					</tr>
				</table>
			 </fieldset>
			 </div>

	<table style="text-align: right;width: 100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" />
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="calificaCliente" name="calificaCliente"  path="calificaCliente"/>
				<input type="hidden" id="pantalla"  name="pantalla"/>
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