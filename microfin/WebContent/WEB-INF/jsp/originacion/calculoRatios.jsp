<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/socDemoViviendaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solBuroCredServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/datSocDemogServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ratiosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/garantiaServicioScript.js"></script>
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clidatsocioeServicio.js"></script>			
		<script type="text/javascript" src="js/originacion/calculoRatios.js"></script>   
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ratiosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cálculo Ratios</legend>
				<table>
					<tr>
						<td>
							<table border="0" style="width: 100%">
								<tr>
									<td class="label" nowrap="nowrap">
										<label for="lblSolicitudCredito">Solicitud de Crédito: </label>
									</td>
									<td>
										<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" autocomplete="false" tabindex="1" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblProspecto">Prospecto: </label>
									</td>
									<td nowrap="nowrap">
										<form:input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="12" readonly="true" />
										<input type="text" id="nombreProspecto" name="nombreProspecto" size="50" readonly="true" disabled="disabled" />
									</td>
								</tr>
								<tr>
									<td>
										<label for="lblClienteID"><s:message code="safilocale.cliente" />: </label>
									</td>
									<td nowrap="nowrap">
										<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" readonly="true" />
										<input type="text" id="nombreCte" name="nombreCte" size="50" readonly="true" disabled="disabled" />
									</td>
									<td class="separador"></td>
									<td class="label" nowrap="nowrap">
										<label for="lblProducto">Producto de Cr&eacute;dito: </label>
									</td>
									<td>
										<form:input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" readonly="true" />
										<input type="text" id="descripProducto" name="descripProducto" size="50" readonly="true" disabled="disabled" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblClasificacion">Clasificación: </label>
									</td>
									<td>
										<input type="radio" id="clasificacionDestin1" name="clasifiDestinCred" value="C" readonly="true" disabled="true" /> <label for="lblcomercial">Comercial</label> <input type="radio" id="clasificacionDestin2" name="clasifiDestinCred" value="O" readonly="true" disabled="true" /> <label for="lblConsumo">Consumo</label> <input type="radio" id="clasificacionDestin3" name="clasifiDestinCred" value="H" readonly="true" disabled="true" /> <label for="lblHipotecario">Vivienda</label> <input type="hidden" id="clasifiDestinCred" name="clasifiDestinCred" size="50" />
									</td>
									<td class="separador"></td>
									<td class="label">
										<label for="lblsolicitado">Monto Solicitado: </label>
									</td>
									<td>
										<input type="text" id="montoSolici" name="montoSolici" size="18" esMonto="true" style="text-align: right;" readonly="true" />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblPlazo">Plazo: </label>
									</td>
									<td>
										<form:select id="plazoID" name="plazoID" path="plazoID" disabled="true">
											<form:option value="0">SELECCIONAR</form:option>
										</form:select>
									</td>
									<td class="separador"></td>
									<td class="label" nowrap="nowrap">
										<label for="tasaFija">Tasa Fija Anualizada: </label>
									</td>
									<td>
										<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8" esTasa="true" style="text-align: right;" readonly="true" /> <label for="porcentaje">%</label>
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="lblEstatus">Estatus: </label>
									</td>
									<td>
										<input type="text" id="estatus" name="estatus" size="18" readonly="true" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>C1. Carácter </legend>
								<table border="0" style="width: 100%">
									<tr>
										<td class="label">
											<label><b>Residencia</b></label>
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="label">
											<label><b>Ocupación</b></label>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Tipo de Residencia:</label>
										</td>
										<td>
											<select id="tipoViviendaID" name="tipoViviendaID" readonly="true" disabled="true">
												<option value=" "></option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="lblantiguedad">Ocupación Principal:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="ocupacionID" name="ocupacionID" size="12" readonly="true" /> <input type="text" id="descripcionOcupacion" name="descripcionOcupacion" size="40" readonly="true" disabled="disabled" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Tiempo de Habitar en la Residencia:</label>
										</td>
										<td>
											<input type="text" id="tiempoHabitarDom" name="tiempoHabitarDom" size="12" readonly="true" /><label for="lblmes">&nbsp;Meses</label>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblantiguedad">No. Meses Ocupación:</label>
										</td>
										<td>
											<input type="text" id="mesesOcupacion" name="mesesOcupacion" size="12" readOnly="true" /><label for="lblmes">&nbsp;Meses</label>
										</td>
									</tr>
									<tr>
										<td class="label">
											<br> <label><b>Experiencia Crediticia:</b></label>
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="label">
											<br> <label><b>Afiliación y Ahorro</b></label>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Hubo Morosidad en el último Crédito:</label>
										</td>
										<td>
											<select id="morosidadCredito" name="morosidadCredito" disabled="disabled">
												<option value="">--</option>
												<option value="S">Si</option>
												<option value="N">No</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="lblSocio">Es Socio de la Caja:</label>
										</td>
										<td>
											<select id="cliente" name="cliente" disabled="disabled">
												<option value="">--</option>
												<option value="S">SI</option>
												<option value="N">NO</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Número de Meses de Mora Máximo:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="maximoMorosidad" name="maximoMorosidad" size="12" readOnly="true" /><label for="lblmes">&nbsp;Meses</label>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="RFClbl">Saldo Promedio de Ahorro:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="saldoPromedioAhorro" name="saldoPromedioAhorro" path="saldoPromedioAhorro" size="15" readonly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Calificación Buró de Crédito:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="calificaBuro" name="calificaBuro" size="12" readonly="true" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Calificación Caja:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="calificaCredito" name="calificaCredito" size="15" readonly="true" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>C2. Capital </legend>
								<table border="0" style="width: 100%">
									<tr>
										<td colspan="2" style="width: 50%; vertical-align: top;">
											<table border="0" style="width: 100%">
												<tr>
													<td class="label" style="width: 150px">
														<label><b>Activos</b></label>
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Cuentas de Ahorro:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="totalAhorro" name="totalAhorro" esMonto="true" readOnly="true" size="15" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Inversiones:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="activosInversiones" name="activosInversiones" esMonto="true" readOnly="true" size="15" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Terrenos:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="activosTerrenos" name="activosTerrenos" esMonto="true" size="15" tabindex="3" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Vivienda:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="vivienda" name="vivienda" value="0" size="15" esMonto="true" tabindex="4" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Vehículos:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="activosVehiculos" name="activosVehiculos" esMonto="true" size="15" tabindex="5" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad">Muebles, Enseres, Maquinaria y otros:</label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="otrosActivos" name="otrosActivos" esMonto="true" size="15" tabindex="6" style="text-align: right;" />
													</td>
												</tr>
												<tr>
													<td class="label" nowrap="nowrap" style="width: 150px">
														<label for="lblantiguedad"><b>Total:</b></label>
													</td>
													<td nowrap="nowrap" style="text-align: right;">
														<input type="text" id="totalActivos" name="totalActivos" esMonto="true" readOnly="true" size="15" style="text-align: right;" />
													</td>
												</tr>

											</table>
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td colspan="2" valign="top" style="width: 50%">
											<table border="0" id="tablaGastosPasivos" style="width: 100%">
												<tr>
													<td class="label" class="label">
														<label><b>Pasivos</b></label>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="separador" colspan="5"></td>
									</tr>
									<tr>
										<td class="separador" colspan="5"></td>
									</tr>
									<tr>
										<td class="separador" colspan="5"></td>
									</tr>
									<tr>
										<td class="separador" colspan="5"></td>
									</tr>
									<tr>
										<td class="separador" colspan="5"></td>
									</tr>
									<tr>
										<td class="label" style="width: 150px; vertical-align: top" >
											<label for="lblantiguedad">Porcentaje Endeudamiento Actual:</label>
										</td>
										<td nowrap="nowrap" style="text-align: right; vertical-align: top">
											<input type="text" id="deudaActual" name="deudaActual" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										</td>
										<td class="separador" style="width: 5%"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap" style="width: 150px; vertical-align: top">
											<label for="lblantiguedad">Porcentaje Endeudamiento Con el Crédito:</label>
										</td>
										<td style="text-align: right; vertical-align: top">
											<input type="text" id="deudaActualConCredito" name="deudaActualConCredito" readOnly="true" esMonto="true" size="20" style="text-align: right;" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>C3. Capacidad de Pago</legend>
								<table border="0" style="width: 100%">
									<tr>
										<td class="label">
											<label for="lblantiguedad">Ingresos Mensuales:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="ingresosMensuales" name="ingresosMensuales" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblantiguedad">Egresos Mensuales:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="egresosMensuales" name="egresosMensuales" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Egresos Marginales:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="egresosMarginales" name="egresosMarginales" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblantiguedad">Ingresos Netos:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="ingresosNetos" name="ingresosNetos" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblPlazo">Monto de la Cuota: </label>
										</td>
										<td>
											<input type="text" id="montoCuota" name="montoCuota" size="15" esMonto="true" tabindex='10' style="text-align: right;" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<br> <label for="lblantiguedad">Porcentaje Cobertura:</label>
										</td>
										<td nowrap="nowrap">
											<br> <input type="text" id="cobertura" name="cobertura" readOnly="true" value="0" size="15" esMonto="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<br> <label for="lblantiguedad">Porcentaje Gastos sin el Crédito:</label>
										</td>
										<td nowrap="nowrap">
											<br> <input type="text" id="gastosActuales" name="gastosActuales" readOnly="true" value="0" size="15" esMonto="true" style="text-align: right;" />
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="lblantiguedad">Porcentaje Gastos con el Crédito:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="gastosConCredito" name="gastosConCredito" readOnly="true" value="0" size="15" esMonto="true" style="text-align: right;" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>C4.Condiciones</legend>
								<table border="0" style="width: 100%">
									<tr>
										<td class="label">
											<label for="lblantiguedad">Estabilidad a Futuro:</label>
										</td>
										<td>
											<select id="estabilidadEmpleo" name="estabilidadEmpleo" tabindex="20" style="width:100%;">
												<option value="">SELECCIONAR</option>
												<option value="A">ALTA</option>
												<option value="M">MEDIA</option>
												<option value="B">BAJA</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblantiguedad">Tiene Algún Negocio o es Productor:</label>
										</td>
										<td nowrap="nowrap">
											<input type="radio" id="tieneNegocio1" name="tieneNegocio" tabindex="21" value="S" checked="tre" /> <label for="lblcomercial">Si</label> <input type="radio" id="tieneNegocio2" name="tieneNegocio" tabindex="22" value="N" /> <label for="lblConsumo">No</label>
										</td>
									</tr>
									<tr id="trMontoVentas">
										<td class="label">
											<label for="lblantiguedad">Monto de Ventas Mensuales:</label>
										</td>
										<td>
											<select id="ventasMensuales" name="ventasMensuales" tabindex="23" style="width:100%;">
												<option value="">SELECCIONAR</option>
												<option value="A">ALTAS</option>
												<option value="M">MEDIAS</option>
												<option value="B">BAJAS</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="lblantiguedad">Flujo de Efectivo o Liquidez:</label>
										</td>
										<td>
											<select id="liquidez" name="liquidez" path="liquidez" tabindex="24" style="width:100%;">
												<option value="">SELECCIONAR</option>
												<option value="A">ALTO</option>
												<option value="M">MEDIA</option>
												<option value="B">BAJA</option>
											</select>
										</td>
									</tr>
									<tr id="trSituacionMercado">
										<td class="label">
											<label for="lblantiguedad">Situación del Mercado:</label>
										</td>
										<td>
											<select id="situacionMercado" name="situacionMercado" tabindex="25" style="width:100%;">
												<option value="">SELECCIONAR</option>
												<option value="C">CRECIENTE</option>
												<option value="E">ESTABLE</option>
												<option value="S">SATURADO</option>
											</select>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>C5. Colateral</legend>
								<fieldset id="fieldGarantias" class="ui-widget ui-widget-content ui-corner-all" style="display:none;">
								<legend><label>Garant&iacute;as Quirografarias/Prendarias</label></legend>
								<table class="tabla_round" id="tablaGarantias" border="0" style="width: 100%; display: none; border: 0; " >
									<tr id="trEncabezadoGarantias" class="encabezadoLista" style="font-size:.80em">
										<td class="td_borderInfIzq">
											N&uacute;mero
										</td>
										<td class="td_sinborder" style="text-align: center;">
											Descripci&oacute;n
										</td>
										<td class="td_sinborder" style="text-align: center;">
											Valor Comercial
										</td>
										<td class="td_borderInfDer" style="text-align: center;">
											Valor Asignado
										</td>
									</tr>
								</table>
								</fieldset>
								<table border="0" style="width: 50%">
									<tr>
										<td class="label">
											<label for="lblAporte">Garantía Liquida: </label>
										</td>
										<td>
											<input type="text" id="porcGarLiq" name="porcGarLiq" size="6" style="text-align: right;" readOnly="true" disabled="disabled" /> <label for="lblAporte">% &nbsp;</label> <input type="text" id="aporteCliente" name="aporteCliente" esMonto="true" size="15" readOnly="true" disabled="disabled" style="text-align: right;" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label"><label>Avales:</label></td>
										<td><input id="nAvales" type="text" name="nAvales" size="6" readonly="readonly" disabled="disabled"></td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all" id="FielsetResultados" style="display: none"">
								<legend>Resultados </legend>
								<table border="0" style="width: 100%">
									<tr>
										<td class="label" colspan="2">
											<label><b>C1. Carácter</b></label>
										</td>
										<td class="separador"></td>
										<td class="label" colspan="2">
											<label><b>C2. Capital</b></label>
										</td>
										<td class="separador"></td>
										<td class="label" colspan="2">
											<label><b>C3. Capacidad de Pago</b></label>
										</td>
										<td class="separador"></td>
										<td class="label" colspan="2">
											<label><b>C4. Condiciones</b></label>
										</td>
										<td class="separador"></td>
										<td class="label" colspan="2">
											<label><b>C5. Colaterales</b></label>
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Residencia:</label>
										</td>
										<td>
											<input type="text" id="totalResidencia" name="totalResidencia" path="totalResidencia" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Deuda Actual:</label>
										</td>
										<td>
											<input type="text" id="totalDeudaActual" name="totalDeudaActual" path="totalDeudaActual" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Cobertura:</label>
										</td>
										<td>
											<input type="text" id="totalCobertura" name="totalCobertura" path="totalCobertura" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Estabilidad de ingresos:</label>
										</td>
										<td>
											<input type="text" id="totalEstabilidadIng" name="totalEstabilidadIng" path="totalEstabilidadIng" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label"><label>Garantias:</label></td>
										<td><input type="text" id="colaterales" name="colaterales" readonly="readonly" style="text-align: right;"> </td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Ocupación:</label>
										</td>
										<td>
											<input type="text" id="totalOCupacion" name="totalOCupacion" path="totalOCupacion" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Deuda con el Crédito:</label>
										</td>
										<td>
											<input type="text" id="totalDeudaCredito" name="totalDeudaCredito" path="totalDeudaCredito" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Gastos sin el Crédito:</label>
										</td>
										<td>
											<input type="text" id="totalGastos" name="totalGastos" path="totalGastos" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Sobre su Negocio:</label>
										</td>
										<td>
											<input type="text" id="totalNegocio" name="" totalNegocio"" path="" totalNegocio""  size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Mora:</label>
										</td>
										<td>
											<input type="text" id="totalMora" name="totalMora" path="totalMora" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Gastos Con el Crédito:</label>
										</td>
										<td>
											<input type="text" id="totalGastosCredito" name="totalGastosCredito" path="totalGastosCredito" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="RFClbl">Afiliación y Ahorro:</label>
										</td>
										<td>
											<input type="text" id="totalAfiliacion" name="totalAfiliacion" path="totalAfiliacion" readonly="true" size="8" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<br> <label for="RFClbl">Puntaje Total:</label>
										</td>
										<td>
											<br> <input type="text" id="puntosTotal" name="puntosTotal" size="8" readonly="true" style="text-align: right;" />
										</td>
										<td class="separador"></td>
										<td class="label" nowrap="nowrap">
											<br> <label for="RFClbl">Nivel de Riesgo:</label>
										</td>
										<td>
											<br> <input type="text" id="nivelRiesgo" name="nivelRiesgo" size="15" readonly="true" />
										</td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
										<td class="separador"></td>
									</tr>
								</table> <br>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<br>
							<table style="width: 100%">
								<tr>
									<td align="right">
										<input type="submit" id="generar" name="generar" value="Generar" tabindex="100" class="submit" />
										<input type="submit" id="guardar" name="guardar" value="Guardar" tabindex="100" class="submit" />
										<input type="button" id="rechazar" name="rechazar" value="Rechazar" tabindex="100" class="submit" />
										<input type="button" id="regresar" name="regresar" value="Regresar al Ejecutivo" tabindex="100" class="submit" />
										<input type="button" id="procesar" name="procesar" value="Procesar" tabindex="100" class="submit" />
										<input type="button" id="imprimir" name="imprimir" value="Imprimir" tabindex="102" class="submit"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" tabindex="102" />
										<input type="hidden" id="numDepenEconomi" name="numDepenEconomi" size="5" readonly="true"/>
										<input type="hidden" id="SocioEMontoAlimentacion" name="SocioEMontoAlimentacion" size="5" readonly="true" />
										<input type="hidden" id="gastosPasivos" name="gastosPasivos" size="5" readonly="true" />
										<input type="hidden" id="IDGastoAlimenta" name="IDGastoAlimenta" size="5" readonly="true" />
										<input type="hidden" id="relGarantCred" name="relGarantCred" size="5" readonly="true" />
										<input type="hidden" id="porcentajeCob" name="porcentajeCob" readOnly="true" size="15" style="text-align: right;" />
										<input type="hidden" id="gastosRural" name="gastosRural" path="gastosRural" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
										<input type="hidden" id="gastosUrbana" name="gastosUrbana" readOnly="true" esMonto="true" size="15" style="text-align: right;" />
									</td>
								</tr>
								<tr>
									<td>
										<br>
										<br>
										<div id="gridComentarios" style="display: none">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend id="legendRegreso" style="display: none">Regresar Solicitud a Ejecutivo</legend>
												<legend id="legendRechazo" style="display: none">Rechazar Solicitud</legend>
												<legend id="legendProceso" style="display: none">Procesar Solicitud</legend>
												<table>
													<tr>
														<td class="label">
															<label id="comentariosRegreso" for="lblComentarioEjec">Motivo de Devoluci&oacute;n: </label>
															<label id="comentariosRechazo" for="lblComentarioEjec">Motivo de Rechazo: </label>
															<label id="comentariosProceso" for="lblComentarioEjec">Terminos y Condiciones: </label>
														</td>
														<td>
															<textarea id="comentarioEjecutivo" name="motivo" path="motivo" maxlength="1000" tabindex="24" COLS="38" ROWS="4" onBlur=" ponerMayusculas(this);"  />
														</td>
														<td class="separador"></td>
														<td>
															<input type="submit" id="guardarRechazo" name="guardarRechazo" class="submit" value="Guardar" tabindex="23" style="display: none"/>
															<input type="submit" id="guardarRegresar" name="guardarRegresar" class="submit" value="Guardar" tabindex="23" style="display: none"/>
															<input type="submit" id="guardarProcesar" name="guardarProcesar" class="submit" value="Guardar" tabindex="23" style="display: none"/>
														</td>
													</tr>
												</table>
											</fieldset>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<!-- contenedorForma -->
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>