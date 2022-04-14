<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
		<script type="text/javascript" src="dwr/interface/esquemaQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/calendarioIngresosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nominaEmpleadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
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
		<script type="text/javascript" src="dwr/interface/esquemaTasasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/serviciosAdicionalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/serviciosSolCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esqComAperNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/comApertConvenioServicio.js"></script>
		<script type="text/javascript" src="js/originacion/solicitudCreditoConsolidacionControlador.js"></script>
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
			<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud Consolidaci&oacute;n de Cr&eacute;dito</legend>


			<!-- ============================= INICIA SECCION DE DATOS GENERALES DE LA SOLICITUD ================================ -->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label" nowrap="nowrap">
			        	<label for="solicitudCreditoID">Solicitud de Cr&eacute;dito: </label>
					</td>
					<td>
						<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12"
						  autocomplete="false"/>
						<input type="hidden" id="esConsolidado" name="esConsolidado" value="S"/>
						<input type="hidden" id="flujoOrigen" name="flujoOrigen" value="6"/>
					</td>
					<td class="separador"></td>
					<td class="label">
			        	<label id="lblCreditoID" for="creditoID">Cr&eacute;dito a Renovar: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="creditoID" name="relacionado" path="relacionado" size="12" readonly="true"/>
			     	</td>
				</tr>
				<tr>
					<td>
						<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
			     	</td>
			     	<td nowrap="nowrap">
			        	<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12"/>
			        	<input type="text" id="nombreCte" name="nombreCte"size="50" />
			        	<input type="hidden" id="clienteSocio" value="<s:message code="safilocale.cliente"/>" />
			        </td>
			        <td></td>
			     	<td class="label" nowrap="nowrap">
						<label for="productoCreditoID">Producto de Cr&eacute;dito: </label>
					</td>
					<td>
			        	<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" />
			         	<input type="text" id="descripProducto" name="descripProducto"size="50" />
			     	</td>
			     </tr>
			    <tr>
			    	<td class="label">
			        	<label for="fechaRegistro">Fecha de Registro: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" />
			     	</td>
			     	<td class="separador"></td>
			     	<td class="label">
			        	<label for="promotorID">Promotor: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="promotorID" name="promotorID" path="promotorID" size="12" />
			     		<input type="text" id="nombrePromotor" name="nombrePromotor"size="50" />
			       	</td>
				</tr>
				<tr>
					<td class="label">
			        	<label for="monedaID">Moneda: </label>
			     	</td>
			     	<td>
				 		<form:select id="monedaID" name="monedaID" path="monedaID" >
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="1">PESOS</form:option>
						</form:select>
					</td>
				    <td class="separador"></td>
				    <td>
						<label for="estatus">Estatus: </label>
			     	</td>
			     	<td>
			     		<form:select id="estatus" name="estatus" path="estatus" >
			     			<form:option value="">SELECCIONAR</form:option>
				     		<form:option value="I">INACTIVA</form:option>
							<form:option value="A">AUTORIZADA</form:option>
							<form:option value="C">CANCELADA</form:option>
							<form:option value="R">RECHAZADA</form:option>
							<form:option value="D">DESEMBOLSADA</form:option>
							<form:option value="L">LIBERADA</form:option>
						</form:select>
					</td>
			 	</tr>
			 	<tr>
					<td>
						<label for="sucursalCte">Sucursal: </label>
			     	</td>
			     	<td>
						<input type="text" id="sucursalCte" name="sucursalCte"  size="12"  />
						<input type="text" id="nombreSucursal" name="nombreSucursal"size="50"  />
					</td>
			     	<td class="separador"></td>
			     	<td>
						<label for="destinoCreID">Destino Cr&eacute;dito: </label>
			     	</td>
			     	<td nowrap="nowrap">
						<form:input type="text" id="destinoCreID" name="destinoCreID" path="destinoCreID" size="12"/>
						<input type="text" id="descripDestino" name="descripDestino" size="50" />
					</td>
			 	</tr>
			 	<tr>
					<td>
						<label for="destinCredFRID">Destino Cr&eacute;dito FR: </label>
			     	</td>
			     	<td>
						<input type="text" id="destinCredFRID" name="destinCredFRID"  size="12" />
						<input type="text" id="descripDestinoFR" name="descripcionoDestinFR" size="50" />
					</td>
			     	<td class="separador"></td>
			     	<td  nowrap="nowrap">
						<label for="destinCredFOMURID">Destino Cr&eacute;dito FOMUR: </label>
			     	</td>
			     	<td>
						<input type="text" id="destinCredFOMURID" name="destinCredFOMURID"  size="12" />
						<input type="text" id="descripDestinoFOMUR" name="descripDestinoFOMUR" size="50" />
					</td>
			 	</tr>
			 	<tr>
		     		<td class="label">
		         		<label for="clasificacionDestin1">Clasificaci&oacute;n: </label>
		     		</td>
		    	 	<td>
				    	<input type="radio" id="clasificacionDestin1" name="clasifiDestinCred1"  value="C" />
							<label for="lblcomercial">Comercial</label>
						<input type="radio" id="clasificacionDestin2" name="clasifiDestinCred1"  value="O" />
							<label for="lblConsumo">Consumo</label>
						<input type="radio" id="clasificacionDestin3" name="clasifiDestinCred1"  value="H" />
							<label for="lblHipotecario">Vivienda</label>
				   		<input type="hidden" id="clasifiDestinCred" name="clasifiDestinCred"/>

		    		</td>
		    		<td class="separador"></td>
		    		<td class="label">
		        		<label for="proyecto">Proyecto: </label>
			     	</td>
			     	<td>
				 		<textarea id="proyecto" name="proyecto" cols="40" rows="2" maxlength="500"> </textarea>
					</td>
			 	</tr>
			 	<tr>
					<td class="label">
						<label for="numCreditos"> Ciclo <s:message code="safilocale.cliente"/>: </label>
					</td>
					<td>
						<form:input type="text" id="numCreditos" name="numCreditos" path="numCreditos" size="12" />
					</td>
				</tr>
				<tr id="trNomina">
					<td class="label">
		        		<label for="calificaCredito">Calificaci&oacute;n: </label>
			     	</td>
			     	<td>
				 		<input type="text" id="calificaCredito" name="calificaCredito"  size="20" />
						<input type="hidden" id="cicloClienteGrupal" name="cicloClienteGrupal" value="0"/>
						<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal"/>
						<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="institucionNominaID">Empresa Nómina: </label>
					</td>
					<td id="institNominaID">
						<form:input type="text" id="institucionNominaID" name="institucionNominaID"  path="institucionNominaID" size="12" />
						<input type="text" id="nombreInstit" name="nombreInstit"  size="50" />
					</td>
				</tr>
				<tr>
					<td>
						<label for="folioCtrl">N&uacute;mero Empleado:</label>
					</td>
					<td id="folioCtrlCaja" >
						<form:input type="text" id="folioCtrl" name="folioCtrl"  path="folioCtrl" size="20" maxlength="20" />
					</td>
					<td class="separador"></td>
					<td>
						<label for="horarioVeri">Horario Verificaci&oacute;n:</label>
					</td>
					<td>
						<form:input type="text" id="horarioVeri" name="horarioVeri" path="horarioVeri" maxlength="20" size="12" />
					</td>
				</tr>
				<tr>
					<td>
						<label for="horarioVeri">Tipo Cr&eacute;dito:</label>
					</td>
					<td>
						<input type="text" id="tipoSolCredito" name="tipoSolCredito" size="20" value="CONSOLIDACI&Oacute;N" iniForma="false"/>
						<input type="hidden" id="tipoCredito" name="tipoCredito" value="N" iniForma="false"/>
					</td>
					<td class="separador"></td>
					<td class="label">
		         		<label for="lblTipoConsultaSIC">Tipo Consulta SIC: </label>
		     		</td>
		    	 	<td>
				    	<input type="radio" id="tipoConsultaSICBuro" name="tipoConSIC"  value="B"  />
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
						<input type="text" id="folioConsultaBC" name="folioConsultaBC" path="folioConsultaBC" size="15"  maxlength="30" />
					</td>
					<td class="separador"></td>
				</tr>
				<tr id="consultaCirculo">
					<td >
						<label for="lbconsultaSICC">Folio Consulta Círculo:</label>
					</td>
					<td>
						<input type="text" id="folioConsultaCC" name="folioConsultaCC" path="folioConsultaCC" size="15" maxlength="30" />
					</td>
					<td class="separador"></td>
				</tr>
				<tr id="convenios">
					<td >
						<label for="lbconsultaSICB">Convenio:</label>
					</td>
					<td>
						<select id="convenioNominaID" name="convenioNominaID" ></select>
					</td>
					<td class="separador"></td>
					<td >
						<label for="noEmpleado" class="quinquenios">Quinquenio:</label>
					</td>
					<td >
						<select id="quinquenioID" name="quinquenioID" class="quinquenios" >
							<option value="">SELECCIONAR</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<label class="folioSolici">Folio:</label>
					</td>
					<td >
						<input id="folioSolici" name="folioSolici"  size="20"  maxlength="20" class="folioSolici"/>
					</td>

				</tr>
			</table>
			</fieldset>
			<!-- ----------------------------- Termina seccion de datos generales de la solicitud ---------------------------------- -->



			<br>




			<!-- ============================= INICIA SECCION DE CONDICIONES ================================ -->

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Condiciones</legend>
			 	<table table border="0" cellpadding="0" cellspacing="0" width="100%">
			 		<tr>
<!-- 		     		<td class="label"> -->
<!-- 		         		<label for="tipoLiquidacionlbl">Liquidaci&oacute;n Cred. Ant.: </label> -->
<!-- 		     		</td> -->
<!-- 		    	 	<td> -->
<!-- 				    	<input type="radio" id="total" name="tipoLiquidacion" value="T" /> -->
<!-- 							<label for="lblTotal">Total</label> -->
<!-- 						<input type="radio" id="parcial" name="tipoLiquidacion" hidden="true" value="P" /> -->
<!-- 							<label for="lblParcial" hidden="true">Parcial</label> -->
<!-- 		    		</td> -->
<!-- 		    		<td class="separador"></td> -->
			     	<td class="label">
			        	<label for="cantidadPagar" id="lblCantidadPagar" style="display: none;">Cantidad a Pagar: </label>
			     	</td>
			     	<td>
			        	<form:input type="text" id="cantidadPagar" path="cantidadPagar" size="18" esMoneda="true"  style="text-align: right; display: none;"  />
			     	</td>


			 	</tr>
			 		<tr>
			 			<td class="label">
			         		<label for="montoSolici">Monto Solicitado: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="montoSolici" name="montoSolici" path="montoSolici" size="18" esMoneda="true" style="text-align: right;" />
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="montoAutorizado">Monto Autorizado: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="montoAutorizado" path="montoAutorizado" size="18" esMoneda="true"  style="text-align: right;" />
			     		</td>
			   		</tr>
			     	<tr>
			     		<td class="label">
			         		<label for="fechaInicio">Fecha de Inicio: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaInicio" name="fechaInicio" size="18" path="fechaInicio" />
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="fechaInicioAmor">Fecha Inicio de Primer Amortizaci&oacute;n: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaInicioAmor" name="fechaInicioAmor" size="18"  path="fechaInicioAmor" />
			     		</td>
			     	</tr>
			     	<tr>
			 			<td class="label">
					   		<label for="plazoID">Plazo: </label>
					   	</td>
					   	<td>
			         		<form:select  id="plazoID" name="plazoID" path="plazoID" >
					        	<form:option value="0">SELECCIONAR</form:option>
						   	</form:select>
			     		</td>
			     		<td class="separador"></td>
			     		<td class="label">
			         		<label for="fechaVencimiento">Fecha de Vencimiento: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" size="18" path="fechaVencimiento" />
			     		</td>
			     	</tr>
			     	<tr>
			     		<td class="label">
							<label for="FactorMora">Factor Mora: </label>
						</td>
			   			<td>
				 			<input type="text" id="factorMora" name="factorMora" size="15"  esMoneda="true" />
	 						<label for="lblveces">veces la tasa de inter&eacute;s ordinaria</label>
						</td>
						<td class="separador"></td>
						<td>
							<label for="porcGarLiq">Garant&iacute;a L&iacute;quida:  </label>
				     	</td>
				     	<td>
				     		<form:input type="text" id="porcGarLiq" name="porcGarLiq" path="porcGarLiq" size="6" style="text-align: right;" />
				 			<label for="lblAporte">% &nbsp;</label>
				     		<form:input type="text" id="aporteCliente" name="aporteCliente" path="aporteCliente" esMoneda="true" size="15"   style="text-align: right;"/>
				     		<input type="hidden" id="porcentaje" name="porcentaje" size="10" />
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
							<input type="text" id="clabeDomiciliacion" name="clabeDomiciliacion" size="24" maxlength="18" autocomplete="off"/>
						</td>
					</tr>
				</table>
			</fieldset>

			<!-- ----------------------------- Termina seccion de condidiciones ---------------------------------- -->
			<!-- Inicia Servicios adicionales -->
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
			
			<!-- Fin Servicios adicionales -->
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
			<div id = "seguroVida">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Seguro de Vida</legend>
						<table border="0" width="100%">

							<tr>
								<td class="label">
									<label for="cobertura">Cobertura:</label>
								</td>
								<td>
									<form:input type="text" id="cobertura" name="cobertura" path="cobertura" esMoneda="true" size="12" style="text-align: right;" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="prima">Prima:</label>
								</td>
								<td>
									<form:input type="text" id="prima" name="prima" path="prima" esMoneda="true" size="12" style="text-align: right;" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="vigencia">Vigencia:</label>
								</td>
								<td>
									<form:input type="text" id="vigencia" name="vigencia" path="vigencia" size="12" />
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
				<br>


			<!-- ============================= INICIA SECCION DE CONDICIONES DE INTERES ================================ -->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Inter&eacute;s</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="tipoCalInteres">Tipo Cal. Inter&eacute;s: </label>
						</td>
					   	<td>
					   		<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres" >
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="1">SALDOS INSOLUTOS</form:option>
								<form:option value="2">MONTO ORIGINAL</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="calcInteresID">C&aacute;lculo de Inter&eacute;s: </label>
						</td>
					   	<td>
					   		<form:select id="calcInteresID" name="calcInteresID" path="calcInteresID" >
								<form:option value="">SELECCIONAR</form:option>

							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tasaBase">Tasa Base: </label>
						</td>
					   	<td>
							<input type="text" id="tasaBase" name="tasaBase" size="8"/>
						 	<input type="text" id="desTasaBase" name="desTasaBase" size="25" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="tasaFija">Tasa Fija Anualizada: </label>
						</td>
						<td >
							<input type="text" id="tasaFija" name="tasaFija" size="8"   style="text-align: right;"/>
						 	<label for="porcentaje">%</label>
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
								 size="18" />
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
							<input type="hidden" id="pagaIVACte" name="pagaIVACte"  disabled="true" size="5" />
							<input type="hidden" id="sucursalID" name="sucursalID" disabled="true" size="5"/><!--  XX.XX -->
							<td class="separador"></td>
							<td class="label">
			         		<label for="fechaCobroComision">Fecha Cobro Comisión: </label>
			     		</td>
			     		<td>
			         		<form:input type="text" id="fechaCobroComision" name="fechaCobroComision" size="18" readOnly="true" disabled="true" path="fechaCobroComision" />
			     		</td>
						</td>

					<tr>
						<td class="label">
							<label for="sobreTasa">SobreTasa: </label>
						</td>
					   	<td>
							<select id="sobreTasa" name="sobreTasa" esMoneda="true" style="text-align: right;" ></select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="pisoTasa">Piso Tasa: </label>
						</td>
					   	<td >
						 	<input type="text" id="pisoTasa" name="pisoTasa" size="8" esMoneda="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="techoTasa">Techo Tasa: </label>
						</td>
					   	<td>
							<input type="text" id="techoTasa" name="techoTasa" size="8" esMoneda="true" />
						</td>
						<td class="separador"></td>
						<td class="label ocultarSeguroCuota"><label>Cobra Seguro Cuota:</label></td>
						<td class="ocultarSeguroCuota">
							<input type="hidden" id="mostrarSeguroCuota" name="mostrarSeguroCuota"/>
							<form:select name="cobraSeguroCuota" id="cobraSeguroCuota" disabled="true" path="cobraSeguroCuota">
								<option value="N">NO</option>
								<option value="S">SI</option>
							</form:select>
						</td>
					</tr>
					<tr class="ocultarSeguroCuota">
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
			<!-- ----------------------------- Termina seccion de condiciones de interes ---------------------------------- -->



			<br>


			<!-- ============================= INICIA SECCION DE CALENDARIO DE PAGOS  ================================ -->
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Calendario de Pagos</legend>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<table border="0" cellpadding="0" cellspacing="0"   width="100%">
					<tr>
						<td class="label" colspan="1">
							<label for="fechInhabil">En Fecha Inh&aacute;bil Tomar: </label>
						</td>
						<td class="label" colspan="4">
							<input type="radio" id="fechInhabil1" name="fechInhabil1" value="S" />
							<label for="siguiente">D&iacute;a H&aacute;bil Siguiente</label>&nbsp;
							<input type="radio" id="fechInhabil2" name="fechInhabil1" value="A" />
							<label for="anterior">D&iacute;a H&aacute;bil Anterior</label>
							<form:input type="hidden" id="fechInhabil" name="fechInhabil" path="fechInhabil" size="15"/>
							<form:input type="hidden" id="ajFecUlAmoVen" name="ajFecUlAmoVen" path="ajFecUlAmoVen" size="15"/>
							<form:input type="hidden" id="ajusFecExiVen" name="ajusFecExiVen" path="ajusFecExiVen" size="15"/>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="1">
							<input type="checkbox" id="calendIrregularCheck" name="calendIrregularCheck"  value="S"  />
							<form:input type="hidden" id="calendIrregular" name="calendIrregular" path="calendIrregular"   value="N" />
				    		<label for="calendarioIrreg">Calendario Irregular </label>
					 	</td>
			 		</tr>
					<tr>
						<td class="label" colspan="1">
							<label for="tipoPagoCapital">Tipo de Pago de Capital: </label>
						</td>
						<td>
					    	<select  id="tipoPagoCapital" name="tipoPagoCapital"  >
								<option value="">SELECCIONAR</option>
							</select>
							<input type="hidden" id="perIgual" name="perIgual"  size="5"/>
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
								<label for="frecuenciaInt">Frecuencia: </label>
							</td>
							<td>
					        	<select  id="frecuenciaInt" name="frecuenciaInt" >
							    	<option value="">SELECCIONAR</option>
								</select>
						 	</td>
							<td class="separador"></td>
							<td class="label">
								<label for="FrecuenciaCap">Frecuencia: </label>
							</td>
							<td>
					        	<select  id="frecuenciaCap" name="frecuenciaCap" >
							    	<option value="">SELECCIONAR</option>
								</select>
						 	</td>
						</tr>
						<tr>
							<td class="label">
								<label for="periodicidadInt">Periodicidad de Inter&eacute;s:</label>
							</td>
			  				<td>
				 				<form:input  type="text"  id="periodicidadInt" name="periodicidadInt" path="periodicidadInt" size="10"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="periodicidadCap">Periodicidad de Capital:</label>
							</td>
			   				<td>
				 				<form:input type="text" id="periodicidadCap" name="periodicidadCap" path="periodicidadCap" size="10"   />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="diaPagoInteres1">D&iacute;a Pago: </label>
							</td>
							<td nowrap="nowrap">
								<input type="radio" id="diaPagoInteres1" name="diaPagoInteres1" value="F" />
								<label for="diaPagoInteres1"id="lbldiaPagoInteres1">&Uacute;ltimo día del mes</label>
								<input type="radio"  id="diaPagoInteres2" name="diaPagoInteres1" value="A" />
								<label for="diaPagoInteres" id="lblDiaPagoInteres">D&iacute;a del mes</label>
								<form:input type="hidden" id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" size="8" value ="F" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="DiaPago">D&iacute;a Pago: </label>
						 	</td>
						 	<td nowrap="nowrap">
								<input type="radio" id="diaPagoCapital1" name="diaPagoCapital1" value="F" />
								<label for="diaPagoCapital2"id="lblDiaPagoCapital2" >&Uacute;ltimo día del mes</label>&nbsp;
								<input type="radio" id="diaPagoCapital2" name="diaPagoCapital1" value="A" />
								<label for="diaPagoCapital" id="lblDiaPagoCap" >D&iacute;a del mes</label>
								<form:input type="hidden" id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" />
								<form:input type="hidden" id="diaPagoProd" name="diaPagoProd" path="diaPagoProd"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="diaMesInteres">D&iacute;a del mes: </label>
							</td>
				 			<td>
				 				<form:input  type="text" id="diaMesInteres" name="diaMesInteres" path="diaMesInteres" size="10"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="diaMesCapital">D&iacute;a del mes: </label>
							</td>
				 			<td>
				 				<form:input  type="text" id="diaMesCapital" name="diaMesCapital" path="diaMesCapital" size="10" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="numAmortInteres">N&uacute;mero de Cuotas:</label>
							</td>
							<td >
								<form:input  type="text"  id="numAmortInteres" name="numAmortInteres" path="numAmortInteres" size="10" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="numAmortizacion">N&uacute;mero de Cuotas:</label>
							</td>
							<td >
								<form:input  type="text"  id="numAmortizacion" name="numAmortizacion" path="numAmortizacion" size="10" />
								<input id="montosCapital" name="montosCapital" size="100" type="hidden"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblMontoCuota">Monto Cuota:</label>
							</td>
							<td>
							 	<form:input type="text" id="montoCuota" name="montoCuota" path="montoCuota" size="10" esMoneda="true" style="text-align: right;" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="CAT">CAT:</label>
							</td>
							<td>
								<input type="text" id="CAT" name="CAT" size="10"  style="text-align: right;"/>
								<label for="numTransacSim"> %</label>
								<input  type="hidden" id="numTransacSim" name="numTransacSim" size="5" value="0"  />
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
								<input type="button" id="simular" name="simular" class="submit" value="Simular" />
							</td>
						</tr>

					</table>
				</fieldset>
			</fieldset>


			<div id="contenedorSimulador" style="display: none;"></div>
			<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>


			<input type="hidden" id="tipoFondeo" name="tipoFondeo" value="P" iniForma="false"/>
			<input type="hidden" id="institutFondID" name="institutFondID" value="0" iniForma="false"/>
			<input type="hidden" id="lineaFondeoID" name="lineaFondeoID" value="0" iniForma="false"/>
			<input type="hidden" id="saldoLineaFon" name="saldoLineaFon" value="0" iniForma="false" />
			<input type="hidden" id="tasaPasiva" name="tasaPasiva" value="0" iniForma="false"/>
			<input type="hidden" id="montoCredAnterior" name="montoCredAnterior" value="0" iniForma="false"/>
			<input type="hidden" id="tipoLiquidacion" name="tipoLiq"  />
			<input type="hidden" id="montoExigible" name="montoExigible" value="0" iniForma="false"/>



			<table>
				<tr>
					<td>
						<div id="comentariosEjecutivo" style="display: none;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all"  style="color:#F00101">
								<legend style="color:#F00101">Historial de Comentarios</legend>
								<table border="0" cellpadding="0" cellspacing="0" >
									<tr>
										<td>
								      		<form:textarea  id="comentarioEjecutivo" name="comentarioEjecutivo" path="comentarioEjecutivo" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);"/>
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
								<table border="0" cellpadding="0" cellspacing="0" >
									<tr>
										<td>
									    	<textarea  id="comentario" name="comentario" COLS="60" ROWS="4" onBlur=" ponerMayusculas(this);"></textarea>
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
						<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar"  />
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar"  />
						<input type="submit" id="liberar" name="liberar" class="submit" value="Liberar"  />
						<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="tipoActualizacion"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="calificaCliente" name="calificaCliente"  path="calificaCliente"/>
						<input type="hidden" id="sucursalPromotor" name="sucursalPromotor"/>
						<input type="hidden" id="promAtiendeSuc" name="promAtiendeSuc" />
						<input type="hidden" id="pantalla"  name="pantalla"/>
						<input type="hidden" id="noDias" name="noDias"/>
						<input type="hidden" id="pagaIVACte" name="pagaIVACte"/>
						<input type="hidden" id="tipoDispersion" name="tipoDispersion" value="E" iniForma="false"/>
						<input type="hidden" id="reqSeguroVida" name="reqSeguroVida" value="N" iniForma="false"/>
						<input type="hidden" id="forCobroSegVida" name="forCobroSegVida" value="" iniForma="false"/>
<!-- 					**Info consolidación** -->
						<input type="hidden" id="tipoTransaccionCons" name="tipoTransaccionCons" value=""/>
						<input type="hidden" id="recursoCons" name="recursoCons" value=""/>
						<input type="hidden" id="clienteIDCons" name="clienteIDCons" value=""/>
						<input type="hidden" id="consolidaCartaIDCons" name="consolidaCartaIDCons" value=""/>
						<input type="hidden" id="direccionIPCons" name="direccionIPCons" value=""/>
						<input type="hidden" id="empresaIDCons" name="empresaIDCons" value=""/>
						<input type="hidden" id="esConsolidadoCons" name="esConsolidadoCons" value=""/>
						<input type="hidden" id="estatusCons" name="estatusCons" value=""/>
						<input type="hidden" id="fechaActualCons" name="fechaActualCons" value=""/>
						<input type="hidden" id="flujoOrigenCons" name="flujoOrigenCons" value=""/>
						<input type="hidden" id="montoConsolidaCons" name="montoConsolidaCons" value=""/>
						<input type="hidden" id="numTransaccionCons" name="numTransaccionCons" value=""/>
						<input type="hidden" id="programaIDCons" name="programaIDCons" value=""/>
						<input type="hidden" id="relacionadoCons" name="relacionadoCons" value=""/>
						<input type="hidden" id="solicitudCreditoIDCons" name="solicitudCreditoIDCons" value=""/>
						<input type="hidden" id="sucursalCons" name="sucursalCons" value=""/>
						<input type="hidden" id="tipoCreditoCons" name="tipoCreditoCons" value=""/>
						<input type="hidden" id="esqComApertID" name="esqComApertID" value="" iniForma="false"/>
					</td>
				</tr>
			</table>
		</fieldset>
		<!-- ----------------------------- Termina seccion de condiciones de calendario de pagos ---------------------------------- -->


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
