<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>

<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
<script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>

<script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/escrituraServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cliExtranjeroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/adicionalPersonaMoralServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cargosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/avalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/garantesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>



<script type="text/javascript" src="js/general.js"></script>
<script type="text/javascript" src="js/generarRFC.js"></script>
<script type="text/javascript" src="js/soporte/mascara.js"></script>
<script type="text/javascript" src="js/cliente/adicionalPersonaMoral.js"></script>
</head>
<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="adicionalPersonaMoral">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Adicional Persona Moral</legend>
                <table>
                    <tr>
                        <td class="label" nowrap="nowrap">
                            <label for="numCliente">N&uacute;mero <s:message code="safilocale.cliente" />
                            </label>
                        </td>
                        <td nowrap="nowrap">
                            <form:input type="text" id="numCliente" name="numCliente" path="numCliente" size="15" tabindex="1" />
                            <input type="text" id="nombreCliente" name="nombreCliente" size="40" disabled="true"  tabindex="2" />
                        </td>
                        <td class="separador" nowrap="nowrap"></td>
                        <td class="label" nowrap="nowrap">
                            <label for="sucursalID">Sucursal: </label>
                        </td>
                        <td nowrap="nowrap">
                            <form:input type="text" id="sucursalID" name="sucursalID" path="sucursalID" size="15" tabindex="3" disabled="true" readonly="true" />
                        </td>
                        <td nowrap="nowrap">
                            <form:input type="text" id="nombreSucursal" name="nombreSucursal" path="nombreSucursal" size="35" tabindex="4" disabled="true" readonly="true" />
                        </td>
                    </tr>

                    <tr>
                    <td class="label">
                        <label for="avalID">N&uacute;mero Aval: </label>
                      </td>
                      <td nowrap="nowrap">
                        <form:input type="text" id="avalID" name="avalID" path="avalID" size="15" tabindex="1" />
                      <input type="text" id="nombreAval" name="nombreAval" size="40" disabled="true" tabindex="2" />
                  </td>
                    </tr>


                    <tr>
                          <td class="label">
                            <label for="garanteID">N&uacute;mero Garante: </label>
                        </td>

                         <td nowrap="nowrap">
                              <form:input type="text" id="garanteID" name="garanteID" path="garanteID" size="15" tabindex="1" />
                            <input type="text" id="nombreGarante" name="nombreGarante" size="40" disabled="true" tabindex="2" />
                        </td>
                    </tr>

                </table>
                <br>
                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                    <legend>Búsqueda</legend>
                    <table>
                        <tr>
                            <td class="label" nowrap="nowrap">
                                <label for="directivoID">Directivo:</label>
                            </td>
                            <td nowrap="nowrap">
                                <form:input type="text" id="directivoID" name="directivoID" path="directivoID" size="15" tabindex="5" />
                            </td>
                        </tr>
                        <tr>
                            <td class="label" nowrap="nowrap">
                                <label for="numeroCte">Cliente:</label>
                            </td>
                            <td nowrap="nowrap">
                                <form:input type="text" id="numeroCte" name="numeroCte" maxlength="15" path="numeroCte" size="15" tabindex="6" />
                                <form:input type="text" path="nombreCompleto" name="nombreCompleto" id="nombreCompleto" maxlength="40" size="45" tabindex="7" disabled="true" readonly="true" />
                            </td>
                        </tr>



                        <tr>
                        <td class="label">
                            <label for="avalRelacion"> Aval: </label>
                          </td>
                          <td nowrap="nowrap">
                            <form:input type="text" id="avalRelacion" name="avalRelacion" path="avalRelacion" size="15" tabindex="7" />
                          <input type="text" id="nombreAvalRel" name="nombreAvalRel" size="40" disabled="true" tabindex="8" />
                      </td>
                        </tr>


                        <tr>
                              <td class="label">
                                <label for="garanteRelacion"> Garante: </label>
                            </td>

                             <td nowrap="nowrap">
                                  <form:input type="text" id="garanteRelacion" name="garanteRelacion" path="garanteRelacion" size="15" tabindex="8" />
                                <input type="text" id="nombreGaranteRel" name="nombreGaranteRel" size="40" disabled="true" tabindex="9" />
                            </td>
                        </tr>
                        <tr>
                            <td class="label" nowrap="nowrap">
                                <label for="cargoID">Cargo:</label>
                            </td>
                            <td nowrap="nowrap">
                                <form:input type="text" id="cargoID" name="cargoID" maxlength="15" path="cargoID" size="15" tabindex="10" />
                                <form:input type="text" path="descCargo" name="descCargo" id="descCargo" maxlength="6" size="45" tabindex="9" disabled="true" readonly="true" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <br>
                <div id="personasRelacionadas">
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Tipo de Persona</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esApoderado" name="esApoderado" path="esApoderado" value="N" tabindex="10" />
                                    <label for="esApoderado">Apoderado/Rep. Legal</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="consejoAdmon" name="consejoAdmon" path="consejoAdmon" value="N" tabindex="11" />
                                    <label for="consejoAdmon">Consejo de Admon.</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esAccionista" name="esAccionista" path="esAccionista" value="N" tabindex="11" />
                                    <label for="esAccionista">Accionista</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esPropReal" name="esPropReal" path="esPropReal" value="N" tabindex="11" />
                                    <label for="esPropReal">Propietario Real</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esSolicitante" name="esSolicitante" path="esSolicitante" value="N" tabindex="11" />
                                    <label for="esSolicitante">Solicitante</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esAutorizador" name="esAutorizador" path="esAutorizador" value="N" tabindex="11" />
                                    <label for="esAutorizador">Autorizador</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <form:input type="checkbox" id="esAdministrador" name="esAdministrador" path="esAdministrador" value="N" tabindex="11" />
                                    <label for="esAdministrador">Administrador</label>
                                </td>
                            </tr>
                            <tr id="infoAccionista">
                                <td class="label" nowrap="nowrap">
                                    <label for="nacion">Tipo Accionista: </label>
                                </td>
                                <td nowrap="nowrap">
                                    <form:select id="tipoAccionista" name="tipoAccionista" path="tipoAccionista" tabindex="12">
                                        <form:option value="">SELECCIONAR</form:option>
                                        <form:option value="F">PERSONA F&Iacute;SICA</form:option>
                                        <form:option value="M">PERSONA MORAL</form:option>
                                        <form:option value="A">PERSONA F&Iacute;SICA A.E.</form:option>
                                        <form:option value="G">GOBIERNO</form:option>
                                    </form:select>
                                </td>
                                <td class="label" id="porcentajeAcc" nowrap="nowrap">
                                    <label for="porcentajeAccion">Porcentaje: </label>

                                    <form:input id="porcentajeAccion" name="porcentajeAccion" path="porcentajeAccion" maxlength="8" size="7" tabindex="12" esMoneda="true" style="text-align: right;"  />
                                    <label for="porcentajeAccion">%</label>
                                </td>
                                <td class="separador"></td>
                                <td class="label" id="tdLblValorAcciones" nowrap="nowrap">
                                    <label for="valorAcciones">Valor de las acciones: </label>

                                    <form:input id="valorAcciones" name="valorAcciones" path="valorAcciones" size="15" tabindex="12" esMoneda="true" style="text-align: right;" maxlength="15" />
                                    <label for="valorAcciones">$</label>
                                </td>
                        </tr>
                        </table>
                    </fieldset>
                   </div>
                    <br>
                    <div id="datosPersonaFisica" style="display: block;">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend id="labelTitulo">Datos Generales de la Persona</legend>
                            <table>
                                <tr id="trCompania">
                                    <td class="label" nowrap="nowrap">
                                        <label for="compania">Nombre de Compa&ntilde;&iacute;a: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="compania" type="text" name="compania" path="compania" size="40" maxlength="150" tabindex="14" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr id="trDireciones">
                                    <td class="label" nowrap="nowrap">
                                        <label for="direccion2">Direcci&oacute;n 1: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="direccion1" type="text" name="direccion1" path="direccion1" size="40" maxlength="40" tabindex="15" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="direccion2">Direcci&oacute;n 2: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="direccion2" type="text" name="direccion2" path="direccion2" size="40" maxlength="40" tabindex="16" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr id="trTitular">
                                    <td class="label" nowrap="nowrap">
                                        <label for="titulo">Título: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:select id="titulo" name="titulo" path="titulo" tabindex="17">
                                            <form:option value="">SELECCIONAR</form:option>
                                            <form:option value="SR." />
                                            <form:option value="SRA." />
                                            <form:option value="SRITA." />
                                            <form:option value="LIC." />
                                            <form:option value="DR." />
                                            <form:option value="ING." />
                                            <form:option value="PROF." />
                                            <form:option value="C. P." />
                                        </form:select>
                                    </td>
                                    <td class="separador"></td>
                                </tr>
                                <tr id="trNombres">
                                    <td class="label" nowrap="nowrap">
                                        <label for="primerNombre">Primer Nombre: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="primerNombre" type="text" name="primerNombre" path="primerNombre" size="40" maxlength="50" tabindex="18" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="segundoNombre">Segundo Nombre: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="segundoNombre" type="text" name="segundoNombre" path="segundoNombre" size="40" maxlength="50" tabindex="19" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr id="trApellido">
                                    <td class="label" nowrap="nowrap">
                                        <label for="tercerNombre">Tercer Nombre: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="tercerNombre" type="text" name="tercerNombre" path="tercerNombre" size="40" maxlength="50" tabindex="20" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="apellidoPaterno">Apellido Paterno: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" maxlength="50" type="text" size="40" tabindex="21" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr id="trFecha">
                                    <td class="label">
                                        <label for="apellidoMaterno">Apellido Materno: </label>
                                    </td>
                                    <td>
                                        <form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="40" maxlength="50" type="text" tabindex="22" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="fechaNacimiento">Fecha de Nacimiento: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="14" type="text" tabindex="23" esCalendario="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label" nowrap="nowrap" id="lblPaisNacimiento">
                                        <label for="paisNacimiento">Pa&iacute;s de Nacimiento: </label>
                                    </td>
                                    <td nowrap="nowrap" id="tdPaisNacimiento">
                                        <form:input id="paisNacimiento" name="paisNacimiento" path="paisNacimiento" size="4" maxlength="5" type="text" tabindex="24" />
                                        <input id="paisNac" name="paisNac" path="paisNac" size="35" tabindex="21" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador" id="tdSeparador1"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="edoNacimiento" id="lblEdoNacimiento">Entidad Federativa: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="edoNacimiento" name="edoNacimiento" path="edoNacimiento" size="4" maxlength="11" type="text" tabindex="25" />
                                        <form:input id="nomEdoNacimiento" name="edoNacimiento" path="edoNacimiento" size="35" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador" id="tdSeparador2"></td>
                                    <td class="label" nowrap="nowrap" id="tdMunNacimiento">
                                        <label for="munNacimiento">Del./ Municipio: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="munNacimiento" name="munNacimiento" path="munNacimiento" size="4" maxlength="11" type="text" tabindex="26" />
                                        <input id="nomMunNacimiento" name="nomMunNacimiento" path="nomMunNacimiento" size="35" readOnly="true" disabled="true" type="text" />
                                    </td>
                                </tr>
                                <tr id="trColonia">
                                    <td class="label" nowrap="nowrap">
                                        <label for="locNacimiento">Localidad: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="locNacimiento" name="locNacimiento" path="locNacimiento" size="4" maxlength="11" type="text" tabindex="27" />
                                        <input id="nomLocalidad" name="nomLocalidad" path="nomLocalidad" size="35" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador" id="tdSeparador2"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="nombreCiudad">Ciudad: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="nombreCiudad" name="nombreCiudad" path="nombreCiudad" size="40" maxlength="40" type="text" tabindex="28" />
                                    </td>
                                </tr>
                                <tr id="trCodigo">
                                    <td class="label" nowrap="nowrap">
                                        <label for="coloniaID">Colonia: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="coloniaID" name="coloniaID" path="coloniaID" size="4" maxlength="11" type="text" tabindex="29" />
                                        <input id="nomColoniaID" name="nomColoniaID" path="nomColoniaID" size="35" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="codigoPostal">Codigo Postal: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="codigoPostal" name="codigoPostal" path="codigoPostal" size="5" maxlength="5" type="text" tabindex="30" />
                                    </td>
                                </tr>
                                <tr id="trFax">
                                    <td class="label" nowrap="nowrap">
                                        <label for="telefonoCompania">Tel&eacute;fono: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <input id="telefonoCompania" name="telefonoCompania" path="telefonoCompania" size="11" maxlength="11" type="text" tabindex="31" />

                                        <label for="extensionCompania">Ext: </label>
                                        <input id="extensionCompania" name="extensionCompania" path="extensionCompania" size="8" maxlength="8" type="text" tabindex="32" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="faxCompania">Fax: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <input id="faxCompania" name="faxCompania" path="faxCompania" size="11" maxlength="11" type="text" tabindex="33" />
                                    </td>
                                </tr>
                                <tr id="trPaisCompania">
                                    <td class="label" nowrap="nowrap">
                                        <label for="paisCompania">Pa&iacute;s: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <input id="paisCompania" name="paisCompania" path="paisCompania" size="5" maxlength="40" type="text" tabindex="34" />
                                        <input id="nomPaisCompania" name="nomPaisCompania" path="nomPaisCompania" size="34" tabindex="21" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="paisCompania">Edo. Extranjero: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="edoExtranjero" type="text" name="edoExtranjero" path="edoExtranjero" size="40" maxlength="40" tabindex="35" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr id="trEstadoCivil">
                                    <td class="label" nowrap="nowrap">
                                        <label for="estadoCivil">Estado Civil: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:select id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="35">
                                            <form:option value="">SELECCIONAR</form:option>
                                            <form:option value="S">SOLTERO</form:option>
                                            <form:option value="CS">CASADO BIENES SEPARADOS</form:option>
                                            <form:option value="CM">CASADO BIENES MANCOMUNADOS</form:option>
                                            <form:option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</form:option>
                                            <form:option value="V">VIUDO</form:option>
                                            <form:option value="D">DIVORCIADO</form:option>
                                            <form:option value="SE">SEPARADO</form:option>
                                            <form:option value="U">UNION LIBRE</form:option>
                                        </form:select>
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="sexo">Género: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:select id="sexo" name="sexo" path="sexo" tabindex="36">
                                            <form:option value="">SELECCIONAR</form:option>
                                            <form:option value="M">MASCULINO</form:option>
                                            <form:option value="F">FEMENINO</form:option>
                                        </form:select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label" nowrap="nowrap" id="lblCurp">
                                        <label for="CURP">CURP: </label>
                                    </td>
                                    <td nowrap="nowrap" id="tdCurp">
                                        <form:input id="CURP" name="CURP" path="CURP" size="25" tabindex="37" maxlength="18" onBlur="ponerMayusculas(this);" />
                                        <input type="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;" />
                                    </td>
                                    <td class="separador" id="separadorCurp"></td>
                                    <td class="label" nowrap="nowrap" id="lblRfc">
                                        <label for="RFC" >RFC: </label>
                                    </td>
                                    <td nowrap="nowrap" id="tdRfc">
                                        <form:input id="RFC" name="RFC" path="RFC" size="13" tabindex="38" onBlur="ponerMayusculas(this);" />
                                        <button type="button" class="submit" id="generar" style="display: none;">Calcular</button>
                                    </td>
                                </tr>
                                <tr id="registroFea">
                                    <td class="label" nowrap="nowrap">
                                        <label for="FEA">Registro de FEA:&nbsp;</label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="FEA" name="FEA" path="FEA" onblur="ponerMayusculas(this)" type="text" size="30" maxlength="250" tabindex="39" />
                                    </td>
                                    <td class="separador" nowrap="nowrap"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="paisFea">Pa&iacute;s que Asigna FEA: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="paisFea" name="paisFea" maxlength="11" path="paisFea" size="5" tabindex="40" />
                                        <input type="text" id="paisF" name="paisF" size="34" tabindex="29" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                </tr>
                                <tr id="trOcupaciones">
                                    <td class="label" nowrap="nowrap">
                                        <label for="ocupacionID">Ocupaci&oacute;n: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="4" tabindex="41" maxlength="5" />
                                        <input type="text" id="ocupacionC" name="ocupacionC" size="35" readOnly="true" disabled="true" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="puestoA">Puesto: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="puestoA" name="puestoA" path="puestoA" size="40" tabindex="42" onBlur="ponerMayusculas(this);" maxlength="100" />
                                    </td>
                                </tr>
                                <tr id="trIngresoRealoRecursos">
                                    <td class="label" width="20%" nowrap="nowrap">
                                        <label for="ingreRealoRecursos">Ingresos Propietario Real o Proveedor de Recursos:</label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="ingreRealoRecursos" name="ingreRealoRecursos" path="ingreRealoRecursos" size="25" tabindex="43" esmoneda="true" maxlength="18" style="text-align: right;" />
                                    </td>
                                    <td class="separador"></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <input type="hidden" id="fax" name="fax"/>
                            </table>
                        </fieldset>
                        <br>
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Actividad</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="sectorGeneral">Sector General: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="sectorGeneral" name="sectorGeneral" path="sectorGeneral" size="7" tabindex="44" />
                                        <input id="sectorGral" name="sectorGral" size="45" type="text" readOnly="true" disabled="true" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="actividadBancoMX">Actividad BancoMX: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="actividadBancoMX" name="actividadBancoMX" path="actividadBancoMX" size="15" tabindex="45" />
                                        <input id="descripcionBMX" name="actividadBMX" size="45" type="text" readOnly="true" disabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="actividadINEGI">Actividad INEGI: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="actividadINEGI" name="actividadINEGI" path="actividadINEGI" size="7" tabindex="35" readOnly="true" disabled="true" />
                                        <input id="descripcionINEGI" name="actINEGI" size="45" type="text" readOnly="true" disabled="true" tabindex="46" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="sectorEconomico">Sector Económico: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="sectorEconomico" name="sectorEconomico" path="sectorEconomico" size="15" readOnly="true" disabled="true" tabindex="37" />
                                        <input id="descripcionSE" name="sectorEco" size="45" type="text" readOnly="true" disabled="true" tabindex="47" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <br>
                        <div id="identificaciones">
                            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                <legend>Identificaci&oacute;n</legend>
                                <table border="0" width="100%">
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="tipoIdentiID">Tipo de Identificaci&oacute;n: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="48">
                                                <form:option value="-1">SELECCIONAR</form:option>
                                            </form:select>
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="otraIdentifi" id="lbIOtradentificacion" style="display: none;">Otra Identificaci&oacute;n: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="otraIdentifi" name="otraIdentifi" path="otraIdentifi" size="25" maxlength="20" tabindex="49" style="display: none;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="numIdentific">No. de Identificaci&oacute;n: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="numIdentific" name="numIdentific" path="numIdentific" size="25" maxlength="20" tabindex="50" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="fecExIden">Fecha Expedici&oacute;n Identificaci&oacute;n: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="fecExIden" name="fecExIden" path="fecExIden" size="14" tabindex="51" esCalendario="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="fecVenIden">Fecha Vencimiento Identificaci&oacute;n:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="fecVenIden" name="fecVenIden" path="fecVenIden" size="14" tabindex="52" esCalendario="true" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="telefonoCasa">Tel&eacute;fono Casa: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="telefonoCasa" name="telefonoCasa" path="telefonoCasa" size="15" maxlength="20" tabindex="53" />
                                            <label for="extTelefonoPart">Ext.:</label>
                                            <form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" maxlength="6" tabindex="53" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="telefonoCelular">Tel&eacute;fono Celular: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="14" maxlength="20" tabindex="54" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="correo">Correo: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="correo" name="correo" path="correo" size="35" tabindex="55" maxlength="50" />
                                        </td>
                                    </tr>
<!--                                     <tr> -->
<!--                                         <td class="label" nowrap="nowrap"> -->
<!--                                             <label for="domicilio">Domicilio: </label> -->
<!--                                         </td> -->
<!--                                         <td colspan="4" nowrap="nowrap"> -->
<%--                                             <form:textarea id="domicilio" name="domicilio" path="domicilio" maxlength="200" cols="60" tabindex="56" onBlur="ponerMayusculas(this);" /> --%>
<!--                                         </td> -->
<!--                                     </tr> -->
                                </table>
                            </fieldset>
                        </div>
                        <br>

                        <!-- SECCIÓN DE DOMICILIO -->
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Domicilio</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblPaisNacimiento">Pa&iacute;s: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="paisIDDom" name="paisIDDom" path="paisIDDom" size="8" tabindex="56" maxlength="8" autocomplete="off"/>
                                        <input type="text" id="nombrePaisNac" name="nombrePaisNac" size="50" readonly="true"/>
                                    </td>
                                    <td class="separador">&nbsp;</td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblEntidadFederativa">Entidad Federativa: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="estadoIDDom" name="estadoIDDom" path="estadoIDDom" size="8" tabindex="57" maxlength="8" autocomplete="off"/>
                                        <input type="text" id="nombreEdoNacimiento" name="nombreEdoNacimiento" size="50" readonly="true"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblMunicipio">Municipio: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="municipioIDDom" name="municipioIDDom" path="municipioIDDom" size="8" tabindex="58" maxlength="8" autocomplete="off"/>
                                        <input type="text" id="nombreMunicipio" name="nombreMunicipio" size="50" readonly="true"/>
                                    </td>
                                    <td class="separador">&nbsp;</td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblLocalidad">Localidad: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="localidadIDDom" name="localidadIDDom" path="localidadIDDom" size="8" tabindex="58" maxlength="8" autocomplete="off"/>
                                        <input type="text" id="nombreLocalidad" name="nombreLocalidad" size="50" readonly="true"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblColonia">Colonia: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="coloniaIDDom" name="coloniaIDDom" path="coloniaIDDom" size="8" tabindex="58" maxlength="8" autocomplete="off"/>
                                        <form:input type="text" id="nombreColonia" name="nombreColonia" path="nombreColoniaDom" size="50" readonly="true"/>
                                    </td>
                                    <td class="separador">&nbsp;</td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblCiudad">Ciudad: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="nombreCiudadDom" name="nombreCiudadDom" path="nombreCiudadDom" size="59" tabindex="59" maxlength="58" autocomplete="off"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblCalle">Calle: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="calleDom" name="calleDom" path="calleDom" onBlur="ponerMayusculas(this);" size="59" tabindex="60" maxlength="58" autoComplete="off"/>
                                    </td>
                                    <td class="separador">&nbsp;</td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblNumero">N&uacute;mero: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="numExteriorDom" name="numExteriorDom" path="numExteriorDom" size="4" tabindex="61" maxlength="4" autocomplete="off"/>
                                        <label for="lblInterior">Interior: </label>
                                        <form:input type="text" id="numInteriorDom" name="numInteriorDom" path="numInteriorDom" size="4" tabindex="62" maxlength="4" autocomplete="off"/>
                                        <label for="lblPiso">Piso: </label>
                                        <form:input type="text" id="pisoDom" name="pisoDom" path="pisoDom" size="4" tabindex="63" maxlength="4" autocomplete="off"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="primeraEntreDom">Primera Entre Calle: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="primeraEntreDom" name="primeraEntreDom" path="primeraEntreDom" onBlur="ponerMayusculas(this);" size="59" tabindex="64" maxlength="58" autoComplete="off"/>
                                    </td>
                                    <td class="separador">&nbsp;</td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="segundaEntreDom">Segunda Entre Calle: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input type="text" id="segundaEntreDom" name="segundaEntreDom" path="segundaEntreDom" size="59" tabindex="65" onBlur="ponerMayusculas(this);" autocomplete="off"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblCP">C&oacute;digo Postal: </label>
                                    </td>
                                    <td colspan="4" nowrap="nowrap">
                                        <form:input type="text" id="codigoPostalDom" name="codigoPostalDom" path="codigoPostalDom" size="12" tabindex="66" maxlength="5" autocomplete="off"/>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblDomicilio">Domicilio Completo: </label>
                                    </td>
                                    <td colspan="4" nowrap="nowrap">
                                        <form:textarea id="domicilioCompleto" name="domicilioCompleto" path="domicilio" maxlength="500" cols="57" tabindex="67" onBlur="ponerMayusculas(this);" readonly="true"/>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <br>

                        <div id="nacionalidades">
                            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                <legend>Nacionalidad</legend>
                                <table border="0" width="100%">
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="nacion">Nacionalidad: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:select id="nacion" name="nacion" path="nacion" tabindex="68">
                                                <form:option value="">SELECCIONAR</form:option>
                                                <form:option value="N">NACIONAL</form:option>
                                                <form:option value="E">EXTRANJERO</form:option>
                                            </form:select>
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="paisResidencia">Pa&iacute;s Residencia: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="7" maxlength="5" tabindex="69" readOnly="true" />
                                            <input id="paisR" name="paisR" size="50" type="text" readOnly="true" disabled="true" tabindex="70" />
                                        </td>
                                    </tr>
                                    <tr name="extranjero" style="display: none;">
                                        <td class="label" nowrap="nowrap">
                                            <label for="lblDocEstanciaLegal">Documento Estancia Legal: </label>
                                        </td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="lblMoneda">FM2 </label>
                                            <form:radiobutton id="docEstanciaLegal" name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3" value="FM2" tabindex="71" checked="checked" />
                                            &nbsp;&nbsp; <label for="lblMoneda">FM3 </label>
                                            <form:radiobutton id="docEstanciaLegal" name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3" value="FM3" tabindex="72" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="docExisLegal">Documento Existencia Legal: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="docExisLegal" name="docExisLegal" path="docExisLegal" size="40" maxlength="30" tabindex="73" onBlur="ponerMayusculas(this);" />
                                        </td>
                                    </tr>
                                    <tr name="extranjero" style="display: none;">
                                        <td class="label" nowrap="nowrap">
                                            <label for="fechaVenEst">Fecha Vencimiento Estancia: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="fechaVenEst" name="fechaVenEst" path="fechaVenEst" size="14" tabindex="74" esCalendario="true" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="paisRFC">País que Asigna RFC: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input type="text" id="paisRFC" name="paisRFC" path="paisRFC" size="7" maxlength="11" tabindex="75" />
                                            <input type="text" id="NomPaisRFC" name="NomPaisRFC" size="50" tabindex="76" readOnly="true" disabled="true" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                        <div id="escritura" style="display: none;">
                            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                                <legend>Escritura</legend>
                                <table border="0" width="100%">
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="numEscPub">No. Escritura Pública: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="numEscPub" name="numEscPub" path="numEscPub" size="7" tabindex="78" maxlength="50" readOnly="true" disabled="true" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="fechaEscPub">Fecha Escritura Pública: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="fechaEscPub" name="fechaEscPub" path="fechaEscPub" size="14" tabindex="79" readOnly="true" disabled="true"  esCalendario="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="estadoID">Estado:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="estadoID" name="estadoID" path="estadoID" size="7" tabindex="80" readOnly="true" disabled="true"  maxlength="11" />
                                            <input id="nombreEstado" name="nombreEstado" size="30" type="text" readOnly="true" disabled="true" tabindex="80" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="municipioID">Municipio:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="municipioID" name="municipioID" path="municipioID" size="7" maxlength="11" readOnly="true" disabled="true"  tabindex="81" />
                                            <input id="nombreMuni" name="nombreMuni" size="40" type="text" readOnly="true" disabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" nowrap="nowrap">
                                            <label for="notariaID">Notaria:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="notariaID" name="notariaID" path="notariaID" size="7" tabindex="82" readOnly="true" disabled="true"  maxlength="11" />
                                        </td>
                                        <td class="separador"></td>
                                        <td class="label" nowrap="nowrap">
                                            <label for="titularNotaria">Titular Notaria:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="titularNotaria" name="titularNotaria" path="titularNotaria" size="60" maxlength="100" tabindex="83" readOnly="true" disabled="true" />
                                        </td>
                                    </tr>
                                    <tr id="escDireccion">
                                        <td class="label" nowrap="nowrap">
                                            <label for="lblDireccion">Direcci&oacute;n:</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <textarea id="direccion" name="direccion" path="direccion" cols="60" type="textarea" readOnly="true" disabled="true" tabindex="85" onBlur="ponerMayusculas(this);"></textarea>
                                        </td>
                                         <td class="separador"></td>
                                         <td class="label" nowrap="nowrap">
                                            <label for="folioMercantil">Folio Mercantil Electr&oacute;nico: </label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <form:input id="folioMercantil" name="folioMercantil" path="folioMercantil" size="20" tabindex="86" maxlength="10" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </div>
                    </div>
                    <table border="0" width="100%">
                        <tr>
                            <td colspan="5">
                                <table align="right">
                                    <tr>
                                        <td align="right">
                                            <input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="82" /> <input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="76" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> <input type="hidden" id="numeroCaracteres" name="numeroCaracteres" /> <input type="hidden" id="tipoPersona" name="tipoPersona" path="tipoPersona" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
            </fieldset>
        </form:form>
    </div>
    <div id="cargando" style="display: none;"></div>
    <div id="cajaLista" style="display: none;">
        <div id="elementoLista" />
    </div>
</body>
<div id="mensaje" style="display: none;" />
</html>