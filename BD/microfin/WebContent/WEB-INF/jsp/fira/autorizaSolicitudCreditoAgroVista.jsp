<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
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
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposLineasAgroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
		<script type="text/javascript" src="js/fira/autorizaSolicitudCredito.js"></script>
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
					<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n de Solicitud de Cr&eacute;dito</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblsolicitud">Solicitud de Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" tabindex="1" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblProspecto">Prospecto: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="prospectoID" name="prospectoID" path="prospectoID" size="12" readOnly = "true"/>
								<input type="text" id="nombreProspecto" name="nombreProspecto"size="50" readOnly="true"  />
							</td>
						</tr>
						<tr>
							<td>
								<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="clienteID" name="clienteID" path="clienteID" size="12" readOnly = "true"/>
								<input id="nombreCte" name="nombreCte"size="50" type="text" readOnly="true"  />
								<input id="estatusCliente" name="estatusCliente" type="hidden"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblProducto">Producto de Cr&eacute;dito: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" type="text" readOnly = "true" />
								<input id="descripProducto" name="descripProducto"size="50" type="text" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblfecRegistro">Fecha de Registro: </label>
							</td>
							<td>
								<form:input id="fechaInicio" name="fechaInicio" path="fechaRegistro" size="12"  readOnly = "true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblfechaAutoriza">Fecha de Autorizaci&oacute;n: </label>
							</td>
							<td>
								<form:input id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="12"   />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblPromotor">Promotor: </label>
							</td>
							<td>
								<form:input id="promotorID" name="promotorID" path="promotorID" size="12"  readOnly = "true" />
								<input id="nombrePromotor" name="nombrePromotor"size="50" type="text" readOnly="true"   />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblNumCred">No. Cr&eacute;ditos: </label>
							</td>
							<td >
								<form:input id="numCreditos" name="numCreditos" path="numCreditos" size="12"  readOnly = "true" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="lblRelacionado">Relacionado: </label>
							</td>
							<td>
								<form:input id="relacionado" name="relacionado" path="relacionado" size="12"  readOnly = "true" />
							</td>
							<td class="separador"></td>
							<td>
								<label for="lblAporte">Aporte de <s:message code="safilocale.cliente"/>: </label>
							</td>
							<td>
								<form:input id="aporteCliente" name="aporteCliente" path="aporteCliente" size="12"  readOnly = "true"  esMoneda="true" style="text-align:right;" />
							</td>
						</tr>
						<tr>
							<td>
								<label for="lblEstatus">Estatus: </label>
							</td>
							<td>
								<form:select id="estatus" name="estatus" path="estatus"  tabindex="2" disabled= "true">
									<form:option value="I">INACTIVO</form:option>
									<form:option value="A">AUTORIZADO</form:option>
									<form:option value="C">CANCELADO</form:option>
									<form:option value="R">RECHAZADO</form:option>
									<form:option value="D">DESEMBOLSADO</form:option>
									<form:option value="L">LIBERADA</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblsolicitado">Monto Solicitado: </label>
							</td>
							<td>
								<form:input id="montoSolici" name="montoSolici" path="montoSolici" size="12"  esMoneda="true" readOnly = "true" style="text-align: right;"  />
								<input type="hidden" id="tipoPagoCapital" name="tipoPagoCapital"  size="12" tabindex="3" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblAutorizado">Monto Autorizado: </label>
							</td>
							<td>
								<form:input id="montoAutorizado" name="montoAutorizado" path="montoAutorizado" size="12" tabindex="12" esMoneda="true" style="text-align: right;" />
								<input type="hidden" id="montoA" name="montoA"  size="12" tabindex="4" esMoneda="true" />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblMoneda">Moneda: </label>
							</td>
							<td >
								<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="5" disabled = "true">
									<form:option value="-1">Seleccionar</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td>
								<label for="lblSucursal">Cuenta CLABE: </label>
							</td>
							<td>
								<form:input id="cuentaCLABE" name="cuentaCLABE" path="cuentaCLABE" size="21"  readOnly = "true" />

							</td>
							<td class="separador"></td>
							<td>
								<label for="lblSucursal">Sucursal: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="12" readOnly= "true" />
								<input type="text" id="nombreSucursal" name="nombreSucursal"size="50" readOnly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblPlazo">Plazo: </label>
							</td>
							<td>
								<form:select  id="plazoID" name="plazoID" path="plazoID" tabindex="6" disabled = "true">
									<form:option value="0">Selecciona</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblAutorizado">Fecha de Vencimiento: </label>
							</td>
							<td>
								<input id="fechaVencimiento" name="fechaVencimiento" size="12" readOnly = "true">
							</td>
						</tr>
						<tr name="tasaBase">
							<td class="label">
								<label for="lblcalInter">C&aacute;lculo de Inter&eacute;s </label>
							</td>
							<td>
								<form:select id="calcInteres" name="calcInteres" path="" tabindex="7" disabled= "true">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tasaFija">Tasa Resultante: </label>
							</td>
							<td>
								<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" size="8" tabindex="8" esTasa="true" readOnly="true" style="text-align: right;"/>
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr name="tasaBase">
							<td class="label">
								<label for="TasaBase">Tasa Base: </label>
							</td>
							<td>
								<input type="text" id="tasaBase" name="tasaBase" path="tasaBase" size="8" readonly="true" disabled="true" tabindex="9"  />
								<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="10"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="SobreTasa">Tasa Base Actual: </label>
							</td>
							<td>
								<input type="text" id="tasaBaseValor" name="tasaBaseValor" path="" size="8"
									esTasa="true" tabindex="11" readOnly="true" style="text-align: right;"/>
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr name="tasaBase">
							<td class="label">
								<label for="SobreTasa">SobreTasa: </label>
							</td>
							<td>
								<input type="text" id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" esTasa="true" tabindex="12" readOnly="true" style="text-align: right;"/>
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
							<td class="label" name="tasaPisoTecho">
								<label for="PisoTasa">Piso Tasa: </label>
							</td>
							<td name="tasaPisoTecho">
								<input type="text" id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8" style="text-align: right;" esTasa="true" readOnly="true" tabindex="13"/>
								<label for="porcentaje">%</label>
							</td>
						</tr>
						<tr name="tasaBase">
							<td class="label" name="tasaPisoTecho">
								<label for="TechoTasa">Techo Tasa: </label>
							</td>
							<td name="tasaPisoTecho">
								<input type="text" id="techoTasa" name="techoTasa" path="techoTasa" size="8" style="text-align: right;" esTasa="true" readOnly="true" tabindex="14" />
								<label for="porcentaje">%</label>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td>
								<label for="lblDestino">Destino de Cr&eacute;dito: </label>
							</td>
							<td nowrap="nowrap">
								<form:input id="destinoCreID" name="destinoCreID" path="destinoCreID" size="12"  readOnly = "true" />
								<textarea id="descripDestino" name="descripDestino" COLS="36" ROWS="2"  readOnly="true"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblProyecto">Proyecto: </label>
							</td>
							<td >
								<form:textarea id="proyecto" name="proyecto" path="proyecto"  COLS="38" ROWS="4" readOnly = "true"/>
							</td>
						</tr>
						<tr>
							<td class="label"  id = "tdGrupolbl" style="display: none;">
								<label for="lblgrupoID">Grupo: </label>
							</td>
							<td id = "tdGrupo" style="display: none;">
								<form:input id="grupoID" name="grupoID" path="grupoID" size="12" tabindex="15" type="text" disabled = "true" />
								<input id="nomGrupo" name="nomGrupo" size="50" tabindex="16" type="text" disabled = "true">
							</td>
						</tr>
					</table>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>L&iacute;nea Cr&eacute;dito</legend>
						<table>
							<tr>
								<td class="label">
									<label for="lbllineaCreditoID">L&iacute;nea Cr&eacute;dito: </label>
								</td>
								<td nowrap="nowrap">
									<form:input type="text" id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="15" tabindex="17" numMax ="12" disabled="true" />
									<input type="text" id="tipoLineaAgroID" name="tipoLineaAgroID" size="40" onBlur=" ponerMayusculas(this);" disabled="true" />
								</td>
								<td class="separador"></td>
								<td class="label">
									<label for="lblSaldoActual">Saldo Disponible: </label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="saldoDisponible" name="saldoDisponible" size="15" tabindex="18" esMoneda="true" style="text-align: right" onkeypress="return ingresaSoloNumeros(event,2,this.id);" disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblfechaVencimiento">Fecha Vencimiento L&iacute;nea: </label>
								</td>
								<td>
									<form:input id="fechaVencimientoLinea" name="fechaVencimiento" path="fechaVencimiento" size="15" tabindex="19" disabled="true" />
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<br>
					<table>
						<tr>
							<td>
								<div id="gridFirmasOtorgadas" style="display: none; width:50%" >  </div>
								<div id="gridFirmasAutoriza" style="display: none;" width="50%">  </div>
								<div id="gridFirmas" style="display: none;">  </div>
								<input type="hidden" id="detalleFirmasAutoriza" name="detalleFirmasAutoriza" size="100" />
							</td>
						</tr>
					</table>
					<div id="comentarioAltaSolicitud" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all"  style="color:#F00101">
							<legend style="color:#F00101">Historial de Comentarios</legend>
							<table border="0" >
								<tr>
									<td>
										<textarea  id="comentariosEje" name="comentariosEje"   COLS="60" ROWS="4" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" readOnly="true" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<table align="center">
						<tr>
							<td>
								<input type="button" id="rechazar" name="rechazar" class="submit" value="Rechazar" tabindex="20"  />
							</td>
							<td class="separador"></td>
							<td>
								<input type="button" id="regresarEjec" name="regresarEjec" class="submit" value="Regresar a Ejecutivo" tabindex="21"  />
							</td>
							<td class="separador"></td>
							<td align="right">
								<input type="button" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="22"  />
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="usuarioAutoriza" name="usuarioAutoriza"/>
								<input id="montoProd" name="montoProd"  size="15" type="hidden" esMoneda="true" disabled = "true"/>
							</td>
						</tr>
					</table>
					<div id="gridComentariosRechazoRegreso" style="display: none;" >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend id="legendRegreso" style="display: none;">Regresar Solicitud a Ejecutivo</legend>
							<legend id="legendRechazo" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rechazar Solicitud &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</legend>
							<table >
								<tr >
									<td class="label" >
										<label id="eComentario" for="lblComentarioEjec">Comentarios:  </label>
									</td>
									<td>
										<form:textarea  id="comentarioEjecutivo" name="comentarioEjecutivo" path="comentarioEjecutivo" maxlength ="500" tabindex="23" COLS="38" ROWS="4" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" />
									</td>
									<td class="separador"></td>
									<td>
										<input type="submit" id="guardarRechazo" name="guardarRechazo" class="submit" value="Guardar" tabindex="24" style="display: none;"  />
									</td>
									<td>
										<input type="submit" id="guardarRegresar" name="guardarRegresar" class="submit" value="Guardar" tabindex="25" style="display: none;" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<div id="gridComentariosAutoriza" style="display: none;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend id="legendAutoriza">Autorizar Solicitud</legend>
							<table>
								<tr>
									<td class="label">
										<label for="lblComentarioEjec">T&eacute;rminos Y <br/> Condiciones : </label>
									</td>
									<td>
										<form:textarea  id="comentarioMesaControl" name="comentarioMesaControl" path="comentarioMesaControl" tabindex="26" COLS="38" ROWS="4" onBlur=" ponerMayusculas(this); limpiarCajaTexto(this.id);" maxlength="500" />
									</td>
									<td class="separador"></td>
									<td>
										<input type="submit" id="guardarAutoriza" name="guardarAutoriza" class="submit" value="Guardar" tabindex="27" />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista" ></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;" ></div>
</html>