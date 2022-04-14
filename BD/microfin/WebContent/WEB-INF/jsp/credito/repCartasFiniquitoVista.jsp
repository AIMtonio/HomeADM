<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
        <script type="text/javascript"	src="dwr/interface/institucionNomServicio.js"></script>

     <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>   
        
 		<script type="text/javascript" src="js/credito/repCartasFiniquito.js"></script> 
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos" target="_blank">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Cartas Finiquito</legend>
        <table border="0" width="100%">		
         <tr> <td> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend><label>Parámetros</label></legend>         
          <table  border="0"  width="560px">
         	<tr>
				<td class="label">
					<label for="fecha">Fecha de Inicio: </label>
				</td>
				<td >
					<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" />	
				</td>					
			</tr>
			<tr>
				<td class="label" >
					<label for="fecha">Fecha de Fin: </label>
				</td>
				<td  colspan="4">
					<input id="fechaVencimien" name="fechaVencimien" path="fechaFin" size="12" tabindex="2" type="text" esCalendario="true"/>
				</td>	
									
			</tr> 		
			<tr>
				<td class="label">
					<label for="sucursal">Sucursal: </label>
				</td> 
				<td >
					<input id="sucursal" name="sucursal"   size="6" tabindex="2" />
					<input type="text" id="nombreSucursal" name="nombreSucursal"  readOnly="true" size="39"/> 
				
				</td>  
			</tr>
			<tr>		
				<td class="label">
					<label>Moneda:</label>
				</td>
				<td  colspan="4"><select name="monedaID" id="monedaID" path="monedaID" tabindex="4" >	 						
						<option value="0">TODAS</option>
					</select>				 
				</td>
			</tr>			
			<tr> 
				<td class="label">
					<label >Producto de Cr&eacute;dito:</label>
				</td>
				<td  colspan="4">
					<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="6" tabindex="5"/>
						<input type="text" id="nomProducto" name="nomProducto" size="39" tabindex="6" disabled= "true" readOnly="true" />	 
				</td>
			</tr>
			<tr> 
				<td class="label" id="lblNomina">
					<label for="promotorInicial">Empresa de Nómina:</label>
				</td>
				<td  colspan="4">
					<form:input id="institNominaID" name="institNominaID" path="institucionNominaID" size="6" tabindex="7"/>
						<input type="text" id="nombreInstit" name="nombreInstit" size="39" tabindex="8" disabled= "true" readOnly="true" />	 
				</td>
			</tr>
			<tr> 
				<td class="label">
					<label for="promotorInicial">Promotor:</label>
				</td>
				<td  colspan="4">
					<form:input id="promotorID" name="promotorID" path="promotorID" size="6" tabindex="9"/>
						<input type="text" id="nombrePromotorI" name="nombrePromotorI" size="39" tabindex="10" disabled= "true" readOnly="true" />	 
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="sexo"> G&eacute;nero:</label>
				</td>
				<td  colspan="4">
					<form:select id="sexo" name="sexo" path="genero" tabindex="11">
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
     			<td  colspan="4"> 
        			 <form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="12" /> 
         				<input type="text" id="nombreEstado" name="nombreEstado" size="39" tabindex="13"  disabled ="true"	readOnly="true"/>   
     			</td> 
 			</tr> 	
			<tr> 
    			 <td class="label"> 
         			 <label for="municipio">Municipio: </label> 
     			 </td> 
   	  			<td  colspan="4"> 
         			<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="14" /> 
        				<input type="text" id="nombreMuni" name="nombreMuni" size="39" tabindex="15" disabled="true" readOnly="true"/>   
          		</td> 
			</tr>	
			  </table> </fieldset>  </td>  
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="4">
						<table align="right" border='0'>
							<tr>
								<td >
										<input type="button" id="generar" name="generar" class="submit" tabIndex = "15" value="Generar" />
								</td>
							</tr>			
						</table>		
					</td>
				</tr>					
			</table>
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