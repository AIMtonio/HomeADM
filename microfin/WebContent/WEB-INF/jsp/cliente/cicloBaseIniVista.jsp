<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
     	 
   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>  
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cicloBaseIniServicio.js"></script>  
	 
	
    <script type="text/javascript" src="js/cliente/cicloBaseIni.js"></script>
    <title>Ciclo Base Inicial</title>
</head>

<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cicloBaseIni">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Ciclo Base Inicial</legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="label"> 
        	<label for="observacion"><s:message code="safilocale.cliente"/>: </label> 
     	</td>
     	<td class="separador"></td>
    	<td>
        	<input type="text" id="clienteID" name="clienteID" path="clienteID" size="13" tabindex="1"  />
        	<input type="text" id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="48" tabindex="2" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>  
      	</td> 
      	
   </tr> 
<!--    <tr> -->
<!-- 			<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
<!-- 			<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td>  		 -->
<!--    </tr> -->
   
	<tr>
		<td class="label"> 
        	<label for="observacion">Prospecto: </label> 
     	</td>
     	<td class="separador"></td>
     	<td> 
     		<input type="text" id="prospectoID" name="prospectoID" path="prospectoID" size="13" tabindex="3"  />
     		<input type="text" id="nombreProspecto" name="nombreProspecto" path="nombreProspecto" size="48" tabindex="4" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>       
     	</td> 
   </tr>
   <tr>
		<td class="label"> 
        	<label for="observacion">Producto de Crédito: </label> 
     	</td>
     	<td class="separador"></td>
     	<td><input type="text" id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="13" tabindex="5" />
     		<input type="text" id="descripcion" name="descripcion" path="descripcion" size="48" tabindex="6" disabled="true" readOnly="true"
						onBlur=" ponerMayusculas(this)"/>
     	</td>
	</tr>
   <tr>
		<td class="label"> 
        	<label for="observacion">Ciclo Base Inicial: </label> 
     	</td>
     	<td class="separador"></td>
     	<td><input type="text" id="cicloBaseIni" name="cicloBaseIni" path="cicloBaseIni" size="13" tabindex="7" /></td>
	</tr>
   
</table>
<table align="right">
	<tr>
	   	<td>
       		<input type="submit" id="graba" name="graba" class="submit" tabindex="8" value="Grabar"   /> 
       		<input type="submit" id="modifica" name="modifica" class="submit" tabindex="9" value="Modificar"   />
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
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 
  
</html>