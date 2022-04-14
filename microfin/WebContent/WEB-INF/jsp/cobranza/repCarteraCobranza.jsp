<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="js/cobranza/repCarteraCobranza.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" >
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Cartera por Cobranza</legend>
		<table  >
				<tr>
					<td >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Par&aacute;metros</label></legend>
								<table>
								<tr>			
								<td class="label">
									<label for="fechaReporte">Fecha de Reporte: </label> 
								</td>
								<td>
									<input id="fechaReporte" name="fechaReporte"  size="15" 
					         			tabindex="1" type="text" disabled="true" readonly="true" />				
								</td>	
							</tr>
								
								</table>
						</fieldset>
					</td>      
				</tr>
				<tr>
					<td >
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="2" checked />
								<label> Excel </label>
				           		<br>
						</fieldset>
					</td>      
				</tr>
				<tr>
				<td align="right">
						<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
						<input type="hidden" id="tipoLista" name="tipoLista" />
						 		 
						 <input type="button" id="generar" name="generar" class="submit" 
											 tabIndex = "3" value="Generar" />
							
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