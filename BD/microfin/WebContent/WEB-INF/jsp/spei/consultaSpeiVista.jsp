<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>

<script type="text/javascript"
	src="dwr/interface/consultaSpeiServicio.js"></script>
<script type="text/javascript" src="js/spei/consultaSpei.js"></script>


</head>
<body>
	<div id="contenedorForma">

		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="consultaSpeiBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Consulta
					SPEI</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr style="text-align: right;">
						<td class="label"><label for="lblFecha">Fecha: </label> <form:input
								type="text" id="fecha" name="fecha" path="fecha" size="12"
								tabindex="1" iniForma="false" disabled="true" readonly="true" />
						</td>
					</tr>
				</table>
				<form:form id="formaGenerica2" name="formaGenerica2" method="POST"
					commandName="consultaSpeiBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Env&iacute;o
							SPEI</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td><input type="hidden" id="datosGrid" name="datosGrid"
									size="100" />
									<div id="gridConsultaSPEI" display:none; "></div></td>
							</tr>
						</table>
					</fieldset>
				</form:form>
				<br>
			
				<form:form id="formaGenerica3" name="formaGenerica3" method="POST"
					commandName="consultaSpeiBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Recepciones
							SPEI</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td><input type="hidden" id="datosGrid" name="datosGrid"
									size="100" />
									<div id="gridConsultaRecepSPEI" display:none; "></div></td>
							</tr>
							<tr>
								<td class="separador"></td>
							</tr>
						</table>
					</fieldset>
				</form:form>
				<br>
				
				<form:form id="formaGenerica4" name="formaGenerica4" method="POST"
					commandName="consultaSpeiBean">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Saldo
							SPEI</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td><input type="hidden" id="datosGrid" name="datosGrid"
									size="100" />
									<div id="gridConsultaSaldoSPEI" display:none; "></div></td>
							</tr>
						</table>
					</fieldset>
				</form:form>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right">

								<tr>
									<td align="right">
										<!-- 									<input type="submit" id="consultar" name="consultar" class="submit" value="Consultar" /> -->
										<input type="hidden" id="tipoTransaccion"
										name="tipoTransaccion" /> <input type="hidden"
										id="tipoActualizacion" name="tipoActualizacion" />

									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" />
	</div>
</body>
<div id="mensaje" style="display: none;" />
</html>
