<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaTarjetaCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="js/tarjetas/tarjetaCreditoAsocia.js"></script> 

		
		
        
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Asignaci&oacute;n de Tarjeta de Cr&eacute;dito</legend>
					<table border="0" cellpadding="1" cellspacing="1" width="100%">
						
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
		    					<label for=lblNúmeroCuenta>Número Cliente:</label>
							</td>
		    				<td>
		    					<form:input id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="2"/> 
		    					<input type="text" id="nombreCompleto" name="nombreCompleto"  size="30" readOnly="true" disabled = "true"  />

			   				</td>
			   				<td class="label">
			    					<label for=lblTipoCuenta>N&uacute;mero de Tarjeta:</label>
								</td>
			   				<td>
			   				<input type="text" id="tarjetaDebID" name="tarjetaDebID"  path="tarjetaDebID" size="35" tabindex="3" readOnly="true" disabled = "true" maxlength="16" />
								
							</td>	
		 				</tr>
		 				
						<tr>
							<td class="label">
								<label for="lblRelacionTarjeta">Relaci&oacute;n Tarjeta: </label>
							</td>
							<td>
								<input type="radio" id="relacion" name="relacion" path="relacion" value="T" tabindex="5" checked="checked"  readOnly="true" disabled = "true"  />
								<label for="lblRelacionT">Titular</label>&nbsp&nbsp;
								<input type="radio"  id="relacionA" name="relacionA" path="relacionA" value="A" tabindex="6"  readOnly="true" disabled = "true"  />
								<label for="lblRelacionA">Adicional</label>
								<input type="hidden" id="opcRelacion" name="opcRelacion" value="" readonly="true" />
							</td>
							<td class="label">
								<label for="lblNombreTarjeta">Fecha de Corte: </label>
							</td>
							<td>
								<select id="tipoCorte" name="tipoCorte"  tabindex="7" type="select">
									<option value="">SELECCIONA</option>
									<option value="D">DIA ESPECIFICO</option>
									<option value="F">FIN DE MES</option>
								</select>
								<label for="lblNombreTarjeta">D&iacute;a Corte: </label>
								<input type="text" id="diaCorte" name="diaCorte"  size="7" tabindex="8" onkeyPress="return validadorNum(event);" maxlength="2" />
							</td>

						</tr>
						
						<tr>
							<td class="label">
		    					<label for="lblTipoCobro">Fecha Pago:</label>
							</td>
		    				<td>
		         				<select id="tipoPago" name="tipoPago"  tabindex="9" type="select">
									<option value="">SELECCIONA</option>
									<option value="D">DIA ESPECIFICO</option>
								</select>
								<label for="lblNombreTarjeta">D&iacute;a Pago: </label>
								<input type="text" id="diaPago" name="diaPago"  size="7" tabindex="10" onkeyPress="return validadorNum(event);" maxlength="2" />
								
		   					</td>
		   					<td class="label">
		    					<label for="lblTipoCobro">Cuenta Clabe:</label>
							</td>
		    				<td>
								<input type="text" id="cuentaClabe" name="cuentaClabe"  size="35" tabindex="11" onkeyPress="return validadorNum(event);" maxlength="18" />
								
		   					</td>
						</tr>

						<!-- campos ocultos -->
						<form:input type="hidden" id="fechaActivacion" name="fechaActivacion"  path="fechaActivacion" size="20" />	
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
								<input type="submit" id="procesar" name="procesar" value="Procesar" tabindex="12" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" />
							</td>
							<td id="btnImprimir" align="right">
								<a id="ligaGenerar" href="/reporteTarDebCaratula.htm" target="_blank" >
										<input type="button" id="imprimir" class="submit" tabIndex="13" value="Imprimir Contrato" />
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