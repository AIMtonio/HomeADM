<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/gruposNosolidarios.js"></script> 
	<script type="text/javascript" src="js/cliente/gruposNosolidariosReporte.js"></script>  
	    
	
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="gruposNosolidariosBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reporte de Grupos No Solidarios</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr> 
		 			<td> 
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend><label>Parámetros</label></legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label>Sucursal:</label>
								</td>
								<td>
									<input type="hidden" id="sucursalID" name="sucursalID" size="10" />
									<input type="text" id="sucursalIni" name="sucursalIni" path="sucursalIni" tabindex="1" size="10" />
									<input type="text" id="nombreSucursalIni" name="nombreSucursalIni" path="nombreSucursalIni" readOnly="true" size="50" />
								</td>
							</tr>
							
							<tr>
								<td class="label">
									<label>Grupo Inicial:</label>
								</td>
								<td>
									<input type="text" id="grupoIniID" name="grupoIniID" path="grupoIniID" tabindex="3" size="10" />
									<input type="text" id="nombreGrupoIni" name="nombreGrupoIni" path="nombreGrupoIni" readOnly="true" size="50" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Grupo Final:</label>
								</td>
								<td>
									<input type="text" id="grupoFinID" name="grupoFinID" path="grupoFinID" tabindex="4" size="10" />
									<input type="text" id="nombreGrupoFin" name="nombreGrupoFin" path="nombreGrupoFin" readOnly="true" size="50" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Promotor Inicial:</label>
								</td>
								<td>
									<input type="text" id="promotorIni" name="promotorIni" path="promotorIni" tabindex="5" size="10" />
									<input type="text" id="nombrePromotorIni" name="nombrePromotorIni" path="nombrePromotorIni" readOnly="true" size="50" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label>Promotor Final:</label>
								</td>
								<td>
									<input type="text" id="promotorFin" name="promotorFin" path="promotorFin" tabindex="6" size="10" />
									<input type="text" id="nombrePromotorFin" name="nombrePromotorFin" path="nombrenombrePromotorFinPromotorIni" readOnly="true" size="50" />
								</td>
							</tr>
							
						</table>
					</fieldset>	
				</td>
		 	</tr>
 		</table> 
		<br>
		<table width="200px">
				 <tr>
 					<td class="label" > 	
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend><label>Presentaci&oacute;n</label></legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td>
										<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="8"  checked="checked" >
										<label> PDF </label><br>
										<input type="radio" id="excel" name="excel" value="excel" tabindex="9">
										<label> Excel </label>	
									</td>
								</tr>
							</table>	
					</fieldset>
				</td>      
			</tr>			 
		</table>	
			<table align="right" border='0'>
					<tr>
						<td align="right">
								<input type="button"  id="generar" name="generar" class="submit" tabindex="10" value="Generar"  />
						</td>				
					</tr>
			</table>
	</form:form>
</div>	
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>