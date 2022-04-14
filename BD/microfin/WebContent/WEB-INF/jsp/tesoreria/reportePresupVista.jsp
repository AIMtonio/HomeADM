<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
 	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		      
      <script type="text/javascript" src="js/tesoreria/presupuestosRep.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="PresupBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Presupuestos</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          <table  border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="creditoID">Del mes de: </label>
					</td>
					<td >
						
						<select id="mesInicio" name="mesInicio" path="mesInicio"  tabindex="5" title="Mes Inicio"   >
				         <option value="1">ENERO</option>
				         <option value="2">FEBRERO</option>
				         <option value="3">MARZO</option>
				         <option value="4">ABRIL</option>
				         <option value="5">MAYO</option>
				         <option value="6">JUNIO</option>
				         <option value="7">JULIO</option>
				         <option value="8">AGOSTO</option>
				         <option value="9">SEPTIEMBRE</option>
				         <option value="10">OCTUBRE</option>
				         <option value="11">NOVIEMBRE</option>
				         <option value="12">DICIEMBRE</option>
				         </select>	
					</td>	
					<td class="label">
						<label for="creditoID">del año: </label>
					</td>
					<td >
						
						<select id="anioInicio" name="anioInicio" path="anioInicio"  tabindex="5" title="Año Inicio"  >
				         </select>
					</td>					
				</tr>
				 
				<tr>
					<td class="label">
						<label for="creditoID">Al mes de: </label>
					</td>
					<td >
						
						<select id="mesFin" name="mesFin" path="mesFin"  tabindex="5" title="Mes final"   >
				         <option value="1">ENERO</option>
				         <option value="2">FEBRERO</option>
				         <option value="3">MARZO</option>
				         <option value="4">ABRIL</option>
				         <option value="5">MAYO</option>
				         <option value="6">JUNIO</option>
				         <option value="7">JULIO</option>
				         <option value="8">AGOSTO</option>
				         <option value="9">SEPTIEMBRE</option>
				         <option value="10">OCTUBRE</option>
				         <option value="11">NOVIEMBRE</option>
				         <option value="12">DICIEMBRE</option>
				         </select>	
					</td>	
					<td class="label">
						<label for="creditoID">del año: </label>
					</td>
					<td >
						
						<select id="anioFin" title="Año final"  name="anioFin" path="anioFin"  tabindex="5" >
				        </select>
					</td>					
				</tr>				
				<tr>
					<td>
						<label>Estatus Presupuesto:</label> 
					</td>
					<td><select id="estatusPre" name="estatusPre" path="estatusPre"  tabindex="5" >
					 <option value="0">TODOS</option>
				         <option value="P">PENDIENTE</option>
				         <option value="C">CERRADO</option>
				         </select>									 
					</td>
				
					
				</tr>
				<tr>
					<td>
						<label>Estatus Movimientos:</label> 
					</td>
					<td><select id="estatusPet" name="estatusPet" path="estatusPet"  tabindex="5" >
					 <option value="0">TODOS</option>
				         <option value="A">AUTORIZADOS</option>
				         <option value="S">SOLICITADOS</option>
				         <option value="C">CANCELADOS</option>
				         <option value="E">ELIMINADOS</option>
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
							<input type="radio" id="excel" name="generaRpt" value="excel">
							<label> Excel </label>
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
								
									<a id="ligaGenerar" href="reportePresupuestos.htm" target="_blank" >  		 
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