<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>

	<head>
	<script type="text/javascript" src="dwr/interface/categoriasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/areasServicio.js"></script>
	 <script type="text/javascript" src="dwr/interface/puestosServicio.js"></script> 
	 <script type="text/javascript" src="js/gestionComercial/puestos.js"></script>  
		 
		</head>	
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="puestos">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Puestos</legend>	
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
      <td class="label"> 
         <label for="clavePuestoID">Clave: </label> 
     </td>
     
     <td>
			<form:input id="clavePuestoID" name="clavePuestoID" path="clavePuestoID" size="15" tabindex="1" iniforma="false"
							onBlur=" ponerMayusculas(this)" maxlength="10"/> 
     </td>
		<td class="separador"></td>
		
      <td class="label"> 
         <label for="descripcion">Descripci&oacute;n: </label> 
     </td>
     <td> 
        <form:input id="descripcion" name="descripcion" path="descripcion" size="70" tabindex="2"  onBlur=" ponerMayusculas(this)"/> 
     </td> 
      </tr>
       <tr>
        <td class="label"> 
          <label for="obligado">Atiende sucursal: </label> 
     </td>
          <td class="label">  
				<form:radiobutton id="atiende" name="atiende" path="atiendeSuc"
			 	value="S" tabindex="3" checked="checked"  />
			<label for="si">Si</label>
				<form:radiobutton id="atiende2" name="atiende2" path="atiendeSuc" 
				value="N" tabindex="4"  iniforma="false"  />
			<label for="no">No</label>
		</td>
		<td class="separador"></td>
		  <td class="label"> 
         <label for="descripcion">&Aacute;rea: </label> 
     </td>
     <td> 
     <form:input id="area" name="area" path="area" size="5" tabindex="5" 	onBlur=" ponerMayusculas(this)"/> 
        <form:input id="descripcionArea" name="descripcionArea" path="descripcionArea" size="40" tabindex="6"   disabled="true" onBlur=" ponerMayusculas(this)"/> 
     </td>       
 </tr> 
 <tr>
  <td class="label"> 
         <label for="descripcion">Categor&iacute;a: </label> 
     </td>
  <td> 
     <form:input id="categoriaID" name="categoriaID" path="categoriaID" size="5" tabindex="5" 	onBlur=" ponerMayusculas(this)"/> 
        <form:input id="descripcionCategoria" name="descripcionCategoria" path="descripcionCategoria" size="40" tabindex="15"   disabled="true" onBlur=" ponerMayusculas(this)"/> 
        <input id="descripcionCategoria2" type="hidden" name="descripcionCategoria" size="40" tabindex="6"  onBlur=" ponerMayusculas(this)"/> 

     </td>
  <td class="separador"></td>
	<td class="label">
	<label for="atiendeSuc">Es Gestor: </label></td>
	<td class="label">
	<form:input id="gestorSi" type= "radio" name="gestorSi"  tabindex="7" value="S" path="esGestor" /> <label for="si">Si</label>
	<form:input id="gestorNo" type= "radio" name="gestorNo"  tabindex="8" value="N" path="esGestor" /> <label for="no">No</label></td>        
 </tr>
 <tr id="supervisor" style="display: none;">
 <td class="label">
	<label for="lblsupervisor">Es Supervisor:</label>
</td>
  <td class="label">
 <form:input id="supervisorSi" type= "radio" name="supervisorSi"  tabindex="9" value="S" path="esSupervisor" /> <label for="si">Si</label>
	<form:input id="supervisorNo" type= "radio" name="supervisorNo"  tabindex="10" value="N" path="esSupervisor" /> <label for="no">No</label>

  </td>
 </tr>
  </table>
  </fieldset>
		<table align="right">
					<tr>
						<td align="right">
							<input type="submit" id="agrega" name="agrega" class="submit" tabindex="11"
							 value="Agregar"/>
							<input type="submit" id="modifica" name="modifica" class="submit" tabindex="12"
							 value="Modificar"/>
							 <input type="submit" id="elimina" name="elimina" class="submit" tabindex="13"
							 value="Baja"/>
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