<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramRegulatoriosServicio.js"></script>
	 	<script type="text/javascript" src="js/regulatorios/regulatorioA1311.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioA1311Bean"> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Regulatorio A-1311  Estado de variaciones en el capital contable.</legend> 
				<div id="tblRegulatorio">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">    	
						<tr>	   	
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">		
									<legend><label>Parámetros</label></legend>		
									<table border="0" width="100%">
										<tr>	
										    <td class="label" > 
										        <label for="mes">Fecha Inicio: </label> 
										    </td>
										 	<td>
												<input type="text" name="mesActual" id="mesActual" path="mesActual"	size="9" tabindex="1" />
											</td>
										</tr>
										<tr>	
										    <td class="label" > 
										        <label for="mes">Fecha Final: </label> 
										    </td>
										   <td>
												<input type="text" name="mesAnterior" id="mesAnterior" path="mesAnterior"  size="9" tabindex="2" />
											</td>
										</tr>
									</table>	
								</fieldset>		
								
								<table  align="left">
									<tr>
										<td>
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
								</table>	
								<br>
								<br>

								<table align="right">
									<tr>
										<td colspan="1" align="right">	
												<input type="button" class="submit" id="generar" value="Generar" tabindex="5" /> 		
										</td>
									</tr>
								</table>  
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