<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
<script type="text/javascript" src="dwr/interface/reversaPagoNominaServicio.js"></script>
<script type="text/javascript" src="js/gridviewscroll.js"></script>


<script type="text/javascript" src="js/nomina/reversaAplicacionPagosCredNomina.js"></script>

</head>
<body>

<div id="contenedorForma">

  <form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reversaPagosNomina">
    <fieldset class="ui-widget ui-widget-content ui-corner-all">
      <legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Reversa de Pagos de Cr&eacute;ditos de N&oacute;mina</legend>

      <table border="0" cellpadding="0" cellspacing="0" width="50%">
        <tr>
          <td class="label" nowrap="nowrap"><label for="lblInstitucion">Empresa N&oacute;mina:</label>  </td>
          <td nowrap="nowrap" >
            <form:input type="text" id="institNominaID" path="institNominaID" size="11" tabindex="1" iniforma="false"/>
            <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="77" tabindex="2" disabled= "true" readonly="true" iniforma='false'/>
          </td>
        </tr>

        <tr>
          <td class="label"><label for="lblFolios">Folios Aplicados:</label></td>
            <td nowrap="nowrap">
            <input type="text" id="folioCargaID" name="folioCargaID" tabindex="3" path="folioCarga" size="11" />
          </td>
        </tr>

        <tr>
            <td class="label" nowrap="nowrap">
              <label for="mot">Motivo: </label>
            </td>
            <td >
              <form:textarea id="motivo" name="motivo" rows="2" cols="50" path="motivo" size="18" maxlength ="200"
              tabindex="4" type="text"  onblur=" ponerMayusculas(this)"/>
            </td>
          </tr>

          <tr>
            <td class="label" nowrap="nowrap">
              <label for="usuarioA">Usuario Autoriza: </label>
            </td>
            <td >
              <form:input id="usuarioAutorizaID" name="usuarioAutorizaID" size="50" path="usuarioAutorizaID"
                tabindex="5" type="password" />
            </td>
          </tr>

          <tr>
            <td class="label" nowrap="nowrap">
              <label for="pass">Password:</label>
            </td>
            <td>
              <form:input type="password" name="contraseniaUsuarioAutoriza" id="contraseniaUsuarioAutoriza"
              path="contraseniaUsuarioAutoriza" value="" size="50"  tabindex="6" autocomplete="new-password" />
            </td>
          </tr>
      <tr>
          <td class="separador"></td>

        <td align="right"  style="float: right;">
          <input type="submit" id="reversaPagos" name="reversaPagos" class="submit" value="Reversa" tabindex="8" />
          <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
        </td>
      </tr>

      <tr>
        <td colspan="2">
          <div id="divGridCreditosPagados"  border="0" style="display:none" ></div>
        </td>
      </tr>
    </table>
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
