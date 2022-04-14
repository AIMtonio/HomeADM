<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramsCalificaServicio.js"></script> 
		<script type="text/javascript" src="js/credito/califRango.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Calificaci&oacute;n por Rango de Reserva</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="calPorRangoBean">			
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label">
								<label for="tipoInstitucion">Tipo Instituci&oacute;n:</label>
							</td>
							<td>
								<form:select id="tipoInstitucion" name="tipoInstitucion" path="tipoInstitucion" readonly="true">
									<form:option value="">Selecciona</form:option>
									<form:option value="R1">R1</form:option>
									<form:option value="R2">R2</form:option>
									<form:option value="N">N</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblTipoRango">Clasificaci&oacute;n:</label>
							</td>
							<td class="label">
								<label>Comercial</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="C"/>
								<label>Com. Microcrédito</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="M"/>
								<label>Consumo</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="O"/>
								<label>Vivienda</label><input type="radio" id="clasificacion" name="clasificacion" path="clasificacion" value="H"/>									
							</td>
						</tr>					
						<tr>
							<td>
								<form:input type="hidden" id="tipo" name="tipo" path="tipo"/>
							</td>
						</tr>	
						<tr>	
							<td colspan="2">
								<div id="gridCalifRango" style="display: none;"/>							
							</td>						
						</tr>										
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="4"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>	
					<input type="hidden" size="500" name="limInferiores" id="limInferiores"/>
					<input type="hidden" size="500" name="limSuperiores" id="limSuperiores"/>
					<input type="hidden" size="500" name="lisCalifica" id="lisCalifica"/>
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