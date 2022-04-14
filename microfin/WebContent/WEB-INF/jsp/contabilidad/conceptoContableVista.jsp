<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>	
   	<script type="text/javascript" src="dwr/interface/conceptoContableServicio.js"></script>        
	   <script type="text/javascript" src="js/contabilidad/conceptoContable.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conceptoContable">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Conceptos Contables</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="conceptoContableID">Numeros: </label>
			</td> 
			<td >
				<form:input id="conceptoContableID" name="conceptoContableID" path="conceptoContableID"
								size="5" tabindex="1" iniForma = 'false' />
			</td>			
			<td colspan="3"></td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="descripcion">Descripcion: </label>
			</td> 
			<td >
				<form:input id="descripcion" name="descripcion" path="descripcion"
								size="60" maxlength="150" tabindex="2" />
			</td>
			<td colspan="3"></td>			
		</tr>	
	</fieldset>		 
		<tr>
			<td colspan="5">
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agrega" tabindex="3"/>
							<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modifica" tabindex="4"/>
							<input type="submit" id="elimina" name="elimina" class="submit" 
							 value="Elimina" tabindex="5"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form:form> 
</div> 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
<html>