<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
 	   <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/paramOpRelServicio.js"></script>   
 	    <script type="text/javascript" src="dwr/interface/tipoInstrumServicio.js"></script>
 	    <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
 	    <script type="text/javascript" src="js/pld/paramOpeRel.js"></script>        
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosOpRel">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Operaciones Relevantes</legend>
					
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend >L&iacute;mite de Operaciones Relevantes</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
								<td class="label"> 
					         		<label for="lblmoneda">Moneda: </label> 
							   </td>
							   <td>
								<form:select id="monedaLimOPR" name="monedaLimOPR" path="monedaLimOPR" tabindex="1" type="select">
										<form:option value="">SELECCIONAR</form:option>
								</form:select>
							   </td>
							   <td class="separador"></td> 
							   <td class="label"> 
					         		<label for="lbllimiteInferior">L&iacute;mite Inferior: </label> 
					     		</td> 
					     		<td> 
					         		<form:input id="limiteInferior" name="limiteInferior" path="limiteInferior" size="20" tabindex="2" esMoneda="true" style="text-align:right;" maxlength="13"/>
					     		</td> 
						</tr>
				   </table>
				  	    <br>
						<br>
				</fieldset>
		<br>
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend >L&iacute;mites de Operaciones de Microcr&eacute;dito</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="label"> 
				         		<label for="lblmoneda">Moneda: </label> 
						   </td>
						   <td>
								<form:select id="monedaLimMicro" name="monedaLimMicro" path="monedaLimMicro" tabindex="3" type="select">
										<form:option value="">SELECCIONAR</form:option>
								</form:select>
						   </td>
						   <td class="separador"></td> 
						   <td class="label"> 
				         		<label for="lbllimiteInferior">L&iacute;mite Mensual: </label> 
				     		</td> 
				     		<td> 
				         		<form:input id="limMensualMicro" name="limMensualMicro" path="limMensualMicro" size="20" tabindex="4" esMoneda="true" style="text-align:right;" maxlength="13"/>
				     		</td> 
				     				     		
						</tr>
				</table>
				 <br>
				 <br>   	
			</fieldset>
		<br>
			<table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="grabar" name="grabar" class="submit"  value="Grabar" tabindex="9"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		
											<input type="submit" id="verhistorico" name="verhistorico" class="submit"  value="Ver Histórico" tabindex="10"/>
											
										</td>
									</tr>
								</table>		
							</td>
						</tr>	
			 </table>
			 </fieldset>
</form:form>
<br>
	</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>