<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoContratoBCServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasifrepregServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clasificCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/circuloCreTipConServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="js/fira/productoCredito.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="productosCreditoBean" >
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Productos de Cr&eacute;dito Agro</legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Cobros</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
		    	<label for="producCreditoID">Producto de Cr&eacute;dito: </label>
			</td>
			<td>
				<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="1"/>
		   </td>
		   <td class="separador"></td>
		   <td class="label">
         		<label for="descripcion">Descripci&oacute;n: </label>
     		</td>
     		<td>
				<form:input id="descripcion" name="descripcion" path="descripcion" size="45" rows="3" tabindex="2" onblur="ponerMayusculas(this)" />
			</td>
		</tr>
		<tr>
			<td class="label" nowrap="nowrap">
         		<label for="refinanciamiento">Refinancia Inter&eacute;s: </label>
     		</td>
     		<td>
     			<form:select id="refinanciamiento" name="refinanciamiento" path="" tabindex="5">
					<form:option value="S">S&iacute; Refinancia</form:option>
			     	<form:option value="N">No Refinancia</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
			<td class="label">
         		<label for="cobraIVAInteres">Cobra IVA Inter&eacute;s: </label>
     		</td>
     		<td>
     			<form:select id="cobraIVAInteres" name="cobraIVAInteres" path="cobraIVAInteres" tabindex="5">
					<form:option value="S">S&iacute; Cobra IVA</form:option>
			     	<form:option value="N">No Cobra IVA</form:option>
				</form:select>
     		</td>
		</tr>
		<tr>
     		<td class="label" nowrap="nowrap">
         		<label for="cobraFaltaPago">Cobra Falta Pago: </label>
     		</td>
     		<td>
     			<form:select id="cobraFaltaPago" name="cobraFaltaPago" path="cobraFaltaPago" tabindex="6">
					<form:option value="S">S&iacute; Cobra </form:option>
			     	<form:option value="N">No Cobra </form:option>
				 </form:select>
     		</td>
     		<td class="separador"></td>
			<td class="label">
         		<label for="cobraMora">Cobra Mora:</label>
			</td>
     		<td>
         		<form:select id="cobraMora" name="cobraMora" path="cobraMora" tabindex="7">
					<form:option value="S">S&iacute; Cobra </form:option>
			     	<form:option value="N">No Cobra </form:option>
				</form:select>
     		</td>
		</tr>
		<tr>
     		<td class="label">
        		<label for="cobraIVAMora">Cobra IVA Mora: </label>
	   		</td>
	   		<td>
	      		<form:select id="cobraIVAMora" name="cobraIVAMora" path="cobraIVAMora" tabindex="8">
					<form:option value="S">S&iacute; Cobra IVA</form:option>
		     		<form:option value="N">No Cobra IVA</form:option>
				</form:select>
	   		</td>
    		<td class="separador"></td>
    		<td class="label">
        		<label for="tipCobComMorato">Tipo Cob. Mora: </label>
    		</td>
    		<td>
        	 	<form:select id="tipCobComMorato" name="tipCobComMorato" path="tipCobComMorato" tabindex="9">
					<form:option value="N">N veces Tasa Ordinaria</form:option>
		     		<form:option value="T">Tasa Fija Anualizada</form:option>
				</form:select>
				<label for="factorMora">Moratorio: </label>
			 	<form:input id="factorMora" name="factorMora" path="factorMora" size="8"  esTasa="true" tabindex="10" style="text-align: right;" />
    		</td>
		</tr>
		<tr>
 		    <td class="label">
        		<label for="clasificacion">Clasificaci&oacute;n: </label>
    		</td>
    		<td>
     			<form:input id="clasificacion" name="clasificacion" path="clasificacion" size="5" tabindex="14"/>
     		 	<textarea id="descripClasifica" name="descripClasifica" size="40" type="text" readOnly="true" disabled="true"> </textarea>
    		</td>
			<td class="separador"></td>
 			<td class="label">
        		<label for="tipo">Tipo: </label>
    		</td>
		    <td>
    		 	<form:select id="tipo" name="tipo" path="tipo" tabindex="15" disabled="true" >
					<form:option value="C">Comercial</form:option>
			     	<form:option value="O">Consumo</form:option>
			     	<form:option value="H">Vivienda</form:option>
				</form:select>
    		</td>
		</tr>
	<tr>
		<td class="label">
        		<label  for="ahoVoluntario">Ahorro Voluntario: </label>
        	 </td>
    		<td>
    		  <form:select id="ahoVoluntario" name="ahoVoluntario" path="ahoVoluntario" tabindex="19">
		      <form:option value="S">Si</form:option>
		      <form:option value="N">No</form:option>
	      </form:select>
         	<label id="mto" for="porAhoVol">Monto: </label>
         	<form:input id="porAhoVol" name="porAhoVol" path="porAhoVol" size="12" esmoneda="true" tabindex="20" style="text-align: right;"/>
          	</td>
  		<td class="separador"></td>
  		<td class="separador"></td>
  		<td class="separador"></td>
	</tr>

	<tr>
		<td class="label">
        		<label for="tipoComXapert">Tipo Com. x Apertura: </label>
    		</td>
    		<td>
    			<form:select id="tipoComXapert" name="tipoComXapert" path="tipoComXapert" tabindex="21">
			      <form:option value="M">Monto</form:option>
			      <form:option value="P">Porcentaje</form:option>
		      </form:select>
	   </td>
    		<td class="separador"></td>
    		<td class="label">
        		<label for="montoComXapert">Valor: </label>
    		</td>
    		<td>
    			<form:input id="montoComXapert" name="montoComXapert" path="montoComXapert" size="12" esMoneda="true" tabindex="22" style="text-align: right;"/>
	   </td>
	</tr>


	<tr>
		<td class="label">
        		<label for="formaComApertura">Tipo Forma de Cobro: </label>
    		</td>
    		<td>
    			<form:select id="formaComApertura" name="formaComApertura" path="formaComApertura" tabindex="23">
	      	<form:option value="F">Financiamiento</form:option>
	      	<form:option value="D">Deduccion</form:option>
	      	<form:option value="A">Anticipado</form:option>
	      </form:select>
	   </td>
	   <td class="separador"></td>
	   <td class="label">
        		<label for="calcInteres">C&aacute;lculo de Inter&eacute;s </label>
    		</td>
    		 <td>
    		<form:select id="calcInteres" name="calcInteres" path="calcInteres"  tabindex="24" >
				<form:option value="">SELECCIONAR</form:option>
			</form:select>
			</td>
		</tr>
		<tr name="tasaBase">
			<td class="label">
				<label for="tasaBase">Tasa Base: </label>
			</td>
		   	<td>
				<input type="text" id="tasaBase" name="tasaBase" path="" size="8"
					readonly="true" disabled="true" tabindex="60"  />
			 	<input type="text" id="desTasaBase" name="desTasaBase" size="25"
				    readonly="true" disabled="true" tabindex="61"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="valorTasaBase">Valor: </label>
			</td>
			<td>
				<input type="text" id="valorTasaBase" name="valorTasaBase" path="" size="8"
			 		tabindex="62" esTasa="true" disabled="true" style="text-align: right;"/>
			 	<label for="porcentaje">%</label>
			</td>
		</tr>
		<td class="label">
        		<label for="tipoCalInteres">Tipo Calc. Inter&eacute;s: </label>
    		</td>

    		<td>
    			<form:select id="tipoCalInteres" name="tipoCalInteres" path="tipoCalInteres" tabindex="25">
     			<form:option value="">SELECCIONAR</form:option>
		      	<form:option value="1">SALDOS INSOLUTOS</form:option>
		      	<form:option value="2">MONTO ORIGINAL</form:option>
	      </form:select>
	   </td>
	   <td class="separador"></td>
	   <td class="label" nowrap="nowrap">
        		<label for="proyInteresPagAde">Proy. Inter&eacute;s Pago Adel. : </label>
    		</td>
    		<td>
    			<form:select id="proyInteresPagAde" name="proyInteresPagAde" path="proyInteresPagAde" tabindex="26">
     			<form:option value="S">S&iacute;</form:option>
		      	<form:option value="N">No</form:option>
	      </form:select>
	   </td>
			</tr>
			<tr>
					<td class="label">
		         		<label for="institutFondID">Inst. Fondeo: </label>
		     		</td>
		     		<td nowrap="nowrap">
		     			<form:input id="institutFondID" name="institutFondID" path="institutFondID" size="12" tabindex="27" />
		     			<input type="text" id="descripFondeo" name="descripFondeo" size="45" tabindex="28" disabled="true"/>
				   </td>
				   <td class="separador"></td>

				   <td class="label">
		         		<label for="permitePrepago">Permite Prepago : </label>
		     		</td>
		     		<td>
		     			<form:select id="permitePrepago" name="permitePrepago" path="permitePrepago" tabindex="29">
			     			<form:option value="">SELECCIONAR</form:option>
			     			<form:option value="S">S&iacute;</form:option>
					      	<form:option value="N">No</form:option>
				      </form:select>
				   </td>

			 </tr>
			 <tr id="prepago" >
			 	<td class="label">
		         	<label for="modificarPrepago">Modificar Prepago Base: </label>
		     	</td>
		     	<td>
					<form:radiobutton id="modificarPrepago" name="modificarPrepago" path="modificarPrepago" value="S" tabindex="30" />
					<label for="modificarPrepago">Si</label>
					<form:radiobutton id="modificarPrepago2" name="modificarPrepago2" path="modificarPrepago" value="N" tabindex="31" />
					<label for="modificarPrepago2">No</label>
				</td>
				  <td class="separador"></td>
				<td>
		     			<label for="tipoPrepago">Tipo Prepago Capital: </label>
				</td>
				<td>
		     			<form:select id="tipoPrepago" name="tipoPrepago" path="tipoPrepago" tabindex="32">
					      	<form:option value="I">Cuotas Siguientes Inmediatas</form:option>
				      </form:select>
				   </td>
			 </tr>
	</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Condiciones</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label">
         		<label for="tipoPersona">Tipo Persona: </label>
			</td>
		   	<td>
		    	<form:select id="tipoPersona" name="tipoPersona" path="tipoPersona" tabindex="35">
					<form:option value="F">F&iacute;sica</form:option>
			     	<form:option value="M">Moral</form:option>
			     	<form:option value="A">Ambas</form:option>
				</form:select>
		   	</td>
		   	<td class="separador"></td>
			<td class="label">
         		<label for="esGrupal">Es Grupal: </label>
     		</td>
     		<td>
     			<form:select id="esGrupal" name="esGrupal" path="esGrupal" tabindex="36">
					<form:option value="N">No es Grupal</form:option>
					<form:option value="S">S&iacute; es Grupal</form:option>
			    </form:select>
     		</td>
		</tr>
 		<tr>
			<td class="label">
         		<label for="requiereGarantia">Requiere Garant&iacute;a: </label>
		  	</td>
		  	<td>
		   		<form:select id="requiereGarantia" name="requiereGarantia" path="requiereGarantia" tabindex="37">
					<form:option value="S">S&iacute; Requiere</form:option>
					<form:option value="I">Indistinto</form:option>
			     	<form:option value="N">No Requiere</form:option>
				</form:select>
			</td>
		   	<td class="separador"></td>
		     <td class="label">
         		<label for="perGarCruzadas">Permite Garant&iacute;as Cruzadas: </label>
		  	 </td>
		  	 <td>
		  	 	<form:select id="perGarCruzadas" name="perGarCruzadas" path="perGarCruzadas" tabindex="38" disabled="false" >
		  	 		<form:option value="">SELECCIONAR</form:option>
					<form:option value="S">S&iacute; Permite</form:option>
			     	<form:option value="N">No Permite</form:option>
				</form:select>
		   	</td>
     	</tr>
		<tr>
		   	<td class="label">
         		<label for="relGarantCred">Relaci&oacute;n Garant&iacute;a Cr&eacute;dito: </label>
		  	 </td>
		  	 <td>
		  	 	<form:input id="relGarantCred" name="relGarantCred" path="relGarantCred" size="12" tabindex="39" disabled="false" style="text-align: right;"/>
	     	    <label for="Porc"> %</label>
		   	</td>
		   	<td class="separador"></td>
			<td class="label">
         		<label for="requiereAvales">Requiere Avales: </label>
     		</td>
     		<td>
     			<form:select id="requiereAvales" name="requiereAvales" path="requiereAvales" tabindex="40">
					<form:option value="S">S&iacute; Requiere</form:option>
					<form:option value="I">Indistinto</form:option>
			     	<form:option value="N">No Requiere</form:option>
				</form:select>
     		</td>
     		</tr>
     		<tr>
		  <td class="label">
         		<label for="perAvaCruzados">Permite Avales Cruzados: </label>
		  	 </td>
		  	 <td>
		  	 	<form:select id="perAvaCruzados" name="perAvaCruzados" path="perAvaCruzados" tabindex="41" disabled="false" >
		  	 		<form:option value="">SELECCIONAR</form:option>
					<form:option value="S">S&iacute; Permite</form:option>
			     	<form:option value="N">No Permite</form:option>
				</form:select>
		   	</td>
     	<td class="separador"></td>
		   <td class="label">
         	<label for="esReestructura">Es Reestructura/Renovaci&oacute;n: </label>
     		</td>
     		<td>
				<form:select id="esReestructura" name="esReestructura" path="esReestructura" tabindex="42">
					<form:option value="">SELECCIONAR</form:option>
					<form:option value="S">SI PERMITE</form:option>
			     	<form:option value="N">NO PERMITE</form:option>
				</form:select>
     		</td>
     		</tr>

     		<tr>
				<td class="label">
					<label for="cantidadAvales">Hasta Cuantos Creditos Avalados: </label>
				</td>

				<td>
					<form:input id="cantidadAvales" name="cantidadAvales" path="cantidadAvales" tabindex="43" type="text" value="0" size="12" disabled="true" onkeyPress="return validador(event);" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="intercambioAvalesRatioSi">Intercambio de Avales: </label>
				</td>
				<td>
					<form:radiobutton id="intercambioAvalesRatioSi" name="intercambioAvalesRatio" path="intercambioAvalesRatio" tabindex="44" type="radio" value="S" />
					<label for="intercambioAvalesRatioSi">Si</label>
					<form:radiobutton id="intercambioAvalesRatioNo" name="intercambioAvalesRatio" path="intercambioAvalesRatio" tabindex="45" type="radio" value="N" />
					<label for="intercambioAvalesRatioNo">No</label>
				</td>
			</tr>

     		<tr>
		   <td class="label">
         	<label for="montoMinimo">Monto M&iacute;nimo: </label>
     		</td>
     		<td>
         	 <form:input id="montoMinimo" name="montoMinimo" path="montoMinimo" size="12" tabindex="46"  esMoneda="true" style="text-align: right;"/>
     		</td>
		<td class="separador"></td>
		<td class="label">
         	<label for="montoMaximo">Monto M&aacute;ximo:</label>
			</td>
     		<td>
         	 <form:input id="montoMaximo" name="montoMaximo" path="montoMaximo" size="12" tabindex="47"  esMoneda="true" style="text-align: right;"/>
     		</td>
		</tr>
		<tr>
		   <td class="label">
         		<label for="margenPagIgual">Margen de Pagos Iguales: </label>
     		</td>
     		<td>
         	 	<form:input id="margenPagIgual" name="margenPagIgual" path="margenPagIgual" size="12" esMoneda="true" style="text-align: right;" tabindex="48"/>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
         		<label for="autorizaComite">Permite Funcionarios y/o Relacionados: </label>
     		</td>
     		<td>
         	 	<form:select id="autorizaComite" name="autorizaComite" path="autorizaComite" tabindex="49">
         	 		<form:option value="N">NO</form:option>
					<form:option value="S">SI</form:option>
				</form:select>
     		</td>
     	</tr>
     	<tr>
     		<td class="label" style="display: none;">
         		<label for="calculoRatios1">C&aacute;lculo Ratios: </label>
     		</td>
     		<td style="display: none;">
     			<form:radiobutton id="calculoRatios1" name="calculoRatios1" path="calculoRatios" value="S" tabindex="50" />
					<label for="calculoRatios1">Si</label>
				<form:radiobutton id="calculoRatios2" name="calculoRatios2" path="calculoRatios" value="N" tabindex="51" checked="checked"/>
					<label for="calculoRatios2">No</label>
     		</td>
     		<td class="separador" style="display: none;"></td>
     		<td><label for="siPermiteAutSolPros">Permite Autorizaci&oacute;n Solicitud por Prospecto:</label> </td>
     		<td>
     			<form:radiobutton id="siPermiteAutSolPros" name="permiteAutSolPros" path="permiteAutSolPros" value="S" tabindex="52" />
				<label for="siPermiteAutSolPros">Si</label>
				<form:radiobutton id="noPermiteAutSolPros" name="permiteAutSolPros" path="permiteAutSolPros" value="N" tabindex="53" checked="true"/>
				<label for="noPermiteAutSolPros">No</label>
     		</td>
     	</tr>
     	<tr>
     		<td class="label">
         		<label for="inicioAfuturoSi">Inicio del Cr&eacute;dito Posterior al Desembolso: </label>
     		</td>
     		<td>
     			<form:radiobutton id="inicioAfuturoSi" name="inicioAfuturo" path="inicioAfuturo" value="S" tabindex="54" />
					<label for="inicioAfuturoSi">Si</label>
				<form:radiobutton id="inicioAfuturoNo" name="inicioAfuturo" path="inicioAfuturo" value="N" tabindex="55" />
					<label for="inicioAfuturoNo">No</label>
     		</td>
     		<td class="separador" id="separador"></td>
     		<td class="label">
         		<label for="diasMaximo" id="labelDiasMaximo"> </label>
     		</td>
     		<td id="tdDiasMaximo" style="display:none;">
     			<form:input id="diasMaximo" name="diasMaximo" path="diasMaximo" size="12" tabindex="56"/>
     		</td>
     	</tr>
		<tr id="mostrarReqReferencias1">
     		<td><label for="requiereReferencias">Requiere Referencias:</label></td>
     		<td>
     			<form:select id="requiereReferencias" name="requiereReferencias" path="requiereReferencias" tabindex="57">
			     	<form:option value="N">No Requiere</form:option>
			     	<form:option value="S">S&iacute; Requiere</form:option>
					<form:option value="I">Indistinto</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label" id="mostrarMinReferencias1">
         		<label for="minReferencias">M&iacute;nimo de Referencias: </label>
     		</td>
     		<td id="mostrarMinReferencias2">
         		 <form:input type="text" id="minReferencias" name="minReferencias" path="minReferencias" size="12" tabindex="58" onkeypress="return validaSoloNumero(event,this);" maxlength="3"/>
     		</td>
		</tr>
		<tr>
			<td><label for="requiereCheckList">Requiere CheckList:</label></td>
     		<td>
     			<form:select id="requiereCheckList" name="requiereCheckList" path="requiereCheckList" tabindex="59">
			     	<form:option value="N">No Requiere</form:option>
			     	<form:option value="S">S&iacute; Requiere</form:option>
					<form:option value="I">Indistinto</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
         		<label for="financiamientoRural">Financiamiento Rural: </label>
     		</td>
     		<td>
     			<form:radiobutton id="financiamientoRural1" name="financiamientoRural1" path="financiamientoRural" value="S" tabindex="55" />
					<label for="si">Si</label>
				<form:radiobutton id="financiamientoRural2" name="financiamientoRural2" path="financiamientoRural" value="N" tabindex="56" />
					<label for="no">No</label>
     		</td>
		</tr>
		<tr>
			<td class="label">
         		<label for="ReqConsolidacionAgro">Permite Consolidaci&oacute;n: </label>
     		</td>
     		<td>
         	 	<form:select id="reqConsolidacionAgro" name="reqConsolidacionAgro" path="reqConsolidacionAgro" tabindex="57">
         	 		<form:option value="">SELECCIONAR</form:option>
         	 		<form:option value="S">SI</form:option>
         	 		<form:option value="N">NO</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label" id="lblFechaDesembolso">
         		<label for="fechaDesembolso" id="lblFechaDesembolso">Fecha Desembolso: </label>
     		</td>
     		<td>
         	 	<form:select id="fechaDesembolso" name="fechaDesembolso" path="fechaDesembolso" tabindex="58">
        	 		<form:option value="">SELECCIONAR</form:option>
        	 		<form:option value="S">SI</form:option>
         	 		<form:option value="N">NO</form:option>
				</form:select>
     		</td>
		</tr>
	</table>
	</fieldset>

	<div style="display:none">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>L&iacute;nea Cr&eacute;dito</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
         		<label for="manejaLinea">Maneja L&iacute;nea: </label>
     		</td>
     		<td>
         		<form:select id="manejaLinea" name="manejaLinea" path="manejaLinea" tabindex="70">
					<form:option value="S">S&iacute; Maneja</form:option>
			     	<form:option value="N" selected="selected">No Maneja</form:option>
				</form:select>
     		</td>
     		<td class="separador"></td>
     		<td class="label">
				<label for="esRevolvente">Es Revolvente:</label>
			</td>
     		<td>
     			<form:select id="esRevolvente" name="esRevolvente" path="esRevolvente" tabindex="71">
					<form:option value="S">S&iacute; es Revolvente</form:option>
			     	<form:option value="N" selected="selected">No es Revolvente</form:option>
				</form:select>
     		</td>
		</tr>
		<tr>
		<td class="label">
         		<label for="afectacionContable">Afectaci&oacute;n Contable: </label>
     		</td>
     		<td>
         		<form:select id="afectacionContable" name="afectacionContable" path="afectacionContable" tabindex="72">
					<form:option value="S">S&iacute;</form:option>
			     	<form:option value="N">No</form:option>
				</form:select>
     		</td>
		</tr>
	</table>
	</fieldset>
	</div>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all" type = "hidden" id = "grupales" >
	<legend>Grupales:</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="tg">Tipo de Grupo:</label>
			</td>
	     	<td class="label" colspan="2">
	        	<label for="eMujeres">Exclusivo S&oacute;lo Mujeres:</label>
				<input type="radio" id="eMujeres"	tabindex="90">
			</td>
		</tr>
		<tr >
			<td class="separador"></td>
		 	<td class="label" colspan="2">
	        	<label for="eHombres">Exclusivo S&oacute;lo Hombres:</label>
	         	<input type="radio" id="eHombres"	tabindex="91">
			</td>
		</tr>
		<tr >
		 	<td class="separador"></td>
			<td class="label" colspan="2">
	        	<label for="gMixto">Mixto:</label>
	         	<input type="radio" id="gMixto"	tabindex="92">
			</td>
		</tr>
		<tr id="gIntegrantes">
			<td class="label" nowrap="nowrap">
	        	<label for="maximoIntegrantes">No. M&aacute;ximo Integrantes:</label>
			</td>
	     	<td>
	          <form:input id="maximoIntegrantes" name="maximoIntegrantes"  path="maxIntegrantes"
	             size="12" maxlength="10"  tabindex="93"  onkeyPress="return validador(event);" />
			</td>
     		<td class="separador"></td>
			<td class="label" >
         		<label for="minimoIntegrantes">No. M&iacute;nimo Integrantes:</label>
     		</td>
     		<td>
         	 	<form:input id="minimoIntegrantes" name="minimoIntegrantes" path="minIntegrantes"
         	 	 size="12" maxlength="10"  tabindex="94"  onkeyPress="return validador(event);" />
     		</td>
		</tr>
		<tr id="gMujeres">
     		<td class="label" nowrap="nowrap">
         		<label for="maxMujeres">No. M&aacute;ximo Mujeres:</label>
     		</td>
     		<td>
         		<form:input id="maxMujeres" name="maxMujeres" path="maxMujeres" size="12" maxlength="10" tabindex="95"
         		 onkeyPress="return validador(event);" />
     		</td>
     		<td class="separador" ></td>
     		<td class="label" >
	         	<label for="minMujeres">No. M&iacute;nimo Mujeres:</label>
			</td>
     		<td>
         		<form:input id="minMujeres" name="minMujeres" path="minMujeres" size="12" 	maxlength="10" tabindex="96"
         		 onkeyPress="return validador(event);" />
     		</td>
		</tr>
		<tr id="gMujeresS">
     		<td class="label" nowrap="nowrap">
         		<label for="maxMujeresSol">No. M&aacute;ximo Mujeres Solteras:</label>
     		</td>
     		<td>
         		<form:input id="maxMujeresSol" name="maxMujeresSol" path="maxMujeresSol" size="12" 	maxlength="10" tabindex="97"
         		 onkeyPress="return validador(event);"/>
     		</td>
     		<td class="separador"></td>
     		<td class="label" >
         		<label for="minMujeresSol">No. M&iacute;nimo Mujeres Solteras:</label>
			</td>
     		<td>
         	 	<form:input id="minMujeresSol" name="minMujeresSol" path="minMujeresSol" size="12" maxlength="10" tabindex="98" onkeyPress="return validador(event);" />
     		</td>
			</tr>
			<tr id="gHombres">
	     		<td class="label" nowrap="nowrap">
	         		<label for="maxHombres">No. M&aacute;ximo Hombres:</label>
	     		</td>
	     		<td>
	         		<form:input id="maxHombres" name="maxHombres" path="maxHombres" size="12" 	maxlength="10" tabindex="99" onkeyPress="return validador(event);" />
	     		</td>
	     		<td class="separador"></td>
	     		<td class="label" >
	         		<label for="minHombres">No. M&iacute;nimo Hombres:</label>
				</td>
	     		<td>
	         		<form:input id="minHombres" name="minHombres" path="minHombres" size="12" 	readOnly="true"	maxlength="10" tabindex="100" onkeyPress="return validador(event);" />
	     		</td>
			 </tr>
			<tr>
	     		<td class="label" >
	         		<label for="tasaPonderaGru">Tasa Ponderada Grupal:</label>
				</td>
	     		<td>
	         		<form:select id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" tabindex="101">
						<form:option value="N">No</form:option>
						<form:option value="S">S&iacute;</form:option>
				   </form:select>
	     		</td>
	     		<td class="separador"></td>
				<td class="label">
	         		<label for="perRompimGrup">Permite Rompimiento Grupo:</label>
				</td>
	     		<td>
	     			<form:select id="perRompimGrup" name="perRompimGrup" path="perRompimGrup" disabled="false"	tabindex="102">
	     				<form:option value="N">No</form:option>
	     				<form:option value="S">S&iacute;</form:option>
				    </form:select>
	     		</td>
	     	</tr>
			<tr>
		   		<td class="label">
	        		<label for="raIniCicloGrup">Rango Inicial Ciclo Grupal:</label>
	    		</td>
    			<td>
        			<form:input id="raIniCicloGrup" name="raIniCicloGrup" path="raIniCicloGrup" size="12" disabled="false" tabindex="103"/>
    			</td>
				<td class="separador"></td>
				<td class="label">
	        		<label for="raFinCicloGrup">Rango Final Ciclo Grupal:</label>
				</td>
    			<td>
        			<form:input id="raFinCicloGrup" name="raFinCicloGrup" path="raFinCicloGrup" size="12" disabled="false" tabindex="104"/>
    			</td>
    			</tr>
    			<tr>
    			<td class="label">
		         	<label for="prorrateoPago">Prorrateo Pago:</label>
		     		</td>
		     		<td>

		         		<form:select id="prorrateoPago" name="prorrateoPago" path="prorrateoPago" tabindex="105">
							<form:option value="S">Si</form:option>
							<form:option value="N">No</form:option>
						</form:select>
					</td>
    		</tr>
		</table>
		</fieldset>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Capital Contable</legend>
	<table >
		<tr>
     		<td class="label">
         		<label for="validaCapConta">Valida Cap. Contable:</label>
     		</td>
     		<td>
         		<form:select id="validaCapConta" name="validaCapConta" path="validaCapConta" tabindex="120">
					<form:option value="S">Si</form:option>
					<form:option value="N">No</form:option>
				</form:select>
			</td>
			<td class="separador"></td>
     	    <td class="label" nowrap="nowrap">
         		<label for="porcMaxCapConta">Porcentaje M&aacute;x. de un Cr&eacute;dito: </label>
     		</td>
     		<td>
	     	    <form:input id="porcMaxCapConta" name="porcMaxCapConta" path="porcMaxCapConta" maxlength="11" size="12" esTasa= "true"    tabindex="121" style="text-align: right;"/>
	     	    <label for="Porc"> %</label>
     		</td>
 		</tr>

 		</table>
	</fieldset>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>D&iacute;as</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
	     		<td class="label">
	         		<label for="graciaFaltaPago">Gracia Falta Pago:</label>
				</td>
	     		<td>
	         	 	<form:input id="graciaFaltaPago" name="graciaFaltaPago" path="graciaFaltaPago" size="12"  tabindex="130"/>
	     		</td>
	     		<td class="separador"></td>
	     		<td class="label">
	         		<label for="graciaMoratorios">Gracia Moratorios: </label>
	     		</td>
	     		<td>
	         	 	<form:input id="graciaMoratorios" name="graciaMoratorios" path="graciaMoratorios" size="12" tabindex="131"/>
	     		</td>
	 		</tr>
	 		<tr>
	     		<td class="label">
	         	<label for="diasSuspesion">D&iacute;as Suspensi&oacute;n: </label>
	     		</td>
	     		<td>
	         	 <form:input id="diasSuspesion" name="diasSuspesion" path="diasSuspesion" size="12" tabindex="132"/>
	     		</td>
		 		<td class="separador"></td>
		 		<td class="label">
	 		 		<label for="diasPasoAtraso">D&iacute;as Paso Atraso: </label>
			   	</td>
			   <td>
			      <form:input id="diasPasoAtraso" name="diasPasoAtraso" path="diasPasoAtraso" size="12"	tabindex="133"/>
			   </td>
	 		</tr>
		 </table>
	</fieldset>

<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>RECA-CONDUSEF</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
		     		<td class="label">
		         	<label for="registroRECA">No. Registro RECA:</label>
					</td>
		     		<td>
		         	 <form:input id="registroRECA" name="registroRECA" path="registroRECA" size="45" tabindex="140"/>
		     		</td>
		     		<td class="separador"></td>
		     		<td class="label">
		         	<label for="fechaInscripcion">Fecha Inscripci&oacute;n:</label>
		     		</td>
		     		<td>
		         	 <form:input id="fechaInscripcion" name="fechaInscripcion" path="fechaInscripcion" size="20" esCalendario="true" tabindex="141"/>
		     		</td>
		 	</tr>
		 	<tr>
		     		<td class="label">
		         		<label for="nombreComercial">Nombre Comercial:</label>
		     		</td>
		     		<td>
		         	 	<form:input id="nombreComercial" name="nombreComercial" path="nombreComercial" size="45" tabindex="142"/>
		     		</td>
			 		<td class="separador"></td>
			 		<td class="label">
		         		<label for="tipoCredito">Tipo Cr&eacute;dito:</label>
				   </td>
				   <td>
				      <form:input id="tipoCredito" name="tipoCredito" path="tipoCredito" size="20" 	tabindex="143"/>
				   </td>
		 	</tr>
						<form:input type="hidden" id="modalidadPago" name="modalidadPago" path="modalidad" />
						<form:input type="hidden" id="reqSeguro" name="reqSeguro" path="reqSeguroVida" />
						<form:input type="hidden" id="factorRiesgoSeg" name="factorRiesgoSeg" path="factorRiesgoSeguro" />
						<form:input type="hidden" id="tipoPagoSeg" name="tipoPagoSeg" path="tipoPagoSeguro" />
						<form:input type="hidden" id="descSeguro" name="descSeguro" path="descuentoSeguro" />
						<input type="hidden" id="montoPol" name="montoPol" path="montoPolSegVida" esmoneda="true" />


    	</table>
	</fieldset>

<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>C&iacute;rculo y Bur&oacute; de Cr&eacute;dito</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label">
	         		<label for="tipoContratoBC">Contrato BC: </label>
	     		</td>
	     		<td>

		     		 <form:input id="tipoContratoBC" name="tipoContratoBC" path="tipoContratoBCID" size="3" tabindex="180"/>
		     		<input type="text" id="descContrato" name="descContrato" size="50" tabindex="181" disabled="true"/>

	     		</td>
	     	</tr>
			<tr>
				<td class="label">
	         		<label for="tipoContratoCCID">Contrato C&iacute;rculo de Cr&eacute;dito: </label>
	     		</td>
	     		<td>

		     		 <form:input id="tipoContratoCCID" name="tipoContratoCCID" path="tipoContratoCCID" size="3" tabindex="182"/>
		     		<input type="text" id="tipoContratoCCIDDes" name="tipoContratoCCIDDes" size="50" tabindex="183" disabled="true"/>

	     		</td>
	     	</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>PLD</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label" style="width: 160px">
	         		<label for="claveRiesgo">Nivel de Riesgo: </label>
	     		</td>
		     		<td>
		         		<form:select id="claveRiesgo" name="claveRiesgo" path="claveRiesgo" tabindex="184">
		         			<form:option value="">SELECCIONAR</form:option>
							<form:option value="A">Alto</form:option>
							<form:option value="B">Bajo</form:option>
						</form:select>
					</td>
	     	</tr>
		</table>
	</fieldset>
<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all  tipoSofipo">
	<legend>Regulatorios</legend>
		<table border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="label" style="width: 160px">
	         		<label for="claveCNBV">Tipo Producto CNBV: </label>
	     		</td>
		     		<td>
		         		<form:input id="claveCNBV" name="claveCNBV" path="claveCNBV" size="15" maxlength="8" tabindex="185" />
					</td>
	     	</tr>
		</table>
	</fieldset>

	<br>
		<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="198"/>
				<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="199"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" value="S" name="esAgropecuario" id="esAgropecuario" />
				<input type="hidden" value="N" name="esAutomatico" id="esAutomatico" />
				<input type="hidden" value="" name="caracteristicas" id="caracteristicas" />
				<input type="hidden" value="N" name="cobraIVASeguroCuota" id="cobraIVASeguroCuota" />
				<input type="hidden" value="N" name="cobraSeguroCuota" id="cobraSeguroCuota" />
				<input type="hidden" value="N" name="productoNomina" id="productoNomina" />
			</td>
		</tr>
	</table>
	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje"  style='display: none;'></div>
</html>