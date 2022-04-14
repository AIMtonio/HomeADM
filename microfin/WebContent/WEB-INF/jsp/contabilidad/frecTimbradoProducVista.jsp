
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
  <head>
    <script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>CFrecuencia de Timbrado por Producto</title>
    <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
    <script type="text/javascript"  src="js/contabilidad/frecTimbradoProduc.js"></script>
    
    </head>
    <body>
      <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="frecTimbradoProducBean">
          <fieldset class="ui-widget ui-widget-content ui-corner-all">
            <legend class="ui-widget ui-widget-header ui-corner-all">Frecuencia de Timbrado por Producto</legend>
            <table border="0" width="100%">
              <tr>
                <td class="label">
                  <label for="frecuencia">Frecuencia:</label>
                </td>
                <td><form:select id="frecuenciaID" name="frecuenciaID" path="frecuenciaID" tabindex="1">
                          <form:option value="">SELECCIONAR</form:option>
                          <form:option value="M">MENSUAL</form:option>
                          <form:option value="E">SEMESTRAL</form:option>
                        </form:select>
                </td>
              </tr>
      
            </table>
           <br>
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
                 <tr> 
                  <td colspan="20">
                   <div id="gridfrecTimbrarProduc" style="display: none;" />             
                  </td>
                </tr>
          </table>
          <table align="right">
            <tr>
              <td align="right">
                <input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  tabindex="3" />
                <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
                <input type="hidden" id="tipoBaja" name="tipoBaja" />               
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
      <div id="mensaje" style="display: none;"/>
     
    </body>
    </html>
