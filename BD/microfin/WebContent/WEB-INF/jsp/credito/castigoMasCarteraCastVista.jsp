<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%!int	consecutivoID	= 01;%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="js/credito/castivoMasCarteraCast.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Castigos Masivos</legend>
				<table style="width: 100%">
					<tr>
						<td class="label"><label for="fechaCondona">Fecha de Castigo:</label></td>
						<td><input type="text" value="" size="12" name="fechaCastigo" id="fechaCastigo" disabled="disabled"/></td>
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
	<div id="ContenedorAyuda" style="display:none; width :600px; overflow:scroll;">
		<div id="ContenedorAyuda" style="padding: 20px">
			<legend class="ui-widget ui-widget-header ui-corner-all">Archivo de Carga de Castigo Masivo:</legend>
			<table id="tablaLista">
				<tbody>
					<tr>
						<td id="contenidoAyuda" align="justify"><b>El siguiente formato corresponde a la estructura del archivo en excel a cargar en el Proceso de Castigo Masivo de Cartera.</b></td>
					</tr>
					<tr>			
						<td>
						<center>
							<table style="background-color: white; border: 1px solid black;">
								<tr>
									<td style=" border-bottom: 1px solid #ddd;"><b>Nombre</b></td>
									<td style=" border-bottom: 1px solid #ddd;"><b>Descripci&oacute;n</b></td>
									<td style=" border-bottom: 1px solid #ddd;"><b>Tipo de dato</b></td>
									<td style=" border-bottom: 1px solid #ddd;"><b>Longitud M&aacute;xima</b></td>
								</tr>
								<tr>
									<td><b>CreditoID</b></td>
									<td align="justify">Corresponde al N&uacute;mero de Cr&eacute;dito asignado en SAFI.</td>
									<td>N&uacute;mero</td>
									<td>12</td>
								</tr>
								<tr>
									<td><b>MotivoCastigo</b></td>
									<td align="justify">Se ingresa el MotivoID de castigo. <br>
									</td>
									<td>N&uacute;mero</td>
									<td>11</td>
								</tr>
								<tr>
									<td></td>
									<td colspan="3">
										<table style="font-size: 12px; text-align: justify;">
											<tr>
												<td style=" border-bottom: 1px solid #ddd;"><b>MotivoID</b></td>
												<td style=" border-bottom: 1px solid #ddd;"><b>Descripci&oacute;n</b></td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">1</td>
												<td style=" border-bottom: 1px solid #ddd;">Sin bienes embargables</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">2</td>
												<td style=" border-bottom: 1px solid #ddd;">Desapareci&oacute; sin dejar bienes</td>
											</tr>
											<tr>
												<td  style=" border-bottom: 1px solid #ddd;">3</td>
												<td style=" border-bottom: 1px solid #ddd;">Quiebra</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">4</td>
												<td style=" border-bottom: 1px solid #ddd;">M&aacute;s de 365 d&iacute;as de Mora</td>
											</tr>
											<tr>
												<td  style=" border-bottom: 1px solid #ddd;">5</td>
												<td  style=" border-bottom: 1px solid #ddd;">Otro</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">6</td>
												<td style=" border-bottom: 1px solid #ddd;">Fallecimiento del cliente</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td><b>CobranzaRealizada</b></td>
									<td align="justify">Se ingresa el tipo de CobranzaID realizada sobre el Cr&eacute;dito.</td>
									<td>N&uacute;mero</td>
									<td>11</td>
								</tr>
								<tr>
									<td></td>
									<td colspan="3">
										<table style="font-size: 12px; text-align: justify;">
											<tr>
												<td style=" border-bottom: 1px solid #ddd;"><b>CobranzaID</b></td>
												<td style=" border-bottom: 1px solid #ddd;"><b>Descripci&oacute;n</b></td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">1</td>
												<td style=" border-bottom: 1px solid #ddd;">Ninguna por declararse inmaterial</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">2</td>
												<td style=" border-bottom: 1px solid #ddd;">Ninguna por declararse incobrable</td>
											</tr>
											<tr>
												<td  style=" border-bottom: 1px solid #ddd;">3</td>
												<td style=" border-bottom: 1px solid #ddd;">Extrajudicial propia</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">4</td>
												<td style=" border-bottom: 1px solid #ddd;">Extrajudicial a cargo de terceros</td>
											</tr>
											<tr>
												<td  style=" border-bottom: 1px solid #ddd;">5</td>
												<td  style=" border-bottom: 1px solid #ddd;">Judicial propia</td>
											</tr>
											<tr>
												<td style=" border-bottom: 1px solid #ddd;">6</td>
												<td style=" border-bottom: 1px solid #ddd;">Judicial a cargo de terceros</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td><b>Observaciones</b></td>
									<td align="justify">Apartado para observaciones.</td>
									<td>Cadena</td>
									<td>500</td>
								</tr>
							</table>
							</center>
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
							<td id="encabezadoAyuda"><b>MotivoCastigo</b></td>
							<td id="encabezadoAyuda"><b>CobranzaRealizada</b></td>
							<td id="encabezadoAyuda"><b>Observaciones</b></td>
						</tr>
						<tr>
							<td colspan="0" id="contenidoAyuda"><b>700638518</b></td>
							<td colspan="0" id="contenidoAyuda" style="white-space: nowrap"><b>1</b></td>
							<td colspan="0" id="contenidoAyuda"><b>1</b></td>
							<td colspan="0" id="contenidoAyuda"><b>CASTIGO MASIVO.</b></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
</body>
</html>