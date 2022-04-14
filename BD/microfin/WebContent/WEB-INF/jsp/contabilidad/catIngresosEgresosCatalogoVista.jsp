
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Cat&aacute;logo Ingresos/Egresos</title>
		<script type="text/javascript" src="dwr/interface/catIngresosEgresosServicio.js"></script>
		<script type="text/javascript"  src="js/contabilidad/catIngresosEgresos.js"></script>
    </head>
    <body>
      <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catalogos">
          <fieldset class="ui-widget ui-widget-content ui-corner-all">
            <legend class="ui-widget ui-widget-header ui-corner-all">Ingresos/Egresos</legend>
            <table border="0" width="100%">
              <tbody>
              	 <tr>
                  <td class="label" nowrap="nowrap"><label>Tipo:</label></td>
                  <td><form:select id="tipo" name="tipo" path="tipo" tabindex="1">
                      <form:option value="">SELECCIONAR</form:option>
                      <form:option value="I">INGRESO</form:option>
                      <form:option value="E">EGRESO</form:option>
                    </form:select></td>
                </tr>
                <tr>
                  <td class="label" nowrap="nowrap"><label>N&uacute;mero:</label></td>
                  <td nowrap="nowrap">
                    <form:input type="text" id="numero" name="numero" path="numero" size="12" tabindex="2" maxlength="45" /> 
                  </td>                 
                </tr>
                <tr>                  
                   <td class="label" nowrap="nowrap"><label>Descripci&oacute;n:</label></td>
                  <td nowrap="nowrap">
                    <form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="50" tabindex="3"  maxlength="100" onBlur=" ponerMayusculas(this)"/>
                  </td>
                </tr>
                <tr>
                	<td class="label" nowrap="nowrap"><label>Estatus:</label></td>
                  	<td><form:select id="estatus" name="estatus" path="estatus" tabindex="4">
                      	<form:option value="">SELECCIONAR</form:option>
                      	<form:option value="A">ACTIVO</form:option>
                      	<form:option value="I">INACTIVO</form:option>
                    	</form:select>
                    </td>
                </tr>
                
                <tr>
                  <td align="right" colspan="5">
                  <input type="button" id="grabar" name="grabar" class="submit" value="Agregar" tabindex="5" />
                  <input type="button" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="6" />
                  <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0" /></td>
                </tr>
              </tbody>
            </table>
          </fieldset>
        </form:form>
      </div>
      <div id="cargando" style="display: none;"></div>
      <div id="cajaLista" style="display: none; overflow:">
        <div id="elementoLista"></div>
      </div>
      <div id="mensaje" style="display: none;"></div>
     
    </body>
    </html>
