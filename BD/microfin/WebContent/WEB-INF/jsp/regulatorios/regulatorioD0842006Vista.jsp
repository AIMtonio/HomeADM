<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/opcionesMenuRegServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/regulatorioD0842Servicio.js"></script>
		
		<script type="text/javascript" src="js/regulatorios/regulatorioD0842006.js"></script>

	</head>
<body>
<div id="contenedorForma" style="
    width: 100%;
">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioD0842">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Desagregado de Pr&eacute;stamos Bancarios y Otros Organismos D-0842</legend>	
	<div id="tblRegulatorio">
	<br>
	 		<table border="0" cellpadding="0" cellspacing="0" width="">    	
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Periodo</label></legend>
								<table>
									<tbody>
										<tr>
											<td class="label" > 
										        <label for="anio">Año: </label> 
										    </td> 
										    <td>
												<select id="anio" name="anio" tabindex="1">
												</select>
											</td>	
											<td class="separador"> </td> 			
										    <td class="label" > 
										        <label for="mes">Mes: </label> 
										    </td> 					    
										   <td>
												<select id="mes" name="mes" tabindex="2">
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
									</tbody>
								</table>
							</fieldset>
						</td>	   	
						<td class="separador"> </td> 
						
						<td class="label" colspan="2">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
							<table>
								<tbody>
									<tr>
										<td><input type="radio" id="excel" checked="checked" name="tipoRep" tabindex="3"></td><td>
											<label> Excel </label>	</td>
										<td class="separador"> </td> 
										<td><input type="radio" id="csv" name="tipoRep" tabindex="4"></td><td>
											<label> CSV </label>	</td>
										<td class="separador"> </td> 										
									</tr>
								</tbody>
							</table>
						</fieldset>
						</td>
						
					</tr>

			 </table>
			
					<div id="divRegulatorioD0842" style="display: none;"></div>		
			
		</div>
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