<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
      <script type="text/javascript" src="dwr/interface/grupoMServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/opMenuServicio.js"></script> 
	   <script type="text/javascript" src="js/soporte/opcionMenuCatalogo.js"></script>

	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opciones">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Opciones del Menú</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="950px">
	<tr>
			<td class="label">
				<label for="num">N&uacute;mero: </label>
			</td> 
			<td >
				<form:input id="numero" name="numero" path="numero" size="7" tabindex="1"  />
				
			</td>
			
			<td class="separador"></td>
			
		   <td class="label">
			 <label for="Grupo">Grupo: </label>
			</td> 
		   <td >
			 	<form:input id="grupoMenu" name="grupoMenu" path="grupoMenu" size="7" tabindex="2"/>	 	
				<input type="text" id="nombreGrupo" name="nombreGrupo" size="30" tabindex="3" disabled="true"/>
			</td>					
		</tr>
		
		<tr>
			<td class="label">
				<label for="descripcion">Descripci&oacute;n: </label>
			</td> 
			<td >
				<form:input id="descripcion" name="descripcion" path="descripcion" size="50" tabindex="4"/>
			</td>
			
			<td class="separador"></td>
			
		   <td class="label">
			 <label for="Desplegado">Desplegado: </label>
			</td> 
		  	<td >
				<form:input id="desplegado" name="desplegado" path="desplegado" size="50" tabindex="5"/>
			</td>	
		</tr>
		<tr>
			<td class="label">
			<label for="Recurso">Recurso: </label> 
			</td>
		   <td >
			 	<form:input id="recurso" name="recurso" path="recurso" size="50" tabindex="6"/>

			</td>
			<td class="separador"></td>
			<td class="label">
			<label for="Orden">Orden: </label> 
			</td>
		   <td >
			 	<form:input id="orden" name="orden" path="orden" size="7" tabindex="7" disabled="true" readOnly="true"/>
			 	
			</td>
		</tr>
		<tr>
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
		</tr>
</table>
  </fieldset>		 
		<tr>
			<td colspan="5">
				<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agrega"/>
							<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modifica"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>		 
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
	