<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%!int	consecutivoID	= 01;%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
<script type="text/javascript" src="js/credito/condonaMasCarteraCast.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Condonaci&oacute;n Masiva</legend>
				<table style="width: 100%">
					<tr>
						<td class="label"><label for="fechaCondona">Fecha de Condonaci&oacute;n:</label></td>
						<td><input type="text" value="" size="12" name="fechaCondona" id="fechaCondona" disabled="disabled"/></td>
					</tr>
					<tr>
						<td class="label"><label for="rutaArchivoFinal">Nombre del Archivo:</label></td>
						<td><input type="text" value="" size="25" name="rutaArchivoFinal" id="rutaArchivoFinal" disabled="disabled" readonly="readonly" /></td>
						<td>
							<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar"  tabindex="<%=consecutivoID++%>" />
							<a href="javaScript:" onclick="ayuda()"> <img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: right;">
							<input id="procesar" type="submit" class="submit" value="Procesar" tabindex="<%=consecutivoID++%>" />
							<input id="tipoTransaccion" name="tipoTransaccion" type="hidden" value="" />
							<input id="tipoActualizacion" name="tipoActualizacion" type="hidden" value="" />
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
	<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none; width :600px">
		<div id="ContenedorAyuda" style="padding: 20px">
			<legend class="ui-widget ui-widget-header ui-corner-all">Archivo de Carga de Condonaci&oacute;n Masiva:</legend>
			<table id="tablaLista">
				<tbody>
					<tr>
						<td id="contenidoAyuda" align="justify"><b>El siguiente formato corresponde a la estructura del archivo en excel a cargar en el Proceso Masivo de Condonaci&oacute;n de Cartera.</b></td>
					</tr>
					<tr>
						<td>
							<table >
								<tr>
									<td><b>Nombre</b></td>
									<td><b>Descripci&oacute;n</b></td>
									<td><b>Tipo de dato</b></td>
									<td><b>Longitud M&aacute;xima</b></td>
								</tr>
								<tr>
									<td>CreditoID</td>
									<td align="justify">Corresponde al N&uacute;mero de Cr&eacute;dito asignado en SAFI.</td>
									<td>N&uacute;mero</td>
									<td>12</td>
								</tr>
								<tr>
									<td>MontoCapital</td>
									<td align="justify">Corresponde al Monto de Capital a condonar.</td>
									<td>Decimal<br>(Sin formato moneda)</td>
									<td>(18,2)</td>
								</tr>
								<tr>
									<td>MontoInteres</td>
									<td align="justify">Corresponde al Monto de Inter&eacute;s a condonar.</td>
									<td>Decimal<br>(Sin formato moneda)</td>
									<td>(18,2)</td>
								</tr>
								<tr>
									<td>MontoInteresMoratorio</td>
									<td align="justify">Corresponde al Monto de Inter&eacute;s Moratorio a condonar.</td>
									<td>Decimal<br>(Sin formato moneda)</td>
									<td>(18,2)</td>
								</tr>
								<tr>
									<td>Comisiones</td>
									<td align="justify">Corresponde al Monto de las Comisiones a condonar.</td>
									<td>Decimal (Sin formato moneda)</td>
									<td>(18,2)</td>
								</tr>
								<tr>
									<td>MotivoCondonacion</td>
									<td align="justify">Descripci&oacute;n corta del Motivo de condonaci&oacute;n.</td>
									<td>Cadena</td>
									<td>500</td>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
			<br>
			<div id="ContenedorAyuda">
				<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo del Formato del Archivo formato Excel (xls)</legend>
				<table border="1" id="tablaLista" width="100%">
					<tbody>
						<tr>
							<td id="encabezadoAyuda"><b>CreditoID</b></td>
							<td id="encabezadoAyuda"><b>MontoCapital</b></td>
							<td id="encabezadoAyuda"><b>MontoInteres</b></td>
							<td id="encabezadoAyuda"><b>MontoInteresMoratorio</b></td>
							<td id="encabezadoAyuda"><b>Comisiones</b></td>
							<td id="encabezadoAyuda"><b>MotivoCondonacion</b></td>
						</tr>
						<tr>
							<td colspan="0" id="contenidoAyuda"><b>700638518</b></td>
							<td colspan="0" id="contenidoAyuda" style="white-space: nowrap"><b>14569.00</b></td>
							<td colspan="0" id="contenidoAyuda"><b>560.65</b></td>
							<td colspan="0" id="contenidoAyuda"><b>0</b></td>
							<td colspan="0" id="contenidoAyuda"><b>0</b></td>
							<td colspan="0" id="contenidoAyuda"><b>RECUPERACION DE CARTERA CRED.</b></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
</body>
</html>