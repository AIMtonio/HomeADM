<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/gestoresCobranzaServicio.js"></script>
	   <script type="text/javascript" src="js/cobranza/repPagosAsignacion.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repPagosAsignacionBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Pagos por Asignaci&oacute;n</legend> 
<table>
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend><label>Par&aacute;metros</label></legend>
					<table>    	
						<tr>
							<td class="label">
								<label for="fechaInicioAsigna">Fecha Inicio Asignaci&oacute;n: </label>
							</td>
							<td>
								<input id="fechaInicioAsigna" name="fechaInicioAsigna" size="12" tabindex="1" type="text"  esCalendario="true" />	
							</td>					
						</tr>
						<tr>			
							<td>
								<label for="fechaFinAsigna">Fecha Fin Asignaci&oacute;n: </label> 
							</td>
							<td>
								<input id="fechaFinAsigna" name="fechaFinAsigna" size="12" tabindex="2" type="text" esCalendario="true"/>				
							</td>	
						</tr>	
						<tr>
						<td>
							<label for="gestorID">Gestor Asignado:</label>
						</td>
						<td>
							<input type="text" id="gestorID" name="gestorID" size="12" tabindex="3" value="0"  autocomplete="off">
							<input type="text" id="nombreGestor" name="nombreGestor" readonly="true" disabled="disabled" size="50" value="TODOS">														 
						</td>
					</tr>	
				</table>
			</fieldset>
		</td>
	</tr>
</table>
 <table width="200px"> 	
	<tr>
		<td class="label" colspan="2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
				<input type="radio" id="excel" name="excel" value="1" checked="checked"><label>Excel</label>
			</fieldset>    	
		</td>
	</tr>	
</table>

 <table width="100%"> 	
	<tr>
		<td colspan="5" align="right">	
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