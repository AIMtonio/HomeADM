<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		
		<script type="text/javascript" src="js/tesoreria/paramDepRefInstituciones.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="institucionesBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Instituciones</legend>
					<table>
						<tr>
							<td>
								<table>
									<tr>	
										<td class="label" nowrap="nowrap">
											<label for="institucionID">Instituci&oacute;n:</label>
										</td>
										<td nowrap="nowrap">
											<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="15" tabindex="1"/>
											<input type="text" id="nombre" name="nombre" size="35" disabled="true" readOnly="true"/>	
										</td>
									</tr>
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="nombreCorto">Nombre Corto:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="nombreCorto" name="nombreCorto" size="35" disabled="true" readOnly="true"/>	
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="tipoInstitID">Tipo de Instituci&oacute;n:</label>
										</td>
										<td>
											<select id="tipoInstitID" name="tipoInstitID" disabled="true" readOnly="true">
												<option value="">SELECCIONAR</option>
												<option value="1">BANCA COMERCIAL</option>
										     	<option value="2">BANCA DESARROLLO</option>
										     	<option value="3">SOFIPO</option>
												<option value="4">SOFOM</option>
										     	<option value="5">SOFOL</option>
										     	<option value="6">SOCAP</option>
										     	<option value="7">FONDEADORES</option>
											</select>	
										</td>
									</tr>	
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="folio">Folio:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="folio" name="folio" size="35" disabled="true" readOnly="true"/>	
										</td>
									</tr>	
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="claveParticipaSpei">Clave Participa:</label>
										</td>
										<td nowrap="nowrap">
											<input type="text" id="claveParticipaSpei" name="claveParticipaSpei" size="35" disabled="true" readOnly="true"/>	
										</td>
									</tr>
									<tr>
										<td class="label" >
												<label for="numContrato">No. Contrato:</label>
											</td>
											<td >
												<input type="text" id="numContrato" name="numContrato" size="40" tabindex="4" maxlength="6" onkeypress="return validaNumero(event);" />	
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="cveEmision">Clave Emisi&oacute;n:</label>
											</td>
											<td>
												<input type="text" id="cveEmision" name="cveEmision" size="40" tabindex="5" maxlength="6" onkeypress="return validaNumero(event);"/>	
											</td>
										</tr>	
									<tr>
											<td class="label" nowrap="nowrap">
												<label for="domicilia">Maneja Domiciliaci&oacute;n:</label>
											</td>
											<td nowrap="nowrap">
												<input type="radio" id="domiciliaSi" name="domicilia" value="S" tabindex="6"/>
												<label> SI </label>
												<input type="radio" id="domiciliaNo" name="domicilia" value="N" tabindex="7"/>
												<label> NO </label>
												
											</td>
										</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-corner-all">Dep&oacute;sitos Referenciados</legend>
									<table>
										<tr>
											<td class="label" nowrap="nowrap">
												<label for="generaRefeDepSi">Genera Referencia Dep&oacute;sitos:</label>
											</td>
											<td nowrap="nowrap">
												<input type="radio" id="generaRefeDepSi" name="generaRefeDepRadio" value="S" tabindex="8"/>
												<label> SI </label>
												<input type="radio" id="generaRefeDepNo" name="generaRefeDepRadio" value="N" tabindex="9"/>
												<label> NO </label>
												<input type="hidden" id="generaRefeDep" name="generaRefeDep" />
											</td>
										</tr>
										<tr>
											<td class="label">
												<label for="algoritmoID">Algoritmo:</label>
											</td>
											<td>
												<select id="algoritmoID" name="algoritmoID" tabindex="10">
													<option value="">SELECCIONAR</option>
												</select>	
											</td>
										</tr>
										<tr name="convenio" style="">
										<td class="label" >
												<label for="numConvenio">N&uacute;mero de Convenio:</label>
											</td>
											<td >
												<input type="text" id="numConvenio" name="numConvenio" size="40" tabindex="11" maxlength="45"/>	
											</td>
										</tr>
										<tr name="convenio" style="">
											<td class="label">
												<label for="convenioInter">N&uacute;mero de Convenio Interbancario:</label>
											</td>
											<td>
												<input type="text" id="convenioInter" name="convenioInter" size="40" tabindex="12" maxlength="45"/>	
											</td>
										</tr>										
									</table>
								</fieldset>								
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="submit" id="actualizar" name="actualizar" class="submit" tabIndex="20" value="Actualizar" />
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
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>
