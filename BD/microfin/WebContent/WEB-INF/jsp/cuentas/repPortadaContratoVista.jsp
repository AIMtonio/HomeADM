<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>
		<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />      
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
     	<script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>	
     	<script type="text/javascript" src="dwr/engine.js"></script> 
      <script type="text/javascript" src="dwr/util.js"></script>
      <script type="text/javascript" src="js/forma.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   <script type="text/javascript" src="js/cuentas/portadaContratoCta.js"></script> 	 	
 	</head>   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ctasPersonaBean" target="_blank">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Portada del Contrato de Cuenta</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="950px">
				<tr> 
		     		<td class="label"> 
		         	<label for="lblCuentaAhoID">Cuenta: </label> 
				   </td>
				   <td>
				      <form:input id="cuentaAhoID" name="cuentaAhoID"  path="cuentaAhoID" size="13" tabindex="1"/>  
				   </td>  
		         <td class="separador"></td> 				
				   <td class="label"> 
		         	<label for="lblTipoCuenta">Tipo Cuenta: </label> 
				   </td>
				   <td>
				      <input id="tipoCuenta" name="tipoCuenta"  size="30" tabindex="2" readOnly="true" disabled = "true"/>  
				   </td>  
		 		</tr> 
			
				<tr>
					<td class="label"> 
		         	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     		</td> 
		     		<td> 
		         	<input id="clienteID" name="clienteID" size="11" tabindex="4" readOnly="true" disabled = "true"/>
		         	<input id="nombreCte" name="nombreCte"size="40" type="text" tabindex="5" 
		         		readOnly="true" disabled = "true"/>
		     		</td>
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         	<td class="label"> 
							<label for="tipoPersona">Tipo Persona: </label> 
						</td>
						<td class="label"> 
							<input type="radio" id="tipoPersona" name="tipoPersona" 
							 value="F" tabindex="4"  />
							<label for="fisica">Fisica</label>
							&nbsp&nbsp;
							<input type="radio" id="tipoPersona2" name="tipoPersona2" 
							 value="M" tabindex="5"/>
							<label for="fisica">Moral</label>
							
							
						</td>			
		 		</tr> 
				
		</table>
		<table align="right">
			<tr>
				<td align="right">
				<a id="liga" href="AnexoPortadaContratoCtaPM.htm" target="_blank" >
             <button type="button" class="submit" id="anexo" style="display: none;">
              Anexo
              </button>
            </a>
       	 <input type="submit" id="imprimir" name="imprimir" class="submit" value="Imprimir" />  
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