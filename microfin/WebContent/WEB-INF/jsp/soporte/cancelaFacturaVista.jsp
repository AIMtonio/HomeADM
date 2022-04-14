<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
			<script type="text/javascript" src="dwr/interface/cancelaFacturaServicio.js"></script>
			<script type="text/javascript" src="js/soporte/cancelaFactura.js"></script>
			<script type="text/javascript" src="js/jquery.maskedinput-1.3.min.js" ></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelarFactura">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cancelación de Factura</legend>
		      		<table border="0" cellpadding="0" cellspacing="0" width="800">
						<tr>
							<td class="label">
								<label for="radioFiscal">Buscar por :  </label>
							</td>
							 <td>
									<input type="radio" id="opcionFiscal" name="opcionesBusqueda"tabindex="1" value="1"/>
									<label for="opcionFiscal">Folio Fiscal</label>
							 </td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td>
									 <input type="radio" id="opcionRango" name="opcionesBusqueda" tabindex="2" value="2"/>
									 <label for="opcionRango">Rango de Fechas</label>
							</td>
						</tr>
						<tr id="divOpcionFiscal">
							<td class="label">
									<label for="folioFiscal">Folio Fiscal: </label>
							</td>
							<td>
								<form:input type="text" id="folioFiscal" name="folioFiscal" path="folioFiscal" size="50" tabindex="3" onBlur="ponerMayusculas(this)"/>
							</td>
						</tr>
						<tr id="divOpcionRango">
							<td class="label">
									<label for="fechaInicio">Fecha Inicio: </label>
							</td>
							<td>
								<form:input type ="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="20" esCalendario="true" tabindex="4"/>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="label">
								<label for="fechaFin">Fecha Fin:</label>
							</td>
							<td>
								<form:input type="text" id="fechaFin" name="fechaFin" path="fechaFin" size="20" esCalendario="true" tabindex="5"/>
							</td>
						</tr>
						<tr id="divOpcionRango2">
								<td class="label">
									<label for="rFCReceptor">RFC Receptor:</label>
								</td>
								<td>
									<form:input type="text" id="rfcReceptor" name="rfcReceptor" path="rfcReceptor" size="20" maxlength="13"  tabindex="6" onBlur="ponerMayusculas(this)"/>
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
									<label for="estatus">Estatus del Comprobante:</label>
								</td>
								<td>
									<select id="estatus" name="estatus" tabindex="7">
										<option value="">Selecciona</option>
										<option value="1">Vigente</option>
										<option value="2">Cancelado</option>
									</select>
								</td>
						</tr>
				</table>
				<table width="100%">
					<tr>
						<td align="right">
							<input type="button" id="buscar" name="buscar" class="submit" value="Buscar"  tabindex="8"/>
						</td>
					</tr>
				</table>
				<div id="gridCancelaFactura" style="display: none;"/>
				<table width="100%">
					<tr>
						<td align="right">
							<input type="hidden" id="listaIDS" name="listaIDS"/>
							<input type="hidden" id="listaFolios" name="listaFolios"/>
							<input type="hidden" id ="listaMotivos" name="listaMotivos"/>
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