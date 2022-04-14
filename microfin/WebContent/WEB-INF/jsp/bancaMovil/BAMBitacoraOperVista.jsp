<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/usuariosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/bamBitacoraOperServicio.js"></script>
   		<script type="text/javascript" src="js/bancaMovil/bitacoraOperaciones.js"></script>
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operacionBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Bitacora de Operaciones</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr>
				<td style="display: block;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
          				<table  border="0"  width="560px">
							<tr>
								<td class="label">
									<label for="fechaInicio">Fecha de Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" tabindex="1" type="text" esCalendario="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="fechaFin">Fecha de Fin: </label>
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" tabindex="2" type="text" esCalendario="true"/>
								</td>
							</tr>
							
							<tr> 
								<td class="label">
									<label for="clienteID">Cliente:</label>
								</td>
								<td >
									<form:input id="clienteID" name="clienteID" path="clienteID" tabindex="3" size="6" value="0"/>
									<input type="text"id="nombreCliente" name="nombreCliente" size="39" readOnly="true"/>									 
								</td>							
							</tr>
							
						<tr>
						<td>
							<label>Tipo Operaci&oacute;n:</label>
						</td>
						<td colspan="4">
						<select id="tipoOperacion" name="tipoOperacion" path="tipoOperacion" tabindex="4" >
					         <option value="0">TODAS</option>
						      </select>									 
						</td>
						</tr>
							        
						</table>
					</fieldset>
				</td>

				<td>
					<table width="200px">
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="excel" name="tipoRpt" value="1" tabindex="6" />
									<label> Excel </label>
				            		<br>
								</fieldset>
							</td>
						</tr>
						<tr>
							<td>
								<br><br><br><br>
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<a id="ligaGenerar">
									 <input type="button" id="generar" name="generar" class="submit"
											 tabIndex = "10" value="Generar" />
								</a>
							</td>
						</tr>
					</table>

				</td>
			</tr>
		</table>
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>