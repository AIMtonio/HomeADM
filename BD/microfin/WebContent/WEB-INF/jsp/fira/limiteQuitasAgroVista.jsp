<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
 	 
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/puestosServicio.js"></script> 
  		<script type="text/javascript" src="dwr/interface/creLimiteQuitasServicio.js"></script> 
		      
      <script type="text/javascript" src="js/fira/limiteQuitasFira.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="limiteQuitas">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Límites Quitas Agro</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" width="600">
			<tr> 
			<td class="label"> 
					         <label for="lblnumCtaAhorro">Producto Crédito:</label> 
					         </td>
					      <td>
				<td>	
				
					<select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="1" >
				    	<option value="0">SELECCIONE</option>
				   </select>									 
				</td>
			
				<td> 
					<input type="button" id="consultar" name="consultar" class="submit" tabIndex = "2" value="Consultar" />
				</td>
					
				<td> 
					<input type="button" id="agregar" name="agregar" class="submit" tabIndex = "3" value="Agregar" />
				</td>
			</tr> 
			</table>
				 
			<br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			 <tr> 
				<td> 
				
				<div id="divPuestos">	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Detalle Puestos</label></legend>         
          			
							<c:set var="listaResultado"  value="${listaResultado[0]}"/>
									<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
					
 		 							</table> 
 		 							<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
 		 						
 		 			</fieldset>  
 		 			</div>	
 		 		</td>  
      
         
    		</tr>
    		</table>
    		<br>
    		<table border="0" cellpadding="0" cellspacing="0" width="600">
    		<tr>
					 
					<td><label for="lblTipoDispersion">Productos de Crédito para los que Aplica: </label> 
					<br>
						<select multiple id="productosAplica" name="productosAplica" path="productosAplica" tabindex="17" size="15">
					         <option value="1">TODOS</option>
					       
				     		 
					    </select>
					  </td>
					 <td class="separador"></td>
					<td colspan="2">
			</td>  
					
     </tr>
	</table>
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"/>
														
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
									
									
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