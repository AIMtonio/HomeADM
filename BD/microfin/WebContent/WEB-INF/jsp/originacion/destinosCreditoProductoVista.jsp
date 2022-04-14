<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
      <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	  <script type="text/javascript" src="js/originacion/destinosCreditoProducto.js"></script>   
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="destinosCredProd">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Destinos de Cr&eacute;dito por Producto</legend>
		<table border="0">
			<tr>
				<td>
					<label for="productoCreditoID">Producto de Crédito: </label> 
		     	</td> 
		     	<td> 
		        	<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" tabindex="1" type="text"  />
		         	<input id="descripcionProducto" name="descripcionProducto" size="50" type="text" tabindex="2" readOnly="true" disabled = "true" />
		     	</td>	
		    </tr>
	 		<tr>
	 			<td colspan="2">
	 				<br>
	 				<div id="gridDestinosPorProducto" style="overflow: scroll;height: 450px;display: none;">  </div>
	 			</td>	
	 		</tr>	
	 		<tr>
	 			<td align="right" colspan="2">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="18"  />
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
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>