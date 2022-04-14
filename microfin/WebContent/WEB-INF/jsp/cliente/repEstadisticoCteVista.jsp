<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>      
<html>
	<head>
      
	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
		      
      <script type="text/javascript" src="js/cliente/repEstadisticoCliente.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clientesBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Estadisticos <s:message code="safilocale.cliente"/></legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="960px">
			<tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          <table  border="0"  width="560px">
				 
				
					<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td><select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="2" >
				         <option value="0">Todas</option>
					      </select>									 
					</td>
					

					</tr>
					 
				 
				
				<tr> 
				<td class="label">
					<label for="promotorInicial">Promotor:</label>
				</td>
				<td >
					<input id="promotorID" name="promotorID" path="promotorID"
					size="6" tabindex="5"/>
					<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39" tabindex="50" 
					 disabled= "true" readOnly="true" />
					 
				</td>
				
				</tr>
				<tr>
			<td class="label">
				<label for="sexo"> G&eacute;nero:</label>
			</td>	
			<td>
				<select id="sexo" name="sexo" path="sexo" tabindex="6">
				<option value="0">TODOS </option>
				<option value="M">MASCULINO</option>
		     	<option value="F">FEMENINO</option>
				</select>
			</td>		
			
		</tr>	
		<tr>
		<td class="label"> 
         <label for="estado">Estado: </label> 
     </td> 
     <td> 
         <input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="7" /> 
         <input type="text" id="nombreEstado" name="nombreEstado" size="39"   disabled ="true"
           readOnly="true"/>   
     </td> 
 	</tr> 
		
	<tr> 
     <td class="label"> 
         <label for="municipio">Municipio: </label> 
     </td> 
     <td> 
         <input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="8" /> 
         <input type="text" id="nombreMuni" name="nombreMuni" size="39" tabindex="7" disabled="true"
          readOnly="true"/>   
     </td> 
     </tr>	
  </table> </fieldset>  </td>  
      
<td> <table width="200px"> <tr>
				
					<td class="label" style="position:absolute;top:8%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
							<input type="radio" id="pdf" checked="true" name="generaRpt" value="pdf" />
							<label> PDF </label>
				            <br>
							<input type="radio" id="pantalla" name="generaRpt" value="pantalla">
						<label> Pantalla </label>
					 	
						</fieldset>
					</td>      
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
								
									<a id="ligaGenerar" href="repEstadisticosCliente.htm" target="_blank" >  		 
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