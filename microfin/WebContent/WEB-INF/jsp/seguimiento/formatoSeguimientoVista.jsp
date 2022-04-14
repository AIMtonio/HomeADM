<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="js/seguimiento/formatoSeguimiento.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="formatoSeguimientoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Formularios de Seguimiento de Campo</legend>			
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr> <td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
         		 <table  border="0"  width="560px">
                 	<tr>
                 	<tr>
	 					<td class="label" nowrap="nowrap">
							<label for="lblsegtoProgra">Fecha Inicio: </label>
						</td>
						<td colspan="">
							<input type="text" id="fechaInicio" name="fechaInicio"  tabindex="" size="12" esCalendario="true" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblcreditoID">Fecha Fin: </label>
						</td>
						<td colspan="">
						    <input type="text" id="fechaFin" name="fechaFin"  tabindex="" size="12" esCalendario="true" />
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblCategoria">Categor&iacute;a: </label>
						</td>
						<td colspan="4">
							<select id="categoriaID" name="categoriaID" ></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblSucursal">Sucursal:</label>
						</td>
						<td>
							<select id="sucursalID" name="sucursalID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblGestor">Gestor:</label>
						</td>
						<td>
							<select id="gestorID" name="gestorID"></select>
						</td>
					</tr>
				</table>
			 </fieldset>  
			</td>  </tr> 
			</table>
				<table align="right" border='0'>
					<tr>
						<td>
							<a id="ligaGenerar" href="formatoSeguimientoRep.htm" target="_blank" >
								<input type="button" id="generar" name="generar" class="submit" tabIndex= "" value="Generar" />
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
							</a>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display:none;"></div> 
</html>