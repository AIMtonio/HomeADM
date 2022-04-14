<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

	<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	
	<script type="text/javascript" src="js/ventanilla/reporteCajaPrincipal.js"></script>  
	    
	
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cajasMovsBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Movimientos de Caja Principal</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr> 
		 			<td> 
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend><label>Parámetros</label></legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label">
									<label for="creditoID">Fecha  Inicial: </label>
								</td>
								<td colspan="4">
									<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>	
								<td class="label">
									<label for="creditoID">Fecha Final: </label> 
								</td>
								<td>
									<input  id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
								
							</tr>	
							<tr>	
								<td class="label">
									<label for="lblCajaID">Caja: </label> 
								</td>
								<td>
									<select name="cajaID" id="cajaID"  tabindex="4" >	 						
									<option value="0">SELECCIONAR</option>
										</select>			
								</td>	
								
							</tr>											
							<tr>		
								<td>
									<label>Moneda:</label>
								</td>
								<td colspan="4">
								<select name="monedaID" id="monedaID" path="monedaID" tabindex="5" >	 						
									<option value="0">Todas</option>
										</select>
												 
								</td>
							</tr>
							
						</table>
					</fieldset>	
				</td>
		 	</tr>
 		</table> 
		<br>
		<table width="200px">
				 <tr>
 					<td class="label" > 	
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend><label>Presentaci&oacute;n</label></legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td>
										<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="8"  checked="checked" >
										<label> PDF </label><br>
										<input type="radio" id="excel" name="pdf" value="excel" tabindex="9">
										<label> Excel </label>	
									</td>
								</tr>
							</table>	
					</fieldset>
				</td>      
			</tr>			 
		</table>	
			<table align="right" border='0'>
					<tr>
						<td align="right">
								<input type="button"  id="generar" name="generar" class="submit" tabindex="10" value="Generar"  />
						</td>				
					</tr>
			</table>
	</form:form>
</div>	
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>