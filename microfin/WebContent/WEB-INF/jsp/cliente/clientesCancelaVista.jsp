<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html"%> 
<%@ page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/motivActivacionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clientesCancelaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/socioMenorServicio.js"></script>
	<script type="text/javascript" src="js/cliente/clientesCancela.js"></script>
</head>
<body>

<c:set var="varAreaRequiere" value="<%= request.getParameter(\"areaRequiere\") %>"/>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clientesCancelaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">  
<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud Cancelaci&oacute;n <s:message code="safilocale.cliente"/></legend>
	<table style="width: 100%">
		<tr>
			<td>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">	
					<table style="width: 100%">
						<tr>
							<td class="label">
								<label for="clienteCancelaID">Folio:</label>
							</td>
							<td>
								<form:input type="text" id="clienteCancelaID" name="clienteCancelaID" path="clienteCancelaID" size="12" tabindex="1"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2"/>
								<input type="text" id="nombreCliente" name="nombreCliente" size="60" tabindex="3" disabled= "disabled" readOnly="readonly" />
							</td>
						</tr>
						
<!-- 						<tr> -->
<!-- 							<td></td><td></td><td></td> -->
<!-- 							<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 							<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>						 -->
<!-- 						</tr> -->
						
						
						<tr>
							<td class="label">
								<label for="fechaRegistro">Fecha Registro:</label>
							</td>
							<td>
								<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="12" tabindex="4" disabled ="true" readonly="true"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="usuarioRegistra">Usuario Registra:</label>
							</td>
							<td nowrap="nowrap">
								<form:input type="text" id="usuarioRegistra" name="usuarioRegistra" path="usuarioRegistra" size="12" tabindex="5" disabled ="true" readonly="true"/>
								<input type="text" id="usuarioRegistraDes" name="usuarioRegistraDes" size="60" tabindex="6" disabled ="disabled" readonly="readonly"/>
							</td>	
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="estatus" style="display: none" id="lblEstatus">Estatus Solicitud:</label>
							</td>
							<td>
								<form:select id="estatus" name="estatus" path="estatus" tabindex="7" disabled="true" style="display: none" >
									<form:option value="R">REGISTRADO</form:option>
							     	<form:option value="A">AUTORIZADO</form:option>
							     	<form:option value="P">PAGADO</form:option>
						        </form:select>
							</td>		
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<table style="width: 100%">
						<tr>
							<td>
								<input type="radio" id="areaAtencionSocio" name="areaAtencionSocio" value="Soc" tabindex="8" readonly="readonly" disabled="disabled"/><label for="areaAtencionSocio">&Aacute;rea Atenci&oacute;n a <s:message code="safilocale.cliente"/></label>
							</td>
							<td class="separador"></td>
							<td>
								<input type="radio" id="areaProtecciones" name="areaProtecciones" value="Pro" tabindex="9" readonly="readonly" disabled="disabled"/><label for="areaProtecciones">&Aacute;rea de Protecciones</label>
							</td>
							<td class="separador"></td>
							<td>
								<input type="radio" id="areaCobranza" name="areaCobranza" value="Cob" tabindex="10" readonly="readonly" disabled="disabled"/><label for="areaCobranza">&Aacute;rea de Cobranza</label>
								<form:input type="hidden" id="areaCancela" name="areaCancela" path="areaCancela" value="${varAreaRequiere}" tabindex="11" disabled ="true" readonly="true"/>					
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><s:message code="safilocale.cliente"/></legend>
					<table style="width: 100%">
						<tr>
							<td class="label">
								<label for="fechaNacimiento">Fecha Nacimiento:</label>
							</td>
							<td>
								<input type="text" id="fechaNacimiento" name="fechaNacimiento"  size="18" tabindex="12" readonly="readonly" disabled="disabled"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="sucursalOrigen">Sucursal <s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<input type="text" id="sucursalOrigen" name="sucursalOrigen"  size="12" tabindex="13" readonly="readonly" disabled="disabled"/>
								<input type="text" id="sucursalOrigenDes" name="sucursalOrigenDes"  size="40" tabindex="14" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="rfc">RFC:</label>
							</td>
							<td>
								<input type="text" id="rfc" name="rfc"  size="18" tabindex="15" readonly="readonly" disabled="disabled"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="edad">Edad:</label>
							</td>
							<td>
								<input type="text" id="edad" name="edad"  size="4" tabindex="16" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaIngreso">Fecha Ingreso:</label>
							</td>
							<td>
								<input type="text" id="fechaIngreso" name="fechaIngreso"  size="18" tabindex="17" readonly="readonly" disabled="disabled"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="tipoPersona">Tipo Persona:</label>
							</td>
							<td>
								<input type="text" id="tipoPersona" name="tipoPersona"  size="40" tabindex="18" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<div id="divDatosTutor">
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Datos del Tutor</legend>
					<table style="width: 100%">
						<tr>
							<td class="label">
								<label for="clienteIDTutor"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<input type="text" id="clienteIDTutor" name="clienteIDTutor"  size="12" tabindex="19" readonly="readonly" disabled="disabled"/>
								<input type="text" id="clienteIDTutorDes" name="clienteIDTutorDes"  size="80" tabindex="20" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="parentescoID">Parentesco:</label>
							</td>
							<td>
								<input type="text" id="parentescoIDDes" name="parentescoIDDes"  size="50" tabindex="21" readonly="readonly" disabled="disabled"/>
							</td>
						</tr>			
					</table>
				</fieldset>
			</div>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Cancelaci&oacute;n</legend>
					<table style="width: 100%">
						<tr id="trActaFecDefuncion">
							<td class="label">
								<label for="actaDefuncion">Acta de Defunci&oacute;n:</label>
							</td>
							<td>
								<form:input type="text" id="actaDefuncion" name="actaDefuncion" path="actaDefuncion" size="20" tabindex="22" maxlength="100"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaDefuncion">Fecha de Defunci&oacute;n:</label>
							</td>
							<td>
								<form:input type="text" id="fechaDefuncion" name="fechaDefuncion" path="fechaDefuncion" size="12" 
									esCalendario="true" tabindex="23"/>
							</td>
						</tr>
						<tr id="trAplicaSeguro">
							<td class="label">
								<label for="aplicaSeguro">Aplica Seguro:</label>
							</td>
							<td>
								<input type="radio" id="aplicaSeguroSi" name="aplicaSeguroSi" value="S" tabindex="24" /><label for="aplicaSeguroSi">Si</label>
								<input type="radio" id="aplicaSeguroNo" name="aplicaSeguroNo" value="N" tabindex="25" /><label for="aplicaSeguroNo">No</label>
								<form:input type="hidden" id="aplicaSeguro" name="aplicaSeguro" path="aplicaSeguro" size="12" tabindex="26" disabled ="true" readonly="true"/>
							</td>		
						</tr>
						<tr>
							<td class="label">
								<label for="motivoActivaID">Motivo:</label>
							</td>
							<td>
								<form:select id="motivoActivaID" name="motivoActivaID" path="motivoActivaID" tabindex="27" >
									<form:option value="">SELECCIONAR</form:option>
						        </form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="comentarios">Comentario:</label>
							</td>
							<td>
								<textarea id="comentarios" name="comentarios" rows="2" cols="50" 	onblur="ponerMayusculas(this)"  
									tabindex="28" maxlength="500"/></textarea>
							</td>
						</tr>			
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">
				<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar"  tabindex="29"/>
				<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar"  tabindex="30"/>
				<input type="button" id="impSolicitud" name="impSolicitud" class="submit" value="Imp. Solicitud"  tabindex="31"/>
				<a id="ligaGenerarPago" href="" target="_blank" >
					<button type="button" id="impPago" name="impPago" class="submit" tabindex="32" >Imp. Pago</button>
				</a>
				<input type="hidden" id="esMenorEdad" name="esMenorEdad"  value=""/>
				<input type="hidden" id="usuarioAutoriza" name="usuarioAutoriza"  value=""/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
				
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
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>


