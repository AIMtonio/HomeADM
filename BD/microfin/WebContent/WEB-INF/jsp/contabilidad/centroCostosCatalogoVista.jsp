<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazasServicio.js"></script>      
 	   <script type="text/javascript" src="js/contabilidad/centroCatalogo.js"></script>  

</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="centro">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Centro de Costos</legend>	
<table border="0" cellpadding="0" cellspacing="0" width="950px">
<tr>
      <td class="label"> 
         <label for="centroCostoID">Número: </label> 
     </td>
     <td>
			<form:input id="centroCostoID" name="centroCostoID" path="centroCostoID" size="10" tabindex="1" iniforma="false" /> 
     </td> 
     <td class="separador"></td>
     <td class="label"> 
         <label for="descripcion">Descripción: </label> 
     </td> 
     <td> 
        <form:input id="descripcion" name="descripcion" path="descripcion" size="35" tabindex="2" onBlur=" ponerMayusculas(this)"/> 
     </td> 
		
 </tr> 
 <tr> 
     <td class="label"> 
          <label for="responsable">Responsable: </label> 
     </td> 
     <td> 
       <form:input id="responsable" name="responsable" path="responsable" size="40" tabindex="3" onBlur=" ponerMayusculas(this)"/>
     </td>
     <td class="separador"></td>
     <td class="label"> 
          <label for="plazaID">Plaza: </label> 
     </td> 
     <td> 
       <form:input id="plazaID" name="plazaID" path="plazaID" size="7" tabindex="4" />
       <input type="text" id="descriPlaza" name="descriPlaza" size="30" tabindex="5" disabled="true"
				 readOnly="true"/>
     </td>
  </tr>  
 </table>
  </fieldset>
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
<div id="mensaje" style="display: none;position:absolute; z-index:999;"/ -->
</html>

  

