<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/catalogoServicios.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 	
		<script type="text/javascript" src="js/ventanilla/repPagoServicios.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repPagServBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Pago de Servicios</legend>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr> 
		 	<td> 
		 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>
										<label>Parámetros: </label> </legend>
		 		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 			<tr> 
						<td class="label"> 
							<label for="lblFechaCarga">Fecha Inicial:</label> 
					   </td> 
					   <td> 
					    	<form:input type="text" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="3" 
					    		path="fechaCargaInicial" esCalendario="true"/> 
					   	</td>
					 </tr>
					 <tr>
					   	<td class="label"> 
							<label for="lblFechaCarga">Fecha Final:</label> 
					   	</td> 
					   	<td> 
					    	<form:input type="text" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="4" 
					    		path="fechaCargaFinal" esCalendario="true"/> 
					   </td> 
					</tr>
					<tr>
						<td class="label"> 
					    	<label for="lblnum">Sucursal: </label> 
						</td>
						<td>
							<form:select id="sucursal" name="sucursal" path="sucursal" tabindex="5" >
								<form:option value="">Selecciona:</form:option>
							</form:select> 				
						</td>
					</tr>
					<tr>
						<td class="label"> 
					    	<label for="lbltserv">Servicio: </label> 
						</td>
						<td>
							<form:select id="servicio" name="servicio" path="servicio" tabindex="6" >
								<form:option value="">Selecciona:</form:option>
							</form:select> 				
						</td>
					</tr>
					<tr>
						<td class="label"> 
					    	<label for="lbltserv">Origen: </label> 
						</td>
						<td>
							<form:select id="origenPago" name="origenPago" path="origenPago" tabindex="7" >
								<form:option value="T">TODOS</form:option>
								<form:option value="V">VENTANILLA</form:option>
								<form:option value="B">BANCA ELECTRONICA</form:option>
							</form:select> 				
						</td>
					
					</tr>									
				</table>
				</fieldset>
		 	</td>
		 	<td> 
		 		 <table width="200px"> 
					<tr>
						<td class="label" style="position:absolute;top:12%;">
						<input  type="hidden" id="nombreOrigenPago" name="nombreOrigenPago" path="nombreOrigenPago" value=""/>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>
										<label>Presentación: </label>
									</legend>
									<input type="radio" id="excel" name="excel"  tabindex="8" checked/>
									<label> Excel </label>
									<br> 
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="9" /> 
									<label>	PDF </label>
								</fieldset>
							</td>
						</tr>
				</table>
		 	</td>
		</tr>
	</table>
	<br>
<table align="right">
	<tr>
		<td align="right">			
			<button type="button" class="submit" id="generar" style="" tabindex="10">Generar</button>
		</td>
	</tr>
</table>
</fieldset>
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>