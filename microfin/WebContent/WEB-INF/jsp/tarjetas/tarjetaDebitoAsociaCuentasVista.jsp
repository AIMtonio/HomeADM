<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaValidoTipoTarjetaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/parametrosCajaServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/tarjetaDebitoAsociaCuentas.js"></script> 

		
		
        
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Asociación de Tarjeta a Cuentas</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
		    					<label for="lblTipoTarjeta">Tipo de Tarjeta: </label>
							</td>
							<td>
								<form:select id="tipoTarjetaDebID" name="tipoTarjetaDebID" path="tipoTarjetaDebID" tabindex="1"></form:select>
								<input type="hidden" id="lisTipoCuentas" name="lisTipoCuentas" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
		    					<label for=lblNúmeroCuenta>Número Cuenta:</label>
							</td>
		    				<td>
		    					<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" tabindex="2" size="25"/> 
			   				</td>
			   				<td class="separador"></td>
			   				<td class="label">
			    					<label for=lblTipoCuenta>Tipo de Cuenta:</label>
								</td>
			   				<td>
			   				<form:input type="text" id="tipoCuentaID" name="tipoCuentaID"  path="tipoCuentaID" size="6" readOnly="true" disabled = "true" />
								<input type="text" id="descripcionTipoCuenta" name="descripcionTipoCuenta"  size="20" readOnly="true" disabled = "true"  />
							</td>	
		 				</tr>
						<tr>
							<td class="label">
								<label for="lblNumeroTarjeta">Número Tarjeta: </label>
							</td>
							<td>
								<form:input type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" size="25" tabindex="3"  />
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblRelacionTarjeta">Relación Tarjeta: </label>
							</td>
							<td>
								<form:input type="radio" id="relacionT" name="relacion" path="relacion" value="T" tabindex="4" checked="checked"/>
								<label for="lblRelacionT">Titular</label>&nbsp&nbsp;
								<form:input type="radio"  id="relacionA" name="relacion" path="relacion" value="A" tabindex="5"/>
								<label for="lblRelacionA">Adicional</label>
								<input type="hidden" id="opcRelacion" name="opcRelacion" value="" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblNombreTarjeta">Nombre Tarjetahabiente: </label>
							</td>
							<td>
								<form:input id="nombreTarjeta" name="nombreTarjeta" path="nombreTarjeta" size="50" 	tabindex="6" type="text" onBlur=" ponerMayusculas(this)" maxlength="40"/>
							</td>
							<td class="separador"></td>
							<td class="label">
		    					<label for="lblTipoCobro">Tipo Cobro:</label>
							</td>
		    				<td>
		         			<select id="tipoCobro" name="tipoCobro"  tabindex="7" type="select">
									<option value="">SELECCIONA</option>
									<option value="NSC">NUEVA SIN COSTO</option>
									<option value="RC">REPOSICIÓN COSTO</option>
									<option value="RE">RENOV.POR EXPEDICIÓN</option>
								</select>
		   				</td>
						</tr>
						<!-- campos ocultos -->
						<form:input type="hidden" id="fechaActivacion" name="fechaActivacion"  path="fechaActivacion" size="20" />	
						<form:input type="hidden" id="clienteID" name="clienteID" path="clienteID"  size="15" />
						<input type="hidden" id="numeroTar" name="numeroTar"  size="15" />
					</table>
					<br>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
			 		<tr>	
						<td colspan="20">
						 <div id="gridTarDebConsulta" style="display: none;" />							
						</td>	
					</tr>
	   			    </table>
	   			    <table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="8" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" />
							</td>
							<td id="btnImprimir" align="right">
								<a id="ligaGenerar" href="/reporteTarDebCaratula.htm" target="_blank" >
										<input type="button" id="imprimir" class="submit" tabIndex="9" value="Imprimir Contrato" />
								</a>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" />
								<input type="hidden" id="identificacionSocio" name="identificacionSocio" />
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
