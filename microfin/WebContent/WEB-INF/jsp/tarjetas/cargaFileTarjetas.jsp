<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
	<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
      <script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script> 
	  <script type="text/javascript" src="js/tarjetas/cargaFileTarjetas.js"></script>
</head> 

<body>
<div id="contenedorForma">
<form method="POST" id="formaGenerica" name="formaGenerica" action="/microfin/cargaFileTarjetas.htm" enctype="multipart/form-data">
  <fieldset class="ui-widget ui-widget-content ui-corner-all">		
  <legend class="ui-widget ui-widget-header ui-corner-all">Carga de Transacciones Tarjetas de Crédito</legend>			
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	  <tr>
	   	<td class="label"> 
        <label for="tipoCarga">Tipo de Archivo:</label> 
      </td> 
      <td nowrap="nowrap"> 
			  <select id="tipoCarga" name="tipoCarga" tabindex="5">
  				<option value="">SELECCIONAR</option>
          <option value="C">ARCHIVO DE COMPRAS</option>
          <option value="P">ARCHIVO DE PAGOS</option> 
			  </select>     
      </td>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="separador"></td> 
	  </tr>
    <tr>
      <td>
        <input type="button" id="enviar" name="enviar" class="submit" tabindex="8" value="Adjuntar"   />
        <input type="hidden" id="resultadoArchivoTran"  name="resultadoArchivoTran" readonly="true" />
      </td>
      <td>
          <input type="text" name="nombreArchivo" id="nombreArchivo" size="50" readonly="readonly">
          <input type="hidden" name="numTransaccion" id="numTransaccion" size="40" readonly="readonly">
      </td>
    </tr>
  </table>

  <table align="right">
	  <tr>
    	<td class="label">
        <input type="submit" id="cargar" name="cargar" class="submit" tabindex="8" value="Procesar"   /> 
        <input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
  		</td> 
	  </tr>
  </table>
  </fieldset>	 
</form> 
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 
</html>