<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
   
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		      
      <script type="text/javascript" src="js/credito/actasComiteCredito.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="actasComite">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Pantalla Actas de Comité Crédito</legend>
		
			<table border="0"  width="600px">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros </label> </legend>        
          <table  border="0"  width="560px">
				<tr>		
					<td>
						<label for="tipoActa">Tipo Acta: </label>
					</td>
					<td colspan="4">
					<select name="tipoActa" id="tipoActa" path="tipoActa" tabindex="1" >	 						
						<option value="">SELECCIONAR</option>
						<option value="1">SUCURSAL</option>
						<option value="2">COMITÉ CENTRAL</option>
						<option value="3">PERSONAS RELACIONADAS</option>
						<option value="4">REESTRUCTURAS Y RENOVACIONES</option>											
					</select>
									 
					</td>
				</tr>
				
				<tr id="filaSucursal" style="display: none;"> 
					<td class="label">
						<label for="sucursalID">Sucursal:</label>
					</td>
					<td colspan="4">
						<form:input id="sucursalID" name="sucursalID" path="sucursalID" tabindex="2" size="6"/>
						<input type="text" id="nombreSucursal" name="nombreSucursal" size="39" disabled= "true" readOnly="true" />					
					</td>				
				</tr>
				
				<tr>
					<td class="label">
						<label for="fechaReporte">Fecha: </label>
					</td>
					<td colspan="4">
						<input type="text" id="fechaReporte" name="fechaReporte" path="fechaReporte" size="12" tabindex="3" esCalendario="true" />	
					</td>					
				</tr>															  
  		</table> </fieldset>  </td>  
      
<td> <table width="200px"> 

		<tr>			
			<td class="label" style="position:absolute;top:16%;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentación</label></legend>
					<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="5"/>
					<label> PDF </label>					 
				</fieldset>
			</td>      
		</tr>
				 
	</table> </td>         
    </tr>
    
	</table>
			<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
			<input type="hidden" id="tipoLista" name="tipoLista" />
			<table border="0"  width="100%">					
				<tr>
					<td colspan="4">
						<table align="right" border='0'>
							<tr>
								<td align="right">			
									<a id="ligaGenerar" target="_blank" >  		 
									<input type="button" id="generar" name="generar" class="submit" tabindex="6" value="Generar" />
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