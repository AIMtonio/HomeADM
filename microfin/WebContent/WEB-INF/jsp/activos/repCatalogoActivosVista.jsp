<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>

		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/tiposActivosServicio.js"></script>	
     	<script type="text/javascript" src="dwr/interface/repCatalogoActivosServicio.js"></script>  		      
      	<script type="text/javascript" src="js/activos/repCatalogoActivos.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repCatalogoActivosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo Activos</legend>
		<table border="0" width="600px">
			<tr> 
			<td> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Par&aacute;metros</label></legend>         
          	<table  border="0"  width="560px"> 	
				<tr>
					<td class="label">
						<label for="fechaInicio">Fecha Inicio Registro: </label>
					</td>
					<td>
						<input id="fechaInicio" name="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" autocomplete="off"/>	
					</td>					
				</tr>
				<tr>			
					<td>
						<label for="fechaFin">Fecha Final Registro: </label> 
					</td>
					<td>
						<input id="fechaFin" name="fechaFin" size="12" tabindex="2" type="text" esCalendario="true" autocomplete="off"/>				
					</td>	
				</tr>	
				<tr>
					<td>
						<label for="centroCosto">Centro de Costos:</label>
					</td>
					<td>
						<input type="text" id="centroCosto" name="centroCosto" size="12" tabindex="3" value="0"  autocomplete="off">
						<input type="text" id="descCentroCosto" name="descCentroCosto" readonly="true" disabled="disabled" size="50" value="TODOS">														 
					</td>
				</tr>
				<tr>
					<td>
						<label for="tipoActivo">Tipo de Activo:</label>
					</td>
					<td>
						<input type="text" id="tipoActivo" name="tipoActivo" size="12" tabindex="4" value="0"  autocomplete="off">
						<input type="text" id="descTipoActivo" name="descTipoActivo" readonly="true" disabled="disabled" size="50" value="TODOS">														 
					</td>
				</tr>
				<tr>
					<td>
						<label for="clasificaActivoID">Clasificaci&oacute;n:</label>
					</td>
					<td>					
						<form:select id="clasificaActivoID" name="clasificaActivoID" path="clasificaActivoID" tabindex="4">
							<form:option value="">SELECCIONAR</form:option>
						</form:select>
					</td>
				</tr>	
				<tr>
					<td>
						<label for="estatus">Estatus:</label>
					</td>
					<td>
						<form:select id="estatus" name="estatus" path="estatus" tabindex="6">
							<form:option value="">TODOS</form:option>
							<form:option value="VI">VIGENTE</form:option>
							<form:option value="BA">BAJA</form:option>
							<form:option value="VE">VENDIDO</form:option>

						</form:select>
					</td>			
				</tr>	
  		</table> 
  		</fieldset>
		</td>        
		<td> 
	 		<table width="200px"> 
					<tr>
						<td class="label" style="position:absolute;top:9%;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="excel" name="radioGenera" tabindex="7" value="excel" />
						<label> Excel </label>
						</fieldset>
						</td>      
					</tr>
			        <tr>
						<td class="label" id="tdPresentacion" style="position:absolute;top:40%;">
						</td>  
					</tr>				
			</table> 
		</td>
        </tr>  
	</table>
	<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
	<input type="hidden" id="tipoLista" name="tipoLista" />
	<table border="0" width="100%">
		
		<tr>
			<td colspan="4">
				<table align="right" border='0'>
					<tr>
						<td align="right">
							<input type="button" class="submit" id="generar" name="generar" tabindex="8"  value="Generar">	
						</td>
					</tr>
					
				</table>		
			</td>
		</tr>					
	</table>
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
