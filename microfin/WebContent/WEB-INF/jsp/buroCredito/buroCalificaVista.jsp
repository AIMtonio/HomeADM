<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/buroCalificaServicio.js"></script>
	<script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/general.js"></script>
	<script type="text/javascript" src="js/buroCredito/buroCalifica.js"></script>
</head>
<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="buroCalificaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Bur&oacute; Califica</legend>
		<table width="100%">
			<td  style="display: block;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
					<table >
						<tr>
							<td class="label">
								<label for="tipoCartera">Tipo de Cartera:</label>
							</td>
							<td>
								<form:select id="tipoCartera" name="tipoCartera" path="tipoCartera" tabindex="1">
									<form:option value="">TODOS</form:option>
									<form:option value="A">CARTERA AGRO</form:option>
									<form:option value="M">CARTERA MICRO</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="rangoCartera">Rango de Cartera: </label>
							</td>
							<td class="label">
								<form:radiobutton id="totalCartera" name="rangoCartera" path="rangoCartera" value="T" tabindex="2"/>
								<label for="totalCartera">Total de la Cartera: </label>
								<form:radiobutton id="creditosNacPeriodo" name="rangoCartera" path="rangoCartera" value="P" tabindex="3"/>
								<label for="creditosNacPeriodo">Cr&eacute;ditos Nacidos en el periodo: </label>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="periodo">Periodo: </label>
							</td>
							<td>
								<form:input id="periodo"  name="periodo" path="periodo"  size="20" tabindex="4" esCalendario="true" maxlength="10"/>
							</td>	
						</tr>
						<tr>
							<td class="label">
								<label for="estatusCredito">Estatus del Cr&eacute;dito:</label>
							</td>
							<td>
								<form:select id="estatusCredito" name="estatusCredito" path="estatusCredito" tabindex="5">
									<form:option value="">TODOS</form:option>	
									<form:option value="V">VIGENTE</form:option>
									<form:option value="A">ATRASADO</form:option>
									<form:option value="B">VENCIDO</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="tipoReporte">Tipo de Reporte:</label>
							</td>
							<td>
								<form:select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="6">
									<form:option value="1">FIRA</form:option>
								</form:select>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="6">
								<table align="right">
									<tr>
										<td align="right">
											<button type="submit" class="submit" id="generar" tabindex="7">Generar</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</table>
	</fieldset>
	</form:form>
	</div>
</body>
</html>