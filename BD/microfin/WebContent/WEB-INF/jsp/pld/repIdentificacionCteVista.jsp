<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>   	
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
    		 <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="js/pld/repIdentificacionCte.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cuestionario Identidad del <s:message code="safilocale.cliente"/></legend>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr> <td> 
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                        		
			<table width="450px">
				<tr>
					<td class="label">
							<label for="clientelb"><s:message code="safilocale.cliente"/>: </label> 
					</td>
				   			<td>
				      			<input id="clienteID" name="clienteID"  path="clienteID" size="10" tabindex="1"/>       				
		         				<input id="nombreCliente" name="nombreCliente"size="35" type="text" tabindex="2" readOnly="false" disabled = "false"/>
			  				</td>	
				</tr>	
	 	<tr>
		<td class="label"> 
         <label for="clienteID">Promotor: </label> 
		</td>
      <td>
         <input type="text" id="promotorID" name="promotorID"   size="10"  disabled= "true" 
          readOnly="true"  />  
         <input type="text" id="nombrePromotor" name="nombrePromotor" size="35" tabindex="3" disabled= "true" 
          readOnly="true"/>  
      </td> 
      	</tr> 
			</table>
		 </fieldset>  
	</td>  
		<td><table width="150px"> <tr>
					<td class="label" style="position:absolute;top:13%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" />
							<label> PDF </label>
					</fieldset>
					</td> 
			</table>     
		</tr> 
 	<table align="right" border='0'>
					<tr>
						<td align="right">
					<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
							<a id="ligaGenerar" href="repIdentificacionCtePDF.htm" target="_blank" >		 
							<input type="button" id="generar" name="generar" class="submit" 
							tabIndex = "4" value="Generar" />
							</a>			
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
