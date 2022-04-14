<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/castigosCarteraAgroServicio.js"></script> 
		      
      <script type="text/javascript" src="js/fira/creCastigosAgroRep.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="castigosCarteraBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Castigos</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="600px">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
	         		 <table  border="0"  width="560px">
						<tr>
							<td class="label">
								<label for="lblFechaInicio">Fecha de Inicio: </label>
							</td>
							<td colspan="4">
								<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
				         			tabindex="1" type="text"  esCalendario="true" />	
							</td>					
						</tr>
						<tr>			
							<td class="label">
								<label for="creditoID">Fecha de Fin: </label> 
							</td>
							<td colspan="4">
								<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
				         			tabindex="2" type="text" esCalendario="true"/>				
							</td>	
						</tr>
				
						<tr>
							<td>
								<label>Sucursal:</label>
							</td>
							<td colspan="4">
							<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="3" >
						         <option value="0">Todas</option>
							      </select>									 
							</td>
						
	
						</tr>
						<tr>
							<td>
								<label>Producto de cr&eacute;dito:</label> 
							</td>
							<td colspan="4">
							<select id="producCreditoID" name="producCreditoID" path="producCreditoID"  tabindex="5" >
						         <option value="0">Todos</option>
							      </select>									 
							</td>
						
							
						</tr>
							<tr>
							<td>
								<label>Motivo:</label> 
							</td>
							<td colspan="4">
							<select id="motivoCastigoID" name="motivoCastigoID" path="motivoCastigoID"  tabindex="5" >
						         <option value="0">Todos</option>
							      </select>									 
							</td>
						
							
						</tr>
				
						<tr> 
							<td class="label">
								<label for="promotorInicial">Promotor:</label>
							</td>
							<td colspan="4">
								<input id="promotorID" name="promotorID"  tabindex="6" 
								size="6"/>
								<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39" 
								 disabled= "true" readOnly="true" />
								 
							</td>						
						</tr>

 
				  </table>
		 </fieldset>  
	</td>  
				      
			<td> 
				<table width="200px">
				 <tr>							
					<td class="label" style="position:absolute;top:8%;">
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
		 </td>
         
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
					
						<a id="ligaGenerar" href="ReporteCredCastigosAgro.htm" target="_blank" >  		 
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
