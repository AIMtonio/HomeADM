<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/ejercicioContableServicio.js"></script>
	   <script type="text/javascript" src="js/contabilidad/periodoContable.js"></script>
	   <script type="text/javascript" src="js/utileria.js"></script>
	</head>
<body>

<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Ejercicio Contable</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ejercicioContable">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="inicioEjercicio">Inicio del Ejercicio: </label>
			</td> 
			<td><form:input type="text" name="inicioEjercicio" id="inicioEjercicio"
								 path="inicioEjercicio" autocomplete="off" esCalendario="true"
								 size="12" tabindex="1" />						
			</td>
			<td class="separador"></td>			
		   <td class="label">
				<label for="tipoEjercicio">Tipo de Ejercicio: </label>
			</td> 
		   <td >
			 	<form:select id="tipoEjercicio" name="tipoEjercicio" path="tipoEjercicio" tabindex="2">
					<form:option value="S">Semestral</form:option>
		     		<form:option value="A">Anual</form:option>
		     		<form:option value="B">Bienal</form:option>
					<form:option value="T">Trienal</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="finEjercicio">Fin de Ejercicio: </label>
			</td> 
			<td><form:input type="text" name="finEjercicio" id="finEjercicio"
								 path="finEjercicio" autocomplete="off" esCalendario="true"
								 size="12" tabindex="3" />						
			</td>
			<td class="separador" colspan="3">
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="tipoPeriodo">Tipo de Periodos: </label>
			</td> 
			<td>
			 	<form:select id="tipoPeriodo" name="tipoPeriodo" path="tipoPeriodo" tabindex="4">
					<form:option value="M">Mensual</form:option>
		     		<form:option value="B">Bimestral</form:option>
		     		<form:option value="T">Trimestral</form:option>
				</form:select>			
			</td>
			<td class="separador" colspan="3">
			</td>
		</tr>
		<input type="hidden" size="70" name="listPeriodoIni" id="listPeriodoIni"/>
		<input type="hidden" size="70" name="listPeriodoFin" id="listPeriodoFin"/>
		
			 
		<tr>
			<td colspan="5">
				<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="Periodos" name="Periodos" class="submit" value="Periodos"
							tabindex="5"/>
						</td>					
						<td align="right">
							<input type="submit" id="Graba" name="Graba" class="submit" value="Graba" tabindex="6"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div id="miTabla"><div/>
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