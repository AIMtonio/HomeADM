<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/aperturaInvBancaria.js"></script>
		<title>Apertura de Inversiones Bancarias</title>
	</head>
	<body>
 		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Apertura de Inversiones Bancarias</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="invBancariaBean">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table>
								<tr>
									<td><label>Institución:</label></td>
									<td><form:input type="text" name="institucionID" id="institucionID" size="4" tabindex="2" autocomplete="off" path="institucionID" />
										<input type="text" name="nombreInstitucion" id="nombreInstitucion" size="50" readOnly="true" disabled = "true" />
									</td>
								</tr>
								<tr>
									<td><label>Cuenta Bancaria:</label></td>
									<td>
										<form:input id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="30"  tabIndex="3" autocomplete="off" />
									</td>
								</tr>
								<tr>
									<td><label>Fecha Inicio:</label></td>
									<td>
										<form:input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" tabIndex="4" size="10" esCalendario="true" />
									</td>
								</tr>
								<tr>
									<td><label>Fecha Fin:</label></td>
									<td >
										<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" tabIndex="4" size="10" esCalendario="true" />
									</td>
								</tr>				
								<tr>
									<td><label>Presentación</label></td>
									<td class="label">
										<input type="radio" id="presenta" name="presenta" value="1" checked="checked"/><label>PDF</label>
										<input type="radio" id="presenta" name="presenta" value="2"/><label>Excel</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<a id="ligaPDF" href="RepAperturaInvBancaria.htm" target="_blank" >
				  							<button type="button" class="submit" id="generar" style="">Generar</button> 
				 						</a>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										<input type="hidden" id="tipoReporte" name="tipoReporte"/>
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
		<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
	</body>
</html>