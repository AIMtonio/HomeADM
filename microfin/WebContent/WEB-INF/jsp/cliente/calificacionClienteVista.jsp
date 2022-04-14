<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/conceptosCalifServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasificacionCliServicio.js"></script>
		<!-- se cargan las funciones o recursos js -->
		<script type="text/javascript" src="js/cliente/calificacionCliente.js"></script>
	</head>
	<body>
	 	<div id="contenedorForma">
	 		<fieldset class="ui-widget ui-widget-content ui-corner-all">
	 		<legend class="ui-widget ui-widget-header ui-corner-all">Calificaci&oacute;n de  <s:message code="safilocale.cliente"/></legend>
	 		
						<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="conceptosCalifBean">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Conceptos</legend>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label"  align="center">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<label for="rangoInferior">  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Conceptos &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; </label>
											</fieldset>
										</td>
										<td class="label"  align="center">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<label for="rangoInferior">Puntos</label>
											</fieldset>
										</td>		
									</tr>									
								</table>
								
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>										
											<td>
												<fieldset class="ui-widget ui-widget-content ui-corner-all">
													<table border="0" cellpadding="0" cellspacing="0" width="100%">											
														<tr>
															<td class="label">											
																<input type="radio" id="A1" name="conceptos" value="1"  tabindex="1"  unchecked="true"/><label>A1 - Antig&#xFC;edad en la Instituci&oacute;n: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDA1" name="lConceptoCalifID" path="lConceptoCalifID" value="1"/>
																<form:input type="hidden" id="conceptoA1" name="lConcepto" path="lConcepto" value="A1"/>
																<form:input type="hidden" id="descripcionA1" name="lDescripcion" path="lDescripcion" value="Antigüedad en la Institución"/>
																<form:input type='text' id="puntosA1" name="lPuntos" path="lPuntos"  size="10" tabindex="2" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />																
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="A2" name="conceptos" value="2"  tabindex="3"  unchecked="true"/><label>A2 - Cr&eacute;ditos Solicitados: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDA2" name="lConceptoCalifID" path="lConceptoCalifID" value="2"/>
																<form:input type="hidden" id="conceptoA2" name="lConcepto" path="lConcepto" value="A2"/>
																<form:input type="hidden" id="descripcionA2" name="lDescripcion" path="lDescripcion" value="Créditos Solicitados"/>
																<form:input type='text' id="puntosA2" name="lPuntos" path="lPuntos" size="10" tabindex="4" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="A3" name="conceptos" value="3"  tabindex="5"  unchecked="true"/><label>A3 - Morosidad Promedio: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDA3" name="lConceptoCalifID" path="lConceptoCalifID" value="3"/>
																<form:input type="hidden" id="conceptoA3" name="lConcepto" path="lConcepto" value="A3"/>
																<form:input type="hidden" id="descripcionA3" name="lDescripcion" path="lDescripcion" value="Morosidad Promedio"/>
																<form:input type='text' id="puntosA3" name="lPuntos" path="lPuntos" size="10" tabindex="6" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>	
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="A4" name="conceptos" value="4"  tabindex="7"  unchecked="true"/><label>A4 - Forma de Pagos (Liquidar) de Sus Cr&eacute;ditos: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDA4" name="lConceptoCalifID" path="lConceptoCalifID" value="4"/>
																<form:input type="hidden" id="conceptoA4" name="lConcepto" path="lConcepto" value="A4"/>
																<form:input type="hidden" id="descripcionA4" name="lDescripcion" path="lDescripcion" value="Forma de Pagos(liquidar) de sus créditos"/>
																<form:input type='text' id="puntosA4" name="lPuntos" path="lPuntos" size="10" tabindex="8" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="M1" name="conceptos" value="5"  tabindex="9"  unchecked="true"/><label>M1- Ahorro Neto <s:message code="safilocale.cliente"/> VS Ahorro Promedio General: </label>											
															</td>															
															<td>
																<form:input type="hidden" id="conceptoCalifIDM1" name="lConceptoCalifID" path="lConceptoCalifID" value="5"/>
																<form:input type="hidden" id="conceptoM1" name="lConcepto" path="lConcepto" value="M1"/>
																<form:input type="hidden" id="descripcionM1" name="lDescripcion" path="lDescripcion" value="Ahorro Neto Socio VS Ahorro Promedio General"/>
																<form:input type='text' id="puntosM1" name="lPuntos" path="lPuntos"  size="10" tabindex="10" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="M2" name="conceptos" value="6"  tabindex="11"  unchecked="true"/><label>M2 - Promedio Inter&eacute;s Normal: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDM2" name="lConceptoCalifID" path="lConceptoCalifID" value="6"/>
																<form:input type="hidden" id="conceptoM2" name="lConcepto" path="lConcepto" value="M2"/>
																<form:input type="hidden" id="descripcionM2" name="lDescripcion" path="lDescripcion" value="Promedio Interés Normal"/>
																<form:input type='text' id="puntosM2" name="lPuntos" path="lPuntos" size="10" tabindex="12" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="B1" name="conceptos" value="7"  tabindex="13"  unchecked="true"/><label>B1 - Reestructuras en Cr&eacute;ditos: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDB1" name="lConceptoCalifID" path="lConceptoCalifID" value="7"/>
																<form:input type="hidden" id="conceptoB1" name="lConcepto" path="lConcepto" value="B1"/>
																<form:input type="hidden" id="descripcionB1" name="lDescripcion" path="lDescripcion" value="Reestructuras en Créditos"/>
																<form:input type='text' id="puntosB1" name="lPuntos" path="lPuntos" size="10" tabindex="14" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="B2" name="conceptos" value="8"  tabindex="15"  unchecked="true"/><label>B2 - Renovaci&oacute;n en Cr&eacute;ditos: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDB2" name="lConceptoCalifID" path="lConceptoCalifID" value="8"/>
																<form:input type="hidden" id="conceptoB2" name="lConcepto" path="lConcepto" value="B2"/>
																<form:input type="hidden" id="descripcionB2" name="lDescripcion" path="lDescripcion" value="Renovaciones en Créditos"/>
																<form:input type='text' id="puntosB2" name="lPuntos" path="lPuntos" size="10" tabindex="16" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>
														<tr>
															<td class="label">											
																<input type="radio" id="B3" name="conceptos" value="9"  tabindex="17"  unchecked="true"/><label>B3 - Asistencia a la Asamblea: </label>											
															</td>
															<td>
																<form:input type="hidden" id="conceptoCalifIDB3" name="lConceptoCalifID" path="lConceptoCalifID" value="9"/>
																<form:input type="hidden" id="conceptoB3" name="lConcepto" path="lConcepto" value="B3"/>
																<form:input type="hidden" id="descripcionB3" name="lDescripcion" path="lDescripcion" value="Asistencia a la Asamblea"/>
																<form:input type='text' id="puntosB3" name="lPuntos" path="lPuntos" size="10" tabindex="18" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
															</td>
														</tr>	
														<tr>
															<td> </td>
															<td> </td>
														</tr>																										
													</table>
												 </fieldset>	
												 <table border="0" cellpadding="0" cellspacing="0" width="100%">
												 		<tr>
															<td class="label" align="right">
															&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;											
																<label>Total:</label>											
															</td>
															<td align="right">
																<form:input type='text' id="totalConceptos" name="puntos" path="puntos" value="0.00"  size="12" esMoneda="true" readonly="true" style='text-align:right;' />
																&nbsp;&nbsp;&nbsp;
															</td>
														</tr>
														<tr>
															<td> </td>
															<td align="right">
																<input type="submit" id="grabarConceptos" class="submit" value="Grabar" tabindex="19"/>
																<input type="hidden" id="tipoTransaccionConceptos" name="tipoTransaccion" value="0"/>
															</td>
														</tr>
												 </table>												
											</td>									  			
											
									</tr>
								</table>
					 		</fieldset>
					 	</form:form>
					 
			 				 		
					 	<form:form id="formaGenerica1" name="formaGenerica1" method="POST"  action="/microfin/puntosConcepto.htm" commandName="puntosConceptoBean">		 		
					 		<div id="puntosConceptoDiv"> 
					 		<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Puntos por Concepto</legend>
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="button" id="agregar" value="Agregar" class="botonGral" tabindex="20" onClick="agregarFila()"/>
										</td>
										<td class="label"  align="right">
											<label for="puntajeMax">Puntaje M&aacute;ximo:</label> 
											<input  type="text" id="puntajeMax" name="puntajeMax" size="10" value="" esMoneda="true" style="text-align:right;" readonly="true"/>
										</td>
									</tr>
								</table>		
								
								<!-- Grid para puntos por concepto -->
								<div id="gridPuntosConceptoDiv"> </div>
								
								<input type="hidden" id="concepto" name="conceptoCalifID" value="0"/>
								
					 		</fieldset>
					 	</div>
					 	</form:form>
				
				<br>
			 	
			 	<form:form id="formaGenerica2" name="formaGenerica2" method="POST" action="/microfin/clasificacionCliente.htm" commandName="clasificacionCliBean">		 		
			 		<fieldset class="ui-widget ui-widget-content ui-corner-all" width="100%">
						<legend>Clasificaci&oacute;n</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="80%">
							<tr>
								<td>
									<label for="puntosTotales">Puntos Totales Actuales a Repartir :</label>
									<input type='text' id="puntosTotales" name="puntosTotales" size="12"  value="0.00" readonly="true" style='text-align:right;' />
								</td>
								<td class="label">									
								</td>
							</tr>
						</table>
						
						
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td>
									<label for="rangoInferior">Rango Inferior</label>
								</td>
								<td>  </td>
								<td class="label"> 
									<label for="rangoSuperior">Rango Superior</label>
								</td>
								<td></td>
							</tr>
							<tr>
								<td class="label">
									<input type="hidden" name="lClasificaCliID" path="lclasificaCliID" value="1"/>
									<input type="hidden" name="lClasificacion" path="lConcepto" value="A"/>
									<input type='text' id="rangoInfA" name="lRangoInferior" size="10" tabindex="51" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />									
								</td>
								<td>
									<label for="A">a &nbsp;&nbsp;&nbsp;</label>									
								</td>
								<td> 
									<input type='text' id="rangoSupA" name="lRangoSuperior" size="10" tabindex="52" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
								</td>
								<td>
									<label for="socioA"> <s:message code="safilocale.cliente"/> A </label>									
								</td>
							</tr>
							<tr>
								<td class="label">
									<input type="hidden" name="lClasificaCliID" path="lclasificaCliID" value="2"/>
									<input type="hidden" name="lClasificacion" path="lConcepto" value="B"/>
									<input type='text' id="rangoInfB" name="lRangoInferior"size="10" tabindex="53" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />									
								</td>
								<td>
									<label for="B">a &nbsp;&nbsp;&nbsp;</label>									
								</td>
								<td> 
									<input type='text' id="rangoSupB" name="lRangoSuperior" size="10" tabindex="54" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
								</td>
								<td>
									<label for="socioB"> <s:message code="safilocale.cliente"/> B </label>									
								</td>
							</tr>
							<tr>
								<td class="label">
									<input type="hidden" name="lClasificaCliID" path="lclasificaCliID" value="3"/>
									<input type="hidden" name="lClasificacion" path="lConcepto" value="C"/>
									<input type='text' id="rangoInfC" name="lRangoInferior" size="10" tabindex="55" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />									
								</td>
								<td>
									<label for="C">a &nbsp;&nbsp;&nbsp;</label>									
								</td>
								<td> 
									<input type='text' id="rangoSupC" name="lRangoSuperior" size="10" tabindex="56" maxlength="6" esMoneda="true" value="0.00" style='text-align:right;' />
								</td>
								<td>
									<label for="socioC"> <s:message code="safilocale.cliente"/> C </label>									
								</td>
							</tr>
							<tr>	
								<td></td>
								<td></td>
								<td> </td>
								<td> 
									<input type="submit" id="grabarClasificacion" class="submit" value="Grabar" tabindex="57"/>
									<input type="hidden" id="tipoTransaccionClasifica" name="tipoTransaccion" value="0"/>
								</td>
							</tr>
						</table>
			 		</fieldset>
			 	</form:form>
			 	
			 </fieldset>
	 	</div>
	 	<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
				<div id="elementoLista"></div>
		</div>
		<div id="imagenCte" style="display: none;">
			<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>