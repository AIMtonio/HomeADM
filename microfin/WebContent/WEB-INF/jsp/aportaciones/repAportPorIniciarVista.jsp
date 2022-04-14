<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

   	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/aportaciones/repAportPorIniciar.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>

</head>
<body>
 
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesPorIniciar">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Aportaciones Por Iniciar</legend>
		<table border="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td>
									<label>Fecha de Inicial:</label>
								</td>
								<td><input type="text" name="fechaInicio" id="fechaInicio" autocomplete="off" esCalendario="true" size="12" tabindex="1" />						
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Fecha Final:</label>
								</td>
								<td><input type="text" name="fechaFin" id="fechaFin" autocomplete="off" esCalendario="true" size="12" tabindex="2" />						
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td class="label"><label>Cliente: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="5" type="text"/>
									<input type="text" id="nombreCliente" name="nombreCliente"  size="50" readOnly="true"/>
								</td>
							</tr>
							<tr>
								<td class="label"> 
						        	<label for="sucursalID">Sucursal: </label> 
							    </td>
								<td>
									<input id="sucursalID" name="sucursalID" size="10" tabindex="4" type="text"/>
									<input type="text" id="nombreSucursal" name="nombreSucursal" size="50" readOnly="true" />	   										 
								</td>
							</tr>
						</table>
					</fieldset>  
				</td>  	
				
				</tr>	
				
				<table width="200px" style="height: 100%" border ="0"> 
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="6" checked/>
									<label for="pdf">PDF</label>
									<br>
									<input type="radio" id="excel" name="tipoReporte" value="2" tabindex="7"/>
									<label for="excel">Excel</label>
				            		<br>
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
								<input type="hidden" name="lista" id="lista" />
							</td>      
						</tr>	
				</table>
				<table  width="595px">
					<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="VencimientosDia.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="" tabindex="10">
		              		Generar
		             		</button> 
	            </a>					
					</td>
				</tr>
				</table>	
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
</html>
