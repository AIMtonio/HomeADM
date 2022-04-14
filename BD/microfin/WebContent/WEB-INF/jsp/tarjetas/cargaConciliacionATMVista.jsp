<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript"	src="js/tarjetas/cargaConciliaATM.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaConciliaATMBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Carga de Archivo de Conciliacion de Transacciones ATM</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><br></td>
						</tr>
						<tr>
							<td>
								<label for="ruta">Ruta Archivo:</label>
							</td>
							<td>
								<input id="ruta" name="ruta" path="ruta" size="80" readonly="true" />
								<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="3" />
							</td>
						</tr>
					</table>
					<table width="100%">
						<tr>	
							<td align="right">
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"  tabindex="6"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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