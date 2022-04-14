<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/repAperturasDia.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Aperturas del D&iacute;a</legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="aperturasInv" target="_blank">
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
								<td><input type="text" name="fecha" id="fecha" autocomplete="off" esCalendario="true" size="12" tabindex="1" />						
								</td>
								<td colspan="3"></td>
							</tr>	
							<tr>
								<td>
									<label>Tipo de Inversi&oacute;n:</label>
								</td>
								<td>
								<input id="tipoInversionID" name="tipoInversionID" size="7" tabindex="2"/>
									<input type="text" id="descripcion" name="descripcion" size="23" readonly="true" disabled="true" />
								</td>
								<td colspan="3"></td>
							</tr>			
							<tr>
								<td>
									<label>Promotor:</label>
								</td>
								<td><select id="promotorID" name="promotorID" tabindex="3" >
									  <option value="0">Todos</option>
										</select>			   										 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td><select id="sucursalID" name="sucursalID" tabindex="4" >
										<option value="0">Todas</option>					      
								      </select>									 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Moneda:</label>
								</td>
								<td><select name="tipoMonedaID" id="tipoMonedaID" tabindex="5" >							
									<option value="0">Todas</option>
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
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="6"/>
									<label> PDF </label>
						            <br>
						            <input type="radio" id="excel" name="excel" value="excel" tabindex="7"/>
									<label> Excel </label>
						            <br>
									<input type="radio" id="pantalla" name="pantalla" value="pantalla" tabindex="8">
								<label> Pantalla </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
							</td>      
							</tr>
						</table>
					</td>
				<tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="AperturasDia.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="" tabindex="9">
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