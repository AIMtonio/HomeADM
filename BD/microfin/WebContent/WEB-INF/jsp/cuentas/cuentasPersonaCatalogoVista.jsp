<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>

<head>
    <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tipoSociedadServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/cuentasPersonaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/sectoresServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/escrituraServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/cliExtranjeroServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
 	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
    <script type="text/javascript" src="js/soporte/mascara.js"></script>

    <script type="text/javascript" src="js/cuentas/cuentaPersonaCatalogo.js"></script>
    <script type="text/javascript" src="js/general.js"></script>
    <script type="text/javascript" src="js/generarRFC.js"></script>
</head>

<body>
    <div id="contenedorForma">
        <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasPersonaBean">
            <fieldset class="ui-widget ui-widget-content ui-corner-all">
                <legend class="ui-widget ui-widget-header ui-corner-all">Personas Relacionadas a la Cuenta</legend>
                <fieldset class="ui-widget ui-widget-content ui-corner-all">
                    <legend>Datos del <s:message code="safilocale.cliente" /></legend>
                    <table border="0" width="100%">
                        <tr>
                            <td class="label">
                                <label for="lblCuentaAhoID">Cuenta: </label>
                            </td>
                            <td>
                                <form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" iniForma='false' tabindex="1" type="text" />
                            </td>
                            <td class="separador"></td>
                            <td class="label">
                                <label for="lblNombreCliente">Nombre <s:message code="safilocale.cliente"/>: </label>
                            </td>
                            <td>
                                <input id="numCliente" name="numCliente" size="11" type="text" readOnly="true" disabled="true" tabindex="2" iniForma='false' />
                                <input id="nombreCliente" name="nombreCliente" size="60" type="text" disabled="true" tabindex="3" iniForma='false' />
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                <label for="lblCuentaAhoID">Tipo Cuenta: </label>
                            </td>
                            <td>
                                <input id="tipoCuenta" name="tipoCuenta" size="25" type="text" disabled="true" tabindex="4" iniForma='false' />
                            </td>
                            <td class="separador"></td>
                            <td class="label">
                                <label for="lblMoneda">Moneda: </label>
                            </td>
                            <td>
                                <input id="moneda" name="moneda" size="25" type="text" disabled="true" tabindex="5" iniForma='false' />
                            </td>
                        </tr>
                        <tr>
                            <td class="label" nowrap="nowrap">
                                <label for="lblTipoPersona">Tipo Persona: </label>
                            </td>
                            <td>
                                <input id="tipoPer" name="tipoPer" size="22" iniForma='false' type="text" disabled="true" tabindex="6" />
                            </td>
                            <td class="separador"></td>
                            <td class="label" nowrap="nowrap">
                                <label for="lblTotalPer">N&uacute;mero de Personas Relacionadas: </label>
                            </td>
                            <td>
                                <input id="totalPer" name="totalPer" size="11" type="text" disabled="true" iniForma='false' />
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <div id="personasRelacionadas">
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Búsqueda</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblPersonaID">Persona Relacionada: </label>
                                </td>
                                <td>
                                    <form:input id="personaID" name="personaID" path="personaID" size="11" tabindex="7" type="text" />
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="numero"><s:message code="safilocale.cliente"/>: </label>
                                </td>
                                <td>
                                    <input id="numeroCte" name="numeroCte" path="numeroCte" size="11" tabindex="8" type="text" />
                                    <input id="nombreCompleto" name="nombreCompleto" size="60" type="text" disabled="true" tabindex="9" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Tipo de Persona</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label">
                                    <form:input type="checkbox" id="esApoderado" name="esApoderado" path="esApoderado" value="S" tabindex="10" />
                                    <label for="esApoderado">Apoderado/Rep. Legal</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esAccionista" name="esAccionista" path="esAccionista" value="S" tabindex="11" />
                                    <label for="esAccionista">Accionista</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esTitular" name="esTitular" path="esTitular" value="S" tabindex="12" />
                                    <label for="esTitular">Titular</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esCotitular" name="esCotitular" path="esCotitular" value="S" tabindex="13" />
                                    <label for="esCotitular">Cotitular</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esBeneficiario" name="esBeneficiario" path="esBeneficiario" value="S" tabindex="14" />
                                    <label for="esBeneficiario">Beneficiario</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esProvRecurso" name="esProvRecurso" path="esProvRecurso" value="S" tabindex="15" />
                                    <label for="esProvRecurso">Proveedor de Recursos</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esPropReal" name="esPropReal" path="esPropReal" value="S" tabindex="16" />
                                    <label for="esPropReal">Propietario Real</label>
                                </td>
                                <td class="label">
                                    <form:input type="checkbox" id="esFirmante" name="esFirmante" path="esFirmante" value="S" tabindex="17" />
                                    <label for="esFirmante">Firmante</label>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <div id="datosPersonaMoral" style="display:none">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Datos Generales de la Empresa</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label">
                                        <label for="razonSocialPM">Raz&oacute;n Social:</label>
                                    </td>
                                    <td>
                                        <form:input id="razonSocialPM" name="razonSocialPM" path="razonSocialPM" size="50" tabindex="18" onBlur=" ponerMayusculas(this)" maxlength="150" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="RFCpm">RFC:</label>
                                    </td>
                                    <td>
                                        <form:input id="RFCpm" name="RFCpm" path="RFCpm" tabindex="19" maxlength="12" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="nacionalidadPM">Nacionalidad:</label>
                                    </td>
                                    <td>
                                        <form:select id="nacionalidadPM" name="nacionalidadPM" path="nacionalidadPM" tabindex="20">
                                            <form:option value="">SELECCIONAR</form:option>
                                            <form:option value="N">MEXICANA</form:option>
                                            <form:option value="E">EXTRANJERA</form:option>
                                        </form:select>
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="paisConstitucionID">Pa&iacute;s de Constituci&oacute;n:</label>
                                    </td>
                                    <td>
                                        <form:input id="paisConstitucionID" name="paisConstitucionID" path="paisConstitucionID" size="7" tabindex="21" maxlength="5" />
                                        <input type="text" id="descPaisConst" name="descPaisConst" size="40" tabindex="22" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="correoPM">Correo Electr&oacute;nico:</label>
                                    </td>
                                    <td>
                                        <form:input id="correoPM" name="correoPM" path="correoPM" size="50" tabindex="23" maxlength="50" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="correoAlterPM">Correo Alternativo:</label>
                                    </td>
                                    <td>
                                        <form:input id="correoAlterPM" name="correoAlterPM" path="correoAlterPM" size="48" tabindex="24" maxlength="50" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="telefonoPM">Tel&eacute;fono:</label>
                                    </td>
                                    <td>
                                        <form:input id="telefonoPM" name="telefonoPM" maxlength="15" path="telefonoPM" size="15" tabindex="25" />
                                        <label for="ext">Ext.:</label>
                                        <form:input path="extTelefonoPM" id="extTelefonoPM" name="extTelefonoPM" maxlength="6" tabindex="26" size="10" />
                                    </td>

                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="sociedad">Tipo de Sociedad: </label>
                                    </td>
                                    <td>
                                        <form:input id="tipoSociedadID" name="tipoSociedadID" path="tipoSociedadID" size="7" tabindex="27" />
                                        <input type="text" id="descripSociedad" name="descripSociedad" size="40" tabindex="29" disabled="true" readOnly="true" onBlur="ponerMayusculas(this)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="grupoEmpresarial">Grupo Empresarial:</label>
                                    </td>
                                    <td>
                                        <form:input id="grupoEmpresarial" name="grupoEmpresarial" path="grupoEmpresarial" size="6" tabindex="30" />
                                        <input type="text" id="descripcionGE" name="descripcionGE" size="30" tabindex="31" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="fechaRegistroPM">Fecha de Registro:</label>
                                    </td>
                                    <td>
                                        <form:input id="fechaRegistroPM" name="fechaRegistroPM" path="fechaRegistroPM" size="20" tabindex="32" esCalendario="true" maxlength="20" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="nombreNotario">Nombre Notario:</label>
                                    </td>
                                    <td>
                                        <form:input id="nombreNotario" name="nombreNotario" path="nombreNotario" size="50" tabindex="33" onBlur=" ponerMayusculas(this)" maxlength="150" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="numNotario">No. Notario:</label>
                                    </td>
                                    <td>
                                        <form:input id="numNotario" name="numNotario" path="numNotario" size="20" tabindex="34" maxlength="11" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="inscripcionReg">Inscripci&oacute;n Reg.:</label>
                                    </td>
                                    <td>
                                        <form:input id="inscripcionReg" name="inscripcionReg" path="inscripcionReg" size="50" tabindex="35" onBlur=" ponerMayusculas(this)" maxlength="50" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="escrituraPubPM">Escritura P&uacute;blica:</label>
                                    </td>
                                    <td>
                                        <form:input id="escrituraPubPM" name="escrituraPubPM" path="escrituraPubPM" size="20" tabindex="36" maxlength="20" autocomplete="off" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="FEAPM">Registro de FEA:&nbsp;</label>
                                    </td>
                                    <td>
                                        <form:input id="feaPM" name="feaPM" path="feaPM" onblur="ponerMayusculas(this)" type="text" size="30" maxlength="100" tabindex="37" />
                                    </td>
                                    <td class="separador" nowrap="nowrap"></td>

                                    <td class="label"><label for="paisFealPM">Pa&iacute;s que Asigna FEA: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="paisFeaPM" name="paisFeaPM" path="paisFeaPM" size="5" tabindex="38" />
                                        <input type="text" id="paisFPM" name="paisFPM" size="30" tabindex="39" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                </tr>
                                <tr id="porcentajeAccMo">
                                    <td class="label">
                                        <label for="lblPorcentaje1">Porcentaje: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="porcentajeAccionM" name="porcentajeAccionM" path="porcentajeAccionM" maxlength="8" size="7" tabindex="40" esTasa="true" /> <label for="lblPorcentajeSigno">%</label>
                                    </td>

                                </tr>

                            </table>
                        </fieldset>
                    </div>
                    <div id="datosPersonaFisica" style="display: block;">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Datos Generales de la Persona</legend>
                            <table>
                                <tr id="divTipoPersona" style="display:none">
                                    <td class="label">
                                        <form:radiobutton id="tipoPersonaF" name="tipoPersonaF" path="tipoPersonaP" value="F" tabindex="41" />
                                        <label for="tipoPersonaF">Física</label>
                                        <form:radiobutton id="tipoPersonaM" name="tipoPersonaM" path="tipoPersonaP" value="M" tabindex="42" />
                                        <label for="tipoPersonaM">Moral</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblTitulo">Título: </label>
                                    </td>
                                    <td>
                                        <form:select id="titulo" name="titulo" path="titulo" tabindex="43">
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
                                    <td class="label" id="porcentajeAcc">
                                        <label for="lblPorcentaje">Porcentaje: </label>
                                    </td>
                                    <td nowrap="nowrap" id="porcentajeAccVal">
                                        <form:input id="porcentajeAccion" name="porcentajeAccion" path="porcentajeAccion" maxlength="8" size="7" tabindex="44" esTasa="true" /> <label for="lblPorcentajeSigno">%</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblPrimerNombre">Primer Nombre: </label>
                                    </td>
                                    <td>
                                        <form:input id="primerNombre" type="text" name="primerNombre" path="primerNombre" size="25" maxlength="50" tabindex="45" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblSegundoNombre">Segundo Nombre: </label>
                                    </td>
                                    <td>
                                        <form:input id="segundoNombre" type="text" name="segundoNombre" path="segundoNombre" size="25" maxlength="50" tabindex="46" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblTercerNombre">Tercer Nombre: </label>
                                    </td>
                                    <td>
                                        <form:input id="tercerNombre" type="text" name="tercerNombre" path="tercerNombre" size="25" maxlength="50" tabindex="47" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblApellidoPaterno">Apellido Paterno: </label>
                                    </td>
                                    <td>
                                        <form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" maxlength="50" type="text" size="25" tabindex="48" onBlur="ponerMayusculas(this);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblApellidoMaterno">Apellido Materno: </label>
                                    </td>
                                    <td>
                                        <form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="25" maxlength="50" type="text" tabindex="49" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblFechaNac">Fecha de Nacimiento: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="14" type="text" tabindex="50" esCalendario="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblPaisNacimiento">Pa&iacute;s de Nacimiento: </label>
                                    </td>
                                    <td>
                                        <form:input id="paisNacimiento" name="paisNacimiento" path="paisNacimiento" size="4" maxlength="5" type="text" tabindex="51" />
                                        <input id="paisNac" name="paisNac" path="paisNac" size="30" tabindex="52" readOnly="true" disabled="true" type="text" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblentidadfederativa">Entidad Federativa: </label>
                                    </td>
                                    <td>
                                        <form:input id="edoNacimiento" name="edoNacimiento" path="edoNacimiento" size="4" maxlength="11" type="text" tabindex="53" />
                                        <form:input id="nomEdoNacimiento" name="edoNacimiento" path="edoNacimiento" size="30" readOnly="true" disabled="true" type="text" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblEstadoCivil">Estado Civil: </label>
                                    </td>
                                    <td>
                                        <form:select id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="54">
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
                                    <td class="label">
                                        <label for="lblSexo">Género: </label>
                                    </td>
                                    <td>
                                        <form:select id="sexo" name="sexo" path="sexo" tabindex="55">
                                            <form:option value="">SELECCIONAR</form:option>
                                            <form:option value="M">MASCULINO</form:option>
                                            <form:option value="F">FEMENINO</form:option>
                                        </form:select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblCURP">CURP: </label>
                                    </td>
                                    <td>
                                        <form:input id="CURP" name="CURP" path="CURP" size="25" tabindex="56" maxlength="18" onBlur="ponerMayusculas(this);" />
                                        <input type="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblRFC">RFC: </label>
                                    </td>
                                    <td>
                                        <form:input id="RFC" name="RFC" path="RFC" size="18" tabindex="57" maxlength="13" onBlur="ponerMayusculas(this);" />
                                        <button type="button" class="submit" id="generar" style="display: none;">Calcular</button>
                                    </td>
                                </tr>

                                <tr id="registroFea">
                                    <td class="label">
                                        <label for="FEA">Registro de FEA:&nbsp;</label>
                                    </td>
                                    <td>
                                        <form:input id="FEA" name="FEA" path="FEA" onblur="ponerMayusculas(this)" type="text" size="30" maxlength="100" tabindex="58" />
                                    </td>
                                    <td class="separador" nowrap="nowrap"></td>
                                    <td class="label"><label for="paisFeal">Pa&iacute;s que Asigna FEA: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="paisFea" name="paisFea" path="paisFea" size="5" tabindex="59" />
                                        <input type="text" id="paisF" name="paisF" size="30" tabindex="60" disabled="true" readOnly="true" onBlur=" ponerMayusculas(this)" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label">
                                        <label for="lblOcupacionID">Ocupaci&oacute;n: </label>
                                    </td>
                                    <td>
                                        <form:input id="ocupacionID" name="ocupacionID" path="ocupacionID" size="4" tabindex="61" maxlength="5" />
                                        <input type="text" id="ocupacionC" name="ocupacionC" size="35" readOnly="true" disabled="true" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblPuestoA">Puesto: </label>
                                    </td>
                                    <td>
                                        <form:input id="puestoA" name="puestoA" path="puestoA" size="40" tabindex="62" onBlur="ponerMayusculas(this);" maxlength="100" />
                                    </td>
                                </tr>
                                <tr id="trIngresoRealoRecursos">
                                    <td class="label" width="20%" nowrap="nowrap">
                                        <label for="lblIngreRealoRecursos">Ingresos Propietario Real o Proveedor de Recursos:</label>
                                    </td>
                                    <td>
                                        <form:input id="ingreRealoRecursos" name="ingreRealoRecursos" path="ingreRealoRecursos" size="25" tabindex="63" esmoneda="true" maxlength="18" />
                                    </td>
                                    <td class="separador"></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Actividad</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label">
                                    <label for="lblSectorGeneral">Sector General: </label>
                                </td>
                                <td>
                                    <form:input id="sectorGeneral" name="sectorGeneral" path="sectorGeneral" size="7" tabindex="64" />
                                    <input id="sectorGral" name="sectorGral" size="45" type="text" readOnly="true" disabled="true" />
                                </td>
                                <td class="separador"></td>

                                <td class="label" nowrap="nowrap">
                                    <label for="lblActividadBancoMX">Actividad BancoMX: </label>
                                </td>
                                <td>
                                    <form:input id="actividadBancoMX" name="actividadBancoMX" path="actividadBancoMX" size="15" tabindex="65" />
                                    <input id="descripcionBMX" name="actividadBMX" size="45" type="text" readOnly="true" disabled="true" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblActividadINEGI">Actividad INEGI: </label>
                                </td>
                                <td>
                                    <form:input id="actividadINEGI" name="actividadINEGI" path="actividadINEGI" size="7" tabindex="66" readOnly="true" disabled="true" />
                                    <input id="descripcionINEGI" name="actINEGI" size="45" type="text" readOnly="true" disabled="true" tabindex="67" />
                                </td>
                                <td class="separador"></td>

                                <td class="label">
                                    <label for="lblSectorEconomico">Sector Económico: </label>
                                </td>
                                <td>
                                    <form:input id="sectorEconomico" name="sectorEconomico" path="sectorEconomico" size="15" readOnly="true" disabled="true" tabindex="68" />
                                    <input id="descripcionSE" name="sectorEco" size="45" type="text" readOnly="true" disabled="true" tabindex="69" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Identificaci&oacute;n</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label">
                                    <label for="lblTipoIdentiID">Tipo de Identificaci&oacute;n: </label>
                                </td>
                                <td>
                                    <form:select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="70">
                                        <form:option value="-1">SELECCIONAR</form:option>
                                        <!--<form:option value="-1">Seleccionar</form:option>-->
                                    </form:select>
                                </td>
                                <td class="separador"></td>

                                <td class="label">
                                    <label for="lblOtraIdentifi" id="lbIOtradentificacion" style="display: none;">Otra Identificaci&oacute;n: </label>
                                </td>
                                <td>
                                    <form:input id="otraIdentifi" name="otraIdentifi" path="otraIdentifi" size="25" maxlength="20" tabindex="71" style="display: none;" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="lblNumIdentific">No. de Identificaci&oacute;n: </label>
                                </td>
                                <td>
                                    <form:input id="numIdentific" name="numIdentific" path="numIdentific" size="25" maxlength="18" tabindex="72" />
                                </td>
                                <td class="separador"></td>

                                <td class="label" nowrap="nowrap">
                                    <label for="lblFecExIden">Fecha Expedici&oacute;n Identificaci&oacute;n: </label>
                                </td>
                                <td>
                                    <form:input id="fecExIden" name="fecExIden" path="fecExIden" size="14" tabindex="73" esCalendario="true" />
                                </td>
                            </tr>
                            <tr>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblFecVenIden">Fecha Vencimiento Identificaci&oacute;n:</label>
                                </td>
                                <td>
                                    <form:input id="fecVenIden" name="fecVenIden" path="fecVenIden" size="14" tabindex="74" esCalendario="true" />
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="lblTelefonoCasa">Tel&eacute;fono Casa: </label>
                                </td>
                                <td>
                                    <form:input id="telefonoCasa" name="telefonoCasa" path="telefonoCasa" size="15" maxlength="10" tabindex="75" />
                                    <label for="lblExtTelefono">Ext.:</label>
                                    <form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" size="10" maxlength="6" tabindex="76" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="lblTelefonoCelular">Tel&eacute;fono Celular: </label>
                                </td>
                                <td>
                                    <form:input id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="14" maxlength="20" tabindex="77" />
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="lblCorreo">Correo: </label>
                                </td>
                                <td>
                                    <form:input id="correo" name="correo" path="correo" size="35" tabindex="78" maxlength="50" />
                                </td>
                            </tr>

                            <tr>
                                <td class="label">
                                    <label for="lblDomicilio">Domicilio: </label>
                                </td>
                                <td colspan="4">
                                    <form:textarea id="domicilio" name="domicilio" path="domicilio" minlength="15" maxlength="200" cols="60" tabindex="79" onBlur="ponerMayusculas(this);" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <fieldset class="ui-widget ui-widget-content ui-corner-all">
                        <legend>Nacionalidad</legend>
                        <table border="0" width="100%">
                            <tr>
                                <td class="label">
                                    <label for="lblNacionalidad">Nacionalidad: </label>
                                </td>
                                <td>
                                    <form:select id="nacion" name="nacion" path="nacion" tabindex="80">
                                        <form:option value="">SELECCIONAR</form:option>
                                        <form:option value="N">NACIONAL</form:option>
                                        <form:option value="E">EXTRANJERO</form:option>
                                    </form:select>
                                </td>
                                <td class="separador"></td>
                                <td class="label" nowrap="nowrap">
                                    <label for="lblPaisResidencia">Pa&iacute;s Residencia: </label>
                                </td>
                                <td>
                                    <form:input id="paisResidencia" name="paisResidencia" path="paisResidencia" size="7" maxlength="5" tabindex="81" readOnly="true" />
                                    <input id="paisR" name="paisR" size="50" type="text" readOnly="true" disabled="true" tabindex="82" />
                                </td>
                            </tr>
                            <tr name="extranjero" style="display: none;">
                                <td class="label">
                                    <label for="lblDocEstanciaLegal">Documento Estancia Legal: </label>
                                </td>
                                <td class="label">
                                    <label for="lblMoneda">FM2 </label>
                                    <form:radiobutton id="docEstanciaLegal" name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3" value="FM2" tabindex="83" checked="checked" />&nbsp;&nbsp;
                                    <label for="lblMoneda">FM3 </label>
                                    <form:radiobutton id="docEstanciaLegal" name="docEstanciaLegal" path="docEstanciaLegal" maxlength="3" value="FM3" tabindex="84" />
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="lblDocExisLegal">Documento Existencia Legal: </label>
                                </td>
                                <td>
                                    <form:input id="docExisLegal" name="docExisLegal" path="docExisLegal" size="40" maxlength="30" tabindex="85" onBlur="ponerMayusculas(this);" />
                                </td>
                            </tr>

                            <tr name="extranjero" style="display: none;">
                                <td class="label">
                                    <label for="lblFechaVenEst">Fecha Vencimiento Estancia: </label>
                                </td>
                                <td>
                                    <form:input id="fechaVenEst" name="fechaVenEst" path="fechaVenEst" size="14" tabindex="86" esCalendario="true" />
                                </td>
                                <td class="separador"></td>
                                <td class="label">
                                    <label for="paisRFC">País que Asigna RFC: </label>
                                </td>
                                <td>
                                    <form:input type="text" id="paisRFC" name="paisRFC" path="paisRFC" size="7" maxlength="11" tabindex="87" />
                                    <input type="text" id="NomPaisRFC" name="NomPaisRFC" size="50" tabindex="88" readOnly="true" disabled="true" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <div id="escritura" style="display: none;">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Escritura</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label">
                                        <label for="lblNumEscPub">No. Escritura Pública: </label>
                                    </td>
                                    <td>
                                        <form:input id="numEscPub" name="numEscPub" path="numEscPub" size="7" tabindex="89" maxlength="50" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblFechaEscPub">Fecha Escritura Pública: </label>
                                    </td>
                                    <td>
                                        <form:input id="fechaEscPub" name="fechaEscPub" path="fechaEscPub" size="14" tabindex="90" esCalendario="true" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label">
                                        <label for="lblEstadoID">Estado:</label>
                                    </td>
                                    <td>
                                        <form:input id="estadoID" name="estadoID" path="estadoID" size="7" tabindex="91" maxlength="11" />
                                        <input id="nombreEstado" name="nombreEstado" size="30" type="text" readOnly="true" disabled="true" tabindex="92" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblMunicipioID">Municipio:</label>
                                    </td>
                                    <td>
                                        <form:input id="municipioID" name="municipioID" path="municipioID" size="7" maxlength="11" tabindex="93" />
                                        <input id="nombreMuni" name="nombreMuni" size="40" type="text" readOnly="true" disabled="true" tabindex="94" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="label">
                                        <label for="lblNotariaID">Notaria:</label>
                                    </td>
                                    <td>
                                        <form:input id="notariaID" name="notariaID" path="notariaID" size="7" tabindex="95" maxlength="11" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblTitularNotaria">Titular Notaria:</label>
                                    </td>
                                    <td>
                                        <form:input id="titularNotaria" name="titularNotaria" path="titularNotaria" size="60" maxlength="100" tabindex="96" readOnly="true" disabled="true" />
                                    </td>
                                </tr>
                                <tr id="escDireccion">
                                    <td class="label">
                                        <label for="lblDireccion">Direcci&oacute;n:</label>
                                    </td>
                                    <td>
                                        <textarea id="direccion" name="direccion" path="direccion" cols="60" type="textarea" readOnly="true" disabled="true" tabindex="97" onBlur="ponerMayusculas(this);">
</textarea>
                                          </td>
                                      </tr>

                                  </table>
                              </fieldset>
                          </div>
                          <div id="miscelaneos" style="display: none;">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Misceláneos</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblRazonSocial">Raz&oacute;n Social: </label>
                                    </td>
                                    <td>
                                        <form:input id="razonSocial" name="razonSocial" path="razonSocial" size="50" maxlength="150" tabindex="98" onBlur="ponerMayusculas(this);" />
                                    </td>
                                    <td class="separador"></td>
                                    <td class="label">
                                        <label for="lblFax">Fax: </label>
                                    </td>
                                    <td>
                                        <form:input id="fax" name="fax" path="fax" size="20" maxlength="30" tabindex="99" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                    <div id="beneficiarios" style="display: none;">
                        <fieldset class="ui-widget ui-widget-content ui-corner-all">
                            <legend>Relaci&oacute;n</legend>
                            <table border="0" width="100%">
                                <tr>
                                    <td class="label" nowrap="nowrap">
                                        <label for="lblParentescoID">Parentesco: </label>
                                    </td>
                                    <td>
                                        <form:input id="parentescoID" name="parentescoID" path="parentescoID" maxlength="11" size="7" tabindex="100" />
                                        <input id="parentesco" name="parentesco" size="50" type="text" readOnly="true" disabled="true" tabindex="101" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">
                                        <label for="lblPorcentaje">Porcentaje: </label>
                                    </td>
                                    <td nowrap="nowrap">
                                        <form:input id="porcentaje" name="porcentaje" path="porcentaje" maxlength="12" size="7" tabindex="102" /> <label for="lblPorcentajeSigno">%</label>
                                    </td>
                                    <td class="separador"></td>
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
                                        <input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="103" />
                                        <input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="104" />
                                        <input type="button" id="elimina" name="elimina" class="button btnelim" value="Eliminar" tabindex="105" />
                                        <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
                                        <input type="hidden" id="numeroCaracteres" name="numeroCaracteres" />
                                        <input type="hidden" id="tipoPersona" name="tipoPersona" path="tipoPersona" />
                                        <input type="hidden" id="porcentajeAccionista" name="porcentajeAccionista" path="porcentajeAccionista" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form:form>
    </div>

    <div id="cargando" style="display: none;">
    </div>
    <div id="cajaLista" style="display: none;">
        <div id="elementoLista" />
    </div>
</body>
<div id="mensaje" style="display: none;" />

</html>
