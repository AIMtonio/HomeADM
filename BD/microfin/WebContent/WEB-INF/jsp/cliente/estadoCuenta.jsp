<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/edoCtaPeriodoEjecutadoServicio.js"></script>
	   	<script type="text/javascript" src="js/cliente/consultaEdoCuenta.js"></script>
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="estadoCuentaUnicoBean">     
			<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
				<legend class="ui-widget ui-widget-header ui-corner-all">Estado de Cuenta &Uacute;nico</legend> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Datos del <s:message code="safilocale.cliente"/></legend>	
							<table border="0" width="100%">
								<tr id="opcionesTipoGeneracion">
									<td class="label">
										<label>Tipo Generaci&oacute;n:</label>
									</td>
									<td class="separador"></td>
									<td>
										<input type="radio" id="tipoGeneracionM" name="opcionesGeneracion" value="M" tabindex="1"  checked="checked" >
										<label> Mensual </label>
										<input type="radio" id="tipoGeneracionS" name="opcionesGeneracion" value="S" tabindex="2">
										<label> Semestral </label>
									</td>
								</tr>
								<tr id ="tarjetaIdentiCA">
									<td class="label"><label for="IdentificaSocio">N&uacute;mero Tarjeta:</label>
									<td class="separador"></td>
									<td>
										<input id="numeroTarjeta" name="numeroTarjeta" size="20" tabindex="1" type="text" />
										<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
										<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />
									</td>
								</tr>
								<tr>	   	
							     	<td class="label" > <label for="lblNombreCliente">No.<s:message code="safilocale.cliente"/>: </label> 
							     	<input type="hidden" id="clienteSocio" value="<s:message code="safilocale.cliente"/>" />
							     	</td>
			 						<td class="separador"></td>
							     	<td> 
							        	<input  type="text" id="clienteID" name="clienteID" size="12" iniForma = 'false' tabindex="1"  autocomplete="off"/>
							        	<input id="nombreCliente" name="nombreCliente"size="80" iniForma = 'false'  type="text" readOnly="true" disabled="true" />
							     	</td> 		
								</tr>  	
								<tr>
									<td>
										<label for="periodo">Periodo: </label>
									</td>
									<td class="separador"></td>
									<td>
										<select name="periodo" id="periodo" tabindex="2">
										</select>
									</td>
									<td>&nbsp;</td>
								</tr>
							</table>
							<table border="0" width="100%"> 
								<tr>
									<td colspan="5">
										<table align="right">
											<tr>
												<td align="right">
													<input type="button" id="consultar" name="consultar" class="submit" tabIndex = "3" value="Consultar" />
													<input type="hidden" id="sucursalOrigen" name="sucursalOrigen" path="sucursalOrigen" tabindex="4"/>
													<input type="hidden" id="tipoGeneracion" name="tipoGeneracion"/>
												</td>
											</tr>
										</table>		
									</td>
								</tr>	
							</table>
					</fieldset>  
			</fieldset>   
		</form:form> 
	</div>
	
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/>
	</div>
	</body>
	<div id="mensaje" style="display: none;"/>
	</html>
