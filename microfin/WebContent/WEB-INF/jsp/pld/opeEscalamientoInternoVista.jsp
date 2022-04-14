<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
   <head>
      <link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
      <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/procesoEscalamientoInternoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/opeEscalamientoInternoServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/clavesPorResultadoOpeEscIntServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/fileServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>   
      <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>   
      <script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>    
      <script type="text/javascript" src="js/pld/opeEscalamientoInterno.js"></script>
      <script>
         $(function() {
               	$('#imagenCte a').lightBox();
           	});
          
           
      </script>
   </head>
   <body>
      <div id="contenedorForma">
         <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeEscalamientoInterno">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
               <legend class="ui-widget ui-widget-header ui-corner-all">Gesti&oacute;n Escalamiento Interno</legend>
               <div id="divAvisoEscalimento">
                  <fieldset class="ui-widget ui-widget-content ui-corner-all">
                     <table border="0" width="100%">
                        <tr>
                           <td class="label">
                              <label for="lblProceso">
                              Proceso: 
                              </label>
                           </td>
                           <td colspan="4">
                              <form:select id="procesoEscalamientoID" name="procesoEscalamientoID" path="procesoEscalamientoID" 
                                 tabindex="1">
                                 <form:option value="">Selecciona</form:option>
                              </form:select>
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblEstado">Estado:</label>
                           </td>
                           <td colspan="2">
                              <input id="resultadoRev" name="resultadoRev" size="20"
                                 tabindex="2" type="text" readOnly="true" disabled="true"
                                 />
                              <form:input id="resultadoRevision" name="resultadoRevision" size="20" path="resultadoRevision"
                                 tabindex="2" type="hidden" readOnly="true" disabled="true"
                                 />
                           </td>
                        </tr>
                        <tr>
                           <td class="label">
                              <label for="lblOperacionID">
                              Operaci&oacute;n: 
                              </label>
                           </td>
                           <td colspan="4">
                              <form:input id="folioOperacionID" name="folioOperacionID" size="13" path="folioOperacionID"
                                 tabindex="3" type="text"
                                 />
                           </td>
                           <td class="separador"></td>
                           <td class="label" nowrap="nowrap">
                              <label for="lblFechaDeteccion">Fecha de detecci&oacute;n:</label>
                           </td>
                           <td colspan="2">
                              <form:input id="fechaDeteccion" name="fechaDeteccion" size="20" path="fechaDeteccion"
                                 tabindex="4" type="text" readOnly="true" disabled="true"
                                 />
                              <form:input id="autorizacion" name="autorizacion" size="20" path=""
                                 tabindex="2" type="hidden" readOnly="true" disabled="true"
                                 />
                           </td>
                        </tr>
                        <tr>
                           <td class="label">
                              <label for="lblSucursal">
                              Sucursal: 
                              </label>
                           </td>
                           <td colspan="4">
                              <form:input id="sucursalDeteccion" name="sucursalDeteccion" size="4" path="sucursalDeteccion" tabindex="5" type="text" readOnly="true" disabled="true"/>
                              <input id="descripSucursal" name="descripSucursal" size="20" tabindex="5" type="text" readOnly="true" disabled="true"/>
                           </td>
                           <td class="separador"></td>
                           <td class="label" nowrap="nowrap">
                              <label for="lblFechaSolicitud">Fecha Solicitud:</label>
                           </td>
                           <td colspan="4">
                              <form:input id="fechaSolicitud" name="fechaSolicitud" size="20"  path="fechaSolicitud"
                                 tabindex="9" type="text" readOnly="true" disabled="true"
                                 />
                           </td>
                        </tr>
                        <tr>
                           <td class="label">
                              <label for="lblCliente">
                                 <s:message code="safilocale.cliente"/>
                                 : 
                              </label>
                           </td>
                           <td colspan="4" nowrap="nowrap">
                              <form:input id="clienteID" name="clienteID" size="13" path="clienteID" tabindex="6" type="text" readOnly="true" disabled="true"/>
                              <input id="nombreCliente" name="nombreCliente" size="45" tabindex="7" type="text" readOnly="true" disabled="true"/>							
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblCliente">Usuario Servicio: </label>
                           </td>
                           <td colspan="4" nowrap="nowrap">
                              <form:input id="usuarioServicioID" name="usuarioServicioID" size="13" path="usuarioServicioID" tabindex="6" type="text" readOnly="true" disabled="true"/>
                              <input id="nombreUsuarioServicio" name="nombreUsuarioServicio" size="45" tabindex="7" type="text" readOnly="true" disabled="true"/>							
                           </td>
                        </tr>
                        <tr>
                           <td class="label"><label for="lblRFC">RFC:</label></td>
                           <td colspan="4">
                              <form:input id="rfcCliente" name="rfcCliente" size="18" path="rfcCliente" tabindex="8" type="text" readOnly="true" disabled="true"/>
                           </td>
                           <td class="separador"></td>
                           <td class="label"><label for="lblMonto">Monto:</label></td>
                           <td colspan="4">
                              <form:input id="montoOperacion" name="montoOperacion" size="18" path="montoOperacion" tabindex="10" type="text" readOnly="true" disabled="true" style="text-align: right"/>
                           </td>
                        </tr>
                        <tr>
                           <td class="label" colspan="5">
                              <label for="lblMotivEsca">Motivo Escalamiento:</label>
                              <label for="lblmatchnivelriesgo" class="motivoAltoRiesgo">Nivel de Riesgo del Cliente</label>
                              <form:input type="checkbox"  id="matchNivelRiesgo" name="matchNivelRiesgo" class="motivoAltoRiesgo"
                                 tabindex="11" path="matchNivelRiesgo" value="1" readonly="true" disabled="true" />
                           </td>
                        </tr>
                        </br>
                        <tr class="motivosEscala">
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblmatchpep">PEP</label>
                           </td>
                           <td>
                              <form:input type="checkbox"  id="matchPEPs" name="matchPEPs"
                                 tabindex="12" path="matchPEPs" value="1"   readonly="true" disabled="true"/>
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblmatchdocumentos">Documentos</label>
                           </td>
                           <td>
                              <form:input type="checkbox"  id="matchDetalleDocumentacion" name="matchDetalleDocumentacion"
                                 tabindex="13" path="matchDetalleDocumentacion" value="1"   readonly="true" disabled="true"/>
                           </td>
                        </tr>
                        <tr class="motivosEscala">
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblmatch3ro">3ro Sin Declarar</label>
                           </td>
                           <td>
                              <form:input type="checkbox"  id="matchCuenta3SinDeclarar" name="matchCuenta3SinDeclarar"
                                 tabindex="14" path="matchCuenta3SinDeclarar" value="1"   readonly="true" disabled="true"/>
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblmatchMonto">Monto</label>
                           </td>
                           <td>
                              <form:input type="checkbox"  id="matchMontoTransaccion" name="matchMontoTransaccion"
                                 tabindex="15" path="matchMontoTransaccion" value="1"   readonly="true" disabled="true"/>
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblmatchOtros">Otro</label>
                           </td>
                           <td>
                              <form:input type="checkbox"  id="matchOtroProceso" name="matchOtroProceso"
                                 tabindex="16" path="matchOtroProceso" value="1"   readonly="true" disabled="true"/>
                              <form:input id="descripcionOtro" name="descripcionOtro" size="35" path="descripcionOtro"
                                 tabindex="17" type="text"  readonly="true"	disabled="true"/>
                           </td>
                        </tr>
                        <tr>
                           <td class="label">
                              <label for="lblproducto">
                              Producto: 
                              </label>
                           </td>
                           <td colspan="8">
                              <form:input id="productoInstrumentoID" name="productoInstrumentoID" size="13" path="productoInstrumentoID"
                                 tabindex="21" type="text" readOnly="true" disabled="true"
                                 />
                              <form:input id="nombreProductoInstrumento" name="nombreProductoInstrumento" size="40" path="nombreProductoInstrumento"
                                 tabindex="22" type="text" readOnly="true" disabled="true"
                                 />
                           </td>
                        </tr>
                     </table>
                  </fieldset>
               </div>
               <br>
               <div id="divBotones">
                  <fieldset class="ui-widget ui-widget-content ui-corner-all">
                     <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                           <td class="separador"></td>
                           <td align="center">
                              <input type="button" id="autorizar" name="autorizar" class="submit" value="Autorizar"
                                 tabindex="24" />
                           </td>
                           <td class="separador"></td>
                           <td align="center">
                              <input type="button" id="pendiente" name="pendiente" class="submit" value="Pendiente"
                                 tabindex="25" />
                           </td>
                           <td class="separador"></td>
                           <td align="center">
                              <input type="button" id="rechazar" name="rechazar" class="submit" value="Rechazar" 
                                 tabindex="26"/>
                           </td>
                           <td class="separador"></td>
                           <td align="center">
                              <input type="button" id="consultar" name="consultar" class="submit" value="Consultar" 
                                 tabindex="27"/>
                           </td>
                        </tr>
                     </table>
                  </fieldset>
               </div>
               <br>
               <div id="gridSolFondeo" style="display: none;">	
               </div>
               <br>
               <div id="divGuardar" style="display: none;">
                  <fieldset class="ui-widget ui-widget-content ui-corner-all">
                     <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                           <td class="label" colspan="2">
                              <label for="lblJustificacion">
                              Justificaci&oacute;n: 
                              </label>
                           </td>
                           <td>
                              <form:select id="claveJustificacion" name="claveJustificacion" path="claveJustificacion" 
                                 tabindex="28">
                                 <form:option value="">Selecciona</form:option>
                              </form:select>
                           </td>
                           <td class="separador"></td>
                           <td class="label">
                              <label for="lblFechaGestion">
                              Fecha Gesti&oacute;n: 
                              </label>
                           </td>
                           <td>
                              <form:input id="fechaGestion" name="fechaGestion" size="20" path="fechaGestion"
                                 tabindex="18" type="text" readOnly="true" disabled="true"
                                 />
                           </td>
                        </tr>
                        <tr>
                           <td class="label" colspan="2">
                              <label for="lblUsuarioGestion">Usuario Gesti&oacute;n:</label>
                           </td>
                           <td >
                              <form:input id="funcionarioUsuarioID" name="funcionarioUsuarioID" size="18" path="funcionarioUsuarioID"
                                 tabindex="19" type="text" readOnly="true" disabled="true"
                                 />
                              <input id="nombreUsuGestion" name="nombreUsuGestion" size="40" 
                                 tabindex="20" type="text" readOnly="true" disabled="true"
                                 />		
                           </td>
                           <td class="separador"></td>
                           <td class="label" align="right">
                              <label for="lblSolSegAdi">Sol. Seguimiento Adicional:</label>
                           </td>
                           <td>
                              <label for="lblsolSegAdiSi">Si</label> 
                              <form:input type="radio" id="solSegAdiSi" name="solSegAdiSi" value="S"
                                 tabindex="31" checked="checked"  path="solicitaSeguimiento" />
                              &nbsp;&nbsp;
                              <label for="lblsolSegAdiNo">No</label> 
                              <form:input type="radio" id="solSegAdiNo" name="solSegAdiNo" value="N"   path="solicitaSeguimiento"
                                 tabindex="32"/>
                           </td>
                        </tr>
                        <tr>
                           <td class="label" colspan="2">
                              <label for="lblDetalleDesi">
                              Detalle de la decisi&oacute;n: 
                              </label>
                           </td>
                           <td colspan="4">
                              <form:textarea id="notasComentarios" name="notasComentarios" path="notasComentarios" 
                                 tabindex="33" cols="80" rows="3" onblur=" ponerMayusculas(this)" maxlength="1500" />
                           </td>
                        </tr>
                        <tr>
                           <td class="separador"></td>
                           <td class="separador"></td>
                           <td align="center">
                              <input type="button" id="btnAdjArchivos" name="btnAdjArchivos" class="submit" value="Adjuntar Archivos"
                                 tabindex="34" />
                           </td>
                           <td class="separador"></td>
                           <td colspan="2" align="center">
                              <input type="submit" id="guardar" name="guardar" class="submit" value="Guardar"
                                 tabindex="35" />
                              <input type="hidden" id="tipoActualizacion" name="tipoActualizacion" />
                           </td>
                        </tr>
                        <tr>
                           <td>
                              <div id="imagenCte" style="display: none;">
                                 <IMG id= "imgCliente" SRC="images/user.jpg" WIDTH="100%" HEIGHT="100%" BORDER=0 ALT="Foto cliente"/> 
                              </div>
                           </td>
                        </tr>
                     </table>
                  </fieldset>
               </div>
            </fieldset>
         </form:form>
      </div>
      <br>
      <div id="gridArchivosClienteOpe"></div>
      <div id="cargando" style="display: none;"></div>
      <div id="cajaLista" style="display: none;">
         <div id="elementoLista"></div>
      </div>
   </body>
   <div id="mensaje" style="display: none;"></div>
</html>