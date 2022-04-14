<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/clienteExMenorServicio.js"></script> 	
		
		
		<script type="text/javascript" src="js/cliente/exMenorCanceladoAutReporte.js"></script> 
		 		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteExmenorBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Menores Cancelados Aut. Por Mayoria de Edad</legend>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr> 
		 		<td> 
		 			<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend><label>Filtros: </label> </legend>
		 					<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 						<tr>
								<td class="label">
									<label for="fechaInicial">Fecha Inicial: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label">
									<label for="fechaFinal">Fecha Final: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
							<tr>			
								<td class="label">
									<label for="sucursalInicial">Sucursal Inicial: </label> 
								</td>
								<td>
									<input id="sucursalIni" name="sucursalIni"  size="12"  value="0" tabindex="3" type="text" />		
					         		<input id="nombreSucIni" name="nombreSucIni"  size="50" value="TODAS" readOnly="true" type="text" />			
								</td>	
							</tr>
							<tr>			
								<td class="label">
									<label for="sucursalFinal">Sucursal Final: </label> 
								</td>
								<td>
									<input id="sucursalFin" name="sucursalFin"  size="12" value="0" tabindex="4" type="text" />		
					         		<input id="nombreSucFin" name="nombreSucFin"  size="50" value="TODAS"  readOnly="true" type="text" />			
								</td>	
							</tr>
							<tr>			
								<td class="label">
									<label for="exmenor">ExMenor: </label> 
								</td>
								<td>
									<input id="clienteID" name="clienteID"  size="12" value="0" tabindex="4" type="text" />		
					         		<input id="nombreExMenor" name="nombreExMenor"  size="50" value="TODOS"  readOnly="true" type="text" />			
								</td>	
							</tr>
						
						</table>
		 			</td>
		 			<td>
		 				 <table width="200px"> <tr>
					<td class="label" style="position:absolute;top:10%;">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="5"/>
							<label> PDF </label>
				            <br>
								<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="6">
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
						<a id="ligaGenerar" href="repExMenorCancelados.htm" target="_blank" >  		 
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