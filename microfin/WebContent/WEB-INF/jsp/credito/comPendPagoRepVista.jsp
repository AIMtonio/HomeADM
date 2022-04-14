<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
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
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>  
		      
      <script type="text/javascript" src="js/credito/comPendPago.js"></script>  
				
	</head>
       
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Comisiones Pendientes de Pago</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          <table  border="0"  width="560px">
                 			<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblclienteID">Cliente: </label>
								</td>
								<td>
									<input type="text" id="clienteID" name="clienteID" tabindex="1" size="10" />
									<input type="text" id="nombreCompleto" name="nombreCompleto" size="50" tabindex="5" onBlur="ponerMayusculas(this)" disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lblgrupoID">Grupo: </label>
								</td>
								<td>
									<input type="text" id="grupoID" name="grupoID" tabindex="2" size="10" />
									<input type="text" id="nombreGrupo" name="nombreGrupo" size="50" tabindex="5" onBlur="ponerMayusculas(this)" disabled="true" />
								</td>
							</tr>
							<tr>
								<td>
								<label>Sucursal:</label>
								</td>
									<td><select id="sucursal" name="sucursal" path="sucursal" tabindex="3" >
				        		 	<option value="0">Todas</option>
					      			</select>									 
									</td>
							</tr>
							<tr>		
								<td>
								<label>Moneda:</label>
								</td>
								<td><select name="monedaID" id="monedaID" path="monedaID" tabindex="4" >	 						
								<option value="0">Todas</option>
								</select>				 
								</td>
							</tr>
							<tr>
								<td>
								<label>Producto de Cr&eacute;dito:</label> 
								</td>
								<td><select id="producCreditoID" name="producCreditoID" path="producCreditoID"  tabindex="5" >
				         		<option value="0">Todos</option>
					    	  	</select>									 
								</td>		
							</tr>
							<tr> 
								<td class="label">
								<label for="promotorInicial">Promotor:</label>
								</td>
								<td >
									<form:input id="promotorID" name="promotorID" path="promotorID"
									size="6" tabindex="5"/>
									<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39" tabindex="6" 
					 				disabled= "true" readOnly="true" />	 
								</td>
							</tr>
							<tr>
								<td class="label">
								<label for="sexo"> G&eacute;nero:</label>
								</td>
								<td>
									<form:select id="sexo" name="sexo" path="sexo" tabindex="6">
									<form:option value="0">Todos</form:option>
									<form:option value="M">Masculino</form:option>
		     						<form:option value="F">Femenino</form:option>
									</form:select>
								</td>			
							</tr>	
							<tr>
								<td class="label"> 
         						<label for="estado">Estado: </label> 
     							</td> 
     							<td> 
        							 <form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="7" /> 
         								<input type="text" id="nombreEstado" name="nombreEstado" size="39"   disabled ="true"
           								readOnly="true"/>   
     							</td> 
 							</tr> 	
							<tr> 
    							 <td class="label"> 
         						 <label for="municipio">Municipio: </label> 
     							 </td> 
   	  							 <td> 
         							<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="8" /> 
        							<input type="text" id="nombreMuni" name="nombreMuni" size="39" tabindex="7" disabled="true"
          							readOnly="true"/>   
          					    </td> 
							</tr>	
  		</table> </fieldset>  </td>        
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
					        <tr>
								<td class="label" id="tdPresenacion" style="position:absolute;top:40%;">
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
								
									<a id="ligaGenerar" href="reportePendientePago.htm" target="_blank" >  		 
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