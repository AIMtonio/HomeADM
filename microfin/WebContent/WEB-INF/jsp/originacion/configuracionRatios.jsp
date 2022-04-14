<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Configuraci&oacute;n Ratios</title>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="js/originacion/configuracionRatios.js"></script>
<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ConfiguracionRatios">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Configuraci&oacute;n Ratios</legend>
				<table border="0" width="100%">
					<tbody>
						<tr>
							<td class="label" nowrap="nowrap">
								<label>Producto de Cr&eacute;dito:</label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="producCreditoID" name="producCreditoID" size="12" tabindex="1" iniforma="false" maxlength="11" /> <input type="text" id="descripProducto" name="descripProducto" size="50" type="text" readOnly="true" disabled="true" iniforma="false" /> <a href="javaScript:" onclick="ayuda()"> <img src="images/help-icon.gif">
								</a>
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
							<td class="separador"></td>
						</tr>
						<tr>
							<td class="separador" colspan="5"></td>
						</tr>
						<tr>
							<td colspan="5">
								<input type="text" id="detalle" name="detalle" size="100" style="display: none;" />
								<div id="listaConcepto" style="display: none;"></div>
								<br> <br>
								<div id="listaClasificacion" style="display: none;"></div>
								<br> <br>
								<div id="listaSubClasificacion" style="display: none;"></div>
								<br> <br>
								<div id="listaPuntos" style="display: none;"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</fieldset>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
			<input type="hidden" id="estatusProducCredito" name="estatusProducCredito" />
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none; overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none;">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Configuracion Ratios</legend>
			<div>
				<p>Todos los valores de los campos a ponderar deben ser mayores a 0, Todos los Conceptos, Clasificaciones, y Sub-Clasificaciones son requeridas sin excepci&oacute;n.
			</div>
		</fieldset>
	</div>
</body>
</html>
