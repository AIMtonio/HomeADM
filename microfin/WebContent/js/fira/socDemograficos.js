 
$(document).ready(function() {
		$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	 
	 	
	//Definicion de Constantes y Enums  
	var catTipoConsultaDatosSocioDem = {
  		'principal':1,
  		'foranea':2,
  		'infoDatosSocioe':3
	};	
 
	
	var catTipoTranDatosSocioDem = {
  		'graba':1,
  		'modifica':2,
  		'grabalista':3
	};
	
	var parametroBean = consultaParametrosSession();  
	 
 	deshabilitaBoton('grabar', 'submit');
 	$('#gridDependientes').hide();

	agregaFormatoControles('formaGenerica2');
	 

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica2', 'contenedorForma', 'mensaje','false','dependEconom');
			 
		}
	});	
	 
	 

	llenaTipoComboGradosEsc('gradoEscolarID');
	 
	
	$('#grabarDSE').click(function() {	
		$('#tipoTransaccionDSE').val(catTipoTranDatosSocioDem.graba);
		inicializaTabs();
	});
	
 
 
	 
	$('#agreNumDepEc').click(function() {
		var numero = $('#numDepenEconomi').asNumber();
		if(numero>15){
			mensajeSis("Solo se pueden agregar 15 dependientes económicos.");
		}
		
		else{
				agregaNuevoDetalle();		 
		}

	});

	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica2').validate({
		rules: {
			numDepenEconomi: { 
				required: true
			}
		},
		
		messages: {
			numDepenEconomi: {
				required: 'Especificar Número de dependientes'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------


	 function regresaNumDepend(numero){
		 
		var retorno=0;
		
		 var contador=0;
			$('input[name=elimina]').each(function() {		
				contador++;
			});
		if(contador==0 && numero > 0)	{
			retorno=0;
		}else{
			if(contador>0 && numero<contador){
				if (confirm("Se eliminarán los "+contador+" registros y se agregarán "+numero+" nuevos ¿Esta seguro?")) {
						limpiaFormaGridPantalla();
						retorno=0;
					}else{
						 $('#numDepenEconomi').val(contador);
						 retorno=contador;
					}
			}
			if(contador>0 && numero>contador){
				retorno=contador;
			}
		}
		 
		return retorno;
	 }
	 
	  
	
 

	
	 
	 
	 function llenaTipoComboGradosEsc(idControl){
			var todos=0;
			var datSocDemogBean = {
			  		'gradoEscolarID':todos
				};	
			
			var tipoListaPrincipal=1;
			dwr.util.removeAllOptions(idControl); 
			datSocDemogServicio.listaGradosEsc(tipoListaPrincipal,datSocDemogBean ,function(lisRelaciones){
				dwr.util.addOptions('gradoEscolarID', {0:'SELECCIONAR'});
				dwr.util.addOptions(idControl, lisRelaciones, 'gradoEscolarID', 'descriGdoEscolar');
			});
		}
 
	 
 function  llenaCombosGridRelaciones(){
	
	 $('input[name=elimina]').each(function() {		
			var idRelacion = eval('tipoRelacion'+this.id);
			llenaTipoRelacion(idRelacion);
		});
	 llenaTipoRelacion(idControl)
 }
	  	
	  	
 ///********** VALIDACIONED DE DATOS SOCIODEMOGRÁFICOS
	  	
	  	
	
	
	
});// fin de document ready
		


 
	
	
	function agregaNuevoDetalle(){

		var numeroFila = $('#numeroDetalle').val();
		var nuevaFila = parseInt(numeroFila) + 1;		
		if(numeroFila=='0'){
			$('#gridDependientes').show();
		}
		var tds = '<tr id="renglonSD' + nuevaFila + '" name="renglonSD">';
 
		tds +='<td><input id="tipoRelacion'+nuevaFila+'" name="tipoRelacion" size="4" path="tipoRelacion" onKeyUp="listaRelacion('+nuevaFila +')" onblur="consultaParentesco('+nuevaFila +'); " />';
		tds += ' 	<input id="nombreRelacion'+nuevaFila+'" name="nombreRelacion" disabled="true" size="38" />  </td>	 ';
		tds +='	<td> <input id="primerNomb'+nuevaFila+'" name="primerNomb" path="primerNomb" onBlur=" ponerMayusculas(this)" /></td>	 ';
	    tds +='<td> <input id="segundNomb'+nuevaFila+'" name="segundNomb" path="segundNomb" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="tercerNomb'+nuevaFila+'" name="tercerNomb" path="tercerNomb" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="apePaterno'+nuevaFila+'" name="apePaterno" path="apePaterno" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="apeMaterno'+nuevaFila+'" name="apeMaterno" path="apeMaterno" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="edades'+nuevaFila+'" name="edades" path="edades" size="4" maxlength="2" onkeypress="return validaSoloNumero(event,this);"/></td> ';
		tds +='<td><input id="ocupaciones'+nuevaFila+'" name="ocupaciones" size="4" maxlength="11" path="ocupaciones" onKeyUp="listaOcupacion('+nuevaFila +')" onblur="consultaTrabajo('+nuevaFila +'); " />';
		tds += ' 	<input id="nombreOcupacion'+nuevaFila+'" name="nombreOcupacion" disabled="true" size="45" />  </td>	 ';


		tds += '<td align="center">	<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle('+nuevaFila +')"/> </td>';
 		tds += '</tr>';

		document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTablaSD").append(tds);

 
		var contador=0;
		$('input[name=elimina]').each(function() {		
			contador++;	
		});
		 $('#numDepenEconomi').val(contador);
		 llenaTipoRelacion('tipoRelacion'+nuevaFila);
	}

	
	
	
	
	function agregaNuevoDetalleGridCon(){

		var numeroFila = $('#numeroDetalle').val();
		var nuevaFila = parseInt(numeroFila) + 1;		
		if(numeroFila=='0'){
			$('#gridDependientes').show();
		}
		var tds = '<tr id="renglonSD' + nuevaFila + '" name="renglonSD">';
 
		tds +='<td><input id="tipoRelacion'+nuevaFila+'" name="tipoRelacion" path="tipoRelacion" size="5" onKeyUp="listaRelacion('+nuevaFila +')" onblur="consultaParentesco('+nuevaFila +'); " />';
		tds +='	<input id="nombreRelacion'+nuevaFila+'" name="nombreRelacion" disabled="true" size="38" />  </td>	 ';
		tds +='	<td> <input id="primerNomb'+nuevaFila+'" name="primerNomb" path="primerNomb" onBlur=" ponerMayusculas(this)" /></td> ';
	    tds +='<td> <input id="segundNomb'+nuevaFila+'" name="segundNomb" path="segundNomb" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="tercerNomb'+nuevaFila+'" name="tercerNomb" path="tercerNomb" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="apePaterno'+nuevaFila+'" name="apePaterno" path="apePaterno" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="apeMaterno'+nuevaFila+'" name="apeMaterno" path="apeMaterno" onBlur=" ponerMayusculas(this)" /></td> ';
		tds +='<td> <input id="edades'+nuevaFila+'" name="edades" path="edades" size="4" maxlength="2" onkeypress="return validaSoloNumero(event,this);"/></td> ';
		tds +='<td><input id="ocupaciones'+nuevaFila+'" name="ocupaciones" size="4" maxlength="11" path="ocupaciones" onKeyUp="listaOcupacion('+nuevaFila +')" onblur="consultaTrabajo('+nuevaFila +'); " />';
		tds += ' 	<input id="nombreOcupacion'+nuevaFila+'" name="nombreOcupacion" disabled="true" size="38" />  </td>	 ';


		tds += '<td align="center">	<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle('+nuevaFila +')"/> </td>';
 		tds += '</tr>';

		document.getElementById("numeroDetalle").value = nuevaFila;    	
		$("#miTablaSD").append(tds);

 
		var contador=0;
		$('input[name=elimina]').each(function() {		
			contador++;
		});
		 $('#numDepenEconomi').val(contador);
		  
	}

	
	function llenaTipoRelacion(idControl){
		var todos=0;
		var datSocDemogBean = {
		  		'tipoRel':todos
			};	
		
		var tipoListaPrincipal=1;
		dwr.util.removeAllOptions(idControl); 
		datSocDemogServicio.listaRelaciones(tipoListaPrincipal,datSocDemogBean ,function(lisRelaciones){
		dwr.util.addOptions(idControl, lisRelaciones, 'tipoRel', 'descripRelacion');
		});
	}

	function eliminaDetalle(numeroID){		

		var jqTr = eval("'#renglonSD" + numeroID + "'");


		var jqTipoRelacion = eval("'#tipoRelacion" + numeroID + "'");
		var jqPrimerNomb = eval("'#primerNomb" + numeroID + "'");
		var jqSegundNomb = eval("'#segundNomb" + numeroID + "'");
		var jqTercerNomb = eval("'#tercerNomb" + numeroID + "'");
		var jqApePaterno = eval("'#apePaterno" + numeroID + "'");
		var jqApeMaterno = eval("'#apeMaterno" + numeroID + "'");
		var jqEdad = eval("'#edades" + numeroID + "'");
		var jqOcupacion = eval("'#ocupaciones" + numeroID + "'");

		var jqElimina = eval("'#" + numeroID + "'");
		var jqAgrega = eval("'#agrega" + numeroID + "'");

		$(jqTipoRelacion).remove(); 
		$(jqPrimerNomb).remove(); 
		$(jqSegundNomb).remove(); 
		$(jqTercerNomb).remove(); 
		$(jqApePaterno).remove(); 
		$(jqApeMaterno).remove(); 
		$(jqEdad).remove(); 
		$(jqOcupacion).remove(); 
	  

		$(jqElimina).remove();
		$(jqAgrega).remove();

		$(jqTr).remove();


		var existenGrids = false;
		var contador=0;
		$('input[name=elimina]').each(function() {		
			var jqConsecutivo = eval("'#" + this.id + "'");	
			existenGrids = true;
			contador++;
		});
		 $('#numDepenEconomi').val(contador);
		 
		 
		if(existenGrids==false) {
			$('#numeroDetalle').val(0);
			consultoPuestos=true;
			$('#gridDependientes').hide();
		}
		inicializaTabs();
	}
	
	
	function limpiaFormaGridPantalla(){

		$('input[name=elimina]').each(function() {	

			eliminaDetalle(this.id);

		});	 

	}
	
	function consultaParentesco(numeroFila) {
		var jqParentesco = eval("'#tipoRelacion" + numeroFila + "'");
		var jqIdNombreParent =  eval("'#nombreRelacion" + numeroFila + "'"); 
		var numParentesco = $(jqParentesco).val();
		var tipPrincipal= 1;

		var ParentescoBean = {
				'parentescoID' : numParentesco
		};

		if(numParentesco != '' && !isNaN(numParentesco)){
			parentescosServicio.consultaParentesco(tipPrincipal, ParentescoBean, function(parentesco) {
						if(parentesco!=null){
							$(jqIdNombreParent).val(parentesco.descripcion);
						}else{
							mensajeSis("No Existe el Tipo de relación");
							$(jqParentesco).val('');
							$(jqIdNombreParent).val('');
						}
				});
			}
		}
	
	function listaRelacion(numeroFila){
		var jqControl = eval("'tipoRelacion" + numeroFila + "'");
		var jqParentesco = eval("'#tipoRelacion" + numeroFila + "'");
		
	lista(jqControl, '2', '1', 'descripcion',$(jqParentesco).val(), 'listaParentescos.htm');
	
	}
	
	//Realiza la consulta de la ocupacion elegida en el campo y despliega su descripcion donde corresponde
	function consultaTrabajo(numeroFila) {
		var jqOcupacion = eval("'#ocupaciones" + numeroFila + "'");
		var jqIdNombreOcupa =  eval("'#nombreOcupacion" + numeroFila + "'"); 
		var numOcupacion = $(jqOcupacion).val();
		var tipPrincipal= 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numOcupacion != '' && !isNaN(numOcupacion)){
			ocupacionesServicio.consultaOcupacion(tipPrincipal, numOcupacion, function(ocupacion) {
				if(ocupacion!=null){
					$(jqIdNombreOcupa).val(ocupacion.descripcion);
				}else{
					mensajeSis("No Existe la Ocupacion");
					$(jqOcupacion).val('');
					$(jqIdNombreOcupa).val('');
					$(jqOcupacion).focus();
				}
			});
		}else {
			$(jqOcupacion).val('');
			$(jqIdNombreOcupa).val('');
		}
	}
	//Despliega la lista de ocupaciones
	function listaOcupacion(numeroFila){
		var jqControl = eval("'ocupaciones" + numeroFila + "'");
		var jqOcupacion = eval("'#ocupaciones" + numeroFila + "'");
		
		lista(jqControl, '1', '1', 'descripcion',$(jqOcupacion).val(), 'listaOcupaciones.htm');
	}
	
	
	//recalcula la antiguedad laboral del cliente
	function calculaAntiguedadLaboral(evento){	
		var antiguedadTra = "";
		var antiguedadMes = "";	
		var fechaActualSistema = parametroBean.fechaSucursal;
		var jqAntiguedadMes =  eval("'#antiguedadLab'");
			
		if(evento.value != ""){
			if(esFechaValida(evento.value)){
				if ( mayor(evento.value, fechaActualSistema) ){
					mensajeSis("La Fecha Indicada es Mayor a la Fecha Actual del Sistema.")	;
					evento.value = fechaActualSistema;
					evento.focus();
				}else{
						antiguedadTra = restaFechas(evento.value,fechaActualSistema);
						if(parseInt(antiguedadTra) <= 0) antiguedadTra = 1;
						
						// verifico cuantos enteros son
						antiguedadMes = parseInt(antiguedadTra) / 30 ;
						if(parseInt(antiguedadMes) < 1) { 
							antiguedadMes = 0;
						}else{
							antiguedadMes = parseInt(antiguedadMes);
						}						
						
						$(jqAntiguedadMes).val(antiguedadMes);	
				
				}
			}
			else{
				evento.value = fechaActualSistema;
				$(jqAntiguedadMes).val('0');
			}
		}else{
			evento.value = fechaActualSistema;
			$(jqAntiguedadMes).val('0');
		}
		
		
	}
	
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea.");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	
	//Función para calcular los días transcurridos entre dos fechas
	function restaFechas(fAhora,fEvento) {	
		var ahora = new Date(fAhora);
	  var evento = new Date(fEvento);
	  var tiempo = evento.getTime() - ahora.getTime();
	  var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
	  
		return dias;
	}
	
	//Funcion para permitir unicamente el ingreso de numeros 
	function validaSoloNumero(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer, Chromium, Chrome
			key = e.keyCode; 
		}else if(e.which){//Firefox, Opera Netscape
				key = e.which;
		}
		
		 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
		    return false;
		 return true;
	}