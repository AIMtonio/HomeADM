<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/esquemaQuinqueniosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/catQuinqueniosServicio.js"></script>                
		<script type="text/javascript" src="js/nomina/esquemaQuinquenios.js"></script>   
		   
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaQuinqueniosBean"> 
	<fieldset class="ui-widget ui-widget-content ui-corner-all">              
		<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Quinquenios</legend>            
		<table border="0"  width="100%">
			<tr>
		     <td class="label"> 
		         <label for="institNominaID">Empresa N&oacute;mina:</label> 
		     </td>
		     <td>
		         <input type="text" id="institNominaID" name="institNominaID"  size="12" tabindex="1" maxlength="13"  autocomplete="off"/>  
		     </td>
		     <td class="label"> 
		     	<input type="text" id="nombreInstit" name="nombreInstit" size="50"  disabled/>
		     </td>
		 	</tr>
		 	<tr>
		 	 <td class="label"> 
		         <label for="convenioNominaID">No Convenio:</label> 
		     </td> 
		     <td colspan="2"> 
		         <select id="convenioNominaID" name="convenioNominaID"  tabindex="2">
						<option value="">SELECCIONAR</option>
				</select>  
		     </td> 
		 	</tr>		
		</table>
		<br>

		<div id="contenedorEsquema" style="display: none;">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Esquemas</legend>
				<table border="0" cellpadding="0" cellspacing="5">
					<tr>
						<td>
							<input type="button" id="agregarEsquema" name="agregarEsquema" value="Agregar" class="submit" onclick="agregarNuevoRegistro()" tabindex="3"/>
						</td>
						<td class="separador">
					</tr>
				</table>
				<div id="formaTablaEsquema" style="display: none;"></div>
				<table border="0" width="100%">
					<tr>
						<td align="right">
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="100"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
				
		
	</fieldset>
</form:form>
	</div>

	<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>