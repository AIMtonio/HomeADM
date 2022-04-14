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
	 
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/originacion/reporteCapacidadPago.js"></script> 
</head>
	<body>
	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="capacidadPagoBean">
	
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Hist&oacute;rico de Estimaci&oacute;n de Capacidad de Pago</legend>	
	
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
									      <td class="label"> 
									         <label for="fechaInicio">Fecha Inicio: </label> 
									      </td>
									      <td>
									         <input type="text" id="fechaInicio" name="fechaInicio" size="12" autocomplete="off" esCalendario="true" tabindex="1" />  
									      </td> 	
								 	</tr> 
									<tr>
									      <td class="label"> 
									         <label for=""fechaFinal"">Fecha Final: </label> 
									    	</td>
									      <td>
									         <input type="text" id="fechaFin" name="fechaFin" autocomplete="off" esCalendario="true" size="12" tabindex="2" />    
									      </td> 
								 	</tr> 
									<tr>
										<td class="label">
											<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
										</td>
										<td>
											<form:input type='text' id="clienteID" name="clienteID" path="clienteID" size="15" value="0" tabindex="3" maxlength="10" />
											<input type='text' id="clienteIDDes" name="clienteIDDes" size="50" value="TODOS" readonly="true" disabled="true"/>
										</td>
									</tr>
									<tr>
										<td class="label">
											<label for="clienteID">Sucursal:</label>
										</td>
										<td>
											<form:input type='text' id="sucursalID" name="sucursalID" path="sucursalID" size="15" value="0" tabindex="4" maxlength="10" />
											<input type='text' id="sucursalIDDes" name="sucursalIDDes" size="50" value="TODAS" readonly="true" disabled="true"/>
										</td>
									</tr>
								</table>
							
								
								<br>
								<br>						 
							 
						<table align="right">
							<tr>
								<td>
									<a id="ligaGenerar" href="/reporteCapacidadPago.htm" target="_blank" >  		 
										<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
									</a>
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
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>