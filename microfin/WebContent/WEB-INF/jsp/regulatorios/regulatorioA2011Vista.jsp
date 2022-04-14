	<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
	<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	<%@page contentType="text/html"%> 
	<%@page pageEncoding="UTF-8"%>
	<html>	
		<head>
			<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
			<script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/divisasServicio.js"></script> 
		   <script type="text/javascript" src="js/regulatorios/regulatorioA2011.js"></script>	      
		</head>
		<body>
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatoriosCarteraBean"> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Coeficiente de Liquidez (A-2011)</legend> 
					<div id="tblRegulatorio">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
						<tr>	   	
							<td class="label" > 
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
									<legend ><label>Versi&oacute;n</label></legend>

									<input type="radio" id="version2014" name="version" value="2014" checked="checked" class="socap">
									<label class="socap"> Anterior Enero 2015 </label>	
									 <br class="socap">
								 	<input type="radio" id="version2015" name="version" value="2015" class="socap">
									<label class="socap"> Enero 2015 </label>
									<br class="socap">
									<input type="radio" id="version2017" name="version" value="2017" class="sofipo">
									<label class="sofipo"> 2017</label >
							</fieldset>
							</td>
						</tr>						
						<tr>
							<td class="label" colspan="2">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="excel" checked="checked" tabindex="3">
									<label> Excel </label>	
									<br>
									<input type="radio" id="csv" tabindex="4">
									<label> Csv </label>	
							</fieldset>
							</td>
							
						</tr>
						<tr>
							<td colspan="5" align="right">	
								<input type="button" class="submit" id="generar" value="Generar" tabindex="5" /> 		
							</td>
						</tr> 
					</table>
					</div>
					</fieldset>      
				</form:form>
			</div>
			<div id="cargando" style="display: none;"></div>
		</body>
		<div id="mensaje" style="display: none;"></div>
	</html>
