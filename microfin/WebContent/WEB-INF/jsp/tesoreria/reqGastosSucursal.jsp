<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/reqGastosSucServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/presupSucursalServicio.js"></script>  
 	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/facturaProvServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/detfacturaProvServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/prorrateoContableServicio.js"></script>  
 
	<script type="text/javascript" src="js/tesoreria/reqGastosSucursal.js"></script>

	<title>Requisición de Gastos</title>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Requisici&oacute;n de Gastos</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="requisicionGastosSuc">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Datos Generales</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tr>
				<td><label>N&uacute;mero Requisici&oacute;n:</label></td>
				<td>
					<form:input type="text" name="numReqGasID" id="numReqGasID" path="numReqGasID" size="11"
						autocomplete="off" tabindex="1" maxlength="40" />
				</td>
				<td class="separador"></td>
				<td colspan="2"><label>Fecha Requisici&oacute;n:</label></td>
				<td>
					<form:input type="text" name="fechRequisicion" id="fechRequisicion" disabled="true"
						 path="fechRequisicion" size="15" autocomplete="off" tabindex="2"/>
				</td>
			</tr>
			<tr>
				<td><label>Sucursal:</label></td>
				<td><form:input type="text" name="sucursalID" id="sucursalID" size="11" tabindex="3"
						autocomplete="off" path="sucursalID"  disabled="true" /> 
					<input type="text" name="nombreSucursal" id="nombreSucursal" size="40"
						readOnly="true" disabled="true" tabindex="4" />
					<form:input type="hidden" name="institucionSuc" id="institucionSuc" path="institucionSuc" 
						size="10" tabindex="5"/>
					<form:input type="hidden" name="cuentaAhoID" id="cuentaAhoID" path="cuentaAhoID" size="50" tabindex="6"/>
				</td>
				<td class="separador"></td>
				<td colspan="2"><label>Estatus Requisici&oacute;n:</label></td>
				<td>
					<form:select id="estatus" name="estatus" path="estatus" disabled="true" tabindex="9">
						<form:option value="A">Alta</form:option>
						<form:option value="P">Procesada</form:option>
						<form:option value="F">Finalizada</form:option>
						<form:option value="C">Cancelada</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td><label>Elabor&oacute;:</label></td>
				<td>
					<form:input type="text" name="usuarioID" id="usuarioID" size="11"  autocomplete="off" 
						path="usuarioID" disabled="true" tabindex="7"/>
					<input type="text" name="nombreUsuario" id="nombreUsuario" size="40" readOnly="true" 
						disabled="true" tabindex="8"/>
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
			</tr>
			<tr>
				<td><label>Responsable del Pago:</label></td>
				<td>
					<form:select id="tipoGasto" name="tipoGasto" path="tipoGasto" tabindex="10" disabled="true" >
						<form:option value="C">Centralizado</form:option>
						<form:option value="S">Sucursal</form:option>
					</form:select>
				</td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>
				<td class="separador"></td>			
			</tr>
		</table>
		</fieldset>
		<br>
		<fieldset id="capturaFactura" class="ui-widget ui-widget-content ui-corner-all">
		<legend>Factura</legend>
		<table id="tablaFactura" border="0" cellpadding="0" cellspacing="0" width="100%">
        	<tr>
        		<!-- <td class="label"><label>C.Costos:</label></td>
				<td>
					<input type="text" name="centroCostoID" id="centroCostoFact" size="8" autocomplete="off" tabindex="1" />	
				</td> -->
				
				<td class="label"><label>Proveedor:</label></td>
				<td>
					<input type="text" name="proveedorIDFact" id="proveedorIDFact" size="4" autocomplete="off" tabindex="2" 
						/>	
				</td>
				<td> 
					<input type="text" name="descProveedorFact" id="descProveedorFact"  size="25" autocomplete="off" 
						disabled="true" tabindex="3"/>						  
				</td>
				<td class="separador"></td>
            	<td class="label"><label>N&uacute;mero Factura:</label></td>
                <td align="left">
					<input type="text" name="noFactura" id="noFactura" size="18"
						autocomplete="off" tabindex="4" />						  
				</td>
				<td class="separador"></td>
				<td class="label"><label>Total:</label></td>
				<td>
					<input type="text" name="totalFactura" id="totalFactura"  size="15" autocomplete="off" disabled="true"
					 	style="text-align: right" tabindex="5"/>						  
				</td>
				<td class="separador"></td>
				<td class="label"><label>Saldo:</label></td>
				<td>
					<input type="text" name="saldoFactura" id="saldoFactura"  size="15" autocomplete="off" disabled="true"
					 	style="text-align: right" tabindex="6"/>						  
				</td>
				<td>
                	<input type="button" id="agreDetalleFac" 	 name="agreDetalle"    class="btnAgrega" value="" tabindex="20" />
                </td>	
				<td class="separador" width="50%"></td>
          	</tr>
		</table>
        </fieldset>
        <br>
		<fieldset id="capturaDetalle" class="ui-widget ui-widget-content ui-corner-all">
		<legend>Capturar Detalle de Requisición</legend>
		<table id="miTablauno" border="0" cellpadding="0" cellspacing="0" width="100%">
        	<tr>
        		<td><label>C.Costos</label></td>
            	
            	<td><label>Tipo Gasto</label></td>
            	<td></td>
                <td><label>Proveedor</label></td>
                <td></td>
                <td><label>Concepto/Observaciones</label></td>
              	<td><label>Presupuesto</label></td>
                <td><label>Monto<br>Disponible</label></td>
                <td><label>Monto<br>Solicitado</label></td>
                <td><label>Monto<br>Autorizado</label></td>
                <td><label>Monto Fuera<br>de Presupuesto</label></td>
          	</tr> 
			<tr>
				
				<td>
					<input type="text" name="centroCostoID" id="centroCostoDet" size="8" autocomplete="off" tabindex="21" />	
				</td>
				<td>
					<input type="text" name="tipoGastoID" id="tipoGastoID" path="tipoGastoID" size="8"
						autocomplete="off" tabindex="22" />
				</td>
				<td>
                   	<input type="text" name="descripcionTG" id="descripcionTG" path="descripcionTG" size="18"
						autocomplete="off"  disabled="true" tabindex="23"/>						  
				</td>
				<td>
					<input type="text" name="proveedorID" id="proveedorID" path="proveedorID" size="8" autocomplete="off" tabindex="24" />
				</td>
				<td>	
					<input type="text" name="descProveedor" id="descProveedor"  size="18" autocomplete="off" tabindex="25"
						disabled="true"/>						  
				</td>
				<td>
					<input type="text" name="observaciones" id="observaciones" path="observaciones" size="30" maxlength= "50"
						autocomplete="off"  tabindex="26"  />
				</td>
				<td>
					<input type="text" name="partidaPre"  esMoneda="true" id="partidaPre" path="partidaPre" size="13" style="text-align:right;"
						autocomplete="off"  readOnly="true" tabindex="27" disabled="disabled" />
					<input name="partidaPreID" 
						id="partidaPreID" value="0" path="partidaPre" size="13" type="hidden"  tabindex="28"/>
				</td>	
				<td>
					<input type="text" name="montoDispon" id="montoDispon" path="montoDispon" size="13" style="text-align:right;"
						autocomplete="off"   esMoneda="true" readOnly="true" disabled="disabled" tabindex="29" />
				</td>	
				<td>
					<input type="text" name="montoPre" id="montoPre" path="montoPre" size="13" style="text-align:right;"
						autocomplete="off"  tabindex="30" esMoneda="true" onkeyPress="return Validador(event);" />
				</td>
				<td>
					<input type="text" name="montoAuto" id="montoAuto" path="montoAuto" size="13" style="text-align:right;"
						autocomplete="off"   readOnly="true" esMoneda="true"  tabindex="31"/>
				</td>
				<td>
					<input type="text" name="noPresupuestado" id="noPresupuestado" path="noPresupuestado" size="13" style="text-align:right;"
						autocomplete="off"  esMoneda="true" readOnly="true" tabindex="32"/>
				</td>		
				<td>
					<input type="hidden" name="monAutorizado" id="monAutorizado" path="monAutorizado" size="13" style="text-align:right;"
							autocomplete="off"  value="0.00"  tabindex="33" />
					<input type="hidden" id="status" name="status"  path="status" value="N" tabindex="34"/>
				</td>	
				<td>
                	<input type="button" id="agreDetalle" name="agreDetalle" class="btnAgrega" value="" tabindex="40" />
                </td>	
			</tr>
		</table>
		<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" tabindex="41" />
        </fieldset>
        <br>
        <div id="contenedorDtlle" style="display: none;"> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Detalles de Requisición</legend>
        <table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
        	<tr>
            	<td></td>
            	<td><label>C.Costos</label></td>
                <td><label>No. Factura</label></td>
                <td><label>Tipo Gasto</label></td>
                <td colspan = "2"><label>Proveedor</label></td>
                <td><label>Observaciones</label></td>
                <td><label>Concepto/Observaciones</label></td>
                <td><label>Monto<br>Disponible</label></td>
                <td><label>Monto<br>Solicitado</label></td>
                <td><label>Monto fuera<br>de Presupuesto</label></td>
                <td><label>Monto<br>Autorizado</label></td>
                <td><label>Tipo<br>Desembolso</label></td>
                <td><label>Estatus</label></td>
        	</tr>
            <tr id="rTotalGasto" name="col" ></tr>                
    	</table>
        <br>               
				
		<div>
			<table>
				<tr>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>	
						<td class="separador"/> <td class="separador"/>
						<td class="separador"/> <td class="separador"/>
					<td colspan="7" align="right" >
						<input type="button" id="aplicaPro" name="aplicaPro" value="Aplicar Prorrateo" class="submit" style="display: none;"/>
					</td>
				</tr>
			</table>
		</div>	
		<!-- INICIO Seccion de Prorrrateo Contable y GRID -->
		<div id="prorrateoContable" style="display: none;">
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Aplicar Métodos Prorrateo</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<label for="prorrateoID">Método Prorrateo: </label>
									</td>
									<td colspan="7">
										<input type="text" id="prorrateoID" name="prorrateoID" tabindex="10" size="8" maxlenth="50"/>
										<input type="text" id="nombreProrrateo" name="nombreProrrateo" readOnly="readOnly" size="40" maxlength="50"/>
									</td>
								</tr>	
								<tr>
									<td>
										<label for="descripcion">Descripción: </label>
									</td>
									<td>
										<textarea cols="35" rows="3" value="" id="descripcion" name="descripcion" readOnly="readOnly" maxlength="100"></textarea>
									</td>
								</tr>										
							</table>
						</td>												
					</tr>							
					<tr>
						<td>
							<div id="gridProrrateoContable" name="gridProrrateoContable" style="display: none;"></div>
						</td>
					</tr>
					<tr>
						<td colspan="7" align="right">
							<br>
							<input type="button" id="aplicaProrrateo" name="aplicaProrrateo" value="Aplicar" class="submit" disabled="disabled"/>
							<input type="button" id="cancelaProrrateo" name="cancelaProrrateo" value="Cancelar Prorrateo" class="submit"/>
						</td>
					</tr>
				</table>						
			</fieldset>					
		</div>			
		<!-- FIN Seccion de Prorrrateo Contable y GRID -->	
		<br>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">			
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="agregar" 			name="agregar" 		class="submit" value="Agregar" 		tabIndex="50"/>
					<input type="submit" id="modificar" 		name="modificar" 	class="submit" value="Modificar" 	tabindex="51" /> 
					<input type="hidden" id="tipoTransaccion" 	name="tipoTransaccion" tabindex="52"  />
					<input type="hidden" id="prorrateoHecho"	name="prorrateoHecho" value="N"/>
				</td>
			</tr>
		</table>
											
		</fieldset>
		</div>			
		</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;" ></div>
</body>
</html>
