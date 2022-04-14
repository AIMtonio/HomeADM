<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
<head>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/resultadoSegtoCobranzaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoOrigenPagoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoMotNoPagoServicio.js"></script>
	<script type="text/javascript" src="js/seguimiento/resultadoSegtoCobranza.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica2" name="formaGenerica2"  method="POST" commandName="resultadoSegtoCobranzaBean">

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Captura Seguimiento Cobranza</legend>	
			<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">

			<tr>
				<td class="label" align="left">
					<label for="segtoPrograID">Secuencia Segto: </label>
				</td>
				<td>
					<form:input id="segtoPrograIDCob" name="segtoPrograID" path="segtoPrograID" Value='' size="12"  maxlength="11" autocomplete="off" tabindex="1" />
				</td>	
				<td class="separador"></td> 	
				<td class="label" nowrap="nowrap"  align="left">
					<label for="segtoRealizaID">Consecutivo: </label>
				</td>
				<td>
					<form:input id="segtoRealizaIDCob" name="segtoRealizaID" path="segtoRealizaID" Value='' size="12" maxlength="11" autocomplete="off"  tabindex="2" />
				</td>
			</tr>
			<tr>
				<td class="label" align="left">
					<label for="lblfechaPromPago">Fec.Promesa Pago: </label>
				</td>
				<td>
					<form:input id="fechaPromPago" name="fechaPromPago" path="fechaPromPago" size="12" tabindex="3" esCalendario="true"/>
				</td>		
				<td class="separador"></td> 
				<td class="label" nowrap="nowrap" align="left">
					<label for="montoPromPago">Monto Promesa: </label>
				</td>
					<td >
						<form:input id="montoPromPago" name="montoPromPago" path="montoPromPago" Value='' autocomplete="off"  esmoneda="true"
							 tabindex="4" style="text-align: right;"/>
					</td>	
				
				</tr>
				<tr>
		 	
				<td class="label"  align="left"> 
			         	<label for="lblexistFlujo">Habrá Flujo Pago: </label> 
						</td> 		     		
			     		<td>
						<form:radiobutton id="existFlujo1" name="existFlujo1" path="existFlujo" value="S" 	tabindex="5"  />
						<label for="S">Si</label>
						<form:radiobutton id="existFlujo2" name="existFlujo2" path="existFlujo" value="N" 	tabindex="6"/>
						<label for="S">No</label>
					
			     		</td> 	
			     		 <td class="separador"></td>
			     		 		
					<td class="label" nowrap="nowrap" align="left">
					<div id="lblcerrarFecha">
						<label for="fechaEstFlujo">Fecha Est. Flujo: </label>
						</div>
						</td>
					<td>	
					<div id="cerrarFecha">
						<form:input id="fechaEstFlujo" name="fechaEstFlujo" path="fechaEstFlujo" size="20" tabindex="7" esCalendario="true"/>
							</div>
					</td>
			    </tr>
			    <tr>
				<td class="label" align="left" align="left">
						<label for="motivoNPID">Motivo No Pago: </label>
					</td>
					<td>
						<form:select id="motivoNPID" name="motivoNPID" path="motivoNPID" tabindex="8" >
						</form:select>
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap" align="left">
						<label for="lblorigenPagoID">Origen Recursos Pago: </label>
					</td>
					<td>
						<form:select id="origenPagoID" name="origenPagoID" path="origenPagoID" tabindex="9" >
						</form:select>
					</td>												
			    </tr>
			    <tr>
					<td class="label" align="left">
						<label for="lblnomOriRecursos">Nom. Recurso Para Pago: </label>
					</td>
					<td>
						<form:input id="nomOriRecursos" name="nomOriRecursos" path="nomOriRecursos" value='' autocomplete="off" tabindex="10" size="40"/>
					</td>
					 <td class="separador"></td> 		
						<td class="label" nowrap="nowrap" align="left">
						<label for="lbltelefonFijo">Tel. Fijo Cliente: </label>
						</td>
					<td>
						<form:input id="telefonFijo" name="telefonFijo" path="telefonFijo" Value='' maxlength="20" autocomplete="off"  tabindex="11" />
					</td>												
			    </tr>
			     <tr>
				<td class="label" align="left">
						<label for="telefonCel">Tel. Celular Cliente: </label>
					</td>
					<td>
						<form:input id="telefonCel" name="telefonCel" path="telefonCel" Value='' maxlength="20" autocomplete="off" tabindex="12" />
					</td>		
																
			    </tr>
			    
	
		</table>
		
		
		<table align="right">
			<tr>
				<td align="right">
				
					<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="13"/>
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="14"/>
					<button type="button" id="salir" name="salir" class="submit" tabindex="15" style="display: none;">Salir</button>
					<input type="hidden" id="tipoTransaccionCob" name="tipoTransaccionCob"/>
	
					
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