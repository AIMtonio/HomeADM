<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  	
	<script type="text/javascript" src="js/contabilidad/repSat.js"></script> 	
	
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Cifras Control Timbrado</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasContablesBean"
					  target="_blank">
			<table border="0"  width="100%">
			    <tr>
			    <td>
			    <fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend> 
					<table  border="0"  width="560px">
					<tr>
					 <td class="label"> 
		         		<label for="lblPeriodo">Periodo:</label> 
					</td> 
		     		<td> 
		         		<input id="periodo" name="periodo" autocomplete="off" size="12" tabindex="1" numMax ="10" />
		     		</td>
				   </tr>
				    
				    <tr>  
		     		<td class="label"> 
		         		<label for="lblproductoCreditoID">Producto Cr&eacute;dito:</label> 
					</td> 		     		
		     		<td>
		         	 <input id="productoCreditoID" name="productoCreditoID" size="12" tabindex="2"/> 
		         	 <input type="text" id="nombreProducto" name="nombreProducto" size="50" readOnly="true" />  
		     		</td> 	 
		 		    </tr>
		 		    <tr>
					
		     		<td class="label"> 
		         		<label for="lblClienteID">Cliente</label> 
					</td> 	
		     		<td> 
		         		<input id="clienteID" name="clienteID" size="12" tabindex="3" numMax ="10" />
		         		<input type="text" id="nombreCliente" name="nombreCliente"size="50" readOnly= "true" />
		     		</td>
		     		<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				    </tr>
					</table>  
				</fieldset>
				</td>   
				</tr>	
				<tr>
				<td>
					 <table > 
				<tr>
					<td class="label" style="position:right;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
							<input type="radio" id="excel" name="radioGenera" tabindex="4" value="excel" />
						    <label> Excel </label>			 	
					</fieldset>
					</td>      
				</tr>			 
					</table> 
				</td>
				</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
								
										 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "5" value="Generar" />
									
									</td>
								</tr>
							</table>		
						</td>
					</tr>					
				</table>

		</form:form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
	
</div>

</body>
</html>