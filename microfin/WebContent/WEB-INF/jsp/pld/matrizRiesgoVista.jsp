<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
   <head>
      <script type="text/javascript" src="dwr/interface/matrizRiesgo.js"></script> 
      <script type="text/javascript" src="js/pld/matrizRiesgo.js"></script>     
   </head>
   <body>
      <div id="contenedorForma">
         <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conceptoMatriz">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
               <legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Matriz de Riesgos</legend>
               <div id="parametrosGrid"></div>
               <div id="ContenedorAyuda" style="display: none;">
               </div>
               <div id="divGrid">
                  <!-- Muestra la tabla con el boton grabar!-->
                  <div id="tablaGrid"></div>
                  <br>                      
                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                     <tr>
                        <td align="right" colspan="5">
                           <input type="submit" id="graba" name="graba" class="submit" value="Grabar" tabindex="100"/>
                           <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
                        </td>
                     </tr>
                  </table>
               </div>
            </fieldset>
         </form:form>
      </div>
      <div id="cargando" style="display: none;"></div>
      <div id="cajaLista" style="display: none;">
         <div id="elementoLista"></div>
      </div>
   </body>
   <div id="mensaje" style="display: none;"></div>
</html>