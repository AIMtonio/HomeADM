<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>	
	 	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
 		<script type="text/javascript" src="js/soporte/usuarioSesion.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario" >  
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Sesiones Activas</legend>
			
			<div id="gridSesionesActivas" overflow-y="scroll" >
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
			
				
			<table  id="sesionesActivas" border="0" cellpadding="2" cellspacing="0" width="100%" onBlur="ponerMayusculas(this)" >
			
			 	<tr>
			 		<td><label>No. de Usuario</label> </td>
			 		<td><label>Sucursal</label></td>
			 		<td><label>Clave</label></td>
			 		<td><label>Nombre Completo</label></td>
			 		<td><label>Estatus</label></td>
			 		<td><input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onclick="selecTodoCheckout(this.id)"/></td>
			 		<td><label>Todos</label>
		
					</td>
			 	</tr>
			 	
			 </table>
	
			  <table align="right">
				<tr>
					<td align="right">
						<input type="button" id="limpiar" name="limpiar" class="submit" value="Limpiar"/>
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