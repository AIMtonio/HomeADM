
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Cat&aacute;logo Ingresos/Egresos</title>
    <script type="text/javascript" src="dwr/interface/catMetodosPagoServicio.js"></script>
		<script type="text/javascript"  src="js/contabilidad/catMetodoPago.js"></script>
    </head>
    <body>
      <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="metodosPago">
          <fieldset class="ui-widget ui-widget-content ui-corner-all">
            <legend class="ui-widget ui-widget-header ui-corner-all">M&eacute;todos de Pago</legend>
            <table border="0" width="100%">
              <tbody>              	
                <tr>
                  <td class="label" nowrap="nowrap"><label>N&uacute;mero:</label></td>
                  <td nowrap="nowrap">
                    <form:input type="text" id="metodoPagoID" name="metodoPagoID" path="metodoPagoID" size="12" tabindex="2" iniforma="false" maxlength="45" /> 
                  </td>                 
                </tr>
                <tr>                 
                   <td class="label" nowrap="nowrap"><label>Descripci&oacute;n:</label></td>
                  <td nowrap="nowrap">
                    <form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="50" tabindex="3" iniforma="false" maxlength="50" onBlur=" ponerMayusculas(this)"/>
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
      <div id="ContenedorAyuda" style="display: none;">
        <fieldset class="ui-widget ui-widget-content ui-corner-all">
          <legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Lista PLD</legend>
          <div>
            <p>Corresponde al campo de Lista del Formato de Carga de acuerdo a Qui&eacute;n es Qui&eacute;n (QeQ).</p>
          </div>
        </fieldset>
      </div>
    </body>
    </html>
