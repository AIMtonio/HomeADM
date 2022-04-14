$(document).ready(function() {
	//$("#agregarConve").focus();
	esTab = true;
	
	var parametroBean = consultaParametrosSession();
	//Definicion de Constantes y Enums
	
	var tipoTransaccion = {  
	  		'grabar':'1'	
  	};

	
	// ------------ Metodos y Manejo de Eventos
	habilitaBoton('grabar', 'submit');
	habilitaBoton('agregarConve','submit');
	agregaFormatoControles('formaGenerica');
	consultaConvencionesSeccionales();
	
	$('#fechaSis').val(parametroBean.fechaSucursal);
	
	//validacion
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  var envia = guardarFechas();
	  		if(envia!=2){
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','sucursalID', 
	    			  'funcionExitoConvencionSeccional','funcionErrorConvencionSeccional');
	     
	      }
	  		else{
		  		  mensajeSis("Faltan datos");
		  	  }
		 
  	  	}
		
	});

	$('#grabar').click(function() {
		mandaRegistrados();
		$('#tipoTransaccion').val(tipoTransaccion.grabar);
		
	});

	// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {

		},
		messages : {

		}
	});
		

	
	});



function consultaConvencionesSeccionales(){	
	var params = {};
	params['tipoLista'] = 1;
	
	$.post("convencionSeccionalGridVista.htm", params, function(data){
		if(data.length >0) {
			$('#divConvencionesSeccionales').html(data);
			$('#divConvencionesSeccionales').show();
			verificaRegistrados();
			if($('#sucursalID1').val() == undefined ){
				$("#agregarConve").show();
			
			}
			else{
				$("#agregarConve").hide();
			}
		}else{	
		
			$('#divConvencionesSeccionales').html("");
			$('#divConvencionesSeccionales').show();
			
			}
		});
	}
	

	function agregarConvencionSeccional(){	
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" type="hidden" />';
			tds += '<input type="text" id="sucursalID'+nuevaFila+'" name="lsucursalID"  size="5"  value="" onkeypress="listaSucursales(this.id)" onblur="validaSurcursales(this.id)"/></td>';								
			tds += '<td><input type="text" id="nombreSucurs'+nuevaFila+'" name="lnombreSucurs" size="40" value="" readOnly="true" /></td>';
			tds += '<td><input type="text" id="fecha'+nuevaFila+'" name="lfecha" size="18 value="" onblur="onblurfecha(this.id,\'sucursalID'+numeroFila+'\');" /></td>';
			tds += '<td><input type="text" id="cantSocio'+nuevaFila+'" name="lcantSocio" size="6" value="" onblur="onblurCantSocio(this.id)" onkeyPress="return validador(event);"/></td>';
			tds += '<td><input type="checkbox" id="esGral'+nuevaFila+'" name="lesGral" value="" onclick="realiza(this.id)"/></td>';
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'" type="hidden" />';
			tds += '<input type="text" id="sucursalID'+nuevaFila+'" name="lsucursalID"  size="5"  value="" onkeypress="listaSucursales(this.id)" onblur="validaSurcursales(this.id)"/></td>';								
			tds += '<td><input type="text" id="nombreSucurs'+nuevaFila+'" name="lnombreSucurs" size="40" value="" readOnly="true" /></td>';
			tds += '<td><input type="text" id="fecha'+nuevaFila+'" name="lfecha" size="18" value="" onblur="onblurfecha(this.id,\'sucursalID'+valor+'\');"/></td>';
			tds += '<td><input type="text" id="cantSocio'+nuevaFila+'" name="lcantSocio" size="6" value="" onblur="onblurCantSocio(this.id)" onkeyPress="return validador(event);"/></td>';
			tds += '<td><input type="checkbox" id="esGral'+nuevaFila+'" name="lesGral" value="" onclick="realiza(this.id)"/></td>';
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarConvencionSeccional(this.id)"/>';
			tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarConvencionSeccional()"/></td>';
			tds += '</tr>';	   	   
			$("#miTabla").append(tds);
			var jqRenglon = eval("'#sucursalID" + nuevaFila + "'");
			$(jqRenglon).focus();
			return false;	
			
			
		}
	
	
	
		function consultaFilas(){
			var totales=0;
			$('tr[name=renglon]').each(function() {
				totales++;		
			});
			return totales;
		}

	function eliminarConvencionSeccional(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqSucursalID = eval("'#sucursalID" + numeroID + "'");		
		var jqNombreSucurs = eval("'#nombreSucurs" + numeroID + "'");
		var jqFecha=eval("'#fecha" + numeroID + "'");
		var jqCantSocio = eval("'#cantSocio" + numeroID + "'");
		var jqEsGral=eval("'#esGral" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqSucursalID).remove();
		$(jqNombreSucurs).remove();
		$(jqElimina).remove();
		$(jqFecha).remove();
		$(jqCantSocio).remove();
		$(jqEsGral).remove();
		$(jqAgrega).remove();
		$(jqRenglon).remove();
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglon"+numero+"'");
			var jqNumero1 = eval("'#consecutivoID"+numero+"'");
			var jqSucursalID1 = eval("'#sucursalID"+numero+"'");		
			var jqNombreSucurs1= eval("'#nombreSucurs"+numero+"'");
			var jqFecha1=eval("'#fecha"+ numero+"'");
			var jqCantSocio1=eval("'#cantSocio"+ numero+"'");
			var jqEsGral1=eval("'#esGral"+ numero+"'");
			var jqAgrega1=eval("'#agrega"+ numero+"'");
			var jqElimina1 = eval("'#"+numero+ "'");
		
			$(jqNumero1).attr('id','consecutivoID'+contador);
			$(jqSucursalID1).attr('id','sucursalID'+contador);
			$(jqNombreSucurs1).attr('id','nombreSucurs'+contador);
			$(jqFecha1).attr('id','fecha'+contador);
			$(jqCantSocio1).attr('id','cantSocio'+contador);
			$(jqEsGral1).attr('id','esGral'+contador);
			$(jqAgrega1).attr('id','agrega'+contador);
			$(jqElimina1).attr('id',contador);
			$(jqRenglon1).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
		
	}
//---------------------------------Funciones Grid de Movimientos-----------------
	function listaSucursales(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombreSucurs"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '4', camposLista, parametrosLista, 'listaSucursales.htm');
		});
	}


	function validaSurcursales(control) {
		var TipoConsulta = 2;
		var jq = eval("'#" + control + "'");
		var numSucursal = $(jq).val();
		var jqNombreSucurs = eval("'#nombreSucurs" + control.substr(10) + "'");
		var jqFecha = eval("'#fecha" + control.substr(10) + "'");
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(TipoConsulta,numSucursal,function(sucursal) {
					if(sucursal!=null){
						$(jqNombreSucurs).val(sucursal.nombreSucurs);
					}else{
						mensajeSis("El Número de sucursal no Existe");
						$(jq).val("");
						$(jqNombreSucurs).val("");
						$(jq).focus();
					}

				});
			}
		}
	
	
function realiza(control){

	var id= control.substr(6,control.length);
	var sucursalID = eval("'sucursalID" + id+ "'");
	
		if($('#'+control).attr('checked')==true){
			document.getElementById(control).value = 'S';
			validaSurcursalCorporativo(sucursalID);
		
		}else{
			document.getElementById(control).value = 'N';
	 }
			
	}

function validaCheck(){
	 var numCodigo = $('input[name=consecutivoID]').length;
	 
		for(var i = 1; i <= numCodigo; i++){
			
			if($('#'+"esGral"+i+"").attr('checked')==true){
				
					document.getElementById("esGral"+i+"").value = 'S';
					
					}else{
						$('#'+"esGral"+i+"").attr('checked','checked');
						document.getElementById("esGral"+i+"").value = 'N';
				 					
			}
		}
	}


function guardarFechas(){
	var mandar = verificarvacios();	
	if(mandar!=1){
		validaCheck();
		var numCodigo = $('input[name=consecutivoID]').length;
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodigo; i++){
			if(i == 1){
				$('#datosGrid').val($('#datosGrid').val() +
						document.getElementById("sucursalID"+i+"").value + ']' +
						document.getElementById("fecha"+i+"").value + ']' +
						document.getElementById("cantSocio"+i+"").value);
				return 1;
			}else{
				$('#datosGrid').val($('#datosGrid').val() + '[' +
						document.getElementById("sucursalID"+i+"").value + ']' +
						document.getElementById("fecha"+i+"").value + ']' +
						document.getElementById("cantSocio"+i+"").value);
				return 1;
			}
		}
	}
	else{
		 return 2;
	}
}

function verificarvacios(){
	quitaFormatoControles('datosGrid');
	var numCodig = $('input[name=consecutivoID]').length;
	
	$('#divConvencionesSeccionales').val("");
	for(var i = 1; i <= numCodig; i++){
		var idsu = document.getElementById("sucursalID"+i+"").value;
			if (idsu ==""){
				document.getElementById("sucursalID"+i+"").focus();
			$(idsu).addClass("error");
				return 1; 
			}
		var idfecha = document.getElementById("fecha"+i+"").value;
		if (idfecha ==""){
			document.getElementById("fecha"+i+"").focus();
			$(idfecha).addClass("error");
			return 1;
		}
		var idcs = document.getElementById("cantSocio"+i+"").value;
		if (idcs ==""){
			document.getElementById("cantSocio"+i+"").focus();
			$(idcs).addClass("error");
			return 1;
		}
	}
}


function onblurfecha(idControl,sucursalID) {
	var Xfecha= $('#'+idControl).val(); 
	var Yfecha=  parametroBean.fechaSucursal;
	if(esFechaValida(Xfecha)){
		if(Xfecha=='')$("#"+ idControl).val(parametroBean.fechaSucursal);

		if ( mayor(Xfecha, Yfecha) )
		{
			mensajeSis("La fecha capturada es menor a la de hoy");
			$("#"+ idControl).val(parametroBean.fechaSucursal);
			$("#"+ idControl).focus();
		}
		//verificaSucurFecha(idControl,sucursalID);
	}else{
		$("#"+ idControl).focus();
		
	}

}

function onblurCantSocio(idControl) {
	var cantSocio= $('#'+idControl).val(); 
	if(cantSocio == 0){
		mensajeSis("La cantidad debe ser mayor a 0");
		$("#"+ idControl).focus();
		}

}

function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}



//funcion para validar la fecha
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
		case 1: case 3:  case 5: case 7: case 8: case 10: case 12:	
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha Introducida es Errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha Introducida es Errónea");
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
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);



	if (xAnio < yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes < yMes){
				return true;
			}
			if (xMes == yMes){
				if (xDia < yDia){
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

// sucursal y fecha no sean iguales

/*function verificaSucurFecha(idfecha,idCampo){
	var contador = 0;
	var nuevaSucursal=$('#'+idCampo).val();
	var nuevaFecha=$('#'+idfecha).val();
	var id= idCampo.substr(10,idCampo.length);
	//var nombreSucurs = eval("'nombreSucurs" + id+ "'");
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdSucursal = eval("'sucursalID" + numero+ "'");		
		var jqNuevaFec = eval("'fecha" + numero+ "'");
		var valorSucursal = $('#'+jqIdSucursal).val();
		var valorFecha = $('#'+jqNuevaFec).val();
		
		if(jqIdSucursal != idCampo){
		
			if((valorSucursal == nuevaSucursal) && (valorFecha==nuevaFecha)){
				mensajeSis("El registro ya existe");
				$('#'+idfecha).focus();
				$('#'+idfecha).val("");
				//$('#'+nombreSucurs).val("");
			//	$('#'+idCampo).val("");
				contador = contador+1;
			}
		}
	});
	return contador;
}
*/


		function verificaRegistrados(){
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqIdSucursal = eval("'sucursalID" + numero+ "'");		
			var jqNuevaFec = eval("'fecha" + numero+ "'");
			var jqCantSocios = eval("'cantSocio" + numero+ "'");
			var jqNombreSucur = eval("'nombreSucurs" + numero+ "'");
			var valorSucursal = $('#'+jqIdSucursal).val();
			var valorFecha = $('#'+jqNuevaFec).val();
			
			var conLugarPre = 1;
			var lugarBeanCon = {
		 		 	'sucursalID' : valorSucursal,
		 		 	'fecha': valorFecha
			};
			if (valorSucursal != '' && !isNaN(valorSucursal)) {
				convenSecPreinsServicio.consulta(conLugarPre,lugarBeanCon,function(lugarPre){
					if (lugarPre != null) {
						if(lugarPre.cantPreins !=0){
							deshabilitaControl(jqIdSucursal);
							deshabilitaControl(jqNuevaFec);
							deshabilitaControl(jqCantSocios);
							deshabilitaControl(jqNombreSucur);
							
						}
						
					}
					
				});
			}
		});
	}
		
		function mandaRegistrados(){
			$('tr[name=renglon]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var jqIdSucursal = eval("'sucursalID" + numero+ "'");		
				var jqNuevaFec = eval("'fecha" + numero+ "'");
				var jqCantSocios = eval("'cantSocio" + numero+ "'");
				var jqNombreSucur = eval("'nombreSucurs" + numero+ "'");
					habilitaControl(jqIdSucursal);
					habilitaControl(jqNuevaFec);
					habilitaControl(jqCantSocios);
					habilitaControl(jqNombreSucur);
			
			});
		}
		

	function validaSurcursalCorporativo(control) {
	var TipoConsulta = 5;
	var jq = eval("'#" + control + "'");
	var numSucursal = $(jq).val();
	//var jqNombreSucurs = eval("'#nombreSucurs" + control.substr(10) + "'");
	//var jqFecha = eval("'#fecha" + control.substr(10) + "'");
	var jqCantSocio = eval("'#cantSocio" + control.substr(10) + "'");
	var jqesGral = eval("'#esGral" + control.substr(10) + "'");
	setTimeout("$('#cajaLista').hide();", 200);
	if(numSucursal != '' && !isNaN(numSucursal)){
		sucursalesServicio.consultaSucursal(TipoConsulta,numSucursal,function(sucursal) {
				if(sucursal==null){
					mensajeSis("No es Sucursal Corporativo");
					//$(jq).val("");
					//$(jqNombreSucurs).val("");
					//$(jqFecha).focus();
					$(jqCantSocio).focus();
					$(jqesGral).attr('checked',false);
					//$(jqesGral).focus();
					//$(jq).focus();
				}
			});
		}
	}


	function funcionExitoConvencionSeccional (){
		 $('#agregarConve').focus();
		 $('#divConvencionesSeccionales').hide();
		 consultaConvencionesSeccionales();
	}
	
	function funcionErrorConvencionSeccional (){
		$('#agregarConve').focus();
	}