<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicios.js"></script>
	<script type="text/javascript" src="js/ventanilla/usuarioServicioRep.js"></script>


</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repProgVentanillasCreditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Usuario de Servicios</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table border="0">

									<tr>
										<td class="label"><label for="lblfechaIni">Usuario: </label></td>
										<td>
											<input id="usuarioID" name="usuarioID"  size="12" value="0" tabindex="1" maxlength="11"/> 
											<input type="text" id="desUsuarioID" name="desUsuarioID"  size="50" value="TODOS"  />
										</td>
									</tr>
									<tr>
										<td class="label"><label for="lblsucursalID">Sucursal: </label></td>
										<td>
											<input type="text"  id="sucursalID" name="sucursalID"  size="12" value="0" tabindex="2"  /> 
											<input type="text" id="desSucursal" name="desSucursal"  size="50" value="TODAS"  />
										</td>
									</tr>	
									<tr>
										<td class="label"><label for="lblcajaID">G&eacute;nero: </label></td>
										<td>
												<select id="sexo" name="sexo"   tabindex="3">
													<option value="">TODOS</option>
													<option value="F">FEMENINO</option>
											     	<option value="M">MASCULINO</option>
											</select>	</td>
									</tr>				
								</table>
							</fieldset>
										</td>
									</tr>		
								</table>
							
						</td>
					</tr>
					<tr>
						<td>
							<table width="120px">
								<tr>
									<td class="label" >
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="4"/>
												<label> PDF </label>
												<br>
												<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="5"> 
												<label>Excel </label>
											</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="right">
								<input type="button" id="generar" name="generar" class="submit" tabIndex="6" value="Generar" />
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
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