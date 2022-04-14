<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>

	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/aportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
    <script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/aportaciones/cancelaAportaciones.js"></script>


<title>Cancelaci&oacute;n de Aportaciones</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Cancelaci&oacute;n de Aportaci&oacute;n</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesBean" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0"  width="100%">
					<tr>
						<td width="10%">
							<label>Aportaci&oacute;n: </label>
						</td>
						<td width="30%">
							<form:input type="text" name="aportacionID" id="aportacionID" path="aportacionID" size="11"  autocomplete="off" tabindex="1" />
							<form:input type="hidden" name="estatus" id="estatus" path="estatus" size="15" readonly="true"/>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>
							<label><s:message code="safilocale.cliente"/>: </label>
						</td>

						<td>
							<form:input type="text" name="clienteID" id="clienteID" size="11" tabIndex = "2"  autocomplete="off" path="clienteID" readonly="true"/>
							<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"   readonly="true" readonly="true"  />
							<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />
						</td>
					</tr>

					<tr>
						<td>
							<label>Tipo de Aportaci&oacute;n:  &nbsp;</label>
						</td>
						<td nowrap="nowrap">
							<form:input id="tipoAportacionID" name="tipoAportacionID" path="tipoAportacionID" tabIndex = "7" size="6"  autocomplete="off" readonly="true"/>
							<input type="text" id="descripcion" name="descripcion"  size="40" readonly="true"/>
							<input type="hidden" id="diaInhabil" name="diaInhabil"  size="5" readonly="true" />
							<input type="hidden" id="esDiaHabil" name="esDiaHabil"  size="5" readonly="true" />
						</td>
					</tr>
					<tr>
						<td>
							<label>Tipo de Pago:</label>
						</td>
						<td>
							<select id="tipoPagoInt" name="tipoPagoInt" tabindex="8">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
						<td class="separador"></td>
						<td colspan="4" nowrap="nowrap">
							<label id="lbldiasPago">D&iacute;as Pago:</label>
							<select id="diasPagoInt" name="diasPagoInt" tabindex="9">
							</select>
						</td>
					</tr>

				<tr >
					<td colspan="4">

					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Condiciones</legend>
						<table border="0">
							<tr class="trMontoGlobal" style="display: none;">
								<td>
									<label>Monto Global: </label>
								</td>
								<td nowrap="nowrap">
									<form:input name="montoGlobal" id="montoGlobal" size="18" path="montoGlobal" esMoneda="true" autocomplete="off" tabIndex = "10" style="text-align: right;" readonly="true" />
								</td>
							</tr>
							<tr>
								<td>
									<label>Monto:</label>
								</td>

								<td nowrap="nowrap">
									<form:input name="monto" id="monto" size="18" path="monto" esMoneda="true" style="text-align: right;" readonly="true" />
									<label id="tipoMonedaInv"></label>
								</td>

								<td>
									<label>Tasa Bruta:</label>
								</td>

								<td nowrap="nowrap">
									<form:input type="text" name="tasaFija" id="tasaFija" path="tasaFija" size="12" style="text-align: right;" readonly="true"  esTasa="true"/><label>%</label>
								</td>

								<td>&nbsp;&nbsp;</td>

								<td>
									<label>Inter&eacute;s Generado:</label>
								</td>

								<td>
									<form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" style="text-align: right;" size="18" readonly="true"  esMoneda="true"/>
								</td>
								<td colspan="2" >
									<label >Tipo de Reinversi&oacute;n: </label>
								</td>
							</tr>

							<tr>
								<td>
									<label>Plazo: </label>
								</td>

								<td>
									<form:input name="plazoOriginal" id="plazoOriginal" path="plazoOriginal" size="10" tabIndex = "7" autocomplete="off"  style="text-align: right;" readonly="true"/><label>D&iacute;as</label>
								</td>

								<td>
									<label>Tasa ISR:</label>
								</td>

								<td nowrap="nowrap">
									<form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" size="12" style="text-align: right;" readonly="true" value="0.00"  esTasa="true"/><label>%</label>
								</td>

								<td>&nbsp;&nbsp;</td>

								<td>
									<label>ISR a Retener:</label>
								</td>

								<td>
									<form:input name="interesRetener" id="interesRetener" path="interesRetener" style="text-align: right;" size="18" readonly="true"  esMoneda="true"/>
								</td>

								<td colspan="2">
										<form:input type="radio" name="reinvertir" id="reinvertirPost" value="F" path="reinversion" tabindex="12" /><label id="reinvPost">Posteriormente</label>
								</td>

							</tr>

							<tr>
								<td>
									<label>
										D&iacute;as a Pagar de Inter&eacute;s:
									</label>
								</td>

								<td>
									<form:input name="plazo" id="plazo" path="plazo" size="18" style="text-align: right;"	 readonly="true" />
								</td>

								<td>
									<label>Tasa Neta:</label>
								</td>

								<td nowrap="nowrap">
									<form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" style="text-align: right;" size="12" readonly="true" esTasa="true" /><label>%</label>
								</td>

								<td>&nbsp;&nbsp;</td>

								<td>
									<label>Inter&eacute;s Recibir:</label>
								</td>

								<td>
									<form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" style="text-align: right;" size="18" readonly="true"  esMoneda="true"/>
								</td>
							</tr>

							<tr>
								<td>
									<label>Fecha de Inicio:</label>
								</td>

								<td>
									<form:input type="text" name="fechaInicio" id="fechaInicio" path="fechaInicio" size="18" readonly="true" autocomplete="off"/>
								</td>

								<td class="label">
									<label for="lbconsultaGAT">GAT Nominal: </label>
								</td>

								<td nowrap="nowrap">
									<input type="text" name="valorGat" id="valorGat"path="valorGat" size="12" readonly="true" 	style="text-align: right;"/><label for="lbconsultaGAT">%</label>
								</td>

								<td class="separador"/>

								<td class="label">
									<label for="valorGatReal">GAT Real: </label>
								</td>

								<td nowrap="nowrap">
									<input type="text" name="valorGatReal" id="valorGatReal" path="valorGatReal" size="12" readonly="true" style="text-align: right;"/><label for="valorGatReal">%</label>
								</td>

							</tr>

							<tr>
								<td>
									<label>Fecha de Vencimiento:</label>
								</td>
								<td>
									<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" path="fechaVencimiento" size="18" readonly="true" />
								</td>



								<td>&nbsp;&nbsp;</td>
							</tr>
							<tr>
								<td id="lblDiaCapInteres">
									<label>
										Capitaliza Inter&eacute;s:
									</label>
								</td>
								<td id="inputDiaCapInt">
									<form:select id="capitaliza" name="capitaliza" path="capitaliza" tabindex="13">
									</form:select>
								</td>
							</tr>

							<tr>
								<td colspan="7">&nbsp;</td>

								<td nowrap="nowrap">
									<label>Total a Recibir:</label>
									<input name="totalRecibir" id="totalRecibir" type="text" readonly="true" esMoneda="true" size="18" style="text-align: right;"/>
								</td>
							</tr>
						</table>
						<table align="left">
							<tr >
								<td>
									<label  id="labelNotas" for="lblNotas">Notas: </label>
								</td>
								<td class="separador"></td>
								<td colspan="8">&nbsp;</td>
								<td colspan="6" style="padding: 2px;">
									<textarea id="notas" name="notas" rows="2" cols="52" 
												style="margin: 2px; width: 620px; height: 64px;" maxlength="500">
									</textarea>
								</td>
								<td class="separador"></td>
							</tr>
						</table>
						<table align="left" id="tablaComentario">
							<tr>
								<td>
									<label  id="labelHistorialCom" for="lblComentarios">Especificaciones: </label>	 					
								</td>
								<td>
									<div id="comentHistorial"  >  
										<textarea id="comentAport" name="comentAport" disabled rows="2" cols="52" 
												style="margin: 2px; width: 620px; height: 64px;" ></textarea>
									</div>					
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
		<br>
		<div id="contenedorSim">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend >Calendario de Pagos: </legend>
				<br>
				<div id="contenedorSimulador" style="overflow-y: scroll; width: 100%; height: 300px;display: none;"></div>
			</fieldset>
		</div>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td colspan="4">
					<table align="right" boder='0'>
						<tr>
							<td align="right">
								<input type="submit" id="cancela" name="cancela"
										 class="submit"  value="Cancelar" tabIndex="2"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"/>
</body>
</html>
