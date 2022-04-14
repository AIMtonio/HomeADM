<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>	
<html>
	<head>	
 		
		<script type="text/javascript" src="dwr/interface/autorizaSpeiServicio.js"></script>
 		<script type="text/javascript" src="js/spei/autorizaSpei.js"></script> 
 		
 		
	</head>
<body>
<div id="contenedorForma">	

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="autorizaSpeiBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Autorizaci&oacute;n SPEI</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr style="text-align:right;">  
	    	<td class="label"> 
		    	<label for="lblFecha">Fecha: </label> 
				<form:input type="text" id="fecha" name="fecha" path="fecha" size="12" tabindex="1" iniForma="false" disabled="true" readonly="true"/>
				<form:input type="hidden" id="usuarioVerifica" name="usuarioVerifica" path="usuarioVerifica" size="12" tabindex="2" iniForma="false" disabled="true" readonly="true"/>
            </td> 
	 	</tr>
	 
	</table>		     
	     <table>
	     	<tr>
	     		<td>
		     		<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
				<div id="gridAutorizaSPEI" style=" width: 1000px;height: 380px;  overflow-y: scroll;  display: none; "></div>	
		    	</td>		
		 	</tr>
	    </table>
	 	
	
												
		     <table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
				<tr>					
					<td colspan="5">
						<table align="right"> 
				
							<tr>								
								<td align="right">
									<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="3" />
									<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="4"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									
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
