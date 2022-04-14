<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="js/soporte/repBitacoraHuella.js"></script>
</head>
<body>


<div id="contenedorForma">	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bitacoraHuellaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Operaciones con Huella </legend>
					<table border="0" cellpadding="0" cellspacing="0" width="450px">
						<tr> 
							<td> 	
								<fieldset class="ui-widget ui-widget-content ui-corner-all" >
								<table  border="0"  width="300px">
									<tr>
										<td class="label">
												<label for="lbtipoReporte">Reporte:</label>
										</td>
										<td>
												<select id="tipoReporte" name="tipoReporte" path="tipoReporte" tabindex="1">
												<option value="">SELECCIONAR</option>
											    <option value="1">CLIENTES</option>
											    <option value="2">USUARIOS</option>	
												</select>
										</td>
									</tr>
									<tr>
										<td>
											<label>Fecha Inicio:</label>
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
								</table>
								</fieldset>
							</td>
							<td>
								<table width="110px">
									<tr>
										<td class="label" style="position:absolute;top:14%;">
											<fieldset class="ui-widget ui-widget-content ui-corner-all">                
												<legend><label>Presentaci&oacute;n</label></legend>			 
										 		<input type="radio" id="excel" name="generaExcel" value="excel" />
												<label> Excel </label>	 	
											</fieldset>
										</td>      
									</tr>			 
								</table> 
							</td> 
						</tr>
		 			</table>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">	
						<input type="hidden" id="empresaID" name="empresaID" path="empresaID"/>
							<input type="hidden" id="fechaReporte" name="fechaReporte" path="fechaReporte"/>
								<tr>
									<td colspan="4">
										<table align="right" border='0'>
											<tr>
												<td align="right">
													<a id="ligaGenerar" target="_blank" >  		 
													 <input type="button" id="genera" name="genera" class="submit" 
													 tabIndex = "3" value="Generar" />
													</a>
												</td>
											</tr>
										</table>		
									</td>
								</tr>					
					</table>
				</fieldset>
		</form:form>

</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>