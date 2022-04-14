<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
   <head>
      <script type="text/javascript" src="dwr/interface/nivelRiesgoClientePLD.js"></script> 
      <script type="text/javascript" src="dwr/interface/procesoEscalamientoInternoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="js/pld/nivelRiesgoClientePLD.js"></script>     
   </head>
   <body>
      <div id="contenedorForma">
         <form:form id="formaGenerica" name="formaGenerica" method="POST" action="" commandName="nivelRiesgoCliente" onsubmit="return false;">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
               <legend class="ui-widget ui-widget-header ui-corner-all">Nivel de Riesgo Por Cliente</legend>
               <table border="0" width="100%">
                  <tr>
                     <td class="label">
                        <label for="ClienteID">No. de Cliente:</label>
                     </td>
                     <td>
                        <input id="clienteID" name="clienteID" path="clienteID" size="18" maxlength="20"  tabindex="1"  />
                        <input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size="60" disabled="true"/>
                     </td>
                     <td class="separador"></td>
                     <td class="label">
                        <label for="tipoConsulta">Consultar por: </label>
                     </td>
                     <td>
                        <select id="tipoConsulta" name="tipoConsulta" path="tipoConsulta" 
                           tabindex="2" width="120px" style="width:150px">
                        <option value="">SELECCIONAR</option>
                        <option value="O">OPERACION</option>
                        <option value="R">RIESGO ACTUAL</option>
                        </select>
                     </td>
                  </tr>
                  <tr id="filtros" style="display: none;">
                     <td class="label">
                        <label for="tipoOperacion">Tipo de Operaci&oacute;n:</label>
                     </td>
                     <td>
                        <select id="tipoOperacion" name="tipoOperacion" tabindex="3" style="width:150px">
                        <option value="">SELECCIONAR</option>
                        </select>
                     </td>
                     <td class="separador"></td>
                     <td class="label">
                        <label for="tipoInstrumento">Instrumento: </label>
                     </td>
                     <td>
                        <select id="tipoInstrumento" name="tipoInstrumento" path="tipoInstrumento" 
                           tabindex="4" style="width:150px" disabled>
                        <option value="">SELECCIONAR</option>
                        </select>
                     </td>
                  </tr>
               </table >
               </br>
               <div id="divGrid">
                  <!-- Muestra la tabla con el boton consultar!-->
                  <div id="tablaGrid"></div>
                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                     <tr>
                        <td align="right" colspan="5">
                           <input type="hidden" id="tipoCon" name="tipoCon" value="1"/>
                        </td>
                     </tr>
                  </table>
               </div>
                 
                  <div id="resultadosGrid"></div>
                  <div id="ContenedorAyuda" style="display: none;"></div>

               
                  
             
       
               

              
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