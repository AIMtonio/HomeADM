<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="dwr/interface/cargaMasivaFacturasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/procesaCargaMasivaFacturasVista.js"></script>
</head>
<body>

	<div id="contenedorForma">

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaMasivaFacturasBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Procesa Carga Masiva de Facturas</legend>

				<table border="0" width="100%">
					<tr>
						<td class="label">
					         <label for="lblFechaInicio">Folio:</label>
						</td>
						<td>
							<form:input id="folioCargaID" name="folioCargaID" tabindex="1" path="folioCargaID" size="10"/>
						</td>
						<td class="separador"></td>
						<td class="label" >
					        <label for="centroCostoID">C.Costos: </label>
					    </td>
					   <td>
							<input id="centroCostoID" name="centroCostoID" tabindex="2" size="10"/>
							<input id="nombreCenCosto" name="nombreCenCosto" size="35" disabled="true"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
						<td class="label">
							<label for="lbltipoGasto">Tipo de Gasto:</label>
					   </td>
					   <td>
						   <input id="tipoGastoID" name="tipoGastoID" tabindex="3" size="10"/>
						   <input id="nombreTipoGasto" name="nombreTipoGasto"  size="35" disabled="true"/>
					   </td>
					   <td class="separador"></td>
						<td class="label" >
					        <label for="fechaCarga">Fecha Carga: </label>
					    </td>
					   <td>
							<input id="fechaCarga" name="fechaCarga" tabindex="4" size="15"  disabled="true"/>
						</td>
						<td class="separador"></td>
					</tr>
					<tr>
					    <td class="label" nowrap="nowrap">
					        <label for="mes">Mes: </label>
					    </td>
					   <td nowrap="nowrap">
							<input id="mes" name="mes" tabindex="5" size="15"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
					         <label for="usuario">Usuario Carga:</label>
						</td>
						<td nowrap="nowrap">
							<input id="usuario" name="usuario" tabindex="6" size="30"  disabled="true"/>
						</td>
					</tr>
					<tr>
					    <td class="label" >
					        <label for="totalFacturas">Total Facturas: </label>
					    </td>
					   <td>
							<input id="totalFacturas" name="totalFacturas" tabindex="7" size="15"  disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
					         <label for="numFacturasExito">Facturas éxito:</label>
						</td>
						<td>
							<input id="numFacturasExito" name="numFacturasExito" tabindex="8" size="15" disabled="true"/>
						</td>
					</tr>
					<tr>
						<td class="label">
					         <label for="numFacturasError">Facturas error:</label>
						</td>
						<td>
							<input id="numFacturasError" name="numFacturasError" tabindex="9" size="15" disabled="true"/>
						</td>
						<td class="separador"></td>
						<td class="label">
					         <label for="numFacturasExito">Estatus Folio:</label>
						</td>
						<td>
							<input id="descripcionEstatus" name="descripcionEstatus" tabindex="10" size="15" disabled="true"/>
						</td>
					</tr>
					<table border="0" cellpadding="2" cellspacing="0" width="100%"></table>
						<div id="gridBitacoraCargaArchivo" style="display:none"> </div>
					</table>
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Procesar" tabindex="15" />
								<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="15" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
								<input type="hidden" id="nombreLista" name="nombreLista" />
							</td>
						</tr>
					</table>
				</table>
 			</fieldset>
		</form:form>
		<div id="ejemploArchivo" style="display:none">
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>