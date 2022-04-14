<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html> 
<head>
	<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasCedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
  
	<script type="text/javascript" src="js/cedes/reimpresionPagareCedes.js"></script>

<title>Autorizaci&oacute;n de Inversiones</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reimpresi&oacute;n de Pagar&eacute; de CEDES</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reimpPagareCedes" >
		
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label">
						<label>CEDE:</label>
					</td>

					<td>
						<form:input type="text" name="cedeID" id="cedeID" path="cedeID" size="11" autocomplete="off" tabIndex="1"/>
					</td>	

					<td class="label">
						<label>Estatus:</label>
					</td>

					<td>
						<input type="text" id="estatus" name="estatus" size="15" readonly="readonly"/>
					</td>
				</tr>

				<tr>
					<td>
						<label><s:message code="safilocale.cliente"/>:</label>
					</td>
					
					<td>
						<input type="text" name="clienteID" id="clienteID" size="9"  readonly="true" />
						<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"  readonly="true" />
					</td>				
				</tr>

				<tr >
					<td>
						<label>Direcci&oacute;n:</label>
					</td>
					
					<td>
						<textarea rows="3" cols="80" name="direccion" id="direccion" readonly="true" >
						</textarea>
					</td>

					<td colspan="2">
						<table border="0" width="100%">
							<tr>
								<td>
									<label>Tel&eacute;fono:</label>
								</td>
								
								<td>
									<input type="text" name="telefono" id="telefono" size="15" readonly="true" />
								</td>
							</tr>
						</table>
					</td>
				</tr>	

				<tr>
					<td colspan='4'>&nbsp;</td>
				</tr>
				
				<tr>
					<td>
						<label>Cuenta Cobro:</label>
					</td>
					
					<td>
						<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" autocomplete="off" readonly="true" />&nbsp;&nbsp;&nbsp;
						<label>Saldo&nbsp;:</label>
						<input type="text" id="saldoCuenta" name="saldoCuenta" style="text-align: right;" size="15" readonly="true" esMoneda="true"/>
						<input type="hidden" name="monedaID" id="monedaID" />
						<label id="tipoMoneda"></label>
					</td>
					
					<td colspan="2"></td>
				</tr>

				<tr>
					<td>
						<label>Tipo de CEDE:</label>
					</td>
					
					<td colspan="3">
						<form:input id="tipoCedeID" name="tipoCedeID" path="tipoCedeID" size="7" autocomplete="off" readonly="true" />
						<input type="text" id="descripcion" name="descripcion" size="32" readonly="true"  />
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;
						<label id="lblfechaApertura">Fecha Apertura:</label>
						<form:input id="fechaApertura" name="fechaApertura" path="fechaApertura" size="20" autocomplete="off" readonly="true"  />
					</td>
				</tr>				
				
				<tr>
					<td colspan='4' >&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="4">					
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Condiciones</legend>
						<table border="0">
							<tr>
								<td>
									<label>Monto:</label>
								</td>
								
								<td>
									<form:input name="monto" id="monto" size="18" path="monto" readonly="true"  esMoneda="true" style="text-align: right;"/>
									<label id="tipoMonedaCed"></label>													
								</td>
								
								<td id="tdlblTasaBruta">
									<label>Tasa Bruta: </label>
								</td>
								
								<td id="tdtasaBruta" nowrap="nowrap">
									<form:input type="text" name="tasaFija" id="tasaFija" path="tasaFija" size="12" style="text-align: right;" readonly="true"  esTasa="true"/><label>%</label>
								</td>
																
								<td>&nbsp;&nbsp;</td>
								
								<td id="tdlblIntGenerado">
									<label>Int&eacute;res Generado:</label>
								</td>
								
								<td id="tdIntGenerado">
									<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" style="text-align: right;" size="18" readonly="true"  esMoneda="true"/>
								</td>
							</tr>

							<tr>
								<td>
									<label>Plazo: </label>
								</td>
								
								<td>
									<input type="text" name="plazoOriginal" id="plazoOriginal"  size="18"  autocomplete="off" 	readOnly="true"	style="text-align: right;"  />
								</td>	
								
								<td>
									<label>Tasa ISR:</label>
								</td>
								
								<td nowrap="nowrap">
									<form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" style="text-align: right;" readonly="true" value="0.00" size="12"  esTasa="true"/><label>%</label>
								</td>

								<td>&nbsp;&nbsp;</td>
								
								<td>
									<label>ISR a Retener:</label>
								</td>
								
								<td>
									<form:input name="interesRetener" id="interesRetener" path="interesRetener" style="text-align: 	right;" size="18" readonly="true"  esMoneda="true"/>
								</td>
							</tr>
							
							<tr>
								<td>
									<label>
										D&iacute;as a Pagar de Inter&eacute;s:
									</label>
								</td>

								<td>
									<form:input type="text" name="plazo" id="plazo" path="plazo"  size="18" readonly="true" style="text-align: right;" />
								</td>							
								
								<td>
									<label>Tasa Neta:</label>
								</td>
								
								<td nowrap="nowrap">
									<form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" style="text-align: right;" size="12" readonly="true" esTasa="true" /><label>%</label>
								</td>

								<td>&nbsp;&nbsp;</td>
								
								<td>
									<label>Int&eacute;res Recibir:</label>
								</td>
								
								<td>
									<form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" style="text-align: right;" size="18" readonly="true"  esMoneda="true"/>
								</td>
							</tr>

							<tr>
								<td>
									<label>Fecha de<br>Inicio:</label>
								</td>
								
								<td>
									<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" size="18" readonly="true" />
								</td>

								<td class="label">
									<label for="lbconsultaGAT">GAT Nominal: </label>
								</td>
							
								<td nowrap="nowrap">
									<input type="text" name="valorGat" id="valorGat" size="12" readonly="true" style="text-align: right;"/><label for="lbconsultaGAT">%</label>
								</td>

								<td class="separador"/>																	
								
								<td class="label">
									<label for="valorGatReal">GAT Real: </label>
								</td>
							
								<td nowrap="nowrap">
									<input type="text" name="valorGatReal" id="valorGatReal"  size="18" readonly="true" style="text-align: right;"/><label for="valorGatReal">%</label>
								</td>									
							</tr>

							<tr>
								<td>
									<label>Fecha de<br>Vencimiento:</label>
								</td>
								
								<td>
									<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="18" readonly="true" />
								</td>

								<td id="tdlblCalculoInteres">
									<label id="lblCalculoInteres">C&aacute;lculo Inter&eacute;s:</label>
								</td>
								
								<td id="tdcalculoInteres">
									<input id="desCalculoInteres" type="text" name="desCalculoInteres" size="40" readonly="true"/>
								</td>

								<td>
								</td>

								<td id="tdlblTasaBaseID" nowrap="nowrap">
									<label id="lblTasaBaseID">Tasa Base:</label>

								</td>
								
								<td id="tdDesTasaBaseID">
									<input id="destasaBaseID" name="destasaBaseID" size="12" readonly="true"/>
								</td>
								
								<td>&nbsp;&nbsp;</td>									
							</tr>
							
							<tr id='trVariable1'>
								<td id='tdlblSobreTasa'>
									<label id="lblSobreTasa">Sobre Tasa: </label>
								</td>

								<td>
									<form:input type="text" name="sobreTasa" id="sobreTasa" path="sobreTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
								</td>

								<td >
									<label id="lblPisoTasa">Piso Tasa: </label>
								</td>

								<td>
									<form:input type="text" name="pisoTasa" id="pisoTasa" path="pisoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
								</td>

								<td>
								</td>
							
								<td >
									<label id="lblTehoTasa">Techo Tasa: </label>
								</td>

								<td>
									<form:input type="text" name="techoTasa" id="techoTasa" path="techoTasa" size="12" readonly="true" esTasa="true"  style="text-align: right;"/>
								</td>
							</tr>							

							<tr>
								<td colspan="7">&nbsp;</td>
								
								<td align="right">
									<label>Total a Recibir:</label>
								</td>

								<td>
									<input type="text" name="totalRecibir" id="totalRecibir" readonly="true" esMoneda="true" style="text-align: right;"	size="18"/>
								</td>
							</tr>							
						</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td id="tdCajaRetiro" colspan="5" style="display:none">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Lugar de Retiro al Vencimiento: </legend>
							<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="cajaRetiro">Caja: </label>
								</td>
								<td nowrap="nowrap">
						 			<form:input id="cajaRetiro" name="cajaRetiro" path="cajaRetiro" size="4" readonly="true" maxlength="11"/>
									<input type="text" id="nombreCaja" name="nombreCaja" size="47" readOnly="true" />
								</td>
							</tr>
							</table>
						</fieldset>
					</td>
				</tr>			
				<tr>
					<td colspan='4'>&nbsp;</td>
				</tr>
			</table>
		</fieldset>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<a id="enlace"  target="_blank">
		                     				<button type="button" class="submit" id="imprimePagare" name="imprimePagare" tabIndex="3" >
		                              			Imprimir Pagar&eacute;
		                      				</button>
										</a>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										<input type="hidden" id="tipoTasa">	
										<input type="hidden" id="sobreTasa">
										<input type="hidden" id="pisoTasa">
										<input type="hidden" id="techoTasa">								
									</td>
								</tr>
							</table>
						</td>
					</tr>	
				</table>
		</form:form>
		</fieldset>
	</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>
</body>
</html>