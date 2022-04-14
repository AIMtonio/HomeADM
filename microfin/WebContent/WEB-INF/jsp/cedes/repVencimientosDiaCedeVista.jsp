<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

   	<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="js/cedes/repVencimientosDiaCede.js"></script>

</head>
<body>
 

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Vencimientos del D&iacute;a</legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="vencimientoCedes"  target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td>
									<label>Fecha de Inicio:</label>
								</td>
								<td><input type="text" name="fechaInicio" id="fechaInicio" autocomplete="off" esCalendario="true" size="12" tabindex="1" />						
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Fecha de Fin:</label>
								</td>
								<td><input type="text" name="fechaFin" id="fechaFin" autocomplete="off" esCalendario="true" size="12" tabindex="2" />						
								</td>
								<td colspan="3"></td>
							</tr>		
							<tr>
								<td>
									<label>Tipo de CEDE:</label>
								</td>
								<td>
								<input id="tipoCedeID" name="tipoCedeID" size="6" tabindex="3" maxlength="9"/>
									<input type="text" id="descripcion" name="descripcion" size="45" readonly="true" disabled="true"  />
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td>
								<input id="sucursalID" name="sucursalID" size="6" tabindex="4" maxlength="9"/>
								<input type="text" id="nombreSucursal" name="nombreSucursal" size="45" tabindex="59" disabled= "true" readOnly="true"  />	   										 
								</td>
								<td colspan="3"></td>
							</tr>			
							<tr>
								<td>
									<label>Promotor:</label>
								</td>
								<td>
								<input id="promotorID" name="promotorID" size="6" tabindex="5" maxlength="9"/>
								<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="45" tabindex="59" disabled= "true" readOnly="true" />	   										 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Moneda:</label>
								</td>
								<td><select name="tipoMonedaID" id="tipoMonedaID" tabindex="6" >
										</select>
												 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
									<label>Estatus:</label>
								</td>
								<td><select name="estatus" id="estatus" tabindex="7" >
									<option value="0">TODOS</option>
									<option value="N">VIGENTE</option>
									<option value="P">PAGADA</option>
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
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="8"/>
									<label> PDF </label>
						            <br>
									<input type="radio" id="excel" name="excel" value="excel" tabindex="9">
								<label> Excel </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
								<input type="hidden" name="lista" id="lista" />
							</td>      
							</tr>
						</table>
					</td>
				<tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
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
		</form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>