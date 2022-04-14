<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
 	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>

	<!-- Grafias -->
		<script type="text/javascript" src="js/tesoreria/Consola/highcharts.js"></script>
	    <script type="text/javascript" src="js/tesoreria/Consola/grid.js"></script>
		<script type="text/javascript" src="js/tesoreria/Consola/exporting.js"></script>
	<!-- Fin de Graficas -->
	
	<script type="text/javascript" src="dwr/interface/consolaServicioScript.js"></script>
	
	<script type="text/javascript" src="js/tesoreria/Consola.js"></script>
			
	<style>
		.cajatexto{
			border-width:0;
			border-color: #000000;
			font-size: 12px;
			text-align:right;
		}
		.cajaEncabezado{
			border-width:0;
			border-color: #000000;
			font-size: 12px;
		}
	</style>
		
<title>Consola Central</title>
</head>
<body>
 
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Vista Posición Global</legend>
		
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="consolaBean" >
					
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="label" >
						<label for="lblfecha">Fecha:</label>
				</td>
				<td >
					<input type="text" name="fechaDelDia" id="fechaDelDia" value="" class="cajaEncabezado"/>
				</td>
				<td colspan="2"></td>
				<td class="label">
						<label for="lblsucursal">Sucursal:</label>
				</td>
				<td>
					<input type="text" name="sucursalDelDia" id="sucursalDelDia" value="" class="cajaEncabezado"/>
				</td>
			</tr>
		</table>
		
			</br>
			
		<table border="0" cellpadding="0" cellspacing="0">	
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Ingresos</legend>
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td class="label"><label for="lblcuentasBancos">Cuentas Bancos:</label></td>
									<td >
										<form:input type="text" name="cuentasBancos" id="cuentasBancos" path="cuentasBancos"  value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="bancos" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label"><label for="lblinversiones">Inversiones Bancarias:</label></td>
									<td>
										<form:input type="text" name="inversionBancarias" id="inversionBancarias" path="inversionBancarias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="inversiones" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label"><label for="lblmontoVenc">Monto Vencimiento Créditos al día de hoy:</label></td>
									<td>
										<form:input type="text" name="montoCreVencidos" id="montoCreVencidos" path="montoCreVencidos" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="creditosVencidos" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<!-- Vencimientos de creditos -->
								<tr>
									<td class="label" align="right"><label for="lblvenCre15">Mañana a 15 días:</label></td>
									<td><form:input type="text" name="totalCred15dias" id="totalCred15dias" path="totalCred15dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="creditosVencidos15" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblvenCre30">16 a 30 días:</label></td>
									<td><form:input type="text" name="totalCred30dias" id="totalCred30dias" path="totalCred30dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="creditosVencidos30" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblvenCre60">31 a 60 días:</label></td>
									<td><form:input type="text" name="totalCred60dias" id="totalCred60dias" path="totalCred60dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="creditosVencidos60" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<!-- Fin vencimientos de creditos -->
								<tr>
									<td class="label"><label for="lblefectivoCajas">Efectivo en Cajas:</label></td>
									<td>
										<form:input type="text" name="efectivoCaja" id="efectivoCaja" path="efectivoCaja" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="caja" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label"><b><label for="lbltotalEfectivo">Total Efectivo</label></b></td>
									<td><input type="text" name="totalEfectivo" id="totalEfectivo"  value="" class="cajatexto" readOnly="true"/></td>
								</tr>
								<tr>
									<td class="label"><b><label for="lbltotalCirculante">Total Circulante</label></b></td>
									<td><input type="text" name="totalCirculante" id="totalCirculante"  value="" class="cajatexto" readOnly="true"/></td>
								</tr>
							</table>
						</fieldset>
					</td>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="ui-widget ui-widget-header ui-corner-all">Egresos</legend>
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td class="label"><label for="lbdldeseembolsoPen">Desembolsos Pendientes Dispersión:</label></td>
									<td >
										<form:input type="text" name="desPendientesDis" id="desPendientesDis" path="desPendientesDis" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="dispersion" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" readOnly="true"/></a>
									</td>
								</tr>
								<tr>
									<td class="label"><label for="lblgastos">Gastos Autorizados Pendientes:</label></td>
									<td>
										<form:input type="text" name="gastosPendientes" id="gastosPendientes" path="gastosPendientes" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="gastos" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" readOnly="true"/></a>
									</td>
								</tr>
								<tr>
									<td class="label"><label for="lblvenFon">Vencimiento Fondeadores al día de hoy:</label></td>
									<td>
										<form:input type="text" name="vencimientoFonde" id="vencimientoFonde" path="vencimientoFonde" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="fondeadorVencimiento" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" readOnly="true"/></a>
									</td>
								</tr>
								<!-- Proyecciones -->
								<tr>
									<td class="label" align="right"><label for="lblven15">Mañana a 15 días:</label></td>
									<td><form:input type="text" name="total15Dias" id="total15Dias" path="total15Dias" value="" class="cajatexto" readOnly="true"/></td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblven30">16 a 30 días:</label></td>
									<td><form:input type="text" name="total30Dias" id="total30Dias" path="total30Dias" value="" class="cajatexto" readOnly="true"/></td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblven60">31 a 60 días:</label></td>
									<td><form:input type="text" name="total60Dias" id="total60Dias" path="total60Dias" value="" class="cajatexto" readOnly="true"/></td>
								</tr>
								<!-- Fin Proyecciones -->
								<tr>
									<td class="label"><label for="lblpresupuesGast">Presupuestos Gastos Aut.:</label></td>
									<td>
										<form:input type="text" name="presuGasAuto" id="presuGasAuto" path="presuGasAuto" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="gastosAutorizados" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label"><label for="lblpagoInteres">Pago Inversiones Plazo hoy:</label></td>
									<td>
										<form:input type="text" name="pagoInteresCaptacion" id="pagoInteresCaptacion" path="pagoInteresCaptacion" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="interes" class="detalle"><img src="images/info2.png" alt="Informacion" width="15" title="Informaci&oacute;n" height="15" /></a>
									</td>
								</tr>
								<!-- inv Plazo -->
								<tr>
									<td class="label" align="right"><label for="lblvenInv15">Mañana a 15 días:</label></td>
									<td><form:input type="text" name="totalInv15dias" id="totalInv15dias" path="totalInv15dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="totalInv15dia" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblvenInv30">16 a 30 días:</label></td>
									<td><form:input type="text" name="totalInv30dias" id="totalInv30dias" path="totalInv30dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="totalInv30dia" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<tr>
									<td class="label" align="right"><label for="lblvenInv60">31 a 60 días:</label></td>
									<td><form:input type="text" name="totalInv60dias" id="totalInv60dias" path="totalInv60dias" value="" class="cajatexto" readOnly="true"/>
										<a href="javascript:" id="totalInv60dia" class="detalle"><img src="images/info2.png" alt="Informacion" title="Informaci&oacute;n" width="15" height="15" /></a>
									</td>
								</tr>
								<!-- fin inv Plazo -->
								<tr>
									<td class="label" colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td class="label"><b><label for="lbltotalCompromisoInm">Total de Compromiso Inmediato</label></b></td>
									<td><input type="text" name="totalCompInm" id="totalCompInm"  value="" class="cajatexto" readOnly="true"/></td>
								</tr>
								<tr>
									<td class="label"><b><label for="lbltotalCompromisoAut">Total de Compromiso Autorizado</label></b></td>
									<td><input type="text" name="totalCompAut" id="totalCompAut"  value="" class="cajatexto" readOnly="true"/></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
		</table>
		
		</br>
		
		<div id="tablaDetalle">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Detalle <label id="nombre"></label> &nbsp;&nbsp; <a href="javascript:" id="cerrarDetalle" ><img src="images/close.gif" alt="Cerrar" title="Cerrar"/></a></legend>
					<table id="detalleConsola" border="1" cellpadding="0" cellspacing="0" ></table>
			</fieldset>
		</div>
		
	</fieldset>
	
	</br>
		
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Gráficas</legend>
		<table>
			<tr>
				<td><div id="contenedorActivos" style="width: 750px; height: 400px; margin: 0 auto"></div></td>
				<td><div id="contenedorEgresos" style="width: 750px; height: 400px; margin: 0 auto"></div></td>
			</tr>
			<tr>
				<td><div id="contenedorCompromiso" style="width: 750px; height: 400px; margin: 0 auto"></div></td>
				<td></td>
			</tr>
		</table>
	</fieldset>
		
			
</form:form>

</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"/>
</body>
</html>