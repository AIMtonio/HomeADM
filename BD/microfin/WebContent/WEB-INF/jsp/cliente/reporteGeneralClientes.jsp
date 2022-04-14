<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>

<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>

<script type="text/javascript"
	src="dwr/interface/parametrosSisServicio.js"></script>

<script type="text/javascript" src="js/cliente/reporteGeneralClientes.js"></script>
</head>
<body>

	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="clienteGeneralBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				
				<legend class="ui-widget ui-widget-header ui-corner-all">
					Reporte de Clientes
				</legend>
				
				<table border="0" cellpadding="0" cellspacing="0" width="600px">
					<tr> 
						<td> 
							<fieldset class="ui-widget ui-widget-content ui-corner-all">        				
				
								<legend>
									<label>Parámetros</label>
								</legend>
								
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
								
									<tr>
										<td class="label">
											<label for="sucursal">Sucursal: </label>
										</td>
										<td>
											<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="1">
												<form:option value="0">TODAS</form:option>
											</form:select>
										</td>
										<td class="separador"></td>
									</tr>
									
									<tr>
										<td class="label" nowrap="nowrap">
											<label>Estatus: </label>
										</td>
										<td>
											<form:select id="estatus" name="estatus" path="estatus" tabindex="2">
												<form:option value="">TODOS</form:option>
												<form:option value="A">ACTIVO</form:option>
												<form:option value="I">INACTIVO</form:option>
											</form:select>
										</td>
										<td class="separador"></td>
									</tr>
				
								</table>
								
							</fieldset>
						</td>
					</tr>
				</table>
				
				
				<table align="right">
					<tr>
						<td align="right">
					
						<a id="ligaGenerar" href="repGeneralClientes.htm" target="_blank" >  		 
							 <input type="button" id="generar" name="generar" class="submit" 
									 tabIndex = "3" value="Generar" />
						</a>
						
						</td>
					</tr>
				</table>	
				
			</fieldset>
		</form:form>

	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista" /></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>