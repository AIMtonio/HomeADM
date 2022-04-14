<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
<script type="text/javascript" src="js/credito/cobranzaAutomaticaRefere.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Cobranza Autom&aacute;tica por Referencia</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario" target="_blank">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<label>Fecha Actual:</label>
						<td>
							<form:input id="fecha" name="fecha" path="fecha" size="12" tabindex="1" readOnly="true" disabled="true" />
						</td>
						<td colspan="9"></td>
					</tr>
					<tr>
						<table>
							<tr>
								<td class="label">
									<div class="label">
										<label> <br> Este proceso realiza la Cobranza Autom&aacute;tica de Cartera por Referencia.
										</label>
									</div>
								</td>
							</tr>
						</table>
					</tr>
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr align="right">
									<td width="350px">&nbsp;</td>
									<td align="right">
										<a target="_blank"> <input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="2" />
										</a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>