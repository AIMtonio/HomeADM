<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<!-- se cargar los servicios para accesar por dwr -->
	 <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
 
	<!-- se cargan las funciones o recursos js -->
	<script type="text/javascript" src="js/fira/rompimientoGrupo.js"></script> 
</head>
	<body>
	
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST"  commandName="rompimientoGrupoBean">
	
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Rompimiento de Grupo</legend>
							
						<table width="100%">
							<tr>
								<td class="label">
									<label for="grupoID">Grupo:</label>
								</td>
								<td>
									<form:input type='text' id="grupoID" name="grupoID" path="grupoID" size="15" tabindex="1" autocomplete="off"/>
									<input type='text' id="nombreGrupo" name="nombreGrupo" size="60" readonly="true"/>
								</td>
								<td class="separador"></td>
								<td nowrap class="label">
									<label for="grupoID">Ciclo Actual:</label>
								</td>
								<td>
									<form:input type='text' id="cicloActual" name="cicloActual" path="cicloActual" size="15" tabindex="2" readonly="true" />
								</td>
							<tr>
							<tr>
								<td class="label">
									<label for="producCreditoID">Producto Cr&eacute;dito:</label>
								</td>
								<td>
									<form:input type='text' id="producCreditoID" name="producCreditoID" path="producCreditoID" size="15" tabindex="3" readonly="true" />
									<input type='text' id="producCreditoIDDes" name="producCreditoIDDes" size="60" readonly="true"/>
								</td>
								<td class="separador"></td>
								<td nowrap class="label">
									<label for="estatusCiclo">Estatus Grupo:</label>
								</td>
								<td>
									<form:input type='text' id="estatusCiclo" name="estatusCiclo" path="estatusCiclo" size="15" tabindex="4" readonly="true" />
								</td>
							<tr>
							<tr>
								<td class="label">
									<label for="nombreSucursal">Sucursal:</label>
								</td>
								<td>
									<form:input type='text' id="nombreSucursal" name="nombreSucursal" path="nombreSucursal" size="40" tabindex="5" readonly="true" />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="separador"></td>
							<tr>
						</table>

						
						<div id="divIntegrantes"></div>		 
						
						
						<table width="100%">
								<tr id="trMotivo">
									<td class="label">
										<label for="nombreSucursal">Motivo:</label>
									</td>								
									<td>
										<form:textarea id="motivo" name="motivo" path="motivo" COLS="48" ROWS="3" tabindex="32" maxlength="500"  onBlur="ponerMayusculas(this);" /> 								
									</td>
								</tr> 
								<tr>
									<td align="right" colspan="5">
										<input type="submit" id="procesar" class="submit" value="Procesar" tabindex="100"/>
										<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID" />  	
										<input type="hidden" id="usuarioID" name="usuarioID" />  	
										<input type="hidden" id="sucursalID" name="sucursalID" />  	
									 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />  	
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