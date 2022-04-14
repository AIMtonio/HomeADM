$("#numeroDetalle").val($('input[name=consecutivoID]').length);

var tipoChequeraBean ;
var tiposChequera = {};
var tiposConcepto = {};

// variables para la referencia automatica
var algClaveRetiro;
var vigClaveRetiro;
var refereciaAut;
var tipoCuenta = "91";
var complemento;
var fechaVen;
var numeroRan;

	function eliminaDetalle(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");

		var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
		var jqTipoMov = eval("'#tipoMov" + numeroID + "'");
		var jqClaveDispMov = eval("'#claveDispMov" + numeroID + "'");
		var jqCuentaAhoID = eval("'#cuentaAhoID" + numeroID + "'");
		var jqSaldo = eval("'#saldo" + numeroID + "'");
		var jqNombreCte = eval("'#nombreCte" + numeroID + "'");
		var jqClienteID = eval("'#clienteID" + numeroID + "'");
		var jqDescripcion = eval("'#descripcion" + numeroID + "'");
		var jqReferencia = eval("'#referencia" + numeroID + "'");
		var jqFormaPago = eval("'#formaPago" + numeroID + "'");
		var jqTipoChequera = eval("'#stipoChequera" + numeroID + "'");
		var jqTipoCheque = eval("'#tipoChequera" + numeroID + "'");
		var jqMonto = eval("'#monto" + numeroID + "'");
		var jqCuentaClabe = eval("'#cuentaClabe" + numeroID + "'");
		var jqNombreBenefi = eval("'#nombreBenefi" + numeroID + "'");
		var jqTrrenglonCta = eval("'#renglonCta" + numeroID + "'");
		var jqdescriCtaCompleta= eval("'#descriCtaCompleta" + numeroID + "'");
		var jqcuentaCompletaID= eval("'#cuentaCompletaID" + numeroID + "'");

		var jqRFC = eval("'#rfc" + numeroID + "'");
		var jqEstatus = eval("'#estatus" + numeroID + "'");
		var jqEstatusHidden = eval("'#estatusHidden" + numeroID + "'");

		var jqElimina = eval("'#" + numeroID + "'");
		var jqAgrega = eval("'#agrega" + numeroID + "'");


		$(jqConsecutivoID).remove();
		$(jqClaveDispMov).remove();
		$(jqTipoMov).remove();
		$(jqCuentaAhoID).remove();
		$(jqSaldo).remove();
		$(jqNombreCte).remove();
		$(jqClienteID).remove();
		$(jqDescripcion).remove();
		$(jqReferencia).remove();
		$(jqFormaPago).remove();
		$(jqTipoChequera).remove();
		$(jqTipoCheque).remove();
		$(jqMonto).remove();
		$(jqCuentaClabe).remove();
		$(jqNombreBenefi).remove();
		$(jqRFC).remove();
		$(jqEstatus).remove();
		$(jqEstatusHidden).remove();
		$(jqdescriCtaCompleta).remove();
		$(jqcuentaCompletaID).remove();
		$(jqElimina).remove();
		$(jqAgrega).remove();

		$(jqTrrenglonCta).remove();
		$(jqTr).remove();


		var contador = 1;
		var existenGrids = false;
		$('input[name=consecutivoID]').each(function() {
			var jqConsecutivo = eval("'#" + this.id + "'");
			$(jqConsecutivo).val(contador);
			contador = contador + 1;
			existenGrids = true;
		});

		 if(existenGrids==false) {
		 	 $('#numeroDetalle').val(0);
		 	 deshabilitaBoton('grabar', 'submit');
	 	}
		 agregaTotales();
	}


	function cargarTipoChequera(numCta,institID,funcionExtra){
		 jqInstitucionID = eval("'#" + institID + "'");
		 jqNumCtaInstit = eval("'#" + numCta + "'");
		 institucionID = $(jqInstitucionID).val();
		 numCtaInstit = $(jqNumCtaInstit).val();

		tipoChequeraBean = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit
				};
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe) {
				tiposChequera = tiposChe;
				if(typeof funcionExtra== "function"){
					funcionExtra();
				}
		});
	}

	function cargarCombo(id){
		var jsTipoChequera 	 	= eval("'#tipoChequera" + id+ "'");
		var valorTipoChequera	= $(jsTipoChequera).val();

		// $('#stipoChequera'+id).each(function() {  $('#stipoChequera'+id+' option').remove(); });
		$('#stipoChequera'+id).empty();
		if(tiposChequera.length==0 || tiposChequera.length==undefined){
			cargarTipoChequera('numCtaInstit','institucionID',function(){
				$('#stipoChequera'+id).append( new Option('SELECCIONAR', '', true, true));
					for ( var j = 0; j < tiposChequera.length; j++) {
						$('#stipoChequera'+id).append(new Option(tiposChequera[j].descripTipoChe,tiposChequera[j].tipoChequera,true,true));
						habilitaTipoAutorizado(id);
						}
					$('#stipoChequera'+id+' option[value='+ valorTipoChequera +']').attr('selected','true');
			});
		}else{
			$('#stipoChequera'+id).append( new Option('SELECCIONAR', '', true, true));
			for ( var j = 0; j < tiposChequera.length; j++) {
				$('#stipoChequera'+id).append(new Option(tiposChequera[j].descripTipoChe,tiposChequera[j].tipoChequera,true,true));
				habilitaTipoAutorizado(id);
				}
			$('#stipoChequera'+id+' option[value='+ valorTipoChequera +']').attr('selected','true');
		}


	}



function agregaNuevoDetalle(){

	var numeroFila = $('#numeroDetalle').val();
	var nuevaFila = parseInt(numeroFila) + 1;

	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

   	if(numeroFila == 0){
   		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" value="1" autocomplete="off" />';
   		tds +=' <input type="hidden" id="tipoMov'+nuevaFila+'" name="tipoMov" value="3"/>';
   		tds +=' <input type="hidden" id="claveDispMov'+nuevaFila+'" name="claveDispMov" value="0"/></td>';
   		tds += '<td><input type="text" id="cuentaAhoID'+nuevaFila+'" name="cuentaAhoID" size="13" value="" autocomplete="off" onKeyUp="obtenerCuenta(\'cuentaAhoID'+nuevaFila+'\');" onblur="maestroCuentasDescripcion(\'cuentaAhoID'+nuevaFila+'\', \'nombreCte'+nuevaFila+'\', \'clienteID'+nuevaFila+'\', \'saldo'+nuevaFila+'\',\'nombreBenefi'+nuevaFila+'\','+nuevaFila+');" />';
   		tds += '<input type="hidden" id="saldo'+nuevaFila+'" name="saldo" readonly="true" /></td>';
   		tds += '<td><input type="text" id="nombreCte'+nuevaFila+'" name="nombreCte" value="" autocomplete="off" disabled="true" />';
   		tds += '<input type="hidden" id="clienteID'+nuevaFila+'" name="clienteID" readonly="true"/></td>';
   		tds += '<td><input id="cuentaCompletaID'+nuevaFila+'" name="cuentaCompletaID" path="cuentaCompletaID" size="35"  onKeyUp="obtenCtaContable(\'cuentaCompletaID'+nuevaFila+'\');" onblur="validaCuentaContable(\'cuentaCompletaID'+nuevaFila+'\', \'descriCtaCompleta'+nuevaFila+'\' ,'+nuevaFila+' );" /></td>';
   		tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="15" value="" maxlength="50"  autocomplete="off" onkeyup="aMays(event, this)"  onBlur="cambiarTextoMayusculas(); "/></td>';
   		tds += '<td><input type="text" id="referencia'+nuevaFila+'" name="referencia" size="10" value=""  maxlength="30" autocomplete="off" onkeyup="aMays(event, this)" onBlur="cambiarTextoMayusculas()" /></td>';
   		tds += '<td><select id="formaPago'+nuevaFila+'" name="formaPago" onblur="habilitaTipo(\'formaPago'+nuevaFila+'\','+nuevaFila+');"  onChange="validaTipoMov(\'formaPago'+nuevaFila+'\', \'nombreBenefi'+nuevaFila+'\',\'fechaEnvio'+nuevaFila+'\',\'tipoMov'+nuevaFila+'\','+nuevaFila+'); generaReferencia('+nuevaFila+');" ><option value="1">SPEI</option><option value="2">CHEQUE</option><option value="4">TARJETA</option><option value="5">ORDEN DE PAGO</option></select></td>';
   		tds += '<td><input type="hidden" id="tipoChequera'+nuevaFila+'"  name="tipoChequera" size="20" value=""/><select id="stipoChequera'+nuevaFila+'" name="stipoChequera"  onblur="validarFolio('+nuevaFila+');"></select></td>';
   		tds += '<td><input type="text" id="monto'+nuevaFila+'" name="monto" style="text-align:right;"  size="15" value="" autocomplete="off" onblur="validarMonto(this.id, \'saldo'+nuevaFila+'\','+nuevaFila+');verificaSeleccionado(\'cuentaAhoID'+nuevaFila+'\','+nuevaFila+')"/></td>';
   		tds += '<td><input type="text" id="cuentaClabe'+nuevaFila+'" name="cuentaClabe" size="19"   maxlength="20"  value="" autocomplete="off" onblur="validaSpei(\'formaPago'+nuevaFila+'\', this.id,\'stipoChequera'+nuevaFila+'\');validaTar(\'formaPago'+nuevaFila+'\', this.id); aMays(event, this)" onkeypress="return Validador(event, \'formaPago'+nuevaFila+'\', this);"/></td>';
   		tds += '<td><input type="text" id="nombreBenefi'+nuevaFila+'" name="nombreBenefi" value="" maxlength="70" autocomplete="off" onkeyup="aMays(event, this)" onBlur="cambiarTextoMayusculas()"/> </td>';
   		tds += '<td><input type="text" id="rfc'+nuevaFila+'" name="rfc" size="12" value="" maxlength="16"  autocomplete="off" onkeyup="aMays(event, this)"/>';
   		tds += '<input type="hidden" id="estatusHidden'+nuevaFila+'" name="estatus" value="P" /></td>';


   	} else{
   	 var contador = 1;
				$('input[name=consecutivoID]').each(function() {
					contador = contador + 1;
				});
   		var valor = contador;
   		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" value="'+valor+'" autocomplete="off" />';
   		tds +=' 	<input type="hidden" id="tipoMov'+nuevaFila+'" name="tipoMov" value="3"/>'; //value=3= Spei Individual
   		tds +='  	<input type="hidden" id="claveDispMov'+nuevaFila+'" name="claveDispMov" value="0" />       </td>';
   		tds += '<td><input type="text" id="cuentaAhoID'+nuevaFila+'" name="cuentaAhoID" size="13" value="" autocomplete="off" onKeyUp="obtenerCuenta(\'cuentaAhoID'+nuevaFila+'\');" onblur="maestroCuentasDescripcion(\'cuentaAhoID'+nuevaFila+'\',\'nombreCte'+nuevaFila+'\', \'clienteID'+nuevaFila+'\', \'saldo'+nuevaFila+'\',\'nombreBenefi'+nuevaFila+'\','+nuevaFila+');"/>';
   		tds += '	<input type="hidden" id="saldo'+nuevaFila+'" name="saldo" readonly="true" /></td>';
   		tds += '<td><input type="text" id="nombreCte'+nuevaFila+'" name="nombreCte" value="" autocomplete="off" disabled="true" "/>';
   		tds += '	<input type="hidden" id="clienteID'+nuevaFila+'" name="clienteID" readonly="true"/></td>';
   		tds += '<td><input id="cuentaCompletaID'+nuevaFila+'" name="cuentaCompletaID" path="cuentaCompletaID" size="35"  onKeyUp="obtenCtaContable(\'cuentaCompletaID'+nuevaFila+'\');" onblur="validaCuentaContable(\'cuentaCompletaID'+nuevaFila+'\', \'descriCtaCompleta'+nuevaFila+'\','+nuevaFila+'  );" /></td>';
   		tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="descripcion" size="15" maxlength="50"  value="" autocomplete="off" onkeyup="aMays(event, this)"	 onBlur="cambiarTextoMayusculas();"/></td>';
   		tds += '<td><input type="text" id="referencia'+nuevaFila+'" name="referencia" size="10" value="" maxlength="30"  autocomplete="off" onkeyup="aMays(event, this)"	  onBlur="cambiarTextoMayusculas()"/></td>';
   		tds += '<td><select id="formaPago'+nuevaFila+'" name="formaPago" onblur="habilitaTipo(\'formaPago'+nuevaFila+'\','+nuevaFila+');" onChange="validaTipoMov(\'formaPago'+nuevaFila+'\', \'nombreBenefi'+nuevaFila+'\',\'fechaEnvio'+nuevaFila+'\',\'tipoMov'+nuevaFila+'\','+nuevaFila+'); generaReferencia('+nuevaFila+');" ><option value="1">SPEI</option><option value="2">CHEQUE</option><option value="4">TARJETA</option><option value="5">ORDEN DE PAGO</option></select></td>';
   		tds += '<td><input type="hidden" id="tipoChequera'+nuevaFila+'"  name="tipoChequera" size="20" value=""/><select id="stipoChequera'+nuevaFila+'" name="stipoChequera"  onblur="validarFolio('+nuevaFila+');"></select></td>';
   		tds += '<td><input type="text" id="monto'+nuevaFila+'" style="text-align:right;" name="monto" size="15" value="" autocomplete="off" onblur="validarMonto(this.id, \'saldo'+nuevaFila+'\','+nuevaFila+');verificaSeleccionado(\'cuentaAhoID'+nuevaFila+'\','+nuevaFila+')" /></td>';
   		tds += '<td><input type="text" id="cuentaClabe'+nuevaFila+'" name="cuentaClabe" size="19" maxlength="20" value="" autocomplete="off" onblur="validaSpei(\'formaPago'+nuevaFila+'\', this.id,\'stipoChequera'+nuevaFila+'\');validaTar(\'formaPago'+nuevaFila+'\', this.id); aMays(event, this)"  onkeypress="return Validador(event, \'formaPago'+nuevaFila+'\' , this);"/></td>';
   		tds += '<td><input type="text" id="nombreBenefi'+nuevaFila+'" name="nombreBenefi" value="" maxlength="70"  autocomplete="off" onkeyup="aMays(event, this)" onBlur="cambiarTextoMayusculas()"/> </td>';
   		tds += '<td><input type="text" id="rfc'+nuevaFila+'" name="rfc" size="12" value="" maxlength="16" autocomplete="off" onkeyup="aMays(event, this)"/>';
   		tds += '	<input type="hidden" id="estatusHidden'+nuevaFila+'" name="estatus" value="P" /></td>';
   	}

   	tds += '<td align="center"  nowrap="nowrap">	<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle(this)"/>';
   	tds += '		<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
   	tds += '</tr>';

   	tds += '<tr id="renglonCta' + nuevaFila + '" name="renglon">';
   	tds += '<td></td> <td></td> <td></td>';
 	tds += '<td colspan="5"><input id="descriCtaCompleta'+nuevaFila+'" name="descriCtaCompleta" size="80" tabindex="8" disabled="true" readonly="true"></td>';

	tds += '</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;
   	$("#miTabla").append(tds);
   	cargarCombo(nuevaFila);
   	agregaTotales();
   	agregaFormato("monto" + nuevaFila);
   	return false;
}
  function validaTipoMov(tipoMov,nombreBenefi,fechaEnvio, tipomov,fila){
     var tipo= eval("'#"  +tipoMov+ "'");
     var nombre= eval("'#"+nombreBenefi+ "'");
     var fecha= eval("'#" +fechaEnvio+ "'");
     var tipoMovim = eval("'#" +tipomov+ "'");
     var ctaClabe = eval("'#cuentaClabe" +fila+ "'");
     var cuentaClabe=   eval("'cuentaClabe" +fila+ "'");
     var tipoChequera=   eval("'stipoChequera" +fila+ "'");
     var chequeIndividual=4;
     var speiIndividual = 3;
     var tarjetaIndividual =26;
     var cuenta= $(ctaClabe).val();
     var value = $( tipo+' option:selected').val();
     var tMov= parseInt(value);

      if(tMov==1){

        	$(nombre).removeAttr("readOnly");
        	$(fecha).removeAttr('readOnly');
        	$(nombre).css({'background-color' : 'white',"color":"black"});
        	$(fecha).css({'background-color' : 'white', "color":"black"});
        	$(tipoMovim).val(speiIndividual);
        	if(isNaN(cuenta)){
        		alert("Solo Números en Cuenta Clabe.");
        		$(ctaClabe).val('');
        	}
        	if(cuenta!=''){
        		validaSpei(tipoMov, cuentaClabe);
        	}
      	}
      if(tMov==2){
      		$(nombre).attr("readOnly");
      		$(fecha).attr("readOnly","true");
      		$(nombre).css({'background-color' : 'white',"color":"black"});
      		$(fecha).css({'background-color' : '#E6E6E6', "color":"#6E6E6E"});
      		$(tipoMovim).val(chequeIndividual);
      		$(nombre).val('');
      		validaCtaNostroChequera('cuentaAhorro','institucionID',fila);
      		cargarCombo(fila);

    	}else{
    		var numFilas =  $('input[name=cuentaClabe]').length;
     		if(numFilas > 0){
     		for(var i = 1; i <= numFilas; i++){
     		var jqCuentaClabe = eval("'#cuentaClabe" + i + "'");

     		}
     		}
    	}
      if(tMov==4){

      	$(nombre).removeAttr("readOnly");
      	$(fecha).removeAttr('readOnly');
      	$(nombre).css({'background-color' : 'white',"color":"black"});
      	$(fecha).css({'background-color' : 'white', "color":"black"});
      	$(tipoMovim).val(tarjetaIndividual);
      	if(isNaN(cuenta)){
      		alert("Solo Números en Cuenta Clabe.");
      		$(ctaClabe).val('');

      	}
      	if(cuenta!=''){
      		validaTar(tipoMov, cuentaClabe);
      	}
    	}

   }

  function habilitaTipo(idControl,fila){
		var esCheque= $('#formaPago'+fila+' option:selected').text();
	  	if(esCheque == 'CHEQUE'){
	  		habilitaControl('stipoChequera'+fila);
	  		$('#stipoChequera'+fila).focus();
      		validaCtaNostroChequera('cuentaAhorro','institucionID',fila);
      		cargarCombo(fila);

	  	}else {
	  		$('#stipoChequera'+fila).empty();
			$('#stipoChequera'+fila).append( new Option('SELECCIONAR', '', true, true));
	  		$('#monto'+fila).focus();
	  	}

	  }


      function habilitaTipoAutorizado(fila){
      	var ordenPago = '';
		var campoConsulta = $('#formaPagoA'+fila).length;

		if(campoConsulta > 0){
			ordenPago = eval("'#formaPagoA"+fila+"'");
		}else{
			ordenPago = eval("'#formaPago"+fila+"'");
		}

		ordPago =$(ordenPago).val();
		if( ordPago != 2){
			$('#stipoChequera'+fila).empty();
			$('#stipoChequera'+fila).append( new Option('SELECCIONAR', '', true, true));
		}

	  }



  function validarFolio(fila){
	  validafolioChequera('cuentaAhorro','institucionID',fila);
	  }



 	//Funcion para autorizar la dispersion
	function cambiaStatusAutorizar(numeroFila){
		var jqEstatusHidden = eval("'#estatusHidden" + numeroFila + "'");
		var estatusCheckID =  eval('window.document.formaGenerica'+'.estatus'+ numeroFila);
		if(estatusCheckID.checked == true){
			$(jqEstatusHidden).val("A");


		}else{
			$(jqEstatusHidden).val("P");
		}
	}

	function verificaAutorizar(numeroFila){
		var jqEstatusHidden = eval("'#autorizaCheckHidden" + numeroFila + "'");
		var jqMonto = eval("'#montoA" + numeroFila + "'");
		var saldoDisp = $('#saldo').asNumber();
		var totalDisp = getMontoTotal();
		var monto = $(jqMonto).asNumber();
		var estatusCheckID =  eval('window.document.formaGenerica'+'.autorizaCheck'+ numeroFila);
		if(estatusCheckID.checked == true){
			if(totalDisp > saldoDisp){
				if($('#sobregirarSaldo').val()=='N'){
					alert("El Monto Total es Superior al Saldo Disponible.");
					estatusCheckID.checked=false;
				}else{
					$('#totMontoAut').val(totalDisp);
					$(jqEstatusHidden).val("A");
					if ($('#estatusDisper').val() == 'C'){
						deshabilitaBoton('autorizaBoton', 'submit');
					}else{
						habilitaBoton('autorizaBoton', 'submit');
					}
				}
			}else{
				$('#totMontoAut').val(totalDisp);
				$(jqEstatusHidden).val("A");
				if ($('#estatusDisper').val() == 'C'){
					deshabilitaBoton('autorizaBoton', 'submit');
				}else{
					habilitaBoton('autorizaBoton', 'submit');
				}
			}

		}else{
			$('#seleccionCheck').removeAttr('checked');
			$(jqEstatusHidden).val("P");
			$('#totMontoAut').val(totalDisp);
			if(totalDisp <= saldoDisp && saldoDisp > 0 ){
				if ($('#estatusDisper').val() == 'C'){
					deshabilitaBoton('autorizaBoton', 'submit');
				}else{
					habilitaBoton('autorizaBoton', 'submit');
				}
			}
		}
		marcaCheckSelecTodos();
		$('#totMontoAut').val(totalDisp);
		$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
	}

 	function agregaFormato(idControl){
		var jControl = eval("'#" + idControl + "'");

     	$(jControl).bind('keyup',function(){
			$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: -1
						});
		});
		$(jControl).blur(function() {
				$(jControl).formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
				});
		});
		$(jControl).formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});
	}

 	//funcion que llama a poner mayusculas para seguir con el estandar
 	function cambiarTextoMayusculas(){
		setTimeout("$('#cajaLista').hide();", 200);
		$('input[name=descripcion]').each(function() {
			ponerMayusculas(this);
		});

		$('input[name=referencia]').each(function() {
			ponerMayusculas(this);
		});

		$('input[name=nombreBenefi]').each(function() {
			ponerMayusculas(this);
		});

 	}

 	function agregaTotales(){

 		$('#TrTotalMonto').remove();

		var tds = '<tr id="TrTotalMonto" name="col" >';

		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';

		tds +='<td align="right"><label>TOTAL:</label></td>';
		tds +='<td>';
		tds +='<input type="text" id="totMonto" style="text-align:right;" name="totMonto" esMoneda="true" path="totMonto" size="15"	autocomplete="off"  disabled="true" />';
		tds +='</td> ';

		tds +='<td></td> ';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';


		tds += '</tr>';

		$("#miTabla").append(tds);

		recalculaTotal();


	}

 	function recalculaTotal(){
 		var total=0;
		$('input[name=monto]').each(function() {
			var jqMonto = eval("'#" + this.id + "'");
			total += $(jqMonto).asNumber();

		});

 		$('#totMonto').val(total);
 		$('#totMonto').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});

 	}

 	function agregaTotalesAutorizar(){

 		$('#TrTotalMontoAut').remove();

		var tds = '<tr id="TrTotalMontoAut" name="col" >';

		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';

		tds +='<td align="right"><label>TOTAL:</label></td>';
		tds +='<td>';
		tds +='<input type="text" id="totMontoAut" style="text-align:right;" name="totMontoAut" esMoneda="true" path="totMontoAut" size="14"	autocomplete="off"  disabled="true" />';
		tds +='</td> ';

		tds +='<td></td> ';
		tds +='<td></td>';
		tds +='<td></td>';
		tds +='<td></td>';


		tds += '</tr>';

		$("#miTablaAutoriza").append(tds);

		recalculaTotalAutoriza();



	}


 	function recalculaTotalAutoriza(){
 		var total=0;
 		var saldoDisp = $('#saldo').asNumber();
 		var existenMovs = false;
		$('input[name=montoA]').each(function() {
			var jqMonto = eval("'#" + this.id + "'");
			total += $(jqMonto).asNumber();
			existenMovs=true;
		});
 		$('#totMontoAut').val(total);
 		$('#totMontoAut').formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
 		if($('#estatusFolio').val()=='C'){
 			deshabilitaBoton('autorizaBoton', 'submit');
 		}else{
 			if(total > saldoDisp){
 	 			if($('#sobregirarSaldo').val() == 'N'){
 	 				alert('Saldo Insuficiente en la Cuenta  Bancaria.');
 	 				deshabilitaBoton('autorizaBoton', 'submit');
 	 				$('#cuentaAhorro').focus();
 	 				$('#cuentaAhorro').select();

 	 			}else{
 	 				habilitaBoton('autorizaBoton', 'submit');
 	 			}
 	 		}
 	 		else{
	 	 		if(total <= saldoDisp){
	 	 			 habilitaBoton('autorizaBoton', 'submit');
	 	 		}
	 	 		if(existenMovs==false){
	 		 		deshabilitaBoton('autorizaBoton', 'submit');
	 		 	}
 	 		}
 		}
 	}


 	function Validador(e, formaPago,elemento) {


 		 var tipo= eval("'#"  +formaPago+ "'");
 	     var chequeIndividual=4;
 	     var speiIndividual = 3;
 	     var elementoID  =elemento.getAttribute('ID');
 	    var NumCarac = document.getElementById(elementoID).value;
 	      var value = $( tipo+' option:selected').val();
 	      var tMov= parseInt(value);

 	      if(tMov==1){//spei
 	    	 key=(document.all) ? e.keyCode : e.which;
 	 		if (key < 48 || key > 57 || key == 46) {

 	 			if (key==8|| key == 46 )	{
 	 				return true;
 	 			}
 	 			if (key==0 && NumCarac.length==18){
 	 				return true;
 	 			 	 }
 	 			if (key==0 ){
 	 				document.getElementById(elementoID).blur();
 	 				document.getElementById(elementoID).focus();
 	 			 	 }
 	 			else
 	 				alert("Sólo números");
 	 			return false;

 	 		}
 	      	}
 	      if(tMov==2){//cheque
 	    	 aMays(e, elemento);
 	      }
 	     if(tMov==4){//tarjeta
 	    	 key=(document.all) ? e.keyCode : e.which;

 	 		if (key < 48 || key > 57 || key == 46) {

 	 			if (key==8|| key == 46 )	{
 	 				return true;
 	 			}
 	 			if (key==0 && NumCarac.length==16){
 	 				return true;
 	 			 	 }
 	 			if (key==0 ){
 	 				document.getElementById(elementoID).blur();
 	 				document.getElementById(elementoID).focus();
 	 			}
 	 			else
 	 				alert("Sólo números");
 	 			return false;

 	 		}
 	      	}


 	}

 	function ValidadorVerifica(e, fila,elemento) {
 		 var ctaClabe = eval("'#cuentaClabeA" +fila+ "'");

		 var tipo= eval("'#formaPago"  +fila+ "'");
	     var chequeIndividual=4;
	     var speiIndividual = 3;

	      var value = $(tipo).val();
	      var tMov= parseInt(value);

	      if(tMov==1){//spei
	    	 key=(document.all) ? e.keyCode : e.which;
	 		if (key < 48 || key > 57 || key == 46) {

	 			if (key==8|| key == 46)	{
	 				return true;
	 			}
	 			else
	 				alert("Sólo números");
	 			 elemento.value = '';
	 			return false;

	 		}
	      	}
	      if(tMov==2){//cheque
	    	 aMays(e, elemento);
	      }
	      if(tMov==4){//tarjeta
		    	 key=(document.all) ? e.keyCode : e.which;
		 		if (key < 48 || key > 57 || key == 46) {

		 			if (key==8|| key == 46)	{
		 				return true;
		 			}
		 			else
		 				alert("Sólo números");
		 			 elemento.value = '';
		 			return false;

		 		}
		 	}

	      if(tMov==5){//Orden de pago
	    	  aMays(e, elemento);
	        	if($(ctaClabe).val() == ""){
	        		alert("Referencia Orden de Pago esta Vacía.");

	        	}
	      	}
	}

 	function aMays(e, elemento) {
 		tecla=(document.all) ? e.keyCode : e.which;
 		 elemento.value = elemento.value.toUpperCase();
 		}

	function checkTodos(){
		var numeroFila=1;
		var estaSelec = eval('window.document.formaGenerica.seleccionCheck.checked');
		$('input[name=autorizaCheck]').each(function() {
			var numero = this.id.substr(13,this.id.length);
			if(estaSelec){
				$(this).attr('checked', 'true');
				verificaAutorizar(numero);
			} else {
				$(this).removeAttr('checked');
				verificaAutorizar(numero);
			}
		});
	}
	// Devuelve el total de checks.
	function getTodosCheck(){
		var totalOpciones = 0;
		$('input[name=autorizaCheck]').each(function() {
			totalOpciones++;
		});
		return totalOpciones;
	}
	//Marca la opcion Selecciona todos si todos estan seleccionados
	function marcaCheckSelecTodos(){
		var totalOpciones = getTodosCheck();
		var checksMarcados = 0;
		// Cuenta cuántos están marcados.
		$('input[name=autorizaCheck]').each(function() {
			if($(this).attr('checked')== true){
				checksMarcados++;
			}
		});
		// Si el total de los checks estan marcados, se marca la opción de todos.
		if(totalOpciones==checksMarcados){
			$('#seleccionCheck').attr('checked',true);
		} else {
			$('#seleccionCheck').removeAttr('checked');
		}
		// Si no hay checks marcados, se dehabilita el botón de procesar.
		if(checksMarcados==0){
			deshabilitaBoton('autorizaBoton','submit');
		}
	}

	// Devuelve el total de montos seleccionados.
	function getMontoTotal(){
		var totalMontoOpciones = 0.00;
		$('input[name=autorizaCheck]').each(function() {
			if($(this).attr('checked')== true){
				var numero = this.id.substr(13,this.id.length);
				totalMontoOpciones = Number(totalMontoOpciones) + $('#montoA'+numero).asNumber();
			}
		});
		return parseFloat(totalMontoOpciones).toFixed(2);
	}

	function cargarTipoConcepto(funcionExtra){

		tipoCconceptoBean = {
				'nombre':''
				};
			conceptoDispersionServicio.listaCombo(2,tipoCconceptoBean,function(concepto) {
				tiposConcepto = concepto;
				if(typeof funcionExtra== "function"){
					funcionExtra();
				}
		});
	}

	function cargaConcepto(id){
		var jsConceptoDisp 	 	= eval("'#conceptoDisp" + id+ "'");
		var valorConceptoDisp	= $(jsConceptoDisp).val().trim();
//
		$('#sConceptoDisp'+id).empty();
			if(tiposConcepto.length==0 || tiposConcepto.length==undefined){
				cargarTipoConcepto(function(){
					$('#sConceptoDisp'+id).append( new Option('SELECCIONAR', '', true, true));
						for ( var j = 0; j < tiposConcepto.length; j++) {
							$('#sConceptoDisp'+id).append(new Option(tiposConcepto[j].nombre,tiposConcepto[j].conceptoID,true,true));
							}
						$('#sConceptoDisp'+id+' option[value='+ valorConceptoDisp +']').attr('selected','true');
						validarConcepto(id);
				});
			}else{
				$('#sConceptoDisp'+id).append( new Option('SELECCIONAR', '', true, true));
				for ( var j = 0; j < tiposConcepto.length; j++) {
					$('#sConceptoDisp'+id).append(new Option(tiposConcepto[j].nombre,tiposConcepto[j].conceptoID,true,true));
					}
				$('#sConceptoDisp'+id+' option[value='+ valorConceptoDisp +']').attr('selected','true');
				validarConcepto(id);
			}
	}

	function validarConcepto(id){
		var jsConceptoDisp 	 	= eval("'#sConceptoDisp" + id+ "'");
		var valorConceptoDisp	= $(jsConceptoDisp).val().trim();
		deshabilitaControl(('sConceptoDisp'+id));

		if(valorConceptoDisp == 1){
			$('#montoA'+id).removeAttr('readonly');
		}else{
			$('montoA'+id).attr('readonly','true');
		}

	}

	function validarMontoAutoriza(id){
		 $('#montoA'+id).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
	}

	function validarMonto(id){
		 $('#totMontoAut'+id).formatCurrency({positiveFormat: '%n',negativeFormat: '%n', roundToDecimalPlace: 2});
	}
	
	function generaReferencia(id){
		var jqFormaPago = eval("'#formaPago" + id + "'");
		var jqCuentaClabe = eval("'#cuentaClabe" + id + "'");
		var jqCuentaAhoID = eval("'#cuentaAhoID" + id + "'");
		var tipoConsulta = 4;
		var cuentaTesoreria = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit':$('#numCtaInstit').val()
		};
		cuentaNostroServicio.consulta(tipoConsulta, cuentaTesoreria, function(cuentaTeso){
			if(cuentaTeso!=null){
				algClaveRetiro = cuentaTeso.algClaveRetiro;
				vigClaveRetiro = cuentaTeso.vigClaveRetiro;
				
				if($(jqFormaPago).val()== 5 && algClaveRetiro == 'A'){
					complemento = parseInt((Math.random()*999999)+1);
					refereciaAut = tipoCuenta+completaCerosIzquierda($(jqCuentaAhoID).val(),12)+complemento;
					$(jqCuentaClabe).val(refereciaAut);
					var fechaCalculada = sumaDiasFechaHabil(3,$('#fechaActual').val(), vigClaveRetiro, 0, 'S');
					$('#complemento').val(complemento);
					$('#fechaVen').val(fechaCalculada.fecha);
					$('#tipoRef').val(tipoCuenta);
				}
			}
		});	
	}
	