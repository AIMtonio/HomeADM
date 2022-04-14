<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/avalesPorSoliciServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	   <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoRecomendasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoResultadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoRealizadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoManualServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoMotNoPagoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/segtoOrigenPagoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/resultadoSegtoCobranzaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/resultadoSegtoDesProyServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
		 <script type="text/javascript" src="dwr/interface/socDemoConyugServicio.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js" charset="utf-8"></script> 
		<script type="text/javascript" src="js/seguimiento/capturaSegtoResultado.js"></script> 
 	  	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="segtoRealizadosBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Captura de Seguimiento Realizado</legend>			
					<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
			 			<tr>
							<td nowrap="nowrap">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<table border="0" cellpadding="0" cellspacing="0" >
						 				<tr>
	 										<td class="label" nowrap="nowrap">
												<label for="lblsegtoProgra">Secuencia Seguimiento: </label>
											</td>
											<td colspan="4">
												<input type="text" id="segtoPrograID" name="segtoPrograID" tabindex="1" size="12" autocomplete="off"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblcreditoID">Cr&eacute;dito: </label>
											</td>
											<td colspan="4">
								    			<input type="text" id="creditoID" name="creditoID" size="12" readonly="true"/>
												<input type="text" id="nombreCompleto" name="nombreCompleto" onBlur="ponerMayusculas(this)" size="45" disabled="true" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblgrupoID">Grupo: </label>
											</td>
											<td colspan="4">
												<input type="text" id="grupoID" name="grupoID" size="12" readonly="true"/>
												<input type="text" id="nombreGrupo" name="nombreGrupo" size="45" onBlur="ponerMayusculas(this)" 
														disabled="true" readonly="readonly" />
												<input type="hidden" id="nomPresidente" name="nomPresidente" readonly="true"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblprodCredID">Categor&iacute;a:</label>
											</td>
											<td>
												<input type="text" id="categoriaID" name="categoriaID" path="categoriaID" size="12"
														disabled="true" readonly="readonly"/> 
        										<input type="text" id="descripcionCat" name="descripcionCat" size="45"
        												disabled="true" readonly="readonly"/>
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblestatusPro">Estatus:</label>
											</td>
											<td>
												<select id="estatusProg" name="estatusProg" path="estatusProg" >
													<option value="">SELECCIONAR</option>
													<option value="P">PROGRAMADO</option>
													<option value="I">INICIADO</option>
													<option value="T">TERMINADO</option>
													<option value="C">CANCELADO</option>
													<option value="R">REPROGRAMADO</option>
													<option value="A">AUTORIZADO</option>
												</select> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblgestorID">Gestor:</label>
											</td>
											<td>
												<input type="text" id="puestoResponsableID" name="puestoResponsableID"  size="12" readonly="readonly" /> 
												<input type="text" id="nombreUsuario" name="nombreUsuario" size="45" readonly="readonly" />
											</td>
											<td class="separador"></td>
											<td colspan="2" rowspan="4">
												<fieldset class="ui-widget ui-widget-content ui-corner-all">
													<legend class="label"><label>Forzado</label></legend>
													<table border="0" cellpadding="0" cellspacing="0" >
						 								<tr>
						 									<td class="label" nowrap="nowrap">
																<label for="lblsegtoforza">Seguimiento Forzado: </label>								
															</td>
															<td>
																<input type="checkbox" id="segtoForzado" name="segtoForzado" value="S"
												   						disabled="true" readonly="readonly"/>
															</td>
														</tr>
														<tr>
															<td class="label" nowrap="nowrap">
																<label for="lblfechaForza">Secuencia Forzado:</label>
															</td>
															<td>
																<input type="text" id="secSegtoForzado" name="secSegtoForzado"  size="11"
																			disabled="true" readonly="readonly" /> 
															</td>
					 									</tr>
					 								</table>	
												</fieldset>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblsupervisorID">Supervisor:</label>
											</td>
											<td>
												<input type="text" id="puestoSupervisorID" name="puestoSupervisorID"  size="12" disabled="true" readonly="readonly"/> 
												<input type="text" id="nombreSupervisor" name="nombreSupervisor"  size="45"   disabled="true" readonly="readonly"/>
											</td>								
											<td class="separador"></td>								
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lbltipoGeneración">Tipo Generaci&oacute;n:</label>
											</td>
											<td>
												<input type="text" id="tipoGeneracion" name="tipoGeneracion" size="12" disabled="true" readonly="readonly"/> 
											</td>
											<td class="separador"></td>								
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblfechaProg">Fecha Programada:</label>
											</td>
											<td>
												<input type="text" id="fechaProg" name="fechaProg" size="12" disabled="true" readonly="readonly"/> 
											</td>
											<td class="separador"></td>
										</tr>
										<tr>
											<td class="label">
											<label for="telefonoCasa">Tel&eacute;fono Particular:</label>
											</td>
											<td>
												<input id="telefonoCasa" name="telefonoCasa" maxlength="15" path="telefonoCasa" size="15" readonly="true"/>
												<label for="ext">Ext.:</label>
												<input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" maxlength="6" readonly="true"/>
											</td>	
											<td class="separador"></td>
											<td class="label">
												<label for="telefonoCelular">Tel&eacute;fono Celular: </label>
											</td>
											<td>
											<input id="telefonoCelular" name="telefonoCelular" maxlength="15" size="15" readonly="true"/>
											</td>
										</tr>
									</table>	
								</fieldset>
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="label">Generales del Cr&eacute;dito</legend>	
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblsolicituID">Solicitud:</label>
											</td>
											<td>
												<input type="text" id="solicitudCreditoID" name="solicitudCreditoID" size="12"
														disabled="true" readonly="readonly"/> 
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblprodCredID">Producto:</label>
											</td>
											<td nowrap="nowrap">
												<input type="text" id="producCredID" name="producCredID" size="12"
														disabled="true" readonly="readonly"/>
												<input type="text" id="nombreProdCred" name="nombreProdCred" size="40"
														disabled="true" readonly="readonly"/>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblmontoSol">Monto Solicitado:</label>
											</td>
											<td>
												<input type="text" id="montoSolicitado" name="montoSolicitado" size="12" esMoneda="true"
														disabled="true" readonly="readonly" style="text-align: right;"/> 
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblmontoAut">Monto Autorizado:</label>
											</td>
											<td>
												<input type="text" id="montoAutorizado" name="montoAutorizado" size="12" esMoneda="true"
														disabled="true" readonly="readonly" style="text-align: right;"/> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblfechaSol">Fecha Solicitud:</label>
											</td>
											<td>
												<input type="text" id="fechaSol" name="fechaSol" size="12" 
													disabled="true" readonly="readonly"/> 
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblmontoAut">Fecha Desembolso:</label>
											</td>
											<td>
												<input type="text" id="fechaDesembolso" name="fechaDesembolso" size="12" 
													disabled="true" readonly="readonly"/> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblestatus">Estatus:</label>
											</td>
											<td>
												<input type="text" id="estatusCredito" name="estatusCredito" size="12" disabled="true" readonly="readonly" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblsaldoVig">Saldo Vigente:</label>
											</td>
											<td>
												<input type="text" id="saldoVigente" name="saldoVigente" size="12" esMoneda="true"
														disabled="true" readonly="readonly" style="text-align: right;"/> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lbldiasatra">D&iacute;as Atraso:</label>
											</td>
											<td>
												<input type="text" id="diasAtraso" name="diasAtraso" size="12" 
														disabled="true" readonly="readonly"/>
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblsaldoAtras">Saldo Atrasado:</label>
											</td>
											<td>
												<input type="text" id="saldoAtrasado" name="saldoAtrasado"  size="12" esMoneda="true"
													disabled="true" readonly="readonly" style="text-align: right;" /> 
											</td>
										</tr>								
										<tr>
											<td class="label" nowrap="nowrap"></td>
											<td class="label" nowrap="nowrap"></td>
											<td class="label" nowrap="nowrap"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblsaldoVencido">Saldo Vencido:</label>
											</td>
											<td>
												<input type="text" id="saldoVencido" name="saldoVencido" size="12" esMoneda="true"
													disabled="true" readonly="readonly" style="text-align: right;"/> 
											</td>
										</tr>
									</table>
								</fieldset>		
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend class="label">Seguimiento</legend>	
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblfechaProg">N&uacute;mero Consecutivo:</label>
											</td>
											<td>
												<input type="text" id="segtoRealizaID" name="segtoRealizaID"  tabindex="2" size="12"/> 
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblprodCredID">Fecha Seguimiento:</label>
											</td>
											<td>
												<input type="text" id="fechaSegto" name="fechaSegto"  tabindex="3" size="12" esCalendario="true"/> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblgestorID">Responsable Segto:</label>
											</td>
											<td>
												<input type="text" id="usuarioSegto" name="usuarioSegto"  tabindex="4" size="12" /> 
												<input type="text" id="nombreUsuarioSegto" name="nombreUsuario" size="45" disabled="true" />
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblsupervisorID">Fecha Captura:</label>
											</td>
											<td>
												<input type="text" id="fechaCaptura" name="fechaCaptura" size="12" disabled="true"  />
												<label>Hora:</label>
												<input type="text" id="horaCaptura" name="horaCaptura" size="5" tabindex="5" /> 
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lbltipoGeneración">Persona Atendi&oacute;:</label>
											</td>
											<td>
												<select  id="tipoContacto" name="tipoContacto"  tabindex="5" >
													<option value="">SELECCIONAR</option>
													<option value="C">CLIENTE</option>
													<option value="V">AVAL</option>
													<option value="O">CONYUGE</option>
													<option value="H">HIJO</option>
													<option value="P">PADRE</option>
													<option value="A">ADMINISTRADOR</option>
													<option value="N">CONTADOR</option>
													<option value="I">INTEGRANTE</option>
													<option value="T">OTRO</option>
												</select> 
											</td>
											<td class="separador"></td>
											<td class="label" nowrap="nowrap">
												<label for="lblsegtoforza">Nombre Persona: </label>								
											</td>
											<td>
												<input type="text" id="nombreContacto" name="nombreContacto" tabindex="6" size="45" onblur="ponerMayusculas(this);"/>
											</td>
										</tr>
										<tr>
											<td colspan="6">
												<div id="capacidadPago" style="display:none" > 
													<fieldset class="ui-widget ui-widget-content ui-corner-all">
														<legend>Capacidad de Pago</legend>
														<table border="0" cellpadding="0" cellspacing="0" width="100%">
															<tr>
																<td class="label" align="left">
																	<label for="lblfechaPromPago">Fec.Promesa Pago: </label>
																</td>
																<td>
																	<input id="fechaPromPago" name="fechaPromPago"  size="12" tabindex="7" esCalendario="true"/>
																</td>
																<td class="separador"></td> 
																<td class="label" nowrap="nowrap" align="left">
																	<label for="montoPromPago">Monto Promesa: </label>
																</td>
																<td>
																	<input id="montoPromPago" name="montoPromPago" size="20" autocomplete="off"  esmoneda="true" tabindex="8" style="text-align: right;" onkeypress="validaFormatoMoneda()" />
																</td>
															</tr>
															<tr>
	 															<td class="label"  align="left"> 
		   														<label for="lblexistFlujo">Habr&aacute; Flujo Pago: </label> 
																</td> 		     		
		   													<td>
																	<input type="radio" id="existFlujo1" name="existFlujo" value="S" tabindex="9"  />
																	<label for="S">Si</label>
																	<input type="radio" id="existFlujo2" name="existFlujo" value="N" tabindex="10"/>
																	<label for="S">No</label>
     															</td>
																<td class="separador"></td>
																<td class="label" nowrap="nowrap" align="left">
																	<div id="lblcerrarFecha">
																		<label for="fechaEstFlujo">Fecha Est. Flujo: </label>
																	</div>
																</td>
																<td>
																	<div id="cerrarFecha">
																		<input id="fechaEstFlujo" name="fechaEstFlujo" size="12" tabindex="11" esCalendario="true"/>
																	</div>
																</td>
															</tr>
															<tr>
																<td class="label" align="left" align="left">
																	<label for="motivoNPID">Motivo No Pago: </label>
																</td>
																<td>
																	<select id="motivoNPID" name="motivoNPID" path="motivoNPID" tabindex="12" ></select>
																</td>
																<td class="separador"></td>
																<td class="label" nowrap="nowrap" align="left">
																	<label for="lblorigenPagoID">Origen Recursos Pago: </label>
																</td>
																<td>
																	<select id="origenPagoID" name="origenPagoID" path="origenPagoID" tabindex="13"></select>
																</td>												
		    												</tr>
		    												<tr>
																<td class="label" align="left">
																	<label for="lblnomOriRecursos">Nom. Recurso Para Pago: </label>
																</td>
																<td>
																	<input id="nomOriRecursos" name="nomOriRecursos" value='' autocomplete="off" tabindex="14" size="40"/>
																</td>
															</tr>
														</table>
													</fieldset>
													<br>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="6">
												<div id="desaProyecto" style="display:none"> 
													<fieldset class="ui-widget ui-widget-content ui-corner-all">
														<legend>Organiza</legend>
														<table >
															<tr>
																<td class="label" nowrap="nowrap" align="left">
																	<label for="asistenciaGpo">%Asistencia Grupo: </label>
																	<input id="asistenciaGpo" name="asistenciaGpo" value='' maxlength="3" tabindex="7" size="5" onkeypress="validaSoloNumeros()" /><label>%</label>
																</td>
																<td class="separador"></td>
																<td class="label">
																	<label for="recoAdeudo1">¿Cliente Reconoce Adeudo?: </label>
																	<input type="radio" id="recoAdeudo1" name="recoAdeudo" value="S" tabindex="8" />
																	<label>Si</label>
																	<input type="radio" id="recoAdeudo2" name="recoAdeudo" value="N" tabindex="8" />
																	<label>No</label>
     															</td>
															</tr>
															<tr>
																<td class="label">
																	<label for="recoMontoFecha1">¿Cliente conoce montos y fechas de pago?: </label>
																	<input type="radio" id="recoMontoFecha1" name="recoMontoFecha" value="S" tabindex="9" />
																	<label>Si</label>
																	<input type="radio" id="recoMontoFecha2" name="recoMontoFecha" value="N" tabindex="9" />
																	<label>No</label>
																</td>
															</tr>
														</table>
													</fieldset>
													<fieldset class="ui-widget ui-widget-content ui-corner-all">
														<legend>Desarrollo de Proyecto</legend>
														<table border="0" cellpadding="0" cellspacing="0" width="98%">
															<tr>
																<td class="label" nowrap="nowrap" >
																	<label for="avanceProy">%Avance Proy: </label>
																</td>
																<td class="label">
																	<input id="avanceProy" name="avanceProy" maxlength="3" tabindex="10" size="5" onkeypress="validaSoloNumeros()"/><label>%</label>
																</td>
																<td class="separador"></td>
																<td class="separador"></td>
																<td class="label" nowrap="nowrap">
																	<label for="montoEstProd">Monto Estimado Prod: </label>
																	<input id="montoEstProd" name="montoEstProd" size="20" tabindex="11" esMoneda="true" tabindex="" style="text-align: right;" onkeypress="validaFormatoMoneda()" />
	     														</td>
															</tr>
															<tr>
																<td class="label" nowrap="nowrap">
																	<label for="uniEstProd">Unidades Estimadas Prod:</label>
																</td>
																<td>
																	<input id="uniEstProd" name="uniEstProd" size="7" tabindex="12" size="13" style="text-align: right;" onkeypress="validaSoloNumeros()" />
																</td>
															</tr>
														</table>
													</fieldset>
													<fieldset class="ui-widget ui-widget-content ui-corner-all">
														<legend>Comercial</legend>
														<table border="0" cellpadding="0" cellspacing="0" width="100%">
															<tr>
																<td class="label" nowrap="nowrap" >
																	<label for="montoEstUni">Precio Estimado x Unid.: </label>
																</td>
																<td class="label">
																	<input id="montoEstUni" name="montoEstUni" size="20" autocomplete="off"  esMoneda="true" tabindex="13" style="text-align: right;" onkeypress="validaFormatoMoneda()" />
	     														</td>
																<td class="label" nowrap="nowrap">
																	<label for="montoEstVtas">Monto Esperado Vtas: </label>
																	<input id="montoEstVtas" name="montoEstVtas" size="20" autocomplete="off"  esMoneda="true" tabindex="14" style="text-align: right;" onkeypress="validaFormatoMoneda()" />
																</td>
	     													</tr>
	     													<tr>
		     													<td class="label" nowrap="nowrap">
	     															<label for="fechaComercial">Fecha Comercializaci&oacute;n: </label>
	     														</td>
	     														<td>
		     														<input id="fechaComercial" name="fechaComercial" size="12" tabindex="14" esCalendario="true"/>
	     														</td>
	     													</tr>
														</table>
													</fieldset>
													<br>
												</div>
											</td>
										</tr>
		    							<tr>
											<td class="label" nowrap="nowrap" align="left">
												<label for="lbltelefonFijo">Tel. Fijo Persona Atendi&oacute;: </label>
											</td>
											<td>
												<input id="telefonFijo" name="telefonFijo" value='' maxlength="20" autocomplete="off"  tabindex="15" onkeypress="validaSoloNumeros()"/>
											</td>
											<td class="separador"></td>
											<td class="label" align="left">
												<label for="telefonCel">Tel. Celular Persona Atendi&oacute;: </label>
											</td>
											<td>
												<input id="telefonCel" name="telefonCel" value='' maxlength="20" autocomplete="off" tabindex="16" onkeypress="validaSoloNumeros()"/>
											</td>
				    					</tr>
										<tr>
											<td class="label" nowrap="nowrap" >
												<label for="lblestatusPro">Comentario General:</label>
											</td>
											<td colspan="4">
												<textarea id="comentario" name="comentario" tabindex="17" cols="93" rows="2" onblur="ponerMayusculas(this);" maxlength="1000"></textarea>
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblgestorID">Resultado Segto:</label>
											</td>
											<td colspan="4">
												<select  id="resultadoSegtoID" name="resultadoSegtoID"  tabindex="18" path="resultadoSegtoID">
													<option value="">SELECCIONAR</option>
												</select>
												<input type="hidden" id="categoResultado" name="categoResultado" readonly="true" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblsupervisorID">1era. Recomendaci&oacute;n:</label>
											</td>
											<td colspan="4">
												<select  id="recomendacionSegtoID" name="recomendacionSegtoID"  tabindex="19" >
													<option value="">SELECCIONAR</option>
												</select>
												<input type="hidden" id="categoRecomenda" name="categoRecomenda" readonly="true" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblsupervisorID">2da. Recomendaci&oacute;n:</label>
											</td>
											<td colspan="4">
												<select  id="segdaRecomendaSegtoID" name="segdaRecomendaSegtoID" tabindex="19" >
													<option value="">SELECCIONAR</option>
												</select>
												<input type="hidden" id="categoRecomenda2" name="categoRecomenda2" readonly="true" />
											</td>
										</tr>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="lblsupervisorID">Estado Segto:</label>
											</td>
											<td>
												<select id="estatus" name="estatus" tabindex="20" path="estatus" >
													<option value="">SELECCIONAR</option>
													<option value="I">INICIADO</option>
													<option value="T">TERMINADO</option>
													<option value="C">CANCELADO</option>
													<option value="R">REPROGRAMADO</option>
													<option value="A">AUTORIZADO</option>
												</select>
											</td>
											<td class="separador"></td>
											<td id="lblForzado" class="label" nowrap="nowrap">
												<label for="lblgestorID">Fecha Prox Segto Forzado:</label>
											</td>
											<td id="txtForzado" nowrap="nowrap">
												<input type="text" id="fechaSegtoFor" name="fechaSegtoFor"  tabindex="21" size="12" esCalendario="true" />
												<label for="lblgestorID">Hora:</label>
												<input type="text" id="horaSegtoFor" name="horaSegtoFor" path="horaSegtoFor" tabindex="22" size="5" />
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
					<div id="gridAdjuntos" style="display:none" >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="label">Documentos Adjuntos</legend>
							<table>
								<tr>
									<td class="label"><label>Tipo Documento</label></td>
									<td>
										<select id="tipoDocumento" name="tipoDocumento" tabindex="23">
											<option value="">SELECCIONAR</option>
										</select>
									</td>
								</tr>
							</table>
							<div id="detalleArchivos" style="display : none"></div>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td align="right">
									<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="30"  />
									<input type="hidden" id="tipoTransAdjunto" name="tipoTransAdjunto" />
									<input type="hidden" id="resultadoArchivoTran" 	name="resultadoArchivoTran" readonly="true" />
									<a id="enlaceSegto" target="_blank">
										<input type="button" id="expediente" name="expediente" class="submit" value="Expediente" tabindex="31" />
									</a>	
								</td>
							</tr>
						</table>
					</div>
					<table align="right">
						<tr>
							<td align="right" nowrap="nowrap">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="32" />
								<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="33" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="esSupervisor" name="esSupervisor" />
								<input type="hidden" id="nombreAval" name="nombreAval" />
								<input type="hidden" id="nombreConyuge" name="nombreConyuge" />
								<input type="hidden" id="cliente" name="cliente" />
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
	</body>
	<div id="mensaje" style="display:none;"></div>
</html>