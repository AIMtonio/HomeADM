<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/gestoresCobranzaServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	   <script type="text/javascript" src="js/cobranza/repAsignaCartera.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="asignaCarteraBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Asignaci&oacute;n de Cartera</legend>

<table>
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend><label>Par&aacute;metros</label></legend>
				<table border="0">    	
					<tr>	   	
						<td class="label" nowrap="nowrap">
							<label for="externo">Tipo Gestor:</label>
						</td>
						<td class="label"> 
							<label for="interno">Interno</label>
							<input id="interno" name="tipoGestor" tabindex="1" type="radio" value="I" checked="checked">
							
							<label for="externo">Externo</label>
							<input id="externo" name="tipoGestor" tabindex="2" type="radio" value="E">
						</td>	
					</tr>
					<tr>
						<td>
							<label for="sucursalID">Sucursal:</label>
						</td>
						<td>
							<input type="text" id="sucursalID" name="sucursalID" size="13" tabindex="3" value="0" autocomplete="off">
							<input type="text" id="nombreSucursal" name="nombreSucursal" readonly="true" disabled="disabled" size="50" value="TODAS">														 
						</td>
					</tr>	
					<tr>
						<td>
							<label for="gestorID">Gestor:</label>
						</td>
						<td>
							<input type="text" id="gestorID" name="gestorID" size="13" tabindex="4" value="0"  autocomplete="off">
							<input type="text" id="nombreGestor" name="nombreGestor" readonly="true" disabled="disabled" size="50" value="TODOS">														 
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
	<tr>
		<td class="label">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
				<input type="radio" id="excel" name="excel" value="1" checked="checked"><label>Excel</label>
			</fieldset>    	
		</td>
	</tr>
	<tr>
		<td align="right">	
			<input type="button" class="submit" id="generar" tabindex="5"  value="Generar">	
		</td>
	</tr>
</table>
</fieldset>      
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>