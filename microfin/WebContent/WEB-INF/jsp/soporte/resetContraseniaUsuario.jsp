<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
         <script type="text/javascript" src="js/soporte/resetPassUsuario.js"></script>                 
       
		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="resetContraUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Reseteo de Contrase&ntilde;a de Usuarios</legend>
	
<table cellpadding="0" cellspacing="0" border="0" width="950px">

	<tr>
		<td class="label">
			<label for="usuarioID">Número: </label>
		</td>
		<td >
			<form:input id="usuarioID" name="usuarioID" path="usuarioID"  size="7" tabindex="1"/> 
		 
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="nombre">Nombre:</label>
		</td>
		<td>
			<form:input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="40" tabindex="2" 
			onBlur=" ponerMayusculas(this)" readOnly="true"/>
		</td>		
	</tr>

	<tr>
		<td class="label">
			<label for="clave">Clave: </label>
		</td>
		<td >
			<form:input value1='<%= request.getParameter("clave") %>' id="clave" name="clave" path="clave" tabindex="5" readOnly="true" />		
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="contrasenia">Nueva Contrase&ntilde;a:</label>
		</td>
		<td>
			<form:password id="contrasenia" name="contrasenia" path="contrasenia" size="20" tabindex="6" autocomplete="new-password"/>
		</td>
	</tr>
	
	<tr>
		<td>
		</td>
		<td>
		</td>
		<td>
		</td>
		<td class="label">
			<label for="confirmarContra">Confirmar Contrase&ntilde;a:</label>
		</td>
		<td>
			<form:password id="confirmarContra" name="confirmarContra" path="confirmarContra" size="20" tabindex="6" autocomplete="new-password"/>
		</td>
			
	</tr>	
	
	
	

	<tr>
		<td class="label">
			<label for="fechUltAcces">Fecha de Último Acceso:</label>
		</td>
		<td>
			<form:input id="fechUltAcces" name="fechUltAcces" path="fechUltAcces" size="20" tabindex="13" 
			disabled="true" readOnly="true"/>
		</td>	
		<td class="separador"></td>	
		<td class="label">
			<label for="fechUltPass">Fecha del Último Password: </label>
		</td>
		<td >
			<form:input id="fechUltPass" name="fechUltPass" path="fechUltPass" size="20" tabindex="14" 
			disabled="true" readOnly="true"/>  
		</td>
	</tr>

</table>
	 <table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="actualizar" name="actualizar" class="submit" value="Actualizar"/>
						<input type="button" id="Continuar" name="Continuar" class="submit" value="Continuar"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
				</tr>
		</table>	
			<br>	
		<table id="reglas de pass">
		 <tr>
			<td class="label">
			<DIV class="label"><label id="mensajeLabel"></label>
			</DIV>
			</td>
		</tr>
		</table>
</fieldset>
</form:form>

  
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<c:set var="varUs" value="<%= request.getParameter(\"user\") %>"/>
<c:if test="${varUs!=''}"> 
		<script type="text/javascript"> 
		
		var val1 = "<%= request.getParameter("user") %>"; 
		document.getElementById('usuarioID').value = val1;
		</script> 
		</c:if> 
	<c:if test="${varUs==null}"> 
		<script type="text/javascript"> 
		$('#Continuar').hide();
		document.getElementById('usuarioID').value = '';
		</script>
	</c:if>  
</body>
<div id="mensaje" style="display: none;"/>
</html>