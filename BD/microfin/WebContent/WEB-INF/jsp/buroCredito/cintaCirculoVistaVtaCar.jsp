<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="js/buroCredito/EnvioCinCirculoVtaCar.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="EnvioCintaCirculoBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Env&iacute;o Informaci&oacute;n C&iacute;rculo de Cr&eacute;dito Cartera Vendida</legend>
					<br>
					<table  border="0"  width="470px">
						<tr>
							<td class="label">
								<label>Reporte de la Cinta para Env&iacute;o a C&iacute;rculo de Cr&eacute;dito.</label><br>
								<br>
							</td>
						</tr>
					</table>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Persona</legend>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="label">
									<input type="radio" id="personaFisica" tabindex="1" >
								</td>
								<td>
									<label for="fisica">Persona F&iacute;sica</label>
								</td>
							</tr>
							<!-- <tr>
								<td class="label">
									<input type="radio" id="personaMoralFisica" tabindex="2" >
								</td>
								<td>
									<label for="moralFisica">Persona Moral y/o Persona F&iacute;sica con Actividad Empresarial</label>
								</td>
							</tr> -->
						</table>
					</fieldset>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Reporte</legend>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="label">
									<input type="radio" id="mensual" tabindex="3" >
								</td>
								<td>
									<label for="fisica">Mensual</label>
								</td>
							</tr>
							<tr></tr>
							<tr>
								<td class="label">
									<input type="radio" id="semanal" tabindex="4" >
								</td>
								<td>
									<label for="moralFisica">Semanal (Cr&eacute;ditos Pagados Ant.)</label>
								</td>
							</tr>
						</table>
					</fieldset>
					<br>
					<table  border="0"  width="470px">
						<tr>
							<td class="label">
								<label for="fecha">Fecha : </label>
								<input id="fechaFin" name="fechaFin"  size="12" tabindex="5" type="text"  esCalendario="true" />
								<br>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="4">
								<table align="right" border='0'>
									<tr>
										<td class="label">
											<a id="ligaGenerar" href="circuloVerArchivos.htm" target="_blank" >
												<input type="button" id="enviar" name="enviar" class="submit" tabindex="6" value="Generar"   />
											</a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>