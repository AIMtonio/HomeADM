<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nominaEmpleadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	  	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	  	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/seguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calculosyOperacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/relacionClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nivelCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
		<script type="text/javascript" src="dwr/interface/invGarantiaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaTasasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/serviciosAdicionalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/serviciosSolCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esqComAperNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/comApertConvenioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/condicionProductoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
		

		<script type="text/javascript" src="js/utileria.js"></script>
      <script type="text/javascript" src="js/originacion/solicitudCredito.js"></script>
	</head>
	<script language="javascript">
		$(document).ready(function() {
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
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCreditoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Cr&eacute;dito</legend>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<table border="0"  width="100%">
				<tr>
					<td class="label" nowrap="nowrap">
			        	<label for="lblsolicitud">Solicitud de Cr&eacute;dito: </label>
					</td>
					<td>
						<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" tabindex="1"
							autocomplete="false"/>
					</td>
					<td class="separador"></td>
					<td class="label">
			        	<label for="lblProspecto">Prospecto: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="12" tabindex="2" />
			         	<input type="text" id="nombreProspecto" name="nombreProspecto"size="50" readonly="true" disabled="disabled"/>
			     	</td>
				</tr>
				<tr>
					<td>
						<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
			     	</td>
			     	<td nowrap="nowrap">
			        	<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="4" />
			        	<input type="text" id="nombreCte" name="nombreCte"size="50" readonly="true"  disabled="disabled"/>
			        	</td>
			        	<td></td>
			     	<td class="label" nowrap="nowrap">
						<label for="lblProducto">Producto de Cr&eacute;dito: </label>
					</td>
					<td>
			        	<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12"
			         			tabindex="6"/>
			         	<input type="text" id="descripProducto" name="descripProducto"size="50" readonly="true"  disabled="disabled"/>
			     	</td>
				</tr>
			    <tr>
			    	<td class="label">
			        	<label for="lblfecRegistro">Fecha de Registro: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" readOnly = "true"  disabled="disabled"/>
			     	</td>
			     	<td class="separador"></td>
			     	<td class="label">
			        	<label for="lblPromotor">Promotor: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="promotorID" name="promotorID" path="promotorID" size="12"	tabindex="9"  />
			     		<input type="text" id="nombrePromotor" name="nombrePromotor"size="50"  readonly="true"   disabled="disabled"/>
			       	</td>
				</tr>
				<tr>
					<td class="label">
			        	<label for="lblMoneda">Moneda: </label>
			     	</td>
			     	<td >
				 		<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="11" disabled="true" >
						<form:option value="">SELECCIONAR</form:option>
						<form:option value="1">PESOS</form:option>
						</form:select>
					</td>
				    <td class="separador"></td>
				    <td>
						<label for="lblEstatus">Estatus: </label>
			     	</td>
			     	<td>
			     		<form:select id="estatus" name="estatus" path="estatus"  tabindex="12" disabled= "true">
				     		<form:option value="I">INACTIVO</form:option>
							<form:option value="A">AUTORIZADO</form:option>
							<form:option value="C">CANCELADO</form:option>
							<form:option value="R">RECHAZADO</form:option>
							<form:option value="D">DESEMBOLSADO</form:option>
							<form:option value="L">LIBERADA</form:option>
						</form:select>
					</td>
			 	</tr>
			 	<tr>
					<td>
						<label for="lblSucursal">Sucursal: </label>
			     	</td>
			     	<td>
						<input type="text" id="sucursalCte" name="sucursalCte"  size="12" readOnly= "true"  disabled="disabled" tabindex="13"/>
						<input type="text" id="nombreSucursal" name="nombreSucursal"size="50" readonly="true"  disabled="disabled"/>
					</td>
			     	<td class="separador"></td>
			     	<td>
						<label for="lblDestino">Destino Cr&eacute;dito: </label>
			     	</td>
			     	<td nowrap="nowrap">
						<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="12" tabindex="15"  />
						<input type="text" id="descripDestino" name="descripDestino" size="50" readonly="true"   disabled="disabled"/>
					</td>
			 	</tr>
			 	<tr>
					<td>
						<label for="lblDestinCredFR">Destino Cr&eacute;dito FR: </label>
			     	</td>
			     	<td>
						<input type="text" id="destinCredFRID" name="destinCredFRID"  size="12"  readOnly= "true"   disabled="disabled"/>
						<input type="text" id="descripDestinoFR" name="descripcionoDestinFR" size="50"
			         		readonly="true"  disabled="disabled"/>
					</td>
			     	<td class="separador"></td>
			     	<td  nowrap="nowrap">
						<label for="lblDestinCredFOMURID">Destino Cr&eacute;dito FOMUR: </label>
			     	</td>
			     	<td>
						<input type="text" id="destinCredFOMURID" name="destinCredFOMURID"  size="12"  readonly="true"    disabled="disabled"/>
						<input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="50" readonly="true"    disabled="disabled"/>
					</td>
			 	</tr>
			 	<tr>
		     		<td class="label">
		         		<label for="lblClasificacion">Clasificaci&oacute;n: </label>
		     		</td>
		    	 	<td>
				    	<input type="radio" id="clasificacionDestin1" name="clasifiDestinCred1"  value="C"  readonly="true"  disabled = "true" />
							<label for="lblcomercial">Comercial</label>
						<input type="radio" id="clasificacionDestin2" name="clasifiDestinCred1"  value="O"  readonly="true"  disabled = "true"/>
							<label for="lblConsumo">Consumo</label>
						<input type="radio" id="clasificacionDestin3" name="clasifiDestinCred1"  value="H"  readonly="true"  disabled = "true"/>
							<label for="lblHipotecario">Vivienda</label>
				   		<input type="hidden" id="clasifiDestinCred" name="clasifiDestinCred" size="50"    tabindex="21" />

		    		</td>
		    		<td class="separador"></td>
		    		<td class="label">
		        		<label for="lblProyecto">Proyecto: </label>
			     	</td>
			     	<td>
				 		<textarea id="proyecto" name="proyecto" path="proyecto" tabindex="20" cols="40" rows="2" onBlur=" ponerMayusculas(this);"
				 			maxlength="500"  tabindex="22" ></textarea>
					</td>

			 	</tr>
			 	<tr>
					<td class="label">
						<label for="calcInter"> Ciclo <s:message code="safilocale.cliente"/>: </label>
					</td>
					<td>
						<form:input type="text" id="numCreditos" name="numCreditos" path="numCreditos" size="15" readOnly="true"  disabled="disabled"/>
					</td>
					<td class="separador"></td>
					<td class="label" id="lbciclos" >
						<label for="calcInter" >Ciclo Promedio Grupal:</label>
					</td>
					<td  id="lbcicloscaja" >
						<input type="text" id="cicloClienteGrupal" name="cicloClienteGrupal" readOnly="true"  disabled="disabled" size="15"   >
						<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal" size="6"/>
						<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" size="6" />
					</td>
				</tr>
				<tr>
		    		<td class="label">
		        		<label for="lblCalif">Calificaci&oacute;n: </label>
			     	</td>
			     	<td>
				 		<input type="text" id="calificaCredito" name="calificaCredito"  size="15" readOnly="true"  disabled="disabled"/>
					</td>

					<td>
					</td>
					<td id="lblnomina" class="label" nowrap="nowrap">
						<label for="lblCalif">Empresa N&oacute;mina: </label>
					</td>
					<td id="institNominaID" nowrap="nowrap">
						<form:input type="text" id="institucionNominaID" name="institucionNominaID"  path="institucionNominaID" size="11"   tabindex="21"/>
						<input type="text" id="nombreInstit" name="nombreInstit"  path="nombreInstit" readonly="true"  disabled="disabled" size="50" />
					</td>
				</tr>
				<tr>
					<td id="lblFolioCtrl">
						<label for="lblFolioCtrlInt">N&uacute;mero Empleado:</label>
					</td>
					<td id="folioCtrlCaja" >
						<form:input type="text" id="folioCtrl" name="folioCtrl"  path="folioCtrl" size="15" maxlength="20" tabindex="22"/>
					</td>
					<td  id ="sep" class="separador"></td>
					<td id="lblHorarioVeri">
						<label for="lblHorarioVeri">Horario Verificaci&oacute;n:</label>
					</td>
					<td>
						<form:input type="text" id="horarioVeri" name="horarioVeri" path="horarioVeri" maxlength="20" size="15" tabindex="23" onblur=" ponerMayusculas(this)"/>
					</td>
				</tr>
				<tr>
					<td>
						<label for="horarioVeri">Tipo Cr&eacute;dito:</label>
					</td>
					<td>
						<input type="text" id="tipoSolCredito" name="tipoSolCredito" size="15" value="NUEVO" iniForma="false" disabled="true"/>
						<input type="hidden" id="tipoCredito" name="tipoCredito" value="N" iniForma="false"/>
					</td>
					<td class="separador"></td>
					<td class="label">
		         		<label for="lblTipoConsultaSIC">Tipo Consulta SIC: </label>
		     		</td>
		    	 	<td>
				    	<input type="radio" id="tipoConsultaSICBuro" name="tipoConSIC"  value="B" tabindex="24"  />
							<label for="lblcomercial">Buró Crédito</label>
						<input type="radio" id="tipoConsultaSICCirculo" name="tipoConSIC"  value="C" tabindex="25" />
							<label for="lblConsumo">Círculo Crédito</label>
				   		<input type="hidden" id="tipoConsultaSIC" name="tipoConsultaSIC" size="20"/>

		    		</td>
				</tr>
				<tr id="consultaBuro">
					<td >
						<label for="lbconsultaSICB">Folio Consulta Buró:</label>
					</td>
					<td>
						<input type="text" id="folioConsultaBC" name="folioConsultaBC" path="folioConsultaBC" size="15" tabindex="26" maxlength="30" />
					</td>
					<td class="separador"></td>
				</tr>
				<tr id="consultaCirculo">
					<td >
						<label for="lbconsultaSICC">Folio Consulta Círculo:</label>
					</td>
					<td>
						<input type="text" id="folioConsultaCC" name="folioConsultaCC" path="folioConsultaCC" size="15" tabindex="26" maxlength="30" />
					</td>
					<td class="separador"></td>
				</tr>

				<tr id="convenios">
					<td >
						<label for="lbconsultaSICB">Convenio:</label>
					</td>
					<td>
						<select id="convenioNominaID" name="convenioNominaID" value="0" tabindex="27"></select>
					</td>
					<td class="separador"></td>
					<td >
						<label for="noEmpleado" class="quinquenios">Quinquenio:</label>
					</td>
					<td >
						<select id="quinquenioID" name="quinquenioID" class="quinquenios" tabindex="28">
							<option value="">SELECCIONAR</option>
						</select>
					</td>
				</tr>

				<tr>
					<td>
						<label class="folioSolici">Folio:</label>
					</td>
					<td >
						<input id="folioSolici" name="folioSolici"  size="20" tabindex="29" maxlength="20" class="folioSolici"/>
					</td>

				</tr>


				</table>
			</fieldset>

			<div id="grupoDiv">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Grupos </legend>
					<table table border="0" width="100%">
						<tr>
				 			<td class="label">
								<label for="lblGrupo">Grupo: </label>
							</td>
							<td >
								<form:input type="text" id="grupoID" name="grupoID" path="grupoID"  size="10" tabindex="28" iniForma="false"  readonly="true"  disabled="disabled" />
								<input type="text" id="nombreGr" name="nombreGr"  size="40" tabindex="29"  disabled="true" />
							</td>
				     		<td class="separador"></td>
				     		<td class="label">
				         		<label for="lbl">Tipo Integrante: </label>
				     		</td>
				     		<td>
				     			<form:select id="tipoIntegrante" name="tipoIntegrante"   path="tipoIntegrante"   tabindex="30">
									<form:option value="" selected="true">SELECCIONA</form:option>
									<form:option value="1">PRESIDENTE </form:option>
									<form:option value="2" >TESORERO</form:option>
									<form:option value="3">SECRETARIO </form:option>
									<form:option value="4">INTEGRANTE</form:option>
								</form:select>
				     		</td>
				     	</tr>
				   	</table>
				</fieldset>
			</div>

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Condiciones</legend>
			 	<table table border="0" width="100%">
			 		<tr>
			 			<td class="label" id = "inversionLbl">
			         		<label id="lblInversionID" for="inversionID">Inversi&oacute;n: </label>
				     	</td>
			     		<td id = "inversionIn">
			         		<form:input type="text" id="inversionID" name="inversionID" autocomplete="off" path="inversionID" size="18" tabindex="31" />
			     		</td>
		 				<td class="label" id="cuentaAhorroLbl" >
		         			<label id="lblCuentaAhoID" for="cuentaAhoID">Ahorro: </label>
			     		</td>
				     	<td id="cuentaAhorro">

			         		<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" autocomplete="off" size="18" tabindex="31"/>
				     	</td>
			     		<td class="separador" id="separadorSol"></td>
			     		<td class="label" id="lblMontoMaximo">
			         		<label for="montoMaximo">Monto M&aacute;ximo: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="montoMaximo" name="montoMaximo" path="montoMaximo" size="18" esMoneda="true" readOnly="true" disabled="disabled"  style="text-align: right;" tabindex="32"/>
			     		</td>
			   		</tr>
			 		<tr>
			 			<td class="label">
			         		<label for="lblsolicitado">Monto Solicitado: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="montoSolici" name="montoSolici" path="montoSolici" size="18" tabindex="31"
			         			esMoneda="true"  style="text-align: right;"/>
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="lblAutorizado">Monto Autorizado: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="montoAutorizado" name="montoAutorizado" path="montoAutorizado" size="18"
			         			esMoneda="true" readOnly="true" disabled="disabled"  style="text-align: right;" tabindex="32"/>
			     		</td>
			   		</tr>
			     	<tr>
			     		<td class="label">
			         		<label for="fechaInicioCredito">Fecha de Inicio: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio" readOnly="true" tabindex="33" />
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="fechaInicio">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="18" readOnly="true" path="fechaInicioAmor" tabindex="34"/>
			     		</td>
			     	</tr>
			     	<tr>
			 			<td class="label">
					   		<label for="lblPlazo">Plazo: </label>
					   	</td>
					   	<td>
			         		<form:select  id="plazoID" name="plazoID" path="plazoID" tabindex="35" >
					        	<form:option value="0">SELECCIONAR</form:option>
						   	</form:select>
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="lblAutorizado">Fecha de Vencimiento: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" size="18" path="fechaVencimiento"
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
							<label for="formaCobro">Forma Cobro Com. por Apertura: </label>
						</td>
			   			<td>
							<input type="text"  id="formaComApertura" name="formaComApertura"
								readOnly="true"  disabled="disabled"  size="18"/>
							<form:input type="hidden"  id="forCobroComAper" name="forCobroComAper" path="forCobroComAper" readonly="true" disabled="disabled"
								 size="18" tabindex="36" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="comision">Comisi&oacute;n por apertura: </label>
						</td>
			    		<td>
				 			<form:input type="text" id="montoComApert" name="montoComApert" path="montoComApert" size="15" esMoneda="true"
				 				readOnly="true"  disabled="disabled"  style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="Moneda">IVA Comisi&oacute;n: </label>
						</td>
						<td>
							<form:input type="text" id="ivaComApert" name="ivaComApert" path="ivaComApert"
							 	esMoneda="true" readOnly="true"  disabled="disabled"  size="18" style="text-align: right;"/>
							<input type="hidden" id="pagaIVACte" name="pagaIVACte" tabindex="38" disabled="true" size="5" />
							<input type="hidden" id="sucursalID" name="sucursalID" tabindex="39" disabled="true" size="5"/><!--  XX.XX -->
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
							<label for="comision">Tipo de Dispersi&oacute;n: </label>
						</td>
					    <td>
					   		<select  id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="40"  >
								<option value="">SELECCIONAR</option>
							</select>
						</td>

						<td class="separador"></td>
						
						<td id="lblCuentaCLABE">
							<label for="lblSucursal">Cuenta CLABE: </label>
			     		</td>
			     		<td id="inputCuentaCLABE">
							<form:input type="text" id="cuentaCLABE" name="cuentaCLABE" path="cuentaCLABE" size="24" tabindex="44"  disabled="true" numMax="18"
								maxlength="18"/>
						</td>
					</tr>
					<tr id="dispSantander">
						<td class="label">
							<label>Tipo Cuenta: </label>
						</td>
						<td>
				    		<input type="radio" id="tipoSantander" name="tipoBanco"  value="A" tabindex="41" checked="checked"/>
								<label for="tipoSantander">Banco Santander</label>
							<input type="radio" id="tipoOtroBanco" name="tipoBanco"  value="O" tabindex="42" />
								<label for="tipoOtroBanco">Otros Bancos</label>
				   			<form:input type="hidden" id="tipoCtaSantander" name="tipoCtaSantander" path="tipoCtaSantander"/>

		    			</td>
		    			
		    			<td class="separador"></td>
		    			
						<td id="ctaSantanderTxt">
							<label for="ctaSantander">N&uacute;mero Cuenta:</label>
						</td>
						<td id="ctaClabeTxt">
							<label for="ctaClabe">Cuenta Clabe:</label>
						</td>
						<td id="ctaSantanderInput">
							<form:input type="text" id="ctaSantander" name="ctaSantander" path="ctaSantander" size="24" tabindex="43" numMax="18"
								maxlength="18"/>
						</td>
						<td id="ctaClabeInput" >
							<form:input type="text" id="ctaClabeDisp" name="ctaClabeDisp" path="ctaClabeDisp" size="24" tabindex="43" numMax="18"
								maxlength="18"/>
						</td>
						
						
					</tr>
					<tr>
						<td>
							<label for="lblAporte">Garant&iacute;a L&iacute;quida:  </label>
				    	</td>
				     	<td>
				     		<form:input type="text" id="porcGarLiq" name="porcGarLiq" path="porcGarLiq" size="6" style="text-align: right;"
				 			 readOnly="true"  disabled="disabled"  />
				 			<label for="lblAporte">% &nbsp;</label>
				     		<form:input type="text" id="aporteCliente" name="aporteCliente" path="aporteCliente" esMoneda="true"
				     			size="15"  readOnly="true" disabled="disabled"  style="text-align: right;"/>
				     		<input type="hidden" id="porcentaje" name="porcentaje" size="10" tabindex="45" />
				     		<form:input type="hidden" id="seguroVidaID" name="seguroVidaID" size="10" path="seguroVidaID" />
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
				     		<input type="hidden" id="valorPorcFOGAFI" name="valorPorcFOGAFI" size="10" tabindex="46" />
						</td>
					</tr>
					<tr>
						<td >
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
							<input type="text" id="clabeDomiciliacion" name="clabeDomiciliacion" size="24" maxlength="18" tabindex="58" autocomplete="off"/>
						</td>
					</tr>

				</table>
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

			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Seguro de Vida</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="seguroVid">Seguro de Vida:</label>
						</td>
						<td>
							<input type="radio" id="reqSeguroVidaSi" name="reqSeguroVidaSi" disabled="true" value="S" tabindex="45" />
							<label for="si">Si</label>
							<input type="radio" id="reqSeguroVidaNo" name="reqSeguroVidaNo" disabled="true" value="N" tabindex="46"/>
							<label for="si">No</label>
							<form:input type="hidden" id="reqSeguroVida" name="reqSeguroVida" path="reqSeguroVida" size="10" tabindex="47" />
			    		</td>


			  		  	<td class="separador"></td>


						<td class="label" id="tipoPagoSelect" >
							<label for="Moneda">Tipo de Pago:</label>
						</td>

						<td id="tipoPagoSelect2">
							<select id="tipPago" name="tipPago" tabindex="48" >
								<option value="">SELECCIONAR</option>
							</select>

						</td>

					</tr>
					<tr id="trMontoSeguroVida">
						<td class="label">
						<label for="montoSeguroVida">Monto Seguro Vida:</label>
						</td>
						<td>
							<form:input type="text" id="montoSeguroVida" name="montoSeguroVida" path="montoSeguroVida" esMoneda="true" disabled="true" size="12"
								style="text-align: right;" tabindex="52"/>
							<form:input type="hidden" id="factorRiesgoSeguro" name="factorRiesgoSeguro" path="factorRiesgoSeguro" seisDecimales="true"  size="12" tabindex="53"/>
						</td>

						<td class="separador"></td>

						<td class="label">
							<label id="ltipoPago" for="Moneda">Tipo de Pago:</label>
						</td>
						<td>
					    	<input type="text" id="tipoPagoSeguro" name="tipoPagoSeguro" tabindex="48" disabled="true"  >
							<form:input type="hidden" id="forCobroSegVida" name="forCobroSegVida" path="forCobroSegVida" tabindex="49"/>
							<form:input type="hidden" id="montoPolSegVida" name="montoPolSegVida" path="montoPolSegVida" tabindex="50"/>
							<form:input type="hidden" id="descuentoSeguro" name="descuentoSeguro" path="descuentoSeguro" tabindex="53"/>
							<input type="hidden" id="noDias" name="noDias" path="noDias" tabindex="51" >
							<input type="hidden" id="montoSegOriginal" name="montoSegOriginal" path="montoSegOriginal" esMoneda="true" >
							<input type="hidden" id="esquemaSeguroID" name="esquemaSeguroID" >
							<input type="hidden" id="auxTipPago" name="auxTipPago" >

						</td>

					</tr>
					<tr id = "complementoSeguroVida">
						<td class="label">
							<label for="cobertura">Cobertura:</label>
						</td>
						<td>
							<form:input type="text" id="cobertura" name="cobertura" path="cobertura" esMoneda="true" size="12" style="text-align: right;" tabindex="54"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="prima">Prima:</label>
						</td>
						<td>
							<form:input type="text" id="prima" name="prima" path="prima" esMoneda="true" size="12" style="text-align: right;" tabindex="55"/>
						</td>
					</tr>
					<tr id = "complementoSeguroVida2">
						<td class="label">
							<label for="vigencia">Vigencia:</label>
						</td>
						<td>
							<form:input type="text" id="vigencia" name="vigencia" path="vigencia" size="12" tabindex="56"/>
						</td>
					</tr>


					<tr id="trBeneficiario">
						<td class="label">
							<label for="beneficiar">Beneficiario:</label>
						</td>
						<td>
							<form:input type="text" id="beneficiario" name="beneficiario" path="beneficiario"  size="42" tabindex="57"
								onblur=" ponerMayusculas(this)" maxlength="200" />
						</td>
						<td class="separador"></td>
						<td>
							<label for="beneficiar">Parentesco:</label>
						</td>
						<td>
							<form:input type="text" id="parentescoID" name="parentescoID" path="parentescoID"  size="5" tabindex="58"/>
							<input type="text" id="parentesco" name="parentesco" size="30" readonly="true" disabled="true" tabindex="59"/>
						</td>
					</tr>
					<tr id="trParentesco">
						<td class="label">
							<label for="direccBen">Direcci&oacute;n:</label>
						</td>
						<td>
					    	<form:textarea id="direccionBen" name="direccionBen" path="direccionBen" size="45" tabindex="60" COLS="38" ROWS="2"
					    		 onblur=" ponerMayusculas(this)"  maxlength="300"/>
						</td>
					</tr>

				</table>
			</fieldset>


			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Inter&eacute;s</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="calcInter">Tipo Cal. Inter&eacute;s : </label>
						</td>
					   	<td>
					   		<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres"  tabindex="61" disabled = "true">
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
					   		<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID"  tabindex="62" disabled = "true">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="TasaBase">Tasa Base: </label>
						</td>
					   	<td>
							<form:input type="text" id="tasaBase" name="tasaBase" path="tasaBase" esTasa="true" size="8" tabindex="63" />
						 	<input type="text" id="desTasaBase" name="desTasaBase" size="25"
							       readonly="true" disabled="true" tabindex="64"/>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tasaFija">Tasa Fija Anualizada</label>
						</td>
						<td id="tdTasaFija" >
							<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8"
						 		tabindex="65" esTasa="true" disabled="true" style="text-align: right;"/>
						 	<label for="porcentaje">%</label>
						</td>
						<td id="tdTasaNivel" style="display:none;">
							<form:select id="tasaNivel" name="tasaNivel" path="tasaNivel" tabindex="66">
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="SobreTasa">SobreTasa: </label>
						</td>
					   	<td>
							<select id="sobreTasa" name="sobreTasa" path="sobreTasa" esTasa="true" tabindex="67" style="text-align: right;"></select>
						 	<label for="porcentaje">%</label>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="PisoTasa">Piso Tasa: </label>
						</td>
					   	<td >
						 	<input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8"
						 		style="text-align: right;" esTasa="true" tabindex="68"/>
						 	<label for="porcentaje">%</label>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="TechoTasa">Techo Tasa: </label>
						</td>
					   	<td>
							<input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8"
						 		style="text-align: right;" esTasa="true" tabindex="69" />
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
				<table border="0" width="100%">
					<tr>
						<td class="label" colspan="3">
							<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label>
							</td>
						<td class="label" colspan="2">
							<input type="radio" id="fechInhabil1" name="fechInhabil1" value="S" tabindex="70" checked="checked" />
							<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
							<input type="radio" id="fechInhabil2" name="fechInhabil2" value="A" tabindex="71" />
							<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
							<form:input type="hidden" id="fechInhabil" name="fechInhabil" path="fechInhabil" size="15" tabindex="72" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label" colspan="3">
							<label for="fechInhabil">Ajustar Fecha Exig&iacute;ble a la de Vencimiento: </label>
							</td>
						<td class="label" colspan="2">
							<input type="radio" id="ajusFecExiVen1" name="ajusFecExiVen1" value="S" tabindex="73" />
							<label for="Si">Si</label>&nbsp;
							<input type="radio" id="ajusFecExiVen2" name="ajusFecExiVen2" value="N" tabindex="74"  checked="checked"  />
							<label for="No">No</label>
							<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15" tabindex="75" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label" colspan="5">
							<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck" tabindex="76" value="S"  />
							<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular"
								readonly="true" disabled="disabled"  value="N" tabindex="77"/>
				    		<label for="calendarioIrreg">Calendario Irregular </label>
					 	</td>
			 		</tr>
					<tr>
						<td class="label" colspan="3" nowrap="nowrap">
							<label for="ajFecUlAmoVen">Ajustar Fecha de Vencimiento de &Uacute;ltima
				 Amortizaci&oacute;n a Vencimiento de Cr&eacute;dito: </label>
						</td>
						<td class="label" colspan="2">
							<input type="radio" id="ajFecUlAmoVen1" name="ajFecUlAmoVen1" value="S" tabindex="78" checked="checked"  />
							<label for="ajFecUlAmoVen">Si</label>&nbsp;
							<input type="radio" id="ajFecUlAmoVen2" name="ajFecUlAmoVen2" value="N" tabindex="79"  />
							<label for="no">No</label>
							<form:input type="hidden" id="ajFecUlAmoVen" name="ajFecUlAmoVen" path="ajFecUlAmoVen" size="15" tabindex="80" readonly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label" colspan="3">
							<label for="TipoPagCap">Tipo de Pago de Capital: </label>
						</td>
						<td>
					    	<select  id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="81" >
								<option value="">SELECCIONAR</option>
								<option value="C">CRECIENTES</option>
								<option value="I">IGUALES</option>
								<option value="L">LIBRES</option>
							</select>
							<input type="hidden" id="perIgual" name="perIgual"  size="5"  tabindex="82"/>
					   	</td>
					</tr>
					<tr class="ocultarSeguroCuota">
						<td class="label" colspan="3"><label>Cobra Seguro Cuota:</label></td>
						<td>
							<input type="hidden" id="mostrarSeguroCuota" name="mostrarSeguroCuota"/>
							<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</form:select>
						</td>
					</tr>
					<tr class="ocultarSeguroCuota">
						<td class="label" colspan="3"><label>Cobra IVA Seguro Cuota:</label></td>
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
					<table border="0" width="100%">
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
					        	<select  id="frecuenciaInt" name="frecuenciaInt" path="frecuenciaInt" tabindex="83" >
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
							    	<option value="L">LIBRE</option>
								</select>
						 	</td>
							<td class="separador"></td>
							<td class="label">
								<label for="FrecuenciaCap">Frecuencia: </label>
							</td>
							<td>
					        	<select  id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap" tabindex="84" >
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
							    	<option value="L">LIBRE</option>
								</select>
						 	</td>
						</tr>
						<tr>
							<td class="label">
								<label for="PeriodicidadInter">Periodicidad de Inter&eacute;s:</label>
							</td>
			  				<td>
				 				<form:input  type="text"  id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="8"
				 				readonly = "true" disabled="disabled"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="PeriodicidadCap">Periodicidad de Capital:</label>
							</td>
			   				<td>
				 				<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="8"
				 					readonly = "true"  disabled="disabled" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="DiaPago">D&iacute;a Pago: </label>
							</td>
							<td nowrap="nowrap">
								<div id="divDiaPagoIntMes">
									<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" tabindex="85"  />
									<label for="diaPagoInteres1">&Uacute;ltimo d&iacute;a del mes</label>
									<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres2" value="A" tabindex="86" />
									<label for="diaPagoInteres2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
								</div>
								<div id="divDiaPagoIntQuinc" style="display: none;" >
									<input type="radio" id="diaPagoInteresD" name="diaPagoInteres3" value="D" tabindex="87"  />
									<label for="diaPagoInteresD">D&iacute;a Quincena</label>
									<input type="radio" id="diaPagoInteresQ" name="diaPagoInteres3" value="Q" tabindex="88" />
									<label for="diaPagoInteresQ">Quincena</label>
								</div>
								<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" tabindex="89" value ="F" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="DiaPago">D&iacute;a Pago: </label>
						 	</td>
						 	<td nowrap="nowrap">
								<div id="divDiaPagoCapMes">
									<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" tabindex="90"  />
									<label for="diaPagoCapital1">&Uacute;ltimo d&iacute;a del mes</label>&nbsp;
									<input type="radio" id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="A" tabindex="91" />
									<label for="diaPagoCapital2" id ="lblDiaPagoCap">D&iacute;a del mes</label>
								</div>
								<div id="divDiaPagoCapQuinc" style="display: none;" >
									<input type="radio" id="diaPagoCapitalD" name="diaPagoCapital3" value="D" tabindex="92"  />
									<label for="diaPagoCapitalD">D&iacute;a Quincena</label>
									<input type="radio" id="diaPagoCapitalQ" name="diaPagoCapital3" value="Q" tabindex="93" />
									<label for="diaPagoCapitalQ">Quincena</label>
								</div>
								<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" size="8" tabindex="94" />
								<input type="hidden" id="diaPagoProd" name="diaPagoProd" size="8" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label id="labelDiaInteres">D&iacute;a del mes: </label>
							</td>
				 			<td>
				 				<form:input  type="text"  id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="8" tabindex="95" disabled="true"
				 					readonly="true" />
				 				<input type="text" id="diaDosQuincInt" name="diaDosQuincInt" size="8" tabindex="96" disabled="true" readonly="true" style="display: ;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label id="labelDiaCapital">D&iacute;a del mes: </label>
							</td>
				 			<td>
				 				<form:input  type="text"  id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="8" tabindex="97"/>
				 				<input type="text" id="diaDosQuincCap" name="diaDosQuincCap" size="8" tabindex="98" disabled="true" readonly="true" style="display: ;" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="numAmort">N&uacute;mero de Cuotas:</label>
							</td>
							<td >
								<form:input  type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="8" tabindex="99"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="numAmort">N&uacute;mero de Cuotas:</label>
							</td>
							<td >
								<form:input  type="text"  id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="8" tabindex="100"/>
								<input id="montosCapital" name="montosCapital" size="100" type="hidden" tabindex="101"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblMontoCuota">Monto Cuota:</label>
							</td>
							<td>
							 	<form:input type="text" id="montoCuota" name="montoCuota" path="montoCuota" size="10"
							 		esMoneda="true" style="text-align: right;" readonly="true" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="CAT">CAT:</label>
							</td>
							<td>
								<input type="text" id="CAT" name="CAT" path="CAT" size="8"   readonly="readonly" disabled="disabled"   esTasa="true"
									style="text-align: right;"/>
								<label for="lblPorc"> %</label>
								<input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5"
								 	tabindex="102" disabled ="true" type="hidden" value="0" readonly="true" disabled="disabled" />
							</td>
						</tr>
						<tr class="ocultarSeguroCuota">
							<td></td>
							<td></td>
							<td></td>
							<td class="label"><label>Monto Seguro Cuota:</label></td>
							<td><form:input type="text" name="montoSeguroCuota" id="montoSeguroCuota" path="montoSeguroCuota" size="8" disabled ="true" style="text-align: right;"/></td>
						</tr>
						<tr>
							<td colspan="5" align="right">
								<input type="button" id="simular" name="simular" class="submit" value="Simular" tabindex="103" />
							</td>
						</tr>
					</table>
				</fieldset>
			</fieldset>
			<div id="contenedorSimulador" style="display: none;"></div>
			<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Origen Recursos</legend>
				<table border="0" width="100%">
					<tr>
						<td nowrap="nowrap" colspan="2">
							<input type="radio" id="tipoFondeo" name="tipoFondeo" path="tipoFondeo" value="P" tabindex="104" checked="checked" />
							<label for="recProp">Rec Propios</label>
							<input type="radio"  id="tipoFondeo2" name="tipoFondeo" path="tipoFondeo" value="F" tabindex="105"  />
							<label for="insFondeo">Inst. Fondeo</label>
						</td>
						<td class="separador"></td>
						<td class="label">
		         			<label for="lblInstitucion">Inst. Fondeo: </label>
		     			</td>
		     			<td>
		     				<form:input type="text" id="institutFondID" name="institutFondID" path="institutFondID" size="10" readOnly="true"  disabled="disabled" />
		     				<input type="text" id="descripFondeo" name="descripFondeo" size="45"  readOnly="true" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="label">
			         		<label for="lblLineaFondeo">L&iacute;nea de Fondeo: </label>
			     		</td>
			     		<td>
			     			<form:input type="text" id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="10" tabindex="106" disabled="true" />
			     			<input type="text" id="descripLineaFon" name="descripLineaFon" size="45"  readOnly="true" disabled="disabled" />
						</td>
						<td class="separador"></td>
						<td class="label">
			         		<label for="lblSaldoLinea">Saldo L&iacute;nea: </label>
			     		</td>
			     		<td>
							<input type="text" id="saldoLineaFon" name="saldoLineaFon" size="20"  readOnly="true" disabled="disabled"  esMoneda="true" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td class="label">
		         			<label for="lblTasaPasiva">Tasa Pasiva: </label>
		     			</td>
		     			<td>
							<input type="text" id="tasaPasiva" name="tasaPasiva" size="12"  readOnly="true" disabled="disabled"  esTasa="true" style="text-align: right;"/>
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

			<table>
				<tr>
					<td>
						<div id="comentariosEjecutivo" style="display: none;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all"  style="color:#F00101">
								<legend style="color:#F00101">Historial de Comentarios</legend>
								<table border="0" >
									<tr>
										<td>
								      		<form:textarea  id="comentarioEjecutivo" name="comentarioEjecutivo" path="comentarioEjecutivo" tabindex="140" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);" disabled="true" />
								     	</td>
									</tr>
								</table>
							</fieldset>
						</div>
					</td>
					<td class="separador" id="separa"></td>
					<td>
						<div id="comentarios" style="display: none;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all" >
								<legend>Comentarios</legend>
								<table border="0" >
									<tr>
										<td>
									    	<textarea  id="comentario" name="comentario"  tabindex="141" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);" maxlength="500"></textarea>
									  	</td>
									</tr>
								</table>
							</fieldset>
						</div>
					</td>
				</tr>
			</table>
			<br>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="142"  />
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="143"  />
						<input type="submit" id="liberar" name="liberar" class="submit" value="Liberar" tabindex="144"  />
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="tipoActualizacion"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="calificaCliente" name="calificaCliente"  path="calificaCliente"/>
						<input type="hidden" id="sucursalPromotor" name="sucursalPromotor"/>
						<input type="hidden" id="promAtiendeSuc" name="promAtiendeSuc" />
						<input type="hidden" id="pantalla"  name="pantalla"/>
						<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>" />
						<input type="hidden" id="esqComApertID" name="esqComApertID" value="" iniForma="false"/>
					</td>
				</tr>
			</table>
		</fieldset>
	</form:form>
</div> <!-- contenedorForma -->

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>