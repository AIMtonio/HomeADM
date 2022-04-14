<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>
		<script type="text/javascript" src="js/regulatorios/repCalificacionYEstimacionesB0417.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Calificaci&oacute;n y Estimaciones (A-0417) </legend>
	<div id="tblRegulatorio">
	<table border="0" width="100%">
	<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
									<legend><label>Parámetros</label></legend>		
										<table border="0" width="100%">
											<tr>
												<td class="label" > 
											        <label for="anio">Año: </label> 
											    </td> 
											    <td>
													<select id="anio" name="anio" tabindex="1">
													</select>
												</td>
											</tr>
											<tr>	
											    <td class="label" > 
											        <label for="mes">Mes: </label> 
											    </td> 					    
											   <td>
													<select id="mes" name="mes" tabindex="2">
														<option value="0">SELECCIONAR</option>
														<option value="1">ENERO</option>
														<option value="2">FEBRERO</option>
														<option value="3">MARZO</option>
														<option value="4">ABRIL</option>
														<option value="5">MAYO</option>
														<option value="6">JUNIO</option>
														<option value="7">JULIO</option>
														<option value="8">AGOSTO</option>
														<option value="9">SEPTIEMBRE</option>
														<option value="10">OCTUBRE</option>
														<option value="11">NOVIEMBRE</option>
														<option value="12">DICIEMBRE</option>
													</select>
												</td>
											</tr>
										</table>	
								</fieldset>	
				</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Versi&oacute;n</label></legend>
					<input type="radio" id="version2014" name="version" value="2014" checked="checked" class="tipoSocap">
					<label class="tipoSocap"> Anterior Enero 2015 </label>	
					 <br class="tipoSocap">
				 	<input type="radio" id="version2015" name="version" value="2015" class="tipoSocap">
					<label class="tipoSocap"> Enero 2015 </label>
				 	<input type="radio" id="version2017" name="version" value="2017" class="tipoSofipo">
					<label class="tipoSofipo">2017</label>
			</fieldset>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="excel" name="excel" value="excel" checked="checked" tabindex="2">
					<label> Excel </label>	
					 <br>
				 	<input type="radio" id="csv" name="csv" value="csv">
					<label> Csv </label>	
			</fieldset>
			</td>
		</tr>
		<tr>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="2">
						<table align="right" border='0'>
							<tr>
								<td align="right"">
									<a id="ligaGenerar">
										<input type="button" id="generar" name="generar" class="submit"
										 tabindex="3" value="Generar" />
									</a>
								</td>	
							</tr>
						</table>		
					</td>
				</tr>					
			</table>
		</tr>
	</table>
	</div>
		<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>