<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="js/fondeador/cambioFuenteFondeoMasivo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="carCambioFondeoBitBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cambio	de fuente de fondeo masivo</legend>
					<table border="0" cellpadding="0" width="100%">
						<tr>
							<td class="label">
								<label for="fecha">Fecha: </label>
							</td>
							<td>
								<input id="fecha" readonly="true" name="fecha" size="12" maxlength="20"	tabindex="1" />
							</td>
						</tr>
	
						<tr>
							<td class="label">
								<label for="nombreArchivo">Nombre del Archivo: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="nombreArchivo"name="nombreArchivo" readonly="true" size="30" tabindex="2" /></td>
							<td class="separador"></td>
							<td><input type="button" id="adjuntar" onclick="subirArchivos()" name="adjuntar" class="submit"	value="adjuntar" tabindex="3" /></td>
						</tr>
					</table>
					<br>

					<table border="0" >
						<tr >
							<div id="listaValidaciones" style="display: none;" ></div>
						</tr>
					</table>
					<br>
	
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
						<tr>
							<td align="right">
								<input type="submit" id="procesar"name="procesar" class="submit" value="Procesar" tabindex="4" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
								<input type="hidden" id="numeroTransacion" name="numeroTransacion" value="0"/>
							</td>
						</tr>
					</table>
				
			</fieldset>
			<div id="listaValidaciones"></div>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
<html>