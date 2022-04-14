<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   

<html>
<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="js/tesoreria/fondSucursales.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reqGastosSucBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Fondeo de Sucursales Bancarias</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="600px">
 <tr>
 		 <td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				 <table  border="0"  width="560px">
			
			
				
			
		 		<tr>
					<td class="label">
						<DIV class="label">
							<label> 
								<br>
									Reporte con Saldos de Cajas y Desembolsos por Sucursal al d&iacute;a de hoy:
									<br>
									</label>
										<br>
							<td align="right">
								  <form:input id="fechaInicio" name="fechaInicio" tabindex="1" path="fechaInicio" readOnly="true" size="10" disabled="true"/>
							</td>
						</DIV>
					</td>
				</tr>	
 		 </table> </fieldset>  </td>  
      
				<td> <table width="200px"> 
				<tr>
				
					<td class="label" style="position:absolute;top:12%;">
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
					
					
					<tr>
					
				
					</tr> 
				 
	</table> </td>
         
    </tr>
     
	</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
								
									<a id="ligaGenerar" href="/fondSucursales.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "48" value="Generar" />
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
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>