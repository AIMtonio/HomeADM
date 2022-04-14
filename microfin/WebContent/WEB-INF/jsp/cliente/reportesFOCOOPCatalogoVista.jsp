<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
			<script type="text/javascript" src="dwr/interface/reportesFOCOOPServicio.js"></script>						      
	    	<script type="text/javascript" src="js/cliente/reportesFOCOOP.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="FOCOOPRep">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reportes FOCOOP</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="470px">
			<tr> <td> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Parámetros</label></legend>   
			 <table  border="0"  width="300px">
					<tr>
						<td class="label">
								<label for="lbtipoReporte">Reporte:		</label>
						</td>
						<td>
								<form:select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="1">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="1">CARTERA</form:option>
							    <form:option value="2">CAPTACION</form:option>	
							    <form:option value="3">PARTES SOCIALES</form:option>
								</form:select>
							</td>													
					</tr>
					<tr>
							<td class="label">
								<label for="lbfechaReporte">Fecha de Corte:</label>
							</td>
							<td>
								<form:input id="fechaReporte" name="fechaReporte" path="fechaReporte" size="20" tabindex="2" esCalendario="true"/>
							</td>
					</tr>
				</table>
		 </fieldset>
		 </td>
				<td>
					 <table width="110px"> 
				<tr>
					<td class="label" style="position:absolute;top:14%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>			 
								<input type="radio" id="csv" name="generaCSV" value="csv">
							<label> CSV </label>	
							 <br>
							 	<input type="radio" id="excel" name="generaExcel" value="excel" />
							<label> Excel </label>	 	
					</fieldset>
					</td>      
				</tr>			 
					</table> 
				</td>
		 </tr>
		 <tr id="secTipoRepCar">
		 	<td class="separador"></td>
		 	<td>
		 		<table >
		 			<tr>
		 				<td>
		 					<fieldset class="ui-widget ui-widget-content ui-corner-all">
		 						<legend><label>Tipo Reporte</label></legend>
		 						<label>
		 							<input type="radio" id="tipoNormal" name="tipoRepCar" value="N">
		 							Normal 
		 						</label>
		 						<br>
		 						<label>
		 							<input type="radio" id="infAdicional" name="tipoRepCar" value="A"> 
		 							Inf. Adicional 
		 						</label>
		 					</fieldset>
		 				</td>
		 			</tr>
		 		</table>
		 	</td>
		 </tr>
		 </table>
		  <input type="hidden" id="empresaID" name="empresaID" path="empresaID"/>
		  	<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
		  	<input type="hidden" id="tipoLista" name="tipoLista" />
		 <table border="0" cellpadding="0" cellspacing="0" width="100%">	
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
									<a id="ligaGenerar" target="_blank" >  		 
										 <input type="button" id="genera" name="genera" class="submit" 
												 tabIndex = "3" value="Generar" />
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

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>