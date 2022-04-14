<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/ejercicioContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/ejercicioContableServicio.js"></script>
	   	<script type="text/javascript" src="js/contabilidad/periodoContableCierre.js"></script>
	</head>
<body>

<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Cierre Período Contable</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="periodoContableBean">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label" align="right">
				<label for="numeroEjercicio">Ejercicio: </label>
			</td> 
			<td align="left">
				<input type="text" name="finEjercicio" id="finEjercicio"
								 path="finEjercicio" autocomplete="off" size="12" tabindex="1" disabled="true" readOnly="true"/>
				<form:input type="hidden" name="numeroEjercicio" id="numeroEjercicio"
								 path="numeroEjercicio" autocomplete="off" size="3" tabindex="2" />											
			</td>
			<td class="separador"></td>			
		   <td class="label" align="right">
				<label for="numeroPeriodo">Período: </label>
			</td> 
		   <td align="left">
				<form:select id="numeroPeriodo" name="numeroPeriodo" path="numeroPeriodo" tabindex="3" >
					<form:option value="0">Selecciona</form:option>
				</form:select>	
			</td>
		</tr>
				 
		<tr>
			<td colspan="5">
				<table align="right">
					<tr>
						<td align="right">
                   			<input type="submit" id="cerrar" name="cerrar" class="submit" value="Cerrar" tabindex="6"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value='3'/>	
						</td>					
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form:form>
	</fieldset>
</div>
 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
<html>