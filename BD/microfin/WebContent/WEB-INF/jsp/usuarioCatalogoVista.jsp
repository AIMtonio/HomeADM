<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		  <link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  > 
      	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />    
		  
        <script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
        <script type='text/javascript' src='js/jquery.validate.js'></script>
        <script type="text/javascript" src="js/jquery.blockUI.js"></script> 
            
       <script type='text/javascript' src='js/jquery-ui-1.8.13.custom.min.js'></script>
		 <script type='text/javascript' src='js/jquery-ui-1.8.13.min.js'></script>
        
        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>                                                                       
        <script type="text/javascript" src="dwr/util.js"></script>    
        
 		<script type="text/javascript" src="js/forma.js"></script>
        <script type="text/javascript" src="js/usuarioCatalogo.js"></script>                    
       
		
	</head>
<body>
<div id="encabezadoOpcion" ></div>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="usuario">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Usuarios</legend>
	
<table cellpadding="0" cellspacing="0" border="0" width="950px">
	<tr>
		<td class="label">
			<label for="numero">Numero: </label>
		</td>
		<td >
			<form:input id="numero" name="numero" path="numero" size="7" tabindex="1" />
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="nombre">Nombre:</label>
		</td>
		<td>
			<form:input id="nombre" name="nombre" path="nombre" tabindex="2"/>
		</td>		
	</tr>

	<tr>
		<td class="label">
			<label for="clave">Clave: </label>
		</td>
		<td >
			<form:input id="clave" name="clave" path="clave" tabindex="3"/>		
		</td>
		<td class="separador"></td>
		<td class="label">
			<label for="contrasenia">Contrase&ntilde;a</label>
		</td>
		<td>
			<form:password id="contrasenia" name="contrasenia" path="contrasenia" tabindex="4"/>
		</td>		
	</tr>
	
	<tr>
		<td colspan="5">
		<table align="center">
				<tr>
				
				 <td align="center">
						<td><img src="./jcaptcha">
						<input type="text" name="j_captcha_response" id="j_captcha_response" value='' tabindex="5">
						<div id="resultadoCapt"></div>
					</td>
				</tr>
			</table>	
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega"/>
						<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
	
</table>
</fieldset>
</form:form>

<!-- <form action="./register" method="post">&nbsp;  
	<img src="./jcaptcha">
<input type='text' name='j_captcha_response' value=''>
   <input type="submit" value="Submit" />
  </form> -->
  
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
