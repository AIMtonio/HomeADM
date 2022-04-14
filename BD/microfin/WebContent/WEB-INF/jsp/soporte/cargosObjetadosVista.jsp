<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	
	<script type="text/javascript" src="js/soporte/cargosObjetados.js"></script>
	<script type="text/javascript" src="dwr/interface/edoCtaPeriodoEjecutadoServicio.js"></script>  	 	
	
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Cargos Objetados en el Periodo</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargosBean"
					  target="_blank">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr> 
				<td>
					<label for="lblanio">A&ntilde;o: </label>
				
					<select name="anio" id="anio" tabindex="1">
					</select>
				</td>

				<td nowrap="nowrap">
					<label for="lblmes">Mes: </label>
					<select name="mes" id="mes" tabindex="2">
						<option value="01">ENERO</option>
						<option value="02">FEBRERO</option>
						<option value="03">MARZO</option>
						<option value="04">ABRIL</option>
						<option value="05">MAYO</option>
						<option value="06">JUNIO</option>
						<option value="07">JULIO</option>
						<option value="08">AGOSTO</option>
						<option value="09">SEPTIEMBRE</option>
						<option value="10">OCTUBRE</option>
						<option value="11">NOVIEMBRE</option>
						<option value="12">DICIEMBRE</option>
					</select>
				</td>
				
			</tr>
           
			<tr>
				  <td class="label"> 
		         		<label for="lblPeriodo">Periodo:</label> 
					</td> 	
		     		<td> 
		   
		         		<input type="text" id="periodo" name="periodo"size="20" readOnly= "true"  disabled="true"/>
		     		</td>
		     	
			</tr>
			<tr>
					<td class="label"> 
		         		<label for="lblLayout">Layout:</label> 
					</td> 	
		     		<td> 
		   
		         		<input type="text" id="layout" name="layout"size="50" readOnly= "true"  disabled="true"/>
		     		</td>
		     		<td align="right">
					<input type="button" id="enviar" name="enviar" tabindex="3" class="submit" tabindex="5" value="Adjuntar" /> 
		     	
		   </tr>
		
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
								
										 
										 <input type="submit" id="grabar" name="grabar" class="submit" 
												 tabIndex = "4" value="Grabar" />
										 <input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									
									</td>
								</tr>
							</table>		
						</td>
					</tr>					
				</table>
			

		</form:form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
	
</div>
<div id="cargando" style="display: none;"></div>	
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"></div>


</body>
</html>