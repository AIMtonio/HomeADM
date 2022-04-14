<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
       
     <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
          <script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>  
     
		      
      <script type="text/javascript" src="js/cuentas/repAnaliticoAhorro.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="analiticoAhorroBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Anal&iacutetico Ahorro</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="600px">
 <tr>
 		 <td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Parámetros</label></legend>  <table  border="0"  width="560px">
				
			<tr>
				<td class="label"> 
					<label for="clienteID">Cliente: </label> 
				</td> 	
				 <td nowrap= "nowrap"> 
					<form:input id="clienteID" name="clienteID"  path="clienteID"  size="12" tabindex="2" /> 
				 	<input type="text" id="nombreCliente" name="nombreCliente" size="50"   readOnly="true"/>   
				 </td> 					
			</tr>
			<tr>
					<td>
						<label>Tipo Cuenta:</label> 
					</td>
					<td>
						<select id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID"  tabindex="3" >
						<option value="0">TODAS</option>
						</select>									 
					</td>
		
			</tr>
				<tr>
				<td>
					<label>Sucursal:</label>
				</td>
				<td>
					<select id="sucursal" name="sucursal"  path="sucursal" tabindex="1" >
					<option ></option>
					 </select>									 
				</td>
										

				</tr>
			<tr>			
				<td class="label">
					<label for=cuentasAho> Cuenta: </label> 
				</td>
				<td>
					<input id="cuentasAho" name="cuentasAho" size="12"tabindex="4" type="text" />				
				</td>	
			</tr>
				
		
				<tr>		
					<td>
						<label>Moneda:</label>
					</td>
					<td>
						<select name="monedaID" id="monedaID" path="monedaID"  tabindex="5" >	 						
						<option value="0">TODAS</option>
						</select>
														 
					</td>
				</tr>
			
					
				<tr> 
					<td class="label">
						<label for="promotorInicial">Promotor:</label>
					</td>
					<td >
						<form:input id="promotorID" name="promotorID" path="promotorID"  tabindex="7" 
						size="12"/>
						<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39"  readOnly="true" />
										 
					</td>
										
				</tr>
				<tr>
					<td class="label">
						<label for="sexo"> G&eacute;nero:</label>
					</td>
					<td>
						<form:select id="sexo" name="sexo" path="sexo"  tabindex="8">
						<form:option value="0">TODOS</form:option>
						<form:option value="M">MASCULINO</form:option>
						<form:option value="F">FEMENINO</form:option>
						</form:select>
					</td>		
				 </tr>	
				<tr>
				    <td class="label"> 
						 <label for="estado">Estado: </label> 
					</td> 
					<td> 
					     <form:input id="estadoID" name="estadoID" path="estadoID" size="12" tabindex="9" /> 
					     <input type="text" id="nombreEstado" name="nombreEstado" size="39"       readOnly="true"/>   
				   </td> 
				</tr> 
		
		 		<tr> 
				     <td class="label"> 
				         <label for="municipio">Municipio: </label> 
				     </td> 
				     <td> 
				         <form:input id="municipioID" name="municipioID" path="municipioID" size="12" tabindex="12" /> 
				         <input type="text" id="nombreMuni" name="nombreMuni" size="39"  
				          readOnly="true"/>   
				     </td> 
	     		</tr>	
 		 </table> </fieldset>  </td>  
      
				<td> <table width="200px"> 
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
								
									<a id="ligaGenerar" href="/ReporteAnaliticoAhorro.htm" target="_blank" >  		 
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