<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>
			
	<script type="text/javascript" src="dwr/interface/actividadesFRServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/actividadesFomurServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>                                                                                                                                                
      <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>  
      <script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>                                                                                                                                                                                                                                                                                           
      <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>        	  
 	  <script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>  	  
 	  <script type="text/javascript" src="dwr/interface/negocioAfiliadoServicio.js"></script>  	   	   
 	  <script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/tiposPuestosServicio.js"></script> 
 	  <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/catUbicaNegocioServicio.js"></script>
 	  
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>
	    <script type="text/javascript" src="js/cliente/clienteCatalogo.js"></script>
     
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="fiscales">

<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Actualizaci&oacute;n IVA, ISR, IDE</legend>
			
<table border="0"  width="100%">
	<tr>
		<td class="label" nowrap="nowrap">
		<label for="numero">N&uacute;mero de <s:message code="safilocale.cliente"/>: </label>
		</td>
		<td >
			<form:input id="clienteIDf" name="clienteIDf" path="numero" size="12" tabindex="1" />
			 <input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" 
          readOnly="true"/>  
		</td>
		<td class="separador"></td>
		<td class="label" nowrap="nowrap">
		<label for="pagaIVA">Paga IVA:</label>
			</td>
			<td>
				<form:select id="pagaIVA" name="pagaIVA" path="pagaIVA" tabindex="3">	
				<form:option value="">SELECCIONAR</form:option>	
				<form:option value="S">Si Paga</form:option>
			  	<form:option value="N">No Paga</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="pagaISR">Paga ISR: </label>
			</td>
			<td >
				<form:select id="pagaISR" name="pagaISR" path="pagaISR" tabindex="4">
				<form:option value="">SELECCIONAR</form:option>
				<form:option value="S">Si Paga</form:option>
			   <form:option value="N">No Paga</form:option>
				</form:select>
			</td>	
			<td class="separador"></td>
			<td class="label" nowrap="nowrap">
				<label for="pagaIDE">Paga IDE: </label>
			</td>
			<td >
				<form:select id="pagaIDE" name="pagaIDE" path="pagaIDE" tabindex="5">
				<form:option value="">SELECCIONAR</form:option>
				<form:option value="S">Si Paga</form:option>
			 	<form:option value="N">No Paga</form:option>
				</form:select>
			</td>
		</tr>
		</table>
		
		<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="actualiza" name="actualiza" class="submit" 
							 value="Actualizar" tabindex="6"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
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
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>