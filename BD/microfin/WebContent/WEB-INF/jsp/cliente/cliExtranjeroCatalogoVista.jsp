<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

  <head>	
    <script type="text/javascript" src="dwr/interface/cliExtranjeroServicio.js"></script> 
    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
    <script type="text/javascript" src="js/cliente/cliExtranjeroCatalogo.js"></script> 
    <script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>    
  </head>
  <body>

    <div id="contenedorForma">
      <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="CliExtranjero">
      <fieldset class="ui-widget ui-widget-content ui-corner-all">		
        <legend class="ui-widget ui-widget-header ui-corner-all">Adicional <s:message code="safilocale.cliente"/> Extranjero</legend>			
        <table border="0" width="100%">
          <tr>
            <td class="label"> 
              <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
            </td>
            <td>
              <form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" iniforma='false' maxlength="11"/>  
              <input type="text" id="nombreCliente" name="nombreCliente" size="45" tabindex="2" disabled= "true" 
              readOnly="true"/>  
            </td> 
            <td class="separador"></td> 
            <td class="label" nowrap="nowrap"> 
              <label for="inmigrado">Calidad de Inmigrado: </label> 
            </td> 
            <td> 
              <form:select id="inmigrado" name="inmigrado" path="inmigrado" tabindex="3" >
              <form:option value="">SELECCIONAR</form:option>
              <form:option value="S">Si</form:option>
              <form:option value="N">No</form:option>
            </form:select>
          </td>	
        </tr> 
        <!--  	<tr> -->
        <!-- 		<td><input type ="button" id="buscarMiSuc" name="buscarMiSuc" value="Buscar Mi Sucursal" class="submit"/></td> -->
        <!-- 		<td><input type ="button" id="buscarGeneral" name="buscarGeneral" value="Busqueda General" class="submit"/></td> -->
        <!--  	</tr> -->

        <tr> 
          <td class="label"> 
            <label for="documentoLegal">Documento Legal: </label> 
          </td> 
          <td> 
            <form:select id="documentoLegal" name="documentoLegal" path="documentoLegal" tabindex="4" disabled="true">
            <form:option value="FM2">FM2</form:option>
            <form:option value="FM3">FM3</form:option>
          </form:select>
        </td> 
        <td class="separador"></td> 
        <td class="label"> 
          <label for="motivoEstancia">Motivo de Estancia: </label> 
        </td> 
        <td> 
          <form:input id="motivoEstancia" name="motivoEstancia" path="motivoEstancia" size="35" tabindex="5"  onBlur=" ponerMayusculas(this)" maxlength="30"/> 
        </td> 
      </tr> 
      <tr> 
        <td class="label" nowrap="nowrap" > 
          <label for="fechaVencimiento">Fecha Vencimiento: </label> 
        </td> 
        <td> 
          <form:input id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="15" tabindex="6" esCalendario="true"/> 
        </td> 
        <td class="separador"></td> 
        <td class="label">
          <label for="pais"> País de Residencia: </label>
        </td>
        <td>
          <form:input type="text" id="paisID" name="paisID" path="paisID" size="5" tabindex="7" disabled="true" readOnly="true"/>
          <input type="text" id="Nombpais" name="Nombpais" size="35" tabindex="8" disabled="true" readOnly="true"/>
        </td>
      </tr> 

      <tr> 
        <td class="label"> 
          <label for="entidad">Entidad: </label> 
        </td> 
        <td> 
          <form:input id="entidad" name="entidad" path="entidad" size="30" tabindex="9" onBlur=" ponerMayusculas(this)" maxlength="50"/> 
        </td> 	
        <td class="separador"></td> 
        <td class="label"> 
          <label for="localidad">Localidad: </label> 
        </td> 
        <td> 
          <form:input id="localidad" name="localidad" path="localidad" size="30" tabindex="10" onBlur=" ponerMayusculas(this)" maxlength="50"/> 
        </td>  
      </tr> 
      <tr>
        <td class="label">
          <label for="colonia"> Colonia: </label>
        </td>
        <td>
          <form:input id="colonia" name="colonia" path="colonia" size="30" tabindex="11" onBlur=" ponerMayusculas(this)" maxlength="50"/>
        </td>
        <td class="separador"></td> 
        <td class="calle"> 
          <label for="numero">Calle: </label> 
        </td>  
        <td>
          <form:input id="calle" name="calle" path="calle" size="45" tabindex="12" onBlur=" ponerMayusculas(this)" maxlength="50"/>
        </td> 
      </tr> 
      <tr>
        <td class="label"> 
          <label for="numero">Número: </label> 
        </td> 
        <td> 
          <form:input id="numeroCasa" name="numeroCasa" path="numeroCasa" size="5" tabindex="13" onBlur=" ponerMayusculas(this)" maxlength="10"/>
          <label for="exterior">Interior: </label>
          <form:input id="numeroIntCasa" name="numeroIntCasa" path="numeroIntCasa" size="5" tabindex="14" onBlur=" ponerMayusculas(this)" maxlength="10"/>
        </td> 
        <td class="separador"></td> 
        <td class="label"> 	
          <label for="CP">Código Postal: </label> 
        </td> 
        <td> 
          <form:input id="adi_CoPoEx" name="adi_CoPoEx" path="adi_CoPoEx" size="15" tabindex="15" onBlur=" ponerMayusculas(this)" maxlength="6"/> 
        </td> 
      </tr>

      <tr> 
        <td class="label"> 
          <label for="RFC">RFC: </label> 
        </td> 
        <td> 
          <input id="RFC" name="RFC" size="25" tabindex="16" readOnly="true"/> 
        </td> 
        <td class="separador"></td> 
        <td class="label" nowrap="nowrap">
          <label for="paisRFC"> País que Asigna RFC: </label>
        </td>
        <td>
          <form:input type="text" id="paisRFC" name="paisRFC" path="paisRFC" size="5" maxlength="11" tabindex="17"/>
          <input type="text" id="NomPaisRFC" name="NomPaisRFC" size="35" readOnly="true"/>
        </td>
      </tr> 

    </table>
  
  <table align="right">
    <tr>
      <td align="right">
        <input type="submit" id="agrega" name="agrega" class="submit" 
        value="Grabar" tabindex="16" />
        <input type="submit" id="modifica" name="modifica" class="submit" 
        value="Modificar" tabindex="17" />
        <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
  <div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
    <div id="elementoListaCte"></div>
  </div>

  </body>
<div id="mensaje" style="display: none;"/>
</html>