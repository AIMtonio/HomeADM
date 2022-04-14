<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tarDebLimiteTipoServicio.js"></script>
		<script type="text/javascript"	src="js/tarjetas/tarDebLimiteTipo.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limiteTarjetaDebitoBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">L&iacute;mites por Tipo de Tarjeta</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" >
								<label for="lblTipoTarjeta">Tipo de Tarjeta:</label>
							</td>
		       			<td>
			       			<input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" size="15" tabindex="1" />
			       		</td>
		       			<td class="separador"></td>
							<td>
								<input type="text" id="descripcion" name="descripcion"  onblur="ponerMayusculas(this)"  size="35" readOnly="true"  />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="montoDisDia"> Monto M&aacute;x. Dispo. Diario: </label>
							</td>
							<td>
								<input type="text" id="montoDisDia" name="montoDisDia" esMoneda="true"  size="20" tabindex="2" />
			    			</td>
			    			<td class="separador"></td>
							<td class="label" id="lblMontoMaxDisp">
								<label for="montoDisMes"> Monto M&aacute;x. Dispo. Mensual: </label>
							</td>
							<td id="txtMontoMaxDisp">
								<input type="text" id="montoDisMes" name="montoDisMes" esMoneda="true" size="20" tabindex="3" />
			    			</td>
						</tr>
						<tr>
							<td class="label">
								<label for="montoComDia"> Monto M&aacute;x. Compra Diario: </label>
							</td>
							<td>
								<input type="text" id="montoComDia" name="montoComDia" esMoneda="true" size="20" tabindex="4"/>
			    			</td>
			    			<td class="separador"></td>
							<td class="label" id="lblMontoMaxCom">
								<label for="montoComMes"> Monto M&aacute;x. Compra Mensual: </label>
							</td>
							<td id="txtMontoMaxCom">
								<input type="text" id="montoComMes" name="montoComMes" esMoneda="true" size="20" tabindex="5" />
			    			</td>
						</tr>
				  		<tr>
			    			<td class="label">
								<label >N&uacute;mero Disposiciones al D&iacute;a: </label>
							</td>
							<td> 
								<input type="text" id="numeroDia" name="numeroDia" size="5" onkeypress="" tabindex="6" />
			    			</td>
							<td class="separador"></td>
							<td class="label" id="lblNumConsMens">
								<label >N&uacute;mero Consultas Mensual: </label>
							</td>
							<td id="txtNumConsMens">
								<input type="text" id="numConsultaMes" name="numConsultaMes" size="5" onkeypress="" tabindex="7" />
							</td>
			    		</tr>
						<tr>			
							<td class="label">
								<label> Bloqueo ATM: </label>
							</td>
							<td>
								<select id="bloqueoATM" name="bloqueoATM"  tabindex="8">
					   			<option value="">SELECCIONA</option>
					   			<option value="S">SI</option>
					  				<option value="N">NO</option>
								</select>
			    			</td>
			    			<td class="separador"></td>
			    			<td class="label">
								<label> Bloqueo POS: </label>
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
							<td class="label">
								<label> Bloqueo Cashback: </label>
							</td>
							<td>
								<select id="bloqueoCash" name="bloqueoCash"  tabindex="10" >
					   			<option value="">SELECCIONA</option>
					    	 		<option value="S">SI</option>
					 	 			<option value="N">NO</option>
								</select>
			    			</td>
			    			<td class="separador"></td>
			    			<td class="label">
								<label> Operaciones MOTO: </label>
							</td>
				  			<td>
				  				<select id="operacionMoto" name="operacionMoto"  tabindex="11" >
								   <option value="">SELECCIONA</option>
					     			<option value="S">SI</option>
					  				<option value="N">NO</option>
								</td>
			    			</td>
			    		</tr>
					</table>
					<table width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="12" />
								<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="13" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
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