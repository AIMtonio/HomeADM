<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/catalogoServicios.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
		
		<script type="text/javascript" src="js/cliente/reporteClienteLocMarginadas.js"></script> 
		 		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteClienteLocMarginadasBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Socios con Vivienda en Localidades Marginadas</legend>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr> 
		 		<td> 
		 			<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend><label>Parámetros: </label> </legend>
		 					<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 						<tr>
								<td class="label">
									<label for="creditoID">Fecha de Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label">
									<label for="creditoID">Fecha de Fin: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
								<tr>
									<td class="label"> 
					    				<label for="lblEstadoMarginadas">Estado: </label> 
									</td>
									<td>
										<form:input type="text" id="estadoMarginadasID" name="estadoMarginadasID" size="15" path="estadoMarginadasID" tabindex="3" />
										<input type="text" id="nombreEstadoMarginadas" name="nombreEstadoMarginadas" size="40" path="nombreEstadoMarginadas" tabindex="4" disabled="true" />
										<input type="hidden" id="estadoID" name = "estadoID" path = "estadoID" />
									</td>
								</tr>
								<tr>
									<td class="label"> 
					    				<label for="lblMunicipioMarginadas">Municipio: </label> 
									</td>
									<td>
										<form:input type="text" id="municipioMarginadasID" name="municipioMarginadasID" size="15" path="municipioMarginadasID" tabindex="5" />
										<input type="text" id="nombreMunicipioMarginadas" name="nombreMunicipioMarginadas" size="40" path="nombreMunicipioMarginadas" tabindex="6" disabled="true" />
									<input type="hidden" id="municipioID" name = "municipioID" path = "municipioID" />
									</td>
								</tr>
								<tr>
									<td class="label"> 
					    				<label for="lblLocalidadMarginadas">Localidad: </label> 
									</td>
									<td>
										<form:input type="text" id="localidadMarginadasID" name="localidadMarginadasID" size="15" path="localidadMarginadasID" tabindex="7" />
										<input type="text" id="nombreLocalidadMarginadas" name="nombreLocalidadMarginadas" size="40" path="nombreLocalidadMarginadas" tabindex="8" disabled="true" />
									</td>
								</tr>
						</table>
		 			</td>
		 			<td>
		 				 <table width="200px"> <tr>
					<td class="label" style="position:absolute;top:10%;">
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
					</table>
					</fieldset>
		 			 </td>
		 		</tr>
 		</table> 
			
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="4">
			<table align="right" border='0'>
				<tr>
					<td align="right">
						<a id="ligaGenerar" href="reporteClienteLocMarginadas.htm" target="_blank" >  		 
						 <input type="button" id="generar" name="generar" class="submit" tabIndex = "48" value="Generar" />
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

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>