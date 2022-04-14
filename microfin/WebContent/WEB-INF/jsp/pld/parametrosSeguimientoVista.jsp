<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>

	<head>	
	     
 	  
 	   <script type="text/javascript" src="dwr/interface/paramSegtoServicio.js"></script>  	   													  
 	    <script type="text/javascript" src="js/pld/paramSeguimiento.js"></script>  
 	     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosegoper">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Parametros de Seguimiento</legend>
					
			
		 
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"> 
			         	<label for="lbltp">Tipo Persona: </label> 
					   	</td>
					   	<td>
					     <form:select id="tipoPersona" name="tipoPersona"  path="tipoPersona" tabindex="1" type="select">
							<form:option value="0">Seleccionar</form:option> 
							<form:option value="F">FISICA</form:option>
							<form:option value="M">MORAL</form:option>
						</form:select>
					   </td>	 
				   	   <td class="separador"></td>
				   	   <td class="label"> 
		         		<label for="lbltipIn">Tipo Instrumento: </label> 
		     			</td> 
		     			<td> 
		     			<form:select id="tipoInstrumento" name="tipoInstrumento"  path="tipoInstrumento" tabindex="2" type="select">
							<form:option value="0">Seleccionar</form:option> 
							<form:option value="1">EFECTIVO</form:option>
							<form:option value="2">DOCUMENTOS</form:option>
							<form:option value="3">CREDITO</form:option>
						</form:select>
		     		</td>   
				  	
				</tr>
				<tr>
					<td class="label"> 
		         	<label for="lblnacMon">Nacionalidad <s:message code="safilocale.cliente"/>: </label> 
				   	</td> 
				   	<td>
				    	<form:select id="nacCliente" name="nacCliente"  path="nacCliente" tabindex="3" type="select">
							<form:option value="0">Seleccionar</form:option> 
							<form:option value="N">NACIONAL</form:option>
							<form:option value="E">EXTRANJERA</form:option>
						</form:select>
				   </td> 
				   <td class="separador"></td>   
				   <td class="label"> 
			       		<label for="lbltp">Nivel Seguimiento: </label> 
				   </td>
				   <td>
					     <form:select id="nivelSeguimien" name="nivelSeguimien"  path="nivelSeguimien" tabindex="4" type="select">
							<form:option value="0">Seleccionar</form:option>  
							<form:option value="1">1</form:option>
							<form:option value="2">2</form:option>
						</form:select>
				  </td>
				  
				</tr>
				
				<tr>
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
				</tr>

				<tr>
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
				</tr>
				
				<tr>
				   <td class="label"> 
		         		<label for="lbllimite">Monto Inferior: </label> 
		     	   </td> 
		     	   <td> 
						<form:input id="montoInferior" name="montoInferior" path="montoInferior" size="11" tabindex="5" esMoneda="true" type="text"/>					
		     		</td> 
				<td class="separador"></td> 
			 
				   <td class="label"> 
		           	<label for="lblnacMon"> Moneda de Comparaci&oacute;n: </label> 
				   </td>
				   <td>
				     <form:select id="monedaComp" name="monedaComp"  path="monedaComp" tabindex="6" type="select">
						<option value="0">Seleccionar</option>
						<option value=1>PESOS</option>
						<option value="2">DOLARES AMERICANOS</option>
						<option value="3">EUROS</option>
					</form:select>
				   </td>
				   
				</tr>
					
		     	</table>
		  	    <br>
				<br>
		     	<table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega" tabindex="7" />
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica" tabindex="8" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>				
								</td>
							</tr>
						</table>		
					</td>
				</tr>	
			 </table>
</form:form>


	</div>
</fieldset>

</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>