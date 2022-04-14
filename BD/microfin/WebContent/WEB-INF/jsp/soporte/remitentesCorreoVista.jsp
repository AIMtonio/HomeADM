<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

<head>
    <script type="text/javascript" src="dwr/interface/tarEnvioCorreoParamServicio.js"></script>
    <script type="text/javascript" src="js/soporte/TarEnvioCorreoParam.js"></script>
</head>

<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="EnvioCorreoParam">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Remitentes Correo</legend>

                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                    <legend>Configuración</legend>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">

                        <table>
                            <tr>
                                <td class="label">
                                    <label for="RemitenteID">N&uacute;mero: </label>
                                </td>
                                <td>
                                    <form:input id="RemitenteID"  path="RemitenteID" size="8"
                                        maxlength="11" tabindex="1" />
                                </td>
                                <td class="separador"></td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="ServidorSMTP">Servidor SMTP: </label>
                                </td>
                                <td>
                                    <form:input id="ServidorSMTP"  path="ServidorSMTP" tabindex="2"
                                        maxlength="80" onBlur=" ponerMayusculas(this)" size="30" autocomplete="off"/>
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="PuertoServerSMTP">Puerto SMTP: </label>
                                </td>
                                <td>
                                    <form:input id="PuertoServerSMTP"  path="PuertoServerSMTP"
                                        maxlength="6" onKeyPress="return soloNumeros(event)" size="15" tabindex="3" autocomplete="off" />
                                </td>

                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="TipoSeguridad">Tipo de Seguridad:</label>
                                </td>
                                <td>
                                    <form:select id="TipoSeguridad"  path="TipoSeguridad"
                                        tabindex="4">
                                        <form:option value="N">Ninguna</form:option>
                                        <form:option value="S">SSL</form:option>
                                        <form:option value="T">STARTTLS</form:option>
                                    </form:select>
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="CorreoSalida">Correo de Salida: </label>
                                </td>
                                <td>
                                    <form:input id="CorreoSalida"  path="CorreoSalida" size="25"
                                        maxlength="80" tabindex="5" autocomplete="off" />
                                </td>
                            </tr>
                            	 <td class="separador"></td>
                            	 <td class="separador"></td>
                            	 <td class="separador"></td>
                            	
                            	  <td class="label">
                                    <label for="AliasRemitente">Alias </label>
                                </td>
                            	 <td>
                                    <form:input id="AliasRemitente" path="AliasRemitente" tabindex="6"
                                        maxlength="30" onBlur=" ponerMayusculas(this)" size="15" autocomplete="off"/>
                                </td>
                            
                            <tr>
                            
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="ConAutentificacion">Requiere Autentificación: </label>
                                </td>
                                <td>
                                    <form:radiobutton id="ConAutentificacionS" 
                                        path="ConAutentificacion" value="S" tabindex="7" checked="checked" />
                                    <label for="ConAutentificacionS">Si</label>
                                    &nbsp;&nbsp;

                                    <form:radiobutton id="ConAutentificacionN" 
                                        path="ConAutentificacion" value="N" tabindex="8" />
                                    <label for="ConAutentificacionN">No</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="Contrasenia">Contrase&ntilde;a: </label>
                                </td>
                                <td>
                                    <form:input id="Contrasenia"  path="Contrasenia" size="25"
                                        maxlength="20" tabindex="9" autocomplete="off" type="password" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="Estatus">Estatus: </label>
                                </td>
                                <td>
                                    <form:select id="Estatus"  tabindex="10" path="Estatus" readonly="true"
                                        disabled="true">
                                        <form:option value="A">Activo</form:option>
                                        <form:option value="B">Baja</form:option>
                                    </form:select>

                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="Descripcion">Descripción: </label>
                                </td>
                                <td>
                                    <form:input id="Descripcion"  path="Descripcion" size="25"
                                        maxlength="80" onBlur=" ponerMayusculas(this)" tabindex="11" autocomplete="off" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="Comentario">Comentarios: </label>
                                </td>
                                <td>
                                <form:textarea id="Comentario"  path="Comentario" cols="30" rows="4" maxlength="200" tabindex="12" onBlur="ponerMayusculas(this)" autocomplete="off"/> 
		
                                   </td>
                                <td class="separador"></td>
                                
                                 <td class="label">
                                    <label for="TamanioMax">Tamaño máximo  de archivos adjuntos: </label>
                                </td>
                                <td>
									 <form:input id="TamanioMax"  path="TamanioMax" size="8"
                                        maxlength="3" onKeyPress="return soloNumeros(event)" tabindex="13" autocomplete="off"/>
                                        
									  <form:select id="Tipo"  path="Tipo" tabindex="14">
                                        <form:option value="MB">MB</form:option>
                                        <form:option value="KB">KB</form:option>
                                    </form:select>
                                </td>
							
                            </tr>

                            <tr>
                                <table width="100%">
                                    <tr>
                                        <td colspan="5" align="right">
                                            <input type="submit" id="agrega" name="agrega" class="submit"
                                                value="Agregar" tabindex="13" />
                                            <input type="submit" id="modifica" name="modifica" class="submit"
                                                value="Modificar" tabindex="14" />
                                            <input type="submit" id="elimina" name="elimina" class="submit"
                                                value="Eliminar" tabindex="12" />
                                            <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />

                                        </td>
                                    </tr>
                                </table>
                            </tr>
                        </table>

                    </table>

                </fieldset>


                <br>
                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                    <div id="gridcorreo"></div>
                </fieldset>
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
