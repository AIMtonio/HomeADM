<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>        	
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>   	 		   
      	<script type="text/javascript" src="js/tesoreria/reporteReqGastos.js"></script>  				
	</head>      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="requisicionBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Requisición de Gastos</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          <table  border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="creditoID">Fecha de Inicio: </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
		         			tabindex="1" type="text"  esCalendario="true" />	
					</td>					
				</tr>
				<tr>			
					<td class="label">
						<label for="creditoID">Fecha de Fin: </label> 
					</td>
					<td>
						<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
		         			tabindex="2" type="text" esCalendario="true"/>				
					</td>	
				</tr>
				
				<tr>
					<td>
						<label>Estatus Requisición:</label> 
					</td>
					<td><select id="estatusEnc" name="estatusEnc" path="estatusEnc"  tabindex="5" >
				         <option value="T">TODOS</option>
				         <option value="P">PROCESADA</option>
				         <option value="F">FINALIZADA</option>
				         <option value="C">CANCELADA</option>
				         </select>									 
					</td>
				
					
				</tr>
				
							
				<tr>
					<td>
						<label>Estatus Movimientos:</label> 
					</td>
					<td><select id="estatusDet" name="estatusDet" path="estatusDet"  tabindex="5" >
				         <option value="T">TODOS</option>
				         <option value="A">AUTORIZADO</option>
				         <option value="P">PENDIENTE</option>
				         <option value="C">CANCELADO</option>
				         </select>									 
					</td>
				
					
				</tr>
				

			
				<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td><select id="sucursal" name="sucursal" path="sucursal" tabindex="3" >
				         <option value="0">TODAS</option>
					      </select>									 
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
							<input type="radio" id="pantalla" name="generaRpt" value="pantalla">
						<label> Pantalla </label>				 	
						</fieldset>
					</td>      
					</tr>
					
					
					<!-- <tr>
					
					<td class="label" id="tdPresenacion" style="position:absolute;top:40%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Nivel de Detalle</label></legend>
							<input type="radio" id="detallado" name="presentacion" value="detallado" />
							<label> Detallado </label>
				            <br>
							<input type="radio" id="sumarizado" name="presentacion" value="sumarizado">
						<label> Sumarizado</label>
					 	
						</fieldset>
					</td>  
					
					</tr> -->
				 
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
								
									<a id="ligaGenerar" href="reporteReqGastos.htm" target="_blank" >  		 
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