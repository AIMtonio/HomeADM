<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/repRenovaciones.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Renovaciones del Mes</legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="renovaciones" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td>
									<label>Fecha:</label>
								</td>
								<td>
									<label for="lblanio">A&ntilde;o: </label>
									<select name="anio" id="anio" tabindex="1">
									</select>
									<label for="lblmes">Mes: </label>
									<select name="mes" id="mes" tabindex="2">
										<option value="01">Enero</option>
										<option value="02">Febrero</option>
										<option value="03">Marzo</option>
										<option value="04">Abril</option>
										<option value="05">Mayo</option>
										<option value="06">Junio</option>
										<option value="07">Julio</option>
										<option value="08">Agosto</option>
										<option value="09">Septiembre</option>
										<option value="10">Octubre</option>
										<option value="11">Noviembre</option>
										<option value="12">Diciembre</option>
									</select>
								</td>
								<td colspan="3"></td>
							</tr>	
							<tr>
								<td>
									<label>Tipo de Inversi&oacute;n:</label>
								</td>
								<td>
								<input id="tipoInversionID" name="tipoInversionID" size="7" tabindex="3"/>
									<input type="text" id="descripcion" name="descripcion" size="23" readonly="true" disabled="true" />
								</td>
								<td colspan="3"></td>
							</tr>			
							<tr>
								<td>
									<label>Promotor:</label>
								</td>
								<td><select id="promotorID" name="promotorID" tabindex="4" >
									  <option value="0">Todos</option>
										</select>			   										 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td><select id="sucursalID" name="sucursalID" tabindex="5" >
										<option value="0">Todas</option>					      
								      </select>									 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
							<td>
								<label>Renovaci&oacute;n:</label>
							</td>
							<td><select name="renovacionID" id="renovacionID" tabindex="6" >							
								<option value="0">Renovada</option>
					     	   <option value="1">No Renovada</option>						
									</select>
											 
							</td>
							<td colspan="3"></td>
							</tr>
						</table>
						</fieldset>  
					</td> 
					<td> 	
						<table width="200px"> 
							<tr>
						
							<td class="label" style="position:absolute;top:12%;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="7"/>
									<label> PDF </label>
						            <br>
						            <input type="radio" id="excel" name="excel" value="excel" tabindex="8"/>
									<label> Excel </label>
						            <br>
									<input type="radio" id="pantalla" name="pantalla" value="pantalla" tabindex="9">
								<label> Pantalla </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" tabindex="10"/>
							</td>      
							</tr>
						</table>
					</td>
				<tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="renovacionInv.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="" tabindex="11">
		              		Imprimir
		             		</button> 
	            </a>					
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
	
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>