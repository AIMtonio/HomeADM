<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript" src="js/ventanilla/reporteCoincidenciasRemesas.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"
				commandName="reporteCoincidenciasRemesasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Coincidencias Usuario de Servicio</legend>					
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr> 
							<td> 
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>Par&aacute;metros</legend>
									<table width="100%">												
										<tr>
											<td class="label" >
												<label for="fechaInicial">Fecha Inicial:</label>
											</td>
											<td>					
												<input type="text" id="fechaInicial" name="fechaInicial" size="16" esCalendario="true" tabindex="1" />	
											</td>				
										</tr>
										<tr>
											<td class="label">
												<label for="fechaFinal">Fecha Final:</label>
											</td>
											<td>
												<input type="text" id="fechaFinal" name="fechaFinal" size="16" esCalendario="true" tabindex="2" />	
											</td>								
										</tr>
										<tr>
											<td class="label" >
												<label for="mostrar">Tipo Coincidencia:</label>
											</td>
											<td >
											<select id="tipoCoincidencia" name="tipoCoincidencia"  tabindex="3" style="width:132px;">
												<option value='0' >TODOS</option>
												<option value='1' >RFC</option>
												<option value='2' >CURP</option>
											</select>
											</td>																					 
										</tr>
									 </table>								
								</fieldset>
							</td>
							
						</tr>
					</table>
					
					<table width="100px"> 
						<tr>
							<td class="label" style="position:relative;align-items:center;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>
										<label>Presentaci&oacute;n</label>
									</legend>
										<input type="radio" id="excel" name="excel" value="excel"> <label> Excel </label>
								</fieldset>
							</td>
						</tr>
					</table>
					
					<br>
					<table align="right">
						<tr>
							<td align="right">			
								<button type="button" class="submit" id="generar" tabindex="4">
									Generar
								</button>
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
</html>