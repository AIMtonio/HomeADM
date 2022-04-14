<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html"%> 
<%@ page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/utileria.js"></script>
	<script type="text/javascript" src="js/date.js"></script>
	
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasInversionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/invGarantiaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>         	
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		
	<script type="text/javascript" src="js/inversiones/invGarantia.js"></script>
</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Inversi&oacute;n en Garant&iacute;a</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="invGarantiaBean" >
	<table border="0" width="100%">
		<tr>
			<td>
				<table border="0"  width="100%">
					<tr>
						<td><label for="creditoID">Cr&eacute;dito:</label></td>
						<td><form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="18"	tabindex="1" /></td>
						<td class="separador"></td> 
						<td><label>Estatus: </label></td>
						<td>
							<input type="text" id="estatusCre" name="estatusCre" readonly="true"  size="18"  />
							<input type="hidden" id="estatus" name="estatus" readonly="true"  size="18"/>
						</td>
					</tr>
					<tr>
						<td><label><s:message code="safilocale.cliente"/>: </label></td>
						<td><input type="text" id="clienteID" name="clienteID" readonly="true"  size="18" />
							<input type="text" id="nombreCli" name="nombreCli" size="50"  readonly="true" />
						</td>
						<td class="separador"></td>
						<td><label>Cuenta:</label></td>
						<td><input type="text" id="cuentaAhoID" name="cuentaAhoID" readonly="true"  size="18" /></td>
					</tr>
					<tr>
						<td><label>Producto de Cr&eacute;dito: </label></td>
						<td><input type="text" id="proCre" name="proCre" readonly="readonly" 	size="18"		/>
							<input type="text" id="nombreProCre"  name="nombreProCre" size="50"  readonly="true"   />
						</td>
						<td class="separador"></td> 
						<td><label>Monto del Cr&eacute;dito: </label></td>
						<td><input type="text" id="montoCre" name="montoCre" readonly="true"  size="18"  style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td><label>Fecha Inicio:</label></td>
						<td><input type="text" id="fechaIniCre" name="fechaIniCre" readonly="true" size="18" /></td>
						<td class="separador"></td>
						<td><label>Fecha Vencimiento:</label></td>
							<td><input type="text" id="fechaVenCre" name="fechaVenCre" readonly="true"  size="18" 	 />
						</td>
					</tr>
					<tr>
						<td><label>Gar. Liq. Requerida:</label></td>
						<td>
							<input type="text" id="porcentajeGarantia" name="porcentajeGarantia" readonly="true"  size="8" style="text-align: right;"/>
							<label>% &nbsp;&nbsp;Monto:</label>
							<input type="text" id="montoGarantia" name="montoGarantia" readonly="true" size="18" style="text-align: right;"/>
						</td>
						<td class="separador"></td>
						<td><label>Gar. Liq. Cubierta:</label></td>
						<td><input type="text" id="garantiaCubierta" name="garantiaCubierta" readonly="true"  size="18" style="text-align: right;" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
					<table border="0"  width="100%">	 
						<tr >
				 			<td class="label"><label for="inversionID">Inversi&oacute;n:</label></td>
							<td><input type="text" id="inversionID" name="inversionID" path="inversionID" size="11" tabindex="13" />
			     			</td>
			     			<td class="separador"></td>
			     			<td class="label"> 
			         			<label for="lblesm">Monto Inversi&oacute;n:</label> </td>
							<td>
			     				<form:input type="text" id="montoInversion" name="montoInversion" path="montoInversion" readonly="true" size="18"  
			     					  style="text-align: right;"/>
			     			</td>
			     		</tr>
			     		<tr>
			     			<td class="label"> 
			         			<label for="lblesm">Tasa Bruta:</label> 
			         		</td>
							<td>
			     				<form:input type="text" id="tasa" name="tasa" path="tasa" readonly="true"   size="11"   
			     					style="text-align: right;"/><label for="lblesm">%</label>
			     			</td>
				     		<td class="separador"></td>
				     		<td class="label"> 
				         		<label for="lblesm">Fecha Vencimiento:</label> </td>
							<td>
				     			<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" readonly="true"   size="18"  />
				     		</td>
				     	</tr>
				     	<tr>
				     		<td class="label"> 
				         		<label for="lblesm">Reinvertir:</label> </td>
							<td>
				     			<input type="text" id="reinvertirDes" name="reinvertirDes" readonly="true"  size="30"/>
				     			<input type="hidden" id="reinvertir" name="reinvertir" path="reinvertir" readonly="true"  size="30"/>
				     		</td>
				     		<td class="separador"></td>
				     		<td class="label"> 
				         		<label for="etiqueta">Etiqueta:</label> </td>
							<td>
								<textarea id="etiqueta" name="etiqueta" rows="2" cols="40" readonly="true" ></textarea>
				     		</td>
				    	</tr>
				    	
				     	<tr>
				     		<td class="label"> 
				         		<label for="lblGar">Monto Garantizado:</label> </td>
							<td>
				     			<input type="text" id="montoGarantizado" name="montoGarantizado" readonly="true"  size="18" style="text-align: right;"/>
				     		</td>
				     		<td class="separador"></td>
				     		<td class="label"> 
				         		<label for="etiquetaMontoDisp">Monto Disponible:</label> </td>
							<td>
								<input type="text" id="montoDisponible" name="montoDisponible" readonly="true"  size="18" style="text-align: right;"/>
				     		</td>
				    	</tr>
				     	<tr>
				     		<td class="label"> 
				         		<label for="lblesm">Total a Garantizar:</label> </td>
							<td>
				     			<form:input type="text" id="montoEnGar" name="montoEnGar" path="montoEnGar" size="18" tabindex="14" esMoneda="true"
				     				  style="text-align: right;"/>
				     		</td>
				    	</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<div id="gridInversionesRelacionadas" style="display: none;"></div>
			</td>
		</tr>
		<tr>
			<td align="right" >
				<input type="submit" id="agrega" name="agrega" class="submit" tabindex = "21" value="Agregar" />
				<input type="submit" id="elimina" name="elimina" class="submit" value=Eliminar tabindex="22" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" tabindex="23" />
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"  tabindex="24" />
				<form:input type="hidden" id="creditoInvGarID" name="creditoInvGarID" path="creditoInvGarID"  tabindex="25"/>
				<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>"  tabindex="24" />				
			</td>
		</tr>
	</table>		
	</form:form>
</fieldset>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista"  style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>
</body>
</html>