<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>                                             
		<script type="text/javascript"	src="dwr/interface/limitesTarDebIndividualServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/limitesTarCreIndividualServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/bitacoraEstatusTarDebServicio.js"></script>
		<script type="text/javascript"  src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript"	src="js/tarjetas/limitesTarDebIndividual.js"></script>
	</head> 
	<body> 
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limitesTarDebIndividualBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">L&iacute;mites por Tarjeta</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">			
								<label>Tipo Tarjeta: </label>
								<input type="radio" id="tipoTarjetaD" name="tipoTarjeta" value="D" tabIndex="1"/><label>Debito</label>
								<input type="radio" id="tipoTarjetaC" name="tipoTarjeta" value="C" tabIndex="2" /><label>Credito</label>
							</td>	
						</tr>
						<tr>
							<td class="label" >
								<label for="lblNumeroTarjeta">N&uacute;mero Tarjeta:</label>
		       		 			<input  type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" maxlength="16" size="20" tabindex="1"  />					
							</td>
							<td class="separador"></td> 
							<td class="label">
					  			<label for="estatus">Estatus: </label>
					  			<input type="text" id="estatus" name="estatus"  readOnly="true" size="20"  />	
				   			</td>				
						</tr>
					</table>
					<div> 
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Datos Tarjeta</legend>
							<table>
		     			 		<tr>
							 		<td class="label">
					  					<label for="fecha">Tarjetahabiente: </label>
							 		</td>
							 		<td>
										<input type="text" id="clienteID" name="clienteID" readOnly="true" size="15"  />					
										<input type="text" id="nombreCompleto" name="nombreCompleto"  readOnly="true" size="50"  />	
									</td>
			  					</tr>
			  					<tr id="cteCorpTr">
							 		<td class="label">
					  					<label for="fecha">Corporativo (Contrato): </label>
							 		</td>
							 		<td>
										<input type="text" id="coorporativo" name="coorporativo" readOnly="true" size="15"  />					
										<input type="text" id="nombreCoorp" name="nombreCoorp"  readOnly="true" size="50"  />	
									</td>
			  					</tr>
			  					<tr id="cuentaAsociada">
									<td class="label" >
										<label for="lblNumeroCuenta">Cuenta Asociada:</label>
			               	</td>
			 		       		<td>
										<input  type="text" id="cuentaAho" name="cuentaAho"  readOnly="true"  size="15"  />
					  	       		<label for="tipoCuenta">Tipo Cuenta: </label>
						      		<input type="text" id="nombreTipoCuenta" name="nombreTipoCuenta"  readOnly="true" size="34"  />	
					       		</td>
			  					</tr>
			  					<tr>
							 		<td class="label">
					  					<label for="tipoTarjeta">Tipo Tarjeta: </label>
							 		</td>
							 		<td>
										<input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" readOnly="true" size="15" />					
										<input type="text" id="nombreTarjeta" name="nombreTarjeta"  readOnly="true" size="50"  />	
									</td>
			  					</tr>
		     				</table>
		     			</fieldset>
		     			<br>
		     		</div>
		     		<table>
						<tr>
							<td class="label" >
								<label for="lblmontoMaxDia">Monto M&aacute;x. Dispo. Diario:</label>
			        		</td>
			 				<td>
								<input  type="text" id="montoMaxDia" name="montoMaxDia"  esMoneda="true" size="20" tabindex="2"  maxlength="12" />
							</td>
					 		<td class="separador"></td> 	
							<td class="label">
					  			<label for="MontoMaxMes">Monto M&aacute;x. Dispo. Mensual: </label>
				    		</td>
				    		<td>
								<input type="text" id="montoMaxMes" name="montoMaxMes" esMoneda="true" size="20" tabindex="3" maxlength="12"/>	
							</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="lblmontoMaxCompDia">Monto M&aacute;x. Compras Diario:</label>
			        		</td>
			 				<td>
		       		 		<input  type="text" id="montoMaxCompraDia" name="montoMaxCompraDia"  esMoneda="true" size="20" tabindex="4"  maxlength="12"/>				
							</td>
					 		<td class="separador"></td> 	
							<td class="label">
					  			<label for="MontoMax.ComprasMensual">Monto M&aacute;x. Compras Mensual: </label>
				   		</td>				
							<td>
								<input type="text" id="montoMaxComprasMensual" name="montoMaxComprasMensual"  esMoneda="true" size="20" tabindex="5" maxlength="12"/>	
							</td>
						</tr>
						<tr>
			    			<td class="label">
								<label >N&uacute;mero Disposiciones al D&iacute;a: </label>
							</td>
							<td> 
								<input type="text" id="disposicionesDia" name="disposicionesDia" size="5" maxlength="5"  tabindex="6"/>
			    			</td>
							<td class="separador"></td>
							<td class="label">
								<label >N&uacute;mero Consultas Mensual: </label>
							</td>
							<td>
								<input type="text" id="numConsultaMes" name="numConsultaMes" size="5" maxlength="5" tabindex="7" />
							</td>
			    		</tr>
						<tr>
							<td class="label" >
								<label for="lblBloqueoATM">Bloqueo ATM:</label>
							</td>
		       			<td>
					  			<select id="bloqueoATM" name="bloqueoATM"  tabindex="8" >
					   			<option value="">SELECCIONA</option>
					  				<option value="S">SI</option>
					  				<option value="N">NO</option>
					  			</select>
			   	  		</td>				
					 		<td class="separador"></td> 	
							<td class="label">
					  			<label for="bloqueoPOS">Bloqueo POS: </label>
				   		</td>				
							<td>
					  			<select id="bloqueoPOS" name="bloqueoPOS"  tabindex="9" >
					   			<option value="">SELECCIONA</option>
					  				<option value="S">SI</option>
					  				<option value="N">NO</option>
					  			</select>
			   	  		</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="lblBloqueoCashback">Bloqueo Cashback:</label>
			        		</td>
			 				<td>
					  			<select id="bloqueoCashback" name="bloqueoCashback"  tabindex="10" >
					  		 		<option value="">SELECCIONA</option>
					  				<option value="S">SI</option>
					  				<option value="N">NO</option>
					  			</select>
			   	  		</td>
					 		<td class="separador"></td> 	
							<td class="label">
					  			<label for="vigencia">Vigencia: </label>
				   		</td>
							<td>
					 			<form:input  id="vigencia" name="vigencia"   size="12" esCalendario="true" path="vigencia" onblur="validaFecha()" tabindex="11" />	
			   	  		</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="lbloperacionesMOTO">Operaciones MOTO:</label>
			        		</td>
			 				<td>
					  			<select id="operacionesMOTO" name="operacionesMOTO"  tabindex="12" >
					   			<option value="">SELECCIONA</option>
					  				<option value="S">SI</option>
					  				<option value="N">NO</option>
					  			</select>
			   	   	</td>
				</tr>
       			</table>					
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agregar" name="agregar" class="submit" tabindex="13" value="Agregar"   /> 
								<input type="submit" id="modificar" name="modificar" class="submit" tabindex="14" value="Modificar"   /> 
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