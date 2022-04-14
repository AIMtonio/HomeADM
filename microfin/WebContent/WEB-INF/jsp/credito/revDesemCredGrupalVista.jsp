<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      
      <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/creditosMovsServicio.js"></script>     
      <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/integraGruposServicio.js"></script> 								
	  <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	  <script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
	  
      <script type="text/javascript" src="js/credito/revDesemCredGrupal.js"></script>  
				
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="revDesCredGrupalBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reversa de Desembolso de Cr&eacute;dito Grupal</legend>
	<table border="0"  width="100%">
		
		<tr>
			<td class="label">
				<label for="lblGrupo">Grupo: </label>
			</td> 
			<td >
				<form:input id="grupoID" name="grupoID" path="grupoID" size="12" tabindex="1"  />
				<input type="text" id="grupoDes" name="grupoDes"  size="40" tabindex="2" disabled="true" readonly="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblCiclo">Ciclo Actual: </label>
			</td> 
			<td>
				<input type="text" id="cicloID" name="cicloID"  size="20" tabindex="3" disabled="true" readonly="true"/>
			</td>			
		</tr>
		<tr>
			<td class="label">
				<label for="lblProducto">Producto de Crédito: </label>
			</td> 
			<td >
				<form:input type ="text" id="producCreditoID" name="producCreditoID"  path ="producCreditoID" size="12" tabindex="4" disabled="true" readonly="true" />
				<input type="text" id="descripProducto" name="descripProducto"  size="40" tabindex="5" disabled="true" readonly="true" type ="text" />
			</td>		
				<td class="separador"></td>
				<td class="label">
				<label for="lblEstatus">Estatus: </label>
			</td> 
			<td >
				<input type="text" id="estatus" name="estatus"  size="20" tabindex="6" disabled="true" readonly="true" />
			</td>			
		</tr>	
		<tr>
			<td class="label">
				<label for="usuarioA">Usuario Autoriza: </label>
			</td>
			<td >
				<form:input type="text" id="usuarioAutorizaID" name="usuarioAutorizaID" size="25" path="usuarioAutorizaID" tabindex="7" autocomplete = "off" />
			</td>
			<td class="separador"></td>
				<td class="label"> 
	    		<label for="pass">Contraseña:</label>				      	 
	  		</td> 
	    	<td> 
	    		<form:input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza" path="contraseniaUsuarioAutoriza" value="" tabindex="8" autocomplete="new-password" />
	    	</td>	
		</tr>	
		<tr>
			<td class="label">
				<label for="mot">Motivo: </label>
			</td>
			<td >
				<form:textarea id="motivo" name="motivo" rows="3" cols="50" path="motivoReversa" size="18" maxlength ="400"	tabindex="9" type="text" />
			</td>					
		</tr>
	
	</table>
		<br>
		<br>
	    <input type="hidden" id="integrantes" name="integrantes" size="100" />	
		<div id="Integrantes" style="width: 900px; height: 320px; overflow-y: scroll; display: none;" ></div>	
		<br>
		<br>
	
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
		<tr>
			<td align="right">
				<input type="submit" id="aceptar" name="aceptar" class="submit"	 tabIndex = "22" value="Aceptar" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="listaReversaDes" name="listaReversaDes"  />
				
			</td>
		</tr>
	</table>
</fieldset>
</form:form>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
