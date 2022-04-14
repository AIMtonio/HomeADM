<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/forma.js"></script>
	<script type="text/javascript" src="dwr/interface/cargaMasivaFacturasServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/cargaMasivaFacturas.js"></script>
</head>
<body>

	<div id="contenedorForma">

		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaMasivaFacturasBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Carga Masiva de Facturas</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
					         <label for="lblFechaInicio">Fecha Carga:</label>
						</td>
						<td>
						<form:input id="fechaInicio" name="fechaInicio" tabindex="3" path="fechaInicio" readOnly="true" size="10" disabled="true" />
						</td>
					</tr>
					<tr>
					    <td class="label" >
					        <label for="mes">Mes: </label>
					    </td>
					   <td>
							<select id="mes" name="mes" tabindex="1">
								<option value="0">SELECCIONAR</option>
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
				</table>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
					<td class="label">
						<div class="label">
							<label>
								<br>
									Este proceso realiza la Carga de Facturas de Proveedores de forma Masiva a trav&eacute;s de un Archivo en Formato Excel.
								<br>
								<br>
								En caso de que el archivo cargado contenga errores en alguno de los registros, favor de
								<br>
								   cargar nuevamente el archivo corrigiendo dichos errores para que se pueda procesar la
								<br>
								   carga correctamente.
								</label>
						</div>
					</td>
					</tr>
	 				<br>
					<tr>
						<td class="label" align="right">
							<a class="submit" id="descargaArchivo" href="reportes/tesoreria/FormatoCargaMasivaFacturas.xlsx" download="FormatoCargaMasivaFacturas.xlsx">Descargar Formato del Archivo</a>
							<input type="button"id="adjuntar" name="adjuntar" class="submit" value="Subir Archivo" tabindex="5" />
						</td>
					</tr>
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<td align="right">
								<input type="button" id="verBitacora" name="verBitacora" class="submit" value="Ver Fallidos" tabindex="6" />
								<input type="button" id="ocultar" name="ocultar" class="submit" value="Ocultar Fallidos" tabindex="7" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="3"/>
							    <input type="hidden" id="folioCargaID" name="folioCargaID" size="10" tabindex="4" disabled= "true" />
							</td>
						</tr>
					</table>

					<div id="gridBitacoraCargaArchivo" >
     				</div>
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