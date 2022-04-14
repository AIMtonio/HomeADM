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
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/invGarantiaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
		
	<script type="text/javascript" src="js/inversiones/liberarInvGarantia.js"></script>
</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Liberaci&oacute;n Anticipada Inversi&oacute;n en Garant&iacute;a</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="invGarantiaBean" >
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<input type="radio" id="radioCredito" name="radioCredito" value="C" tabindex="1"/>
							<label for="radioCredito">Cr&eacute;dito</label>
						</td>
						<td class="separador"></td>
						<td>
							<input type="radio" id="radioInversion" name="radioInversion" value="I" tabindex="2" />
							<label for="radioInversion">Inversi&oacute;n</label>
							<input type="hidden" id="creditoInversion" name="creditoInversion" size="18" tabindex="3" readonly="true" disabled="true"/>
						</td>
					</tr>
				</table>
				<br>
			</td>
		</tr>
		<tr>
			<td>
				<div  id="divCredito" style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Cr&eacute;dito</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td><label for="creditoID">Cr&eacute;dito:</label></td>
								<td><form:input type="text" id="creditoID" name="creditoID" path="creditoID" size="18"	tabindex="4" /></td>
								<td class="separador"></td> 
								<td><label>Estatus: </label></td>
								<td>
									<select id="estatusCre" name="estatusCre" tabindex="5" disabled="disabled" readonly="true">
										<option value=""></option>
								    	<option value="I">INACTIVO</option>
								     	<option value="V">VIGENTE</option>
										<option value="P">PAGADO</option>
										<option value="C">CANCELADO</option>
										<option value="A">AUTORIZADO</option>
										<option value="B">VENCIDO</option>
										<option value="K">CASTIGADO</option>
									</select>
								</td>
							</tr>
							<tr>
								<td><label for="fechaIniCre">Fecha Inicio:</label></td>
								<td><input type="text" id="fechaIniCre" name="fechaIniCre" size="18" readonly="true" disabled="true"  tabindex="6" /></td>
								<td class="separador"></td> 
								<td><label>Fecha Vencimiento: </label></td>
								<td><input type="text" id="fechaVenCre" name="fechaVenCre" readonly="true" disabled="true" size="18" tabindex="7" /></td>
							</tr>
							<tr>
								<td><label>Producto de Cr&eacute;dito: </label></td>
								<td><input type="text" id="proCre" name="proCre" readonly="readonly" disabled="disabled"	size="18" tabindex="8" />
									<input type="text" id="nombreProCre" name="nombreProCre" size="50"  readonly="true" disabled="true"   />
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div  id="divInversion"  style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Inversi&oacute;n</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
					 			<td class="label"><label for="inversionID">Inversi&oacute;n:</label></td>
								<td><input type="text" id="inversionID" name="inversionID" size="18" tabindex="9" />
				     			</td>
				     			<td class="separador"></td>
				     			<td class="label"> 
				         			<label for="lblesm">Monto Inversi&oacute;n:</label> </td>
								<td>
				     				<form:input type="text" id="montoInversion" name="montoInversion" path="montoInversion" readonly="true" disabled="true" size="18" tabindex="10" 
				     					  style="text-align: right;"/>
				     			</td>
				     		</tr>
							<tr>
					 			<td class="label"><label for="fechaVencimientoInver">Fecha Vencimiento:</label></td>
								<td><input type="text" id="fechaVencimientoInver" name="fechaVencimientoInver" size="18" tabindex="11" readonly="true" disabled="true"  />
				     			</td>
				     			<td class="separador"></td>
								<td><label>Estatus: </label></td>
								<td>
									<select id="estatusInv" name="estatusInv" tabindex="12" disabled="disabled" readonly="true">
										<option value=""></option>
								    	<option value="A">INACTIVO</option>
								     	<option value="N">VIGENTE</option>
										<option value="P">PAGADO</option>
										<option value="C">CANCELADO</option>
										<option value="V">VENCIDO</option>
									</select>
								</td>								
				     		</tr>
						</table>
					</fieldset>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend><s:message code="safilocale.cliente"/></legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td><label><s:message code="safilocale.cliente"/>: </label></td>
						<td><input type="text" id="clienteID" name="clienteID" readonly="true" disabled="true" size="18" tabindex="13"/>
							<input type="text" id="nombreCli" name="nombreCli" readonly="true" disabled="true" size="50" />
						</td>
						<td class="separador"></td>
						<td><label>Fecha Nacimiento:</label></td>
						<td><input type="text" id="fechaNacimiento" name="fechaNacimiento" readonly="true" disabled="true" size="18" tabindex="14"/></td>
					</tr>
					<tr>
						<td><label>Sucursal: </label></td>
						<td><input type="text" id="sucursalID" name="sucursalID" readonly="readonly" disabled="disabled"	size="18"		tabindex="15" />
							<input type="text" id="nombreSucursal" name="nombreSucursal" size="50"  readonly="true" disabled="true"   />
						</td>
						<td class="separador"></td> 
						<td><label>Edad: </label></td>
						<td nowrap="nowrap">
							<input type="text" id="edad" name="edad" readonly="true" disabled="true" size="18" tabindex="16"/>
							<label>a&ntilde;os</label>
						</td>
					</tr>
					<tr>
						<td><label>RFC: </label></td>
						<td><input type="text" id="rfc" name="rfc" readonly="readonly" disabled="disabled"	size="22" tabindex="17" />
						</td>
						<td class="separador"></td> 
						<td><label>Fecha Ingreso: </label></td>
						<td><input type="text" id="fechaIngreso" name="fechaIngreso" readonly="true" disabled="true" size="18" tabindex="18"/>
						</td>
					</tr>
					<tr>
						<td><label>Tipo Persona: </label></td>
						<td>
							<input type="text" id="tipoPersona" name="tipoPersona" readonly="readonly" disabled="disabled"	size="30" tabindex="19" />
						</td>
						<td class="separador"></td> 
						<td><label>CURP: </label></td>
						<td><input type="text" id="curp" name="curp" readonly="true" disabled="true" size="28" tabindex="20"/>
						</td>
					</tr>
				</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td>
				<br>
				<div id="situacionGarantia">
					<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Situaci&oacute;n de la Garant&iacute;a</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr> 
							<td nowrap="nowrap"><label>Monto Cr&eacute;dito:</label></td>
							<td><input type="text" id="montoCredito" name="montoCredito" readonly="true" disabled="true" size="18" tabindex="21" style="text-align: right;"/></td>
							<td class="separador"></td>
							<td nowrap="nowrap"><label>Ahorro en Garant&iacute;a:</label></td>
								<td><input type="text" id="ahorroGarantia" name="ahorroGarantia" readonly="true" disabled="true" size="18" 	tabindex="22" style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td><label>% Gar. Liq. Requerida:</label></td>
							<td><input type="text" id="porcentajeGarantia" name="porcentajeGarantia" readonly="true" disabled="true" size="18" tabindex="23" style="text-align: right;"/>
							</td>
							<td class="separador"></td>
							<td nowrap="nowrap"><label>Inversi&oacute;n en Garant&iacute;a:</label></td>
							<td><input type="text" id="inverGarantia" name="inverGarantia"  readonly="true" disabled="true" size="18" 	tabindex="24"  style="text-align: right;" />
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap"><label>Monto Gar. Liq. Requerida:</label></td>
							<td><input type="text" id="garantiaRequerida" name="garantiaRequerida" readonly="true" disabled="true" size="18" tabindex="25" style="text-align: right;"/>
							</td>
							<td class="separador"></td>
							<td nowrap="nowrap"><label><b>Total Garantizado:</b></label></td>
							<td><input type="text" id="totalGarantizado" name="totalGarantizado"  readonly="true" disabled="true" size="18" 	tabindex="26"  style="text-align: right;" />
							</td>
						</tr>
					</table>
					</fieldset>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div id="gridCreditosRelacionados" style="display: none;"></div>
			</td>
		</tr>
		<tr>
			<td>
				<div id="gridInversionesRelacionadas" style="display: none;"></div>
			</td>
		</tr>
		<tr>
			<td align="right" >
				<input type="submit" id="liberar" name="liberar" class="submit" tabindex = "27" value="Liberar Inversiones" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
				<input type="hidden" id="fechaOperacion" name="fechaOperacion" value="0"/>
				<input type="hidden" id="totalInver" name="totalInver" value="0"/>
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