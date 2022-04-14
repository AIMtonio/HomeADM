<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/plazasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoResultadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/segtoRecomendasServicio.js"></script>		
	<script type="text/javascript" src="js/seguimiento/repSegtoCampo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="seguimientoBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Seguimiento de Campo</legend>			
				<table border="0" cellpadding="0" cellspacing="0" >
				<tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
         		 <table  border="0"  width="560px">
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
							<label for="lblPlaza">Plaza:</label>
						</td>
						<td>
							<select id="plazaID" name="plazaID"></select>
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
							<label for="lblProducto">Producto de Cr&eacute;dito:</label>
						</td>
						<td>
							<select id="prodCreditoID" name="prodCreditoID"></select>
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
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblSupervisor">Supervisor:</label>
						</td>
						<td>
							<select id="supervisorID" name="supervisorID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblResultados">Resultados:</label>
						</td>
						<td>
							<select id="resultadoID" name="resultadoID"></select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="lblRecomendacion">Recomendaci&oacute;n:</label>
						</td>
						<td>
							<select id="recomendacionID" name="recomendacionID"></select>
						</td>
					</tr>
				</table>
			 </fieldset>  
			 </td>  
			 <td> 
			 		<table width="200px"> 
							<tr>
								<td class="label" style="position:absolute;top:7%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" />
								<label> PDF </label>
				           		 <br>
									<input type="radio" id="excel" name="generaRpt" value="excel">
								<label> Excel </label>
								</fieldset>
								</td>      
							</tr>
					        <tr>
								<td class="label" id="tdPresentacion" style="position:absolute;top:40%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Nivel de Detalle</label></legend>
									<input type="radio" id="detallado" name="presentacion" value="detallado" />
									<label> Detallado </label>
				           		 <br>
									<input type="radio" id="sumarizado" name="presentacion" value="sumarizado">
									<label> Sumarizado</label>
								</fieldset>
								</td>  
							</tr>				
						</table> 
					</tr>  
			</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
					
				<table align="right" border='0'>
					<tr>
						<td>
							<a id="ligaGenerar" href="segtoCampoRep.htm" target="_blank" >
								<input type="button" id="generar" name="generar" class="submit" tabIndex= "" value="Generar" />
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