$(document).ready(function() {

	esTab = true;
	$('#clienteID').focus();
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCteExt = { 
  		'agrega':'1',
  		'modifica':'2',
  		'elimina':'3'	};
	
	var catTipoConsultaCteExt = {
  		'principal'	:	1,
  		'foranea'	:	2
	};	

	var parametroBean = consultaParametrosSession();
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');

	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({
            submitHandler: function(event) {
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','exitoTransAdicional','falloTransAdicional');
            }
    });
	   			
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCteExt.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCteExt.modifica);
	});		
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '6', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	/*
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});
	*/
	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '21', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '6', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {
		consultaCliente(this.id);		
	});
	
	$('#fechaVencimiento').blur(function() {
		//$('#entidad').focus();
	});
	
	$('#fechaVencimiento').change(function() {
		var fechaVen= $('#fechaVencimiento').val();
		if(esFechaValida(fechaVen)){
			if(fechaVen=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			var fechaSis = parametroBean.fechaSucursal;
			if (mayor(fechaSis,fechaVen)){
				mensajeSis("La Fecha de Vencimiento es Menor a la Fecha del Sistema.");
				$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#paisID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('paisID', '1', '1', 'nombre', $('#paisID').val(), 'listaPaises.htm'); 
	});  	
   	
//	$('#paisID').blur(function() {
//  		consultaPais(this.id);
//	});

	$('#paisRFC').bind('keyup',function(e) { 
		lista('paisRFC', '1', '1', 'nombre', $('#paisRFC').val(),'listaPaises.htm');
	});

	$('#paisRFC').blur(function() {
		consultaPais(this.id,2);
	});
	
	$('#inmigrado').blur(function() {
	
		var inmi= $('#inmigrado').val(); 
		if(inmi == 'S'){
				$('#documentoLegal').val('FM2');
		}
		else{
		if(inmi == 'N')
			$('#documentoLegal').val('FM3');
		}
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			clienteID: {
				required: true
			},
			inmigrado: {
				required: true
			},
			documentoLegal: {
				required: true
			},	
			motivoEstancia: {
				required: true
			},	
			fechaVencimiento: {
				required: true,
				date : true
			},
			paisID: {
				required: true
			},	
			entidad: {
				required: true
			},	
			localidad: {
				required: true
			},
			colonia: {
			required: true
			},	
			calle: {
				required: true
			},	
			adi_CoPoEx: {
			maxlength: 6
			},
			paisRFC:{
				required: true
			},
		},
		messages: {
			clienteID: {
				required: 'Especifique el Nombre.',
				numeroPositivo: 'Solo números'
			},
			inmigrado: {
				required: 'Especifique Calidad de Inmigrado.'	
			},
			documentoLegal: {
				required: 'Especifique Doc. Legal.'	
			},	
			motivoEstancia: {
				required: 'Especifique Motivo de Estancia.'	
			},	
			fechaVencimiento: {
				required: 'Especifique Fecha de Vencimiento.',
				date : 'Fecha Incorrecta'
			},
			paisID: {
				required: 'Especifique País.'
				//numeroPositivo: 'Solo números'
			},	
			entidad: {
				required: 'Especifique Entidad.'	
			},	
			localidad: {
				required: 'Especifique Localidad.'	
			},
			colonia: {
				required: 'Especifique Colonia.'	
			},	
			calle: {
				required: 'Especifique Calle.'		
			},
			adi_CoPoEx: {
				maxlength: 'Máximo 6 Caracteres.'
			},
			paisRFC:{
				required: 'Especifique Pais para RFC.'
			},
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	//función para consultar el cliente y su pais de residencia
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		var tipoPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipoPrincipal,numCliente,function(cliente) {
				  if(cliente!=null){
					  if(cliente.nacion!='N'){
				  			 	$('#clienteID').val(cliente.numero)							
								$('#nombreCliente').val(cliente.nombreCompleto);
					  			$('#paisID').val(cliente.paisResidencia);
					  			$('#RFC').val(cliente.RFC);
					  			
					  			consultaPais('paisID',1);
					  			estatusCliente = cliente.estatus;
					  			validaAdCteExtrajero(idControl);	
					  		 
						 }else{
								mensajeSis("El Cliente No es Extranjero.");
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								limpiaPantallaExtrn();
						 }			
					}else{
						mensajeSis("No Existe el Cliente.");
						limpiaPantallaExtrn();	
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}	
			});	
		}
	}
	
	
	
	
	// función para validar si el cliente tiene registros
	function validaAdCteExtrajero(control) {
		var numCte = $('#clienteID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCte != '' && !isNaN(numCte) ){
				habilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				deshabilitaBoton('elimina', 'submit');
				var numCte =  $('#clienteID').val(); 
						
				var cteExtBeanCon = {
		  				'clienteID':numCte
						};
				cliExtranjeroServicio.consulta(catTipoConsultaCteExt.principal,cteExtBeanCon,function(cteExt) {
					if(cteExt!=null){
					//	dwr.util.setValues(cteExt);	
						$('#inmigrado').val(cteExt.inmigrado);		
						$('#documentoLegal').val(cteExt.documentoLegal);		
						$('#motivoEstancia').val(cteExt.motivoEstancia);			
						$('#fechaVencimiento').val(cteExt.fechaVencimiento);			
						$('#entidad').val(cteExt.entidad);			
						$('#localidad').val(cteExt.localidad);			
						$('#colonia').val(cteExt.colonia);		
						$('#calle').val(cteExt.calle);		
						$('#numeroCasa').val(cteExt.numeroCasa);		
						$('#numeroIntCasa').val(cteExt.numeroIntCasa);		
						$('#adi_CoPoEx').val(cteExt.adi_CoPoEx);
						$('#paisRFC').val(cteExt.paisRFC);
						consultaPais('paisRFC',2);
						
						 if (estatusCliente=='I'){
								deshabilitaBoton('agrega','submit');
								deshabilitaBoton('modifica','submit');
								mensajeSis("El Cliente se Encuentra Inactivo.");
								$('#clienteID').focus();
						  }else{
							  deshabilitaBoton('agrega', 'submit');
							  habilitaBoton('modifica', 'submit');
						  }
					}else{
						deshabilitaBoton('modifica', 'submit');
						habilitaBoton('agrega', 'submit');	
						limpiaPantallaExtrnP();
					}
				});
						
			}	
	}
		
		
	//función para limpiar todos los campos 
	function limpiaPantallaExtrn(){
		//$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#Nombpais').val('');
		$('#paisID').val('');
		$('#inmigrado').val('');
		$('#documentoLegal').val('');;
		$('#motivoEstancia').val('');
		$('#fechaVencimiento').val('');;
		$('#entidad').val('');
		$('#localidad').val('');
		$('#colonia').val('');
		$('#calle').val('');
		$('#numeroCasa').val('');
		$('#numeroIntCasa').val('');
		$('#adi_CoPoEx').val('');
		$('#RFC').val('');
		$('#paisRFC').val('');
		$('#NomPaisRFC').val('');
		$('#clienteID').focus();
		$('#clienteID').select();
	}

	//función para limpiar algunos campos
	function limpiaPantallaExtrnP(){
		$('#inmigrado').val('');
		$('#documentoLegal').val('');;
		$('#motivoEstancia').val('');
		$('#fechaVencimiento').val('');;
		$('#entidad').val('');
		$('#localidad').val('');
		$('#colonia').val('');
		$('#calle').val('');
		$('#numeroCasa').val('');
		$('#numeroIntCasa').val('');
		$('#adi_CoPoEx').val('');
		$('#paisRFC').val('');
		$('#NomPaisRFC').val('');
	}
		
		
	//función para consultar el nombre del país
	function consultaPais(idControl,origen) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();	
		var conPais=2; 
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numPais != '' && !isNaN(numPais) && esTab){
			paisesServicio.consultaPaises(conPais,numPais,function(pais) {
				if(pais!=null){		
					if (origen == 1) {
						$('#Nombpais').val(pais.nombre); 
					}else{
						$('#NomPaisRFC').val(pais.nombre); 
					}
					
				}else{
					mensajeSis("No Existe el País.");
					if (origen == 1) {
						$('#Nombpais').val('');
					}else{
						$('#NomPaisRFC').val('');
					}
					$(jqPais).val('');
					$(jqPais).focus();
				}    						
			});
		} else {
			if (origen == 1) {
				$('#Nombpais').val('');
			}else{
				$('#NomPaisRFC').val('');
			}
		}
		/*
			if(numPais != '' && isNaN(numPais) && esTab){
				mensajeSis("No Existe el País.");
				if (origen == 1) {
					$('#Nombpais').val('');
				}else{
					$('#NomPaisRFC').val('');
				}
				$(jqPais).val('');
				$(jqPais).focus();
			}	
			*/
	}
		
});

function exitoTransAdicional(){
	limpiaPantallaExtrn();
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}

function falloTransAdicional(){
	
}

function limpiaPantallaExtrn(){
		//$('#clienteID').val('');
		$('#nombreCliente').val('');
		$('#Nombpais').val('');
		$('#paisID').val('');
		$('#inmigrado').val('');
		$('#documentoLegal').val('');;
		$('#motivoEstancia').val('');
		$('#fechaVencimiento').val('');;
		$('#entidad').val('');
		$('#localidad').val('');
		$('#colonia').val('');
		$('#calle').val('');
		$('#numeroCasa').val('');
		$('#numeroIntCasa').val('');
		$('#adi_CoPoEx').val('');
		$('#RFC').val('');
		$('#paisRFC').val('');
		$('#NomPaisRFC').val('');
		$('#clienteID').focus();
		$('#clienteID').select();
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){
	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de fecha no válido (aaaa-mm-dd).");
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
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
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

function mayor(fecha, fecha2){
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
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