<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	    <script type="text/javascript" src="dwr/interface/aplicacionDepreciacionServicio.js"></script>
		<script type="text/javascript" src="js/activos/aplicacionDepAmor.js"></script> 
	</head>
	<body> 
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aplicacionDepreciacionBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all">Aplicaci&oacute;n de Depreciaci&oacute;n y Amortizaci&oacute;n</legend>			
					<table border="0" width="100%">
					 	<tr>	   	
							<td  nowrap="nowrap"> 
					        	<label for="anio">Año: </label> 
					    	</td> 
					    	<td class="separador"> </td> 
					    	<td>
								<select id="anio" name="anio"  path="anio" tabindex="1">
									<option value="">SELECCIONAR</option>
								</select>
							</td>	
							<td class="separador"> </td> 			
					   		<td class="label" > 
					        	<label for="mes">Mes: </label> 
					    	</td> 	
					    	<td class="separador"> </td> 				    
					   		<td>
								<select id="mes" name="mes"  path="mes" tabindex="2" >
									<option value="">SELECCIONAR</option>
								</select>
							</td>			
						</tr>
						<tr>
							<table id="descrip proceso Batch">
								<tr>
									<td class="label">
										<div class="label">
											<label> 
												<br>
													Este proceso realiza el proceso de depreciaci&oacute;n y amortizaci&oacute;n de los activos, se realizarán las siguientes acciones:
												<br>
												<br>
													* Se realizar&aacute;n los movimientos operativos que correspondan a la depreciaci&oacute;n y amortizaci&oacute;n.
												<br> 
													* Se realizar&aacute;n los movimientos contables que correspondan a la depreciaci&oacute;n y amortizaci&oacute;n.
										   		<br>
										   		<br>
													Al finalizar el proceso, favor de revisar el reporte de depreciaci&oacute;n y amortizaci&oacute;n.
										   		<br>						
											</label>
										</div>
									</td>
								</tr>
							</table>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="button" id="previo" name="previo" class="submit" value="Previo" tabindex="3"/>
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="4" onclick="return confirmar()"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="descMes" name="descMes"/>
								<input type="hidden" id="numTransaccion" name="numTransaccion" />
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<input type="hidden" id="usuarioID" name="usuarioID" />
								<input type="hidden" id="sucursalID" name="sucursalID" />
							</td>
						</tr>
					</table>
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


