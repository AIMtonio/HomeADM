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
	 <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
 
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/cliente/hiscambiosucurcli.js"></script> 
</head>
	<body>
	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="hiscambiosucurcliBean">
	
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Sucursal</legend>
							
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend ><s:message code="safilocale.cliente"/></legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
								</td>
								<td>
									<form:input type='text' id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" />
									<input type='text' id="clienteIDDes" name="clienteIDDes" size="60" readonly="true"/>
								</td>
								<td class="separador">
									<input type="hidden" id="usuarioID" name="usuarioID" size="10" />  	
								 </td>
								<td class="label">
									<label for="estatus">Estatus:</label>
								</td>
								<td>
									<input type='text' id="estatus" name="estatus" size="15" readonly="true" />
								</td>
							</tr>
<!-- 							<tr> -->
<!-- 								<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 								<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
<!-- 							</tr> -->
							<tr>
								<td class="label">
									<label for="sucursalOrigen">Sucursal:</label>
								</td>
								<td>
									<form:input type='text' id="sucursalOrigen" name="sucursalOrigen" path="sucursalOrigen" size="5" readonly="true" />
									<input type='text' id="sucursalOrigenDes" name="sucursalOrigenDes" size="50" readonly="true"/>
								</td>
								<td class="separador"> </td>
								 <td nowrap="nowrap">
									<label for="fechaNacimiento">Fecha Nacimiento:</label>
								</td>
								<td>
									<input type='text' id="fechaNacimiento" name="fechaNacimiento" size="15" readonly="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="RFC">RFC:</label>
								</td>
								<td>
									<input type='text' id="RFC" name="RFC" size="25" readonly="true" />
								</td>
								<td class="separador"> </td>
								<td class="label">
									<label for="edad">Edad:</label>
								</td>
								<td>
									<input type='text' id="edad" name="edad" size="6" readonly="true" />
									<label for="anios"> Años</label>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="tipoPersona">Tipo Persona:</label>
								</td>
								<td>
									<input type='text' id="tipoPersona" name="tipoPersona"  size="60" readonly="true" />
								</td>
								<td class="separador"> </td>
								 <td nowrap="nowrap">
									<label for="fechaIngreso">Fecha Ingreso:</label>
								</td>
								<td>
									<input type='text' id="fechaIngreso" name="fechaIngreso"  size="15" readonly="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="CURP">CURP:</label>
								</td>
								<td>
									<input type='text' id="CURP" name="CURP" size="28" readonly="true" />
								</td>
								<td class="separador"> </td>
								<td class="separador"> </td>
								<td class="separador"> </td>
							</tr>
							<tr id="trRazonSocial">
								<td class="label">
									<label for="razonSocial">Raz&oacute;n Social:</label>
								</td>
								<td>
									<input type='text' id="razonSocial" name="razonSocial" size="80" readonly="true" />
								</td>
								<td class="separador"> </td>
								<td class="separador"> </td>
								<td class="separador"> </td>
							</tr>
							<tr>
								<td class="label">
									<label for="promotorAnterior">Promotor Actual:</label>
								</td>
								<td>
									<input type='text' id="promotorAnterior" name="promotorAnterior" size="10" readonly="true" />
									<input type='text' id="promotorAnteriorDes" name="promotorAnteriorDes" size="65" readonly="true"/>
								</td>
								<td class="separador"> </td>
								<td class="separador"> </td>
								<td class="separador"> </td>
							</tr>
						</table>
					</fieldset>
					
					<br>
					
					<div id="divNuevaSucursal">
						
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend >Sucursal Destino</legend>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="label">
											<label for="sucursalDestino">Sucursal:</label>
										</td>
										<td>
											<form:input type='text' id="sucursalDestino" name="sucursalDestino" path="sucursalDestino" size="5" tabindex="2"  />
											<input type='text' id="sucursalDestinoDes" name="sucursalDestinoDes" size="60" readonly="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="promotorActual">Promotor:</label>
										</td>
										<td>
											<form:input type='text' id="promotorActual" name="promotorActual" path="promotorActual" size="5" tabindex="3"  />
											<input type='text' id="promotorActualDes" name="promotorActualDes" size="60" readonly="true"/>
										</td>
									</tr>
								</table>
							</fieldset>
						</div>
								 
						
						
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="submit" id="grabar" class="submit" value="Grabar" tabindex="4"/>
										 <a id="ligaGenerar" href="" target="_blank" >
											<input type="button" id="imprimir" class="submit" value="Imprimir Formato" tabindex="5" style="display: none;" />
										 </a>
									 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" size="10" />  	
									 	<input type="hidden" id="avalados" name="avalados" />  
									 	<input type="hidden" id="inicioAvalados" name="inicioAvalados" />  		
									 	<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />
									</td>
								</tr> 
						 </table>
						 	
					 </div>
					<div id="creditosAvalados" style="display: none;" ></div>	
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