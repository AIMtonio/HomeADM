var SucursalCredito = '';
var NomEmpresaNomina = '';
$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
	$('#Producto').focus();
	$('#fecha').val(parametroBean.fechaSucursal);	
	//Oculto la tabla contenedora del detalle
	$('#tablaDetalle').hide();
	$('#tablaGeneral').hide();
	esTab = true;

	consultaCreditos(this.id);

	//Definicion de Constantes y Enums  
	var catTipoTransaccionAvales = {
  		'agrega':'1',
  		'modifica':'2', 
  		'grabaLista':'3'
	}; 
	
	var catTipoConsultaAvales = {
  		'principal':1,
  		'foranea':2
	};	

	 //------------ Metodos y Manejo de Eventos -----------------------------------------
	
		deshabilitaBoton('modifica', 'submit'); 
		deshabilitaBoton('agrega', 'submit');
		agregaFormatoControles('formaGenerica');

		$(':text').focus(function() {	
		 	esTab = false;
		});
	
		$.validator.setDefaults({
	      submitHandler: function(event) {	      	    
 				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','CreditoID','funcionExito','funcioError');	    
	      }
		});		
	     
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});	


		
		// *******************************************************++

		var catTipoConsulta={};
		catTipoConsulta['MontoTotal']=1;
		catTipoConsulta['Producto']=2;
		catTipoConsulta['ProductoColumnas']=2;
		catTipoConsulta['Sucurs']=3;
		catTipoConsulta['SucursColumnas']=3;
	
		$('.detalle').click( function(){
			bloquearPantallaCarga();  	

		$('#tablaGeneral').hide();
		$('#tablaDetalle').hide();
		$('#Tabla').hide();
		$('#cantidad').val("");
		$('#montoDesembolsar').val("");

		 var removertabla = document.getElementById("miTabla"); 
		   if(removertabla.rows.length>=1){ 
		   		var conta=removertabla.rows.length; 
		   		for(var i=0;i<conta; i++){
		   			document.getElementById("miTabla").deleteRow(0);
		   		}
		   	}




		var idConsulta = this.id;
		var jqTipo = eval("'" + idConsulta + "'");
		var jqColumas = eval("'" + jqTipo + "Columnas'");
		
		var consulta =  catTipoConsulta[jqTipo];
		var numCol = catTipoConsulta[jqColumas];

		var beanCreditos = {
				'tipoConsulta'	: consulta,
				'productoCredito'	: '',
				'sucursal'	: '',
				'empresaNomina'	: ''

				
			};

		$('#detalleConsola').html('');		
			creditosOtorgarServicio.obtieneDatos(beanCreditos, function(data){
				if(data != null && data != ''){
					$('#tablaDetalle').show();
					 creaTabla(data, numCol, consulta);
					 sumarSaldos();
				}
				else{
					mensajeSis("No hay Datos que Mostrar");
				}
				$('#contenedorForma').unblock(); // desbloquear	
			});	

		});

		$('#cerrarDetalle').click(function() {	
		$('#detalleConsola').html('');
		$('#tablaDetalle').hide();
		});

		// **********************	
		

			$('#formaGenerica').validate({

		rules: {

			
		},
		messages: {

		}		
	});
	
	function guardarDetalle(){		  	
	var table = $("#miTabla");
		var value_check = "";
		for (var i = 1; i < table.rows.length; i++) {
		if ($('#chk')[i].is(':checked')) {
		value_check += i + ": " + $('#chk')[i].val();
		}
		}
		
	}
	
	function guardarDetalleGrid(){		
	var CreditoID = "";
	var Estatus = "";

	var enviar = 1; // se llama a la funcion que valida los elementos del grid
	if(enviar==1){ 
		
		var numDetalle = $('input[name=Num]').length; 
		$('#detalleCreditos').val("");
		for(var i = 1; i <= numDetalle; i++){
			CreditoID 		= eval("'#Credito"+i+"'");
			Estatus 	= eval("'#Valor"+i+"'");
			if(i == 1){
				$('#detalleCreditos').val($('#detalleCreditos').val() +
						$(CreditoID).val() + ']' +
						$(Estatus).asNumber()+']' );
			}else{
				$('#detalleCreditos').val($('#detalleCreditos').val() + '[' +
						$(CreditoID).val() + ']' +
						$(Estatus).asNumber() + ']' );
			}
		}
	}
	return enviar;
}	


	function consultaCreditos(idControl) {
		var jqFecha = eval("'#" + idControl + "'");
		var Fecha = $(jqFecha).val();	
		var tipConPrincipal= 1;	

		var beanCreditos = {
				'tipoConsulta'	: tipConPrincipal,
				'productoCredito'	: '',
				'sucursal'	: '',
				'empresaNomina'	: ''

				
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(Fecha != ''){
			creditosOtorgarServicio.obtieneDatos(beanCreditos, function(valor){
						if(valor!=null){		
							$.each(valor[0], function(key, value){
								var valor = "$ " + formatoMiles(value, 2, [',', ",", '.']);
								$('#montoTotal').val(valor);
							});						
																	
						}	 						
				});
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
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


	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
	



});	
// deshabilta controles 
function deshabilitaControler(){
	soloLecturaControl('calle');
	soloLecturaControl('numExterior');
	soloLecturaControl('numInterior');
	soloLecturaControl('manzana');
	soloLecturaControl('lote');
	soloLecturaControl('colonia');
	soloLecturaControl('estadoID');	
	soloLecturaControl('localidadID');	
	soloLecturaControl('coloniaID');
	soloLecturaControl('municipioID');
	soloLecturaControl('CP');
	soloLecturaControl('latitud');
	soloLecturaControl('longitud');
};

// habilita controles
function habilitaControler(){
	habilitaControl('calle');
	habilitaControl('numExterior');
	habilitaControl('numInterior');
	habilitaControl('manzana');
	habilitaControl('lote');
	habilitaControl('estadoID');	
	habilitaControl('localidadID');	
	habilitaControl('coloniaID');
	habilitaControl('municipioID');
	habilitaControl('CP');
	habilitaControl('latitud');
	habilitaControl('longitud');
};

var catTipoConsulta={};
		catTipoConsulta['MontoTotal']=1;
		catTipoConsulta['Producto']=2;
		catTipoConsulta['ProductoColumnas']=2;
		catTipoConsulta['Sucurs']=3;
		catTipoConsulta['SucursColumnas']=4;
		catTipoConsulta['Nomina']=4;
		catTipoConsulta['NominaColumnas']=2;
		catTipoConsulta['Genera']= 5;
		catTipoConsulta['GeneraColumnas']=6;
		catTipoConsulta['grabaLista']=6;


function ObtieneConsulta(idControl){
	bloquearPantallaCarga();
	var valor = idControl;
	
		var nombreConsulta 	= valor.substring(0, 6);
		var jqValor = eval("'#" + idControl + "'");
		var nomValor = $(jqValor).val();	
		
		var jqTipo = nombreConsulta;
		var jqColumas = eval("'" + jqTipo + "Columnas'");
		
		
		var consulta =  catTipoConsulta[jqTipo];
		var numCol = catTipoConsulta[jqColumas];
		var beanCreditos = {
				'tipoConsulta'	: consulta,
				'productoCredito'	: nomValor,
				'sucursal'	: '',
				'empresaNomina'	: ''

				
			};

		$('#detalleConsola').html('');		
		creditosOtorgarServicio.obtieneDatos(beanCreditos, function(data){
			if(data != null && data != ''){
				var esNomina = data[0].ProductoNomina;			
				$('#tablaDetalle').show();
				 creaTabla(data, numCol, consulta);
				 sumarSaldos();
			}
			else{
				mensajeSis("No hay Datos que Mostrar");
			}
			$('#contenedorForma').unblock(); // desbloquear	
		});
	

}

function obtieneTipoConsulta(idControl, valor){
	bloquearPantallaCarga();
	var validaProducto = valor;
	var tipoConsulta = "";
	var nombreConsulta 	= idControl.substring(0, 6);
	
		var jqValor = eval("'#" + idControl + "'");
		var nomValor = $(jqValor).val();	
		SucursalCredito = nomValor;
		document.getElementById('nombreEncabezado').innerHTML = SucursalCredito;


		if(validaProducto!= null){
			if(validaProducto == 'S'){
			tipoConsulta = 4;
			numCol = 2;
			}
			if(validaProducto == 'N'){
				tipoConsulta = 5;
				numCol = 6;
			}
		}
		else{
			var jqTipo = nombreConsulta;
			var jqColumas = eval("'" + jqTipo + "Columnas'");
			
			
			var tipoConsulta =  catTipoConsulta[jqTipo];
			var numCol = catTipoConsulta[jqColumas];

		}
		
		var beanCreditos = {
				'tipoConsulta'	: tipoConsulta,
				'productoCredito'	: nomValor,
				'sucursal'	: '',
				'empresaNomina'	: ''

				
			};

		$('#detalleConsola').html('');		
		creditosOtorgarServicio.obtieneDatos(beanCreditos, function(data){
			if(data != null && data != ''){
				var esNomina = data[0].ProductoNomina;
					
				if(tipoConsulta!=5){
				$('#tablaDetalle').show();
				$('#tablaGeneral').hide();
				

				 creaTabla(data, numCol, tipoConsulta);
				 sumarSaldos();
				}
				else{					
					$('#tablaDetalle').hide();
					$('#tablaGeneral').show();

					 creaTabla(data, numCol, tipoConsulta);
					 sumarSaldos();
				}
				$('#contenedorForma').unblock(); // desbloquear	
				
			}
			else{
				mensajeSis("No hay Datos que Mostrar");	
			}

		});
}

//Metodo para crear el contenido del detalle de la consulta
	function creaTabla(data, numCol, tipoConsulta){
		var tds = "";
		var colTd = 0;
		var i = 0;
		var renglon = 0;
		var colspan = numCol - 1;
		var validaProducto = esNomina;
		var ProductoNomina = "ProductoNomina";
		var esNomina = data[0].ProductoNomina;			
		var Credito = "CreditoID";
		var Estatus = "Estatus";
		


		tds += creaEncabezadoTabla(tipoConsulta);
		tds += "<tr name=renglon >";		
		
		for(i=0; i< data.length; i++){
			$.each(data[i], function(key, value){
				switch(tipoConsulta){
					case 2:
						var idCampo = 'Sucursal';
						if(colTd == 0){
							tds += '<td >' + '<input type="text" onClick="ObtieneConsulta(this.id)" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

						}
						else{

							tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</td>';
						}
					break;
					case 3:							
					var idCampo = 'Nomina';						
						if(colTd == 0){
							
							tds += '<td >' + '<input type="text" onClick="obtieneTipoConsulta(this.id,\''+esNomina+'\')"  name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

						}						
						else{
							if(key == ProductoNomina){
							

							tds += '<td style="display:none;">' + '<input type="hidden" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

							}
							else
							{
							tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</td>';
							}
					
						}
					break;
					case 4:	
					var idCampo = 'General';	
		
						if(colTd == 0){
							tds += '<td >' + '<input type="text" onClick="obtieneTipoConsulta(this.id)" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

						}
						
						else{


							tds += '<td >'+'<input type="text" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</td>';
						}
					break;
					case 5:	
					
					if(colTd == 0){
						tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="10" readOnly="true" />'+'</td>';

						}
					if(colTd == 1){
						tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="42" readOnly="true" />'+'</td>';

						}
					if(colTd == 2){
						tds += '<td >'+'<input type="text" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="50" readOnly="true" />'+'</td>';

						}
					if(colTd == 3){
						tds += '<td >'+'<input type="text"  style="text-align:right" name="'+key+'" id="'+key+''+renglon+'" value="' + value + '" size="15" readOnly="true" />'+'</td>';

						}
					if(colTd == 4){
							idCampo = 'Estatus';

							tds += '<td style="display:none;">' + '<input type="hidden" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

							}
					if(key == Credito){
							idCampo = 'Credito';

							tds += '<td style="display:none;">' + '<input type="hidden" name="'+key+'" id="'+idCampo+''+renglon+'" value="' + value + '" size="35" class="cajaEncabezado" readOnly="true" />'+'</a></td>';

							}

					break;
					


				}				
							
				colTd = colTd + 1;
				
				if(colTd == numCol){
					if(tipoConsulta!=5){
						tds += "</tr>";
						tds += "<tr>";
						colTd = 0;
					}
					else{
						var nomCheck = 'Valor';
												
						tds += '<td>';
						tds += '<input type="checkbox" name="'+nomCheck+'" id="'+nomCheck+''+renglon+'" value="N" onclick="verificaSeleccion()"/>';						
						tds +=	'</td>';							

						tds += "</tr>";
						tds += "<tr>";
						colTd = 0;
					}
					
				}
				renglon = renglon + 1;
			});

		}


		if(tipoConsulta != 5 && tipoConsulta != 3){
			tds += '<tr><td colspan="'+colspan+'" id="totalFinal"><b>Total:</submitHandlerb></td><td><input type="text" name="sumatoriaFinal" id="sumatoriaFinal" size="35" value="" class="cajatexto" readOnly="true"></td></tr>';
		$('#detalleConsola').append(tds);
		}
		if(tipoConsulta == 3){
			colspan = colspan-1;
			tds += '<tr><td colspan="'+colspan+'" id="totalFinal"><b>Total:</b></td><td><input type="text" name="sumatoriaFinal" id="sumatoriaFinal" size="35" value="" class="cajatexto" readOnly="true"></td></tr>';
		$('#detalleConsola').append(tds);
		}

		if(tipoConsulta == 5){
			$('#Tabla').show(500);	
			$('#miTabla').append(tds);

			
			$('#selecTodas').click(function() {

				$('input[name=Valor]').each(function() {		
					var menuID = eval("'#" + this.id + "'");	
					var numMenuID= $(menuID).val();					
					var checked = eval("'#Valor" + numMenuID + "'");					
		        	if( $('#selecTodas').is(":checked") ){
			         	$(menuID).attr('checked','true');
			          	$(menuID).val('S'); 

			          	$("input[name=Estatus]").each(function(i){			
							var jqEstatus = eval("'#" + this.id + "'");	
							$(jqEstatus).val('S');						

						});

			          	habilitaBoton('procesar', 'submit');
		         	}else{
					   $(menuID).removeAttr('checked');
		          		$(menuID).val('N'); 
		          		$("input[name=Estatus]").each(function(i){			
							var jqEstatus = eval("'#" + this.id + "'");	
							$(jqEstatus).val('N');						

						});
			          	deshabilitaBoton('procesar', 'submit');

		         	}

				});

				verificaSeleccion();
			
			});


		}
		
	}


	//Metodo para crear los encabezados de cada detalle
	function creaEncabezadoTabla(tipoConsulta){
		
		var trs = '';
		
		switch(tipoConsulta){
			case 2:
				trs += '<tr align="center"><td class="label"><label for="lblProd">Producto Crédito</label></td><td class="label"><label for="lblMonto">Monto a Ministrar</label></td></tr>';
					$('#nombre').html('por Producto');
				break;
			case 3:
				trs += '<tr align="center"><td class="label"><label for="lblSuc">Sucursal</label></td><td class="label"><label for="lblProdCred">Producto de Crédito</label></td><td class="label"><label for="lblMontoMin">Monto a Ministrar</label></td></tr>';
					$('#nombre').html('Por Sucursal');
				break;
			case 4:
				trs += '<tr align="center"><td class="label"><label for="lblEmpNomina">Empresa de Nómina</label></td><td class="label"><label for="lblMontoMinis">Monto a Ministrar</label></td></tr>';
					$('#nombre').html('Empresas de Nomina');
				break;
				
			case 5:				
				trs += '<tr align="center" id="encabezadoLista"><td class="label" ><label for="lblNum" style="color:white; font-weight: bold">Num.</label></td><td class="label"><label for="lblProductoCred" style="color:white; font-weight: bold">Producto Crédito</label></td><td class="label"><label for="lblNomBenefic" style="color:white; font-weight: bold">Nombre Beneficiario</label></td><td class="label"><label for="lblMontFin" style="color:white; font-weight: bold">Monto</label></td><td><input type="checkbox" id="selecTodas" name="selecTodas" value="" /></td></tr>';
					$('#nombre').html('');
				break;

			
			
		}
							
		return trs;
	}
	

	function sumarSaldos(){
		var sumatoria = 0;
		$("input[name=MontoCredito]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			$(jqSaldo).val(formatoMiles($(jqSaldo).val(), 2, [',', ",", '.']));
		});

		$("input[name=Monto]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");				
			sumatoria += parseFloat($(jqSaldo).val());
			$(jqSaldo).val(formatoMiles($(jqSaldo).val(), 2, [',', ",", '.']));
			$("input[name=Monto]").css({"text-align":"right"});
		});

		$('#sumatoriaFinal').val("$ "+formatoMiles(sumatoria , 2, [',', ",", '.']));

		$("input[name=Monto]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			var valor = $(jqSaldo).val();
			$(jqSaldo).val("$ "+ valor);			
		});

		$("input[name=MontoCredito]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			var valor = $(jqSaldo).val();
			$(jqSaldo).val("$ "+ valor);			
		});


		$('#sumatoriaFinal').css({"text-align":"right"});
		$('#totalFinal').css({"text-align":"right"});
	}


	// rutina para separador de miles
function formatoMiles(value, decimals, separators) {
    decimals = decimals >= 0 ? parseInt(decimals, 0) : 2;
    separators = separators || [',', ',', '.'];
    
    var number = (parseFloat(value) || 0).toFixed(decimals);
    
    if (number.length <= (4 + decimals)){
        return number.replace('.', separators[separators.length - 1]);
    }
    var parts = number.split(/[-.]/);
    
    value = parts[parts.length > 1 ? parts.length - 2 : 0];
    
    var result = value.substr(value.length - 3, 3) + (parts.length > 1 ? separators[separators.length - 1] + parts[parts.length - 1] : '');
    
    var start = value.length - 6;
    var idx = 0;
   
    while (start > -3) {
        result = (start > 0 ? value.substr(start, 3) : value.substr(0, 3 + start)) + separators[idx] + result;
        idx = (++idx) % 2;
        start -= 3;
    }
    
    return (parts.length == 3 ? '-' : '') + result;
}

function verificaSeleccion(){

	var Total = 0;
	var NumSeleccionados = 0;
	var j=document.getElementById("miTabla").rows.length;
	for (var i = 1; i < j-1; i++) {
		var ID = ((5 * i)+(i-2));
		var Monto = "MontoCredito" + (ID - 1);
		var Estatus = "Estatus" + (ID);
		var Check = "Valor" + (ID+1);
		

		Total += parseFloat(valida(Check,Monto,Estatus));
	}
	NumSeleccionados = cuentaSeleccionados();
	if(NumSeleccionados>=1){
		habilitaBoton('procesar', 'submit');
	}else{
			deshabilitaBoton('procesar', 'submit');
	}	

	Total = "$ " + formatoMiles(Total, 2, [',', ",", '.']);
	$('#montoDesembolsar').val(Total);
   	$('#cantidad').val(NumSeleccionados);
}

function valida(idControl,Monto,Estatus){
	var jqControl = eval("'#" + idControl + "'");
	var jqValor = eval("'#" + Monto + "'");
	var jqEstatus = eval("'#" + Estatus + "'");
	var MontoCred = 0;
	var Monto2 = 0;

	if ($(jqControl).is(':checked')) {
		MontoCred = $(jqValor).val();
		Monto2 = MontoCred.replace('$','').replace(',','');
		$(jqControl).val('S');
		$(jqEstatus).val('S');
		

	}
	else{
		$(jqControl).val('N');
		$(jqEstatus).val('N');
	
	}

	return Monto2;

}
function cuentaSeleccionados(){
	var numero = 0;
	$("input[name=Valor]").each(function(i){			
			var jqValida = eval("'#" + this.id + "'");				
			if ($(jqValida).is(':checked')) {
				numero = numero+1;
				
			}
			
		});
	return numero;

}

$('#procesar').click(function() {
	var numero = 6;
	$('#tipoTransaccion').val(numero);	
});

 

$('#cerrarDetalle').click(function() {	
		$('#detalleConsola').html('');
		$('#tablaDetalle').hide();
		});


function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}

//Función de éxito en la transación
function funcionExito(){
	var consulta = 'Producto';
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert);
			$('#tablaDetalle').hide();
			$('#tablaGeneral').hide(); 
			actualizaMonto();
			
		}
        }, 50);
	}

}

//función de error en la transacción
function funcionError(){
	
}

function actualizaMonto() {
		var tipConPrincipal= 1;	

		var beanCreditos = {
				'tipoConsulta'	: tipConPrincipal,
				'productoCredito'	: '',
				'sucursal'	: '',
				'empresaNomina'	: ''				
			};
		setTimeout("$('#cajaLista').hide();", 200);		
	
			creditosOtorgarServicio.obtieneDatos(beanCreditos, function(valor){
						if(valor!=null){		
							$.each(valor[0], function(key, value){
								var valor = "$ " + formatoMiles(value, 2, [',', ",", '.']);
								$('#montoTotal').val(valor);
							});						
																	
						}	 						
				});
			
}	