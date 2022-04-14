<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
	   	<script type="text/javascript" src="js/tarjetas/tarDebConciliaTarjeta.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Conciliaci&oacute;n de Movimientos de Tarjeta</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarDebConciliaMovs">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table border="0" width="100%" align="right">
							<tr>
								<td>
									<div id="contenedorMovs" style="display: none;"></div>
									<br>
								</td>
							</tr>
						</table>
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
							<tr>
								<td align="right">
									<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"  tabindex="4"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/> 
								</td>
							</tr>
						</table>
					</fieldset>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
</html>