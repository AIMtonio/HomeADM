<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">  
		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>  
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script type="text/javascript" src="dwr/interface/opcionesMenuRegServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/regulatorioD0842Servicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>  
	    <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
  		<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
		<script type="text/javascript" src="js/regulatorios/regulatorioD0842003.js"></script>
		<script>
			$(function() { 
				$("#tabs" ).tabs();
			});
   		</script>

	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioD0842">
<fieldset class="ui-widget ui-widget-content ui-corner-all">   

	<legend class="ui-widget ui-widget-header ui-corner-all">Desagregado de Pr&eacute;stamos Bancarios y Otros Organismos D-0842</legend>	
		<div id="tblRegulatorio">
		<table width="100%">
		<tr>
		<td class="label" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">              
			<legend><label>Periodo</label></legend>
			<table >
				<tbody>
					<tr>
						<td class="label" > 
					        <label for="anio">Año: </label> 
					    </td> 
					    <td>
							<select id="anio" name="anio" tabindex="1">
							</select>
						</td>	
						<td class="separador"> </td> 			
					    <td class="label" > 
					        <label for="mes">Mes: </label> 
					    </td> 					    
					   <td>
							<select id="mes" name="mes" tabindex="2">
								<option value="1">ENERO</option>
								<option value="2">FEBRERO</option>
								<option value="3">MARZO</option>
								<option value="4">ABRIL</option>
								<option value="5">MAYO</option>
								<option value="6">JUNIO</option>
								<option value="7">JULIO</option>
								<option value="8">AGOSTO</option>
								<option value="9">SEPTIEMBRE</option>
								<option value="10">OCTUBRE</option>
								<option value="11">NOVIEMBRE</option>
								<option value="12">DICIEMBRE</option>
							</select>
						</td>	
					</tr>
				</tbody>
			</table>
		</fieldset>
		</td>
		</tr>
		</table>
		<br>
	<div id="tabs"> 
		<ul> 
			<li ><a id="reporteD0842" href="#_reporte">Reporte</a></li> 	
			<li ><a id="registroD0842" href="#_registro">Registro </a></li> 	
		</ul> 	 
		<div id="_reporte"> 
		<table id="reporte" width="100%">
			<tr>
			<td>
	 		<table width="100%" >  	
						<tr>
						<td class="label" >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
							<table>
								<tbody>
									
									<tr>
									<td><input type="radio" id="excel" name="tipoReporte" selected="true" tabindex="3" ></td><td>
											<label> Excel </label>	</td>
										
									</tr>
									<tr>
										<td><input type="radio" id="csv" name="tipoReporte" tabindex="4" ></td><td>
											<label> Csv </label>	</td>
										
																		
									</tr>
								</tbody>
							</table>
						</fieldset>
						</td>
					</tr>
			 </table>
			<br>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr> 
						<td >
							<table align="right" border='0'>
								<tr>
									<td align="right"">
											<input type="button" id="generar" name="generar" class="submit"
												 tabindex="7" value="Generar" />
									</td>	
								</tr> 
							</table>		
						</td>
					</tr>					
				</table>
			</td>
			</tr>
			</table>
		</div>
		<div id="_registro"> 
		<table id="capturaInfo" width="100%">
		<tr>
		<td>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend ><label>Información del Otorgante</label></legend>
			<table width="100%">
				<tr>
					<td class="label"> 
						<label for="lblNumeroIden">Número de Identificación:</label> 
					</td>
					<td>
						<form:input type="text" id="identificadorID" name="identificadorID" path="identificadorID" tabindex="5" 
						onBlur="ocultaCaja(this.id)" maxlength="11" size="12" />
					</td>
					
					<td class="separador"></td>
					<td class="label"> 
						<label for="lblNumeroIden">Otorgante del Prestamo:</label> 
					</td>
					<td>
						<form:input type="text" id="numeroIden" name="numeroIden" path="numeroIden" tabindex="5" maxlength="12" size="8" onBlur="ocultaCaja(this.id)"/>

						<input type="text" id="nomOtorgante" name="nomOtorgante" size="50" tabindex="8" disabled="true" readOnly="true"
							onBlur="ponerMayusculas(this)"/>
					</td>
					</td>
					
					
				</tr>
				<tr>
					<td class="label"> 
						   		<label for="lblTipoPrestamista">Tipo de Prestamista:</label> 
					</td>
					<td>
						<form:select id="tipoPrestamista" name="tipoPrestamista" path="tipoPrestamista" tabindex="6" style="width:350px;">
						<form:option value="">SELECCIONAR</form:option> 

						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						<label for="lblPaisExtranjero">País Entidad Extranjera:</label> 
					</td>
					<td>
						<form:input type="text"  id="paisEntidadExtranjera" name="paisEntidadExtranjera" path="paisEntidadExtranjera" 
						 	size="8" tabindex="7" maxlength="9" onBlur="ocultaCaja(this.id)"/>
						<input type="text" id="nomPais" name="nomPais" size="50" tabindex="8" disabled="true" readOnly="true"
							onBlur=" ponerMayusculas(this)"/>
					</td>

				</tr>

			</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend ><label>Datos de la Operación</label></legend>
			<table width="100%">
				<tr>
					<td class="label"> 
						<label for="lblnumeroCuenta">Número de Cuenta:</label> 
					</td>
					<td>
						<form:input type="text" id="numeroCuenta" name="numeroCuenta" path="numeroCuenta" tabindex="9" onBlur=" ponerMayusculas(this)"  maxlength="22" size="30" />
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblNumContrato">Número de Contrato:</label> 
					</td>
					<td>
						<form:input type="text" id="numeroContrato" name="numeroContrato" path="numeroContrato" tabindex="10" onBlur=" ponerMayusculas(this)"  maxlength="22" size="30" />
					</td>
				</tr>
				<tr>
					<td class="label"> 
				   		<label for="lblClasificaCortLarg">Clasificación de Corto<br> o Largo PLazo: </label> 
					</td>
					<td>
						<form:select id="clasificaCortLarg" name="clasificaCortLarg" path="clasificaCortLarg" tabindex="11" >
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
						
					</td>
					
					<td class="separador"></td>

					<td class="label"> 
						   		<label for="lblFechaContra">Fecha de Contratación:</label> 
							</td>
					<td>
					<form:input type="text" id="fechaContra" name="fechaContra" path="fechaContra" size="12" tabindex="12" esCalendario="true" maxlength="10" />
					</td>
				</tr>
				<tr>
					<td class="label"> 
				   		<label for="lblFechaVencim">Fecha de Vencimiento:</label> 
					</td>
					<td>
						<form:input type="text" id="fechaVencim" name="fechaVencim" path="fechaVencim" size="12" tabindex="13" esCalendario="true" maxlength="10"/>	
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label for="lblplazo">Plazo del Vencimiento:</label> 
					</td>
					<td>
						<form:input type="text" id="plazo" name="plazo" path="plazo" tabindex="14" maxlength="8" size="12" /><label class="label">días</label>
					</td>

				</tr>
				<tr>
					<td class="label"> 
						   		<label for="lblPeriodoPago">Periodicidad de Pagos:</label> 
					</td>
					<td>
						<form:select id="periodo" name="periodo" path="periodo" tabindex="15">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   <label for="lblMontoRecibido">Monto Inicial del Préstamo Moneda Origen:</label> 
					</td>
					<td>
						<form:input type="text" id="montoRecibido" name="montoRecibido" path="montoRecibido" tabindex="16" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
				</tr>
				<tr>
					<td class="label"> 
						   <label for="lblMontoRecibido">Monto Inicial del Préstamo MNX:</label> 
					</td>
					<td>
						<form:input type="text" id="montoInicialPrestamo" name="montoInicialPrestamo" path="montoInicialPrestamo" tabindex="17"  onblur="soloCantidad(this,this.id)" maxlength="28" esBigDecimal="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label for="lblTipoTasa">Tipo de Tasa:</label> 
					</td>
					<td>
						<form:select id="tipoTasa" name="tipoTasa" path="tipoTasa" tabindex="18">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
				</tr>
				<tr>
					<td class="label"> 
					   		<label for="lblValorTasa">Valor de Tasa Original:</label> 
					</td>
					<td>
						<input type="text" id="valTasaOriginal" maxlength="20" path="valTasaOriginal" name="valTasaOriginal"  style="text-align:right;" onblur="validarTasa(this.id,this.value)" size="20" seisDecimales="true" tabindex="19"/><label class="label">%</label>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					   		<label for="lblvalTasaInt">Interés Aplicable Tasa:</label> 
					</td>
					<td>
						<input type="text" id="valTasaInt" maxlength="20" path="valTasaInt" name="valTasaInt"  style="text-align:right;" onblur="validarTasa(this.id,this.value)" size="20" seisDecimales="true" tabindex="20" /><label class="label">%</label>
					</td>
				</tr>
				<tr>
					<td class="label"> 
					   		<label for="lbltasaIntReferencia">Tasa de Referencia:</label> 
					</td>
					<td>
						<form:input type="text"  id="tasaIntReferencia" name="tasaIntReferencia" path="tasaIntReferencia" 
						 	size="12" tabindex="21" maxlength="9" onBlur="ocultaCaja(this.id)"/>
						<input type="text" id="desTasaRef" name="desTasaRef" size="39" disabled="true" readOnly="true"
							onBlur=" ponerMayusculas(this)"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					   		<label for="lbldiferenciaTasaRef">Ajuste Tasa de Referencia:</label> 
					</td>
					<td>
						<form:input type="text" id="diferenciaTasaRef" name="diferenciaTasaRef" path="diferenciaTasaRef" tabindex="22" onblur="soloCantidad(this,this.id)" maxlength="20" esMoneda="true" size="20" style="text-align:right;"/>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
					   		<label for="lbloperaDifTasaRefe">Operación Diferencial Tasa de Referencia:</label> 
					</td>
					<td>
						<form:select id="operaDifTasaRefe" name="operaDifTasaRefe" path="operaDifTasaRefe" tabindex="23" style="width:350px;">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					   		<label for="lblfrecRevisionTasa">Frecuencia Revisión Tasa:</label> 
					</td>
					<td>
						<form:input type="text" id="frecRevisionTasa" name="frecRevisionTasa" path="frecRevisionTasa" tabindex="24" maxlength="8" size="12" /><label class="label">días</label>
					</td>
					
				</tr>
				<tr>
				<td class="label"> 
					   		<label for="lbltipoMoneda">Tipo Moneda:</label> 
					</td>
					<td>
						<form:select id="tipoMoneda" name="tipoMoneda" path="tipoMoneda" tabindex="25" style="width:350px;">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					   		<label for="lblporcentajeComision">Porcentaje Comisión:</label> 
					</td>
					<td>
						<form:input type="text" id="porcentajeComision" name="porcentajeComision" path="porcentajeComision" tabindex="26" onblur="soloCantidad(this,this.id)" maxlength="20" esMoneda="true" size="20" seisDecimales="true" style="text-align:right;"/>
						<label class="label">%</label>
					</td>
					
				</tr>
				<tr>
				<td class="label"> 
					   		<label for="lblimporteComision">Importe Comisión:</label> 
					</td>
					<td>
						<form:input type="text" id="importeComision" name="importeComision" path="importeComision" tabindex="27" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   	<label for="lblperiodoPagoComision">Periodicidad de Pagos Comisión:</label> 
					</td>
					<td>
						<form:select id="periodoPago" name="periodoPago" path="periodoPago" tabindex="28">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
						   	<label for="lbltipoDisposicionCredito">Tipo Disposición del Crédito:</label> 
					</td>
					<td>
						<form:select id="tipoDisposicionCredito" name="tipoDisposicionCredito" path="tipoDisposicionCredito" tabindex="29" style="width:350px;">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblDestino">Destino Recursos:</label> 
					</td>
					<td>
						<form:select id="destino" name="destino" path="destino" tabindex="30">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
						<label for="lblClasificaConta">Clasificación Contable:</label> 
					</td>
					<td>
						<form:select id="clasificaConta" name="clasificaConta" path="clasificaConta" tabindex="31" style="width:350px;">
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
					</td>
					
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblSalInsoluto">Saldo Inicial Periodo: </label> 
					</td>
					<td>
						<form:input type="text" id="saldoInicio" name="saldoInicio" path="saldoInicio" tabindex="32" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>

				</tr>
				<tr>
					<td class="label"> 
						   		<label for="lblpagosRealizados">Pagos Realizados: </label> 
					</td>
					<td>
						<form:input type="text" id="pagosRealizados" name="pagosRealizados" path="pagosRealizados" tabindex="33" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblcomisionPagada">Comisiones Pagadas: </label> 
					</td>
					<td>
						<form:input type="text" id="comisionPagada" name="comisionPagada" path="comisionPagada" tabindex="34" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
						   		<label for="lblinteresesPagados">Interéses Pagados: </label> 
					</td>
					<td>
						<form:input type="text" id="interesesPagados" name="interesesPagados" path="interesesPagados" tabindex="35" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblinteresesDevengados">Interéses Devengados No Pagados: </label> 
					</td>
					<td>
						<form:input type="text" id="interesesDevengados" name="interesesDevengados" path="interesesDevengados" tabindex="36" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
						   		<label for="lblsaldoCierre">Saldo Cierre: </label> 
					</td>
					<td>
						<form:input type="text" id="saldoCierre" name="saldoCierre" path="saldoCierre" tabindex="37" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
						   		<label for="lblporcentajeLinRevolvente">Porcentaje Línea Revolvente: </label> 
					</td>

					<td>
						<input type="text" id="porcentajeLinRevolvente" maxlength="20" path="porcentajeLinRevolvente" name="porcentajeLinRevolvente"  style="text-align:right;" onblur="validarTasa(this.id,this.value)" size="20"  tabindex="38" seisDecimales="true" /><label class="label">%</label>
					</td>
					
				</tr>
				<tr>
					<td class="label"> 
				   		<label for="lblfechaUltPago">Fecha Último Pago: </label> 
					</td>
					<td>
						<form:input type="text" id="fechaUltPago" name="fechaUltPago" path="fechaUltPago" size="12" tabindex="39" esCalendario="true" maxlength="10" />
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label for="lblpagoAnticipado">Pago Anticipado: </label> 
					</td>
					<td>
						<form:select id="pagoAnticipado" name="pagoAnticipado" path="pagoAnticipado" tabindex="40">
							<form:option value="">SELECCIONAR</form:option> 
							<form:option value="101">SI</form:option>
					     	<form:option value="102">NO</form:option>
						</form:select>
						
					</td>
				</tr>
				<tr>
					<td class="label"> 
				   		<label for="lblmontoUltimoPago">Monto Último Pago: </label> 
					</td>
					<td>
						<form:input type="text" id="montoUltimoPago" name="montoUltimoPago" path="montoUltimoPago" tabindex="41" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
				   		<label for="lblFechaPago">Fecha del Pago Inmediato Siguiente: </label> 
					</td>
					<td>
						<form:input type="text" id="fechaPagoInmediato" name="fechaPagoInmediato" path="fechaPagoInmediato" size="12" tabindex="42" esCalendario="true" maxlength="10"/>
					</td>
				</tr>
				<tr>
					<td class="label"> 
				   		<label for="lblmontoPagoInmediato">Monto del Pago Inmediato Siguiente: </label> 
					</td>
					<td>
						<form:input type="text" id="montoPagoInmediato" name="montoPagoInmediato" path="montoPagoInmediato" tabindex="43" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
				</tr>

			</table>
	</fieldset>
	<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend ><label>Información de las Garantías</label></legend>
			<table width="100%">
				<tr>
					<td class="label"> 
				   		<label for="lblTipoGarantia">Tipo de Garantía:</label> 
					</td>
					<td>
						<form:select id="tipoGarantia" name="tipoGarantia" path="tipoGarantia" tabindex="44" onchange="valGarantia(this.value)" >
						<form:option value="">SELECCIONAR</form:option> 
						</form:select>
						
					</td>
					<td class="separador"></td>
					<td class="label"> 
					   		<label for="lblMontoGarantia">Monto o Valor de la Garantía:</label> 
						</td>
					<td>
						<form:input type="text" id="montoGarantia" name="montoGarantia" path="montoGarantia" tabindex="45" onblur="soloCantidad(this,this.id)" maxlength="28" esMoneda="true" size="30" style="text-align:right;"/>
					</td>
				</tr>
				<tr>
					<td class="label"> 
						<label for="lblfechaValuacionGaran">Fecha Valuación Garantía:</label> 
					</td>
					<td>
						<form:input type="text" id="fechaValuacionGaran" name="fechaValuacionGaran" path="fechaValuacionGaran" size="12" tabindex="46" esCalendario="true" maxlength="10" onblur="esFechaValida(this.value,this.id)"/>
					</td>
				</tr>
			</table>
		</fieldset>
		<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="99"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="100"/>
				<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar"  tabindex="101"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>

			</td>
		</tr>
	</table>
	</td>
	</tr>
	</table>
	</fieldset>
</div>
	</fieldset>

</div> 
</div> 
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
