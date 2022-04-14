<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Par&aacute;metros PLD</title>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
<script type="text/javascript" src="js/pld/paramPLD.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosSisBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros PLD</legend>
				<table width="100%">
					<tr>
						<td class="label">
							<label for="empredaID">Empresa: </label>
						</td>
						<td colspan="4">
							<form:input id="empresaID" name="empresaID" path="empresaID" size="6" tabindex="1" />
						</td>
					</tr>
					<tr style="display: none;">
						<td class="label">
							<label for="usuarioOC">Oficial de Cumplimiento: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="oficialCumID" name="oficialCumID" path="oficialCumID" size="6" disabled="true" />
							<input id="nombreOficialCumID" name="nombreOficialCumID" size="40" type="text" readOnly="true" disabled="true" />
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Procesos Autom&aacute;ticos </legend>
								<table border="0" width="100%">
									<tr>
										<td class="label">
											<label for="evaluacionMatriz">Evaluaci&oacute;n Peri&oacute;dica Matriz Riesgo: </label>
										</td>
										<td>
											<input type="radio" id="evaluacionMatrizSi" name="evaluacionMatriz" path="evaluacionMatriz" value="S" tabindex="2" /> <label for="evaluacionMatrizSi">Si</label> <input type="radio" id="evaluacionMatrizNo" name="evaluacionMatriz" path="evaluacionMatriz" value="N" tabindex="3" /> <label for="evaluacionMatrizNo">No</label> <a href="javaScript:" onclick="ayudaEvaluacion()"> <img src="images/help-icon.gif"></a>
										</td>
										<td class="separador"></td>
										<td class="label tdEvaluacion" style="display: none;">
											<label for="frecuenciaMensual">Frecuencia Mensual: </label>
										</td>
										<td class="tdEvaluacion" style="display: none;">
											<form:input id="frecuenciaMensual" name="frecuenciaMensual" path="frecuenciaMensual" size="6" tabindex="2" maxlength="2" />
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="actualizaPerfilSi">Actualizaci&oacute;n Peri&oacute;dica Perfil Transaccional: </label>
										</td>
										<td nowrap="nowrap">
											<form:radiobutton type="radio" id="actualizaPerfilSi" name="actPerfilTransOpe" path="actPerfilTransOpe" value="S" tabindex="4" />
											<label for="actualizaPerfilSi">Si</label>
											<form:radiobutton type="radio" id="actualizaPerfilNo" name="actPerfilTransOpe" path="actPerfilTransOpe" value="N" tabindex="5" />
											<label for="actualizaPerfilNo">No</label> <a href="javaScript:" onclick="ayudaPerfil()"><img src="images/help-icon.gif"></a>
										</td>
										<td class="separador"></td>
										<td class="label tdFrecuenciaPerf" style="display: none;">
											<label for="frecuenciaMensPerf">Frecuencia Mensual: </label>
										</td>
										<td class="tdFrecuenciaPerf" style="display: none;">
											<form:input id="frecuenciaMensPerf" name="frecuenciaMensPerf" path="frecuenciaMensPerf" size="6" tabindex="6" maxlength="7" />
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="actualizaPerfilSi">Actualizaci&oacute;n Masiva del Perfil Transaccional: </label>
										</td>
										<td nowrap="nowrap">
											<form:radiobutton type="radio" id="actualizaPerfilSiMas" name="actPerfilTransOpeMas" path="actPerfilTransOpeMas" value="S" tabindex="8" />
											<label for="actualizaPerfilMasSi">Si</label>
											<form:radiobutton type="radio" id="actualizaPerfilNoMas" name="actPerfilTransOpeMas" path="actPerfilTransOpeMas" value="N" tabindex="9" />
											<label for="actualizaPerfilMasNo">No</label> <a href="javaScript:" onclick="ayudaPerfilMas()"><img src="images/help-icon.gif"></a>
										</td>
										<td class="separador"></td>
										<td class="label tdFrecuenciaPerfMas" style="display: none;">
											<label for="numEvalPerfilTrans">Frecuencia Mensual: </label>
										</td>
										<td class="tdFrecuenciaPerfMas" style="display: none;">
											<form:input type="text" id="numEvalPerfilTrans" name="numEvalPerfilTrans" path="numEvalPerfilTrans" size="6" tabindex="10" maxlength="2" />
										</td>
									</tr>
									<tr>
										<td>
											<label for="fecVigenDomicilio">Validar Vigencia Domicilio:</label>
										</td>
										<td>
											<input type="radio" id="validarVigDomiSi" name="validarVigDomi" path="validarVigDomi" value="S" tabindex="11" /> <label for="validarVigDomiSi">Si</label>
											<input type="radio" id="validarVigDomiNo" name="validarVigDomi" path="validarVigDomi" value="N" tabindex="12" /> <label for="validarVigDomiNo">No</label> <a href="javaScript:" onclick="ayudaValidaVig()"> <img src="images/help-icon.gif"></a>
										</td>
										<td class="separador"></td>
										<td class="label tdVigenciaDomicilio" style="display: none;">
											<label for="fecVigenDomicilio">Vigencia Domicilio:</label>
										</td>
										<td nowrap="nowrap" class="tdVigenciaDomicilio" style="display: none;">
											<form:input type="text" id="fecVigenDomicilio" name="fecVigenDomicilio" path="fecVigenDomicilio" tabindex="9" size="13" />
											<label for="fecVigenDomicilio">Meses</label>
										</td>
									</tr>
									<tr class="tdVigenciaDomicilio" style="display: none;">
										<td class="label ">
											<label>Tipo Documento:</label>
										</td>
										<td nowrap="nowrap" colspan="3">
											<form:input id="tipoDocDomID" type="text" name="tipoDocDomID" path="tipoDocDomID" size="6" value="" tabindex="14" />
											<input id="descripcionDocumento" name="descripcionDocumento" size="40" type="text" readOnly="true" disabled="true" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Detecci&oacute;n en Listas</legend>
								<table border="0" width="100%">
									<tr>
										<td class="label" colspan="1">
											<label for="porcCoincidencias">Porcentaje de Coincidencias: </label>
										</td>
										<td nowrap="nowrap" colspan="4">
											<form:input type="text" id="porcCoincidencias" name="porcCoincidencias" path="porcCoincidencias" esTasa="true" tabindex="15" size="10" style="text-align:right;"/>
											<label for="porcCoincidencias">%</label> <a href="javaScript:" onclick="ayudaConcidencias()"> <img src="images/help-icon.gif"></a>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="1">
							<label for="modNivelRiesgoSi">Modificaci&oacute;n Nivel Riesgo:</label>
						</td>
						<td nowrap="nowrap" colspan="4">
							<form:radiobutton type="radio" id="modNivelRiesgoSi" name="modNivelRiesgo" path="modNivelRiesgo" value="S" tabindex="16" />
							<label for="modNivelRiesgoSi">Si</label>
							<form:radiobutton type="radio" id="modNivelRiesgoNo" name="modNivelRiesgo" path="modNivelRiesgo" value="N" tabindex="17" />
							<label for="modNivelRiesgoNo">No</label>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="right">
							<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="18" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
	<div id="mensaje" style="display: none;"></div>
	<div id="divOculto" style="display: none;">
		<div id="ayudaEvaluacion">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Evaluaci&oacute;n Peri&oacute;dica Matriz de Riesgo:</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">Indica si se evalúa de manera periódica el nivel de riesgo de los cliente en base a la matriz de riesgos vigente durante el cierre de mes (Número de meses posterior a la fecha actual).</div>
			</fieldset>
		</div>
		<div id="ayudaPerfil">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Actualizaci&oacute;n Peri&oacute;dica del Perfil Transaccional:</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">Indica si se realiza el proceso de Actualización del Perfil Transaccional Operativo en base a la Transaccionalidad del Cliente</div>
			</fieldset>
		</div>
		<div id="ayudaPerfilMas">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Actualizaci&oacute;n Masiva del Perfil Transaccional:</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">Indica si se realiza el proceso de Evaluaci&oacute;n Masiva del Perfil Transaccional de Todos los Clientes Activos. Y se ejecutan N veces al Año.</div>
			</fieldset>
		</div>
		<div id="ayudaConcidencias">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Porcentaje de Coincidencias:</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">
					Porcentaje que puede haber de coincidencias en los siguientes campos:<br> <b> Nombre Completo<br> Apellido Paterno<br>Apellido Materno<br>
					</b> <br> Por Ejemplo: <br> <br>Detección en Apellido Paterno:<br>Apellido Paterno en Listas Negras: Mende<b>z</b><br>Apellido Paterno Registrado en el Sistema: Mende<b>s</b><br>Porcentaje de Coincidencias: 83.33%
				</div>
			</fieldset>
		</div>
		<div id="ayudaValVig">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Validación en Vigencia de Comprobante de Domicilio:</legend>
				<div id="ContenedorAyuda" style="text-align: justify; padding: 10px">Indica si se Válida la Fecha de Vigencia de los Comprobantes de Domicilio.</div>
			</fieldset>
		</div>
	</div>
</body>
</html>