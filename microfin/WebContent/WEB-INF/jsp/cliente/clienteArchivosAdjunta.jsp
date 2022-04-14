<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
<script type="text/javascript" src="js/cliente/clienteArchivosAdjunta.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form method="post" id="formaGenerica" name="formaGenerica" action="/microfin/clientesFileUpload.htm" enctype="multipart/form-data">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">
					Digitalizaci&oacute;n de Documentos del <s:message code="safilocale.cliente" />
				</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label">
							<label for="lblCliente"><s:message code="safilocale.cliente" />:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="clienteID" name="clienteID" size="13" tabindex="1" iniforma="false" /> <input type="text" id="nombreCliente" name="nombreCliente" size="40" tabindex="2" disabled="true" readOnly="true" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="lblProspecto">Prospecto:</label>
						</td>
						<td nowrap="nowrap">
							<input type="text" id="prospectoID" name="prospectoID" size="13" tabindex="3" iniforma="false" /> <input type="text" id="nombreProspecto" name="nombreProspecto" size="40" tabindex="4" disabled="true" readOnly="true" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tipoDocumento">Tipo de Documento:</label>
						</td>
						<td nowrap="nowrap">
							<select id="tipoDocumento" name="tipoDocumento" tabindex="5">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="separador"></td>
						<td class="separador"></td>
					</tr>
				</table>
				<br>
				<div id="gridArchivosCliente" style="display: none;"></div>
				<table align="right">
					<tr>
						<td class="label">
							<input type="button" id="enviar" name="enviar" class="submit" tabindex="7" value="Adjuntar" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						</td>
						<td>
							<a id="ligaGenerar" href="" target="_blank"> <input type="button" class="submit" id="pdf" tabindex="8" value="Expediente" />
							</a>
						</td>
					</tr>
					<tr>
						<td>
							<div id="imagenCte" style="overflow: scroll; width: 950px; height: 500px; display: none;">
								<img id="imgCliente" src="images/user.jpg" border="0" />
							</div>
						</td>
					</tr>
				</table>
			</fieldset>
		</form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>