<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>

	<head>
	    <script type="text/javascript" src="dwr/interface/conceptoBalanzaServicio.js"></script> 
		 <script type="text/javascript" src="js/contabilidad/conceptoBalanza.js"></script>  
		
		</head>	
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conceptoBalanza">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas Agrupadoras</legend>	
<table border="0" cellpadding="0" cellspacing="0" width="950px">
<tr>
      <td class="label"> 
         <label for="conceptoBalanzaID">Cuenta Agrupadora: </label> 
     </td>
     
     <td>
			<form:input id="conBalanzaID" name="conBalanzaID" path="conBalanzaID" size="15" tabindex="1" iniforma="false"/> 
     </td>
		<td class="separador"></td>
		
      <td class="label"> 
         <label for="descripcion">Descripcion: </label> 
     </td>
     <td> 
        <form:input id="descripcion" name="descripcion" path="descripcion" size="70" tabindex="2" /> 
     </td>     
 </tr> 
  </table>
  </fieldset>
  
		<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" 
							 value="Agregar"/>
							<input type="submit" id="modifica" name="modifica" class="submit" 
							 value="Modificar"/>
							<input type="submit" id="elimina" name="elimina" class="submit" 
							 value="Eliminar"/>
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

  

