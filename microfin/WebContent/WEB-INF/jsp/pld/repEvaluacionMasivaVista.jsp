<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
   <head>
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/procesoEscalamientoInternoServicio.js"></script>
      <script type="text/javascript" src="js/pld/repEvaluacionMasivaRiesgoCte.js"></script>  
   </head>
   <body>
      <div id="contenedorForma">
         <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="riesgoActualClienteRep">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
            <legend class="ui-widget ui-widget-header ui-corner-all">Evaluaci&oacute;n Masiva Nivel de Riesgo</legend>
            <table border="0" width="600px">
                  <tr>
                     <td>
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                           <legend><label>Par&aacute;metros</label></legend>
                           <table border="0" width="560px">
                              <tr>
                                 <td class="label" style="width: 25%">
                                    <label for="fechaInicio">Fecha de Inicio: </label>
                                 </td>
                                 <td >
                                    <input id="fechaInicio" name="fechaInicio"  size="12" type="text" tabindex="3"  esCalendario="true" />   
                                 </td>
                              </tr>
                              <tr>
                                 <td class="label">
                                    <label for="fechaFin">Fecha de Fin: </label> 
                                 </td>
                                 <td>
                                    <input id="fechaFin" name="fechaFin"  size="12" type="text"  tabindex="4" esCalendario="true" />            
                                 </td>
                              </tr>
                           </table>
                        </fieldset>
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <table>
                           <tr>
                              <td>
                                 <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                    <legend><label>Presentaci&oacute;n</label></legend>
                                       <input type="radio" id="tipoReportePDF" name="tipoReporte" value="1" tabindex="5" checked="checked" />
                                       <label for="tipoReportePDF">PDF</label>
                                 </fieldset>
                              </td>
                           </tr>
                        </table>
                     </td>
                  </tr>
            
            <table align="right" border='0'>
               <tr>
                  <td align="right">
                     <input type="hidden" id="tipoReportev" name="tipoReporte" class="submit" />
                     <input type="hidden" id="tipoLista" name="tipoLista" />
                     <input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
                     <input type="button" id="generar" name="generar" class="submit" tabIndex = "7" value="Generar" />
                     </a>
                  </td>
               </tr>
            </table>
            </table>
         </form:form>
      </div>
      <div id="cargando" style="display: none;">   </div>
      <div id="cajaLista" style="display: none;">
      <div id="elementoLista"/></div>
   </body>
   <div id="mensaje" style="display: none;"/>
</html>