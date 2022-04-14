<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
<!--  declaracion del recurso que se nombro en el xml para consultas -->
<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" 	src="dwr/interface/cuentasContablesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/apoyoEscCicloServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramApoyoEscolarServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clidatsocioeServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catDatSocioEServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
<script type="text/javascript" src="dwr/interface/asamGralUsuarioAutServicio.js"></script>  
 

<!-- se cargan las funciones o recursos js -->
<script type="text/javascript" src="js/soporte/parametrosCaja.js"></script>

</head>

<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros CAJA</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosCajaBean">

				<fieldset class="ui-widget ui-widget-content ui-co
				rner-all">
					<table border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="empredaID">Empresa:</label>
							</td>
							<td>
								<form:input type='text' id="empresaID" name="empresaID" path="empresaID" size="12" tabindex="1" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="haberExSocios">Cta. Conta. Haberes Ex<s:message code="safilocale.cliente"/>s: </label>
							</td>
							<td>
								<form:input type='text' id="haberExSocios" name="haberExSocios" path="haberExSocios" size="34" tabindex="2" /> 
								<input type='text' id="haberExSociosDes" name="haberExSociosDes" size="60"  readonly disabled />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="CCHaberesEx">Nomenclatura Centro de Costos: </label>
							</td>
							<td>
								<form:input type='text' id="CCHaberesEx" name="CCHaberesEx" path="CCHaberesEx" size="25" tabindex="3" maxlength="30" /> 
								<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
							</td>
						</tr>
						
						
						 <tr>
							<td class="label">
								<label for="tipoCtaProtec">Cuenta Ordinaria: </label>
							</td>
							<td>
								<form:select id="ctaOrdinaria" name="ctaOrdinaria" path="ctaOrdinaria" tabindex="4" type="select">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr> 
						 <tr>
							<td class="label">
								<label for="cuentaVista">Cuenta a la Vista: </label>
							</td>
							<td>
								<form:select id="cuentaVista" name="cuentaVista" path="cuentaVista" tabindex="5" type="select">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr> 
						<tr>
							<td class="label">
								<label for="compAho">Compromiso de Ahorro: </label>
							</td>
							<td>
								<form:input type='text' id="compromisoAho" name="compromisoAho" path="compromisoAho" size="25" tabindex="6" esMoneda="true" style='text-align:right;'  />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ejecutivoFR">Ejecutivo Financiero Rural: </label>
							</td>
							<td>
								<form:input type='text' id="ejecutivoFR" name="ejecutivoFR" path="ejecutivoFR" size="5" tabindex="7" />
								<input type='text' id="ejecutivoFRDes" name="ejecutivoFRDes" size="60" tabindex="8"  readonly disabled />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="versionWS">Versión WS: </label>
							</td>
							<td>
								<form:input type='text' id="versionWS" name="versionWS" path="versionWS" size="25" tabindex="9" maxlength="40" onBlur="ponerMayusculas(this)" style='text-transform:uppercase' />
								
								
							</td>
					   </tr>
					</table>
				</fieldset>
			
				<br>
			 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Capacidad de Pago</legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="porcentajeCob">Porcentaje de Cobertura:</label>
							
							</td>
							<td>

								<form:input type='text' id="porcentajeCob" name="porcentajeCob" path="porcentajeCob" size="12" tabindex="10" esMoneda="true" style='text-align:right;' />

							</td>
							<td class="label" nowrap="nowrap">
								<label for="coberturaMin">Cobertura M&iacute;nima:</label>
							</td>
							<td>

								<form:input type='text' id="coberturaMin" name="coberturaMin" path="coberturaMin" size="12" tabindex="11"  esMoneda="true" style='text-align:right;' />

							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="gastosBasicosRural">Gastos Básicos Zona Rural:</label>
							</td>
							<td>
								<form:input type='text' id="gastosRural" name="gastosRural" path="gastosRural" size="12" tabindex="12"  esMoneda="true" style='text-align:right;' />
							</td>
							
							<td class="		label" nowrap="nowrap">
								<label for="gastosBasicosUrbana">Gastos Básicos Zona Urbana:</label>
							</td>
							<td>
								<form:input type='text' id="gastosUrbana" name="gastosUrbana" path="gastosUrbana" size="12" tabindex="13"  esMoneda="true" style='text-align:right;' />
							</td>
							<tr>
							<td class="label" nowrap="nowrap">
								<label for="puntajeMinimo">Porcentaje M&iacute;nimo:</label>
							
							</td>
							<td>

								<form:input type='int' id="puntajeMinimo" name="puntajeMinimo" path="puntajeMinimo" size="12" tabindex="14" esMoneda="true" style='text-align:right;' />

							</td>
							
							<td class="label" nowrap="nowrap">
								<label for="idGastoAlimenta">Gastos Alimentaci&oacute;n:</label>
							
							</td>
								<td>
								<form:input type='text' id="idGastoAlimenta" name="idGastoAlimenta" path="idGastoAlimenta" size="12" tabindex="15"  style='text-align:right;' />
								</td>
								<td>
								<input type='text' id="desGastosAlimentacion" name="desGastosAlimentacion"  size="30"  readOnly="true" />
							</td>
							</tr>
							
							<tr>
							<td class="label" nowrap="nowrap">
								<label for="gastosPasivos">Gastos Pasivos:</label>
							
							</td>
							<td>
								<!--<form:input type='text' id="gastosPasivos" name="gastosPasivos" path="gastosPasivos" size="12" tabindex="9" esMoneda="true" style='text-align:right;' />-->
								<select multiple   id="gastosPasivos" name="gastosPasivos"  tabindex="16"  size="4">
					    	
								</select>
						
							</td>
							</tr>
							<tr>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>							
							</tr>
					</table>
				</fieldset>  
				
				<br>
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Cancelaci&oacute;n de <s:message code="safilocale.cliente"/></legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="tipoCtaBeneCancel">Tipo de Cuenta para Tomar los Beneficiarios:</label>								
							</td>
							<td>
								<form:select id="tipoCtaBeneCancel" name="tipoCtaBeneCancel" path="tipoCtaBeneCancel" tabindex="17" type="select">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label">
								<label for="ctaContaPerdida">Cta. Conta. P&eacute;rdida:</label>								
							</td>
							<td>
								<form:input type='text' id="ctaContaPerdida" name="ctaContaPerdida" path="ctaContaPerdida" size="34" tabindex="18"/>
								<input type='text' id="ctaContaPerdidaDes" name="ctaContaPerdidaDes" size="60" tabindex="19" readonly="readonly" disabled="disabled" />
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="label">
								<label for="CCContaPerdida">Nomenclatura Centro de Costos: </label>
							</td>
							<td>
								<form:input type='text' id="CCContaPerdida" name="CCContaPerdida" path="CCContaPerdida" size="25" tabindex="20" maxlength="30" /> 
								<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
							</td>
						</tr>
					</table>
				</fieldset>  	
			
				<br>
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Protecci&oacute;n al Ahorro y Cr&eacute;dito </legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="lblPerfilAutoriProtec">Perfil para Autorizar: </label>
							</td>
							<td>
								<form:input type='text' id="perfilAutoriProtec" name="perfilAutoriProtec" path="perfilAutoriProtec" size="5" tabindex="21" />
								 <input type='text' id="perfilAutoriProtecDes" name="perfilAutoriProtecDes" size="60"  readonly disabled/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoCtaProtec">Tipo de Cuenta <s:message code="safilocale.cliente"/>s: </label>
							</td>
							<td>
								<form:select id="tipoCtaProtec" name="tipoCtaProtec" path="tipoCtaProtec" tabindex="22" type="select">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoCtaProtecMen">Tipo de Cuenta <s:message code="safilocale.cliente"/>s Menores: </label>
							</td>
							<td>
								<form:select id="tipoCtaProtecMen" name="tipoCtaProtecMen" path="tipoCtaProtecMen" tabindex="23" type="select">
									<form:option value="">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="montoMaxProtec">Monto M&aacute;ximo: </label>
							</td>
							<td>
								<form:input type='text' id="montoMaxProtec" name="montoMaxProtec" path="montoMaxProtec" size="25" tabindex="24" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ctaProtecCta">Cta. Conta. Protecci&oacute;n Ahorro: </label>
							</td>
							<td>
								<form:input type='text' id="ctaProtecCta" name="ctaProtecCta" path="ctaProtecCta" size="34" tabindex="25" />
								<input type='text' id="ctaProtecCtaDes" name="ctaProtecCtaDes" size="60" readonly disabled/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ctaProtecCre">Cta. Conta. Protecci&oacute;n Cr&eacute;dito: </label>
							</td>
							<td>
								<form:input type='text' id="ctaProtecCre" name="ctaProtecCre" path="ctaProtecCre" size="34" tabindex="26" />
								<input type='text' id="ctaProtecCreDes" name="ctaProtecCreDes" size="60"  readonly disabled/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="edadMinimaCliMen">Rango de Edad <s:message code="safilocale.cliente"/> Menor: </label>
							</td>
							<td>
								<form:input type='text' id="edadMinimaCliMen" name="edadMinimaCliMen" path="edadMinimaCliMen" size="5" tabindex="27" maxlength="3"/> 
							
								<label for="edadMaximaCliMen">a </label>
							
								<form:input type='text' id="edadMaximaCliMen" name="edadMaximaCliMen" path="edadMaximaCliMen" size="5" tabindex="28" maxlength="3"/>
								
								<label for="edadMaximaCliMen">Año(s) </label> 
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNomenclaturaCCProteccion">Nomenclatura Centro de Costos: </label>
							</td>
							<td>
								<form:input type='text' id="CCProtecAhorro" name="CCProtecAhorro" path="CCProtecAhorro" size="25" tabindex="29" maxlength="30"/> 
								<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
							</td>
						</tr>
						
					</table>
				</fieldset>

				<br>


				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Protecci&oacute;n Funeraria (PROFUN) </legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="perfilAutoriSRVFUN">Perfil para Cancelar: </label>
							</td>
							<td>

								<form:input type='text' id="perfilCancelPROFUN" name="perfilCancelPROFUN" path="perfilCancelPROFUN" size="5" tabindex="30" />
								 <input type='text' id="perfilCancelPROFUNDes" name="perfilCancelPROFUNDes" size="60" tabindex="31" readonly disabled/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="montoPROFUN">Monto M&aacute;ximo: </label>
							</td>
							<td>
								<form:input type='text' id="montoPROFUN" name="montoPROFUN" path="montoPROFUN" size="25" tabindex="32" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="aporteMaxPROFUN">Aporte	M&aacute;ximo por <s:message code="safilocale.cliente"/>: </label>
							</td>
							<td>
								<form:input type='text' id="aporteMaxPROFUN" name="aporteMaxPROFUN" path="aporteMaxPROFUN" size="25" tabindex="33" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ctaContaPROFUN">Cta. Conta. PROFUN: </label>
								</td>
							<td>

								<form:input type='text' id="ctaContaPROFUN" name="ctaContaPROFUN" path="ctaContaPROFUN" size="34" tabindex="34" /> 
								<input type='text' id="ctaContaPROFUNDes" name="ctaContaPROFUNDes" size="60"  readonly disabled/>

							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="ctaContaPROFUN">Max. Atraso Meses Pago: </label>
								</td>
							<td>

								<form:input type='text' id="maxAtraPagPROFUN" name="maxAtraPagPROFUN" path="maxAtraPagPROFUN" size="5" tabindex="35" />

							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="mesesConsPago">Meses Constantes Pago: </label>
								</td>
							<td>

								<form:input type='text' id="mesesConsPago" name="mesesConsPago" path="mesesConsPago" size="5" tabindex="35" maxlength="11" />

							</td>
						</tr>
					</table>
				</fieldset>

				<br>


				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>SERVIFUN </legend>
					<table border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="perfilAutoriSRVFUN">Perfil para Autorizar: </label>
							</td>
							<td>

								<form:input type='text' id="perfilAutoriSRVFUN" name="perfilAutoriSRVFUN" path="perfilAutoriSRVFUN" size="5" tabindex="36" />
								 <input type='text' id="perfilAutoriSRVFUNDes" name="perfilAutoriSRVFUNDes" size="60" tabindex="37" readonly disabled/>
							</td>
						</tr>
						<tr>
								<td class="label">
									<label for="ctaContaSRVFUN">Cta. Conta. SERVIFUN: </label>
								</td>
								<td>

									<form:input type='text' id="ctaContaSRVFUN" name="ctaContaSRVFUN" path="ctaContaSRVFUN" size="34" tabindex="38" />
									 <input type='text' id="ctaContaSRVFUNDes" name="ctaContaSRVFUNDes" size="60"  readonly disabled/>

								</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNomenclaturaCCServifun">Nomenclatura Centro de Costos: </label>
							</td>
							<td>
								<form:input type='text' id="CCServifun" name="CCServifun" path="CCServifun" size="25" tabindex="39" maxlength="30" /> 
								<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
							</td>
						</tr>						
						<tr>
							<td class="label">
								<label for="montoApoyoSRVFUN">Monto Total a Entregar Socio: </label>
							</td>
							<td>
								<form:input type='text' id="montoApoyoSRVFUN" name="montoApoyoSRVFUN" path="montoApoyoSRVFUN" size="20" tabindex="40" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>
							<tr>
							<td class="label">
								<label for="monApoFamSRVFUN">Monto Total a Entregar Familiar: </label>
							</td>
							<td>
								<form:input type='text' id="monApoFamSRVFUN" name="monApoFamSRVFUN" path="monApoFamSRVFUN" size="20" tabindex="41" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="edadMaximaSRVFUN">Edad M&aacute;xima al Ingreso a la Instituci&oacute;n: </label>
							</td>
							<td>
								<form:input type='text' id="edadMaximaSRVFUN" name="edadMaximaSRVFUN" path="edadMaximaSRVFUN" size="20" tabindex="42" />
								<label for="edadMaximaSRVFUN">años </label>
							</td>
						</tr>  
						<tr>
							<td class="label">
								<label for="tiempoMinimoSRVFUN">M&iacute;nimo de Tiempo de ser <s:message code="safilocale.cliente"/>: </label>
							</td>
							<td>
								<form:input type='text' id="tiempoMinimoSRVFUN" name="tiempoMinimoSRVFUN" path="tiempoMinimoSRVFUN" size="20" tabindex="43" /> 
								<label for="tiempoMinimoSRVFUN">Mes(es) </label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="mesesValAhoSRVFUN">Cant. M&aacute;xima de Meses a Validar (Ahorro Frecuente): </label>
							</td>
							<td>
								<form:input type='text' id="mesesValAhoSRVFUN" name="mesesValAhoSRVFUN" path="mesesValAhoSRVFUN" size="20" tabindex="44" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="saldoMinMesSRVFUN">Monto M&iacute;nimo en el Mes Considerado como Ahorro: </label></td>
							<td>
								<form:input type='text' id="saldoMinMesSRVFUN" name="saldoMinMesSRVFUN" path="saldoMinMesSRVFUN" size="20" tabindex="45" esMoneda="true" style='text-align:right;' />
							</td>
						</tr>  
					</table>


				</fieldset>
				
				
				<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Cancelación Cheques</legend>
				<table border="0"  width="100%">
								
						<tr>
							<td class="label">
								<label for="rolAutorizaCancelaCheque">Rol Cancelación de Cheques: </label>
							</td>
							<td>
								<form:input type='text' id="rolCancelaCheque" name="rolCancelaCheque" path="rolCancelaCheque" size="5" tabindex="46" />
								 <input type='text' id="desRolCancelaCheque" name="desRolCancelaCheque" size="60" tabindex="47" readonly disabled/>
							</td>
						</tr>					
				</table>
		</fieldset>		
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Tarjeta D&eacute;bito</legend>
				<table border="0"  width="100%">								
						<tr>
							<td width="200" class="label">
								<label for="codCooperativa">C&oacute;digo Cooperativa:</label>
							</td>
							<td>
								<form:input type='text' id="codCooperativa" name="codCooperativa" path="codCooperativa" maxlength="9" size="45" tabindex="48" />
							</td>
						</tr>		
						<tr>
							<td class="label">
								<label for="codMoneda">C&oacute;digo Moneda:</label>
							</td>
							<td>
								<form:input type='text' id="codMoneda" name="codMoneda" path="codMoneda" maxlength="3" size="45" tabindex="49" />
							</td>
						</tr>	
						<tr>
							<td class="label">
								<label for="codUsuario">C&oacute;digo Usuario:</label>
							</td>
							<td>
								<form:input type='text' id="codUsuario" name="codUsuario" maxlength="19" path="codUsuario" size="45" tabindex="50" />
							</td>
						</tr>
						<!-- F&iacute;sica -->
						<tr>
							<td class="label"> 
								<label for=permiteAdicional>Permite Tarjetas Adicionales:</label> 
							</td>
							<td class="label"> 
								<form:radiobutton id="permiteAdicional" name="permiteAdicional" path="permiteAdicional" value="S" tabindex="51"/>
								<label for="permiteAdicional">Si</label>&nbsp;&nbsp;
								<form:radiobutton id="permiteAdicional1" name="permiteAdicional" path="permiteAdicional" value="N" tabindex="52"/>
								<label for="permiteAdicional">No</label>
							</td>	
						</tr>						
				</table>
		</fieldset>	
			<br>
	<!-- PARAMETRIZACION PARA CONVECIONES SECCIONALES -->	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Asambleas</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Generales </legend>
						<table border="0"  width="100%">	
								<tr>
									<td width="200" class="label">
										<label for="tipoProdCap">Tipo de Producto Captacion:</label>
									</td>
									<td>
										<form:select id="tipoProdCap" name="tipoProdCap" path="tipoProdCap" tabindex="53" >
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="A">Ahorro Ordinario</form:option>
										<form:option value="V">Ahorro Vista</form:option>
										</form:select> 
									</td>
								</tr>								
								<tr>
									<td width="200" class="label">
										<label for="antigueSocio">Antig&uuml;edad del Socio:</label>
									</td>
									<td>
										<form:input type='text' id="antigueSocio" name="antigueSocio" path="antigueSocio" size="20" tabindex="54" maxlength="2" />
										<label for="antigueSocio">Mes(es)</label>
									</td>
								</tr>		
								<tr>
									<td class="label">
										<label for="montoAhoMes">Monto de Ahorro por Mes: </label></td>
									<td>
										<form:input type='text' id="montoAhoMes" name="montoAhoMes" path="montoAhoMes" size="20" tabindex="55" esMoneda="true" style='text-align:right;' />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="impMinParSoc">Importe M&iacute;nimo de Saldo: </label></td>
									<td>
										<form:input type='text' id="impMinParSoc" name="impMinParSoc" path="impMinParSoc" size="20" tabindex="56" esMoneda="true" style='text-align:right;' />
									</td>
								</tr>
								<tr>
									<td class="label">
										<label for="mesesEvalAho">Meses de Evaluaci&oacute;n de Ahorro:</label>
									</td>
									<td>
										<form:input type='text' id="mesesEvalAho" name="mesesEvalAho" path="mesesEvalAho" maxlength="2" size="20" tabindex="57" />
										<label for="mesesEvalAho">Mes(es)</label>
									</td>
								</tr>		
								<tr>
								
								<tr>
									<td class="label"> 
										<label for=validaCredAtras>Validar Atraso en los Cr&eacute;ditos:</label> 
									</td>
									<td class="label"> 
										<form:radiobutton id="validaCredAtras" name="validaCredAtras" path="validaCredAtras" value="S" tabindex="58"/>
										<label for="validaCredAtras">Si</label>&nbsp;&nbsp;
										<form:radiobutton id="validaCredAtras1" name="validaCredAtras" path="validaCredAtras" value="N" tabindex="59"/>
										<label for="validaCredAtras">No</label>
									</td>	
								</tr>	
								<tr>
									<td class="label"> 
										<label for=validaGaranLiq>Validar Abonos de Garant&iacute;a L&iacute;quida:</label> 
									</td>
									<td class="label"> 
										<form:radiobutton id="validaGaranLiq" name="validaGaranLiq" path="validaGaranLiq" value="S" tabindex="60"/>
										<label for="validaGaranLiq">Si</label>&nbsp;&nbsp;
										<form:radiobutton id="validaGaranLiq1" name="validaGaranLiq" path="validaGaranLiq" value="N" tabindex="61"/>
										<label for="validaGaranLiq">No</label>
									</td>	
								</tr>						
						</table>
				</fieldset>
			
	
				</fieldset>
					<br>
					
			<!-- PARAMETRIZACION PARA ACTAS DE COMITE -->	
			
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Actas de Comit&eacute;</legend>
				<table  width="100%">								
						<tr>
							<td class="label">
								<label for="montoMinActCom">Monto M&iacute;nimo:</label>
							</td>
							<td>
								<form:input type='text' id="montoMinActCom" name="montoMinActCom" path="montoMinActCom"  size="20" esMoneda="true" style='text-align:right;' tabindex="62" />
							</td>
							
							<td class="label">
								<label for="montoMaxActCom">Monto M&aacute;ximo:</label>
							</td>
							<td>
								<form:input type='text' id="montoMaxActCom" name="montoMaxActCom" path="montoMaxActCom"  size="20" esMoneda="true" style='text-align:right;' tabindex="63" />
							</td>
							
						</tr>		
					
															
				</table>
		</fieldset>	
				
					
					<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Apoyo Escolar </legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Generales </legend>
						<table border="0"  width="100%">
							<tr>
								<td class="label">
									<label for="rolAutoApoyoEsc">Perfil para Autorizar: </label>
								</td>
								<td>
									<form:input type='text' id="rolAutoApoyoEsc" name="rolAutoApoyoEsc" path="rolAutoApoyoEsc" size="5" tabindex="64" /> 
									<input type='text' id="rolAutoApoyoEscDes" name="rolAutoApoyoEscDes" size="60"  readonly
									disabled />

								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="ctaContaApoyoEsc">Cta. Conta. Apoyo Escolar: </label>
								</td>
								<td>

									<form:input type='text' id="ctaContaApoyoEsc" name="ctaContaApoyoEsc" path="ctaContaApoyoEsc" size="34" tabindex="65" />
									 <input type='text' id="ctaContaApoyoEscDes" name="ctaContaApoyoEscDes" size="60" tabindex="122" readonly disabled/>

								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="lblNomenclaturaCCApoyoEscolar">Nomenclatura Centro de Costos: </label>
								</td>
								<td>
									<form:input type='text' id="CCApoyoEscolar" name="CCApoyoEscolar" path="CCApoyoEscolar" size="25" tabindex="66" maxlength="30"/> 
									<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
								</td>
							</tr>
							<tr>
								<td class="label"><label for="tipoCtaApoyoEscMay">Tipo de Cta. para Ahorro Constante (<s:message code="safilocale.cliente"/> Mayor): </label>
								</td>
								<td>
									<form:select id="tipoCtaApoyoEscMay" name="tipoCtaApoyoEscMay" path="tipoCtaApoyoEscMay" tabindex="67" type="select">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="tipoCtaApoyoEscMen">Tipo de Cta. para Ahorro Constante (<s:message code="safilocale.cliente"/> Menor): </label></td>
								<td>

									<form:select id="tipoCtaApoyoEscMen" name="tipoCtaApoyoEscMen" path="tipoCtaApoyoEscMen" tabindex="68" type="select">
										<form:option value="">SELECCIONAR</form:option>
									</form:select>
								</td>
							</tr>							
							<tr>
								<td class="label">
									<label for="MesInicioAhorroCons">Mes de Inicio de Ahorro Constante:</label>
								</td>
								<td>
									<form:select id="mesInicioAhoCons" name="mesInicioAhoCons" path="mesInicioAhoCons" tabindex="69" type="select">
										<form:option value="">SELECCIONAR</form:option>
										<form:option value="1">ENERO</form:option>
										<form:option value="2">FEBRERO</form:option>
										<form:option value="3">MARZO</form:option>
										<form:option value="4">ABRIL</form:option>
										<form:option value="5">MAYO</form:option>
										<form:option value="6">JUNIO</form:option>
										<form:option value="7">JULIO</form:option>
										<form:option value="8">AGOSTO</form:option>
										<form:option value="9">SEPTIEMBRE</form:option>
										<form:option value="10">OCTUBRE</form:option>
										<form:option value="11">NOVIEMBRE</form:option>
										<form:option value="12">DICIEMBRE</form:option>
									</form:select>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="montoMinMesApoyoEsc">Monto M&iacute;nimo en el Mes Considerado como Ahorro: </label>
								</td>
								<td>
									<form:input type='text' id="montoMinMesApoyoEsc" name="montoMinMesApoyoEsc" path="montoMinMesApoyoEsc" size="20" tabindex="70" esMoneda="true" style='text-align:right;' />
								</td>
							</tr>   
						</table>
		</fieldset>

		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="71" />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
				</td>
			</tr>
		</table>
		<br>
		<br>

		</form:form>
		<br>
		<form:form id="formaGenerica1" name="formaGenerica1" method="POST" action="/microfin/paramApoyoEscolar.htm" commandName="paramApoyoEscolarBean"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Grado Escolar</legend>
			<table border="0"  width="100%">
				<tr>
					<td class="label" align="center">
						<label for="apoyoEscCicloID">Grado Escolar </label>
					</td>
					<td class="label" align="center">
						<label for="promedioMinimo">Promedio M&iacute;nimo </label>
					</td>
					<td class="label" align="center">
						<label for="tipoCalculo">Tipo de C&aacute;lculo </label>
					</td>
					<td class="label" align="center">
						<label for="cantidad">Cantidad </label>
					</td>
					<td class="label" align="center">
						<label for="mesesAhorroCons">Meses de Ahorro Const.</label>
					</td> 
					<td class="label" align="center">
						
					</td>
				</tr>
				<tr>
					<td align="center">
						<select id="apoyoEscCicloID" name="apoyoEscCicloID" path="apoyoEscCicloID" tabindex="72" type="select">
							<option value="">SELECCIONAR<option>
						</select>
					</td>
					<td align="center">
						<input type='text' id="promedioMinimo" name="promedioMinimo" path="promedioMinimo" size="10" maxlength=6 tabindex="73" />
					</td>
					<td align="center">
						<select id="tipoCalculo" name="tipoCalculo" path="tipoCalculo" tabindex="74" type="select">
							<option value="">SELECCIONAR</option>
							<option value="MF">MONTO FIJO</option>
							<option value="SM">N VECES SALARIO M&Iacute;NIMO</option>
						</select>
					</td>
					<td align="center">
						<input type='text' id="cantidad" name="cantidad" path="cantidad" size="20" maxlength=13  tabindex="75" esMoneda="true" style='text-align:right;'/>
					</td>
					<td align="center">
						<input type='text' id="mesesAhorroCons" name="mesesAhorroCons" path="mesesAhorroCons" size="10" tabindex="76" />
					</td>    
					<td align="center">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="77"/>
						<input type="hidden" id="tipoTransaccionGrid" name="tipoTransaccionGrid" />
						<input type="hidden" value="0" name="paramApoyoEscID" id="paramApoyoEscID" />
					</td>
				</tr>

			</table>

			<br>
			<div id="gridApoyoEscolarDiv" style="display: none;">
				<fieldset>
					<legend>Escolaridad Registrada </legend>
					<!-- aqui va el grid que muestra los parametros por nivel escolar para el apoyo escolar -->
				</fieldset>
			</div>
		</fieldset>
	</form:form>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
			   <legend>Asambleas</legend>
			<form:form id="formaGenerica2" name="formaGenerica2" method="POST" action="/microfin/asamGralUsuarioAut.htm" commandName="asamGralUsuarioAutBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Personal autorizado </legend>
					<table border="0"  width="100%">
					<tr>
			 		  	<td align="right">
			 		  	<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
						<input type="button" id="btnagregar" name="btnagregar" class="submit" value="Agregar" onclick="agregarPersonalAut()" tabindex="78"/>
						<input type="submit" id="btnGrabarAsambleas" name="btnGrabarAsambleas" value="Grabar" class="submit" tabindex="79"/>
						<input type="hidden" id="tipoTransaccionGridPer" name="tipoTransaccionGridPer"  value="1"/>
						</td>
					</tr>
					<tr>
					</table>		
			 		  <table border="0"  width="100%">
			 		  
			 		  	<tr>
						<td>
				 		<div id="divPersonalAutorizado" style="display:none";/>
				 		</td>

						</tr>
			 		</table>

				 </fieldset>
		   </form:form>
	</fieldset>
	</fieldset>
	</div>


		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
		</div>
		<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>