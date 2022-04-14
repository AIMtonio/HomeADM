<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<!-- se cargar los servicios para accesar por dwr -->
	 <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	 <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
	 <script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/clidatsocioeServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/capacidadPagoServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script> 
	   
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/originacion/capacidadPago.js"></script> 
</head>
	<body>
	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="capacidadPagoBean">
	
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Estimaci&oacute;n de Capacidad de Pago</legend>
	
	
	
	
	
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
								</td>
								<td>
									<form:input type='text' id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1"/>
									<input type="hidden" id="pagaIVA" name="pagaIVA" size="10" />  
								</td>
								<td class="separador">
									<input type="hidden" id="usuarioID" name="usuarioID" size="10" />  
									<input type="hidden" id="sucursalID" name="sucursalID" size="10" />  
								</td>
								<td class="separador">
									<input type="hidden" id="tasaInteres1" name="tasaInteres1" size="10" />  
									<input type="hidden" id="tasaInteres2" name="tasaInteres2" size="10" />  
									<input type="hidden" id="tasaInteres3" name="tasaInteres3" size="10" />  
								</td>
								<td class="label">
									<label for="clasificacion">Clasificaci&oacute;n <s:message code="safilocale.cliente"/>:</label>
								</td>
								<td>
									<input type='text' id="clasificacion" name="clasificacion" path="clasificacion" size="2" readonly="true" style='text-align:center;'/>
									<input type='text' id="calificacion" name="calificacion" path="calificacion" size="7" readonly="true" style='text-align:right;'/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="ingresoMensual">Ingreso Mensual:</label>
								</td>
								<td>
									<form:input type='text' id="ingresoMensual" name="ingresoMensual" path="ingresoMensual" size="15" esMoneda="true" readonly="true" style='text-align:right;' />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label for="gastoMensual">Gasto Mensual:</label>
								</td>
								<td>
									<form:input type='text' id="gastoMensual" name="gastoMensual" path="gastoMensual" size="15" esMoneda="true" readonly="true" style='text-align:right;'/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="montoSolicitado">Monto Solicitado:</label>
								</td>
								<td>
									<form:input type='text' id="montoSolicitado" name="montoSolicitado" path="montoSolicitado" size="15" tabindex="2" maxlength="9" esMoneda="true" style='text-align:right;'/>
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label for="abonoPropuesto">Abono Propuesto:</label>
								</td>
								<td>
									<form:input type='text' id="abonoPropuesto" name="abonoPropuesto" path="abonoPropuesto" size="15" tabindex="3" maxlength="9" esMoneda="true" style='text-align:right;'/>
								</td>
							</tr>
						</table>
						 
						<br>
					
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td valign="top">
									<label for="productoCredito1">Producto Cr&eacute;dito 1:</label>									
								</td>
								<td valign="top">
									<select id="productoCredito1" name="productoCredito1" path="productoCredito1" tabindex="4" >
										<option value="">SELECCIONAR<option>
									</select>
									<input type="hidden" id="producCredito1" name="producCredito1" size="10" />  
								</td>
								<td class="separador"></td>
								<td>
									<label for="productoCredito2">Producto Cr&eacute;dito 2:</label>
								</td>
								<td valign="top">
									<select id="productoCredito2" name="productoCredito2" path="productoCredito2" tabindex="5" >
										<option value="">SELECCIONAR<option>
									</select>
									<input type="hidden" id="producCredito2" name="producCredito2" size="10" />  
								</td>
							</tr>
							<tr>
								<td  valign="top">
									<label for="productoCredito3">Producto Cr&eacute;dito 3:</label>
								</td>
								<td valign="top">
									<select id="productoCredito3" name="productoCredito3" path="productoCredito3" tabindex="6" >
										<option value="">SELECCIONAR<option>
									</select>
									<input type="hidden" id="producCredito3" name="producCredito3" size="10" />  
								</td>
								<td class="separador"></td>
								<td  valign="top">
									<label for="plazo">Plazo:</label>
								</td>
								<td>
									<select multiple id="plazo" name="plazo" path="plazo" tabindex="7" size ="10" type="select">
										<option value="">SELECCIONAR<option>
									</select>
								</td>
							</tr>
						</table>
						
						 <div id="divUltimaEstimacion">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>&Uacute;ltima Estimaci&oacute;n</legend>
								<table border="0" cellpadding="0" cellspacing="0" width="70">
									<tr>
										<td>
											<label for="fecha">Fecha</label>									
										</td>
										<td>
											<label for="ultimaCobertura">Cobertura</label>									
										</td>
									</tr>
									<tr>
										<td>
											<input type='text' id="fecha"  size="15" readonly="true" />
										</td>
										<td>
											<input type='text' id="ultimaCobertura"  size="15"  readonly="true"  esMoneda="true" style='text-align:right;'/>
										</td>
									</tr>
								</table>
								</fieldset>
						</div>
						
						
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="button" id="calcular"  class="submit" value="Calcular" tabindex="8"/>
									</td>
								</tr> 
						 </table>	
						 
						 <br>
						 
						 <div id="divResultadoEstimacion">
						
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Resultado</legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td>
										<label for="abonoEstimado">Abono Estimado:</label>									
									</td>
									<td>
										<form:input type='text' id="abonoEstimado" name="abonoEstimado" path="abonoEstimado" size="15" tabindex="1" readonly="true" style='text-align:right;' />
									</td>
								</tr>
								<tr>
									<td>
										<label for="ingresosGastos">Ingresos - Gastos:</label>									
									</td>
									<td>
										<form:input type='text' id="ingresosGastos" name="ingresosGastos" path="ingresosGastos" size="15" tabindex="1" readonly="true"  esMoneda="true"  style='text-align:right;'/>
									</td>
								</tr>
								<tr>
									<td>
										<b>% Cobertura:</b>									
									</td>
									<td>
										<form:input type='text' id="cobertura" name="cobertura" path="cobertura" size="15" tabindex="1" readonly="true"  esMoneda="true" style='text-align:right;' />
										<b id="lblCobertura">+/-</b>
									</td>
								</tr>
								<tr>
									<td> </td>
									<td> <h1></h1></td>
								</tr>
								<tr>
									<td colspan="2">
										<b id="etiqueta" Style="color: #8A0808;"></b>									
									</td>
								</tr>
								<tr>
									<td>
										<label for="cobSinPrestamo">Cobertura Sin Pr&eacute;stamo:</label>									
									</td>
									<td>
										<form:input type='text' id="cobSinPrestamo" name="cobSinPrestamo" path="cobSinPrestamo" size="15" tabindex="1" readonly="true"  esMoneda="true" style='text-align:right;'/>
										<label for="cobSinPrestamo">%</label>
									</td>
								</tr>
								<tr>
									<td>
										<label for="cobConPrestamo">Cobertura Con Pr&eacute;stamo:</label>									
									</td>
									<td>
										<form:input type='text' id="cobConPrestamo" name="cobConPrestamo" path="cobConPrestamo" size="15" tabindex="1" readonly="true" esMoneda="true" style='text-align:right;'/>
										<label for="cobSinPrestamo">%</label>
									</td>
								</tr>
							</table>
							
							
							
							<br>
							 
							<!-- Muestra la tabla con las cuotas calculadas en la simulacion -->
							<div id="tablaCuotas"></div>
							
						</fieldset>
					
					
						<br>
						
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td align="right" colspan="5">
										<input type="submit" id="grabar" class="submit" value="Grabar" tabindex="42"/>
									 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" size="10" />  	
									</td>
								</tr> 
						 </table>
						 	
					 </div>

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