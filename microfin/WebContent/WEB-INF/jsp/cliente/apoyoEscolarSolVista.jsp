<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<!-- se cargar los servicios para accesar por dwr -->
	 <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/socioMenorServicio.js"></script>  	
	 <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  	 
	 <script type="text/javascript" src="dwr/interface/apoyoEscolarSolServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/apoyoEscCicloServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/cliente/apoyoEscolarSol.js"></script>
</head>
<body>

	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="apoyoEscolarSolBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud Apoyo Escolar</legend>

					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="lblclienteID"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<form:input type='text' id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" iniForma="false" />
								<input type='text' id="clienteIDDes" name="clienteIDDes" size="80" readonly="true" iniForma="false"/>
							</td>
							<td> </td>
							<td> </td>
						</tr>
<!-- 						<tr> -->
<!-- 							<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 							<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>						 -->
<!-- 						</tr> -->
						
						<tr>
							<td class="label">
								<label for="apoyoEscSolID">Solicitud: </label>
							</td>
							<td>
								<form:input type='text' id="apoyoEscSolID" name="apoyoEscSolID" path="apoyoEscSolID" size="15" tabindex="3" maxlength="10" />								
							</td>
							<td> </td>
							<td> </td>
						</tr>
					</table>
										
					
					<div id="datosSolicitud">
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="usuarioRegistra">Usuario Registro: </label>
							</td>
							<td>
							  <form:input type="text" id="usuarioRegistra" name="usuarioRegistra" path="usuarioRegistra" size="70" readonly="true" tabindex="4" />							
							</td>
							<td class="label">
								<label for="estatus">Estatus: </label>
							</td>
							<td>
								<form:input type="text" id="estatus" name="estatus" path="estatus" size="15" readonly="true" tabindex="5" />								
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaRegistro">Fecha Registro: </label>
							</td>
							<td>
								<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="15" readonly="true" tabindex="6" />								
							</td>
							<td class="label">
						<!-- <label for="fechaAutoriza">Fecha Autorizaci&oacute;n: </label>  -->	   
							</td>
							<td>
						<!-- 		<form:input type="text" id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="15" readonly="true" /> --> 								
							</td>
						</tr>
					</table>
				</div>

				
		<div id="datosCliente">
		<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><s:message code="safilocale.cliente"/></legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="sucursalID">Sucursal:</label>
							</td>
							<td>
								<input type='text' id="sucursalID" name="sucursalID" path="sucursalID" size="4" readonly="true" iniForma="false" tabindex="7"/>
								<input type='text' id="sucursalIDDes" name="sucursalIDDes" size="50" readonly="true" iniForma="false" tabindex="8"/>
							</td>							
							<td class="label">
								<label for="fechaIngreso">Fecha Ingreso: </label>
							</td>
							<td>
								<input type="text" id="fechaIngreso" name="fechaIngreso" path="fechaIngreso" size="15" readonly="true" iniForma="false" tabindex="9"/>								
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="RFC">RFC: </label>
							</td>
							<td>
								<input type="text" id="RFC" name="RFC" path="RFC" size="20"  readonly="true" iniForma="false" tabindex="10"/>								
							</td>
							<td class="label">
								<label for="edadCliente">Edad Actual: </label>
							</td>
							<td>
								<form:input type="text" id="edadCliente" name="edadCliente" path="edadCliente" size="5" readonly="true" iniForma="false" tabindex="11" />
								<label for="RFC">Año (s) </label>								
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoPersona">Tipo Persona: </label>
							</td>
							<td>
								<input type="text" id="tipoPersona" name="tipoPersona" path="tipoPersona" size="20" readonly="true" iniForma="false" tabindex="12"/>								
							</td>
							<td class="label">
								<label for="fechaNacimiento">Fecha Nacimiento: </label>
							</td>							
							<td>
								<input type="text" id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="15" readonly="true" iniForma="false" tabindex="13" />								
							</td>	
						</tr>
					</table>
				</fieldset>
		</div>		
				
		<div id="datosTutor">	
		<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos de Tutor</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="tutorID"><s:message code="safilocale.cliente"/>:</label>
							</td>
							<td>
								<input type='text' id="tutorID" name="tutorID" size="15"   readonly="true"  iniForma="false" tabindex="14" />
								<input type='text' id="tutorIDDes" name="tutorIDDes" size="80" readonly="true"  iniForma="false" tabindex="15"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="parentesco">Parentesco: </label>
							</td>
							<td>
								<input type="text" id="parentesco" name="parentesco" path="parentesco" size="40"  readonly="true"  iniForma="false" tabindex="16"/>								
							</td>
						</tr>
					</table>
				</fieldset>
			</div>		
				
			<div id="datosApoyoEscolarReg">
			<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Apoyo(s) Escolar(es) Registrado(s)</legend>
					<!-- aqui va la lista en forma de grid -->
					<div id="listaSolicitudes"   style="overflow: scroll; width: 1000px; height: 150px;display: none;"></div>
				</fieldset>
			</div>		
								
				
		 <div id="datosApoyoEscolar">
		 <br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Datos Apoyo Escolar</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="apoyoEscCicloID">Grado Escolar:</label>
							</td>
							<td>
								<select id="apoyoEscCicloID" name="apoyoEscCicloID" path="apoyoEscCicloID" tabindex="26" type="select">
									<option value="">SELECCIONAR<option>
								</select>
							</td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="label">
								<label for="cicloEscolar">Ciclo Escolar: </label>
							</td>
							<td>
								<form:input type="text" id="cicloEscolar" name="cicloEscolar" path="cicloEscolar" size="20" tabindex="27" maxlength="50" onBlur="ponerMayusculas(this);" />								
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="gradoEscolar">No. Grado: </label>
							</td>
							<td>
								<form:input type="text" id="gradoEscolar" name="gradoEscolar" path="gradoEscolar" size="5" tabindex="28" maxlength="3" />								
							</td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="separador"> </td>
							<td class="label">
								<label for="promedioEscolar">Promedio: </label>
							</td>
							<td>
								<form:input type="text" id="promedioEscolar" name="promedioEscolar" path="promedioEscolar" size="10" tabindex="29" maxlength="6" style="text-align: right;"/>
								<form:input type="hidden" id="sucursalRegistroID" name="sucursalRegistroID" path="sucursalRegistroID" size="10" tabindex="30"/>
							</td>
						</tr>
					</table>
					
					
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Escuela</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="nombreEscuela">Nombre:</label>
								</td>
								<td>
									<form:input type='text' id="nombreEscuela" name="nombreEscuela" path="nombreEscuela" size="120" tabindex="31" maxlength="200" onBlur="ponerMayusculas(this);" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="direccionEscuela">Direcci&oacute;n: </label>
								</td>
								<td>
									<form:textarea id="direccionEscuela" name="direccionEscuela" path="direccionEscuela" COLS="48" ROWS="3" tabindex="32" maxlength="500"  onBlur="ponerMayusculas(this);" /> 								
								</td>
							</tr>
						</table>
					</fieldset>
				<br>
				<div id="documentosAdjuntos">
				 <fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Documentos Adjuntos</legend> 	
						<div id="gridDocumentosAdjuntos"> 
								<!--  para los archivos adjuntos -->
						</div>						
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="42"/>
									</td>
								</tr> 
						   </table>						
					</fieldset> 
				</div>	
				</fieldset>
		</div>
		
								
		<div id="autorizar">
		<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Autorizar</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">								
									<input type="radio" id="autorizar" name="autorizar" value="A" tabindex="43"  unchecked="true"/><label>Autorizar</label>						
								</td>
								<td class="label">
									<input type="radio" id="rechazar" name="autorizar" value="X"  tabindex="44"  unchecked="true"/><label>Rechazar</label>
								</td>
								<td class="separador"> </td>
								<td class="label">
										<label for="comentario">Comentario: </label>
										<textarea id="comentario" name="comentario" cols="60" rows="2" tabindex="45" onBlur="ponerMayusculas(this);"></textarea>								
								</td>
								<td align="right" colspan="5">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="46"/>
									<input type="hidden" id="usuarioAutoriza" name="usuarioAutoriza"/>
									<input type="hidden" id="rolAutoriza" name="rolAutoriza"/>
								</td>
							</tr>
						</table>
				</fieldset>
			</div>	
				<br>
				<br>
				
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="right" colspan="5">
					<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="47"/>
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="48"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>
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
	<div id="imagenCte" style="display: none;">
		<img id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" border ="0" alt="Foto cliente"/> 
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
	
</body>
<div id="mensaje" style="display: none;"></div>
</html>