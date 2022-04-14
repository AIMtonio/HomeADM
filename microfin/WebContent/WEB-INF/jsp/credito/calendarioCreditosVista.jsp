<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>
      <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
	
		<script type="text/javascript" src="js/credito/amortizacionCredito.js"></script>				
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Calendario de Pagos</legend>
					
			<table border="0" cellpadding="0" cellspacing="0" width="950px">
				<tr>
					<td class="label">
						<label for="promotorID">Credito: </label>
					</td>
					<td >
						<form:input id="creditoID" name="creditoID" path="creditoID" size="12"  iniForma = 'false'  tabindex="1" />
					</td>					
					<td class="separador"></td>				
					<td class="label">
						<label for="estatus">Estatus: </label>
					</td>
					<td >
						<form:select id="estatus" name="estatus" path="estatus" tabindex="2"  disabled="true">
							<form:option value="I">Inactivo</form:option>
				     		<form:option value="V">Vigente</form:option>
							<form:option value="P">Pagado</form:option>
							<form:option value="C">Cancelado</form:option>
						</form:select>
					</td>	
				</tr>
				
				<tr>
					<td class="label">
						<label for="usuarioID"><s:message code="safilocale.cliente"/>: </label>
					</td>
					<td >
						<form:input id="clienteID" name="clienteID" path="clienteID" size="11" tabindex="3" />
						<input type="text" id="nombreCliente" name="nombreCliente" size="40" tabindex="4" disabled="true" readOnly="true"/>
					</td>
					
					<td class="separador"></td>
					
				   <td class="label">
					 <label  for="cuenta">Cuenta: </label>
					</td>
				   <td >
					 	<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="12"  tabindex="5"/>
					</td>
				</tr>
				
				<tr>
			     	<td class="label"> 
			      	<label for="lblfecha">Inicio:</label>				      	 
			     	</td> 
			     	<td> 
			      	<form:input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="20"
			         	type="text" esCalendario="true" tabindex="6" iniForma = "false" /> 
			     	</td>
			     	<td class="separador"></td>
			     	<td class="label"> 
			      	<label for="lblfecha">Vencimiento:</label>				      	 
			     	</td> 
			     	<td> 
			      	<form:input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="20"
			         	type="text" esCalendario="true" tabindex="7" iniForma = "false" /> 
			     	</td>			     	
				</tr>
				<tr>
					<td><label>Monto:</label>
					</td>
					<td><form:input name="montoCredito" id="montoCredito" size="11" path="montoCredito" esMoneda="true"
								  autocomplete="off" tabIndex = "8"/>
					</td>
			     	<td class="separador"></td>
					<td><label>Tasa:</label>
					</td>
					<td><form:input name="tasaFija" id="tasaFija" size="8" path="tasaFija" esTasa="true"
								  autocomplete="off" tabIndex = "9"/>
								  <label>&nbsp;% Anual</label>
					</td>
				</tr>
				<tr>
					<td><label>No.Cuotas:</label>
					</td>
					<td><form:input name="numAmortizacion" id="numAmortizacion" size="5" path="numAmortizacion"
								  autocomplete="off" tabIndex = "10"/>
					</td>
			     	<td class="separador"></td>
					<td><label>Frec.Pago:</label>
					</td>
					<td>
		 				<form:select id="frecuenciaCap" name="frecuenciaCap" path="frecuenciaCap"  tabindex="11">		
					     	<form:option value="S">SEMANAL</form:option>
					     	<form:option value="C">CATORCENAL</form:option>
							<form:option value="Q">QUINCENAL</form:option>
							<form:option value="M">MENSUAL</form:option>
							<form:option value="P">PERIODO</form:option>
						</form:select>	
					</td>
				</tr>
				<tr>
					<td><label>Periodicidad:</label>
					</td>
					<td><form:input name="periodicidadCap" id="periodicidadCap" size="5" path="periodicidadCap"
								  autocomplete="off" tabIndex = "12"/>
					</td>
				</tr>
			</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<input type="button" id="generar" name="generar" class="submit"
												 tabIndex = "13" value="Calcular Calendario" />
										<input type="submit" id="grabar" name="grabar" class="submit"
												 value="Grabar" tabIndex = "14" />
										<input type="button" id="imprimir" name="imprimir" class="submit"
												 value="Imprimir" tabIndex = "15" />												 
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									</td>
								</tr>
								
							</table>		
						</td>
					</tr>					
				</table>
<div id="gridAmortizacion"></div>
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<disv id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>