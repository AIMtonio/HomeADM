<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
		<script type="text/javascript" src="dwr/interface/bloqueoServicio.js">		</script> 
 		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js">		</script>     
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js">		</script> 
		<script type="text/javascript" src="dwr/interface/clienteServicio.js">			</script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js">			</script>        
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	   <script type="text/javascript" src="js/cuentas/consultaSaldoCuenta.js"></script>
	      
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Consulta de Saldo</legend> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Datos del <s:message code="safilocale.cliente"/></legend>	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
					<tr id ="tarjetaIdentiCA">
						<td class="label"><label for="IdentificaSocio">N&uacute;mero Tarjeta:</label>
						<td nowrap="nowrap">
							<input id="numeroTarjeta" name="numeroTarjeta" size="20" tabindex="1" type="text" />
							<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
							<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />
						</td>
					</tr>
					<tr>	   	
				     	<td class="label" > 
				         <label for="lblNombreCliente"><s:message code="safilocale.cliente"/>: </label> 
				     	</td> 
				     	<td> 
				        <input  type="text" id="numCliente" name="numCliente" size="20" iniForma = 'false'
				        			tabindex="1" />
				        <input id="nombreCliente" name="nombreCliente"size="50" iniForma = 'false' 
				         	type="text" readOnly="true" disabled="true" tabindex="2"/>
				     	</td> 	
				     	<td class="separador"></td> 		
				     	<td>
							<label for="lblanio">A&ntilde;o: </label>
							<select name="anio" id="anio" tabindex="3">
							</select>
						</td>
						<td nowrap="nowrap">
							<label for="lblmes">Mes: </label>
							<select name="mes" id="mes" tabindex="4">
								<option value="01">Enero</option>
								<option value="02">Febrero</option>
								<option value="03">Marzo</option>
								<option value="04">Abril</option>
								<option value="05">Mayo</option>
								<option value="06">Junio</option>
								<option value="07">Julio</option>
								<option value="08">Agosto</option>
								<option value="09">Septiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="label"> 
				         <label for="lblCuentaAhoID">Cuenta: </label> 
				     	</td>
				     	<td>
				         <form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="20" 
				         		iniForma = "false" tabindex="5"/> 
				     	</td> 
				      <td class="separador"></td> 	
				      <td class="label" nowrap="nowrap"> 
				         <label for="lbltipoCuentaAho">Tipo Cuenta: </label> 
				     	</td>
				     	<td>
				     		<input id="tipoCuenta" name="tipoCuenta" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true"  />
				     	</td>       
					</tr> 
					<tr>
						<td class="label"> 
				         <label for="lblMoneda">Moneda: </label> 
				     	</td> 
				     	<td> 
				        <input id="moneda" name="moneda" size="20" iniForma = 'false'
				        		type="text" readOnly="true" disabled="true"/>
				     	</td> 
				      <td class="separador"></td> 
						<td class="label" nowrap="nowrap"> 
				         <label for="lblSaldoIniMes">Saldo Inicial Mes: </label> 
				     	</td> 
				     	<td> 
				        <input id="saldoIniMes" name="saldoIniMes" size="20" iniForma = 'false'
				        		type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td>
				   </tr>
				   <tr>
						<td class="label"> 
				         <label for="lblsaldo">Saldo: </label> 
				     	</td> 
				     	<td> 
				        <input id="saldo" name="saldo" size="20" iniForma = 'false'
				        		type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td> 
				      <td class="separador"></td> 
							<td class="label"> 
				         <label for="lblAbonosMes">Abonos del Mes: </label> 
				     	</td> 
				     	<td> 
				        <input id="abonosMes" name="abonosMes"size="20" iniForma = 'false'
				        		type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td> 
				   </tr> 
				    
				   <tr>
				   <td class="label"> 
				         <label for="lblSaldoDispon">Saldo Disponible: </label> 
				     	</td>
				     	<td>
				     		<input id="saldoDispon" name="saldoDispon" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right" />
				     	</td> 
						 
				      <td class="separador"></td> 
						<td class="label"> 
				         <label for="lblCargosMes">Cargos del Mes: </label> 
				     	</td>
				     	<td>
				     		<input id="cargosMes" name="cargosMes" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true"  style="text-align: right"/>
				     	</td> 
				   </tr> 
				   <tr>
				   <td class="label"> 
				         <label for="lblSaldoBC">Saldo SBC: </label> 
				     	</td>
				     	<td>
				     		<input id="saldoSBC" name="saldoSBC" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right" />
				     	</td> 
					
				      <td class="separador"></td> 
						<td class="label"> 
				         <label for="lblCargosDia">Cargos del D&iacute;a: </label> 
				     	</td>
				     	<td>
				     		<input id="cargosDia" name="cargosDia" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td> 
				   </tr> 
				   <tr>
				   		<td class="label"> 
				         <label for="lbsaldoBloq">Saldo Bloqueado: </label> 
				     	</td>
				     	<td>
				     		<input id="saldoBloq" name="saldoBloq" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     		<input type="button" id="salBloq" name="salBloq" class="submit" tabindex="5"
							 value="Ver Detalle" style="display: none;"/>
				     	</td> 
				     	<td class="separador"></td>
						<td class="label"> 
				         <label for="lblAbonosDia">Abonos del D&iacute;a: </label> 
				     	</td>
				     	<td>
				     		<input id="abonosDia" name="abonosDia" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     		<input id="tipoListaMovs" name="tipoListaMovs" size="2" value="0"
				     				type="hidden" readOnly="true" disabled="true" />
		     				<input id="fechaSistemaMov" name="fechaSistemaMov" size="2" value="0"
		     						type="hidden" readOnly="true" disabled="true" />
				     	</td> 
				   </tr> 
				    <tr>
				   		<td class="label"> 
				         <label for="lblcobrospend">Cargos Pendientes: </label> 
				     	</td>
				     	<td>
				     		<input id="cargosPendientes" name="cargosPendientes" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     		<input type="button" id="cargosPendientesBtn" name="cargosPendientesBtn" class="submit" tabindex="6"
							 value="Ver Detalle" style="display: none;"/>
				     	</td> 
				     	<td class="separador"></td>
				   		<td class="label"> 
				         <label for="lblcobrospend">Saldo Promedio: </label> 
				     	</td>
				     	<td>
				     		<input id="saldoProm" name="saldoProm" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td> 
				   </tr> 
				     <tr>
				   		<td class="label"> 
				         <label for="lblGat">GAT Nominal: </label> 
				     	</td>
				     	<td>
				     		<input id="gat" name="gat" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     			<label for="lblGat%">%</label>
				     	</td>
				     	<td class="separador"></td> 
				     	<td class="label"> 
				         <label for="valorGatReal">GAT Real: </label> 
				     	</td>
				     	<td>
				     		<input id="valorGatReal" name="valorGatReal" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     			<label for="valorGatReal">%</label>
				     	</td> 
				     	
				     	<td class="separador"></td>
				     	<td class="separador"></td>
				   </tr> 
				   
				   <tr>
				   		<td class="label"> 
				     <label for="lblctaClabe">Cuenta Clabe: </label> 
				     	</td>
				    	<td>
				     		<input id="ctaClabe" name="ctaClabe" size="20" iniForma = 'false'  
				     				type="text" readOnly="true" disabled="true" style="text-align: right"/>	
				     	</td>
				     	<td class="separador"></td> 
				     	<td class="separador"></td> 
				     	<td>
				     	<label></label>
				     	</td> 
				     	
				     	<td class="separador"></td>
				     	<td class="separador"></td>
				   </tr> 
					<tr>
						<td colspan="5">
							<table align="right">
								<tr> 
									<td align="right">	
										<button type="button" class="submit" id="consultar">Consultar</button> 		
									</td>
								</tr> 
							</table>		
						</td>
					</tr> 
				</table>
		</fieldset>   
	
	   
		<div id="gridReporteMovimientos" style="display: none;">
		</div>
				
		<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
			<tr>
				<td colspan="5" align="right">
					<a id="enlaceExcel" target="_blank">
                  		<button type="button" class="submit" id="excel" style="display: none;">Ver Excel</button>
					</a>
					<a id="enlace" target="_blank">
                  		<button type="button" class="submit" id="imprimir" style="display: none;">Ver PDF</button>
					</a>		
				</td>
			</tr>	
		</table>
	</fieldset>   
</form:form>
</div>
<div id="bloq" title="Bloqueos"  style="overflow: scroll; width: 100%; height: 300px;display: none;font-size: 100%"></div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>