<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		
 		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
		 <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
		  				
        <script type="text/javascript" src="js/cliente/repSaldosSocio.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Saldos por <s:message code="safilocale.cliente"/></legend>			
<table border="0" width="100%">

	<tr>
      <td > 
      <fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend><label>Par&aacute;metros: </label> </legend> 
		<table border="0" width="100%">		
               	<tr>
					<td class="label" nowrap="nowrap">		     
         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
    	</td>
      <td nowrap="nowrap">
         <input type="text" id="clienteID" name="clienteID"path="clienteID" size="15" tabindex="1" iniforma='false'  autocomplete="off" />  
         <input type="text" id="nombreCliente" name="nombreCliente" size="45" tabindex="2" disabled= "true" 
          readOnly="true"/>  
      </td> 
      <td class="separador"></td> 
	 
     
 	</tr> 
 	<tr>
					<td class="label">
			 			<label for="credito">Cr&eacute;dito: </label>
					</td> 
		  			<td>
		   				<input id="creditoID" name="creditoID" path="creditoID"   size="15" tabindex="3"  autocomplete="off"/>
		   				<input type="text" id="nombreClienteCre" name="nombreClienteCre"  readOnly="true" size="45" />  
					</td>		
			</tr>
					
</table>
</fieldset>
</td>
			<td>
				<table>   
			<tr>	
				<td class="label" >
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>						
						<input type="radio" id="pdf" name="radioGenera"  tabindex="4" value="pdf" checked="checked"/>
						<label> PDF </label><br>
						
					</fieldset>
				</td>
			</tr>
		</table>
		</td>
		</tr>
		<table align="right">
					<tr>
									<td align="right">
								
											 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "5" value="Generar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									
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