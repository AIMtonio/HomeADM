<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript" src="js/ventanilla/reporteRemitentesUsuario.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"
				commandName="reporteRemitentesUsuarioBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Remitentes por Usuario</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Par&aacute;metros</legend>
						<table>									
							<tr>
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
							</tr>
							<tr>
								<td class="label">
									<label for="usuario">Usuario:</label>
								</td>
								<td>
									<form:input type="text" id="usuarioID" name="usuario" path="usuario" size="19" tabindex="3" value="0"/>	
								</td>															
								<td>
									<form:input  type="text" id="nombreCompleto" name="descripcion" path="descripcion" size="40" readonly="true"/>								
								</td>
							</tr>																	
					 	</table>						
					</fieldset>						
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