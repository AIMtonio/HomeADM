<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
	 	<script type="text/javascript" src="js/soporte/menuAplicacion.js"></script>
 		<script type="text/javascript" src="js/soporte/cambioPassUsuario.js"></script>
		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cambioContraUsuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cambio de Contrase&ntilde;a de Usuarios</legend>
	
<table cellpadding="0" cellspacing="0" border="0" width="950px" style="text-align: left;">
	<tr>
		<td class="label">
			<label for="usuarioID">N&uacute;mero: </label>
		</td>
		<td>
			<form:input id="usuarioID" name="usuarioID" path="usuarioID"  size="7" tabindex="1" readOnly="true"/> 
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
		<td class="separador"></td>
		<td class="separador"></td>	
	</tr>
	<tr>
		<td class="label">
			<label for="contrasenia">Nueva Contrase&ntilde;a:</label>
		</td>
		<td>
			<input type="password" id="nuevaContra" name="nuevaContra" size="20" tabindex="6" autocomplete="new-password"/>
		</td>	
		<td class="separador"></td>	
		<td class="label">
			<label for="contrasenia">Confirma Contrase&ntilde;a:</label>
		</td>
		<td>
			<input type="password" id="Confirmacontra" name="Confirmacontra"  size="20" tabindex="6" autocomplete="new-password" />
		</td>	
	</tr>
</table>
<table style="text-align: right;" width="950px">
	<tr align="right">
		<td align="right">
			<input type="submit" id="actualizar" name="actualizar" class="submit" value="Actualizar" tabindex="7"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
		</td>
	</tr>
</table>	
<br>	
<table id="reglas de pass" style="text-align: left;">
<tr>
	<td class="label" >
		<DIV class="label">
			<label id="mensajeLabel"> </label>
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
	<div id="elementoLista"></div>
</div>

<c:set var="varUs" value="<%= request.getParameter(\"user\") %>"/>
<c:if test="${varUs!=''}"> 
	<script type="text/javascript"> 
		var val1 = "<%= request.getParameter("user") %>"; 
		document.getElementById('usuarioID').value = val1;
		consultaUsuario('usuarioID');
		
		function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var usuarioBeanCon = {
  				'usuarioID':numUsuario
				};
		var catTipoConsultaUsuario = 5;
		var cancelado ='C';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario)){
			usuarioServicio.consulta(catTipoConsultaUsuario,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					$('#nombreCompleto'). val(usuario.nombreCompleto);
					$('#clave'). val(usuario.clave);
					$('#fechUltAcces'). val(usuario.fechUltAcces);
					$('#fechUltPass'). val(usuario.fechUltPass);
					var estatu = usuario.estatus;
					if(estatu == cancelado){
						alert('El usuario ya esta Cancelado');
						deshabilitaBoton('actualizar', 'submit');
					}
					$('#nuevaContra').focus();
				}else{
					alert("No Existe el Usuario");
					inicializaForma('formaGenerica', 'UsuarioID');
				}
			});
			}
		}
	</script>
</c:if> 
<c:if test="${varUs==null}"> 
	<script type="text/javascript"> 
		$('#Continuar').hide();
		document.getElementById('usuarioID').value = '';
	</script>
</c:if>  
</body>
<div id="mensaje" style="display: none;"></div>
<script type="text/javascript" >
	
</script>
</html>
