<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>   
		<script type="text/javascript" src="dwr/interface/tipoInstrumServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramEscalaServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/escalaSolServicio.js"></script> 
		<script type="text/javascript" src="js/pld/parameEscalamiento.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosEscala">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros de Escalamiento Ingresos de Operaciones</legend>
					
			
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
					<td class="label"> 
		         	<label for="lbltp">Tipo Persona: </label> 
				   </td>
				   <td>
				     <form:select id="tipoPersona" name="tipoPersona"  path="tipoPersona" tabindex="1">
						<form:option value="0">SELECCIONAR</form:option> 
						<form:option value="F">FISICA</form:option>
						<form:option value="M">MORAL</form:option>

					</form:select>
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lbltipIn">Tipo Instrumento: </label> 
		     		</td> 
		     		<td> 
		     		<form:select id="tipoInstrumento" name="tipoInstrumento"  path="tipoInstrumento" tabindex="2">
						<form:option value="0">SELECCIONAR</form:option> 
						<form:option value="1">EFECTIVO</form:option>
						<form:option value="2">DOCUMENTOS</form:option>
						<form:option value="3">CREDITO</form:option>
					</form:select>
		     		</td> 
				</tr>
				<tr>
					<td class="label"> 
		         	<label for="lblnacMon">Nacionalidad del <s:message code="safilocale.cliente"/>: </label> 
				   </td>
				   <td>
				     <form:select id="nacMoneda" name="nacMoneda"  path="nacMoneda" tabindex="3">
						<form:option value="0">SELECCIONAR</form:option> 
						<form:option value="N">NACIONAL</form:option>
						<form:option value="E">EXTRANJERA</form:option>
					</form:select>
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lbllimite">Limite Inferior: </label> 
		     		</td> 
		     		<td> 
						<form:input id="limiteInferior" name="limiteInferior" path="limiteInferior" size="18" tabindex="4"
							esmoneda="true" maxlength="18" style="text-align: right"/>					
		     		</td> 
				</tr>
				
				<tr>
					<td class="label"> 
		         	<label for="lblnacMon"> Moneda de Comparaci&oacute;n: </label> 
				   </td>
				   <td>
				     <form:select id="monedaComp" name="monedaComp"  path="monedaComp" tabindex="5">
						<option value="0">SELECCIONAR</option>
						<option value=1>PESOS</option>
						<option value="2">DOLARES AMERICANOS</option>
						<option value="3">EUROS</option>
					</form:select>
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lblusuarioTit">Titular: </label> 
		     		</td> 
		     		<td> 
						<form:input id="rolTitular" name="rolTitular" path="rolTitular" size="7" tabindex="6"/>				
						<input type="text" id="desTitular" name="desTitular"  size="30" tabindex="7" disabled="true" />		
		     		</td> 
				</tr>
				
				<tr>
					<td class="label"> 
		         	<label for="lblusuaSuplente"> Suplente: </label> 
				   </td>
				   <td>
				    <form:input id="rolSuplente" name="rolSuplente" path="rolSuplente" size="7" tabindex="8"/>	
				    <input type="text" id="desSuplente" name="desSuplente"  size="30" tabindex="9" disabled="true" />		
				    
				   </td>
				   <td class="separador"></td> 
				
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
									<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="10"/>
									<input type="submit" id="modificar" name="modificar" class="submit"  value="Modificar" tabindex="11"/>
									<input type="submit" id="historico" name="historico" class="submit"  value="Hist&oacute;rico" tabindex="12"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				    				<form:input type="hidden" id="folioID" name="folioID" path="folioID" size="7"/>
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