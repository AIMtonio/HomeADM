<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catalogoRemesasServicio.js"></script>
		<script type="text/javascript" src="js/pld/reporteOpeRemesas.js"></script>		
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"
				commandName="reporteOpeRemesasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Operaciones con Remesas</legend>
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
									<label for="lblremesaCatalogoID">Entidad TD O TDE:</label>
								</td>
								<td>
									<form:input type="text" id="remesaCatalogoID" name="entidadTDE" path="entidadTDE" size="19" tabindex="3" />
									
								</td>															
								<td>
									<form:input  type="text" id="nombre" name="nombreEntidad" path="nombreEntidad" size="40" readonly="true"/>								
								</td>
							</tr>	
							<tr>
								<td class="label" >
									<label for="tipoOperacion">Tipo Operación:</label>
								</td>
								<td >
								<select id="tipoOperacion" name="tipoOperacion"  tabindex="4" style="width:132px;">
									<option value='0' >TODOS</option>
									<option value='1' >EFECTIVO</option>
									<option value='2' >SPEI</option>
									<option value='3' >ABONO A CTA.</option>
								</select>
								</td>																					 
							</tr>	
							<tr>
								<td class="label" >
									<label for="estatus">Estatus:</label>
								</td>
								<td >
								<select id="estatus" name="estatus"  tabindex="5" style="width:132px;">
									<option value='0' >TODOS</option>
									<option value='1' >REGISTRADOS</option>
									<option value='2' >EN REVISIÓN</option>
									<option value='3' >RECHAZADOS</option>
									<option value='4' >PAGADOS</option>
								</select>
								</td>																					 
							</tr>
							<tr>
								<td class="label" >
									<label for="umbral">Umbral:</label>
								</td>
								<td >
								<select id="umbral" name="umbral"  tabindex="6" style="width:132px;">
									<option value='0' >TODOS</option>
									<option value='1' >< 1000</option>
									<option value='2' >< 3000</option>
									<option value='3' >< 5000</option>								
								</select>
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