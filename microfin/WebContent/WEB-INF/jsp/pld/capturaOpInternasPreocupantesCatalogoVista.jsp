<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
	<title>SAFI - Captura de Operaciones Internas Preocupantes</title>
	<link rel="stylesheet" type="text/css" href="css/template.css" media="screen,print"  />
	<link rel="stylesheet" type="text/css" href="css/menuTree.css" media="screen,print"  />
	<link rel="stylesheet" type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css"  />
 	<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
 	<script type="text/javascript" src="js/jquery.ui.datepicker-es.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.13.custom.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.13.min.js"></script>
	<script type="text/javascript" src="js/jquery.validate.js"></script>
	<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
	<script type="text/javascript" src="js/jquery.blockUI.js"></script>
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" ></link>
	<script type='text/javascript' src='js/jquery.hoverIntent.minified.js'></script>
	<script type="text/javascript" src="js/jquery.plugin.tracer.js"></script>
	<script type="text/javascript" src="dwr/interface/procInternosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/motivosPreoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/opIntPreocupantesServicio.js"></script>
 	<script type="text/javascript" src="dwr/engine.js"></script>
 	<script type="text/javascript" src="dwr/util.js"></script>
 	<script type="text/javascript" src="js/formaPLD.js"></script>
	<script type="text/javascript" src="dwr/interface/companiasServicio.js"></script>
	<script type="text/javascript" src="js/pld/capturaOpIntPreocupantes.js"></script>
	</head>
<body>
	<div id="contenedorForma">
	<label for="desplegado1">Origen Datos: </label>
		<select id="desplegado1" name="desplegado1"   iniforma="false">
         	<option value="">SELECCIONA</option>
      	</select>
   		<br></br>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="capturaOperacion">
	 Operación Preocupante: Cualquier actividad, conducta o comportamiento de los directivos, funcionarios, empleados y apoderados de las 		Entidades que por sus características, pudiera contravenir o vulnerar la aplicación de lo dispuesto en la Ley y las presentes
	 disposiciones, o aquella que por cualquier otra causa resulte dubitativa para las Entidades.
<br>
</br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Captura de Operaciones Internas Preocupantes</legend>
								<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="1"></label>
											<label for="consecutivo">Número: </label>
											<form:input id="opeInterPreoID" name="opeInterPreoID" path="opeInterPreoID" size="5" tabindex="1"  />
										</td>
									</tr>
								</table>
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Datos Generales del Registro de la Operación</legend>
								<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">

									<tr>

										<td class="label">
											<label for="fechaDeteccion">Fecha Detección: </label>
										</td>
										<td>
											<form:input id="fechaDeteccion" name="fechaDeteccion" path="fechaDeteccion" size="12" esCalendario="true" tabindex="2" />
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="motivo">Motivo:</label>
										</td>
										<td>
											<form:input id="catMotivPreoID" name="catMotivPreoID" path="catMotivPreoID" size="12" onBlur=" ponerMayusculas(this)" tabindex="3" />
											<textarea id="descripcionMotivo" name="descripcionMotivo" cols="37" rows="2"  onBlur=" ponerMayusculas(this)" readOnly="true"></textarea>
										</td>
									</tr>
									<tr>
									<td class="label">
											<label for="procesoInterno">Proceso Interno:</label>
										</td>
										<td>
											<form:input id="catProcedIntID" name="catProcedIntID" path="catProcedIntID" size="12" tabindex="5" />
											<textarea id="descripcionProceso" name="descripcionProceso" cols="37" rows="2"   readOnly="true"></textarea>
										</td>
									<td class="separador"></td>
									<td class="label">
											<label for="personaReportar">Persona a Reportar:</label>
										</td>
										<td>
											<form:input id="clavePersonaInv" name="clavePersonaInv" path="clavePersonaInv" size="12" tabindex="11"  />
											<input type="hidden" id="descripcionSucursal" name="descripcionSucural" size="40" tabindex="12" disabled="true"/>
											<form:input id="nomPersonaInv" name="nomPersonaInv" path="nomPersonaInv" size="40"   maxlength="100" onBlur=" ponerMayusculas(this)"/>

										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="frecuencia">Existe Frecuencia:</label>
										</td>
										<td>
											<form:radiobutton id="frecuencia" name="frecuencia"  tabindex="13" path="frecuencia"
			 													value="S"   />
											<label for="frecuenciaS">Si</label>

			 								<form:radiobutton id="frecuencia2" name="frecuencia2"  tabindex="14" path="frecuencia"
																 value="N"   checked="checked"/>
											<label for="frecuenciaN">No</label>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="describirFrecuencia" id="descripcionF" style="display: none">Describir Frecuencia:</label>
										</td>
										<td>

										    <form:textarea id="desFrecuencia" name="desFrecuencia" cols="50" rows="2" path="desFrecuencia" tabindex="15" maxlength="50" onBlur=" ponerMayusculas(this)" style="display: none"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="InvolucraCliente">Involucra <s:message code="safilocale.cliente"/>:</label>
										</td>
										<td>
											<input id="involucraCliente" type= "radio" name="involucraCliente"  tabindex="16" value="S"  iniforma="false"
                               						 /> <label for="si">Si</label>
											<input id="involucraCliente2" type= "radio" name="involucraCliente2" tabindex="17" value="N"
                            					     checked="checked"/> <label for="no">No</label>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="clienteInvolucrado" id="clienteInv" style="display: none">Nombre del <s:message code="safilocale.cliente"/>:</label>
										</td>
										<td>
											<form:input id="cteInvolucrado" name="cteInvolucrado" path="cteInvolucrado" size="51" tabindex="18" maxlength="50" style="display: none" onBlur=" ponerMayusculas(this)"/>
										</td>
									</tr>
									</table>
									<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="descripcion">Descripción:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																				 &nbsp;&nbsp;&nbsp;</label>
											<form:textarea id="desOperacion" name="desOperacion" cols="100" rows="5" path="desOperacion" tabindex="19"  onBlur=" ponerMayusculas(this)" maxlength="300"/>
										</td>
									</tr>
							</table>
				<br>
				</fieldset>
			</fieldset>
			<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="guardar" name="guardar" class="submit"
							 value="Grabar" tabindex="20"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="desplegado" name="desplegado"/>
						</td>
					</tr>
				</table>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>

</body>
<div id="mensaje" style="display: none;"></div>
</html>