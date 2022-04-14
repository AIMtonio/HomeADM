<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
 		<script type="text/javascript" src="js/credito/reporteReferenciasBanc.js"></script> 
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos" target="_blank">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Referencia Dep. Bancario</legend>
         <table border="0" cellpadding="0" cellspacing="0" width="100%">		
        	 	<tr>
					<td class="label">
						<label for="creditoID">No. Crédito: </label>
					</td> 
					<td >
						<form:input id="creditoID" name="creditoID" path="creditoID" size="10" tabindex="1"  />
					</td>  	
				</tr>		
         		<tr>
					<td class="label">
						<label for="Cliente"><s:message code="safilocale.cliente"/>: </label>
					</td> 
					<td >
						<form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="2" readOnly="true"/>
						<input type="text" id="nombreCliente" name="nombreCliente" tabindex="3" readOnly="true"size="40"/> 
					</td>	
				</tr>
			
			</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td >

									<a id="ligaGenerar" href="reporteReferencias.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "10" value="Generar" />
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