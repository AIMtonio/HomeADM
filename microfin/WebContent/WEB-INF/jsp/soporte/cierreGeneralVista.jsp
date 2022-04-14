<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/generalServicio.js"></script>
<script type="text/javascript" src="js/soporte/cierreGeneral.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Cierre General de la Aplicaci&oacute;n</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario" target="_blank">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<label>Fecha Actual:</label>
						<td>
							<form:input id="fechaBloqueo" name="fechaBloqueo" path="fechaBloqueo" size="12" tabindex="1" readOnly="true" disabled="true" />
						</td>
						<td colspan="9"></td>
					</tr>
					<tr>
						<table id="descrip proceso Batch">
							<tr>
								<td class="label">
									<DIV class="label">
										<label> <br> Este proceso realiza el Cierre de Día General de la Aplicaci&oacute;n, se realizar&aacute;n las siguientes acciones: <br> Cierre Diario de Inversiones <br> Cierre Diario de Ahorro <br> Cierre Diario de Cartera <br> Cierre Mensual (Si Aplica) <br> <br> Al finalizar el proceso, favor de revisar el reporte de la bit&aacute;cora de los procesos Batch. <br>
										</label>
									</DIV>
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
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="2" />
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