 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/plazasServicio.js"></script>   
 	   <script type="text/javascript" src="js/soporte/plazasCatalogo.js"></script>  

</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="plaza">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Plazas</legend>	
<table border="0"  width="950px">
<tr>
      <td class="label"> 
         <label for="plazaID">Número: </label> 
     </td>
     <td>
			<form:input id="plazaID" name="plazaID" path="plazaID" size="10" tabindex="1" iniforma="false" /> 
     </td> 
		<td class="separador"></td>
     <td class="label"> 
         <label for="nombre">Nombre: </label> 
     </td> 
     <td> 
        <form:input id="nombre" name="nombre" path="nombre" size="35" tabindex="2" maxlength='100' /> 
     </td> 
 </tr> 
 <tr> 
     <td class="label"> 
          <label for="plazaCLABE">CLABE: </label> 
     </td> 
     <td> 
       <form:input id="plazaCLABE" name="plazaCLABE" path="plazaCLABE" tabindex="3" maxlength='3' />
     </td> 
  </tr>  
 </table>

		<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agregar" tabindex="4"/>
							<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modificar" tabindex="4"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
</body>
<div id="mensaje" style="display: none;position:absolute; z-index:999;"/ -->
</html>