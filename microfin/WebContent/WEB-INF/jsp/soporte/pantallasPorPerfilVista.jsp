<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
        <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>  
        <script type="text/javascript" src="js/soporte/pantallasPorPerfil.js"></script>                   
       
		
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opcionesRol">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Pantallas por Perfil</legend>
	
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
      <td class="label"> 
         <label for="rolID">Rol: </label> 
     </td>
     <td>
			<form:input id="rolID" name="rolID" path="rolID" size="10" tabindex="1" iniforma="false" /> 
			<input id="descripcion" name="descripcion" tabindex="3" size="50"/>
     </td> 
		<td class="separador"></td>
		<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar"/>

						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>
 </tr> 
 </table>
<table  >
<tr>
<td> <label for="rolID">Seleccionar todas: </label> </td>
<td>  <input class="check" type="checkbox" id="selecTodas" value="0" name="selecTodas" />
							</td>
</tr>
</table> 
 
 </fieldset>
 <br>

 	<c:set var="listaResultado"  value="${listaResultado[0]}"/>				
 <table  id="mitabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
   			
		
				 	<tr>
				 				
						<td >
							<div id="gridPantallaSelec" style="display: none;"/>							
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
</html>
<!--  //Nueva instalacion a kubo 1.1 -->